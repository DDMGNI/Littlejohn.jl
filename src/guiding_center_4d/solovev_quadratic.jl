"""
Analytic, quadratic Solov'ev equilibrium.
"""
module GuidingCenter4dSolovevQuadratic

    using ElectromagneticFields: load_equilibrium, periodicity, SolovevQuadratic

    export initial_conditions_barely_passing, initial_conditions_barely_trapped,
           initial_conditions_deeply_passing, initial_conditions_deeply_trapped

    export toroidal_momentum

    const μ  = 1E-2

    equ = SolovevQuadratic(2., 5., 1., 1.)
    load_equilibrium(equ; target_module=GuidingCenter4dSolovevQuadratic)

    initial_conditions_barely_passing() = [2.5, 0., 0., 3.425E-1] # Δt=2.5, nt=50
    initial_conditions_barely_trapped() = [2.5, 0., 0., 3.375E-1] # Δt=3.0, nt=100
    initial_conditions_deeply_passing() = [2.5, 0., 0., 5E-1]     # Δt=2.5, nt=25
    initial_conditions_deeply_trapped() = [2.5, 0., 0., 1E-1]     # Δt=5.0, nt=50

    include("guiding_center_4d_common.jl")
    include("guiding_center_4d_equations.jl")

    function toroidal_momentum(t,q)
        R(t,q) * ϑ3(t,q)
    end

end
