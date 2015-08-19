class Ecell4 < Formula
  desc "A multi-algorithm, multi-timescale biochemical simulation environment"
  homepage "https://github.com/ecell/ecell4"
  url "http://dev.e-cell.org/downloads/ecell-4.0.0.zip"
  sha256 "16b97620ac15d249318bccd0c23001b8ff381c74660f6a924fd437eb726997a8"

  depends_on "cmake" => :build

  def install
    args = %W[
      .
      -DCMAKE_INSTALL_PREFIX=#{prefix}
    ]

    system "cmake", *args
    system "make"
    system "make", "install"
  end

end
