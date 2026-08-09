class PlugmemCli < Formula
  desc "CLI for the plugmem embedded memory engine."
  homepage "https://github.com/m62624/plugmem"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.9.0/plugmem-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3270008e6b18d4cbdf8cf411228d16e6b9a43741e125b62b78e9642c8ac733f1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.9.0/plugmem-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f65fcb9c6917c370fb35cee9e6cbc21d83d1ae87c6448e10379942aa0cb8c6bd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.9.0/plugmem-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "60d6237259994db3882fc1f0da9d90ba4058b0697b6e23a88c84ff29c4708efc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.9.0/plugmem-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2ab475c2f205b4f0fb6621fa1edd3eeadafc0671b688e7bbf6a36815356f6921"
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
