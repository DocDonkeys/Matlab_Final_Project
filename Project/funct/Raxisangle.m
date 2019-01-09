function [axis, angle] = Raxisangle(r)

aux_trace = trace(r);

angle = acosd((aux_trace - 1) / 2);

skew = ((r - r') / (2 * sind(angle)));

axis = [skew(3, 2); skew(1, 3); skew(2, 1)];

if angle == 180
    aux = (r - eye(3)*(-1))/2;
    axis = [aux(1,1); aux(2,2); aux(3,3)];
end

if isnan(axis)
    if angle == 0
       axis = [1; 1; 1] / sqrt(3);  
    end
end

end

