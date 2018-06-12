$ver     = "v0.7.0-rc4"
$hash    = "d25f7de83523d4ea297b7e1beae512fe21d81b3c96bb9d3c3f13f6f848463e51"
$pkg     = "github.com/xo/usql"

$tags    = %w(most fts5 vtable json1 no_adodb no_ql)
$ldflags = "-s -w -X #{$pkg}/text.CommandVersion=#{$ver}"

class Usql < Formula
  desc     "universal command-line SQL client interface"
  homepage "https://#{$pkg}"
  head     "https://#{$pkg}.git"
  url      "https://#{$pkg}/archive/#{$ver}.tar.gz"
  sha256   $hash

  option "with-oracle", "Build with Oracle database (instantclient) support"
  option "with-odbc",   "Build with ODBC (unixodbc) support"

  depends_on "go"  => :build

  if build.with? "oracle" then
    $tags   << "oracle"
    depends_on "pkg-config"        => :build,
               "instantclient-sdk" => :build
  end

  if build.with? "odbc" then
    $tags   << "odbc"
    depends_on "unixodbc"
  end

  def install
    ENV["GOPATH"]     = buildpath

    if build.with? "oracle"
      ENV["PKG_CONFIG"] = "#{Formula["pkg-config"].opt_bin}/pkg-config"
      ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["instantclient-sdk"].lib}/pkgconfig"
    end

    (buildpath/"src/#{$pkg}").install buildpath.children

    cd "src/#{$pkg}" do
      system "go", "get", "-u", "golang.org/x/vgo"

      system "vgo", "build",
        "-tags",    $tags.join(" "),
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
