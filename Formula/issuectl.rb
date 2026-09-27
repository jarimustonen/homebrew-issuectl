class Issuectl < Formula
  desc "AI-first CLI for managing markdown-based issues with YAML frontmatter"
  homepage "https://github.com/jarimustonen/issuectl"
  version "0.18.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.18.6/issuectl-aarch64-apple-darwin.tar.xz"
      sha256 "5668c9d48f8faf4da37fbd1b70bfc0696e37888c427f9cbf112fd4e8a435ad90"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.18.6/issuectl-x86_64-apple-darwin.tar.xz"
      sha256 "32feb50757ccddcc0c894c0fee66d4ca6402d248b085467cc4e88ad12436305f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.18.6/issuectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "df9e7fc31bfc414941166e5e1d8040fd2a8ba1f855bf2a89f445c975e082a7ca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.18.6/issuectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "681243a1872690df0a279cf2c001707f19be4992aedd4b85cd76c73b7d1df2fa"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
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
    if OS.mac? && Hardware::CPU.intel?
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
