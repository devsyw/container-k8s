{{/*
공통 라벨 생성
*/}}
{{- define "container-platform.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
이미지 전체 경로 생성
사용법: {{ include "container-platform.image" (dict "registry" .Values.global.registry "repository" .Values.codeServer.image.repository "tag" .Values.codeServer.image.tag) }}
*/}}
{{- define "container-platform.image" -}}
{{ .registry }}/{{ .repository }}:{{ .tag }}
{{- end }}

{{/*
랜덤 서브도메인 생성을 위한 어노테이션
*/}}
{{- define "container-platform.randomSubdomain" -}}
{{- randAlphaNum 8 | lower -}}
{{- end }}