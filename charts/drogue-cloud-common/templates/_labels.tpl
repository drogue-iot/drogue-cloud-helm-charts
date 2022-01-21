{{/*
Selector labels
 * root - .
 * name - name of the resource
 * component - component this resource belongs to
*/}}
{{- define "drogue-cloud-common.selectorLabels" -}}
app.kubernetes.io/name: {{ .name }}
app.kubernetes.io/component: {{ .component }}
app.kubernetes.io/instance: {{ .root.Values.coreReleaseName | default .root.Release.Name }}

{{- if .metrics }}
drogue.io/metrics: "true"
{{- end }}

{{- end }}

{{/*
Health labels
*/}}
{{- define "drogue-cloud-common.healthSelector" -}}
app.kubernetes.io/instance: {{ .Values.global.coreReleaseName | default .Values.coreReleaseName | default .Release.Name }}
app.kubernetes.io/part-of: {{ .Values.global.partOf | default "drogue-iot" }}
drogue.io/metrics: "true"
{{- end }}