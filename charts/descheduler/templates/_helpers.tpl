{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "descheduler.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "descheduler.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "descheduler.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "descheduler.labels" -}}
app.kubernetes.io/name: {{ include "descheduler.name" . }}
helm.sh/chart: {{ include "descheduler.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.commonLabels}}
{{ toYaml .Values.commonLabels }}
{{- end }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "descheduler.selectorLabels" -}}
app.kubernetes.io/name: {{ include "descheduler.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "descheduler.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "descheduler.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Leader Election
*/}}
{{- define "descheduler.leaderElection"}}
{{- if .Values.leaderElection -}}
- --leader-elect
- {{ default false .Values.leaderElection.enabled }}
{{- if .Values.leaderElection.leaseDuration }}
- --leader-elect-lease-duration
- {{ .Values.leaderElection.leaseDuration }}
{{- end }}
{{- if .Values.leaderElection.renewDeadline }}
- --leader-elect-renew-deadline
- {{ .Values.leaderElection.renewDeadline }}
{{- end }}
{{- if .Values.leaderElection.retryPeriod }}
- --leader-elect-retry-period
- {{ .Values.leaderElection.retryPeriod }}
{{- end }}
{{- if .Values.leaderElection.resourceLock }}
- --leader-elect-resource-lock
- {{ .Values.leaderElection.resourceLock }}
{{- end }}
{{- if .Values.leaderElection.resourceName }}
- --leader-elect-resource-name
- {{ .Values.leaderElection.resourceName }}
{{- end }}
{{- if .Values.leaderElection.resourceNamescape }}
- --leader-elect-resource-namespace
- {{ .Values.leaderElection.resourceNamescape }}
{{- end -}}
{{- end }}
{{- end }}
