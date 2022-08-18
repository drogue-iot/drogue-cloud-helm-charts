{{/*
Define the HTTP service env-vars.

Arguments (dict):
  * root - .
  * app - application structure
  * skipServiceCa - skip using the service CA, even if it is available
*/}}
{{- define "drogue-cloud-common.http-service-env" }}

- name: HTTP__BIND_ADDR
  value: "0.0.0.0:{{ include "drogue-cloud-common.http-bind-port" . }}"

{{- if .app.service.insecure }}
- name: HTTP__DISABLE_TLS
  value: "true"
{{- else }}
- name: HTTP__CERT_BUNDLE_FILE
  value: /etc/tls/service/tls.crt
- name: HTTP__KEY_FILE
  value: /etc/tls/service/tls.key
{{- end }}{{/* if .app.insecure */}}

{{- end }}

{{/*
The bind port of an HTTP based service

Arguments (dict):
  * root - .
  * app - application structure
*/}}
{{- define "drogue-cloud-common.http-bind-port" }}
{{- if .app.service.insecure }}8080{{- else -}}8443{{- end }}
{{- end }}

{{/*
The service port of an HTTP based service

Arguments (dict):
  * root - .
  * app - application structure
*/}}
{{- define "drogue-cloud-common.http-service-port" }}
{{- if .app.service.insecure }}80{{- else -}}443{{- end }}
{{- end }}

{{/*
The container port entry for an HTTP service.

Arguments (dict):
  * root - .
  * app - application structure
*/}}
{{- define "drogue-cloud-common.http-service-container-port" }}
- containerPort: {{ include "drogue-cloud-common.http-bind-port" . }}
  name: service
  protocol: TCP
{{- end }}