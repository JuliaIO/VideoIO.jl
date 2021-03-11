using Base: fieldindex, RefValue, unsafe_convert
using Base.Libc: calloc, free
using Base.GC: @preserve

using VideoIO: NestedCStruct, nested_wrap, field_ptr, check_ptr_valid, @avptr

struct TestChildStruct
    e::NTuple{4, Int}
    f::Cint
    g::Ptr{Int}
end

struct TestParentStruct
    a::Int
    b::Float64
    c::Ptr{Int}
    d::Ptr{TestChildStruct}
end

function make_TestChildStruct(;e::NTuple{4, Int} = (1, 2, 3, 4),
                                   f::Cint = Cint(-1),
                                   g::Ptr{Int} = Ptr{Int}())
    mem = Vector{UInt8}(undef, sizeof(TestChildStruct))
    mem_ptr = pointer(mem)
    @preserve mem begin
        e_arr = unsafe_wrap(Array, convert(Ptr{Int}, mem_ptr), (4,))
        e_arr .= e
        f_ptr = convert(Ptr{Cint}, mem_ptr + fieldoffset(TestChildStruct, 2))
        unsafe_store!(f_ptr, f)
        g_ptr = convert(Ptr{Ptr{Int}}, mem_ptr + fieldoffset(TestChildStruct, 3))
        unsafe_store!(g_ptr, g)
    end
    mem
end

function make_TestParentStruct(;a::Int = -1, b::Float64 = 0.0,
                                    c::Ptr{Int} = Ptr{Int}(),
                                    d::Ptr{TestChildStruct} = Ptr{TestChildStruct}())
    mem = Vector{UInt8}(undef, sizeof(TestParentStruct))
    mem_ptr = pointer(mem)
    @preserve mem begin
        a_ptr = convert(Ptr{Int}, mem_ptr)
        unsafe_store!(a_ptr, a)
        b_ptr = convert(Ptr{Float64}, mem_ptr + fieldoffset(TestParentStruct, 2))
        unsafe_store!(b_ptr, b)
        c_ptr = convert(Ptr{Ptr{Int}}, mem_ptr + fieldoffset(TestParentStruct, 3))
        unsafe_store!(c_ptr, c)
        d_ptr = convert(Ptr{Ptr{TestChildStruct}}, mem_ptr + fieldoffset(TestParentStruct, 4))
        unsafe_store!(d_ptr, d)
    end
    mem
end

@testset "Pointer utilities" begin
    child_ptr_null = Ptr{TestChildStruct}()
    e_ptr = field_ptr(child_ptr_null, :e)
    @test e_ptr == child_ptr_null
    @test e_ptr isa Ptr{NTuple{4, Int}}
    f_ptr_pos = child_ptr_null + fieldoffset(TestChildStruct, 2)
    f_ptr = field_ptr(child_ptr_null, :f)
    @test f_ptr == f_ptr_pos
    @test f_ptr isa Ptr{Cint}
    f_ptr_UInt32 = field_ptr(UInt32, child_ptr_null, :f)
    @test f_ptr_UInt32 == f_ptr_pos
    @test f_ptr_UInt32 isa Ptr{UInt32}

    @test check_ptr_valid(C_NULL, false) == false
    @test_throws ErrorException check_ptr_valid(C_NULL)
    @test check_ptr_valid(f_ptr) == true
    @test check_ptr_valid(f_ptr, false) == true
end

@testset "AVPtr" begin
    @testset "NestedCStruct" begin
        g = convert(Ptr{Int}, calloc(4, sizeof(Int)))
        try
            g_arr = unsafe_wrap(Array, g, (4,))
            g_arr .= 1:4
            child_mem = make_TestChildStruct(;g = g)
            child_ptr = convert(Ptr{TestChildStruct}, pointer(child_mem))
            @preserve child_mem begin
                parent_mem = make_TestParentStruct(;c = g, d = child_ptr)
                parent_ptr = convert(Ptr{TestParentStruct}, pointer(parent_mem))
                @preserve parent_mem begin
                    parent_nested_ptr = NestedCStruct(parent_ptr)
                    @testset "NestedCStruct constructors" begin
                        @test parent_nested_ptr isa NestedCStruct{TestParentStruct}
                        inner_ref = getfield(parent_nested_ptr, :data)
                        @test inner_ref isa Ref{Ptr{TestParentStruct}}
                        @test inner_ref[] == parent_ptr
                        void_pointer = convert(Ptr{Nothing}, parent_ptr)
                        parent_nested_ptr_from_null = NestedCStruct{TestParentStruct}(void_pointer)
                        @test parent_nested_ptr_from_null isa NestedCStruct{TestParentStruct}
                        inner_ref_from_null = getfield(parent_nested_ptr_from_null, :data)
                        @test inner_ref_from_null isa Ref{Ptr{TestParentStruct}}
                        @test inner_ref_from_null[] == parent_ptr
                        nested_null_ptr = NestedCStruct(C_NULL)
                        @test nested_null_ptr isa NestedCStruct{Nothing}
                    end

                    @testset "NestedCStruct pointer conversion" begin
                        derived_ptr = unsafe_convert(Ptr{TestParentStruct}, parent_nested_ptr)
                        @test derived_ptr == parent_ptr
                        derived_dptr = unsafe_convert(Ptr{Ptr{TestParentStruct}}, parent_nested_ptr)
                        @test derived_dptr isa Ptr{Ptr{TestParentStruct}}
                        @test unsafe_load(derived_dptr) == parent_ptr
                        derived_null_ptr = unsafe_convert(Ptr{Nothing}, parent_nested_ptr)
                        @test derived_null_ptr isa Ptr{Nothing}
                        @test derived_null_ptr == parent_ptr
                        derived_null_dptr = unsafe_convert(Ptr{Ptr{Nothing}}, parent_nested_ptr)
                        @test derived_null_dptr isa Ptr{Ptr{Nothing}}
                        @test unsafe_load(derived_null_dptr) == parent_ptr
                    end

                    @testset "NestedCStruct field pointers" begin
                        b_field_ptr = convert(Ptr{Float64}, parent_ptr + fieldoffset(TestParentStruct, 2))
                        @test field_ptr(parent_nested_ptr, :b) == b_field_ptr
                        @test field_ptr(Int, parent_nested_ptr, :b) == convert(Ptr{Int}, b_field_ptr)
                    end

                    @testset "NestedCStruct interface" begin
                        @test parent_nested_ptr.a == -1
                        @test parent_nested_ptr.b == 0.0
                        @test parent_nested_ptr.c isa NestedCStruct{Int}
                        @test getfield(parent_nested_ptr.c, :data)[] == g
                        @test parent_nested_ptr.c[1] == 1
                        @test parent_nested_ptr.c[2] == 2
                        @test parent_nested_ptr.c[3] == 3
                        @test parent_nested_ptr.c[4] == 4
                        child_nested_ptr = parent_nested_ptr.d
                        @test child_nested_ptr isa NestedCStruct{TestChildStruct}
                        @test getfield(child_nested_ptr, :data)[] == child_ptr
                        @test child_nested_ptr.e == (1, 2, 3, 4)
                        @test child_nested_ptr.f == Cint(-1)
                        @test getfield(child_nested_ptr.g, :data)[] == g
                    end

                    @testset "NestedCStruct convenience functions" begin
                        @test propertynames(parent_nested_ptr) == (:a, :b, :c, :d, :data)
                    end
                end
            end
        finally
            free(g)
        end
    end
end
