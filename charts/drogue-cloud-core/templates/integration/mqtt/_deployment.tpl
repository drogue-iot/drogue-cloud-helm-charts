{{- define "drogue-cloud-core.deployment.mqtt-integration" -}}
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
  replicas: {{ .app.deployment.replicas | default 1 }}
  selector:
    matchLabels:
      {{- include "drogue-cloud-common.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "drogue-cloud-core.labels" . | nindent 8 }}
      annotations:
        {{- include "drogue-cloud-common.prometheus-annotations" . | nindent 8 }}

    spec:
      containers:
        - name: service
          image: {{ include "drogue-cloud-common.image" (dict "root" .root "name" "mqtt-integration" ) | quote }}
          imagePullPolicy: {{ include "drogue-cloud-common.image-pull-policy" .root }}
          env:
            {{- include "drogue-cloud-common.rust.logging" ( dict "root" .root "app" .app ) | nindent 12 }}
            {{- include "drogue-cloud-common.jaeger-env" ( dict "root" .root "app" .app ) | nindent 12 }}
            {{- include "drogue-cloud-common.health-env" ( dict "root" .root "app" .app ) | nindent 12 }}
            - name: MQTT__BIND_ADDR
              value: "0.0.0.0:1883"
            - name: MQTT__TRANSPORT
              value: {{ .transport | quote }}
            - name: INSTANCE
              valueFrom:
                configMapKeyRef:
                  name: configuration
                  key: instance
            - name: NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
            {{- include "drogue-cloud-core.oauth2-authenticator.env-vars" (dict "root" .root "clients" (list "drogue" )) | nindent 12 }}
            - name: USER_AUTH__URL
              value: {{ include "drogue-cloud-core.service-url.user-auth-service" .root }}
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
            {{- include "drogue-cloud-core.oauth2-internal.env-vars" (dict "root" .root "prefix" "USER_AUTH__" ) | nindent 12 }}
            - name: REGISTRY__URL
              value: {{ include "drogue-cloud-core.service-url.device-management-service" .root }}
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
            {{- include "drogue-cloud-core.oauth2-internal.env-vars" (dict "root" .root "prefix" "REGISTRY__" ) | nindent 12 }}
            - name: SERVICE__KAFKA__BOOTSTRAP_SERVERS
              value: {{ include "drogue-cloud-common.kafka-bootstrap-server" .root -}}
            {{- include "drogue-cloud-common.kafka-properties" (dict "root" .root "prefix" "SERVICE__KAFKA__PROPERTIES__" ) | nindent 12 }}
            - name: COMMAND_KAFKA_SINK__TOPIC
              value: iot-commands
            - name: COMMAND_KAFKA_SINK__BOOTSTRAP_SERVERS
              value: {{ include "drogue-cloud-common.kafka-bootstrap-server" .root -}}
            {{- include "drogue-cloud-common.kafka-properties" (dict "root" .root "prefix" "COMMAND_KAFKA_SINK__PROPERTIES__" ) | nindent 12 }}
            {{- include "drogue-cloud-core.env-vars-extras" ( dict "root" .root "app" .app ) | nindent 12 }}

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
              name: service
              protocol: TCP
            {{- include "drogue-cloud-common.health-container-port" . | nindent 12 }}

          {{- include "drogue-cloud-core.container-resources" ( dict "root" .root "app" .app ) | nindent 10 }}

          {{- include "drogue-cloud-common.health-probes" ( dict "root" .root "app" .app ) | nindent 10 }}

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