{{/*
Kafka bootstrap server
*/}}
{{- define "drogue-cloud-common.kafka-bootstrap-server" -}}

    {{- if .Values.kafka.external.enabled -}}
        {{- .Values.kafka.external.bootstrapServers -}}
    {{- else -}}
        drogue-iot-kafka-bootstrap.{{ .Release.Namespace }}.svc.cluster.local.:9092
    {{- end }}

{{- end }}

{{/*
Kafka connection properties
*/}}
{{- define "drogue-cloud-common.kafka-properties" -}}

{{- if .root.Values.kafka.external.enabled -}}

{{- if .root.Values.kafka.external.tls.enabled -}}
- name: {{ .prefix }}SECURITY_PROTOCOL
  value: {{ if .root.Values.kafka.external.sasl.enabled -}}sasl_ssl{{- else -}}ssl{{- end }}
{{- end }}

{{- if .root.Values.kafka.external.properties -}}
{{- range $key, $value := .root.Values.kafka.external.properties }}
- name: {{ .prefix }}{{ $key | upper | replace "." "_" }}
  value: {{ $value | quote }}
{{- end }}
{{- end -}}

{{- if .root.Values.kafka.external.sasl.enabled }}
- name: {{ .prefix }}SASL_MECHANISMS
  value: {{ .root.Values.kafka.external.sasl.mechanism }}
- name: {{ .prefix }}SASL_USERNAME
  value: {{ .root.Values.kafka.external.sasl.username | quote }}
- name: {{ .prefix }}SASL_PASSWORD
  value: {{ .root.Values.kafka.external.sasl.password | quote }}
{{- end }}{{/* if kafka.external.sasl.enabled */}}

{{- else -}}{{/* if kafka.external.enabled */}}

- name: {{ .prefix }}SECURITY_PROTOCOL
  value: sasl_plaintext
- name: {{ .prefix }}SASL_MECHANISMS
  value: SCRAM-SHA-512
- name: {{ .prefix }}SASL_USERNAME
  value: drogue-iot
- name: {{ .prefix }}SASL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: drogue-iot
      key: password

{{- end }}{{/* if kafka.external.enabled */}}

{{- end }}


{{/*
Kafka .spec.net configuration for Knative KafkaSource:
Args (dict):
  * root - .
  * secretName - the name of the secret to use, align with the call to "drogue-cloud-common.knative-kafka-net-secret-data"
*/}}
{{- define "drogue-cloud-common.knative-kafka-net" -}}

{{- if .root.Values.kafka.external.enabled }}
  net:

  {{- if .root.Values.kafka.external.tls.enabled }}
    tls:
      enable: true
  {{- end }}{{/* external.tls.enabled */}}

  {{- if .root.Values.kafka.external.sasl.enabled }}
    sasl:
      enable: true
      type:
        secretKeyRef:
            name: {{ .secretName }}
            key: mechanism
      user:
        secretKeyRef:
            name: {{ .secretName }}
            key: username
      password:
        secretKeyRef:
            name: {{ .secretName }}
            key: password

  {{- end }}{{/* external.sasl.enabled */}}

{{- else }}{{/* external.enabled */}}

  net:
    sasl:
      enable: true
      type:
        secretKeyRef:
            name: {{ .secretName }}
            key: mechanism
      user:
        secretKeyRef:
            name: {{ .secretName }}
            key: username
      password:
        secretKeyRef:
            name: drogue-iot
            key: password

{{- end }}{{/* external.enabled */}}
{{- end }}

{{/*
Secret for the Kafka .spec.net configuration for Knative KafkaSource:
Args (dict):
  * root - .
  * name - the name of the topic resource (might not be the topic name itself)
*/}}
{{- define "drogue-cloud-common.knative-kafka-net-secret-data" -}}

{{- if .Values.kafka.external.enabled }}

{{- if .Values.kafka.external.sasl.enabled }}
mechanism: {{ .Values.kafka.external.sasl.mechanism | b64enc }}
username: {{ .Values.kafka.external.sasl.username | b64enc }}
password: {{ .Values.kafka.external.sasl.password | b64enc }}
{{- end }}

{{- else -}}{{/* external.enabled */}}

mechanism: {{ "SCRAM-SHA-512" | b64enc }}
username: {{ "drogue-iot" | b64enc }}

{{- end }}{{/* external.enabled */}}

{{- end }}
