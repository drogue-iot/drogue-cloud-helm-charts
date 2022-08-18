{{- define "drogue-cloud-common.postgres.env-vars-default" }}
{{- include "drogue-cloud-common.postgres.env-vars" (dict "root" . "prefix" "PG__" ) }}
{{- end }}

{{- define "drogue-cloud-common.postgres.env-vars" }}

{{- with .root.Values.postgres.external }}
- name: {{ $.prefix }}DB__HOST
  value: {{ .host | quote }}
- name: {{ $.prefix }}DB__PORT
  value: {{ .port | default 5432 | quote }}
{{- else }}
- name: {{ .prefix }}DB__HOST
  value: postgres.{{ .root.Release.Namespace }}.svc
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
  value: Require


{{- if .root.Values.global.drogueCloud.useServiceCA -}}
{{/* nothing required */}}
{{- else }}

{{- with .root.Values.postgres.tls.trustAnchor }}
{{/* only required if we have a secret or config map */}}
{{- if or .secret .configMap }}
- name: {{ $.prefix }}TLS__CA_CERTIFICATE
  value: /etc/tls/postgres/ca.crt
{{- end}}

{{- end }}{{/* with trustAchor */}}
{{- end }}{{/* if useServiceCA */}}

{{- end }} {{/* if .tls.enabled */}}

{{- end }}

{{- define "drogue-cloud-common.postgres.volume-mounts" }}
{{- if and .Values.postgres.tls.enabled ( not .Values.global.drogueCloud.useServiceCA ) }}
- name: postgres-tls
  mountPath: /etc/tls/postgres
{{- end }}
{{- end }}

{{- define "drogue-cloud-common.postgres.volumes" }}
{{- if and .Values.postgres.tls.enabled ( not .Values.global.drogueCloud.useServiceCA ) }}
- name: postgres-tls
  {{- with .Values.postgres.tls.trustAnchor }}

  {{- if .configMap }}
  configMap:
    name: {{ .configMap }}
    {{- with .key }}
    items:
      - key: {{ . | quote }}
        path: ca.crt
    {{- end }}
  {{- else if .secret }}
  secret:
    secretName: {{ .secret }}
    {{- with .key }}
    items:
      - key: {{ . | quote }}
        path: ca.crt
    {{- else }}
    items:
      - key: tls.crt
        path: ca.crt
    {{- end }}
  {{- end }}

  {{- end }}{{/* with trustAnchor */}}
{{- end }}{{/* if tls.enabled && !useServiceCA */}}
{{- end }}
