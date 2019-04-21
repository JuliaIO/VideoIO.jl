# Julia wrapper for header: /usr/local/include/libavutil/tree.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


export
    av_tree_node_alloc,
    av_tree_find,
    av_tree_insert,
    av_tree_destroy,
    av_tree_enumerate


function av_tree_node_alloc()
    ccall((:av_tree_node_alloc,libavutil),Ptr{AVTreeNode},())
end

function av_tree_find(root,key,cmp,next::NTuple{2,Ptr{Cvoid}})
    ccall((:av_tree_find,libavutil),Ptr{Cvoid},(Ptr{AVTreeNode},Ptr{Cvoid},Ptr{Cvoid},NTuple{2,Ptr{Cvoid}}),root,key,cmp,next)
end

function av_tree_insert(rootp,key,cmp,next)
    ccall((:av_tree_insert,libavutil),Ptr{Cvoid},(Ptr{Ptr{AVTreeNode}},Ptr{Cvoid},Ptr{Cvoid},Ptr{Ptr{AVTreeNode}}),rootp,key,cmp,next)
end

function av_tree_destroy(t)
    ccall((:av_tree_destroy,libavutil),Cvoid,(Ptr{AVTreeNode},),t)
end

function av_tree_enumerate(t,opaque,cmp,enu)
    ccall((:av_tree_enumerate,libavutil),Cvoid,(Ptr{AVTreeNode},Ptr{Cvoid},Ptr{Cvoid},Ptr{Cvoid}),t,opaque,cmp,enu)
end
