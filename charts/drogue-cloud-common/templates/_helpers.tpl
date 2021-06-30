

{{/*
Selector labels
 * root - .
 * name - name of the resource
 * component - component this resource belongs to
*/}}
{{- define "drogue-cloud-common.selectorLabels" -}}
app.kubernetes.io/name: {{ .name }}
app.kubernetes.io/component: {{ .component }}
app.kubernetes.io/instance: {{ .releaseName | default .root.Release.Name }}
{{- end }}
