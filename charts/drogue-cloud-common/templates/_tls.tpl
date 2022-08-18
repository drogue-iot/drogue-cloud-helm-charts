{{/*
Volumes for using TLS.

Arguments (dict):
  * root - .
  * name - the base name of the application
  * app - application structure
*/}}
{{- define "drogue-cloud-common.tls-volumes" }}

{{- if and (not .app.service.insecure) .root.Values.global.drogueCloud.useServiceCA }}
- name: service-tls
  secret:
    secretName: {{ .name }}-tls
{{- end }}

{{- end }}

{{/*
Volumes for using TLS.

Arguments (dict):
  * root - .
  * name - the base name of the application
  * app - application structure
*/}}
{{- define "drogue-cloud-common.tls-service-annotations" }}
{{- if and ( not .app.service.insecure ) .root.Values.global.drogueCloud.useServiceCA -}}
service.beta.openshift.io/serving-cert-secret-name: {{ .name }}-tls
{{- end }}
{{- end }}

{{/*
Volume mounts for using TLS.

Arguments (dict):
  * root - .
  * app - application structure
*/}}
{{- define "drogue-cloud-common.tls-volume-mounts" }}

{{- if and (not .app.service.insecure) .root.Values.global.drogueCloud.useServiceCA }}
- mountPath: /etc/tls/service
  name: service-tls
{{- end }}

{{- end }}

