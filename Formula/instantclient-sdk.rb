class InstantclientSdk < Formula
  desc "Oracle Instant Client SDK x64."
  homepage "https://www.oracle.com/sg/database/technologies/instant-client/macos-intel-x86-downloads.html"
  url "https://download.oracle.com/otn_software/mac/instantclient/198000/instantclient-basiclite-macos.x64-19.8.0.0.0dbru.zip"
  sha256 "82fcc280726dafad0254f31a5dc7361c8ebce18e5eb4ed676a4143dda8aab9af"

  depends_on "pkg-config" => :build

  resource "instantclient-sdk" do
    url "https://download.oracle.com/otn_software/mac/instantclient/198000/instantclient-sdk-macos.x64-19.8.0.0.0dbru.zip"
    sha256 "0fa8ae4c4418aa66ce875cf92e728dd7a81aeaf2e68e7926e102b5e52fc8ba4c"
  end

  def install
    %w(libclntsh.dylib libocci.dylib).each do |dylib|
      ln_s "#{dylib}.19.8", dylib
    end
    lib.install Dir["*.dylib*"]

    resource("instantclient-sdk").stage do
      lib.install ["sdk"]
    end

    (lib+"pkgconfig/oci8.pc").write pc_file
  end

  def check_pc(name, expected)
    assert_match expected, shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --#{name} oci8")
  end

  test do
    check_pc("modversion", "19.8.0.0.0")
    check_pc("cflags", "-I/usr/local/opt/instantclient-sdk/lib/sdk/include")
  end

  def pc_file; <<~EOS
    prefix=#{opt_prefix}

    Name: OCI
    Description: Oracle Instant Client
    Version: #{version}
    Libs: -L${prefix}/lib -lclntsh
    Libs.private:
    Cflags: -I${prefix}/lib/sdk/include
    EOS
  end
end
