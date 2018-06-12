$pkg     = "golang.org/x/vgo"
$commit  = "93f360beebe966cc4548016d1f4f3a037ba9f022"
$hash    = "5500947eb4e5ac085f10a6fa034b029942edeead15af38eb3224e3c6f47792bd"

class Vgo < Formula
  desc     "vgo: versioned go"
  homepage "https://research.swtch.com/vgo-tour"
  head     "https://github.com/golang/vgo.git"
  url      "https://github.com/golang/vgo/archive/#{$commit}.tar.gz"
  sha256   $hash

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/#{$pkg}").install buildpath.children

    cd "src/#{$pkg}" do
      system "go", "build", "-o", bin/"vgo"
    end
  end

  test do
    ENV["GOPATH"] = testpath.realpath
    output = shell_output("#{bin}/vgo version")
    assert_match(/vgo:2018-02-20/, output)
  end
end
