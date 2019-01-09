function varargout = trackBall(varargin)
% TRACKBALL MATLAB code for trackBall.fig
%      TRACKBALL, by itself, creates a new TRACKBALL or raises the existing
%      singleton*.
%
%      H = TRACKBALL returns the handle to a new TRACKBALL or the handle to
%      the existing singleton*.
%
%      TRACKBALL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACKBALL.M with the given input arguments.
%
%      TRACKBALL('Property','Value',...) creates a new TRACKBALL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before trackBall_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to trackBall_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help trackBall

% Last Modified by GUIDE v2.5 09-Jan-2019 20:03:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @trackBall_OpeningFcn, ...
                   'gui_OutputFcn',  @trackBall_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before trackBall is made visible.
function trackBall_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to trackBall (see VARARGIN)

set(hObject,'WindowButtonDownFcn',{@my_MouseClickFcn,handles.axes1});
set(hObject,'WindowButtonUpFcn',{@my_MouseReleaseFcn,handles.axes1});
axes(handles.axes1);

handles.Cube=DrawCube(eye(3));

set(handles.axes1,'CameraPosition',...
    [0 0 5],'CameraTarget',...
    [0 0 -5],'CameraUpVector',...
    [0 1 0],'DataAspectRatio',...
    [1 1 1]);

set(handles.axes1,'xlim',[-3 3],'ylim',[-3 3],'visible','off','color','none');

% Choose default command line output for trackBall
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes trackBall wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = trackBall_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function my_MouseClickFcn(obj,event,hObject)

handles=guidata(obj);
xlim = get(handles.axes1,'xlim');
ylim = get(handles.axes1,'ylim');
mousepos=get(handles.axes1,'CurrentPoint');
xmouse = mousepos(1,1);
ymouse = mousepos(1,2);

if xmouse > xlim(1) && xmouse < xlim(2) && ymouse > ylim(1) && ymouse < ylim(2)

    set(handles.figure1,'WindowButtonMotionFcn',{@my_MouseMoveFcn,hObject});
    
    % Get mouse input x-y. We need to share the two variables with other
    % functions.
    xclick = xmouse;
    Set_global_xclick(xclick);
    yclick = ymouse;
    Set_global_yclick(yclick);
end
guidata(hObject,handles)

function my_MouseReleaseFcn(obj,event,hObject)
handles = guidata(hObject);
set(handles.figure1,'WindowButtonMotionFcn','');
guidata(hObject,handles);

function my_MouseMoveFcn(obj,event,hObject)

handles = guidata(obj);
xlim = get(handles.axes1,'xlim');
ylim = get(handles.axes1,'ylim');
mousepos = get(handles.axes1,'CurrentPoint');
xmouse = mousepos(1,1);
ymouse = mousepos(1,2);

if xmouse > xlim(1) && xmouse < xlim(2) && ymouse > ylim(1) && ymouse < ylim(2)

    xclick = Get_global_xclick;
    yclick = Get_global_yclick;

    if ((xclick^2 + yclick^2) < 1 / 2)
        zclick = sqrt(1 - xclick^2 - yclick^2); 
        vec1 = [xclick; yclick; zclick];
    else
        if (xclick^2 + yclick^2 >= 1 / 2)
        vec1= [xclick; yclick; 4 / (2 * sqrt(xclick^2 + yclick^2))]; 
        vec1= (vec1) / norm(vec1);
        end
    end
    
    if (xmouse^2 + ymouse^2 < 1 / 2)
        zmouse= sqrt(1 - xmouse^2 - ymouse^2); 
        vec2 = [xmouse; ymouse; zmouse];
    else
        if (xmouse^2 + ymouse^2 >= 1 / 2)
        vec2 = [xmouse; ymouse; 1/(2 * sqrt(xmouse^2 + ymouse^2))]; 
        vec2 = (vec2) / norm(vec2); 
        end
    end
    
    axis = cross(vec2, vec1); 
    angle = -acosd(dot(vec2, vec1)); 
    R = Rodrigues(axis, angle);
    handles.Cube = RedrawCube(R, handles);
    
end
guidata(hObject,handles);

function h = DrawCube(R)

M0 = [ -1 -1 1;   %Node 1
       -1 1 1;    %Node 2
        1 1 1;    %Node 3
        1 -1 1;   %Node 4
       -1 -1 -1;  %Node 5
       -1 1 -1;   %Node 6
        1 1 -1;   %Node 7
        1 -1 -1]; %Node 8

