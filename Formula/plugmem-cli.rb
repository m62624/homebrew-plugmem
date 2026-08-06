class PlugmemCli < Formula
  desc "CLI for the plugmem embedded memory engine."
  homepage "https://github.com/m62624/plugmem"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.7.1/plugmem-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c2a05e881f17750a3608bca1a8718a8d3678a6e0cf047a8fa2bf88a8dfc2143c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.7.1/plugmem-cli-x86_64-apple-darwin.tar.xz"
      sha256 "6881ce4fb1c72e42ed60cd3009ef2f979aeb94342a1aa0db67c3c6dc864a9986"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.7.1/plugmem-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "778fcc4ceecbbd93f238c636119d4cf04908df18925b65898ae5298db9d72a26"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.7.1/plugmem-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ef4555fc17dffe4316a459f50b0ff81fd0b908c3dde455047ce660f5e145df3f"
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
