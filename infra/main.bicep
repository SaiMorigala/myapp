param location string = 'eastus'
param environmentName string
param containerAppName string
param image string

// Create Container Apps Environment
resource containerEnv 'Microsoft.App/managedEnvironments@2022-03-01' = {
  name: environmentName
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
    }
  }
}

// Create Container App
resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: containerAppName
  location: location
  properties: {
    managedEnvironmentId: containerEnv.id
    configuration: {
      ingress: {
        external: true
        targetPort: 80
      }
    }
    template: {
      containers: [
        {
          name: containerAppName
          image: image
          resources: {
            cpu: '0.5'
            memory: '1Gi'
          }
        }
      ]
    }
  }
}

output containerAppUrl string = 'https://${containerAppName}.${location}.azurecontainerapps.io'