M = (R*M0')';

x = M(:,1);
y = M(:,2);
z = M(:,3);

con = [1 2 3 4;
    5 6 7 8;
    4 3 7 8;
    1 2 6 5;
    1 4 8 5;
    2 3 7 6]';

x = reshape(x(con(:)),[4,6]);
y = reshape(y(con(:)),[4,6]);
z = reshape(z(con(:)),[4,6]);

c = 1/255*[255 248 88;
    0 0 0;
    57 183 225;
    57 183 0;
    255 178 0;
    255 0 0];

h = fill3(x,y,z, 1:6);

for q = 1:length(c)
    h(q).FaceColor = c(q,:);
end

function cube = RedrawCube(R, hin)

cube = hin.Cube;
c = 1/255 * [255 248 88;
             0 0 0;
             57 183 225;
             57 183 0;
             255 178 0;
             255 0 0];

M0 = [ -1 -1 1;   
       -1 1 1;    
        1 1 1;    
        1 -1 1;   
       -1 -1 -1;  
       -1 1 -1;   
        1 1 -1;   
        1 -1 -1]; 

M = (R*M0')';

x = M(:,1);
y = M(:,2);
z = M(:,3);

con = [1 2 3 4;
       5 6 7 8;
       4 3 7 8;
       1 2 6 5;
       1 4 8 5;
       2 3 7 6]';

x = reshape(x(con(:)),[4,6]);
y = reshape(y(con(:)),[4,6]);
z = reshape(z(con(:)),[4,6]);

for q = 1:6
    cube(q).Vertices = [x(:,q) y(:,q) z(:,q)];
    cube(q).FaceColor = c(q,:);
end

SetRotMat(hin, R);
SetPrincipalEuler(hin, R);
SetEulerAngles(hin, R);
SetRotVec(hin, R);
SetQuat(hin, R);

function Quat_Button(hObject, eventdata, handles)

q0 = str2double(get(handles.q_0_edit, 'String'));
q1 = str2double(get(handles.q_1_edit, 'String'));
q2 = str2double(get(handles.q_2_edit, 'String'));
q3 = str2double(get(handles.q_3_edit, 'String'));
q = [q0; q1; q2; q3];
R = QuatToRotMat(q);
handles.Cube = RedrawCube(R, handles);

function Reset_Button(hObject, eventdata, handles)

R = eye(3);
handles.Cube = RedrawCube(R, handles);
SetRotMat(handles, R);

function Principal_Euler_Button(hObject, eventdata, handles)

u_x = str2double(get(handles.u_x_edit, 'String'));
u_y = str2double(get(handles.u_y_edit, 'String'));
u_z = str2double(get(handles.u_z_edit, 'String'));
axis = [u_x; u_y; u_z];
angle = str2double(get(handles.u_angle_edit, 'String'));
R = Rodrigues(axis, angle);
handles.Cube = RedrawCube(R, handles);

function Euler_Angles_Button(hObject, eventdata, handles)

yaw = str2double(get(handles.phi_edit, 'String'));
pitch = str2double(get(handles.theta_edit, 'String'));
roll = str2double(get(handles.psi_edit, 'String'));
R = EulerAnglesToRotMat(roll, pitch, yaw);
handles.Cube = RedrawCube(R, handles);

function RotVec_Button(hObject, eventdata, handles)

rotVec_x = str2double(get(handles.x_rot_edit, 'String'));
rotVec_y = str2double(get(handles.y_rot_edit, 'String'));
rotVec_z = str2double(get(handles.z_rot_edit, 'String'));
rotVec = [rotVec_x; rotVec_y; rotVec_z];
R = RotVecToRotMat(rotVec);
handles.Cube = RedrawCube(R, handles);

function phi_edit(hObject, eventdata, handles)
set(hObject,'BackgroundColor','white');

function theta_edit(hObject, eventdata, handles)
set(hObject,'BackgroundColor','white');

function psi_edit(hObject, eventdata, handles)
set(hObject,'BackgroundColor','white');

function u_angle_edit(hObject, eventdata, handles)
set(hObject,'BackgroundColor','white');

function u_x_edit(hObject, eventdata, handles)
set(hObject,'BackgroundColor','white');

function u_y_edit(hObject, eventdata, handles)
set(hObject,'BackgroundColor','white');

function u_z_edit(hObject, eventdata, handles)
set(hObject,'BackgroundColor','white');

function x_rot_edit(hObject, eventdata, handles)
set(hObject,'BackgroundColor','white');

function y_rot_edit(hObject, eventdata, handles)
set(hObject,'BackgroundColor','white');

function z_rot_edit(hObject, eventdata, handles)
set(hObject,'BackgroundColor','white');

function q_0_edit(hObject, eventdata, handles)
set(hObject,'BackgroundColor','white');

function q_1_edit(hObject, eventdata, handles)
set(hObject,'BackgroundColor','white');

function q_2_edit(hObject, eventdata, handles)
set(hObject,'BackgroundColor','white');

function q_3_edit(hObject, eventdata, handles)
set(hObject,'BackgroundColor','white');

function SetRotMat(update, R)
    set(update.rm_11, 'String', R(1, 1));
    set(update.rm_12, 'String', R(1, 2));
    set(update.rm_13, 'String', R(1, 3));
    set(update.rm_21, 'String', R(2, 1));
    set(update.rm_22, 'String', R(2, 2));
    set(update.rm_23, 'String', R(2, 3));
    set(update.rm_31, 'String', R(3, 1));
    set(update.rm_32, 'String', R(3, 2));
    set(update.rm_33, 'String', R(3, 3));

function SetPrincipalEuler(update, R)
    [axis, angle] = RotMatToEuler(R);
    set(update.u_angle_edit, 'String', angle);
    set(update.u_x_edit, 'String', axis(1));
    set(update.u_y_edit, 'String', axis(2));
    set(update.u_z_edit, 'String', axis(3));
    
function SetEulerAngles(update, R)
    [roll, pitch, yaw] = GetRotAngles(R);
    set(update.phi_edit, 'String', yaw);
    set(update.theta_edit, 'String', pitch);
    set(update.psi_edit, 'String', roll);
    
function SetRotVec(update, R)
    rotVec = RotMatToRotVec(R);
    set(update.x_rot_edit, 'String', rotVec(1));
    set(update.y_rot_edit, 'String', rotVec(2));
    set(update.z_rot_edit, 'String', rotVec(3));

function SetQuat(update, R)
    q = RotMatToQuat(R);
    set(update.q_0_edit, 'String', q(1));
    set(update.q_1_edit, 'String', q(2));
    set(update.q_2_edit, 'String', q(3));
    set(update.q_3_edit, 'String', q(4));
 
function Set_global_xclick(variable)
    global xclick;
    xclick = variable;
    
function x = Get_global_xclick
    global xclick;
    x = xclick;

function Set_global_yclick(variable)
    global yclick;
    yclick = variable;
    
function y = Get_global_yclick
    global yclick;
    y = yclick;


% --- Executes on button press in Quat_Button.
function Quat_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Quat_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
