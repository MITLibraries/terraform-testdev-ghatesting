#### Developer Checklist

- [ ] The README contains the correct list of dependencies, inputs, and outputs (e.g., `terraform-docs markdown .` has been run)
- [ ] Latest versions of `dev.tfvars` and `test.tfvars` uploaded to Parameter Store using `./scripts/parameter_update.py` script
- [ ] Infrastructure resources in this feature are currently NOT deployed in `dev` workspace (opening this PR will trigger a `terraform plan` in the `dev` workspace for review)
- [ ] Stakeholder approval has been confirmed (or is not needed)

#### What does this PR do?

A few sentences describing the overall goals of the pull request's commits.
Why are we making these changes? Is there more work to be done to fully
achieve these goals?

#### Helpful background context

Describe any additional context beyond what the PR accomplishes if it is likely
to be useful to a reviewer.

Delete this section if it isn't applicable to the PR.

#### What are the relevant tickets?

Include links to Jira Software and/or Jira Service Managament tickets here.

#### Requires Database Migrations?
YES | NO

#### Includes new or updated dependencies?
YES | NO
