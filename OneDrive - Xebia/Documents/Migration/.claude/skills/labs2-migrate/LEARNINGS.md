# Labs 2.0 migration learnings

Append new entries at the bottom of the relevant section. Date and source track in brackets.

## Architecture
- One module per track, thin lab. Container/VM lives in the lab and is passed to the module as a variable. A task cannot target a container defined inside a module (`unsupported target type "module.<name>.resource.container..."`). [mongodb indexing]
- Published module versions are immutable. A lab must pin a version. A stale validation persists until a new module version is published.
- `instruqt lab validate` can't resolve published modules: validate a local copy with `./modules/...` and no `version`.
- `depends_on = [module.x]` on a task fails at runtime ("no cty.Type for interface {}"). Don't use it.

## HCL gotchas
- Lab needs `settings.timelimit.duration`, else "no session time limit configured".
- A page needs `activities = { id = resource.task.x }` for every `<instruqt-task>` in the markdown.
- Set `title` on the lab's `page` block, otherwise the loading outline shows a blank name.
- Terminal `command` must be a list, e.g. `["/scripts/mongosh.sh","--skipStartupWarnings"]`, otherwise you get a bash prompt.
- Lab description renders Markdown (tables, lists, callouts) but not images or video. `/assets/...` and data-URI images fail.
- No equivalent yet for: track tags, loading video/tips, track notes video.

## Images and secrets
- Customer registry images are often not pullable from the instruqt org. MongoDB: use Instruqt-owned `europe-west1-docker.pkg.dev/instruqt-mongodb/instruqt-images/mongodb:1.0.23`. `curriculum-labs/prod/mongodb-image` does not pull.
- Secrets: `resource "secret"` with `reference` naming a team secret; use `resource.secret.<name>.value`. Values are write-only. Keep tokens out of container `environment` and logs; use exec-only scope.
- Datadog: every track uses a `datadog-community/...` GCP host image and Datadog-owned provisioning (`datadoghq.dev/instruqtlabtools`, `creds`, learner-history secrets). Blocked until Datadog shares images/tooling. Don't attempt stock-VM rebuilds. [datadog, datadog-dev, datadog-field-marketing, ~60 tracks checked]

## Cloud accounts
- `aws_account` requires `regions` and `services`; optional `tags`, `scp_policy`; `user "name" { managed_policies, iam_policy }`. Outputs: `account_id`, `account_name`, `user.N.username/password/access_key_id/secret_access_key`. Reference users by index. `disabled = true` still provisions. Untested end to end.

### RESOLVED (2026-10-31): the platform `no cty.Type for cloud.ServiceLimits` bug is fixed; the lab now gets past it
The section below is kept as history. After the fix three of OUR mistakes surfaced, one at a time (each only visible by pressing Play):
1. `cloud_credentials { aws_account { users = [0] } }`: `users` takes the user **names** (`["student"]`), not indexes. `[0]` fails at start with `user "0" does not exist in target account`. (Indexes are only for value references like `user.0.access_key_id`.)
2. A `virtual_browser` inside a module fails at start with `unable to find dependent resource 'resource.network.main': module.<name>.resource.network.main`: a virtual browser attaches to every network in the lab, and a module can't see the lab's network. **Define the `virtual_browser` in the lab** and pass it to the module as a variable, like the credentials tab and the container.
3. Publish the module version **before** pushing the lab commit that pins it. Pushing first leaves a stale "version X is not published" validation (warning icon on the branch, Play greyed out) that survives publishing and even an empty commit. Fix: publish another version (identical content) and pin to that.
- Rule of thumb: any resource that references a lab-level resource (container, VM, network, aws_account, cloud tab, browser) belongs in the lab; the module receives it through a `variable`.
- Tab titles come from the layout `tab` slug, capitalised: `cloud-cli` shows as "Cloud-Cli", `aws-console` as "Aws-Console". Use slugs that read well as titles (e.g. `terminal`, `console`).
- Press Play after every change: validate is clean for all three problems above.
- End-to-end result (aws-ec2, module 1.0.3, 2026-10-31): lab starts; setup `create-default-vpc` works with the env credentials; Credentials tab shows account ID, user, password, keys; AWS Console tab loads the IAM sign-in page; page 1 Check fails ("Please create an instance to proceed.") then passes after `run-instances` with the looked-up AMI; page 2 Check fails ("Please terminate the instance to proceed.") then Solve for me terminates the instance ("Solved for you"); completion card unlocks; Finish & Exit works. Console sign-in with the shown credentials was not typed in (credentials are not entered by the assistant); the terminate step was verified through Solve for me.
- The page 2 task counter reads "1 / 2" until the second task completes; page 1 completion is kept when navigating forward.

