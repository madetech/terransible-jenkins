remote_user = ubuntu
ssh_key_name = keys/terransible_provisioner

ansible/ec2.py:
	curl -o ansible/ec2.py \
		https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py
	chmod u+x ansible/ec2.py

ansible/ec2.ini:
	curl -o ansible/ec2.ini \
		https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.ini

ansible/roles/geerlingguy.java:
	ansible-galaxy install geerlingguy.java -p ansible/roles

ansible/roles/geerlingguy.jenkins:
	ansible-galaxy install geerlingguy.jenkins -p ansible/roles

ansible/roles/MichaelRigart.brightbox-ruby:
	ansible-galaxy install MichaelRigart.brightbox-ruby -p ansible/roles

ansible/roles/mjanser.cloudfoundry-cli:
	ansible-galaxy install mjanser.cloudfoundry-cli -p ansible/roles

ansible_roles: ansible/roles/geerlingguy.java ansible/roles/geerlingguy.jenkins ansible/roles/MichaelRigart.brightbox-ruby ansible/roles/mjanser.cloudfoundry-cli

ansible: ansible/ec2.ini ansible/ec2.py ansible_roles

keys:
	mkdir keys
	ssh-keygen -t rsa \
		-C terransible_provisioner \
		-f $(ssh_key_name) \
		-P ''

clean:
	rm -rf ansible/roles/geerling*
	rm -rf ansible/roles/MichaelRigart.brightbox-ruby
	rm -rf ansible/roles/mjanser.cloudfoundry-cli
	rm ansible/ec2.py
	rm ansible/ec2.ini
	rm -rf keys

build: keys
	terraform apply

provision: ansible
	ANSIBLE_HOST_KEY_CHECKING=false \
	ANSIBLE_REMOTE_USER=$(remote_user) \
	ANSIBLE_PRIVATE_KEY_FILE=$(ssh_key_name) \
	ansible-playbook -i ansible/ec2.py ansible/site.yml \
		--extra-vars='{"pipeline_repo":"$(repo)", "pipeline_project_name":"$(project_name)", "jenkins_auth_user": "$(jenkins_auth_user)", "jenkins_auth_password": "$(jenkins_auth_password)"}'

jenkins: build provision
