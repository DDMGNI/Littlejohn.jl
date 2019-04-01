
import DecFP

using GeometricIntegrators.Equations


export guiding_center_4d_ode, guiding_center_4d_iode, guiding_center_4d_iode_λ,
       guiding_center_4d_iode_dec128, guiding_center_4d_vode,
       guiding_center_4d_dg, guiding_center_4d_formal_lagrangian



function guiding_center_4d_periodicity(q)
    p = zero(q)
    p .= periodicity(q, equ)

    try
        p .= periodicity(q, equ)
    catch
        @warn "No equilibrium found to determine periodicity."
    end

    return p
end


function guiding_center_4d_ode(qᵢ=qᵢ; periodic=true)
    if periodic
        ODE(guiding_center_4d_v, qᵢ; periodicity=guiding_center_4d_periodicity(qᵢ))
    else
        ODE(guiding_center_4d_v, qᵢ)
    end
end


function guiding_center_4d_iode(qᵢ=qᵢ; periodic=true)
    pᵢ = guiding_center_4d_pᵢ(qᵢ)
    if periodic
        IODE(guiding_center_4d_ϑ, guiding_center_4d_f,
             guiding_center_4d_g, guiding_center_4d_v,
             qᵢ, pᵢ; periodicity=guiding_center_4d_periodicity(qᵢ))
    else
        IODE(guiding_center_4d_ϑ, guiding_center_4d_f,
             guiding_center_4d_g, guiding_center_4d_v,
             qᵢ, pᵢ)
    end
end

function guiding_center_4d_iode_dec128(qᵢ=qᵢ; periodic=true)
    guiding_center_4d_iode(Dec128.(qᵢ); periodic=periodic)
end

function guiding_center_4d_iode_λ(qᵢ=qᵢ; periodic=true)
    pᵢ = guiding_center_4d_pᵢ(qᵢ)
    λ₀ = guiding_center_4d_λ₀(qᵢ)
    if periodic
        IODE(guiding_center_4d_ϑ, guiding_center_4d_f,
             guiding_center_4d_g, guiding_center_4d_v,
             qᵢ, pᵢ, λ₀; periodicity=guiding_center_4d_periodicity(qᵢ))
    else
        IODE(guiding_center_4d_ϑ, guiding_center_4d_f,
             guiding_center_4d_g, guiding_center_4d_v,
             qᵢ, pᵢ, λ₀)
    end
end

function guiding_center_4d_vode(qᵢ=qᵢ; periodic=true)
    pᵢ = guiding_center_4d_pᵢ(qᵢ)
    if periodic
        VODE(guiding_center_4d_ϑ, guiding_center_4d_f,
             guiding_center_4d_g, guiding_center_4d_v,
             ω, dH, qᵢ, pᵢ; periodicity=guiding_center_4d_periodicity(qᵢ))
    else
        VODE(guiding_center_4d_ϑ, guiding_center_4d_f,
             guiding_center_4d_g, guiding_center_4d_v,
             ω, dH, qᵢ, pᵢ)
    end
end

function guiding_center_4d_dg(qᵢ=qᵢ; κ=0.0, periodic=true)
    if periodic
        periodicity = []
    else
        periodicity=guiding_center_4d_periodicity(qᵢ)
    end

    guiding_center_4d_ϑ_κ(t, q, v, p) = guiding_center_4d_ϑ(κ, t, q, v, p)
    guiding_center_4d_f_κ(t, q, v, f) = guiding_center_4d_f(κ, t, q, v, f)
    guiding_center_4d_g_κ(t, q, λ, g) = guiding_center_4d_g(κ, t, q, λ, g)

    IODE(guiding_center_4d_ϑ_κ, guiding_center_4d_f_κ,
         guiding_center_4d_g_κ, guiding_center_4d_v,
         qᵢ, qᵢ; periodicity=periodicity)
end

function guiding_center_4d_formal_lagrangian(qᵢ=qᵢ; periodic=true)
    pᵢ = guiding_center_4d_pᵢ(qᵢ)
    if periodic
        VODE(guiding_center_4d_ϑ, guiding_center_4d_f, guiding_center_4d_g, guiding_center_4d_v,
             ω, dH, qᵢ, pᵢ; periodicity=guiding_center_4d_periodicity(qᵢ))
    else
        VODE(guiding_center_4d_ϑ, guiding_center_4d_f, guiding_center_4d_g, guiding_center_4d_v,
             ω, dH, qᵢ, pᵢ)
    end
end