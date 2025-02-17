# Argo Rollouts - Custom Workload Profile

This project contains a custom workload profile that utilizes Argo Rollouts to facilitate the rollout of deployments.

## Project Structure

- `app/`: Contains application-specific configuration files.
  - `bluegreen.humanitec.score.yaml`
  - `canary.humanitec.score.yaml`
  - `score_whale.yaml`
  - `score.yaml`
- `workloadprofile/`: Contains workload profile configurations and templates.
  - `Chart.yaml`
  - `profile.json`
  - `README.md`
  - `sample-minimal.yaml`
  - `sample-new-bluegreen.yaml`
  - `sample-new-canary.yaml`
  - `sample-new-schema.yaml`
  - `templates/`: Contains Helm templates.
    - `_feature_container.tpl`
    - `_feature_deployment.tpl`
    - `_feature_pod.tpl`
    - `_feature_volumes.tpl`
    - `_helpers.tpl`
    - `_k8s_podtemplatespec.tpl`
    - `_utils.tpl`
    - `configmap.yaml`
    - `extra_objects.yaml`
    - `rollout.yaml`
    - `service.yaml`
  - `values.yaml`

## Makefile Targets

- `init`: Initialize the project.
- `update-chart`: Update the chart version.
- `upload-chart`: Upload the chart to Humanitec.
- `package`: Package the Helm chart.
- `clean`: Clean up generated files.
- `deploy-default-profile`: Deploy using the default profile.
- `deploy-custom-profile-canary`: Deploy using the custom canary profile.
- `deploy-custom-profile-bluegreen`: Deploy using the custom blue-green profile.
- `deploy-custom-whale-canary`: Deploy using the custom whale canary profile.
- `deploy-custom-whale-bluegreen`: Deploy using the custom whale blue-green profile.
- `iterate`: Iterate the deployment process.
- `debug`: Debug the Helm template.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## More Information

For more information, visit [clearco.de](https://clearco.de).