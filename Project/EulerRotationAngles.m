function [pitch, yaw, roll] = EulerRotationAngles(r)

yaw = asind(r(3, 1));
pitch = atan2d((r(3, 2) / cosd(yaw)), (r(3, 3) / cosd(yaw)));
roll = atan2d((r(2, 1) / cosd(yaw)), (r(1, 1) / cosd(yaw)));

end
