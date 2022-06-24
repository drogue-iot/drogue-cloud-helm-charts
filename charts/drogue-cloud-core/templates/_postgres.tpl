{{- define "drogue-cloud-core.postgres.env-vars-default" }}
{{- include "drogue-cloud-core.postgres.env-vars" (dict "root" . "prefix" "PG__" ) }}
{{- end }}

{{- define "drogue-cloud-core.postgres.env-vars" }}

{{- with .root.Values.postgres.external }}
- name: {{ $.prefix }}DB__HOST
  value: {{ .host | quote }}
- name: {{ $.prefix }}DB__PORT
  value: {{ .port | default 5432 | quote }}
{{- else }}
- name: {{ .prefix }}DB__HOST
  value: postgres
- name: {{ $.prefix }}DB__PORT
  value: "5432"
{{- end }} {{/* with .external */}}

- name: {{ .prefix }}DB__DBNAME
  value: {{ .root.Values.postgres.databaseName | quote }}
- name: {{ .prefix }}DB__USER
  valueFrom:
    secretKeyRef:
      name: postgres-secret
      key: admin.username
- name: {{ .prefix }}DB__PASSWORD
  valueFrom:
    secretKeyRef:
      name: postgres-secret
      key: admin.password

{{/* TLS */}}

{{- if .root.Values.postgres.tls.enabled }}
- name: {{ $.prefix }}DB__SSL_MODE
  value: required

{{- if not .root.Values.global.drogueCloud.useServiceCA -}}
- name: {{ $.prefix }}TLS__CA_CERTIFICATE
  value: /etc/tls/postgres/ca.crt
{{- end }} {{/* if not .useServiceCA */}}

{{- end }} {{/* if .tls.enabled */}}

{{- end }}

{{/* The hash of the postgres secret, for using as an annotation value */}}
{{- define "drogue-cloud-core.postgres.secret-hash" }}
{{- include (print $.Template.BasePath "/infrastructure/postgres/secret.yaml") . | sha256sum }}
{{- end }}

{{- define "drogue-cloud-core.postgres.volume-mounts" }}
{{- if and .Values.postgres.tls.enabled ( not .Values.global.drogueCloud.useServiceCA ) }}
- name: postgres-tls
  mountPath: /etc/tls/postgres
{{- end }}
{{- end }}

{{- define "drogue-cloud-core.postgres.volumes" }}
{{- if and .Values.postgres.tls.enabled ( not .Values.global.drogueCloud.useServiceCA ) }}
- name: postgres-tls
  {{- with .Values.postgres.tls.trustAnchor }}
  configMap:
    name: {{ .configMap }}
    {{- with .key }}
    items:
      - key: {{ . | quote }}
        path: ca.crt
    {{- end }}
  {{- else }}
  secret:
    secretName: {{ . }}
    items:
      - key: tls.crt
        path: ca.crt
  {{- end }}
{{- end }}
{{- end }}
