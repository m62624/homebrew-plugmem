class PlugmemCli < Formula
  desc "CLI for the plugmem embedded memory engine."
  homepage "https://github.com/m62624/plugmem"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.6.0/plugmem-cli-aarch64-apple-darwin.tar.xz"
      sha256 "99a8e72653dd46b49ef48653a9aa739f75c2433e1163043a74357447dfded476"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.6.0/plugmem-cli-x86_64-apple-darwin.tar.xz"
      sha256 "13f05c41a0ac4e34a691420c9cd3a8f102b5c6e3ef7d0f7e2c32f1a84e700510"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.6.0/plugmem-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7e3b1d61a72cd59cb227557bee56b60990abf7599550fb64281174c883b746dc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.6.0/plugmem-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "18a9c74d7c76e7a2157e86b98a62876611408309950cf6441052b53d1eb38289"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "plugmem-cli" if OS.mac? && Hardware::CPU.arm?
    bin.install "plugmem-cli" if OS.mac? && Hardware::CPU.intel?
    bin.install "plugmem-cli" if OS.linux? && Hardware::CPU.arm?
    bin.install "plugmem-cli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
