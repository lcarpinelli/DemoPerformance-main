param location string = resourceGroup().location
param targetId string //"/subscriptions/6a37c895-4239-4b1e-bc34-a48c4994cc8a/resourceGroups/rg-poc-demo-performance/providers/Microsoft.ContainerService/managedClusters/demo-performance-aks/providers/Microsoft.Chaos/targets/Microsoft-AzureKubernetesServiceChaosMesh"

param steps array = [
  {
    name: 'Step 1'
    branches: [
      {
        name: 'Branch 1'
        actions: [
          {
            type: 'continuous'
            selectorId: 'Selector1'
            duration: 'PT10M'
            parameters: [
              {
                key: 'jsonSpec'
                value: '{"action":"pod-failure","mode":"all","duration":"600s","selector":{"namespaces":["default"]}}'
              }
            ]
            name: 'urn:csci:microsoft:azureKubernetesServiceChaosMesh:podChaos/2.1'
          }
        ]
      }
    ]
  }
  {
    name: 'ChaosMeshPodFaultsExperiment'
    stepName: 'AKS Pod kill'
    branchName: 'AKS Pod kill'
    action: {
      type: 'continuous'
      selectorId: 'Selector1'
      duration: 'PT10M'
      parameters: [
        {
          key: 'jsonSpec'
          value: '{"action":"pod-failure","mode":"all","duration":"600s","selector":{"namespaces":["default"]}}'
        }
      ]
      actionName: 'urn:csci:microsoft:azureKubernetesServiceChaosMesh:podChaos/2.1'
    }
  }
  {
    name: 'ChaosMeshStressFaultsExperiment'
    stepName: 'AKS stress'
    branchName: 'AKS stress'
    action: {
      type: 'continuous'
      selectorId: 'Selector1'
      parameters: [
        {
          key: 'jsonSpec'
          value: '{"mode":"one","selector":{"labelSelectors":{"app":"app1"}},"stressors":{"memory":{"workers":4,"size":"256MB"}}}'
        }
      ]
      actionName: 'urn:csci:microsoft:azureKubernetesServiceChaosMesh:stressChaos/2.1'
    }
  }
  {
    name: 'ChaosMeshHttpFaultsExperiment'
    stepName: 'AKS http chaos'
    branchName: 'AKS http chaos'
    action: {
      type: 'continuous'
      selectorId: 'Selector1'
      parameters: [
        {
          key: 'jsonSpec'
          value: '{"mode":"all","selector":{"labelSelectors":{"app":"nginx"}},"target":"Request","port":80,"method":"GET","path":"/api","abort":true,"duration":"5m","scheduler":{"cron":"@every 10m"}}'
        }
      ]
      actionName: 'urn:csci:microsoft:azureKubernetesServiceChaosMesh:httpChaos/2.1'
    }
  }
]

// module experiments 'modules/experiment.bicep' = [for item in actions: {
//   name: item.name
//   params: {
//     stepName: item.stepName
//     targetId: targetId
//     branchName: item.branchName
//     experimentName: item.name
//     location: location
//     actionName: item.action.actionName
//   }
// }]

// output servicePrincipal array = [for i in range(0, length(actions)): {
//   name: experiments[i].name
//   servicePrincipal: experiments[i].outputs.servicePrincipalId
// }]
