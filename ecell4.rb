class Ecell4 < Formula
  desc "A multi-algorithm, multi-timescale biochemical simulation environment"
  homepage "https://github.com/ecell/ecell4"
  url "http://dev.e-cell.org/downloads/ecell-4.0.0.zip"
  sha256 "16b97620ac15d249318bccd0c23001b8ff381c74660f6a924fd437eb726997a8"

  depends_on "cmake" => :build
  depends_on "gsl"
  depends_on "boost"
  depends_on "homebrew/science/hdf5"

  resource "cython" do
    url "http://cython.org/release/Cython-0.23.tar.gz"
    sha256 "9fd01e8301c24fb3ba0411ad8eb16f5d9f9f8e66b1281fbe7aba2a9bd9d343dc"
  end

  def install
    args = %W[
      .
      -DCMAKE_INSTALL_PREFIX=#{prefix}
    ]

    system "cmake", *args
    system "make", "BesselTables"

    resource("cython").stage do
      system "python", *Language::Python.setup_install_args(buildpath/"vendor")
    end
    ENV.prepend_path "PYTHONPATH", buildpath/"vendor/lib/python2.7/site-packages"

    cd "python" do
      ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
      system "python", "setup.py", "build_ext"
      system "python", *Language::Python.setup_install_args(libexec)
    end

  end

end
