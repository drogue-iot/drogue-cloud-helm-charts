{{/*
Add ditto service spec:

Arguments (dict):
  root - the root context
  service - the service configuration
*/}}
{{- define "drogue-cloud-twin._ditto-service-spec" -}}
replicas: {{ .service.replicas | default 1 }}
logLevel: {{ .service.logLevel | default .root.Values.ditto.logLevel | default "info" | quote }}
{{- if .service.resources }}
resources:
  {{- .service.resources | toYaml | nindent 2 }}
{{- end }}

{{- end }}
