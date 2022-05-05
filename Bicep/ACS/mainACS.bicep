param location string = resourceGroup().id
//param targetId string //"/subscriptions/6a37c895-4239-4b1e-bc34-a48c4994cc8a/resourceGroups/rg-poc-demo-performance/providers/Microsoft.ContainerService/managedClusters/demo-performance-aks/providers/Microsoft.Chaos/targets/Microsoft-AzureKubernetesServiceChaosMesh"
param experimentName string
param aksName string

param stepName string //AKS Pod kill
param branchName string //AKS Pod kill
param actionName string //'urn:csci:microsoft:azureKubernetesServiceChaosMesh:podChaos/2.1'

param actionValue string //
param duration string

var targetId = '/subscriptions/${ subscription().id }/resourceGroups/${ resourceGroup().id }/providers/Microsoft.ContainerService/managedClusters/${ aksName }/providers/Microsoft.Chaos/targets/Microsoft-AzureKubernetesServiceChaosMesh'
var actionNameComplete = 'urn:csci:microsoft:azureKubernetesServiceChaosMesh:${ actionName }/2.1'

resource experiment 'Microsoft.Chaos/experiments@2021-09-15-preview' = {
  name: experimentName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    selectors: [
      {
        type: 'List'
        id: 'Selector1'
        targets: [
          {
            id: targetId
            type: 'ChaosTarget'
          }
        ]
      }
    ]
    steps: [
      {
        name: stepName
        branches: [
          {
            name: branchName
            actions: [
              {
                type: 'continuous'
                selectorId: 'Selector1'
                duration: duration //'PT10M'
                parameters: [
                  {
                    key: 'jsonSpec'
                    value: actionValue //'{"action":"pod-failure","mode":"all","duration":"600s","selector":{"namespaces":["default"]}}'
                  }
                ]
                name: actionNameComplete
              }
            ]
          }
        ]
      }
    ]
  }
}

output servicePrincipalId string = experiment.identity.principalId
