function R = axisangle2matrix(vec, angle)

vec_module = sqrt(vec' * vec);
vec_normalized = vec / vec_module;

c = cosd(angle);
s = sind(angle);

ux = [0 -vec_normalized(3) vec_normalized(2);
             vec_normalized(3) 0 -vec_normalized(1);
             -vec_normalized(2) vec_normalized(1) 0];

R = eye(3) * c + (vec_normalized * vec_normalized') * (1 - c) + s * ux;

end
