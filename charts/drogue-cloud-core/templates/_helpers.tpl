{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "drogue-cloud-core.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.

Arguments: (dict)
 * root - .
 * name - name of the resource
 * component - component this resource belongs to
 * metrics - flag to add metrics labels
*/}}
{{- define "drogue-cloud-core.labels" -}}
{{ include "drogue-cloud-common.selectorLabels" . }}
{{- if .root.Chart.AppVersion }}
app.kubernetes.io/version: {{ .root.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .root.Release.Service }}
app.kubernetes.io/part-of: {{ .root.Values.global.partOf | default "drogue-iot" }}
{{- if .metrics }}
drogue.io/metrics: "true"
{{- end }}
{{- end }}

{{/*
Generate certificates and create secretes if they don't already exists
*/}}
{{- define "drogue-cloud-core.cert-gen" -}}
{{- if .Values.certificates.generator.enabled }}
{{- if or
(lookup "v1" "Secret" .Release.Namespace "http-endpoint-tls")
(lookup "v1" "Secret" .Release.Namespace "mqtt-endpoint-tls")
(lookup "v1" "Secret" .Release.Namespace "coap-endpoint-tls")
-}}
  {{- else  }}
true
{{- end }}
{{- else }}{{- end }}
{{- end }}