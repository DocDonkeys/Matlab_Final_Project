function [axis, angle] = RotMatToEuler(R)

angle = acosd((trace(R) - 1) / 2);
crossAxis = (R - R') / (2 * sind(angle));
axis = [crossAxis(3,2); crossAxis(1,3); crossAxis(2,1)];

if rad2deg(angle) == 180
    aux = (R - eye(3)*(-1))/2;
    axis = [aux(1,1); aux(2,2); aux(3,3)];
end

if isnan(axis)
    if angle == 0
       axis = [1; 1; 1] / sqrt(3);  
    end
end

end