class PlugmemCli < Formula
  desc "CLI for the plugmem embedded memory engine."
  homepage "https://github.com/m62624/plugmem"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.1.4/plugmem-cli-aarch64-apple-darwin.tar.xz"
      sha256 "40771a475f69d225e9ab9c983761591f7f95d99b1919ec60bee73654d5701c7a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.1.4/plugmem-cli-x86_64-apple-darwin.tar.xz"
      sha256 "faac0b23aacabd69cdca2682a52859b4453ab1b3d4a06ddf834ce49a34f84459"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.1.4/plugmem-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d5b2120c88e88564e6f6a7aa00f940d1ff5adc60d163da87f80e5388d7bd4437"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.1.4/plugmem-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8cc34a527378e26cb5f4e705ee0631d442614c734b3427f51833f1772296315d"
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
