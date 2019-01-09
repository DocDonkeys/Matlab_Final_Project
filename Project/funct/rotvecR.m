function r = rotvecR(vec)

vn = norm(vec);
vec = vec / vn;

sk_matrix = [0 -vec(3) vec(2);
             vec(3) 0 -vec(1);
             -vec(2) vec(1) 0];

r = eye(3) * cosd(vn) + (1 - cosd(vn)) * (vec * vec') + sk_matrix * sind(vn);

end

