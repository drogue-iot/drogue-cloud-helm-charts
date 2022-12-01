{{/*
External Console URL.
*/}}
{{- define "drogue-cloud-core.console.url" -}}
{{- include "drogue-cloud-common.ingress.url" (dict "root" . "prefix" "console" "ingress" .Values.services.console.ingress ) -}}
{{- end }}

{{/*
External Console Hostname.
*/}}
{{- define "drogue-cloud-core.console.host" -}}
{{- include "drogue-cloud-common.ingress.host" (dict "root" . "prefix" "console" "ingress" .Values.services.console.ingress ) -}}
{{- end }}

{{/*
External API URL.
*/}}
{{- define "drogue-cloud-core.api.url" -}}
{{- include "drogue-cloud-common.ingress.url" (dict "root" . "prefix" "api" "ingress" .Values.services.api.ingress ) -}}
{{- end }}

{{/*
External API Hostname.
*/}}
{{- define "drogue-cloud-core.api.host" -}}
{{- include "drogue-cloud-common.ingress.host" (dict "root" . "prefix" "api" "ingress" .Values.services.api.ingress ) -}}
{{- end }}

{{/*
External SSO URL.
*/}}
{{- define "drogue-cloud-core.sso.url" -}}
{{- include "drogue-cloud-common.ingress.url" (dict "root" . "prefix" "sso" "ingress" .Values.services.sso.ingress ) -}}
{{- end }}

{{/*
External SSO Hostname.
*/}}
{{- define "drogue-cloud-core.sso.host" -}}
{{- include "drogue-cloud-common.ingress.host" (dict "root" . "prefix" "sso" "ingress" .Values.services.sso.ingress ) -}}
{{- end }}

{{/*
External Websocket integration URL.
*/}}
{{- define "drogue-cloud-core.websocket-integration.url" -}}
{{- include "drogue-cloud-common.ingress.url" (dict "root" . "prefix" "websocket-integration" "ingress" .Values.integrations.websocket.ingress ) -}}
{{- end }}

{{/*
External Websocket integration Hostname.
*/}}
{{- define "drogue-cloud-core.websocket-integration.host" -}}
{{- include "drogue-cloud-common.ingress.host" (dict "root" . "prefix" "websocket-integration" "ingress" .Values.integrations.websocket.ingress ) -}}
{{- end }}
