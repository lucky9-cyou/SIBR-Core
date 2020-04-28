from conans import ConanFile, CMake, tools

class SIBRConan(ConanFile):
    name = "SIBR"
    version = "0.9"
    description = """This is an SIBR app.
                    Build it at your convenience."""
    generators = "cmake_multi", "cmake_find_package_multi"
    settings = "os", "arch", "compiler", "build_type"
    requires = [
                ("assimp/5.0.1"),
                ("boost/1.74.0"),
                ("eigen/3.3.8"),
                ("embree3/3.12.0"),
                ("ffmpeg/4.2.1@bincrafters/stable"),
                ("freetype/2.10.4"),
                ("libiconv/1.16"),
                ("glew/2.1.0"),
                ("glfw/3.3.2"),
                ("openmesh/8.1"),
                ("opencv/4.5.0"),
                ("xz_utils/5.2.5"),
                ("libwebp/1.1.0")
            ]
    default_options = {
                "assimp:shared": True,
                "boost:shared": True,
                "ffmpeg:shared": True,
                "glew:shared": True,
                "glfw:shared": True,
                "openmesh:shared": True,
                "opencv:shared": True,
                "opencv:contrib": True
            }

    def source(self):
        print("nothing to do")
        # self.run("git clone https://gitlab.inria.com/sibr/sibr_core.git")

    def build(self):
        cmake = CMake(self)
        cmake.configure(source_folder=".")
        cmake.build()