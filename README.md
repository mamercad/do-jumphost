[![GitHub Super-Linter](https://github.com/mamercad/do-jumphost/workflows/Lint%20Code%20Base/badge.svg)](https://github.com/marketplace/actions/super-linter)

# jumphost

Sets up a jump host<sup>[1](jump)</sup> (or, bastion host<sup>[2](bastion)</sup>) in the [DigitalOcean](https://cloud.digitalocean.com/) ☁️. And yes, I'm doing footnotes strangely because I didn't even realize they weren't actually supported in GitHub flavored Markdown<sup>[3](ghmd)</sup> until about 7 minutes ago.

This repository contains an [Ansible](https://www.ansible.com/) role named, surprise, `jumphost` and makes use of [`pipenv`](https://pipenv-fork.readthedocs.io/en/latest/).

Before doing things, keep in mind, Droplets aren't free. Be sure and *look at* the default [inventory](jumphost/tests/inventory.yml):

```yaml
all:
  hosts:
    localhost:
  vars:
    jumphost:
      name: jumphost
      unique_name: yes
      image: ubuntu-18-04-x64
      size: 1gb
      region: "{{ lookup('env', 'DO_REGION') | default('nyc3') }}"
      monitoring: yes
      private_networking: yes
      ssh_keys:
        - "{{ lookup('env', 'DO_SSH_KEY_ID') }}"
      oauth_token: "{{ lookup('env', 'DO_API_TOKEN') }}"
```

To kick it off, make sure that the following environment variables are set:

* `DO_API_TOKEN`
* `DO_REGION`
* `DO_SSH_KEY_ID`

Then, run `make test`:

```bash
❯ make test
pipenv run ansible-playbook -i jumphost/tests/inventory.yml jumphost/tests/test.yml -v

...

TASK [jumphost : Show the jump host's IP information] *********************************************************************************************************
ok: [localhost] =>
  msg: |-
    ssh root@12.34.56.78
    ssh root@10.108.0.11

PLAY RECAP ****************************************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Easy enough:

```bash
❯ ssh root@12.34.56.78 uptime
 06:17:32 up 11 min,  0 users,  load average: 0.00, 0.04, 0.06
```

That's a wrap! (And, no, I didn't hit the IP lottery, I redacted away the real IP address, heh.)

---

1. <a name="jump"></a> https://en.wikipedia.org/wiki/Jump_server
1. <a name="bastion"></a> https://en.wikipedia.org/wiki/Bastion_host
1. <a name="ghmd"></a> https://guides.github.com/features/mastering-markdown/
