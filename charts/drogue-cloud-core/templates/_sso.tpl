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

{{/*
Apply OAuth2 authenticator settings for an external service.

Arguments: .
*/}}
{{- define "drogue-cloud-core.oauth2-external-authenticator.env-vars" }}
{{- $clients := list "drogue" "services" -}}
{{- if .Values.keycloak.postInstall.resourceOwnerPasswordFlow }}
{{- $clients = concat $clients (list "direct") }}
{{- end }}
{{- include "drogue-cloud-common.oauth2-authenticator.env-vars" (dict "root" . "clients" $clients ) }}
{{- end }}

{{/*
Apply OAuth2 authenticator settings for an internal service.

Arguments: .
*/}}
{{- define "drogue-cloud-core.oauth2-internal-authenticator.env-vars" }}
{{- $clients := list "services" -}}
{{- include "drogue-cloud-common.oauth2-authenticator.env-vars" (dict "root" . "clients" $clients ) }}
{{- end }}