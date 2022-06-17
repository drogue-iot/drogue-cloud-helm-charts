{{/*
External OAuth2 issuer URL
*/}}
{{- define "drogue-cloud-core.sso.issuer-url" -}}
{{- with .Values.oauth2.issuerUrl }}{{ . }}{{ else -}}
{{- include "drogue-cloud-common.ingress.url" (dict "root" . "prefix" "sso" "ingress" .Values.services.sso.ingress ) }}/realms/drogue
{{- end }}
{{- end }}


{{/*
Apply OAuth2 (token provider, authenticator) env-vars.

Arguments: (dict)
 * root - .
 * prefix (String) - Env-var prefix
*/}}
{{- define "drogue-cloud-core.oauth2-internal.env-vars" -}}

{{- with .root.Values.oauth2.issuerUrl }}
- name: {{ .prefix }}ISSUER_URL
  value: {{ . | quote }}
{{- else }} {{/* with issuerUrl */}}
- name: {{ .prefix }}ISSUER_URL
  value: {{ include "drogue-cloud-common.keycloak.internal.url" .root }}/realms/drogue
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
{{- define "drogue-cloud-core.oauth2-external.env-vars" -}}
{{/* Override handled by include */}}
- name: {{ .prefix }}ISSUER_URL
  value: {{ include "drogue-cloud-core.sso.issuer-url" .root | quote }}

- name: {{ .prefix }}TLS_INSECURE
  value: {{ .root.Values.oauth2.tls.insecure | default false | quote }}

{{- end }}{{/* define */}}


{{/*
Apply OAuth2 authenticator (validating) env-vars.

Arguments: (dict)
  * root - .
  * clients - (list<String>) clients
*/}}
{{- define  "drogue-cloud-core.oauth2-authenticator.env-vars" }}

{{/* global SSO variables for authenticator */}}
{{- include "drogue-cloud-core.oauth2-internal.env-vars" (dict "root" .root "prefix" "OAUTH__" ) }}

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

{{/*
For the Keycloak API, storing access tokens
*/}}
{{- define "drogue-cloud-core.keycloak.internal-access" }}
- name: KEYCLOAK__URL
  value: {{ include "drogue-cloud-common.keycloak.internal.url" . | quote }}
- name: KEYCLOAK__ADMIN_USERNAME
  valueFrom:
    secretKeyRef:
      key: username
      name: sso-service-credentials
- name: KEYCLOAK__ADMIN_PASSWORD
  valueFrom:
    secretKeyRef:
      key: password
      name: sso-service-credentials
- name: "KEYCLOAK__TLS_INSECURE"
  value: {{ .Values.oauth2.tls.insecure | quote }}
{{- end }}
