{{/*
The type of the topic operator, including defaults.
*/}}
{{- define "drogue-cloud-core.topic-operator.type" -}}

{{- with .Values.services.registry.topicOperator.type }}
    {{- . -}}
{{ else -}}
    {{- if .Values.kafka.external.enabled -}}
        admin
    {{- else -}}
        strimzi
    {{- end }}
{{- end }}

{{- end }}
