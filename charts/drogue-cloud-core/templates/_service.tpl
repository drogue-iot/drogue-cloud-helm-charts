{{/* The following macros are there to avoid repetition in other files */}}

{{- define "drogue-cloud-core.service-url.auth-service" }}
{{- include "drogue-cloud-common.service-url" (dict "root" . "name" "authentication-service" "app" .Values.services.auth ) }}
{{- end }}

{{- define "drogue-cloud-core.service-url.device-state-service" }}
{{- include "drogue-cloud-common.service-url" (dict "root" . "name" "device-state-service" "app" .Values.services.deviceState ) }}
{{- end }}

{{- define "drogue-cloud-core.service-url.device-management-service" }}
{{- include "drogue-cloud-common.service-url" (dict "root" . "name" "device-management-service" "app" .Values.services.registry ) }}
{{- end }}

{{- define "drogue-cloud-core.service-url.user-auth-service" }}
{{- include "drogue-cloud-common.service-url" (dict "root" . "name" "user-auth-service" "app" .Values.services.userAuth ) }}
{{- end }}
