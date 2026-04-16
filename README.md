# Active Directory Homelab Automation

## Overview

This project demonstrates a self-built Active Directory environment with automated user provisioning and role-based group assignment.

The lab simulates a small company infrastructure with a Domain Controller, a Management Server, and a Client system.

---

## Environment

* Hyper-V Virtualization
* Windows Server 2022 (Domain Controller)
* Windows Server 2022 (Application / Management Server)
* Windows 11 Client
* Active Directory Domain Services (AD DS)
* DNS

---

## Architecture

* **DC1** – Domain Controller (AD DS, DNS)
* **APP1** – Management & Automation Server
* **CL1** – Domain Client

---

## Features

* Creation of a custom AD domain (`corp.lab`)
* Organizational Unit (OU) structure for departments:

  * IT
  * HR
  * Sales
* Automated user creation using Python-generated data
* Automated provisioning of users in Active Directory via PowerShell
* Automatic group assignment based on department
* Separation of infrastructure and administration roles
* Initial Group Policy Object (GPO) implementation

---

## Automation Workflow

1. Python script generates user data (CSV)
2. PowerShell script imports users into Active Directory
3. PowerShell script assigns users to security groups
4. Logging is written for traceability

---

## Project Structure

* `python/` → User data generation
* `powershell/` → AD automation scripts
* `docs/` → Screenshots and documentation
* `.gitignore` → Prevents sensitive/local data upload

---

## Key Learnings

* Practical setup and management of Active Directory
* Understanding of domain architecture and services
* Automation of user lifecycle processes
* Use of PowerShell for administrative tasks
* Separation of roles (Domain Controller vs. Management Server)
* Version control using Git and GitHub

---

## Notes

* The lab environment is isolated and runs without internet access
* No real user data or credentials are used
