{{/*
Create the default ingress annotations.

Arguments:
  * root - .
  * app - the application configuration
  * insecure - service is always insecure (or not)
*/}}
{{- define "drogue-cloud-core.ingress.annotations" -}}

{{- with .app.ingress.annotations }}
{{- . | toYaml }}
{{- else }}

{{- with .root.Values.defaults.ingress.annotations }}
{{- . | toYaml }}
{{- else }}

{{- if eq .root.Values.global.cluster "openshift" }}
{{- if not .app.ingress.insecure }}
{{- if and ( not .app.service.insecure ) .root.Values.global.drogueCloud.useServiceCA ( not .insecure ) }}
route.openshift.io/termination: "reencrypt"
{{- else }}
route.openshift.io/termination: "edge"
{{- end }}{{/* !.service.insecure && .useServiceCA */}}
{{- end }}{{/* .ingress.insecure */}}
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
