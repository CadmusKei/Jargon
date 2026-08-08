## Challenge 2 - Ansible Automation

Convert manual configuration into repeatable automation using Ansible (or equivalent). Roles must be idempotent and support clean reapplication.

### Expected Deliverables

- Playbooks/roles with inventory and variables.
- Automated setup for users, base-packages (eg. `nftables, btop, vim, scientific-packages`)
- Idempotence proof: second run with zero unintended changes.
- Documentation for bootstrap prerequisites and execution order.
- Markdown table showing task results before/after re-run.
