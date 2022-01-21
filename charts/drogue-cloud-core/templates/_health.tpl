{{/*
Health container port.

Arguments: (root)
*/}}
{{- define "drogue-cloud-core.health-container-port" -}}
- containerPort: 9090
  name: health
  protocol: TCP
{{- end }}