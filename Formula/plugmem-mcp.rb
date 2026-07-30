class PlugmemMcp < Formula
  desc "MCP stdio server exposing plugmem memory to AI agents."
  homepage "https://github.com/m62624/plugmem"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.1.3/plugmem-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "7156ae008202b747d55bd0a9474301e45c4bff1fd3cc779770fc68af34c85225"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.1.3/plugmem-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "2804effd0b529b17e726d9cdd479eb3bbd77ee89ecd568ef5a3a1ab24009a38a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.1.3/plugmem-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "55055fdf2d70050269fd438032b66bd3790995fd78b742346de66f5d16ebf836"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.1.3/plugmem-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f1a98fd39fea467a6c9d0c266397db30265c36af7ed3723fb7629549d869eca1"
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
