class GoLivepeer < Formula
  desc "Official Go implementation of the Livepeer protocol"
  homepage "https://livepeer.org/"
  url "https://github.com/livepeer/go-livepeer.git",
      tag:      "v0.5.35",
      revision: "e87d7366b4a077a59fa1c307ea4ee107bf8abe4a"
  license "MIT"
  head "https://github.com/livepeer/go-livepeer.git",
       branch: "master"

  option "with-dev", "build with support for only development networks"

  depends_on "autoconf" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build

  env :std

  on_macos do
    depends_on "coreutils" => :build
    depends_on "llvm" => :build
  end

  def install
    tags = ((build.with? "dev") && "dev") || "mainnet"
    system "./install_ffmpeg.sh", Dir.home
    ENV["BUILD_TAGS"] = tags
    ENV["PKG_CONFIG_PATH"] = "#{Dir.home}/compiled/lib/pkgconfig"
    system "make", "livepeer", "livepeer_bench", "livepeer_cli", "livepeer_router"
    bin.install "livepeer"
    bin.install "livepeer_bench"
    bin.install "livepeer_cli"
    bin.install "livepeer_router"
  end

  test do
    system "#{bin}/livepeer", "--version"
  end
end
