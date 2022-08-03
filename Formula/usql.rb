$pkg     = "github.com/xo/usql"
$tags    = %w(most sqlite_app_armor sqlite_icu sqlite_fts5 sqlite_introspect sqlite_json1 sqlite_stat4 sqlite_userauth sqlite_vtable no_adodb)

class Usql < Formula
  desc "universal command-line SQL client interface"
  homepage "https://#{$pkg}"
  head "https://#{$pkg}.git"
  url "https://github.com/xo/usql/archive/v0.11.9.tar.gz"
  version "v0.11.9"
  sha256 "4f50097a18c1d43223f295d8f29b5d7a68d154d5288664a37a387842ee5ece7e"

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
