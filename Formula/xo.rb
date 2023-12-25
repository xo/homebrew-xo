$pkg     = "github.com/xo/xo"

class Xo < Formula
  desc "the templated code generator for databases"
  homepage "https://#{$pkg}"
  head "https://#{$pkg}.git"
  url "https://github.com/xo/xo/archive/v1.0.1.tar.gz"
  sha256 "9a36068c0e69f1da25ef4d3bf1070d8315bf32054d52f631388306c8b48d6b4d"

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
