## Dependencies

 * Terraform
 * Ansible

## Usage

Configuration is handled by a mix of environment variables, to manage your AWS credentials, and Makefile variables to handle the actual installation of Jenkins on the infrastructure this tool creates.

Prefix the `make` command with any AWS environment variables you need. For example, you may want to use a specific credentials profile, or specify a region.

The following is a list of variables that are required by the `make` tool:

 * **project_name** This is used in the Jenkins pipeline view
 * **jenkins_auth_user** Jenkins is protected by HTTP basic auth, this is the user that will grant you access
 * **jenkins_auth_password** As above, this is the password for HTTP auth
 * **repo** The repository for the project pipeline to use. For private repositories it's best to use Git over HTTP, and to include an OAuth token in the URL scheme. See example below

To help simplify the setup of the pipeline, the repositories currently have to be either Public or Private, accessible over HTTP with an OAuth token. This alleviates the need for SSH setup on the Jenkins machine. Support is planned for the future. The HTTP url scheme for a private repo should be as follows:

```
https://OAUTH_TOKEN_HERE:x-oauth-basic@github.com/YOUR_USERNAME/YOUR_REPO.git
```

Be sure to substitute `OAUTH_TOKEN_HERE`, `YOUR_USERNAME` and `YOUR_REPO`.

Putting all of this together, you can run:

```
AWS_REGION=eu-west-1 \
make jenkins \
project_name='TestProject' \
jenkins_auth_user=jenkins jenkins_auth_password=testing \
repo='https://OAUTH_TOKEN_HERE:x-oauth-basic@github.com/YOUR_USERNAME/YOUR_REPO.git'
```
