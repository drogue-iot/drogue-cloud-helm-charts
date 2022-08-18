{{/*
Create a Drogue IoT image name
*/}}
{{- define "drogue-cloud-common.image-repo" -}}
{{- with .Values.defaults.images.repository -}}
    {{ printf "%s/" . }}
{{- end }}
{{- end }}

{{/*
Image tag
*/}}
{{- define "drogue-cloud-common.image-tag" -}}
{{- .Values.defaults.images.tag | default .Chart.AppVersion }}
{{- end }}

{{/*
Full image.

Arguments: (dict)
 * root - .
 * name - core name of the image
*/}}
{{- define "drogue-cloud-common.image" -}}
{{ include "drogue-cloud-common.image-repo" .root }}{{ .root.Values.defaults.images.prefix }}{{ .name }}:{{ include "drogue-cloud-common.image-tag" .root }}
{{- end }}

{{/*
Pull policy
*/}}
{{- define "drogue-cloud-common.image-pull-policy" -}}
{{- with .Values.defaults.images.pullPolicy }}{{ . }}
{{- else }}
{{- if (eq (include "drogue-cloud-common.image-tag" .) "latest") }}Always{{ else }}IfNotPresent{{ end }}
{{- end }}
{{- end }}
