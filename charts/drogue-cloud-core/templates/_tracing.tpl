{{/*
Jaeger tracing annotations.

Arguments: (root)
*/}}
{{- define "drogue-cloud-core.tracing-annotations" -}}
{{- if eq (include "drogue-cloud-core.tracing-enabled" . ) "true" }}
"sidecar.jaegertracing.io/inject": "true"
{{- end }}
{{- end }}

{{- define "drogue-cloud-core.tracing-enabled" -}}
{{ .Values.global.drogueCloud.jaeger.enabled }}
{{- end }}
