cask "jbr@21" do
  arch arm: "aarch64", intel: "x64"

  version "21.0.10,1163.110"
  # update shas
  sha256 arm:   "1c1721d5df6c2ab2edd8d2801bac07a8895b051e51b1946b1897d0a712138115",
         intel: "a814d873a80386f3d2eeca6b8408efcad8d824e61ffa1c2dcb38c95dbb6918e1"

  url "https://cache-redirector.jetbrains.com/intellij-jbr/jbr-#{version.csv.first}-osx-#{arch}-b#{version.csv.second}.pkg",
      verified: "cache-redirector.jetbrains.com/"
  name "JetBrains Runtime 21"
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
  conflicts_with cask: ["jbr", "jbr@17"]
  depends_on :macos

  pkg "jbr-#{version.csv.first}-osx-#{arch}-b#{version.csv.second}.pkg"

  uninstall pkgutil: "com.jetbrains.jbr"

  # No zap stanza required
end
