class PlugmemMcp < Formula
  desc "MCP stdio server exposing plugmem memory to AI agents."
  homepage "https://github.com/m62624/plugmem"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.12.0/plugmem-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "7ae8d1a91e8cc64804a7cb92e3113680bd772a1a29967c553c828d9095c857cf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.12.0/plugmem-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "ab8fb9c47b3e267960ee1ae184d51014386823c18e8926ed360d3d146c664e21"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.12.0/plugmem-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1e77d841294ef35f47f4672e622be09813547bbe7c8b743831a29ba5404578f7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.12.0/plugmem-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "31c3959e082b90c27f87f1758a58e0568c5edbfd7cd51962fdef814173f8aff8"
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
      bin.install "plugmem-mcp"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "plugmem-mcp"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "plugmem-mcp"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "plugmem-mcp"
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
