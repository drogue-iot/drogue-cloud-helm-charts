{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "drogue-cloud-twin.chart" -}}
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
{{- define "drogue-cloud-twin.labels" -}}
{{ include "drogue-cloud-common.selectorLabels" . }}
{{- if .root.Chart.AppVersion }}
app.kubernetes.io/version: {{ .root.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .root.Release.Service }}
app.kubernetes.io/part-of: {{ .root.Values.global.partOf | default "drogue-doppelgaenger" }}
{{- if .metrics }}
drogue.io/metrics: "true"
{{- end }}
{{- end }}
