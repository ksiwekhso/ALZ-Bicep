targetScope = 'tenant'

param managementGroupObject object

// TIER ONE, ROOT
resource tierOne 'Microsoft.Management/managementGroups@2021-04-01' = [for mg in managementGroupObject.tier1: {
  name: toLower('${mg.name}')
  properties: {
    displayName: empty(mg.parent) ? '${mg.displayName}' : '${mg.displayName}'
    details: {
      parent: {
        id: empty(mg.parent) ? resourceId('Microsoft.Management/managementGroups', tenant().tenantId) : resourceId('Microsoft.Management/managementGroups', '${mg.parent}')
      }
    }
}
}]

resource tierTwo 'Microsoft.Management/managementGroups@2021-04-01' = [for mg in managementGroupObject.tier2: {
  dependsOn: tierOne
  name: toLower('${mg.name}')
  properties: {
    displayName: '${mg.displayName}'
    details: {
      parent: {
        id: resourceId('Microsoft.Management/managementGroups', '${mg.parent}')
      }
    }
  }
}]

resource tierThree 'Microsoft.Management/managementGroups@2021-04-01' = [for mg in managementGroupObject.tier3: {
  dependsOn: tierTwo
  name: toLower('${mg.name}')
  properties: {
    displayName: '${mg.displayName}'
    details: {
      parent: {
        id: resourceId('Microsoft.Management/managementGroups', '-${mg.parent}')
      }
    }
  }
}]

resource tierFour 'Microsoft.Management/managementGroups@2021-04-01' = [for mg in managementGroupObject.tier4: {
  dependsOn: tierThree
  name: toLower('${mg.name}-')
  properties: {
    displayName: '${mg.displayName}'
    details: {
      parent: {
        id: resourceId('Microsoft.Management/managementGroups', '${mg.parent}')
      }
    }
  }
}]

resource tierFive 'Microsoft.Management/managementGroups@2021-04-01' = [for mg in managementGroupObject.tier5: {
  dependsOn: tierFour
  name: toLower('${mg.name}')
  properties: {
    displayName: '{${mg.displayName}'
    details: {
      parent: {
        id: resourceId('Microsoft.Management/managementGroups', '${mg.parent}')
      }
    }
  }
}]

resource tierSix 'Microsoft.Management/managementGroups@2021-04-01' = [for mg in managementGroupObject.tier6: {
  dependsOn: tierFive
  name: toLower('${mg.name}')
  properties: {
    displayName: '${mg.displayName}'
    details: {
      parent: {
        id: resourceId('Microsoft.Management/managementGroups', '${mg.parent}')
      }
    }
  }
}]

// Set default management group for subscriptions if specified in parameters
//resource mgSettings 'Microsoft.Management/managementGroups/settings@2021-04-01' = if (!empty(managementGroupObject.defaultManagementGroup)) {
 // name: '${tenant().tenantId}/default'
 // properties: {
  //  defaultManagementGroup: resourceId('Microsoft.Management/managementGroups', '${managementGroupObject.defaultManagementGroup}')
  //  requireAuthorizationForGroupCreation: managementGroupObject.requireAuthorizationForGroupCreation
 // }
//}
