{{/*
Health container port.

Arguments: (root)
*/}}
{{- define "drogue-cloud-core.health-container-port" -}}
- containerPort: 9090
  name: health
  protocol: TCP
{{- end }}

{{/*
Defaults health probes.

Arguments: (dict)
  * root - .
  * app - application configuration
*/}}
{{- define "drogue-cloud-core.health-probes" -}}
readinessProbe:
  initialDelaySeconds: 2
  periodSeconds: 1
  timeoutSeconds: 1
  failureThreshold: 3
  httpGet:
    port: 9090
    path: /readiness
livenessProbe:
  initialDelaySeconds: 2
  periodSeconds: 1
  timeoutSeconds: 1
  failureThreshold: 3
  httpGet:
    port: 9090
    path: /liveness
{{- end }}