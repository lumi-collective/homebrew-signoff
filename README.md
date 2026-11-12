# Homebrew tap for Signoff

[Signoff](https://github.com/lumi-collective/signoff) is a Claude Code plugin that puts an agent's open decisions on
a local page and gathers every project's questions in one inbox. This tap installs its optional macOS app.

```bash
brew install --cask lumi-collective/signoff/signoff
```

The cask downloads the release's source and builds the app on your Mac (Go, which Homebrew installs, and the Xcode
Command Line Tools), then puts it in `/Applications`. Nothing prebuilt is downloaded. Then install the plugin and
start a Claude Code session with it once, so the app can find it:

```bash
claude plugin install signoff --marketplace lumi-collective/signoff
```

Update with `brew upgrade --cask signoff`, then restart the app.
