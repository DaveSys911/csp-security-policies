# Cloud Security Posture security policies 
    .
    ├── compliance                             # Compliance policies
    │   ├── lib
    │   │   ├── common.rego                    # Common functions
    │   │   ├── osquery.rego                   # OSQuery input parser
    │   │   └── ...
    │   ├── rules/cis                          # End-to-end, integration tests 
    │   │   ├── cis_1_1_1                      # package per rule
    │   │   │   ├── cis_1_1_1.rego             # rule implementation in rego
    │   │   │   ├── test                       # tests folder per rule
    │   │   │   │   └── cis_1_1_1_test.rego
    │   │   └── ...
    │   └── cis.rego                           # Handles rule evalutation at the CIS policy
    └── main.rego                              # Evaluate all policies and returns the findings
    
## Local Evaluation
Add the following configuration files into the root folder
##### `data.yaml`
should contain the list of rules you want to evaluate (also supports json)

```yaml
activated_rules:
  cis_1_1_1: true
  cis_1_1_2: true
```

##### `input.json`
should contain an beat/agent output, e.g. OSQuery

```json
{
  "osquery": {
    "mode": "0700",
    "path": "/hostfs/etc/kubernetes/manifests/kube-apiserver.yaml",
    "uid": "etc",
    "filename": "kube-apiserver.yaml",
    "gid": "root"
  }
}
```

### Evaluate entire policy into output.json
`opa eval data.main --format pretty -i input.json -b . > output.json`

### Evaluate findings only
`opa eval data.main.findings --format pretty -i input.json -b . > output.json`

<details> 
<summary>Example output</summary>
  
```json
[
  {
    "evaluation": "violation",
    "fields": [
      {
        "key": "filemode",
        "value": "0700"
      }
    ],
    "rule_name": "Ensure that the API server pod specification file permissions are set to 644 or more restrictive",
    "tags": [
      "CIS",
      "CIS v1.6.0",
      "Kubernetes",
      "CIS 1.1.1"
    ]
  },
  {
    "evaluation": "violation",
    "fields": [
      {
        "key": "uid",
        "value": "etc"
      },
      {
        "key": "gid",
        "value": "root"
      }
    ],
    "rule_name": "Ensure that the API server pod specification file ownership is set to root:root",
    "tags": [
      "CIS",
      "CIS v1.6.0",
      "Kubernetes",
      "CIS 1.1.2"
    ]
  }
]

```
  
</details>

## Local Testing
### Test entire policy
`opa test -v compliance`