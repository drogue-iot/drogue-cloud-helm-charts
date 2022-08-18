{{/*
Kafka bootstrap server
*/}}
{{- define "drogue-cloud-common.kafka-bootstrap-server" -}}

    {{- if .Values.kafka.external.enabled -}}
        {{- .Values.kafka.external.bootstrapServer | quote -}}
    {{- else -}}
        {{ .Values.kafka.clusterResourceName }}-kafka-bootstrap.{{ .Release.Namespace }}.svc.cluster.local.:9092
    {{- end }}

{{- end }}

{{/*
Encodes Kafka properties from "foo.bar.baz" to "FOO_BAR_BAZ"
Arguments (dict):
  * properties(dict) - the properties to encode
  * prefix(string) - the value to prefix all env-var names with
*/}}
{{- define "drogue-cloud-common.translate-kafka-properties" -}}
{{- if .properties -}}
{{- range $key, $value := .properties }}
- name: {{ .prefix }}{{ $key | upper | replace "." "_" }}
  value: {{ $value | quote }}
{{- end }}
{{- end -}}
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

{{- include "drogue-cloud-common.translate-kafka-properties" ( dict "prefix" .prefix "properties" .root.Values.kafka.external.properties ) -}}

{{- if .root.Values.kafka.external.sasl.enabled }}
- name: {{ .prefix }}SASL_MECHANISM
  value: {{ .root.Values.kafka.external.sasl.mechanism }}
- name: {{ .prefix }}SASL_USERNAME
  value: {{ .root.Values.kafka.external.sasl.username | quote }}
- name: {{ .prefix }}SASL_PASSWORD
  value: {{ .root.Values.kafka.external.sasl.password | quote }}
{{- end }}{{/* if kafka.external.sasl.enabled */}}

{{- else -}}{{/* if kafka.external.enabled */}}

- name: {{ .prefix }}SECURITY_PROTOCOL
  value: sasl_plaintext
- name: {{ .prefix }}SASL_MECHANISM
  value: SCRAM-SHA-512
- name: {{ .prefix }}SASL_USERNAME
  value: {{ .root.Values.kafka.internalUserName }}
- name: {{ .prefix }}SASL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .root.Values.kafka.internalUserName }}
      key: password

{{- end }}{{/* if kafka.external.enabled */}}

{{- end }}


{{/*
Kafka .spec.net configuration for Knative KafkaSource:
Args (dict):
  * root - .
  * secretName - the name of the secret to use, align with the call to "drogue-cloud-common.knative-kafka-net-secret-data"
  * userName - optional default name of the kafka user/user resource which is used internally
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
            name: {{ .userName | default "drogue-iot" | quote }}
            key: password

{{- end }}{{/* external.enabled */}}
{{- end }}

{{/*
Secret for the Kafka .spec.net configuration for Knative KafkaSource:
Args (dict):
  * root - .
  * userName - The name of the Kafka user resource and user
*/}}
{{- define "drogue-cloud-common.knative-kafka-net-secret-data" -}}

{{- if .root.Values.kafka.external.enabled }}

{{- if .root.Values.kafka.external.sasl.enabled }}
mechanism: {{ .root.Values.kafka.external.sasl.mechanism | b64enc }}
username: {{ .root.Values.kafka.external.sasl.username | b64enc }}
password: {{ .root.Values.kafka.external.sasl.password | b64enc }}
{{- end }}

{{- else -}}{{/* external.enabled */}}

mechanism: {{ "SCRAM-SHA-512" | b64enc }}
username: {{ .userName | default "drogue-iot" | b64enc }}

{{- end }}{{/* external.enabled */}}

{{- end }}

{{/*
Event topic:
Args (dict):
  * application - The application configuration
*/}}
{{- define "drogue-cloud-common.kafka-event-topic" -}}
{{- with .application.eventTopic -}}
{{- . -}}
{{- else -}}
events-{{- .application.name -}}
{{- end -}}
{{- end }}
