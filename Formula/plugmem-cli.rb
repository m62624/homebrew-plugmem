class PlugmemCli < Formula
  desc "CLI for the plugmem embedded memory engine."
  homepage "https://github.com/m62624/plugmem"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.1.2/plugmem-cli-aarch64-apple-darwin.tar.xz"
      sha256 "101fb1c2069fab7f47e84863861e75c950af60e10c712914a1ed490fdd12dd5d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.1.2/plugmem-cli-x86_64-apple-darwin.tar.xz"
      sha256 "665b5d2a2aaf58a29fc95ae548377d8a2188abefd1fd55f8ea1214e978642be5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.1.2/plugmem-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4d467cfedbd144c32a6d62c6c8a7242658080e489b83e3cf620e8883486433be"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.1.2/plugmem-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c54aa01a44669f869faf9bf24b8c6b167cc4cb34c0ef19fa764374d2de005d68"
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
