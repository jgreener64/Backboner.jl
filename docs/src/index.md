```@meta
CurrentModule = Backboner
DocTestSetup = quote
    using Backboner
end
```

# Backboner

[![Latest Release](https://img.shields.io/github/release/MurrellGroup/Backboner.jl.svg)](https://github.com/MurrellGroup/Backboner.jl/releases/latest)
[![MIT license](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/license/MIT)
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://MurrellGroup.github.io/Backboner.jl/stable/)
[![Documentation](https://img.shields.io/badge/docs-latest-blue.svg)](https://MurrellGroup.github.io/Backboner.jl/dev/)
[![Build Status](https://github.com/MurrellGroup/Backboner.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/MurrellGroup/Backboner.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/MurrellGroup/Backboner.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/MurrellGroup/Backboner.jl)

Backboner is a Julia package that offers a set of types and functions for working with molecular *backbones*: defined here as a continuous chain of bonded atoms. The package provides a variety of different types for representing backbones:
- `Backbone`, containing a 3xN matrix of coordinates
- `ChainedBonds`, holding bond lengths, bond angles, and dihedral angles
- `Frames`, a collection of rotations and translations (e.g. for representing orientations and locations of protein residues)

[View the source code on GitHub](https://github.com/MurrellGroup/Backboner.jl) (licensed under MIT).

## Installation

Backboner is a registered in the General Julia package registry, and can be installed with the Julia package manager:

```julia
using Pkg
Pkg.add("Backboner")
```
