class Issuectl < Formula
  desc "AI-first CLI for managing markdown-based issues with YAML frontmatter"
  homepage "https://github.com/jarimustonen/issuectl"
  version "0.19.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.19.0/issuectl-aarch64-apple-darwin.tar.xz"
      sha256 "b510cf879aaacada63553ebfe6012cd6ca26d1318762527c3cec10d342c738f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.19.0/issuectl-x86_64-apple-darwin.tar.xz"
      sha256 "adcc4776d0ec1f95f6e469abe6437692f32a808d03e09f5154058276bc7dc867"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.19.0/issuectl-aarch64-unknown-linux-musl.tar.xz"
      sha256 "b1679f610cde8b6d889bff820627222b0675e0ac57b16566b72aac49695564c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/issuectl/releases/download/v0.19.0/issuectl-x86_64-unknown-linux-musl.tar.xz"
      sha256 "75d5fa1b1c20cae557ab90948788f19af88bf14dfa215a538abc6096673976ef"
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
