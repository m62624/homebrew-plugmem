class PlugmemMcp < Formula
  desc "MCP stdio server exposing plugmem memory to AI agents."
  homepage "https://github.com/m62624/plugmem"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.1.4/plugmem-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "c89b13dd0a7376f8d2dc650c554657d28f5591b61903d3016c1b3433e390c9e0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.1.4/plugmem-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "7370f4bccf21ce4ca767874a0133cae1ae232b96acb8830e6893f9289a31f9b1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.1.4/plugmem-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b4407e966b006f3aeae9ba90352040673c1021984eda682f04f60b3a2cc8cb56"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.1.4/plugmem-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f2bd07e118af029139fd0641641a5017d2b9cf14c5a178537eafae70af5b0bad"
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
