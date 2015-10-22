class Ecell4 < Formula
  desc "A multi-algorithm, multi-timescale biochemical simulation environment"
  homepage "https://github.com/ecell/ecell4"
  url "http://dev.e-cell.org/downloads/ecell-4.0.0.zip"
  sha256 "16b97620ac15d249318bccd0c23001b8ff381c74660f6a924fd437eb726997a8"
  
  head "https://github.com/ecell/ecell4.git"

  depends_on "cmake" => :build
  depends_on "gsl"
  depends_on "boost"
  depends_on "homebrew/science/hdf5"

  resource "cython" do
    url "http://cython.org/release/Cython-0.23.2.zip"
    sha256 "ca376b20b40312f70d4d19d79fc00909f591f1b2cc11c26eeccd17abfbdd7562"
  end

  def install
    args = %W[
      .
      -DCMAKE_INSTALL_PREFIX=#{prefix}
    ]

    system "cmake", *args
    system "cat", "ecell4/core/config.h"
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
