param location string = 'eastus'
param environment string
param webAppName string

resource plan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: 'asp-${environment}'
  location: location
  sku: {
    name: 'F1'
    tier: 'Free'
  }
  properties: {
    reserved: true
  }
}

resource web 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|9.0'
    }
  }
}

output webAppUrl string = 'https://${webAppName}.azurewebsites.net'
