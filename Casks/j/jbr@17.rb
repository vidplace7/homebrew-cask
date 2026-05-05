cask "jbr@17" do
  arch arm: "aarch64", intel: "x64"

  version "17.0.14,1367.22"
  # update shas
  sha256 arm:   "e709b76af0a28d1a0ebffe042a6c90082ef56343508c57fa4955227d8937f6e4",
         intel: "2c0f68b2bde4d4243bfe83f531ac0133a31dbe073301641013cce517af5ef021"

  url "https://cache-redirector.jetbrains.com/intellij-jbr/jbr-#{version.csv.first}-osx-#{arch}-b#{version.csv.second}.pkg",
      verified: "cache-redirector.jetbrains.com/"
  name "JetBrains Runtime 17"
  desc "JetBrains Runtime JVM"
  homepage "https://github.com/JetBrains/JetBrainsRuntime"

  livecheck do
    url :homepage
    regex(/^jbr-release-(#{version.major}(?:\.\d+)*?)b(\d+(?:\.\d+)*)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  # JBR does not use unique identifiers
  conflicts_with cask: ["jbr", "jbr@21"]
  depends_on :macos

  pkg "jbr-#{version.csv.first}-osx-#{arch}-b#{version.csv.second}.pkg"

  uninstall pkgutil: "com.jetbrains.jbr"

  # No zap stanza required
end
