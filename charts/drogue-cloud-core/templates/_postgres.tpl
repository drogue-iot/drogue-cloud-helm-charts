{{/* The hash of the postgres secret, for using as an annotation value */}}
{{- define "drogue-cloud-core.postgres.volumes" }}
{{- include (print $.Template.BasePath "/infrastructure/postgres/secret.yaml") . | sha256sum }}
{{- end }}
