{{/*
Jaeger tracing annotations.

Arguments: (root)
*/}}
{{- define "drogue-cloud-core.jaeger-annotations" -}}
{{- if eq (include "drogue-cloud-core.jaeger-enabled" . ) "true" }}
"sidecar.jaegertracing.io/inject": "true"
{{- end }}
{{- end }}

{{/*
Add jaeger tracing env-vars.

Arguments: (dict)
  root - the root (.)
  app - the application level configuration
*/}}
{{- define "drogue-cloud-core.jaeger-env" -}}
{{- if eq (include "drogue-cloud-core.jaeger-enabled" .root ) "true" }}
- name: ENABLE_TRACING
  value: "true"
- name: OTEL_BSP_MAX_EXPORT_BATCH_SIZE
  value: {{ .root.Values.global.drogueCloud.jaeger.exportBatchSize | default 32 | quote }}
{{- end }}
{{- end }}

{{/*
Check if jaeger tracing is enabled

Arguments: (root)
*/}}
{{- define "drogue-cloud-core.jaeger-enabled" -}}
{{ .Values.global.drogueCloud.jaeger.enabled }}
{{- end }}
