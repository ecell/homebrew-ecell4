# additional prerequisites for ubuntu
# apt-get install python-setuptools python-dev

# additional prerequisties for centos7
# linuxbrew does NOT figure out gcc and g++ in centos. you need to symlink with
# ln -s `which gcc` `brew --prefix`/bin/gcc-4.8
# ln -s `which g++` `brew --prefix`/bin/g++-4.8
# yum install python-setuptools python-devel

class Ecell4 < Formula
  desc "A multi-algorithm, multi-timescale biochemical simulation environment"
  homepage "https://github.com/ecell/ecell4"
  url "http://dev.e-cell.org/downloads/ecell4-ff3fef040dfa46656156160d4006c3836f97550b.zip"
  sha256 "8fafe0c42996c5a1997371b4808c71d52de0600a8ab971332f891f1f2161f504"

  head "https://github.com/ecell/ecell4.git"
  
  option "with-python3", "Build python3 bindings"

  depends_on "cmake" => :build
  depends_on "gsl"
  depends_on "boost"
  depends_on "homebrew/science/hdf5"
  depends_on "pkg-config"
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
