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

function av_tree_find(root,key,cmp,next::NTuple{2,Ptr{Void}})
    ccall((:av_tree_find,libavutil),Ptr{Void},(Ptr{AVTreeNode},Ptr{Void},Ptr{Void},NTuple{2,Ptr{Void}}),root,key,cmp,next)
end

function av_tree_insert(rootp,key,cmp,next)
    ccall((:av_tree_insert,libavutil),Ptr{Void},(Ptr{Ptr{AVTreeNode}},Ptr{Void},Ptr{Void},Ptr{Ptr{AVTreeNode}}),rootp,key,cmp,next)
end

function av_tree_destroy(t)
    ccall((:av_tree_destroy,libavutil),Void,(Ptr{AVTreeNode},),t)
end

function av_tree_enumerate(t,opaque,cmp,enu)
    ccall((:av_tree_enumerate,libavutil),Void,(Ptr{AVTreeNode},Ptr{Void},Ptr{Void},Ptr{Void}),t,opaque,cmp,enu)
end
