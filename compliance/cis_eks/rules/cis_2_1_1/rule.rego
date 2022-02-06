package compliance.cis_eks.rules.cis_2_1_1

import data.compliance.cis_eks
import data.compliance.lib.common
import data.compliance.lib.data_adapter

# Ensure that the kubeconfig file permissions are set to 644 or more restrictive
finding = result {
	# filter
	data_adapter.filename == "kubeconfig"

	# evaluate
	filemode := data_adapter.filemode
	rule_evaluation := common.file_permission_match(filemode, 6, 4, 4)

	# set result
	result := {
		"evaluation": common.calculate_result(rule_evaluation),
		"evidence": {"filemode": filemode},
	}
}

metadata = {
	"name": "2.1.1 Enable audit Logs",
	"description": `The audit logs are part of the EKS managed Kubernetes control plane logs that are managed by Amazon EKS.
Amazon EKS is integrated with AWS CloudTrail, a service that provides a record of actions taken by a user, role, or an AWS service in Amazon EKS.
CloudTrail captures all API calls for Amazon EKS as events.
The calls captured include calls from the Amazon EKS console and code calls to the Amazon EKS API operations.`,
	"rationale": `Exporting logs and metrics to a dedicated,
persistent datastore such as CloudTrail ensures availability of audit data following a cluster security event,
and provides a central location for analysis of log and metric data collated from multiple sources.`,
	"impact": `Audit logs will be created on the master nodes, which will consume disk space.
Care should be taken to avoid generating too large volumes of log information as this could impact the available of the cluster nodes.
S3 lifecycle features can be used to manage the accumulation and management of logs over time.`,
	"tags": array.concat(cis_eks.default_tags, ["CIS 2.1.1", "Logging"]),
	"default_value": `By default, cluster control plane logs aren't sent to CloudWatch Logs.
When you enable a log type, the logs are sent with a log verbosity level of 2.
To enable or disable control plane logs with the console.
Open the Amazon EKS console at https://console.aws.amazon.com/eks/home#/clusters.
Amazon EKS Information in CloudTrail CloudTrail is enabled on your AWS account when you create the account.
When activity occurs in Amazon EKS, that activity is recorded in a CloudTrail event along with other AWS service events in Event history.`
	"benchmark": cis_eks.benchmark_name,
	"remediation": `aws --region "${REGION_CODE}" eks describe-cluster --name "${CLUSTER_NAME}" --query 'cluster.logging.clusterLogging[?enabled==true].types`,
}