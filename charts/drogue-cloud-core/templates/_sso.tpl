{{/*
Apply OAuth2 (token provider, authenticator) env-vars.

Arguments: (dict)
 * root - .
 * prefix (String) - Env-var prefix
 * external (bool) - Don't use service CA, even if it is available (because it is an external endpoint)
*/}}
{{- define "drogue-cloud-core.oauth2-env-vars" -}}

{{- with .root.Values.oauth2.issuerUrl }}

- name: {{ $.prefix }}ISSUER_URL
  value: {{ . | quote }}

{{- else }} {{/* with issuerUrl */}}

{{- if and .root.Values.keycloak.useServiceCA (not .external ) }}
- name: {{ .prefix }}SSO_URL
  value: https://keycloak.{{ .root.Release.Namespace }}.svc:8443
{{- else }} {{/* if useServiceCA && !external */}}
{{/* being an external endpoint, we must use the external url, and fall back to "insecure" later */}}
- name: {{ .prefix }}SSO_URL
  value: {{ include "drogue-cloud-common.ingress.url" (dict "root" .root "prefix" "sso" "ingress" .root.Values.services.sso.ingress ) }}
{{- end }}

{{- end }} {{/* without issuerUrl */}}


{{- if .root.Values.keycloak.useServiceCA }}

- name: {{ .prefix }}TLS_CA_CERTIFICATES
  value: /etc/certs/keycloak/service-ca.crt
- name: {{ .prefix }}TLS_INSECURE
  {{/* being forced to use the external URL, we need to fall back to "insecure" */}}
  {{/* and we can't just use `.external` as doesn't have a value when left empty */}}
  value: {{ if .external }}"true"{{ else }}"false"{{ end }}

{{- else }}{{/* if useServiceCA */}}

- name: {{ .prefix }}TLS_INSECURE
  value: {{ .root.Values.oauth2.tls.insecure | quote }}

{{- end }}{{/* else useServiceCA */}}

{{- end }}{{/* define */}}

{{/*
Apply OAuth2 (token provider, authenticator) volumes.

Arguments: .
*/}}
{{- define "drogue-cloud-core.keycloak-volumes" -}}
{{- if .Values.keycloak.useServiceCA }}
- name: keycloak-tls
  configMap:
    name: keycloak-service-ca
{{- end }}
{{- end }}

{{/*
Apply OAuth2 (token provider, authenticator) volume mounts.

Arguments: .
*/}}
{{- define "drogue-cloud-core.keycloak-volume-mounts" -}}
{{- if .Values.keycloak.useServiceCA }}
- mountPath: /etc/certs/keycloak
  name: keycloak-tls
{{- end }}
{{- end }}


{{/*
Apply OAuth2 authenticator (validating) env-vars.

Arguments: (dict)
  * root - .
  * clients - (list<String>) clients
*/}}
{{- define "drogue-cloud-core.oauth2-authenticator.env-vars" }}

{{/* global SSO variables for authenticator */}}
{{- include "drogue-cloud-core.oauth2-env-vars" (dict "root" .root "prefix" "OAUTH__" ) }}

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

{{- if and (eq . "drogue") (and $.root.Values.keycloak.useServiceCA $.root.Values.keycloak.insecureExternal) }}
{{/* the console uses the issuer from an external endpoint, which is insecure */}}
- name: OAUTH__CLIENTS__{{ . | upper }}__ISSUER_URL
  value: {{ include "drogue-cloud-common.ingress.url" (dict "root" $.root "prefix" "sso" "ingress" $.root.Values.services.sso.ingress ) }}/auth/realms/drogue
- name: OAUTH__CLIENTS__{{ . | upper }}__TLS_INSECURE
  value: "true"
{{- end }}

{{- end }}

{{- end }}