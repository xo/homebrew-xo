$pkg     = "github.com/xo/usql"
$tags    = %w(most sqlite_app_armor sqlite_fts5 sqlite_introspect sqlite_json1 sqlite_math_functions sqlite_stat4 sqlite_vtable no_adodb)

class Usql < Formula
  desc "universal command-line SQL client interface"
  homepage "https://#{$pkg}"
  head "https://#{$pkg}.git"
  url "https://github.com/xo/usql/archive/v0.20.2.tar.gz"
  sha256 "04b76e916e9ce926ac0e365a9bb5a73a8e15220501a7f2a0c68cc86627d637f3"

  option "with-odbc", "Build with ODBC (unixodbc) support"

  depends_on "go" => :build
  depends_on "icu4c" => :build

  if build.with? "odbc" then
    $tags   << "odbc"
    depends_on "unixodbc"
  end

  def install
    (buildpath/"src/#{$pkg}").install buildpath.children

    cd "src/#{$pkg}" do
      system "go", "mod", "download"
      system "go", "build",
        "-trimpath",
        "-tags",    $tags.join(" "),
        "-ldflags", "-s -w -X #{$pkg}/text.CommandVersion=#{self.version}",
        "-o",       bin/"usql"
    end
  end

  test do
    output = shell_output("#{bin}/usql --version")
    assert_match "usql #{self.version}", output
  end
end
