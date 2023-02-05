{{/*
Expand the name of the chart.
*/}}
{{- define "carshop.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "carshop.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "carshop.imageCredential" -}}
{{- $cred := printf "\"username\": \"%s\", \"password\": \"%s\"" .Values.image.credential.username .Values.image.credential.password -}}
{{- $string := b64enc (printf "%s:%s" .Values.image.credential.username .Values.image.credential.password) -}}
{{- $config := printf "{\"auths\":{\"%s\":{ %s, \"auth\":\"%s\"}}}" .Values.image.repository $cred $string -}}
{{- $encoded := b64enc $config -}}
{{- $encoded -}}
{{- end -}}
{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "carshop.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "carshop.labels" -}}
helm.sh/chart: {{ include "carshop.chart" . }}
{{ include "carshop.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "carshop.selectorLabels" -}}
app.kubernetes.io/name: {{ include "carshop.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "carshop.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "carshop.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
