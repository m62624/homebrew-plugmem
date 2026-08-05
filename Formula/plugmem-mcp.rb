class PlugmemMcp < Formula
  desc "MCP stdio server exposing plugmem memory to AI agents."
  homepage "https://github.com/m62624/plugmem"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.6.0/plugmem-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "484407ae3f29cdf9c7940e569db5408d30464920bbf232db1538416e76c2b86c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.6.0/plugmem-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "de1636d359ea44621d70d4e7fc9651f66c8055d6e2775fbf5a426ee7135482e4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.6.0/plugmem-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "433dad2e2a9d9f6944120a2a122c885130e7418a5c2ef4d176c62c557a2eaec4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.6.0/plugmem-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b80234ccf37d826fcb943a0d3df287c1315bc8c990a0e990088ab24e6b43f166"
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
