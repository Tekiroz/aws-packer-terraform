PACKER = cd packer

vagrant-init: ## Use Vagrant to test ansible playbooks in local.
	vagrant halt && vagrant destroy -f && vagrant up


ami-build:	## Check that the template is valid and then build the image from template.
	@${PACKER} && \
		packer validate aws-ubuntu.pkr.hcl &&\
		packer build aws-ubuntu.pkr.hcl