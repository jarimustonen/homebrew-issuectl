class Issuectl < Formula
  desc "AI-first CLI for managing markdown-based issues with YAML frontmatter"
  homepage "https://github.com/jarimustonen/issuectl"
  version "0.18.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.18.7/issuectl-aarch64-apple-darwin.tar.xz"
      sha256 "268fc0820252e9c5b95eadff0c465c90b08cc2f88a3d5d9f8d45600c47be1fa0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.18.7/issuectl-x86_64-apple-darwin.tar.xz"
      sha256 "720cd9a37613f054e2aaaeadbf23d12b0e1aad868264ed1a6f7fe369800ad709"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.18.7/issuectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "56a69aeb746dae23f1885b811641353e0966f8fa48dc36e57cce9737570f9fd9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.18.7/issuectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "907b5ae60c5e1a70cb0eb6f5425386226b700709544d0ceaa9d55d8fa532ce7a"
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
