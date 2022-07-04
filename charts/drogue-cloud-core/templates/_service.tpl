{{/*
Render an internal service URL.

Arguments (dict):
  * root - .
  * name - name of the (target) service
  * app - app section of the service (of the target service)
*/}}
{{- define "drogue-cloud-core.service-url" }}
{{- if .app.service.insecure }}
http://{{ .name }}.{{ .root.Release.Namespace }}.svc
{{- else }}
https://{{ .name }}.{{ .root.Release.Namespace }}.svc
{{- end }}
{{- end }}

{{/* The following macros are there to avoid repetition in other files */}}

{{- define "drogue-cloud-core.service-url.device-state-service" }}
{{- include "drogue-cloud-core.service-url" (dict "root" . "name" "device-state-service" "app" .Values.services.deviceState ) }}
{{- end }}