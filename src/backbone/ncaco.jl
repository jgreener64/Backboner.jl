nitrogen_coord_matrix(bb::Backbone) = atom_coord_matrix(bb, 1)
alphacarbon_coord_matrix(bb::Backbone) = atom_coord_matrix(bb, 2)
carbon_coord_matrix(bb::Backbone) = atom_coord_matrix(bb, 3)
oxygen_coord_matrix(bb::Backbone) = atom_coord_matrix(bb, 4)