@description('Azure region')
param location string

@description('Container Apps environment name')
param environmentName string

@description('Container App name')
param containerAppName string

@description('Container image (ACR or GHCR)')
param image string

@description('Azure Container Registry name (without .azurecr.io)')
param acrName string

// ---------------------------
// Log Analytics Workspace
// ---------------------------
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'log-${environmentName}'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

// ---------------------------
// Container Apps Environment
// ---------------------------
resource containerEnv 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: environmentName
  location: location
  dependsOn: [
    logAnalytics
  ]
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalytics.properties.customerId
        sharedKey: listKeys(logAnalytics.id, '2022-10-01').primarySharedKey
      }
    }
  }
}

// ---------------------------
// Container App
// ---------------------------
resource containerApp 'Microsoft.App/containerApps@2023-05-01' = {
  name: containerAppName
  location: location
  dependsOn: [
    containerEnv
  ]
  properties: {
    managedEnvironmentId: containerEnv.id

    configuration: {
      ingress: {
        external: true
        targetPort: 80
        transport: 'auto'
      }

      registries: [
        {
          server: '${acrName}.azurecr.io'
          username: listCredentials(
            resourceId('Microsoft.ContainerRegistry/registries', acrName),
            '2023-01-01-preview'
          ).username
          passwordSecretRef: 'acr-password'
        }
      ]

      secrets: [
        {
          name: 'acr-password'
          value: listCredentials(
            resourceId('Microsoft.ContainerRegistry/registries', acrName),
            '2023-01-01-preview'
          ).passwords[0].value
        }
      ]
    }

    template: {
      containers: [
        {
          name: 'myapp'
          image: image
          resources: {
            cpu: 0.5
            memory: '1Gi'
          }
        }
      ]

      scale: {
        minReplicas: 1
        maxReplicas: 2
      }
    }
  }
}

// ---------------------------
// Output
// ---------------------------
output appUrl string = 'https://${containerApp.properties.latestRevisionFqdn}'
