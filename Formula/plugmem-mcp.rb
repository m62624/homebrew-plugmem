class PlugmemMcp < Formula
  desc "MCP stdio server exposing plugmem memory to AI agents."
  homepage "https://github.com/m62624/plugmem"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.7.1/plugmem-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "1b9e56b46145fab700eea33a8b6058d8d33981e7b33ef02a1932db3e03234705"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.7.1/plugmem-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "2056e322b69f47d2d517c5d4eb211af4f5724ddc8600f2438ea9867d40d01f2e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.7.1/plugmem-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2015d262b744ced11e92e6822093f857b44d7296b291baa28f665656e1449aef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.7.1/plugmem-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9c4a80ce2e6e95f79753adf2c008a9b867c13a53a63108d313442bfb5f5325bb"
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
