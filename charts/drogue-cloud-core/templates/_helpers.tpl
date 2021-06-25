{{/*
Create a Drogue IoT image name
*/}}
{{- define "drogue-cloud-core.image-repo" -}}
{{- with .Values.defaults.images.repository -}}
    {{ printf "%s/" . }}
{{- end }}
{{- end }}

{{/*
Image tag
*/}}
{{- define "drogue-cloud-core.image-tag" -}}
{{- .Values.defaults.images.tag | default .Chart.AppVersion }}
{{- end }}

{{/*
Pull policy
*/}}
{{- define "drogue-cloud-core.image-pull-policy" -}}
{{- with .Values.defaults.images.pullPolicy }}{{ . }}
{{- else }}
{{- if (eq (include "drogue-cloud-core.image-tag" .) "latest") }}Always{{ else }}IfNotPresent{{ end }}
{{- end }}
{{- end }}

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
*/}}
{{- define "drogue-cloud-core.labels" -}}
helm.sh/chart: {{ include "drogue-cloud-core.chart" .root }}
{{ include "drogue-cloud-common.selectorLabels" . }}
{{- if .root.Chart.AppVersion }}
app.kubernetes.io/version: {{ .root.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .root.Release.Service }}
app.kubernetes.io/part-of: {{ .root.Values.global.partOf | default "drogue-iot" }}
{{- end }}


{{/*
Passthrough service URL
*/}}
{{- define "drogue-cloud-core.passthrough.ingress.url" -}}
{{ if .insecure }}http{{ else }}https{{ end }}://
{{- include "drogue-cloud-core.passthrough.ingress.host" . -}}

{{- $port := .ingress.port | default 443 | toString -}}
{{- /*
  The next line means:
    !( port == 80 && insecure ) || ( port == 443 && !insecure)
*/ -}}
{{- if not (or (and (eq $port "80") .insecure) (and (eq $port "443") (not .insecure )) ) -}}
:{{ $port }}
{{- end }}

{{- end }}

{{/*
Passthrough service host
*/}}
{{- define "drogue-cloud-core.passthrough.ingress.host" -}}
{{- .ingress.host | default ( printf "%s%s" .prefix .root.Values.global.domain ) -}}
{{- end }}
