package compliance.policy.kube_api.minimize_assigned_capabilities

import data.compliance.lib.assert
import data.compliance.lib.common as lib_common
import data.compliance.policy.kube_api.data_adapter

default rule_evaluation = true

rule_evaluation = false {
	container := data_adapter.containers[_]
	capabilities := object.get(container.securityContext, "capabilities", [])
	not assert.array_is_empty(capabilities)
}

finding := result {
	data_adapter.is_kube_api
	data_adapter.containers

	# set result
	result := lib_common.generate_result_without_expected(
		lib_common.calculate_result(rule_evaluation),
		{"containers": {json.filter(c, ["name", "securityContext/capabilities"]) | c := data_adapter.containers[_]}},
	)
}
