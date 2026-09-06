class Issuectl < Formula
  desc "AI-first CLI for managing markdown-based issues with YAML frontmatter"
  homepage "https://github.com/jarimustonen/issuectl"
  version "0.18.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/issuectl/releases/download/v0.18.3/issuectl-aarch64-apple-darwin.tar.xz"
    sha256 "be67f2498480662f168984c9cb62ad0be60a94b4f84ede338cd9a897b3574c9a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.18.3/issuectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "d8d28862f18212cf65e1730f29480087423423236e9b5de30bbf9cff4dabc6d7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.18.3/issuectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "9f58c162fb16bc9df15c1e944e0978bce5fcd17de70df7e75b31205c2bf97bad"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "issuectl"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "issuectl"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "issuectl"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
