{{/*
Create the default ingress annotations.
*/}}
{{- define "drogue-cloud-core.ingress.annotations" -}}
{{- with .ingress.annotations }}
{{- . | toYaml }}
{{- else }}
{{- if eq .root.Values.global.cluster "openshift" }}
route.openshift.io/termination: "edge"
{{- end }}
{{- end }}
{{- end }}

{{/*
Create the ingressClassName field.
*/}}
{{- define "drogue-cloud-core.ingress.className" -}}
{{- with .ingress.className | default .root.Values.defaults.ingress.className }}
ingressClassName: {{ . }}
{{- end }}
{{- end }}
