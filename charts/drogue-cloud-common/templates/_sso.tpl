{{/*
Internal Keycloak API URL

This requires the global "drogueCloud" section.
*/}}
{{- define "drogue-cloud-common.keycloak.internal.url" -}}
{{- if .Values.global.drogueCloud.keycloak.insecure -}}
http://sso-service.{{ .Release.Namespace }}.svc:8080
{{- else -}}
{{- if .Values.global.drogueCloud.useServiceCA -}}
https://sso-tls.{{ .Release.Namespace }}.svc:8443
{{- else -}}
https://sso-service.{{ .Release.Namespace }}.svc:8443
{{- end }}{{/* .useServiceCA */}}
{{- end }}{{/* .insecure */}}
{{- end }}

{{/*
An init container to wait for the client secret to be populated.

Arguments: (dict)
* root - the content
* volume - the name of the volume to map
*/}}
{{- define "drogue-cloud-common.init-container.wait-for-client-secret" -}}
- name: wait-for-{{ .volume }}
  image: {{ .root.Values.helper.image }}
  imagePullPolicy: {{ .root.Values.helper.imagePullPolicy | default "IfNotPresent" }}
  command:
    - bash
    - -c
    - |
      echo "$(date): Waiting for client secret to be populated (/etc/client-secret/CLIENT_SECRET)..."
      while test -z "$(cat /etc/client-secret/CLIENT_SECRET)"; do
        sleep 1
      done
      echo "$(date): Found client secret"
  volumeMounts:
    - mountPath: /etc/client-secret
      name: {{ .volume }}
      readOnly: true
{{- end }}
