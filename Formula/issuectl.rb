class Issuectl < Formula
  desc "AI-first CLI for managing markdown-based issues with YAML frontmatter"
  homepage "https://github.com/jarimustonen/issuectl"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.5.1/issuectl-aarch64-apple-darwin.tar.xz"
      sha256 "d15106763a6aad5e262dcd0afd691efd626d12202f5fc2dfa73bc5f4b83f2f91"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.5.1/issuectl-x86_64-apple-darwin.tar.xz"
      sha256 "4482ee3057f3e8bd7b1cbcdd5c19ab2d53049445419e7720d7eeeeaa3fa8d722"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jarimustonen/issuectl/releases/download/v0.5.1/issuectl-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "34e3b66c6d16821dbb07ab35225a371eff9e0299555189ec594db10299206b88"
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
