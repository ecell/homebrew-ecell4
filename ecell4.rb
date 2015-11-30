# prerequisites
# apt-get install python-setuptools python-dev
class Ecell4 < Formula
  desc "A multi-algorithm, multi-timescale biochemical simulation environment"
  homepage "https://github.com/ecell/ecell4"
  url "http://dev.e-cell.org/downloads/ecell4.zip"
  sha256 "bdbd8f406e230cbb2d566b9795bdfd3953cda67160d186bd0ca8ed8a3cf604b4"

  head "https://github.com/ecell/ecell4.git"

  depends_on "cmake" => :build
  depends_on "gsl"
  depends_on "boost"
  depends_on "homebrew/science/hdf5"
  depends_on "pkg-config"

  resource "cython" do
    url "http://cython.org/release/Cython-0.23.4.zip"
    sha256 "44444591133c92a30d78a6ec52ea4afd902ee4548ca5e83d94388f6a99f6c9ae"
  end

  def install
    args = %W[
      .
      -DCMAKE_INSTALL_PREFIX=#{prefix}
    ]
    ENV["CPATH"] = "#{HOMEBREW_PREFIX}/include:#{buildpath}"

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
