load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def _k8s_deps_impl(module_ctx):
    http_archive(
        name = "com_github_yaml_pyyaml",
        build_file_content = """
py_library(
    name = "yaml",
    srcs = glob(["lib/yaml/*.py"]),
    imports = [
        "lib",
    ],
    visibility = ["//visibility:public"],
)

py_library(
    name = "yaml3",
    srcs = glob(["lib3/yaml/*.py"]),
    imports = [
        "lib3",
    ],
    visibility = ["//visibility:public"],
)
    """,
        sha256 = "e9df8412ddabc9c21b4437ee138875b95ebb32c25f07f962439e16005152e00e",
        strip_prefix = "pyyaml-5.1.2",
        urls = ["https://github.com/yaml/pyyaml/archive/5.1.2.zip"],
    )

# This normally would have been invoked by k8s_repositories(), but we have our own
# simpler version of this rule.
#load("//toolchains/kubectl:kubectl_configure.bzl", "kubectl_configure")
#kubectl_configure(name = "k8s_config", build_srcs = False)

    git_repository(
        name = "subpar",
        remote = "https://github.com/google/subpar.git",
        #tag = "2.0.0",
        commit = "35bb9f0092f71ea56b742a520602da9b3638a24f",
    )

    return module_ctx.extension_metadata(
        reproducible = True,
        root_module_direct_deps = [
            "com_github_yaml_pyyaml",
            "subpar",
        ],
        root_module_direct_dev_deps = [],
    )

k8s_deps = module_extension(
    implementation = _k8s_deps_impl,
    tag_classes = {
        "all": tag_class(
            attrs = {
            },
        ),
    },
)

