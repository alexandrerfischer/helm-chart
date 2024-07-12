{{/*
Expand the name of the chart.
*/}}
{{- define "app.name" -}}
{{- $name := default $.Values.name $.Values.nameOverride }}
{{- trunc 63 $name | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default $.Values.name $.Values.nameOverride }}
{{- if contains $name $.Release.Name }}
{{- $.Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" $.Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "app.chart" -}}
{{- $name := default $.Values.name $.Values.nameOverride }}
{{- printf "%s | Chart Version: %s" $name $.Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "app.labels" -}}
{{- $commonLabels := dict "helm.sh/chart" (include "app.chart" .) "app.kubernetes.io/name" (include "app.name" .) "app.kubernetes.io/instance" $.Release.Name "app.kubernetes.io/managed-by" $.Release.Service -}}
{{- if .Values.env }}
{{- $commonLabels = merge $commonLabels (dict "env" .Values.env) -}}
{{- end }}
{{- toYaml $commonLabels | nindent 4 -}}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "app.selectorLabels" -}}
{{- $selectorLabels := dict "app.kubernetes.io/name" (include "app.name" .) "app.kubernetes.io/instance" $.Release.Name -}}
{{- toYaml $selectorLabels | nindent 4 -}}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
