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
