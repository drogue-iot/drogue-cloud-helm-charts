{{/*
Jaeger tracing annotations.

Arguments: (root)
*/}}
{{- define "drogue-cloud-common.jaeger-annotations" -}}
{{- if eq (include "drogue-cloud-common.jaeger-enabled" . ) "true" }}
"sidecar.jaegertracing.io/inject": "true"
{{- end }}
{{- end }}

{{/*
Add jaeger tracing env-vars.

Arguments: (dict)
  root - the root (.)
  app - the application level configuration
*/}}
{{- define "drogue-cloud-common.jaeger-env" -}}
{{- if eq (include "drogue-cloud-common.jaeger-enabled" .root ) "true" }}
- name: RUNTIME__TRACING
  value: "jaeger"
- name: OTEL_BSP_MAX_EXPORT_BATCH_SIZE
  value: {{ .root.Values.global.drogueCloud.jaeger.exportBatchSize | default 32 | quote }}
- name: OTEL_TRACES_SAMPLER
  value: {{ .root.Values.global.drogueCloud.jaeger.sampler | default "parentbased_traceidratio" | quote }}
- name: OTEL_TRACES_SAMPLER_ARG
  value: {{ .root.Values.global.drogueCloud.jaeger.samplerArgument | default "0.1" | quote }}
{{- end }}
{{- end }}

{{/*
Check if jaeger tracing is enabled

Arguments: (root)
*/}}
{{- define "drogue-cloud-common.jaeger-enabled" -}}
{{ .Values.global.drogueCloud.jaeger.enabled }}
{{- end }}
