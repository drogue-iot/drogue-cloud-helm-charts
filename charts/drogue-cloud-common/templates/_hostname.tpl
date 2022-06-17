
{{/*
Service host:
 * root - .
 * prefix - DNS prefix
*/}}
{{- define "drogue-cloud-common.ingress.host" -}}
{{- .ingress.host | default ( printf "%s%s" .prefix .root.Values.global.domain ) -}}
{{- end }}


{{/* HTTP Specific */}}

{{/*
Service URL:
 * root - .
 * ingress - the ingress configuration
 * prefix - DNS prefix
*/}}
{{- define "drogue-cloud-common.ingress.url" -}}
{{- include "drogue-cloud-common.ingress.proto" . -}}
://
{{- include "drogue-cloud-common.ingress.host" . -}}

{{- $port := .ingress.port | default 443 | toString -}}
{{- include "drogue-cloud-common.ingress._port-part" ( dict "ingress" .ingress "securePort" "443" "insecurePort" "80" "port" $port ) }}

{{- end }}

{{/*
Ingress HTTP protocol:
 * root - .
 * ingress - the ingress configuration
*/}}
{{- define "drogue-cloud-common.ingress.proto" -}}
{{- include "drogue-cloud-common.ingress._proto" ( deepCopy . | merge ( dict "secureProto" "https" "insecureProto" "http" )) }}
{{- end }}

{{/* CoAP specific */}}

{{/*
CoAP Service URL:
 * root - .
 * ingress - the ingress configuration
 * prefix - DNS prefix
*/}}
{{- define "drogue-cloud-common.ingress.coap-url" -}}
{{- include "drogue-cloud-common.ingress.coap-proto" . -}}
://
{{- include "drogue-cloud-common.ingress.host" . -}}

{{- $port := .ingress.port | default 5683 | toString -}}
{{- include "drogue-cloud-common.ingress._port-part" ( dict "ingress" .ingress "securePort" "5684" "insecurePort" "5683" "port" $port ) }}

{{- end }}

{{/*
Ingress CoAP protocol:
 * root - .
 * ingress - the ingress configuration
 * ingress - the ingress object
*/}}
{{- define "drogue-cloud-common.ingress.coap-proto" -}}
{{- include "drogue-cloud-common.ingress._proto" ( deepCopy . | merge ( dict "secureProto" "coaps" "insecureProto" "coap" )) }}
{{- end }}

{{/* WS specific */}}

{{/*
WS Service URL:
 * root - .
 * ingress - the ingress configuration
 * prefix - DNS prefix
*/}}
{{- define "drogue-cloud-common.ingress.ws-url" -}}
{{- include "drogue-cloud-common.ingress.ws-proto" . -}}
://
{{- include "drogue-cloud-common.ingress.host" . -}}

{{- $port := .ingress.port | default 443 | toString -}}
{{- include "drogue-cloud-common.ingress._port-part" ( dict "ingress" .ingress "securePort" "443" "insecurePort" "80" "port" $port ) }}

{{- end }}

{{/*
Ingress WS protocol:
 * root - .
 * ingress - the ingress configuration
*/}}
{{- define "drogue-cloud-common.ingress.ws-proto" -}}
{{- include "drogue-cloud-common.ingress._proto" ( deepCopy . | merge ( dict "secureProto" "wss" "insecureProto" "ws" )) }}
{{- end }}

{{/*
Ingress protocol:
 * root - the root context
 * ingress - the ingress configuration
 * insecureProto - the insecure protocol prefix
 * secureProto - the secure protocol prefix
*/}}
{{- define "drogue-cloud-common.ingress._proto" -}}
    {{- with .ingress.proto -}}{{ . }}
    {{- else -}}{{- if .ingress.insecure }}{{- .insecureProto -}}{{- else }}{{- .secureProto -}}{{- end }}
    {{- end }}{{/* with ingress.proto */}}
{{- end }}


{{/*
Ingress port (with prefixed :), or nothing.

Arguments:
 * ingress - the ingress configuration
 * securePort - default port number for secure connections
 * insecurePort - default port number for insecure connections
 * port - the actual port number
*/}}
{{- define "drogue-cloud-common.ingress._port-part" }}
{{- if and .ingress.insecure ( eq .port .insecurePort ) }}
{{- else if and ( not .ingress.insecure ) ( eq .port .securePort ) }}
{{- else }}:{{ .port }}
{{- end }}
{{- end }}

{{- define "drogue-cloud-common.ingress.cert-altnames" -}}
DNS:{{- include "drogue-cloud-common.ingress.host" (dict "root" . "prefix" "mqtt-endpoint" "ingress" .Values.endpoints.mqtt.ingress ) -}}, DNS:{{- include "drogue-cloud-common.ingress.host" (dict "root" . "prefix" "mqtt-endpoint-ws" "ingress" .Values.endpoints.mqttWs.ingress ) -}}, DNS:{{- include "drogue-cloud-common.ingress.host" (dict "root" . "prefix" "http-endpoint" "ingress" .Values.endpoints.http.ingress ) -}}, DNS:{{- include "drogue-cloud-common.ingress.host" (dict "root" . "prefix" "coap-endpoint" "ingress" .Values.endpoints.coap.ingress ) -}}, DNS:{{- include "drogue-cloud-common.ingress.host" (dict "root" . "prefix" "mqtt-integration" "ingress" .Values.integrations.mqtt.ingress ) -}}, DNS:{{- include "drogue-cloud-common.ingress.host" (dict "root" . "prefix" "mqtt-integration-ws" "ingress" .Values.integrations.mqttWs.ingress ) -}}
{{- end }}
