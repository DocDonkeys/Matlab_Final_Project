function [roll, pitch, yaw] = GetRotAngles(R)

[r, c] = size(R);
if (r ~= 3 || c ~= 3)
    error('Rotation matrix must be 3x3.');
else
    pitch = asind(-R(3,1));
    roll = atan2d(R(3,2)/cosd(pitch), R(3,3)/cosd(pitch));
    yaw = atan2d(R(2,1)/cosd(pitch), R(1,1)/cosd(pitch));
end

end