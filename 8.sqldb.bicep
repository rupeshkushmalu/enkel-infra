param psqldatabaseName string 
param pDatabaseSkuName string 
param pDatabaseSkuTier string 
param pDatabaseCollation string 
param psqldatabasemaxsize int
param ptags object 
param psqlServerName string
param plocation string = 'Central India'

@allowed([
  'Local'
  'Geo'
  'GeoZone'
  'Zone'
])
param prequestedBackupStorageRedundancy string

resource sqlServer 'Microsoft.Sql/servers@2021-11-01' existing = {
  name: psqlServerName
}

resource sqlServerDatabase 'Microsoft.Sql/servers/databases@2021-11-01' = {
  parent: sqlServer
  tags: ptags
  name: psqldatabaseName
  location: plocation
  sku: {
    name: pDatabaseSkuName
    tier: pDatabaseSkuTier
  }
  properties: {
    requestedBackupStorageRedundancy: prequestedBackupStorageRedundancy
    collation: pDatabaseCollation
    maxSizeBytes: psqldatabasemaxsize
    zoneRedundant:false
  }
}

output sqlServerDatabaseName string = sqlServerDatabase.name
output sqlServerDatabaseId string = sqlServerDatabase.id
