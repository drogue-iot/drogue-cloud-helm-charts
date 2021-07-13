{{/*
Service URL:
 * root - .
 * insecure - https or not
 * prefix - DNS prefix
*/}}
{{- define "drogue-cloud-common.ingress.url" -}}
{{- include "drogue-cloud-common.ingress.proto" . -}}
://
{{- include "drogue-cloud-common.ingress.host" . -}}

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
Service host:
 * root - .
 * insecure - https or not
 * prefix - DNS prefix
*/}}
{{- define "drogue-cloud-common.ingress.host" -}}
{{- .ingress.host | default ( printf "%s%s" .prefix .root.Values.global.domain ) -}}
{{- end }}

{{/*
Ingress HTTP protocol:
 * root - .
 * insecure - https or not
*/}}
{{- define "drogue-cloud-common.ingress.proto" -}}
    {{- with .ingress.proto -}}{{ . }}{{- else -}}
    {{- if not ( kindIs "invalid" .insecure ) -}}
        {{- if .insecure -}}http{{- else -}}https{{- end -}}
    {{- else -}}
        {{- if eq .root.Values.global.cluster "openshift" -}}
            https
        {{- else -}}
            http
        {{- end }}
    {{- end }}{{/* end-if defined .insecure */}}
    {{- end }}{{/* end-with .ingress.proto */}}
{{- end }}
