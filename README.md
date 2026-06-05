# Jargon Progress Repository

A repository to track our progress and store benchmark screenshots as we prepare for the CHPC 2026 Student Cluster Competition, representing the University of the Western Cape.

## Repository Structure

```
Jargon/
├── __Guides/                        # Step-by-step guides made by the team for current distro and software versions
├── __Tutorial_Briefs/               # Official tutorial briefs
│   ├── 2025/                        # 2025 briefs
│   └── 2026/                        # 2026 briefs
├── Internal Selection Prep/         # Individual prep work done before the internal selection round
│   ├── Prep_Btop_From_Source/       # Btop built from source — one subfolder per member
│   ├── Prep_Fastfetch/              # Fastfetch configuration and output screenshots
│   ├── Prep_HPL_Install/            # HPL benchmark installation screenshots
│   └── Prep_Passwordless_SSH/       # Passwordless SSH setup screenshots
├── Internal Selection Tutorials/    # Work submitted for each tutorial in the internal selection round
│   ├── _Challenge_1/                # Challenge 1 — cluster setup and HPL
│   │   └── Documentation/           # decision log, failure log, results, reflection
│   ├── _Tutorial_1/                 # One subfolder per member
│   ├── _Tutorial_2/                 # One subfolder per member
│   └── _Tutorial_3/                 # One subfolder per member
├── Scripts/                         # Ansible playbooks and automation scripts
│   ├── setupHPL.yml                 # Provisions and compiles HPL with ATLAS on headnode
│   └── runHPL.yml                   # Runs xhpl and saves output to a named results file
├── Selection Prep/                  # June 2026 prep notes (Written with the assistance of AI)
│   ├── 2025 Challenge 1 Notes.md    # Notes from Challenge 1
│   ├── Ansible Cheatsheet.md        # Ansible syntax reference
│   └── Regex Cheatsheet.md          # Regex basics reference
└── README.md
```

## Folders

| Folder | Description |
|--------|-------------|
| `__Guides` | Step-by-step guides made by the team, for current distro and software versions |
| `__Tutorial_Briefs` | Official briefs for each tutorial |
| `Internal Selection Prep` | Individual prep work done before the internal selection round |
| `Internal Selection Tutorials` | Submitted work and screenshots for each tutorial and challenge |
| `Scripts` | Ansible playbooks for automated cluster provisioning and benchmarking |
| `Selection Prep` | June 2026 comp prep notes and cheatsheets |

## Scripts

| Script | Description |
|--------|-------------|
| `setupHPL.yml` | Installs dependencies, downloads and compiles HPL 2.3 with ATLAS on the headnode |
| `runHPL.yml` | Prompts for output folder and number, runs xhpl, saves result to `/home/kei/outputs/` |

> Note: Scripts are run from the headnode using `make hpl` or `make run`. 

> Note: Selection Prep notes were written with AI assistance during June 2026 prep sessions.

## Team Members

- Maxwell Kei Farouk
- Pride McPetane Mnisi
- Erin Jordan Salo
- Ashley Kieran Tom

## About

This repository documents Jargon's preparation and competition work for the CHPC 2026 Student Cluster Competition, representing the University of the Western Cape.

