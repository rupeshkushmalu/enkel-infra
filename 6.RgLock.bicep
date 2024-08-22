param prgLock string

resource symbolicname 'Microsoft.Authorization/locks@2020-05-01' = {
  name: prgLock
  properties: {
    level: 'CanNotDelete'
    notes: 'Resource group should not be deleted'
  }
}
