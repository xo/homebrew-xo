$ver     = "v0.6.0-rc1"
$hash    = "dab5524f7f5f96a24baac8cb5281cd33b5e1054d554a6f4647a3bb788752a578"

$tags    = "most fts5 vtable json1 no_adodb"
$ldflags = "-s -w -X github.com/xo/usql/text.CommandVersion=#{$ver}"

class Usql < Formula
  desc     "universal command-line SQL client interface"
  homepage "https://github.com/xo/usql"
  head     "https://github.com/xo/usql.git"
  url      "https://github.com/xo/usql/archive/#{$ver}.tar.gz"
  sha256   $hash

  depends_on "go"  => :build
  depends_on "dep" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/xo/usql").install buildpath.children

    cd "src/github.com/xo/usql" do
      system "dep", "ensure"

      system "go", "build",
        "-tags",    $tags,
        "-ldflags", $ldflags,
        "-o",       bin/"usql"
    end
  end

  test do
    ENV["GOPATH"] = testpath.realpath
    output = shell_output("#{bin}/usql --version")
    assert_match "usql #{$ver}", output
  end
end
