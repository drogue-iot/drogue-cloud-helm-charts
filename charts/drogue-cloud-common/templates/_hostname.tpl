
{{/*
Service host:
 * root - .
 * insecure - https or not
 * prefix - DNS prefix
*/}}
{{- define "drogue-cloud-common.ingress.host" -}}
{{- .ingress.host | default ( printf "%s%s" .prefix .root.Values.global.domain ) -}}
{{- end }}


{{/* HTTP Specific */}}

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


{{/* CoAP specific */}}

{{/*
CoAP Service URL:
 * root - .
 * insecure - coaps or not
 * prefix - DNS prefix
*/}}
{{- define "drogue-cloud-common.ingress.coap-url" -}}
{{- include "drogue-cloud-common.ingress.coap-proto" . -}}
://
{{- include "drogue-cloud-common.ingress.host" . -}}

{{- $port := .ingress.port | default 5683 | toString -}}
{{- /*
  The next line means:
    !( port == 5683 && insecure ) || ( port == 5684 && !insecure)
*/ -}}
{{- if not (or (and (eq $port "5683") .insecure) (and (eq $port "5684") (not .insecure )) ) -}}
:{{ $port }}
{{- end }}

{{- end }}

{{/*
Ingress CoAP protocol:
 * root - .
 * insecure - coaps or not
*/}}
{{- define "drogue-cloud-common.ingress.coap-proto" -}}
    {{- with .ingress.proto -}}{{ . }}{{- else -}}
    {{- if not ( kindIs "invalid" .insecure ) -}}
        {{- if .insecure -}}coap{{- else -}}coaps{{- end -}}
    {{- else -}}
        {{- if eq .root.Values.global.cluster "openshift" -}}
            coaps
        {{- else -}}
            coap
        {{- end }}
    {{- end }}{{/* end-if defined .insecure */}}
    {{- end }}{{/* end-with .ingress.coap-proto */}}
{{- end }}

{{/* WS specific */}}

{{/*
WS Service URL:
 * root - .
 * insecure - wss or not
 * prefix - DNS prefix
*/}}
{{- define "drogue-cloud-common.ingress.ws-url" -}}
{{- include "drogue-cloud-common.ingress.ws-proto" . -}}
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
Ingress WS protocol:
 * root - .
 * insecure - wss or not
*/}}
{{- define "drogue-cloud-common.ingress.ws-proto" -}}
    {{- with .ingress.proto -}}{{ . }}{{- else -}}
    {{- if not ( kindIs "invalid" .insecure ) -}}
        {{- if .insecure -}}ws{{- else -}}wss{{- end -}}
    {{- else -}}
        {{- if eq .root.Values.global.cluster "openshift" -}}
            wss
        {{- else -}}
            ws
        {{- end }}
    {{- end }}{{/* end-if defined .insecure */}}
    {{- end }}{{/* end-with .ingress.ws-proto */}}
{{- end }}

{{- define "drogue-cloud-common.ingress.cert-altnames" -}}
DNS:{{- include "drogue-cloud-common.ingress.host" (dict "root" . "prefix" "mqtt-endpoint" "ingress" .Values.endpoints.mqtt.ingress ) -}}, DNS:{{- include "drogue-cloud-common.ingress.host" (dict "root" . "prefix" "http-endpoint" "ingress" .Values.endpoints.http.ingress ) -}}, DNS:{{- include "drogue-cloud-common.ingress.host" (dict "root" . "prefix" "coap-endpoint" "ingress" .Values.endpoints.coap.ingress ) -}}, DNS:{{- include "drogue-cloud-common.ingress.host" (dict "root" . "prefix" "mqtt-integration" "ingress" .Values.integrations.mqtt.ingress ) -}}
{{- end }}