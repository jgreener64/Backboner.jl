var documenterSearchIndex = {"docs":
[{"location":"","page":"Overview","title":"Overview","text":"CurrentModule = Backboner\nDocTestSetup = quote\n    using Backboner\nend","category":"page"},{"location":"#Backboner","page":"Overview","title":"Backboner","text":"","category":"section"},{"location":"","page":"Overview","title":"Overview","text":"(Image: Latest Release) (Image: MIT license) (Image: Documentation) (Image: Documentation) (Image: Build Status) (Image: Coverage)","category":"page"},{"location":"","page":"Overview","title":"Overview","text":"Backboner is a Julia package that offers a suite of tools for storing protein backbone atom positions, estimating oxygen atom positions, assigning secondary structure, and more. View the source code on GitHub (licensed under MIT).","category":"page"},{"location":"#Installation","page":"Overview","title":"Installation","text":"","category":"section"},{"location":"","page":"Overview","title":"Overview","text":"Backboner is a registered Julia package, and can be installed with the Julia package manager:","category":"page"},{"location":"","page":"Overview","title":"Overview","text":"using Pkg\nPkg.add(\"Backboner\")","category":"page"},{"location":"#Usage","page":"Overview","title":"Usage","text":"","category":"section"},{"location":"","page":"Overview","title":"Overview","text":"The Protein type wraps a vector of Chains.","category":"page"},{"location":"","page":"Overview","title":"Overview","text":"julia> using Backboner\n\njulia> protein = readpdb(\"test/data/1ZAK.pdb\")\n2-element Vector{Chain}:\n Chain A with 220 residues\n Chain B with 220 residues\n\njulia> chain = protein[\"A\"] # chains can be accessed by name\nChain A with 220 residues\n\njulia> protein[\"A\"] == protein[1] # numeric indexing also works\ntrue\n\njulia> new_protein = [protein[\"A\"]] # create a new protein with a single chain\n1-element Vector{Chain}:\n Chain A with 220 residues\n\njulia> writepdb(new_protein, \"test/data/1ZAK_A.pdb\");","category":"page"},{"location":"#API-Reference","page":"Overview","title":"API Reference","text":"","category":"section"},{"location":"","page":"Overview","title":"Overview","text":"Modules = [Backboner, Protein]","category":"page"},{"location":"#Backboner.Backbone","page":"Overview","title":"Backboner.Backbone","text":"Backbone{T <: Real} <: AbstractVector{AbstractVector{T}}\n\nThe Backbone type is designed to efficiently store and manipulate the three-dimensional coordinates of backbone atoms.\n\nExamples\n\nA Backbone can be created from a matrix of coordinates:\n\njulia> backbone = Backbone(zeros(3, 5)) # 5 atoms with 3 coordinates each\n5-element Backbone{Float64}:\n [0.0, 0.0, 0.0]\n [0.0, 0.0, 0.0]\n [0.0, 0.0, 0.0]\n [0.0, 0.0, 0.0]\n [0.0, 0.0, 0.0]\n\njulia> backbone[1] = [1.0, 2.0, 3.0]; # set the first atom's coordinates\n\njulia> backbone\n5-element Backbone{Float64}:\n [1.0, 2.0, 3.0]\n [0.0, 0.0, 0.0]\n [0.0, 0.0, 0.0]\n [0.0, 0.0, 0.0]\n [0.0, 0.0, 0.0]\n\njulia> backbone[1:2] # indexing by range returns a `Backbone` wrapped around a view of the original\n2-element Backbone{Float64}:\n [1.0, 2.0, 3.0]\n [0.0, 0.0, 0.0]\n\nArrays will always be flattened to be a 3xN matrix:\n\n```jldoctest julia> backbone = Backbone(zeros(3, 3, 100)) # 3 coordinates per atom, 3 atoms per residue, 100 residues 300-element Backbone{Float64}:  [0.0, 0.0, 0.0]  [0.0, 0.0, 0.0]  [0.0, 0.0, 0.0]  [0.0, 0.0, 0.0]  ⋮  [0.0, 0.0, 0.0]  [0.0, 0.0, 0.0]  [0.0, 0.0, 0.0]  [0.0, 0.0, 0.0]\n\n\n\n\n\n","category":"type"},{"location":"#Backboner.ChainedBonds","page":"Overview","title":"Backboner.ChainedBonds","text":"ChainedBonds{T <: Real}\n\nA lazy way to store a backbone as a series of bond lengths, angles, and dihedrals. It can be instantiated from a Backbone or a matrix of bond vectors. It can also be used to instantiate a Backbone using the Backbone(bonds::ChainedBonds) constructor.\n\nExamples\n\njulia> backbone = readpdb(\"test/data/1ZAK.pdb\")[\"A\"].backbone\n660-element Backbone{Float32}:\n [22.346, 17.547, 23.294]\n [22.901, 18.031, 21.993]\n [23.227, 16.793, 21.163]\n [24.115, 16.923, 20.175]\n ⋮\n [22.041, 14.866, 3.569]\n [21.808, 13.861, 2.734]\n [22.263, 13.862, 1.355]\n [21.085, 14.233, 0.446]\n\njulia> bonds = ChainedBonds(backbone)\nChainedBonds{Float32} with 659 bonds, 658 angles, and 657 dihedrals\n\n\n\n\n\n","category":"type"},{"location":"#Backboner.Protein.Chain","page":"Overview","title":"Backboner.Protein.Chain","text":"Chain <: AbstractVector{Residue}\n\nA Chain represents a chain of a protein, and is a vector of Residues, which are instantiated from indexing the chain.\n\nFields\n\nid::AbstractString: A string identifier (usually a single letter).\nbackbone::Backbone: A backbone with a length divisible by 3, to ensure 3 atoms per residue (N, Ca, C).\naavector::Vector{Char}: storing the amino acid sequence.\nssvector::Vector{Char}: storing the secondary structure.\n\n\n\n\n\n","category":"type"},{"location":"#AssigningSecondaryStructure.assign_secondary_structure!-Tuple{AbstractVector{Backboner.Protein.Chain}}","page":"Overview","title":"AssigningSecondaryStructure.assign_secondary_structure!","text":"assign_secondary_structure!(protein)\n\nUses a simplified version of DSSP to fill the secondary structure vector of each chain with '-' (coil/loop), 'H' (helix), and 'E' (strand).\n\n\n\n\n\n","category":"method"},{"location":"#AssigningSecondaryStructure.assign_secondary_structure-Tuple{AbstractVector{Backboner.Protein.Chain}}","page":"Overview","title":"AssigningSecondaryStructure.assign_secondary_structure","text":"assign_secondary_structure(protein)\n\nReturns a new protein with secondary structure assigned.\n\n\n\n\n\n","category":"method"},{"location":"#Backboner.Protein.alphacarbon_carbonyl_distances-Tuple{Backboner.Protein.Chain}","page":"Overview","title":"Backboner.Protein.alphacarbon_carbonyl_distances","text":"alphacarbon_carbonyl_distances(chain::Chain)\n\nCalculate the distances between all pairs of contiguous alpha-carbon and carbonyl atoms in a chain. Returns a vector of distances of length length(chain).\n\n\n\n\n\n","category":"method"},{"location":"#Backboner.Protein.backbone_to_locs_and_rots-Union{Tuple{Backbone{T}}, Tuple{T}, Tuple{Backbone{T}, Symbol}} where T","page":"Overview","title":"Backboner.Protein.backbone_to_locs_and_rots","text":"backbone_to_locs_and_rots(backbone, unit=:angstrom)\n\nReturns the locations and rotation matrices of residues in a backbone, according to a defined standard triangle (Backboner.STANDARD_TRIANGLE_ANGSTROM).\n\n\n\n\n\n","category":"method"},{"location":"#Backboner.Protein.carbonyl_nitrogen_distances-Tuple{Backboner.Protein.Chain}","page":"Overview","title":"Backboner.Protein.carbonyl_nitrogen_distances","text":"carbonyl_nitrogen_distances(chain::Chain)\n\nCalculate the distances between all pairs of contiguous carbonyl and nitrogen atoms in a chain. Returns a vector of distances of length length(chain) - 1.\n\n\n\n\n\n","category":"method"},{"location":"#Backboner.Protein.locs_and_rots_to_backbone-Union{Tuple{T}, Tuple{AbstractMatrix{T}, AbstractArray{T, 3}}} where T","page":"Overview","title":"Backboner.Protein.locs_and_rots_to_backbone","text":"locs_and_rots_to_backbone(locations, rot_matrices; unit=:angstrom)\n\nReturns a backbone with the given locations and rotation matrices of residues. If unit is :nm, the locations are converted to angstroms by multiplying them by 10.\n\n\n\n\n\n","category":"method"},{"location":"#Backboner.Protein.nitrogen_alphacarbon_distances-Tuple{Backboner.Protein.Chain}","page":"Overview","title":"Backboner.Protein.nitrogen_alphacarbon_distances","text":"nitrogen_alphacarbon_distances(chain::Chain)\n\nCalculate the distances between all pairs of contiguous nitrogen and alpha-carbon atoms in a chain. Returns a vector of distances of length length(chain).\n\n\n\n\n\n","category":"method"},{"location":"#Backboner.Protein.oxygen_coords-Tuple{Backboner.Protein.Chain}","page":"Overview","title":"Backboner.Protein.oxygen_coords","text":"oxygen_coords(chain::Chain)\n\nAdd oxygen atoms to the backbone of a protein, turning the coordinate array from size 3x3xL to 3x4xL-1, where L is the length of the backbone.\n\nExample\n\njulia> protein = readpdb(\"test/data/1ZAK.pdb\")\n2-element Vector{Chain}:\n Chain A with 220 residues\n Chain B with 220 residues\n\njulia> oxygen_coords(protein[\"A\"]) # returns the estimated position of oxygen atoms in chain A (~0.05 Å mean deviation)\n3×220 Matrix{Float32}:\n 22.6697  25.1719  24.7761  25.8559  …  24.7911   22.7649   22.6578   21.24\n 15.7257  13.505   13.5151  11.478      15.0888   12.2361   15.8825   14.2933\n 21.4295  19.5663  22.8638  25.3283      7.95346   4.81901   3.24164  -0.742424        \n\nnote: Note\nThe oxygen_coords function finds the oxygen atoms to the backbone using idealized geometry, and oxygens atom will on average deviate 0.05 Å from original PDB positions. Moreover, the last oxygen atom is essentially given a random (although deterministic) orientation, as that information is lost when the backbone is reduced to 3 atoms, and there's no next nitrogen atom to compare with.\n\n\n\n\n\n","category":"method"},{"location":"#Backboner.Protein.readpdb-Tuple{String}","page":"Overview","title":"Backboner.Protein.readpdb","text":"readpdb(filename::String)\n\nLoads a protein (represented as a Vector{Protein.Chain}) from a PDB file. Assumes that each residue starts with four atoms: N, CA, C.\n\n\n\n\n\n","category":"method"},{"location":"#Backboner.Protein.writepdb","page":"Overview","title":"Backboner.Protein.writepdb","text":"writepdb(protein::Vector{Protein.Chain}, filename)\n\nWrite a protein (represented as a Vector{Protein.Chain}s) to a PDB file.\n\n\n\n\n\n","category":"function"}]
}
