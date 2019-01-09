function vec = Rvecrot(r)

vec(2) = asind(r(3, 1));
vec(1) = atan2d((r(3, 2) / cosd(vec(2))), (r(3, 3) / cosd(vec(2))));
vec(3) = atan2d((r(2, 1) / cosd(vec(2))), (r(1, 1) / cosd(vec(2))));

end

