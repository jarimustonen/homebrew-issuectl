class Issuectl < Formula
  desc "AI-first CLI for managing markdown-based issues with YAML frontmatter"
  homepage "https://github.com/jarimustonen/issuectl"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.7.1/issuectl-aarch64-apple-darwin.tar.xz"
      sha256 "de630507ad18ad87a5954cd79b4c86b03ab506a9127d6e716875db388042ecff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.7.1/issuectl-x86_64-apple-darwin.tar.xz"
      sha256 "2814ae5d307cdca2ba0a0760f701d0b2b368a7d38bf02654c5f3b59e3c5fe713"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jarimustonen/issuectl/releases/download/v0.7.1/issuectl-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "fb1121edf3f7a989b5d02890e07353a77005021e0a12008de50da5a4c0fa74e5"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "issuectl" if OS.mac? && Hardware::CPU.arm?
    bin.install "issuectl" if OS.mac? && Hardware::CPU.intel?
    bin.install "issuectl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
