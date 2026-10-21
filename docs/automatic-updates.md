# Updating a formula from a project's release

A project can update its own formula in this tap whenever it publishes a release. This page covers the one-time setup and the workflow step to add.

## Why a credential is needed

A GitHub Actions workflow can only write to the repository it runs in. The built-in token of `jrnxf/<project>` cannot push to `jrnxf/homebrew-tap`, so the workflow needs a credential for the tap.

The credential is a deploy key: an SSH key pair registered on this tap only.

- A deploy key never expires.
- It can only reach this tap, and nothing else.
- Each project gets its own key, so nothing has to be kept and each key can be removed alone.
- The private key never goes into chat, an issue, or a command line.

## Setup

Run these once per project, as a user who can administer both repositories. Replace `<project>` with the project's repository name.

1. Generate a key pair with no passphrase:

   ```sh
   ssh-keygen -t ed25519 -N "" -C <project>-tap-bump -f /tmp/tap_key
   ```

2. Add the public half to the tap as a deploy key with write access:

   ```sh
   gh repo deploy-key add /tmp/tap_key.pub --repo jrnxf/homebrew-tap --allow-write --title <project>-tap-bump
   ```

3. Store the private half as a secret on the project:

   ```sh
   gh secret set TAP_DEPLOY_KEY --repo jrnxf/<project> < /tmp/tap_key
   ```

4. Delete both key files:

   ```sh
   rm /tmp/tap_key /tmp/tap_key.pub
   ```

5. Check it worked:

   ```sh
   gh secret list --repo jrnxf/<project>
   gh repo deploy-key list --repo jrnxf/homebrew-tap
   ```

   The first command must list `TAP_DEPLOY_KEY`. The second must list `<project>-tap-bump` as read-write.

## Release step

Add this job to the project's release workflow, after the job that publishes the release artefact. Replace `<formula>` with the formula's name (the file in `Formula/` without `.rb`), and `needs` with the name of that publishing job.

```yaml
  tap:
    name: update tap formula
    needs: <the job that publishes the release artefact>
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          repository: jrnxf/homebrew-tap
          ssh-key: ${{ secrets.TAP_DEPLOY_KEY }}
      - run: scripts/bump-formula.sh <formula> "${{ github.event.release.tag_name }}"
      - run: |
          git config user.name "github-actions[bot]"
          git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
          git commit -am "<formula> ${{ github.event.release.tag_name }}"
          git push
```

The workflow must run on the `release` event, for example `on: release: types: [published]`, so that `github.event.release.tag_name` is set.

`scripts/bump-formula.sh <formula> <version>` downloads the source archive of the release tag, then rewrites the `url` and `sha256` lines of `Formula/<formula>.rb`. A leading `v` on the version is accepted. It reads the repository address from the formula's `homepage`, so the homepage must be a `https://github.com/<owner>/<repo>` address.

For a project that attaches prebuilt binaries to its release, add a `<platform>=<asset>` argument for each binary, for example `scripts/bump-formula.sh <formula> "${{ github.event.release.tag_name }}" macos=<formula>-universal-apple-darwin`. The job's `needs` must then include the job that uploads the binaries. The [README](../README.md#updating-a-formula) lists the platforms and what the script writes.

## Removing a key

List the keys, find the id of the one to remove, and delete it:

```sh
gh repo deploy-key list --repo jrnxf/homebrew-tap
gh repo deploy-key delete <id> --repo jrnxf/homebrew-tap
```

Then remove the secret from the project:

```sh
gh secret delete TAP_DEPLOY_KEY --repo jrnxf/<project>
```

Other projects keep working, because each has its own key.
