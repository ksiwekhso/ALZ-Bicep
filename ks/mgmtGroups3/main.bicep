targetScope = 'tenant'

param managementGroupObject object

var prefix = managementGroupObject.managementGroupPrefix
var suffix = managementGroupObject.managementGroupSuffix

// TIER ONE, ROOT
resource tierOne 'Microsoft.Management/managementGroups@2021-04-01' = [for mg in managementGroupObject.tier1: {
  name: toLower('${prefix}-${mg.name}-${suffix}')
  properties: {
    displayName: empty(mg.parent) ? '${mg.displayName}' : '${toUpper(prefix)} ${mg.displayName}'
    details: {
      parent: {
        id: empty(mg.parent) ? resourceId('Microsoft.Management/managementGroups', tenant().tenantId) : resourceId('Microsoft.Management/managementGroups', '${prefix}-${mg.parent}-${suffix}')
      }
    }
  }
}]

resource tierTwo 'Microsoft.Management/managementGroups@2021-04-01' = [for mg in managementGroupObject.tier2: {
  dependsOn: tierOne
  name: toLower('${prefix}-${mg.name}-${suffix}')
  properties: {
    displayName: '${toUpper(prefix)} ${mg.displayName}'
    details: {
      parent: {
        id: resourceId('Microsoft.Management/managementGroups', '${prefix}-${mg.parent}-${suffix}')
      }
    }
  }
}]

resource tierThree 'Microsoft.Management/managementGroups@2021-04-01' = [for mg in managementGroupObject.tier3: {
  dependsOn: tierTwo
  name: toLower('${prefix}-${mg.name}-${suffix}')
  properties: {
    displayName: '${toUpper(prefix)} ${mg.displayName}'
    details: {
      parent: {
        id: resourceId('Microsoft.Management/managementGroups', '${prefix}-${mg.parent}-${suffix}')
      }
    }
  }
}]

resource tierFour 'Microsoft.Management/managementGroups@2021-04-01' = [for mg in managementGroupObject.tier4: {
  dependsOn: tierThree
  name: toLower('${prefix}-${mg.name}-${suffix}')
  properties: {
    displayName: '${toUpper(prefix)} ${mg.displayName}'
    details: {
      parent: {
        id: resourceId('Microsoft.Management/managementGroups', '${prefix}-${mg.parent}-${suffix}')
      }
    }
  }
}]

resource tierFive 'Microsoft.Management/managementGroups@2021-04-01' = [for mg in managementGroupObject.tier5: {
  dependsOn: tierFour
  name: toLower('${prefix}-${mg.name}-${suffix}')
  properties: {
    displayName: '${toUpper(prefix)} ${mg.displayName}'
    details: {
      parent: {
        id: resourceId('Microsoft.Management/managementGroups', '${prefix}-${mg.parent}-${suffix}')
      }
    }
  }
}]

resource tierSix 'Microsoft.Management/managementGroups@2021-04-01' = [for mg in managementGroupObject.tier6: {
  dependsOn: tierFive
  name: toLower('${prefix}-${mg.name}-${suffix}')
  properties: {
    displayName: '${toUpper(prefix)} ${mg.displayName}'
    details: {
      parent: {
        id: resourceId('Microsoft.Management/managementGroups', '${prefix}-${mg.parent}-${suffix}')
      }
    }
  }
}]

// Set default management group for subscriptions if specified in parameters
resource mgSettings 'Microsoft.Management/managementGroups/settings@2021-04-01' = if (!empty(managementGroupObject.defaultManagementGroup)) {
  name: '${tenant().tenantId}/default'
  properties: {
    defaultManagementGroup: resourceId('Microsoft.Management/managementGroups', '${prefix}-${managementGroupObject.defaultManagementGroup}-${suffix}')
    requireAuthorizationForGroupCreation: managementGroupObject.requireAuthorizationForGroupCreation
  }
}
