cask "signoff" do
  version "0.4.0"
  sha256 "f9673fd865c063868a87fe8deb4abac6bd3efb90f847a9c87e2cf0676dc82bb8"

  url "https://github.com/lumi-collective/signoff/archive/refs/tags/v#{version}.tar.gz"
  name "Signoff"
  desc "Inbox app for the Signoff plugin, built from source"
  homepage "https://github.com/lumi-collective/signoff"

  depends_on formula: "go"
  depends_on macos: :monterey

  app "signoff-#{version}/app/bin/Signoff.app"

  # Built here from the release's source (pinned by sha256): there is no notarized build. Homebrew quarantines the
  # download and build.sh copies two of its files into the app, so the app it built has that mark removed.
  # SIGNOFF_LAUNCHER=link: the app finds the plugin through the link the plugin's hook keeps.
  preflight_steps do
    run "/bin/sh",
        args:           ["-c", 'GOPATH="$PWD/../go" GOCACHE="$PWD/../go-cache" GOFLAGS=-modcacherw ' \
                               "SIGNOFF_LAUNCHER=link exec /bin/sh app/build.sh"],
        chdir:          "signoff-#{version}",
        env:            { "PATH" => "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin" },
        writable_paths: ["."],
        network_access: true
    run "/usr/bin/xattr",
        args:  ["-dr", "com.apple.quarantine", "signoff-#{version}/app/bin/Signoff.app"],
        chdir: "."
    remove ["go", "go-cache"], recursive: true # the build's module cache, about 200 MB, not needed after it
  end

  uninstall quit: "io.github.lumi-collective.signoff.inbox"

  # The app's own files only. The Signoff home (~/Library/Application Support/signoff) holds the inbox's data
  # and stays.
  zap trash: [
    "~/Library/Caches/io.github.lumi-collective.signoff.inbox",
    "~/Library/HTTPStorages/io.github.lumi-collective.signoff.inbox",
    "~/Library/Preferences/io.github.lumi-collective.signoff.inbox.plist",
    "~/Library/Saved Application State/io.github.lumi-collective.signoff.inbox.savedState",
    "~/Library/WebKit/io.github.lumi-collective.signoff.inbox",
  ]

  caveats <<~EOS
    The app finds the Signoff plugin through a link the plugin keeps. Install the plugin and start a Claude Code
    session with it once:
      claude plugin install signoff --marketplace lumi-collective/signoff
    The plugin keeps the link only while the app is in /Applications or ~/Applications.
    A plugin run from a git checkout keeps no link; build the app from that checkout with app/build.sh instead.
  EOS
end
