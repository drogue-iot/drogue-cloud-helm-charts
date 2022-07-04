{{/*
Volumes for using TLS.

Arguments (dict):
  * root - .
  * name - the base name of the application
  * app - application structure
*/}}
{{- define "drogue-cloud-core.tls-volumes" }}

{{- if and (not .app.service.insecure) .Values.global.drogueCloud.useServiceCA }}
- name: service-tls
  secret:
    secretName: {{ .name | quote }}
{{- end }}

{{- end }}

{{/*
Volume mounts for using TLS.

Arguments (dict):
  * root - .
  * name - the base name of the application
  * app - application structure
*/}}
{{- define "drogue-cloud-core.tls-volumes" }}

{{- if and (not .app.service.insecure) .Values.global.drogueCloud.useServiceCA }}
- mountPath: /etc/tls/service
  name: {{ .name | quote }}
{{- end }}

{{- end }}

