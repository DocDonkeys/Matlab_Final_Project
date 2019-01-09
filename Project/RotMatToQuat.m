function q = RotMatToQuat(R)

    [axis, angle] = RotMatToEuler(R);
    
    if (norm(axis) ~= 1)
        axis = axis/norm(axis);
    end
    
    qSin = sind(angle/2);
    qVec = axis * qSin;
    q = [cosd(angle/2); qVec];
end