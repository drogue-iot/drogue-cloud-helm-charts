{{/*
CORS env-var settings.

Arguments: (dict)
  root - the root (.)
  app - the application level configuration

*/}}
{{- define "drogue-cloud-core.cors.env-vars" -}}

{{- with .app.cors }} {{/* with cors section */}}

- name: HTTP__CORS__MODE
  value: {{ .mode | quote }}

{{- if eq .mode "custom" }}
{{- with .allowOriginUrl }}
- name: HTTP__CORS__ALLOW_ORIGIN_URL
  value: {{ . | quote }}
{{- else }}
- name: HTTP__CORS__ALLOW_ORIGIN_URL
  value: {{- include "drogue-cloud-common.ingress.url" (dict "root" . "prefix" "api" "ingress" .Values.services.api.ingress ) -}}/*
{{- end }}
{{- end }}

{{- else }} {{/* no cors section */}}
{{/* leave empty, other provide through custom env-vars, are leave it to the application*/}}
{{- end }}

{{- end }}
