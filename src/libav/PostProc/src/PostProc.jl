module PostProc
  include(joinpath(Pkg.dir("VideoIO"),"src","init.jl"))

  if have_postproc()
      w(f) = joinpath(postproc_dir, f)
      include(w("LIBPOSTPROC.jl"))
  else
      error("PostProc: libpostproc not found")
  end
end
