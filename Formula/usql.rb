$pkg     = "github.com/xo/usql"
$ver     = "v0.7.6"
$hash    = "e515b702d081a94f5dbd1bf3d698a2b7fb63a82b4790ca6e688645ef5a2b3aa9"

$cmdver  = $ver[1..-1]
$tags    = %w(most sqlite_app_armor sqlite_icu sqlite_fts5 sqlite_introspect sqlite_json1 sqlite_stat4 sqlite_userauth sqlite_vtable no_adodb no_ql)
$ldflags = "-s -w -X #{$pkg}/text.CommandVersion=#{$cmdver}"

class Usql < Formula
  desc     "universal command-line SQL client interface"
  homepage "https://#{$pkg}"
  head     "https://#{$pkg}.git"
  url      "https://#{$pkg}/archive/#{$ver}.tar.gz"
  sha256   $hash

  option "with-oracle",  "Build with Oracle database (instantclient) support"
  option "with-odbc",    "Build with ODBC (unixodbc) support"

  depends_on "go" => :build
  depends_on "icu4c" => :build

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
    if build.with? "oracle"
      ENV["PKG_CONFIG"] = "#{Formula["pkg-config"].opt_bin}/pkg-config"
      ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["instantclient-sdk"].lib}/pkgconfig"
    end

    (buildpath/"src/#{$pkg}").install buildpath.children

    cd "src/#{$pkg}" do
      system "go", "mod", "download"
      system "go", "build",
        "-tags",    $tags.join(" "),
        "-ldflags", $ldflags,
        "-o",       bin/"usql"
    end
  end

  test do
    output = shell_output("#{bin}/usql --version")
    assert_match "usql #{$cmdver}", output
  end
end
