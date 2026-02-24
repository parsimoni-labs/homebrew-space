class Space < Formula
  desc "SpaceOS CLI — build and boot SpaceOS VMs"
  homepage "https://parsimoni.co"
  license "ISC"
  version "20260223"

  on_macos do
    on_arm do
      url "https://homebrew-bottles.s3.fr-par.scw.cloud/space-20260223.arm64_sonoma.bottle.tar.gz"
      sha256 "b75bef01bf2538ce50440e9d109679c718469b2d94d4bcf73bb4d4745b5ed97c"
    end
    on_intel do
      url "https://homebrew-bottles.s3.fr-par.scw.cloud/space-latest.sonoma.bottle.tar.gz"
      sha256 :no_check
    end
  end

  on_linux do
    url "https://homebrew-bottles.s3.fr-par.scw.cloud/space-latest.x86_64_linux.bottle.tar.gz"
    sha256 :no_check
  end

  head "https://github.com/parsimoni-labs/mono.git", branch: "main"

  head do
    depends_on "ocaml" => :build
    depends_on "opam" => :build
    depends_on "dune" => :build
    depends_on "qemu" => :recommended
  end

  def install
    if build.head?
      system "opam", "init", "--disable-sandboxing", "--no-setup", "-y" unless File.exist?("#{Dir.home}/.opam")
      system "opam", "install", ".", "--deps-only", "--with-test=false", "-y", "--working-dir"
      system "opam", "exec", "--", "dune", "build", "space/bin/main.exe"
      bin.install "_build/default/space/bin/main.exe" => "space"
    else
      bin.install "space"
    end
  end

  test do
    system bin/"space", "--help"
  end
end
