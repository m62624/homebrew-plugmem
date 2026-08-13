class PlugmemCli < Formula
  desc "CLI for the plugmem embedded memory engine."
  homepage "https://github.com/m62624/plugmem"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.12.0/plugmem-cli-aarch64-apple-darwin.tar.xz"
      sha256 "2bc07b7710ab295150ed7cded60e03590e5b1abc51aafba37e2d0d41093a2616"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.12.0/plugmem-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f7b75a9d2b7b83bfa8803d313bc467330720d0396dfc14706b92a408794d0982"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.12.0/plugmem-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "50e1402c1296090fedde403cf347a5b87343fac609063e9c472159b8f37d6783"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.12.0/plugmem-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f845406821c2b25689f48114c61dd562eb5f90e33715270769efcfcbbf259db1"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "plugmem-cli"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "plugmem-cli"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "plugmem-cli"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "plugmem-cli"
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
