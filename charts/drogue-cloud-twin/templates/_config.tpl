{{- define "drogue-cloud-twin.config.common" }}

{{- with .root.Values.configuration.application }}
- name: APPLICATION
  value: {{ . | quote }}
{{- end}}

{{- end }}{{/* define */}}


{{- define "drogue-cloud-twin.config.storage" }}

{{- with .root.Values.configuration.application }}
- name: {{ $.prefix }}APPLICATION
  value: {{ . | quote }}
{{- end}}

{{- include "drogue-cloud-common.postgres.env-vars" ( dict "root" .root "prefix" .prefix ) }}
{{- end }}{{/* define */}}


{{- define "drogue-cloud-twin.config.listener" }}
- name: {{ .prefix }}TOPIC
  value: {{ .root.Values.configuration.notifications.topic | quote }}
- name: {{ .prefix }}PROPERTIES__BOOTSTRAP_SERVERS
  value: {{ include "drogue-cloud-common.kafka-bootstrap-server" .root | quote }}
- name: {{ .prefix }}PROPERTIES__GROUP_ID
  value: doppelgaenger
{{- include "drogue-cloud-common.kafka-properties" ( dict "root" .root "prefix" ( printf "%sPROPERTIES__" .prefix ) ) }}
{{- end }}{{/* define */}}


{{- define "drogue-cloud-twin.config.notifier" }}
- name: {{ .prefix }}TOPIC
  value: {{ .root.Values.configuration.notifications.topic | quote }}
- name: {{ .prefix }}QUEUE_TIMEOUT
  value: 15s
- name: {{ .prefix }}PROPERTIES__BOOTSTRAP_SERVERS
  value: {{ include "drogue-cloud-common.kafka-bootstrap-server" .root | quote }}
{{- include "drogue-cloud-common.kafka-properties" ( dict "root" .root "prefix" ( printf "%sPROPERTIES__" .prefix ) ) }}
{{- end }}{{/* define */}}


{{- define "drogue-cloud-twin.config.event-source" }}
- name: {{ .prefix }}TOPIC
  value: {{ .root.Values.configuration.events.topic | quote }}
- name: {{ .prefix }}PROPERTIES__BOOTSTRAP_SERVERS
  value: {{ include "drogue-cloud-common.kafka-bootstrap-server" .root | quote }}
- name: {{ .prefix }}PROPERTIES__GROUP_ID
  value: doppelgaenger
{{- include "drogue-cloud-common.kafka-properties" ( dict "root" .root "prefix" ( printf "%sPROPERTIES__" .prefix ) ) }}
{{- end }}{{/* define */}}


{{- define "drogue-cloud-twin.config.event-sink" }}
- name: {{ .prefix }}TOPIC
  value: {{ .root.Values.configuration.events.topic | quote }}
- name: {{ .prefix }}QUEUE_TIMEOUT
  value: 15s
- name: {{ .prefix }}PROPERTIES__BOOTSTRAP_SERVERS
  value: {{ include "drogue-cloud-common.kafka-bootstrap-server" .root | quote }}
{{- include "drogue-cloud-common.kafka-properties" ( dict "root" .root "prefix" ( printf "%sPROPERTIES__" .prefix ) ) }}
{{- end }}{{/* define */}}

{{- define "drogue-cloud-twin.config.command-sink" }}
- name: {{ .prefix }}MODE
  value: drogue

{{- with .root.Values.configuration.commands.mapToApplication }}
- name: {{ $.prefix }}APPLICATION
  value: {{ . | quote }}
{{- end }}

- name: {{ .prefix }}HOST
  value: {{ .root.Values.configuration.commands.host | quote }}
- name: {{ .prefix }}PORT
  value: {{ .root.Values.configuration.commands.port | quote }}

{{- if .root.Values.configuration.commands.username }}
- name: {{ .prefix }}USERNAME
  value: {{ .root.Values.configuration.commands.username | quote }}
- name: {{ .prefix }}PASSWORD
  value: {{ .root.Values.configuration.commands.password | quote }}
{{- end}}

{{- if .root.Values.configuration.commands.clientId }}
- name: {{ .prefix }}CLIENT_ID
  value: {{ .root.Values.configuration.commands.clientId | quote }}
{{- else }}
- name: {{ .prefix }}CLIENT_ID
  valueFrom:
    configMapKeyRef:
      name: drogue-doppelgaenger-configuration
      key: command.mqtt.clientId
{{- end }}

- name: {{ .prefix }}CLEAN_SESSION
  value: "true"
- name: {{ .prefix }}DISABLE_TLS
  value: {{ .root.Values.configuration.commands.disableTls | quote }}

{{- end }}{{/* define */}}

{{- define "drogue-cloud-twin.config.service" }}
{{- include "drogue-cloud-twin.config.storage" ( dict "root" .root "prefix" ( printf "%sSTORAGE__" .prefix ) ) }}
{{- include "drogue-cloud-twin.config.notifier" ( dict "root" .root "prefix" ( printf "%sNOTIFIER__" .prefix ) ) }}
{{- include "drogue-cloud-twin.config.event-sink" ( dict "root" .root "prefix" ( printf "%sSINK__" .prefix ) ) }}
{{- include "drogue-cloud-twin.config.command-sink" ( dict "root" .root "prefix" ( printf "%sCOMMAND_SINK__" .prefix ) ) }}
{{- end }}{{/* define */}}

