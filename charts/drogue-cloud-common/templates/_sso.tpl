{{/*
Internal Keycloak API URL

This requires the global "drogueCloud" section.
*/}}
{{- define "drogue-cloud-common.keycloak.internal.url" -}}
{{- if .Values.global.drogueCloud.keycloak.insecure -}}
http://sso-service.{{ .Release.Namespace }}.svc:8080
{{- else -}}
{{- if .Values.global.drogueCloud.useServiceCA -}}
https://sso-tls.{{ .Release.Namespace }}.svc:8443
{{- else -}}
https://sso-service.{{ .Release.Namespace }}.svc:8443
{{- end }}{{/* .useServiceCA */}}
{{- end }}{{/* .insecure */}}
{{- end }}

{{/*
Default keycloak realm name
*/}}
{{- define "drogue-cloud-common.sso.default-realm" }}
{{- .Values.keycloak.realm | default "drogue" }}
{{- end }}

{{/*
External OAuth2 issuer URL
*/}}
{{- define "drogue-cloud-common.sso.issuer-url" -}}
{{- with .Values.oauth2.issuerUrl }}{{ . }}{{ else -}}
{{- include "drogue-cloud-common.ingress.url" (dict "root" . "prefix" "sso" "ingress" .Values.services.sso.ingress ) }}/realms/{{- include "drogue-cloud-common.sso.default-realm" . | urlquery }}
{{- end }}
{{- end }}


{{/*
Apply OAuth2 (token provider, authenticator) env-vars.

Arguments: (dict)
 * root - .
 * prefix (String) - Env-var prefix
*/}}
{{- define "drogue-cloud-common.oauth2-internal.env-vars" -}}

{{- with .root.Values.oauth2.issuerUrl }}
- name: {{ .prefix }}ISSUER_URL
  value: {{ . | quote }}
{{- else }} {{/* with issuerUrl */}}
- name: {{ .prefix }}ISSUER_URL
  value: {{ include "drogue-cloud-common.keycloak.internal.url" .root }}/realms/{{- include "drogue-cloud-common.sso.default-realm" .root | urlquery }}
{{- end }}{{/* with issuerUrl */}}

- name: {{ .prefix }}TLS_INSECURE
  value: {{ .root.Values.oauth2.tls.insecure | quote }}

{{- end }}{{/* define */}}


{{/*
Apply OAuth2 (token provider, authenticator) env-vars.

Arguments: (dict)
 * root - .
 * prefix (String) - Env-var prefix
*/}}
{{- define "drogue-cloud-common.oauth2-external.env-vars" -}}
{{/* Override handled by include */}}
- name: {{ .prefix }}ISSUER_URL
  value: {{ include "drogue-cloud-common.sso.issuer-url" .root | quote }}

- name: {{ .prefix }}TLS_INSECURE
  value: {{ .root.Values.oauth2.tls.insecure | default false | quote }}

{{- end }}{{/* define */}}


{{/*
Apply OAuth2 authenticator (validating) env-vars.

Arguments: (dict)
  * root - .
  * clients - (list<String>) clients
*/}}
{{- define  "drogue-cloud-common.oauth2-authenticator.env-vars" }}

{{/* global SSO variables for authenticator */}}
{{- include "drogue-cloud-common.oauth2-internal.env-vars" (dict "root" .root "prefix" "OAUTH__" ) }}

{{- range .clients }}
- name: OAUTH__CLIENTS__{{ . | upper }}__CLIENT_ID
  valueFrom:
    secretKeyRef:
      name: keycloak-client-secret-{{ . }}
      key: CLIENT_ID
- name: OAUTH__CLIENTS__{{ . | upper }}__CLIENT_SECRET
  valueFrom:
    secretKeyRef:
      name: keycloak-client-secret-{{ . }}
      key: CLIENT_SECRET

{{- end }}

{{- end }}
