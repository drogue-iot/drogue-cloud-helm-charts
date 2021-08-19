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
Full image.

Arguments: (dict)
 * root - .
 * name - core name of the image
*/}}
{{- define "drogue-cloud-core.image" -}}
{{ include "drogue-cloud-core.image-repo" .root }}{{ .name }}:{{ include "drogue-cloud-core.image-tag" .root }}
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
