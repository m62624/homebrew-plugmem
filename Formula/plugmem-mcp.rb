class PlugmemMcp < Formula
  desc "MCP stdio server exposing plugmem memory to AI agents."
  homepage "https://github.com/m62624/plugmem"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.10.0/plugmem-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "d61d03fb375c99effeabea101154359166d122e39b2b6dadc2327b880731bf63"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.10.0/plugmem-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "5a4c59abfdbe44a6dc6b4741d5220d965b1fe0a767eaf0beba6bdd1e7c05c9ed"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.10.0/plugmem-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7ef2876d9cf77f999c4e654d9ee30e1da79ea0e56fc91bbd389fccbe5e1dfa47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.10.0/plugmem-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e86de8d6ee57e258b74be7b0472a48cfca1be96030678fe4c1c583d28198e421"
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
