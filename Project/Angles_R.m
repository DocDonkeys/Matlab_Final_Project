function R = Angles_R (A, B, C)
%Given 3 angles in degrees the function devolves a rotation matrix
R = [cosd(B)*cosd(C) cosd(C)*sind(B)*sind(A)-cosd(A)*sind(C) cosd(C)*cosd(A)*sind(B)+sind(C)*sind(A);
                   cosd(B)*sind(C) sind(C)*sind(B)*sind(A)+cosd(A)*cosd(C) sind(C)*sind(B)*cosd(A)-cosd(C)*sind(A);   
                   -sind(B) cosd(B)*sind(A) cosd(B)*cosd(A)];
end