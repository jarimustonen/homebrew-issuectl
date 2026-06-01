class Issuectl < Formula
  desc "AI-first CLI for managing markdown-based issues with YAML frontmatter"
  homepage "https://github.com/jarimustonen/issuectl"
  version "0.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.6.1/issuectl-aarch64-apple-darwin.tar.xz"
      sha256 "689d942a270519c09bdc590500dfceb2b7a69b38df7f86596bb90dab56f529d1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.6.1/issuectl-x86_64-apple-darwin.tar.xz"
      sha256 "0051c11803cc8faf0c342bbfad3c904f1c7f57b6375a8a9818163e7b16d29c68"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jarimustonen/issuectl/releases/download/v0.6.1/issuectl-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "375ab724ba62e9caa5e72273537b86ce7e6c60ac7fe927a9e5f86fdaff78e355"
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
