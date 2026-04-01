SetFactory("OpenCASCADE");

lc = 0.1;
Rectangle(1) = {0, 0, 0, 1.0, 0.4, 0};

Physical Surface("fluid", 1) = {1};
Physical Curve("inlet", 2) = {4};
Physical Curve("outlet", 3) = {2};
Physical Curve("walls", 4) = {1, 3};

Mesh.CharacteristicLengthMin = lc;
Mesh.CharacteristicLengthMax = lc;
