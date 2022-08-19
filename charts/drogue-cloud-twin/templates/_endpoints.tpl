{{/*
External API URL.
*/}}
{{- define "drogue-cloud-twin.api.url" -}}
{{- include "drogue-cloud-common.ingress.url" (dict "root" . "prefix" "api" "ingress" .Values.api.ingress ) -}}
{{- end }}

{{/*
External API Hostname.
*/}}
{{- define "drogue-cloud-twin.api.host" -}}
{{- include "drogue-cloud-common.ingress.host" (dict "root" . "prefix" "api" "ingress" .Values.api.ingress ) -}}
{{- end }}

{{/*
External SSO URL.
*/}}
{{- define "drogue-cloud-twin.sso.url" -}}
{{- include "drogue-cloud-common.ingress.url" (dict "root" . "prefix" "sso" "ingress" .Values.services.sso.ingress ) -}}
{{- end }}

{{/*
External SSO Hostname.
*/}}
{{- define "drogue-cloud-twin.sso.host" -}}
{{- include "drogue-cloud-common.ingress.host" (dict "root" . "prefix" "sso" "ingress" .Values.services.sso.ingress ) -}}
{{- end }}

{{/*
External Debugger URL.
*/}}
{{- define "drogue-cloud-twin.debugger.url" -}}
{{- include "drogue-cloud-common.ingress.url" (dict "root" . "prefix" "debugger" "ingress" .Values.services.debugger.ingress ) -}}
{{- end }}

{{/*
External Debugger Hostname.
*/}}
{{- define "drogue-cloud-twin.debugger.host" -}}
{{- include "drogue-cloud-common.ingress.host" (dict "root" . "prefix" "debugger" "ingress" .Values.services.debugger.ingress ) -}}
{{- end }}