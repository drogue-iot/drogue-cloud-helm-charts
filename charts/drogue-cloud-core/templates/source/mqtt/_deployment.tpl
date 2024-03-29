{{- define "drogue-cloud-core.deployment.mqtt-endpoint" -}}
kind: Deployment
apiVersion: apps/v1
metadata:
  name: {{ .name | quote }}
  annotations:
    {{- include "drogue-cloud-common.jaeger-annotations" .root | nindent 4 }}
  labels:
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
        checksum/clients: {{ include (print .root.Template.BasePath "/infrastructure/sso/clients.yaml") .root | sha256sum }}

    spec:

      {{- include "drogue-cloud-common.pod-security-context" ( dict "root" .root "app" .app ) | nindent 6 }}

      containers:
        - name: endpoint
          image: {{ include "drogue-cloud-common.image" (dict "root" .root "name" "mqtt-endpoint" ) | quote }}
          imagePullPolicy: {{ include "drogue-cloud-common.image-pull-policy" .root }}

          {{- include "drogue-cloud-common.container-security-context" ( dict "root" .root "app" .app ) | nindent 10 }}

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
            {{- include "drogue-cloud-common.oauth2-internal.env-vars" (dict "root" .root "prefix" "STATE__CLIENT__" ) | nindent 12 }}
            - name: AUTH__URL
              value: {{ include "drogue-cloud-core.service-url.auth-service" .root }}
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
            {{- include "drogue-cloud-common.oauth2-internal.env-vars" (dict "root" .root "prefix" "AUTH__" ) | nindent 12 }}
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

            {{- include "drogue-cloud-common.env-vars-extras" ( dict "root" .root "app" .app ) | nindent 12 }}

          ports:
            - containerPort: 1883
              name: endpoint
              protocol: TCP
            {{- include "drogue-cloud-common.health-container-port" . | nindent 12 }}

          {{- include "drogue-cloud-common.health-probes" ( dict "root" .root "app" .app ) | nindent 10 }}
          {{- include "drogue-cloud-common.container-resources" ( dict "root" .root "app" .app ) | nindent 10 }}

          volumeMounts:
          {{- if not .app.ingress.insecure }}
            - mountPath: /etc/endpoint
              name: endpoint-tls
          {{- end }}

      volumes:

        {{- if not .app.ingress.insecure }}
        - name: endpoint-tls
          secret:
            secretName: {{ ((.app.service).certificates).secret | default "mqtt-endpoint-tls" | quote }}
        {{- end }}

        - name: client-secret-services
          secret:
            secretName: keycloak-client-secret-services

{{- end -}}
