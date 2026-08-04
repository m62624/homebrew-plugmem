class PlugmemMcp < Formula
  desc "MCP stdio server exposing plugmem memory to AI agents."
  homepage "https://github.com/m62624/plugmem"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.4.0/plugmem-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "56e62e8cf38de83e395eef4dce7e0924a39e64089ce29123bd6237d8862ff6ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.4.0/plugmem-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "1c8bda20f6f10a8925f657a574e4b8ae8a19ef20b08feb17e326c1dab0820aaa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.4.0/plugmem-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0cd4857789860a52fab63238838e1a03ae22e28146451f71e5c20885b359e77a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.4.0/plugmem-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f2c61b35272b8e94254da0fc5fccbfa47a7784e52c9e2a97dad92128b36eb9a4"
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
    bin.install "plugmem-mcp" if OS.mac? && Hardware::CPU.arm?
    bin.install "plugmem-mcp" if OS.mac? && Hardware::CPU.intel?
    bin.install "plugmem-mcp" if OS.linux? && Hardware::CPU.arm?
    bin.install "plugmem-mcp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
