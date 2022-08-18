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
