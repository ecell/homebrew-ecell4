# additional prerequisites for ubuntu
# apt-get install python-setuptools python-dev

# additional prerequisties for centos7
# linuxbrew does NOT figure out gcc and g++ in centos. you need to symlink with
# ln -s `which gcc` `brew --prefix`/bin/gcc-4.8
# ln -s `which g++` `brew --prefix`/bin/g++-4.8
# yum install python-setuptools python-devel

class Ecell4 < Formula
  desc "Multi algorithm-timescale bio-simulation environment"
  homepage "https://github.com/ecell/ecell4"
  url "https://github.com/ecell/ecell4/archive/4.0.0.zip"
  sha256 "64e20b2acff95690ce6dfb262e3b1596e6c33086f76380a4549ee72e60d0a204"

  head "https://github.com/ecell/ecell4.git"
  option "with-python3", "Build python3 bindings"

  depends_on "cmake" => :build
  depends_on "gsl" => :build
  depends_on "homebrew/versions/boost155" => :build
  depends_on "homebrew/science/hdf5"
  depends_on "pkg-config" => :build
  depends_on "ffmpeg" => %w[with-libvpx with-libvorbis]
  depends_on :python3 => :optional

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
    if build.with? "python3"

      resource("cython").stage do
        system "python3", *Language::Python.setup_install_args(buildpath/"vendor")
      end
      ENV.prepend_path "PYTHONPATH", buildpath/"vendor/lib/python3.5/site-packages"
      # centos needs lib64 path
      ENV.prepend_path "PYTHONPATH", buildpath/"vendor/lib64/python3.5/site-packages"
      cd "python" do
        ENV.prepend_create_path "PYTHONPATH", prefix/"lib/python3.5/site-packages"
        system "python3", "setup.py", "build_ext"
        system "python3", *Language::Python.setup_install_args(prefix)
      end
    else

      resource("cython").stage do
        system "python", *Language::Python.setup_install_args(buildpath/"vendor")
      end
      ENV.prepend_path "PYTHONPATH", buildpath/"vendor/lib/python2.7/site-packages"
      # centos needs lib64 path
      ENV.prepend_path "PYTHONPATH", buildpath/"vendor/lib64/python2.7/site-packages"
      cd "python" do
        ENV.prepend_create_path "PYTHONPATH", prefix/"lib/python2.7/site-packages"
        system "python", "setup.py", "build_ext"
        system "python", *Language::Python.setup_install_args(prefix)
      end
    end
  end
end
