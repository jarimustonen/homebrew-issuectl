class Issuectl < Formula
  desc "AI-first CLI for managing markdown-based issues with YAML frontmatter"
  homepage "https://github.com/jarimustonen/issuectl"
  version "0.16.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/issuectl/releases/download/v0.16.0/issuectl-aarch64-apple-darwin.tar.xz"
    sha256 "790c5b06eb3fdd2b53c41bd48406c88fc9e0869c42a31f5b07751090e2b60417"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.16.0/issuectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "43d276ced127189f80137107ee01f20d4770ef31b9490c8a229c51683861c833"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.16.0/issuectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "464fb3bdfd0140875a3c4bf9eee32af6c0cae6ab35905a7435fec213f7863044"
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
