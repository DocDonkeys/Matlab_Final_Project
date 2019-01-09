function [axis, angle] = RotVecToEuler(rotVec)

axis = rotVec/norm(rotVec);
angle = norm(rotVec);

end