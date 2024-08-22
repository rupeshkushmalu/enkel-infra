param pStorageAccountName string

resource azurebicepstorageservice 'Microsoft.Storage/storageAccounts@2022-05-01' existing= {
  name: pStorageAccountName
}

resource azurebicepblobstaorageservice 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01'={
  name: 'default'
  parent:azurebicepstorageservice
}
