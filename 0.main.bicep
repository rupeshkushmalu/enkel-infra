@description('Location for all resources.')
param plocation string = resourceGroup().location

param pTags object 

param pcontainerAppEnvName string

param pcontainerAppLogAnalyticsName string

param pcontainerAppbackendName string

param pcontainerAppFrontendName string

@description('Name of the SQL server')
param psqlServerName string 

@description('Name of the SQL server')
param psqldatabasemaxsize int

@description('Name of the SQL Database')
param psqldatabaseName string 

@allowed([
  'Local'
  'Geo'
  'GeoZone'
  'Zone'
])
param prequestedBackupStorageRedundancy string

@description('Name of Sku for SQL Database')
param pDatabaseSkuName string 

@description('SkuTier used for SQL Database')
param pDatabaseSkuTier string 

@description('Name of Sku for SQL DatabaseCollaction')
param pDatabaseCollation string 

@description('administrator User name to login SQL Database')
param administratorLogin string 

@description('The name of the SQL Server password')
@secure()
param pSqlServerPassword string

@description('Storage Account type')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param pStorageAccountType string 

@description('The name of the Storage Account')
param pStorageAccountName string 

@description('The name of the ACR')
param pacrName string

@description('The name of the Key Vault')
param pkeyVaultName string

@description('The name of the Resource Group Lock')
param prgLock string

@description('The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Get it by using Get-AzADUser or Get-AzADServicePrincipal cmdlets.')
param pobjectId string

module acr '1.Acr.bicep' = {
  name: 'acr'
  params: {
    acrName: pacrName
    plocation: plocation
  }
}

module rollassignmentFrontend '2.RollAssignments.bicep' = {
  name: 'rollassignmentFrontend'
  params: {
    acrName: acr.outputs.acrName
    acaName: containerAppFrontend.outputs.acaName
  }
  dependsOn: [
    acr
    aca
    containerAppFrontend
  ]
}

module rollassignmentBackend '2.RollAssignments.bicep' = {
  name: 'rollassignmentBackend'
  params: {
    acrName: acr.outputs.acrName
    acaName: containerAppFrontend.outputs.acaName
  }
  dependsOn: [
    acr
    aca
    containerAppBackend
  ]
}

module StorageAccount '3.StorageAccount.bicep' = {
  name: 'StorageAccount'
  params: {
    plocation: plocation
    pStorageAccountName: pStorageAccountName
    pStorageAccountType: pStorageAccountType
    pTags: pTags
  }
}

module KeyVault '5.KeyVault.bicep' = {
  name: 'KeyVault'
  params: {
    keyVaultName: pkeyVaultName
    objectId: pobjectId
    pTags: pTags
    plocation: plocation
  }
}

module BlobStorage '4.AzureBlobStorage.bicep' = {
  name: 'BlobStorage'
  params: {
    pStorageAccountName: pStorageAccountName
  }
  dependsOn: [
    StorageAccount
  ]
}

module rgLock '6.RgLock.bicep' = {
  name: 'rgLock'
  params: {
    prgLock: prgLock
  }
}

module sqlserver '7.sqlserver.bicep' = {
  name: 'sqlserver'
  params: {
    psqlServerName: psqlServerName
    administratorLogin: administratorLogin
    administratorLoginPassword: pSqlServerPassword
    plocation: 'Central India'
    ptags: pTags
  }
}

module sqldb '8.sqldb.bicep' = {
  name: 'sqldb'
  params: {
    pDatabaseCollation: pDatabaseCollation
    pDatabaseSkuName: pDatabaseSkuName
    pDatabaseSkuTier: pDatabaseSkuTier
    prequestedBackupStorageRedundancy: prequestedBackupStorageRedundancy
    psqlServerName: psqlServerName
    psqldatabaseName: psqldatabaseName
    psqldatabasemaxsize: psqldatabasemaxsize
    ptags: {}
    plocation: 'Central India'
  }
  dependsOn: [
    sqlserver
  ]
}

module aca '9.containerAppEnv.bicep' = {
  name: 'aca'
  params: {
    containerAppEnvName: pcontainerAppEnvName
    containerAppLogAnalyticsName: pcontainerAppLogAnalyticsName
    plocation: plocation
  }
}

module containerAppFrontend '10.containerApp.bicep' = {
  name: 'containerAppFrontend'
  params: {
    containerAppEnvName: pcontainerAppEnvName
    containerAppName: pcontainerAppFrontendName
    incressExternal: true
    plocation: plocation
  }
  dependsOn: [
    aca
  ]
}

module containerAppBackend '10.containerApp.bicep' = {
  name: 'containerAppBackend'
  params: {
    containerAppEnvName: pcontainerAppEnvName
    containerAppName: pcontainerAppbackendName
    incressExternal: false
    plocation: plocation
  }
  dependsOn: [
    aca
  ]
}
