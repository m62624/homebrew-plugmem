class PlugmemMcp < Formula
  desc "MCP stdio server exposing plugmem memory to AI agents."
  homepage "https://github.com/m62624/plugmem"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.11.0/plugmem-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "1748dc0d03bab753037e0541c6ea0439ac9df344f9f208f27e710813827796d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.11.0/plugmem-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "452309fe20ae5b130d3bb5d511b177ed1cb38124560ca6c91984c80c820ad798"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.11.0/plugmem-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a5db08607667fde8c53869d3bd259cf21afc0b5e730fbaeffab41134fad6cbc3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.11.0/plugmem-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b1c4b492ba11074109474ca0941fbf0ddcbc9256ee0112efe32be36411228fbe"
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
