.PHONY: init update-chart upload-chart package clean deploy-default-profile iterate debug deploy-custom-profile-canary deploy-custom-profile-bluegreen deploy-custom-whale-canary deploy-custom-whale-bluegreen

init:
	@echo "Running init..."
	@humctl create app ${HUMANITEC_APP}
	@$(MAKE) package
	@$(MAKE) upload-chart
	@$(MAKE) update-chart
	@$(MAKE) deploy-custom-profile-canary

iterate:
	@echo "Running iterate..."
	@$(MAKE) package
	@$(MAKE) upload-chart
	@$(MAKE) deploy-custom-profile-canary

debug:
	@echo "Running debug..."
	@cd workloadProfile && \
	helm template . -f sample-new-bluegreen.yaml --debug

update-chart:
	@echo "Running update-chart..."
	@cd workloadProfile && \
	version=$$(yq e .version Chart.yaml) && \
	payload=$$(cat profile.json | jq -rM '. + {"id": "'${WORKLOAD_PROFILE}'", "version": "'${version}'", "workload_profile_chart": { "id": "'${WORKLOAD_PROFILE}'", "version": "latest" } }') && \
	humctl api post /orgs/${HUMANITEC_ORG}/workload-profiles -d "$$payload" > /dev/null

upload-chart:
	@echo "Running upload-chart..."
	@curl "https://api.humanitec.io/orgs/${HUMANITEC_ORG}/workload-profile-chart-versions" \
	-X POST \
	-H "Authorization: Bearer ${HUMANITEC_TOKEN}" \
	-F "file=@chart.tgz" > /dev/null

package:
	@echo "Running package... bumping patch version before that..."
	@cd workloadProfile && \
	version=$$(semver -i patch $$(yq e .version Chart.yaml)) && \
	yq e -i '.version = "'$$version'"' Chart.yaml
	@rm -f *.tgz
	@helm package workloadProfile
	@cp *.tgz chart.tgz

clean:
	@echo "Running clean..."
	@rm -rf *.tgz
	@humctl api DELETE /orgs/${HUMANITEC_ORG}/workload-profiles/${WORKLOAD_PROFILE}
	@humctl delete app ${HUMANITEC_APP}

deploy-custom-profile-canary:
	@echo "Running deploy with custom profile..."
	@humctl score deploy --file app/score.yaml --extensions app/canary.humanitec.score.yaml

deploy-custom-profile-bluegreen:
	@echo "Running deploy with custom profile..."
	@humctl score deploy --file app/score.yaml --extensions app/bluegreen.humanitec.score.yaml

deploy-custom-whale-canary:
	@echo "Running deploy with custom profile... and whales..."
	@humctl score deploy --file app/score_whale.yaml --extensions app/canary.humanitec.score.yaml

deploy-custom-whale-bluegreen:
	@echo "Running deploy with custom profile... and whales..."
	@humctl score deploy --file app/score_whale.yaml --extensions app/bluegreen.humanitec.score.yaml

deploy-default-profile:
	@echo "Running deploy with default profile..."
	@humctl score deploy --file app/score.yaml