class PlugmemCli < Formula
  desc "CLI for the plugmem embedded memory engine."
  homepage "https://github.com/m62624/plugmem"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.10.0/plugmem-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e912368e3d99327a97b284fb895f92980440ee945ed67f7fcbf084f2121b4b55"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.10.0/plugmem-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1ff53ccc6b85e0cfc11f770fc45d424f7917cb77b4cc02678782abefe6981677"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.10.0/plugmem-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b0a53ce299bb4590e444c47fa9c3078813771fe070ade93b251fc8081379e89f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.10.0/plugmem-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "63bb04639c8df7db50a8d4e2c11afb86b4c39f4cc45c8900d4c151e71582d819"
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
