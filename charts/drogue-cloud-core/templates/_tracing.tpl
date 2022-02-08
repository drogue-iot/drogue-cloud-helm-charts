{{/*
Jaeger tracing annotations.

Arguments: (root)
*/}}
{{- define "drogue-cloud-core.jaeger-annotations" -}}
{{- if eq (include "drogue-cloud-core.jaeger-enabled" . ) "true" }}
"sidecar.jaegertracing.io/inject": "true"
{{- end }}
{{- end }}

{{- define "drogue-cloud-core.jaeger-enabled" -}}
{{ .Values.global.drogueCloud.jaeger.enabled }}
{{- end }}
