
## Play structure

```yaml
---
- name: Description of what this play does
  hosts: headnode          # group from inventory.ini
  tasks:
    - name: Task description
      module_name:
        param1: value
        param2: value
      become: yes          # sudo only on tasks that need it
```

> Indentation is strict — 2 spaces per level, no tabs.

---

## dnf module — package management

### Install one package

```yaml
- name: Install wget
  dnf:
    name: wget
    state: present
  become: yes
```

### Install multiple packages

```yaml
- name: Install dependencies
  dnf:
    name:
      - openmpi
      - openmpi-devel
      - atlas
      - atlas-devel
    state: present
  become: yes
```

### Update all packages

```yaml
- name: Update system
  dnf:
    name: "*"
    state: latest
  become: yes
```

### state values for dnf

|state|meaning|
|---|---|
|`present`|install if not already installed|
|`latest`|install or upgrade to latest version|
|`absent`|uninstall the package|

---

## shell / command modules

Use `shell` for chaining (`&&`), pipes (`|`), redirects (`>`). Use `command` for simple single commands.

### Basic shell task

```yaml
- name: Echo something
  shell: echo "hello" > /home/kei/test.txt
```

### args — extra shell options

|arg|meaning|
|---|---|
|`chdir`|run command from this directory|
|`creates`|skip task if this file/folder already exists|
|`removes`|skip task if this file/folder does not exist|
|`executable`|use a specific shell (e.g. /bin/bash)|

```yaml
- name: Download and extract HPL
  shell: wget http://example.com/hpl.tar.gz && tar -xzf hpl.tar.gz && mv hpl-2.3 /home/kei/hpl
  args:
    creates: /home/kei/hpl
    chdir: /home/kei
```

### Capture and print output

```yaml
- name: Run something
  shell: echo "hello"
  register: result

- name: Show output
  debug:
    msg: "{{ result.stdout }}"
```

---

## file module — files and folders

|state|meaning|
|---|---|
|`absent`|delete the file/folder if it exists|
|`directory`|create as a folder if it doesn't exist|
|`touch`|create empty file if it doesn't exist|
|`file`|ensure file exists (used with mode/owner)|

```yaml
- name: Delete tarball
  file:
    path: /home/kei/hpl-2.3.tar.gz
    state: absent

- name: Create output dir
  file:
    path: /home/kei/results
    state: directory
```

---

## replace module — edit files

Idempotent — only changes the file if the pattern matches. Use for editing config files and Makefiles.

```yaml
- name: Set ARCH in Makefile
  replace:
    path: /home/kei/hpl/Make.Jargon
    regexp: 'ARCH\s*=.*'
    replace: 'ARCH = Jargon'
```

---

## Running a playbook

```bash
ansible-playbook -i inventory.ini basicHPL.yml --ask-become-pass
```

|flag|meaning|
|---|---|
|`-i inventory.ini`|specify the inventory file|
|`--ask-become-pass`|prompt for sudo password|
|`--check`|dry run — show what would change without doing it|
|`-v / -vv / -vvv`|increase verbosity for debugging|

---

## Key concepts

| concept       | meaning                                                                              |
| ------------- | ------------------------------------------------------------------------------------ |
| idempotent    | safe to run multiple times — same result each time                                   |
| `become: yes` | sudo for that task (put on task, not play level)                                     |
| `register`    | save task output to a variable                                                       |
| `{{ var }}`   | Jinja2 — reference a variable                                                        |
| `ok`          | task ran, nothing needed changing                                                    |
| `changed`     | task ran and made a change                                                           |
| `failed`      | task errored out                                                                     |
| `creates`     | tells Ansible what a shell task is responsible for creating — skip if already exists |
| `removes`     | skip shell task if this file does not exist                                          |