$pkg     = "github.com/xo/xo"

class Xo < Formula
  desc "the templated code generator for databases"
  homepage "https://#{$pkg}"
  head "https://#{$pkg}.git"
  url "https://github.com/xo/xo/archive/v1.0.2.tar.gz"
  sha256 "f5114ca06515ff1c1ee24d14ea05e483963aab5ee5dff76a7fb2941e10be4b9e"

  depends_on "go" => :build

  def install
    (buildpath/"src/#{$pkg}").install buildpath.children

    cd "src/#{$pkg}" do
      system "go", "mod", "download"
      system "go", "build",
        "-trimpath",
        "-ldflags", "-s -w -X main.version=#{self.version}",
        "-o",       bin/"xo"
    end
  end

  test do
    output = shell_output("#{bin}/xo --version")
    assert_match "xo #{self.version}", output
  end
end
