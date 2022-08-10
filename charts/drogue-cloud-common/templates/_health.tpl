{{/*
Add health env-vars.

Arguments: (dict)
  root - the root (.)
  app - the application level configuration
*/}}
{{- define "drogue-cloud-common.health-env" -}}
- name: RUNTIME__HEALTH__ENABLED
  value: "true"
- name: RUNTIME__HEALTH__BIND_ADDR
  value: "0.0.0.0:9090"
{{- end -}}

{{- define "drogue-cloud-common.prometheus-annotations" -}}
prometheus.io/scrape: "true"
prometheus.io/path: /metrics
prometheus.io/port: "9090"
{{- end }}

{{/*
Health container port.

Arguments: (root)
*/}}
{{- define "drogue-cloud-common.health-container-port" -}}
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
{{- define "drogue-cloud-common.health-probes" -}}
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
