module TestTransform
    import ManifoldLearning: fit, transform, reconstruct, DataTransform,
                             ZScoreTransform, UnitRangeTransform
    using Base.Test

    X = rand(5, 8)

    t = fit(ZScoreTransform, X; center=false, scale=false)
    Y = transform(t, X)
    @test isa(t, DataTransform)
    @test isempty(t.mean)
    @test isempty(t.scale)
    @test isequal(X, Y)
    @test transform(t, X[:,1]) ≈ Y[:,1]
    @test reconstruct(t, Y[:,1]) ≈ X[:,1]
    @test reconstruct(t, Y) ≈ X

    t = fit(ZScoreTransform, X; center=false)
    Y = transform(t, X)
    @test isa(t, DataTransform)
    @test isempty(t.mean)
    @test length(t.scale) == 5
    @test Y ≈ X ./ std(X, 2)
    @test transform(t, X[:,1]) ≈ Y[:,1]
    @test reconstruct(t, Y[:,1]) ≈ X[:,1]
    @test reconstruct(t, Y) ≈ X

    t = fit(ZScoreTransform, X; scale=false)
    Y = transform(t, X)
    @test isa(t, DataTransform)
    @test length(t.mean) == 5
    @test isempty(t.scale)
    @test Y ≈ X .- mean(X, 2)
    @test transform(t, X[:,1]) ≈ Y[:,1]
    @test reconstruct(t, Y[:,1]) ≈ X[:,1]
    @test reconstruct(t, Y) ≈ X

    t = fit(ZScoreTransform, X)
    Y = transform(t, X)
    @test isa(t, DataTransform)
    @test length(t.mean) == 5
    @test length(t.scale) == 5
    @test Y ≈ (X .- mean(X, 2)) ./ std(X, 2)
    @test transform(t, X[:,1]) ≈ Y[:,1]
    @test reconstruct(t, Y[:,1]) ≈ X[:,1]
    @test reconstruct(t, Y) ≈ X

    t = fit(UnitRangeTransform, X)
    Y = transform(t, X)
    @test length(t.min) == 5
    @test length(t.scale) == 5
    @test Y ≈ (X .- minimum(X, 2)) ./ (maximum(X, 2) .- minimum(X, 2))
    @test transform(t, X[:,1]) ≈ Y[:,1]
    @test reconstruct(t, Y[:,1]) ≈ X[:,1]
    @test reconstruct(t, Y) ≈ X

    t = fit(UnitRangeTransform, X; unit=false)
    Y = transform(t, X)
    @test length(t.min) == 5
    @test length(t.scale) == 5
    @test Y ≈ X ./ (maximum(X, 2) .- minimum(X, 2))
    @test transform(t, X[:,1]) ≈ Y[:,1]
    @test reconstruct(t, Y[:,1]) ≈ X[:,1]
    @test reconstruct(t, Y) ≈ X
end
