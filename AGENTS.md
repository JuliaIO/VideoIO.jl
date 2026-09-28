# Notes for contributors and coding agents

## Supported FFmpeg versions

- VideoIO supports the two most recent FFmpeg major versions. The `FFMPEG_jll` compat entry in
  `Project.toml` lists one entry per supported major (e.g. `"8.0, 9.0"`). When support for a new
  major is added, drop the oldest one.
- Struct layouts and enum values change between majors, so each major has its own bindings file,
  `lib/libffmpeg_<major>.jl`, and `src/VideoIO.jl` loads the one matching the installed FFMPEG_jll.
  Delete the file of a dropped major.
- Code in `src/` must work with every supported major. When the newer major removes a field or
  function, use the replacement that exists in both (e.g. `avcodec_get_supported_config` instead of
  `AVCodec.pix_fmts`).
- CI tests the newest release of every FFMPEG_jll minor version that compat allows, so a compat
  bump from Dependabot runs the suite against the new major. The newest resolves in the main test
  matrix, and the older ones get extra jobs on Julia 1.

## Regenerating the bindings

- `gen/generate.jl` writes `lib/libffmpeg_<major>.jl` for the FFMPEG_jll version in the `gen`
  environment. Use a Julia version that Clang.jl 0.18 supports (1.11 works, 1.13 does not):

  ```sh
  cd gen
  julia +1.11 --project=. -e 'using Pkg; Pkg.add(name="FFMPEG_jll", version="9")'
  julia +1.11 --project=. generate.jl
  ```

- Do not edit the generated files by hand. Put fixes in `gen/` (`prologue.jl`, the
  `printer_blacklist` in `generate.toml`, `rewriter.jl`) so they survive regeneration.
- Headers for Windows and vendor SDKs (D3D, QSV, VideoToolbox, AMF, CUDA) are not available when
  generating, so the structs that use their types are not exact. VideoIO does not use them.
