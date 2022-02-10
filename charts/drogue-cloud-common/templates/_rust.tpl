{{/*
Set Rust logging variables.

Arguments: (dict)
* root - the content
* app - the application
*/}}
{{- define "drogue-cloud-common.rust.logging" -}}
{{- include "drogue-cloud-common._rust.backtrace" . }}
{{- include "drogue-cloud-common._rust.log" . }}
{{- end }}{{/* define */}}


{{/*
Set RUST_LOG

Arguments: (dict)
* root - the content
* app - the application
*/}}
{{- define "drogue-cloud-common._rust.log" -}}

{{/* application, specific value */}}
{{- with ((.app.logging).rust).log }}
- name: RUST_LOG
  value: {{ . | quote }}
{{- else }}

{{/* application, debug flag */}}
{{- if not ( kindIs "invalid" (.app.logging).debug ) -}}
{{- if (.app.logging).debug }}
- name: RUST_LOG
  value: debug
{{- else }}
- name: RUST_LOG
  value: info
{{- end }}
{{- else }}{{/* if not "invalid" */}}

{{/* default, specific value */}}
{{- with (.root.Values.defaults.logging.rust).log }}
- name: RUST_LOG
  value: {{ . | quote }}
{{- else }}
{{- if .root.Values.defaults.logging.debug }}
- name: RUST_LOG
  value: debug
{{- else }}
- name: RUST_LOG
  value: info
{{- end }}{{/* if not defaults debug */}}
{{- end }}{{/* with (default)*/}}

{{- end }}{{/* if not "invalid" */}}

{{- end }}{{/* with (application)*/}}

{{- end }}{{/* define */}}



{{/*
Set RUST_BACKTRACE

Arguments: (dict)
* root - the content
* app - the application
*/}}
{{- define "drogue-cloud-common._rust.backtrace" -}}

{{- if ((.app.logging).rust).backtrace | default (.app.logging).debug | default (.root.Values.defaults.logging.rust).backtrace | default .root.Values.defaults.logging.debug }}
- name: RUST_BACKTRACE
  value: "1"
{{- end }}

{{- end }}{{/* define */}}