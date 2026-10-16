# SPDX-License-Identifier: Apache-2.0
# Copyright 2026 Amer Ghazal
#
# Binary formula over the macOS universal2 tar.gz; rendered by tools/release/publish_homebrew.sh
# (1.1.0, https://github.com/amerghazal7/overlume/releases/download/v1.1.0/overlume-1.1.0-macos-universal.tar.gz, 4755f98998827849cbc181368f845d82d0a4f59cce11e10543c4943342bc3a55).
class Overlume < Formula
  desc "Real-time robot-scene rendering library behind a POD-only C++ API"
  homepage "https://github.com/amerghazal7/overlume"
  url "https://github.com/amerghazal7/overlume/releases/download/v1.1.0/overlume-1.1.0-macos-universal.tar.gz"
  version "1.1.0"
  sha256 "4755f98998827849cbc181368f845d82d0a4f59cce11e10543c4943342bc3a55"
  license "Apache-2.0"

  depends_on macos: :ventura
  depends_on "cmake" => :test

  def install
    prefix.install Dir["*"]
  end

  test do
    # create_renderer with a 0x0 config returns nullptr whatever the GPU: proves the package
    # configures, links and runs.
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.16)
      project(overlume_formula_test CXX)
      set(CMAKE_CXX_STANDARD 17)
      find_package(overlume REQUIRED)
      add_executable(t main.cpp)
      target_link_libraries(t PRIVATE overlume::overlume)
    CMAKE
    (testpath/"main.cpp").write <<~CPP
      #include <overlume/api.h>
      int main() {
        overlume::RenderConfig config{};
        return overlume::create_renderer(config) == nullptr ? 0 : 1;
      }
    CPP
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_PREFIX_PATH=#{prefix}"
    system "cmake", "--build", "build"
    system "./build/t"
  end
end
