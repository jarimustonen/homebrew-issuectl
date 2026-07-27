class Issuectl < Formula
  desc "AI-first CLI for managing markdown-based issues with YAML frontmatter"
  homepage "https://github.com/jarimustonen/issuectl"
  version "0.6.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.6.5/issuectl-aarch64-apple-darwin.tar.xz"
      sha256 "ecbee9a47a959657212ad0f4d1242dd69e5fa765cad7d5a3efb76354b01cb525"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.6.5/issuectl-x86_64-apple-darwin.tar.xz"
      sha256 "8bfa0aa10d3d257aff7b24aeece6aa500d385dd93a55e091dea639c917295bae"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jarimustonen/issuectl/releases/download/v0.6.5/issuectl-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "34c2e5bd861be2e998de4be7758f75d515bf1b1442447e31aab3de6850be4a44"
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
