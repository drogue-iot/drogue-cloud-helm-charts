{{/*
Jaeger tracing annotations.

Arguments: (root)
*/}}
{{- define "drogue-cloud-twin.jaeger-annotations" -}}
{{- if eq (include "drogue-cloud-twin.jaeger-enabled" . ) "true" }}
"sidecar.jaegertracing.io/inject": "true"
{{- end }}
{{- end }}

{{- define "drogue-cloud-twin.jaeger-enabled" -}}
{{ .Values.global.drogueCloud.jaeger.enabled }}
{{- end }}
