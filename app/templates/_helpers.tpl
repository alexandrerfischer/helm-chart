{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
This defines a short and default name for the application. 
If `nameOverride` is set in the values, it will use that, otherwise it defaults to the chart name.
*/}}
{{- define "app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a fully qualified name for the application.
This function generates a complete name for the application by combining the release name and chart name.
If `fullnameOverride` is set in the values, it will use that. Otherwise, it checks if the release name already contains the chart name.
In both cases, the result is truncated to 63 characters to comply with Kubernetes' DNS name length limitations.
*/}}
{{- define "app.fullname" -}}
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
Create a chart name and version label.
This helper function combines the chart name and version into a single label.
It replaces any `+` symbols (which are invalid in Kubernetes labels) with underscores, ensuring a valid format.
*/}}
{{- define "app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels for resources.
This function generates common labels that should be applied to Kubernetes resources, such as deployments, services, etc.
It includes the chart label, selector labels, the app version (if available), and the service that manages the release.
*/}}
{{- define "app.labels" -}}
helm.sh/chart: {{ include "app.chart" . }}
{{ include "app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels used by the Kubernetes resources for selecting the right objects.
This defines the labels used for selecting pods and other resources. 
It includes the app name and the release instance.
*/}}
{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Define the name of the service account to be used.
If the service account is set to be created (`serviceAccount.create`), it uses the full name of the application as the service account name.
Otherwise, it defaults to the Kubernetes default service account or the specified name in `serviceAccount.name`.
*/}}
{{- define "app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
  {{ default (include "app.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
  {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
