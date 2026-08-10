class Issuectl < Formula
  desc "AI-first CLI for managing markdown-based issues with YAML frontmatter"
  homepage "https://github.com/jarimustonen/issuectl"
  version "0.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.7.2/issuectl-aarch64-apple-darwin.tar.xz"
      sha256 "8c86c21f61c0810ac182346284e2980ea7b948833bfa0cfa98509f9d58fd8340"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.7.2/issuectl-x86_64-apple-darwin.tar.xz"
      sha256 "dd6eb0d3de73c472bc1cce3eebb3a5a13b0338fab7ef128b5a2e024aae866560"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jarimustonen/issuectl/releases/download/v0.7.2/issuectl-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f9fbb0a45364414245c80e1a593dfac0ac19f9e152aeab4c508ee39e7156ce25"
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
