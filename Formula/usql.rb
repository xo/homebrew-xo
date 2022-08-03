$pkg     = "github.com/xo/usql"
$tags    = %w(most sqlite_app_armor sqlite_icu sqlite_fts5 sqlite_introspect sqlite_json1 sqlite_stat4 sqlite_userauth sqlite_vtable no_adodb)

class Usql < Formula
  desc "universal command-line SQL client interface"
  homepage "https://#{$pkg}"
  head "https://#{$pkg}.git"
  url "https://github.com/xo/usql/archive/v0.11.1.tar.gz"
  version "v0.11.1"
  sha256 "66a84057ea4d795319dd20f6e1b85343fcc4c2770cfe9bb4582842d4d90d3932"

  option "with-odbc", "Build with ODBC (unixodbc) support"

  depends_on "go" => :build
  depends_on "icu4c" => :build

  if build.with? "odbc" then
    $tags   << "odbc"
    depends_on "unixodbc"
  end

  def install
    (buildpath/"src/#{$pkg}").install buildpath.children

    cmdver = ("#{self.version}")[1..-1]
    cd "src/#{$pkg}" do
      system "go", "mod", "download"
      system "go", "build",
        "-trimpath",
        "-tags",    $tags.join(" "),
        "-ldflags", "-s -w -X #{$pkg}/text.CommandVersion=#{cmdver}",
        "-o",       bin/"usql"
    end
  end

  test do
    cmdver = ("#{self.version}")[1..-1]
    output = shell_output("#{bin}/usql --version")
    assert_match "usql #{cmdver}", output
  end
end
