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
    {{ if not .insecure -}}
        http
    {{- else -}}
        {{- if eq .Values.global.cluster "openshift" -}}
            https
        {{- else -}}
            http
        {{- end }}
    {{- end }}
    {{- end }}{{/* end-with */}}
{{- end }}