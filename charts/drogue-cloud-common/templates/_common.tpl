{{/*
Add extra env-vars.

Arguments: (dict)
  * root -
  * app - application configuration

*/}}
{{- define "drogue-cloud-common.env-vars-extras" }}
{{- with .root.Values.defaults.extraEnvironment }}{{ . | toYaml }}{{- end }}
{{- with .app.extraEnvironment }}{{ . | toYaml }}{{- end }}
{{- end }}

{{/*
Pod security context.

Arguments: (dict)
  * root -
  * app - application configuration

*/}}
{{- define "drogue-cloud-common.pod-security-context" }}
{{- if .app.podSecurityContext }}
securityContext:
  {{- .app.podSecurityContext | toYaml | nindent 2 }}
{{- else if .root.Values.global.drogueCloud.defaults.podSecurityContext }}
securityContext:
  {{- .root.Values.global.drogueCloud.defaults.podSecurityContext | toYaml | nindent 2 }}
{{- else }}
{{- end }}
{{- end }}

{{/*
Container security context.

Arguments: (dict)
  * root -
  * app - application configuration

*/}}
{{- define "drogue-cloud-common.container-security-context" }}
{{- if .app.containerSecurityContext }}
securityContext:
  {{ .app.containerSecurityContext | toYaml | nindent 2 }}
{{- else if .root.Values.global.drogueCloud.defaults.containerSecurityContext }}
securityContext:
  {{ .root.Values.global.drogueCloud.defaults.containerSecurityContext | toYaml | nindent 2 }}
{{- else }}
{{- end }}
{{- end }}
