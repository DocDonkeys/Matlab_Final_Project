function R = RotVecToRotMat(rotVec)

[axis, angle] = RotVecToEuler(rotVec);
R = Rodrigues(axis, angle);

end

