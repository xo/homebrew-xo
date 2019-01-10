$pkg     = "github.com/xo/usql"
$ver     = "v0.7.1"
$hash    = "18f541dab352931937276bec5f723da94356a804c894359c6d428ad980eb14fc"

$tags    = %w(most sqlite_app_armor sqlite_fts5 sqlite_icu sqlite_introspect sqlite_json1 sqlite_stat4 sqlite_userauth sqlite_vtable no_adodb no_ql)
$ldflags = "-s -w -X #{$pkg}/text.CommandVersion=#{$ver}"

class Usql < Formula
  desc     "universal command-line SQL client interface"
  homepage "https://#{$pkg}"
  head     "https://#{$pkg}.git"
  url      "https://#{$pkg}/archive/#{$ver}.tar.gz"
  sha256   $hash

  option "with-oracle", "Build with Oracle database (instantclient) support"
  option "with-odbc",   "Build with ODBC (unixodbc) support"

  depends_on "go" => :build

  if build.with? "oracle" then
    $tags   << "oracle"
    depends_on "pkg-config"
    depends_on "instantclient-sdk"
  end

  if build.with? "odbc" then
    $tags   << "odbc"
    depends_on "unixodbc"
  end

  def install
    ENV["GOPATH"]      = buildpath
    ENV["GO111MODULE"] = "on"

    if build.with? "oracle"
      ENV["PKG_CONFIG"] = "#{Formula["pkg-config"].opt_bin}/pkg-config"
      ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["instantclient-sdk"].lib}/pkgconfig"
    end

    (buildpath/"src/#{$pkg}").install buildpath.children

    cd "src/#{$pkg}" do
      system "go", "build",
        "-tags",    $tags.join(" "),
        "-ldflags", $ldflags,
        "-o",       bin/"usql"
    end
  end

  test do
    ENV["GOPATH"]      = testpath.realpath
    ENV["GO111MODULE"] = "on"
    output = shell_output("#{bin}/usql --version")
    assert_match "usql #{$ver}", output
  end
end
