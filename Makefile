.PHONY: test

test:
	pipenv run ansible-playbook -i jumphost/tests/inventory.yml jumphost/tests/test.yml -v
