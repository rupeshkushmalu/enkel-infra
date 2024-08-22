param ptags object 
param psqlServerName string 
param plocation string = 'Central India'

@secure()
param administratorLogin string

@secure()
param administratorLoginPassword string

resource sqlServer 'Microsoft.Sql/servers@2021-11-01' ={
  name: psqlServerName
  location: plocation
  tags: ptags
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

resource sqlfirewall 'Microsoft.Sql/servers/firewallRules@2023-05-01-preview' = {
  name: 'sqlfirewall'
  parent: sqlServer
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

output sqlServerName string = sqlServer.name
