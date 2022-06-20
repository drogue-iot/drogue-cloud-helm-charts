{{/*
Selector labels
 * root - .
 * name - name of the resource
 * component - component this resource belongs to
*/}}
{{- define "drogue-cloud-common.selectorLabels" -}}
app.kubernetes.io/name: {{ .name }}
{{- with .component}}
app.kubernetes.io/component: {{ . }}
{{- end }}
app.kubernetes.io/instance: {{ .root.Values.coreReleaseName | default .root.Release.Name }}
{{- end }}

{{/*
Health labels
*/}}
{{- define "drogue-cloud-common.healthSelector" -}}
app.kubernetes.io/instance: {{ .Values.global.coreReleaseName | default .Values.coreReleaseName | default .Release.Name }}
app.kubernetes.io/part-of: {{ .Values.global.partOf | default "drogue-iot" }}
drogue.io/metrics: "true"
{{- end }}