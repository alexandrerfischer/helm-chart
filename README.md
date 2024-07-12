# Helm Chart Template

This Helm Chart provides a generic and reusable solution for deploying applications on Kubernetes. Helm is a package management tool for Kubernetes that allows you to define, install, and upgrade Kubernetes applications.

This particular Helm Chart is configurable and can be used to deploy various types of resources on Kubernetes, such as:

    Deployments: Define how pods will be managed, including the number of replicas, container images, and more.

    CronJobs: Schedule tasks similar to Unix cron jobs.
    
    Services: Expose pods so they can be accessed within or outside the cluster.
    
    Ingresses: Manage external access to services in the cluster, typically via HTTP/HTTPS.
    
    ConfigMaps: Store configuration data that can be consumed by pods.
    
    Secrets: Store sensitive information like passwords and tokens securely.
    
    Horizontal Pod Autoscaler (HPA): Automatically adjust the number of replicas of a deployment or replicaset based on CPU/memory usage.
    
    Service Accounts: Specify service accounts that pods can use to authenticate with Kubernetes and other services.

The values.yaml file is used to define default values and specific configurations that can be adjusted as needed for different environments or applications.

Any application can use this generic Helm Chart by adjusting the specific configurations in the values.yaml file of the application's repository. Additionally, each resource (such as ConfigMaps, CronJobs, Secrets, etc.) can be enabled or disabled according to specific needs using the enabled option in `values.yaml` .

## Directory Structure

```plaintext
app/
├── Chart.yaml
├── values.yaml
├── .helmignore
├── templates/
│   ├── _helpers.tpl
│   ├── NOTES.txt
│   ├── cronjobs.yaml
│   ├── configmap.yaml
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── secret.yaml
│   ├── service.yaml
│   ├── serviceaccount.yaml
└── charts/
```

## Default Values

The `values.yaml` file contains the default values used to configure the Kubernetes resources. You can adjust these values as needed.

```
replicaCount: 1

image:
  repository: nginx
  pullPolicy: IfNotPresent
  tag: ""

imagePullSecrets: []

name: "name-your-application"
appVersion: "app-version"

serviceAccount: []
  create: true
  automount: true
  annotations: {}
  name: "name-your-service-account"

podAnnotations: {}
podLabels: {}

podSecurityContext: {}
# fsGroup: 2000

securityContext: {}
# capabilities:
#   drop:
#   - ALL
# readOnlyRootFilesystem: true
# runAsNonRoot: true
# runAsUser: 1000

# ConfigMaps
configMaps:
  - name: my-configmap-1
    enabled: true
    data:
      key1: "value1"
      key2: "value2"
  - name: my-configmap-2
    enabled: false
    data:
      keyA: "valueA"
      keyB: "valueB"

# CronJobs
cronjobs:
  exampleCronJob1:
    enabled: true
    schedule: "*/5 * * * *"
    image: "busybox"
    imagePullPolicy: "IfNotPresent"
    command: ["/bin/sh", "-c"]
    args: ["echo Hello World"]
    env:
      EXAMPLE_ENV: "example-value"
    restartPolicy: "OnFailure"
  exampleCronJob2:
    enabled: false
    schedule: "0 0 * * *"
    image: "alpine"
    imagePullPolicy: "IfNotPresent"
    command: ["/bin/sh", "-c"]
    args: ["echo Hello from another CronJob"]
    env:
      EXAMPLE_ENV: "another-value"
    restartPolicy: "OnFailure"

# Secrets
secrets:
  - name: secret1
    enabled: true
    data:
      key1: "value1"
      key2: "value2"
  - name: secret2
    enabled: false
    data:
      keyA: "valueA"
      keyB: "valueB"

# Services
services:
  - name: service1
    enabled: true
    type: ClusterIP
    ports:
      - port: 8082
        targetPort: 8082
    healthcheck:
      type: http
      path: /health
  - name: service2
    enabled: false
    type: LoadBalancer
    ports:
      - port: 8085
        targetPort: 8085
    healthcheck:
      type: http
      path: /health

# Ingresses
ingress:
  - name: "ingress-1"
    enabled: true
    className: "nginx"
    hosts:
      - host: "meuapp-1.exemplo.com"
        paths:
          - path: "/"
            pathType: "Prefix"
            serviceName: "service1"
    tls:
      - hosts:
          - "meuapp.exemplo.com"
        secretName: "meuapp-tls"
  - name: "ingress-2"
    enabled: false
    className: "nginx"
    hosts:
      - host: "meuapp-2.exemplo.com"
        paths:
          - path: "/"
            pathType: "Prefix"
            serviceName: "service2"
    tls:
      - hosts:
          - "meuapp.exemplo.com"
        secretName: "meuapp-tls"

# Deployment
deployment:
  enabled: true

resources: {}
# limits:
#   cpu: 100m
#   memory: 128Mi
# requests:
#   cpu: 100m
#   memory: 128Mi

livenessProbe:
  httpGet:
    path: /
    port: http
readinessProbe:
  httpGet:
    path: /
    port: http

# HPA
hpa:
  enabled: false
  minReplicas: 1
  maxReplicas: 100
  targetCPUUtilizationPercentage: 80
  targetMemoryUtilizationPercentage: 80

volumes:
  - name: foo
    secret:
      secretName: mysecret
      optional: true
  - name: my-volume
    claimName: my-claim
    mountPath: /data

volumeMounts:
  - name: foo
    mountPath: "/etc/foo"
    readOnly: true
  - name: my-volume
    mountPath: "/etc/my-volume"
    readOnly: false

nodeSelector: {}

tolerations: []

affinity: {}
```

You can configure resources such as ConfigMaps, CronJobs, Secrets, Services, Ingresses, Volumes, and VolumeMounts individually or in multiples as needed.

The `enabled` option is a key feature in the `values.yaml` files of a Helm Chart, allowing control over whether a specific resource should be deployed or not. This option is particularly useful for flexibly configuring which resources are activated or deactivated in different environments or deployment scenarios. This function is available for these resources: ConfigMaps, CronJobs, Secrets, Services, Ingresses, HPA, and Deployment.