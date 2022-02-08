{{/*
An init container to wait for the client secret to be populated.

Arguments: (dict)
* root - the content
* volume - the name of the volume to map
*/}}
{{- define "drogue-cloud-common.init-container.wait-for-client-secret" -}}
- name: wait-for-{{ .volume }}
  image: {{ .root.Values.helper.image }}
  imagePullPolicy: IfNotPresent
  command:
    - bash
    - -c
    - |
      echo "Waiting for client secret to be populated (/etc/client-secret/CLIENT_SECRET)..."
      while test -z "$(cat /etc/client-secret/CLIENT_SECRET)"; do
        sleep 1
      done
  volumeMounts:
    - mountPath: /etc/client-secret
      name: {{ .volume }}
      readOnly: true
{{- end }}
