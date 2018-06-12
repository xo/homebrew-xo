class InstantclientSdk < Formula
  desc "Oracle Instant Client SDK x64."
  homepage "http://www.oracle.com/technetwork/topics/intel-macsoft-096467.html"
  url "https://raw.githubusercontent.com/strongloop/loopback-oracle-builder/master/deps/oracle/MacOSX/x64/instantclient-basiclite-macos.x64-12.1.0.2.0.zip"
  sha256 "ac7e97661a2bfac69b3262150641914f456c7806ba2a7850669fb83abac120e8"

  depends_on "pkg-config" => :build

  resource "instantclient-sdk" do
    url "https://raw.githubusercontent.com/strongloop/loopback-oracle-builder/master/deps/oracle/MacOSX/x64/instantclient-sdk-macos.x64-12.1.0.2.0.zip"
    sha256 "63582d9a2f4afabd7f5e678c39bf9184d51625c61e67372acdbc7b42ed8530ac"
  end

  def install
    %w(libclntsh.dylib libocci.dylib).each do |dylib|
      ln_s "#{dylib}.12.1", dylib
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
    check_pc("modversion", "12.1.0.2.0")
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
