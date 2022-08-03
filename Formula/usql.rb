$pkg     = "github.com/xo/usql"
$tags    = %w(most sqlite_app_armor sqlite_icu sqlite_fts5 sqlite_introspect sqlite_json1 sqlite_stat4 sqlite_userauth sqlite_vtable no_adodb)

class Usql < Formula
  desc "universal command-line SQL client interface"
  homepage "https://#{$pkg}"
  head "https://#{$pkg}.git"
  url "https://github.com/xo/usql/archive/v0.11.12.tar.gz"
  version "v0.11.12"
  sha256 "c90df5f0781bc2b351aedf7a0c30115453cd1b6f6390464676a0dc788eedd741"

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
