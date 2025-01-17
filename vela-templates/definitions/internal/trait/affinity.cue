"affinity": {
	type: "trait"
	annotations: {}
	labels: {
		"ui-hidden": "true"
	}
	description: "affinity specify affinity and tolerationon K8s pod for your workload which follows the pod spec in path 'spec.template'."
	attributes: {
		appliesToWorkloads: ["*"]
		podDisruptive: true
	}
}
template: {
	patch: spec: template: spec: {
		if parameter.podAffinity != _|_ {
			affinity: podAffinity: {
				if parameter.podAffinity.required != _|_ {
					requiredDuringSchedulingIgnoredDuringExecution: [
						for k in parameter.podAffinity.required {
							if k.labelSelector != _|_ {
								labelSelector: k.labelSelector
							}
							if k.namespace != _|_ {
								namespace: k.namespace
							}
							topologyKey: k.topologyKey
							if k.namespaceSelector != _|_ {
								namespaceSelector: k.namespaceSelector
							}
						}]
				}
				if parameter.podAffinity.preferred != _|_ {
					preferredDuringSchedulingIgnoredDuringExecution: [
						for k in parameter.podAffinity.preferred {
							weight:          k.weight
							podAffinityTerm: k.podAffinityTerm
						}]
				}
			}
		}
		if parameter.podAntiAffinity != _|_ {
			affinity: podAntiAffinity: {
				if parameter.podAntiAffinity.required != _|_ {
					requiredDuringSchedulingIgnoredDuringExecution: [
						for k in parameter.podAntiAffinity.required {
							if k.labelSelector != _|_ {
								labelSelector: k.labelSelector
							}
							if k.namespace != _|_ {
								namespace: k.namespace
							}
							topologyKey: k.topologyKey
							if k.namespaceSelector != _|_ {
								namespaceSelector: k.namespaceSelector
							}
						}]
				}
				if parameter.podAntiAffinity.preferred != _|_ {
					preferredDuringSchedulingIgnoredDuringExecution: [
						for k in parameter.podAntiAffinity.preferred {
							weight:          k.weight
							podAffinityTerm: k.podAffinityTerm
						}]
				}
			}
		}
		if parameter.nodeAffinity != _|_ {
			affinity: nodeAffinity: {
				if parameter.nodeAffinity.required != _|_ {
					requiredDuringSchedulingIgnoredDuringExecution: nodeSelectorTerms: [
						for k in parameter.nodeAffinity.required.nodeSelectorTerms {
							if k.matchExpressions != _|_ {
								matchExpressions: k.matchExpressions
							}
							if k.matchFields != _|_ {
								matchFields: k.matchFields
							}
						}]
				}
				if parameter.nodeAffinity.preferred != _|_ {
					preferredDuringSchedulingIgnoredDuringExecution: [
						for k in parameter.nodeAffinity.preferred {
							weight:     k.weight
							preference: k.preference
						}]
				}
			}
		}
		if parameter.tolerations != _|_ {
			tolerations: [
				for k in parameter.tolerations {
					if k.key != _|_ {
						key: k.key
					}
					if k.effect != _|_ {
						effect: k.effect
					}
					if k.value != _|_ {
						value: k.value
					}
					operator: k.operator
					if k.tolerationSeconds != _|_ {
						tolerationSeconds: k.tolerationSeconds
					}
				}]
		}
	}

	#labelSelector: {
		matchLabels?: [string]: string
		matchExpressions?: [...{
			key:      string
			operator: *"In" | "NotIn" | "Exists" | "DoesNotExist"
			values?: [...string]
		}]
	}

	#podAffinityTerm: {
		labelSelector?: #labelSelector
		namespaces?: [...string]
		topologyKey:        string
		namespaceSelector?: #labelSelector
	}

	#nodeSelecor: {
		key:      string
		operator: *"In" | "NotIn" | "Exists" | "DoesNotExist" | "Gt" | "Lt"
		values?: [...string]
	}

	#nodeSelectorTerm: {
		matchExpressions?: [...#nodeSelecor]
		matchFields?: [...#nodeSelecor]
	}

	parameter: {
		// +usage=Specify the pod affinity scheduling rules
		podAffinity?: {
			// +usage=Specify the required during scheduling ignored during execution
			required?: [...#podAffinityTerm]
			// +usage=Specify the preferred during scheduling ignored during execution
			preferred?: [...{
				// +usage=Specify weight associated with matching the corresponding podAffinityTerm
				weight: int & >=1 & <=100
				// +usage=Specify a set of pods
				podAffinityTerm: #podAffinityTerm
			}]
		}
		// +usage=Specify the pod anti-affinity scheduling rules
		podAntiAffinity?: {
			// +usage=Specify the required during scheduling ignored during execution
			required?: [...#podAffinityTerm]
			// +usage=Specify the preferred during scheduling ignored during execution
			preferred?: [...{
				// +usage=Specify weight associated with matching the corresponding podAffinityTerm
				weight: int & >=1 & <=100
				// +usage=Specify a set of pods
				podAffinityTerm: #podAffinityTerm
			}]
		}
		// +usage=Specify the node affinity scheduling rules for the pod
		nodeAffinity?: {
			// +usage=Specify the required during scheduling ignored during execution
			required?: {
				// +usage=Specify a list of node selector
				nodeSelectorTerms: [...#nodeSelectorTerm]
			}
			// +usage=Specify the preferred during scheduling ignored during execution
			preferred?: [...{
				// +usage=Specify weight associated with matching the corresponding nodeSelector
				weight: int & >=1 & <=100
				// +usage=Specify a node selector
				preference: #nodeSelectorTerm
			}]
		}
		// +usage=Specify tolerant taint
		tolerations?: [...{
			key?:     string
			operator: *"Equal" | "Exists"
			value?:   string
			effect?:  "NoSchedule" | "PreferNoSchedule" | "NoExecute"
			// +usage=Specify the period of time the toleration
			tolerationSeconds?: int
		}]
	}
}
