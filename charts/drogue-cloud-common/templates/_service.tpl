{{/*
Render an internal service URL.

Arguments (dict):
  * root - .
  * name - name of the (target) service
  * app - app section of the service (of the target service)
*/}}
{{- define "drogue-cloud-common.service-url" }}
{{- if .app.service.insecure -}}
http://{{ .name }}.{{ .root.Release.Namespace }}.svc
{{- else -}}
https://{{ .name }}.{{ .root.Release.Namespace }}.svc
{{- end }}
{{- end }}
