{{- define "drogue-cloud-core.deployment.mqtt-integration" -}}
kind: Deployment
apiVersion: apps/v1
metadata:
  name: {{ .name | quote }}
  labels:
    {{- include "drogue-cloud-core.labels" . | nindent 4 }}
spec:
  replicas: 1
  selector:
    matchLabels:
      {{- include "drogue-cloud-common.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "drogue-cloud-core.labels" . | nindent 8 }}
    spec:
      initContainers:
        {{- include "drogue-cloud-common.init-container.wait-for-client-secret" ( dict "root" .root "volume" "client-secret-services")  | nindent 8 }}
      containers:
        - name: service
          image: {{ include "drogue-cloud-core.image" (dict "root" .root "name" "mqtt-integration" ) | quote }}
          imagePullPolicy: {{ include "drogue-cloud-core.image-pull-policy" .root }}
          env:
            {{- include "drogue-cloud-core.rust.logging" ( dict "root" .root "app" .app ) | nindent 12 }}
            - name: MQTT__BIND_ADDR
              value: "0.0.0.0:1883"
            - name: MQTT__TRANSPORT
              value: {{ .transport | quote }}
            - name: HEALTH__BIND_ADDR
              value: "0.0.0.0:9090"
            - name: INSTANCE
              valueFrom:
                configMapKeyRef:
                  name: configuration
                  key: instance
            - name: SSO_URL
              value: {{ include "drogue-cloud-common.ingress.url" (dict "root" .root "prefix" "sso" "ingress" .root.Values.services.sso.ingress ) }}
            - name: OAUTH__SSO_URL
              value: $(SSO_URL)
            - name: OAUTH__CLIENTS__DROGUE__CLIENT_ID
              valueFrom:
                secretKeyRef:
                  name: keycloak-client-secret-drogue
                  key: CLIENT_ID
            - name: OAUTH__CLIENTS__DROGUE__CLIENT_SECRET
              valueFrom:
                secretKeyRef:
                  name: keycloak-client-secret-drogue
                  key: CLIENT_SECRET
                  optional: true
            - name: NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
            - name: USER_AUTH__CLIENT_ID
              valueFrom:
                secretKeyRef:
                  name: keycloak-client-secret-services
                  key: CLIENT_ID
            - name: USER_AUTH__CLIENT_SECRET
              valueFrom:
                secretKeyRef:
                  name: keycloak-client-secret-services
                  key: CLIENT_SECRET
            - name: USER_AUTH__SSO_URL
              value: $(SSO_URL)
            - name: REGISTRY__CLIENT_ID
              valueFrom:
                secretKeyRef:
                  name: keycloak-client-secret-services
                  key: CLIENT_ID
            - name: REGISTRY__CLIENT_SECRET
              valueFrom:
                secretKeyRef:
                  name: keycloak-client-secret-services
                  key: CLIENT_SECRET
            - name: REGISTRY__SSO_URL
              value: $(SSO_URL)
            - name: SERVICE__KAFKA__BOOTSTRAP_SERVERS
              value: {{ include "drogue-cloud-common.kafka-bootstrap-server" .root -}}
            {{- include "drogue-cloud-common.kafka-properties" (dict "root" .root "prefix" "SERVICE__KAFKA__PROPERTIES__" ) | nindent 12 }}
            - name: COMMAND_KAFKA_SINK__TOPIC
              value: iot-commands
            - name: COMMAND_KAFKA_SINK__BOOTSTRAP_SERVERS
              value: {{ include "drogue-cloud-common.kafka-bootstrap-server" .root -}}
            {{- include "drogue-cloud-common.kafka-properties" (dict "root" .root "prefix" "COMMAND_KAFKA_SINK__PROPERTIES__" ) | nindent 12 }}

            {{ if .disableClientCertificates }}
            - name: DISABLE_CLIENT_CERTIFICATES
              value: "true"
            {{ end }}
            {{ if .insecure }}
            - name: DISABLE_TLS
              value: "true"
            {{ else }}
            - name: CERT_BUNDLE_FILE # TLS
              value: /etc/endpoint/tls.crt
            - name: KEY_FILE # TLS
              value: /etc/endpoint/tls.key
            {{ end }}

          ports:
            - containerPort: 1883
              name: service
              protocol: TCP

          resources:
            limits:
              memory: 64Mi

          readinessProbe:
            initialDelaySeconds: 2
            periodSeconds: 1
            timeoutSeconds: 1
            failureThreshold: 3
            httpGet:
              port: 9090
              path: /readiness
          livenessProbe:
            initialDelaySeconds: 2
            periodSeconds: 1
            timeoutSeconds: 1
            failureThreshold: 3
            httpGet:
              port: 9090
              path: /liveness

          {{- if not .insecure }}
          volumeMounts:
            - mountPath: /etc/endpoint
              name: endpoint-tls
          {{- end }}

      volumes:

        {{- if not .insecure }}
        - name: endpoint-tls
          secret:
            secretName: mqtt-endpoint-tls
        {{- end }}

        - name: client-secret-services
          secret:
            secretName: keycloak-client-secret-services

{{- end -}}