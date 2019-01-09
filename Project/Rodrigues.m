function R = Rodrigues(axis, angle)

[r, c] = size(axis);
if (r ~= 3 || c ~= 1)
    error('Axis must be a single column matrix with 3 elements.');
else
    axis = axis / norm(axis);
    
    R = eye(3) * cosd(angle) + (1 - cosd(angle))*(axis*axis') + GetCrossMat(axis)*sind(angle);
end

end