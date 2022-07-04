{{- define "drogue-cloud-core.deployment.mqtt-endpoint" -}}
kind: Deployment
apiVersion: apps/v1
metadata:
  name: {{ .name | quote }}
  annotations:
    {{- include "drogue-cloud-common.jaeger-annotations" .root | nindent 4 }}
  labels:
    client.oauth2.drogue.io/services: ""
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
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/path: /metrics
        prometheus.io/port: "9090"
    spec:
      initContainers:
        {{- include "drogue-cloud-common.init-container.wait-for-client-secret" ( dict "root" .root "volume" "client-secret-services")  | nindent 8 }}
      containers:
        - name: endpoint
          image: {{ include "drogue-cloud-common.image" (dict "root" .root "name" "mqtt-endpoint" ) | quote }}
          imagePullPolicy: {{ include "drogue-cloud-common.image-pull-policy" .root }}
          env:
            {{- include "drogue-cloud-common.rust.logging" ( dict "root" .root "app" .app ) | nindent 12 }}
            {{- include "drogue-cloud-common.jaeger-env" ( dict "root" .root "app" .app ) | nindent 12 }}
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
            - name: STATE__ENDPOINT
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: STATE__CLIENT__URL
              value: {{ include "drogue-cloud-core.service-url.device-state-service" .root }}
            - name: STATE__CLIENT__CLIENT_ID
              valueFrom:
                secretKeyRef:
                  name: keycloak-client-secret-services
                  key: CLIENT_ID
            - name: STATE__CLIENT__CLIENT_SECRET
              valueFrom:
                secretKeyRef:
                  name: keycloak-client-secret-services
                  key: CLIENT_SECRET
            {{- include "drogue-cloud-core.oauth2-internal.env-vars" (dict "root" .root "prefix" "STATE__CLIENT__" ) | nindent 12 }}
            - name: AUTH__CLIENT_ID
              valueFrom:
                secretKeyRef:
                  name: keycloak-client-secret-services
                  key: CLIENT_ID
            - name: AUTH__CLIENT_SECRET
              valueFrom:
                secretKeyRef:
                  name: keycloak-client-secret-services
                  key: CLIENT_SECRET
            {{- include "drogue-cloud-core.oauth2-internal.env-vars" (dict "root" .root "prefix" "AUTH__" ) | nindent 12 }}
            - name: COMMAND_SOURCE_KAFKA__TOPIC
              value: iot-commands
            - name: COMMAND_SOURCE_KAFKA__CONSUMER_GROUP
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: KAFKA_COMMAND_CONFIG__BOOTSTRAP_SERVERS
              value: {{ include "drogue-cloud-common.kafka-bootstrap-server" .root }}
            {{- include "drogue-cloud-common.kafka-properties" (dict "root" .root "prefix" "KAFKA_COMMAND_CONFIG__PROPERTIES__" ) | nindent 12 }}
            - name: KAFKA_DOWNSTREAM_CONFIG__BOOTSTRAP_SERVERS
              value: {{ include "drogue-cloud-common.kafka-bootstrap-server" .root }}
            {{- include "drogue-cloud-common.kafka-properties" (dict "root" .root "prefix" "KAFKA_DOWNSTREAM_CONFIG__PROPERTIES__" ) | nindent 12 }}

            {{ if .disableClientCertificates }}
            - name: DISABLE_CLIENT_CERTIFICATES
              value: "true"
            {{ end }}
            {{ if .app.ingress.insecure }}
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
              name: endpoint
              protocol: TCP
            {{- include "drogue-cloud-core.health-container-port" . | nindent 12 }}

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

          {{- include "drogue-cloud-core.container-resources" ( dict "root" .root "app" .app ) | nindent 10 }}

          volumeMounts:
          {{- if not .app.ingress.insecure }}
            - mountPath: /etc/endpoint
              name: endpoint-tls
          {{- end }}

      volumes:

        {{- if not .app.ingress.insecure }}
        - name: endpoint-tls
          secret:
            secretName: mqtt-endpoint-tls
        {{- end }}

        - name: client-secret-services
          secret:
            secretName: keycloak-client-secret-services

{{- end -}}