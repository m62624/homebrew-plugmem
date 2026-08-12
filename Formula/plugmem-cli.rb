class PlugmemCli < Formula
  desc "CLI for the plugmem embedded memory engine."
  homepage "https://github.com/m62624/plugmem"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.11.0/plugmem-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a3c83e91f17d585e264d38bc5c9bd7bd7accfefafca0f7fce9561f83da90b42a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.11.0/plugmem-cli-x86_64-apple-darwin.tar.xz"
      sha256 "9767195bb8532bbc97062369208c16f8e880ca4bc99632268c62f299c47603a8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.11.0/plugmem-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f461ac259109196226afb7a0ec24891dea6591fc9b3d462245705212f89aca6c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.11.0/plugmem-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7ce972931c886e6304558c6637a02aabe192de311cee7c2929ed9db6655c6f16"
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
