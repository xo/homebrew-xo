$ver     = "v0.6.0-rc3"
$hash    = "8c1f0a4328d94b0dd020648d4c3dc1cee2e97202ce693c1ef18fb610781cce33"
$pkg     = "github.com/xo/usql"

$tags    = %w(most fts5 vtable json1 no_adodb)
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
  depends_on "dep" => :build

  if build.with? "oracle" then
    $tags   << "oracle"
    depends_on "pkg-config"        => :build,
               "instantclient-sdk" => [:build, :run]
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
      system "dep", "ensure", "--vendor-only"

      system "go", "build",
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
