class PlugmemMcp < Formula
  desc "MCP stdio server exposing plugmem memory to AI agents."
  homepage "https://github.com/m62624/plugmem"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.9.0/plugmem-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "e9f2dcbc7154103bbb12fe599fa7cfbe8f61cdc24b0cdb51bf2bed55cd3e3cb2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.9.0/plugmem-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "71cbf17359c6f469768e48850edce1a868cadc6370cfc4e8f4bb82d0952fd0c3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/m62624/plugmem/releases/download/v0.9.0/plugmem-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4a7cc85086ea8b0dfe9cde0a70798ef5088003b87a92c04070fbb339d71bf543"
    end
    if Hardware::CPU.intel?
      url "https://github.com/m62624/plugmem/releases/download/v0.9.0/plugmem-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fd05671e7c9973a19780b98608c2f2565eb348e7770746ee63102e9635e79258"
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
