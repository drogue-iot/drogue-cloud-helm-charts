

{{/*
Container resource limits.

Arguments: (dict)
 * root - .
 * app - The application configuration
*/}}
{{- define "drogue-cloud-core.container-resources" -}}

{{- if .app.resources }}
resources:
  {{- .app.resources | toYaml | nindent 2 }}
{{ else if .root.Values.defaults.resources }}
resources:
  {{- .root.Values.defaults.resources | toYaml | nindent 2 }}
{{- end }}

{{- end }}