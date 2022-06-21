{{/*
Create the default ingress annotations.

Arguments:
  * root - .
  * ingress
*/}}
{{- define "drogue-cloud-core.ingress.annotations" -}}

{{- with .ingress.annotations }}
{{- . | toYaml }}
{{- else }}

{{- with .root.Values.defaults.ingress.annotations }}
{{- . | toYaml }}
{{- else }}

{{- if eq .root.Values.global.cluster "openshift" }}
{{- if not .ingress.insecure }}
route.openshift.io/termination: "edge"
{{- end }}{{/* .insecure */}}
{{- end }}{{/* is openshift */}}

{{- end }}{{/* with .default.ingress.annotations */}}

{{- end }}{{/* with .ingress.annotations */}}

{{- end }}{{/* define */}}

{{/*
Create the ingressClassName field.

Arguments:
  * root - .
  * ingress
*/}}
{{- define "drogue-cloud-core.ingress.className" -}}
{{- with .ingress.className | default .root.Values.defaults.ingress.className -}}
ingressClassName: {{ . }}
{{- end }}
{{- end }}