### (history) BLOCKER: any reference to an `aws_account` / `google_project` resource fails at session start (found 2026-10-30, aws-cloud-account-copy-hp)
- Symptom: `instruqt lab validate` and import are clean, but Play fails with "Lab failed to start": `unable to convert reference resource.aws_account.lab to context variable: no cty.Type for cloud.ServiceLimits (no hcl field tags)`. Hits every reference: container `environment` using `user.0.access_key_id`, and the `cloud_credentials` tab `target`. Occurs with no `service_limits` block.
- Known platform bug: reproduced by Instruqt support on 2026-10-29 (customer ticket #4418, escalated to engineering, no workaround or ETA at the time). Not fixable from the lab or module.
- Until it is fixed, triage must mark cloud-account tracks (aws_accounts / google_project / azure) as **blocked at runtime**, even though they validate. Re-test the sandbox start before promising a migration.
- Always play-test: validate passing proves nothing for this class of error.

### Imported labs open in "Editing" mode with a draft that can be older than the repo (daytona-sdk-ai-agents, 2026-11-02)
- After Import lab, the editor opens in **Editing** mode. Play from that state runs the editor draft, not the repo's latest commit. After pushing a new module pin, Play still ran the old module (the log showed the old script) and the Modules tab still showed the old version.
- Fix: open the lab's More actions (three dots) menu, choose **Exit edit mode** (it reports "Changes discarded"), then check that the Overview shows your latest commit under Change history and press Play from the read-only page. Always confirm the module version actually used by reading the setup script lines in `instruqt lab logs`.
- The `/modules/<name>` route re-enters Editing mode; use the Overview URL (`?reference=main`) for Play.

### Pin third-party sources the original track pulled from `main` (daytona-sdk-ai-agents)
- The original track did `git clone --depth 1 https://github.com/daytonaio/daytona.git` (unpinned). Upstream was archived in June 2026 and `main` now only holds a README, so the clone succeeded but `docker/dex/config.yaml` was missing and setup failed (`FileNotFoundError ... /root/daytona/docker/dex/config.yaml`). Pin to the last release tag (`--branch v0.190.0`). Expect the same decay for any unpinned `latest`/`main` download in a migrated setup script: triage should list them.
- Track-only values with no Labs equivalent: `${_SANDBOX_ID}` URLs, the `provision_ssl_certificate` metadata-server certificate, and `allow_external_ingress`. A lab can reach VM ports from a `virtual_browser` at `http://<vm-resource-name>.sandbox.internal:<port>`; apps that need a public URL (OIDC issuers) must be configured with that address.

### Heavy self-hosted stacks on a VM (daytona-sdk-ai-agents, 2026-11-02; Check/Solve passed on all 3 pages)
- **Images disappear:** `docker compose pull` failed with `pull access denied for minio/minio`: MinIO stopped publishing Docker images (Docker Hub and quay.io). Triage must check every image a compose file references is still pullable (query the registry); use a maintained fork (`pgsty/minio`) via a compose override if needed.
- **Pin SDKs to the server version.** `pip install daytona_sdk>=0.10.0` pulled 0.227.0 (from the now-private server) and failed against the archived v0.190.0 server (`Sandbox kvm: Input should be a valid boolean`). Pin the client (`daytona_sdk==0.190.0`) to the release published the same day as the server tag.
- **Internal names:** `<vm>.sandbox.internal` does NOT resolve; use `<vm>.<network>.sandbox.internal` (e.g. `workstation.main.sandbox.internal`; `.vm.main.` also works). The VM resolves its own name at the VM's lab IP.
- **Secure context:** a web app doing PKCE/OIDC in the browser (`crypto.subtle`) fails on plain `http://` internal names ("Crypto.subtle is available only in secure contexts"). Put nginx with a self-signed certificate in front (dashboard and IdP on one origin) and open `https://<vm>.<network>.sandbox.internal`; learners click through the certificate warning once (Advanced, Proceed). The API container can keep using the IdP over the Docker network.
- **The virtual browser loads its URL at lab start, before setup finishes.** The tab can show a stale ERR_CONNECTION_REFUSED; tell learners to reload it (or add a note in the instructions).
- **No unauthenticated shortcuts:** the original solve posted to `/api/api-keys` with no auth and could never work. A solve that needs a login must do the real login: OIDC authorization code + PKCE against Dex as the static user, then API calls with `Authorization: Bearer` and `X-Daytona-Organization-ID`. Dex's Grant Access form has no `action` attribute (post back to the same URL). Use a unique API key name per run (a duplicate name returns 409 and the value is only shown at creation).
- **Don't paste long commands into the terminal tab:** a ~6 KB command dropped the terminal connection ("Connection lost, trying to reconnect"). Ship helper scripts from the setup exec instead (heredoc), and use short commands for live fixes.
- **Platform hiccup to recognise:** sessions stuck on "Session queued" and Stop failing with `column "stop_reason" of relation "lab_sessions" does not exist` was a platform migration problem (fixed by the platform team the same day), not a lab problem.
- Failure messages: the platform appends a period, so don't end `failure_message` with one.
- The first start of this stack took roughly 20 minutes (VM image download, packages, ~15 images). Allow for it in the description and the session time limit.

### VM tracks (docker-hp: passed first play-through, 2026-10-30)
- Track VM images (`instruqt/docker-2010`, `datadog-community/...`) are not Labs VM images. Labs `vm { image { name = "docker" } }` uses an Instruqt **base image** by bare name: `ubuntu`, `debian`, `fedora`, `centos`, `rockylinux`, `docker` (Docker preinstalled), `k3s`. Pick the base image closest to the track's purpose. [docker-hp]
- A `vm` needs `resources { cpu = <cores>  memory = <MB> }` and takes `network { target = resource.network.main }` (container uses `id = ...meta.id`, VM uses `target`). Exec, terminal and task `config.target` can all be the VM and worked.
- Terminal has `working_directory`: replaces Track `set-workdir`. The directory must exist (created by the setup exec).
- The editor tab (Track `type: code`) cannot target a VM (only a container), so it is dropped; point learners at `cat` in the terminal instead. A service tab on a port nothing listens on is also dropped.
- First VM start was ~11 minutes (the VM image downloaded for ~6 min, then QEMU ~30 s, then the module setup). Track start was ~1 minute. Set expectations and give a generous `timelimit` (the clock starts after the sandbox is ready).
- `instruqt lab logs <team>/<lab> --since=-15m` shows the platform timeline (Starting QEMU, Executing script, Script completed). Use it when a lab sits on "Creating sandbox".
- Original track's `check` used `set -euxo pipefail`, `fail-message` and `exit 1`; ported to a plain `exit 1`, with the text moved to `failure_message`. The learner sees it as "Couldn't find an image with the name my-service." Identical message in the track and the lab.

### Verify content that the original track hardcodes (found by playing the original)
- The track's `aws ec2 run-instances --image-id ami-01685d240b8fbbfeb` fails in `ap-south-1` (`InvalidAMIID.NotFound`): the original track was already broken for its region. Fixed by looking up the latest Amazon Linux AMI with `describe-images` (needs only EC2 permissions). Always run the track's own commands during the original play, and don't assume they work.
- Original behaviour confirmed useful for comparison: failing Check shows "Not quite right, try again" with the `fail-message` text; Skip runs the solve script and the track then finishes with a rating screen.
- Chrome tooling: a background tab can't be screenshotted (times out). Bring one tab to the front or test one tab at a time.

### AWS account migration pattern (aws-cloud-account-copy-hp, validated; runtime blocked, see above)
- `cloud_credentials` must reference the `aws_account` **directly**. Defining it inside the module with `target = variable.aws_account` fails validate ("aws_account[0] must specify a target"). Define `resource "cloud_credentials"` in the **lab** next to the `aws_account`, pass it into the module as a variable, and use `variable.credentials` as the layout tab target. [aws-ec2]
- `cloud_credentials { aws_account { target = resource.aws_account.lab  users = [0] } }`: users are positional indexes.
- Track `cloud-client` container becomes a lab container with the AWS keys in `environment` (`resource.aws_account.lab.user.0.access_key_id` / `.secret_access_key`) plus `AWS_DEFAULT_REGION`. Terminal tab targets that container.
- Track `virtualbrowsers` becomes a `virtual_browser` resource with `url`; it can live in the module (no target).
- `aws_account` needs `regions`, `services` and at least one `user` with `managed_policies` or `iam_policy`. Prefer least privilege (the track used AdministratorAccess; the lab uses AmazonEC2FullAccess).
- Unused VMs in the track (here a stock Ubuntu VM with a commented-out setup) were left out; say so in the report.
- Module import: Building blocks → Modules → Import module → pick owner `xi2870-harpreet`, repo, root directory; then **Publish version** (1.0.0). Lab import: Labs 2.0 → Import lab.
- `instruqt update` is needed when the CLI says "update required"; pulls fail until then.

## Platform behaviour differences vs Tracks
- Skip becomes "Solve for me". The lab shows the task card in a last, collapsed "Check Your Work" section.
- Solve for me runs the solve scripts but does not advance the lab; the learner then clicks Finish.
- Solve runs all scripts in one request and has been reported to fail with a 504 beyond ~30s.
- Sandbox start ~7 min vs ~1 min for tracks (hot start).
- UI "Editing" drafts can rewrite HCL and shadow repo commits. Review/discard drafts before judging repo changes. (Symptom: "required attribute layout not found on type resource.lab".)

## Tooling
- Public GitHub repo creation is blocked by the auto-mode classifier; private is allowed.
- `instruqt track pull <org>/<slug>` is read-only and fine for triage. There is no `track list` CLI; list tracks in the web UI.

## Porting Track scripts (things that don't exist in Labs)
Source: Instruqt's internal lab builder rulebook (paraphrased; internal only, do not copy text).
- Track check helpers do not exist in Labs: `fail-message`, `hint-message`, `debug-message`, `check-history`, `set-workdir`. Calling one gives `command not found` (exit 127) and **the script keeps going**, so a ported check can pass by accident. Delete every helper call, end each failing branch with an explicit `exit 1`, and turn per-branch fail-messages into separate conditions with their own `failure_message`.
- Test a ported task by driving it through a deliberate partial failure, not just untouched and fully solved.
- There is no `/opt/instruqt/bootstrap/host-bootstrap-completed` marker. A Track bootstrap-wait loop (`until [ -f ... ]`) never exits in Labs. Delete the loop. Both MongoDB tracks had it; our modules dropped it. [mongodb indexing]
- No "allow external ingress" equivalent for VMs/containers. Contact Support if a lab needs it.
- No Track-level teardown or `cleanup` hook that runs when the sandbox stops. No loading messages: move Track notes to the first page or a note tab. Track feedback becomes Feedback blocks and must be added explicitly.
- No `agent variable set/get`, no `[[ Instruqt-Var ]]`, no `skipping_enabled`. Skipping is always on for tasks; a task skip runs its `solve` scripts.
- Checks in the UI import are stricter than `instruqt lab validate`: CLI-clean does not guarantee import-clean (for example a terminal targeting the wrong resource type).
- Cloud accounts need at least one `user` block. For AWS a user needs `iam_policy` or `managed_policies`. Services not on the team's allowed list can take a month to get approved: check feasibility before designing.

## o11ycon-workshop (OpenTelemetry demo + Honeycomb)

- **Module source namespace is the team that owns the module.** A module published in `instruqt-support` must be referenced as `instruqt-support/<module-repo>`, not `instruqt/...`. Wrong namespace gives `module ...: not found` at lab import.
- **Error toast can cover the Import button** in the import dialog. Dismiss the toast, or click the button by ref, otherwise you retry on a stale error.
- **Code Editor tab has no Labs equivalent.** Install `nano` in setup and point learners at the terminal.
- **Internal DNS** is `<vm>.<network>.sandbox.internal`, so the shop is `http://demo.main.sandbox.internal:8080`.
- **Big compose stacks work on the `docker` base image** (4 CPU, 16 GB, 40 GB disk at `/var/lib/docker`). Setup exec: pre-pull images, `compose up -d`, wait for the HTTP port. It took about 7 min on first start (exec timeout 1800s is comfortable).
- **Idle timeout destroys the session** (30 min). Do not leave a play-test unattended if you need to inspect the UI.
- **Slow lab logs:** `instruqt lab logs` takes minutes. Run it in the background to a file.
- **Not verified:** shop tab and Honeycomb tab rendering. Honeycomb needs the learner's own login.
- **Play-test result (o11ycon):** all 19 containers up, shop HTTP 200, terminal opens in `/root/opentelemetry-demo`, Honeycomb login page loads in the virtual browser. First-start about 11 min end to end. If a virtual browser tab is opened before the app is listening it shows `ERR_CONNECTION_REFUSED`; Reload fixes it. Consider making the setup exec the last thing that must finish before learners enter (it already is).

## GCP cloud account (gcp-cloud-account-copy-hp, 2026-11-17)
- Labs resource is `google_project` (name 4+ chars), with `regions`, `services` (full API names like `compute.googleapis.com`), at least one `user "<name>" { roles }`, optional `service_account "<name>" { roles }`. Computed: `project_id`, `user.N.email|password`, `service_account.N.email|key` (positional index, not label).
- Credentials tab: `cloud_credentials { google_project { target = resource.google_project.x  users = ["student"] } }` (user **names**). This syntax is not in the docs; it validated and works at Play. Shows project ID, email, password.
- The Track cloud-client container is NOT pre-authenticated in Labs. Add a `service_account` block, pass `service_account.0.key` and `project_id` to the container `environment`, and in the setup exec run `gcloud auth activate-service-account --key-file=...` + `gcloud config set project`. The key is the JSON itself and fits in an env var.
- Track `regions:` were `us-central1` only but the solve created a VM in `europe-west1-b`; the lab allows both. Check track scripts against `regions` during triage.
- The aws/google cloud-account start bug is fixed: lab starts, credentials resolve, VM created by Solve (RUNNING, `n1-standard-1`).
- Result: Check failed with the failure message, Solve for me created `myinstance` ("Solved for you"), Credentials tab populated, Console tab shows the Google sign-in page (credentials not typed in). Start to Enter lab about 5 min.
- Click targets in the instructions panel move when the failure message appears; re-screenshot before clicking Solve for me.
