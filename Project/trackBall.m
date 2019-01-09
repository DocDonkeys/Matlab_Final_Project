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

% Last Modified by GUIDE v2.5 24-Nov-2016 11:52:15

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
    Set_xclick(xclick);
    yclick = ymouse;
    Set_yclick(yclick);
end
guidata(hObject,handles)

function my_MouseReleaseFcn(obj,event,hObject)
handles=guidata(hObject);
set(handles.figure1,'WindowButtonMotionFcn','');
guidata(hObject,handles);

function my_MouseMoveFcn(obj,event,hObject)

handles=guidata(obj);
xlim = get(handles.axes1,'xlim');
ylim = get(handles.axes1,'ylim');
mousepos = get(handles.axes1,'CurrentPoint');
xmouse = mousepos(1,1);
ymouse = mousepos(1,2);

vec1 = zeros(3, 1);
vec2 = zeros(3, 1);

if xmouse > xlim(1) && xmouse < xlim(2) && ymouse > ylim(1) && ymouse < ylim(2)

    click_x = Get_xclick;
    click_y = Get_yclick;

    if((click_x^2 + click_y^2) < 1 / 2)
        m_z = sqrt(1 - click_x^2 - click_y^2); 
        vec1 = [click_x; click_y; m_z];
    end
    
    if(click_x^2 + click_y^2 >= 1 / 2)
        vec1= [click_x; click_y; 4 / (2 * sqrt(click_x^2 + click_y^2))]; 
        vec1= (vec1) / norm(vec1);
    end
    
    if(xmouse^2 + ymouse^2 < 1 / 2)
        zmouse= sqrt(1 - xmouse^2 - ymouse^2); 
        vec2 = [xmouse; ymouse; zmouse];
    end
    
    if(xmouse^2 + ymouse^2 >= 1 / 2)
        vec2= [xmouse; ymouse; 1/(2 * sqrt(xmouse^2 + ymouse^2))]; 
        vec2= (vec2) / norm(vec2); 
    end
    
    axis = cross(vec2, vec1); 
    angle = -acosd(dot(vec2, vec1)); 
    R = axisangle2matrix(axis, angle);
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

SetGuideRot(hin, R);
SetEulerRot(hin, R);
SetAnglesRot(hin, R);
SetVecRot(hin, R);
SetQuatRot(hin, R);


function Push_Button_Quaternion(hObject, eventdata, handles)

q0 = str2double(get(handles.q_0_edit, 'String'));
q1 = str2double(get(handles.q_1_edit, 'String'));
q2 = str2double(get(handles.q_2_edit, 'String'));
q3 = str2double(get(handles.q_3_edit, 'String'));
q = [q0; q1; q2; q3];
R = quaternion_R(q);
handles.Cube = RedrawCube(R, handles);


function Reset_Button(hObject, eventdata, handles)

R = eye(3);
handles.Cube = RedrawCube(R, handles);
SetGuideRot(handles, R);


function Push_Button_Euler(hObject, eventdata, handles)

u_x = str2double(get(handles.u_x_edit, 'String'));
u_y = str2double(get(handles.u_y_edit, 'String'));
u_z = str2double(get(handles.u_z_edit, 'String'));
u_axis = [u_x; u_y; u_z];
u_angle = str2double(get(handles.u_angle_edit, 'String'));
R = axisangle2matrix(u_axis, u_angle);
handles.Cube = RedrawCube(R, handles);


function Push_Button_Euler_Angles(hObject, eventdata, handles)

e_phi = str2double(get(handles.phi_edit, 'String'));
e_theta = str2double(get(handles.theta_edit, 'String'));
e_psi = str2double(get(handles.psi_edit, 'String'));
R = Angles_R(e_phi, e_theta, e_psi);
handles.Cube = RedrawCube(R, handles);


function Push_Button_Rotation_Vector(hObject, eventdata, handles)

x_rot_v = str2double(get(handles.x_rot_edit, 'String'));
y_rot_v = str2double(get(handles.y_rot_edit, 'String'));
z_rot_v = str2double(get(handles.z_rot_edit, 'String'));
rot_vector = [x_rot_v; y_rot_v; z_rot_v];
R = rotvecR(rot_vector);
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


function SetGuideRot(update, r)
    set(update.rm_11, 'String', r(1, 1));
    set(update.rm_12, 'String', r(1, 2));
    set(update.rm_13, 'String', r(1, 3));
    set(update.rm_21, 'String', r(2, 1));
    set(update.rm_22, 'String', r(2, 2));
    set(update.rm_23, 'String', r(2, 3));
    set(update.rm_31, 'String', r(3, 1));
    set(update.rm_32, 'String', r(3, 2));
    set(update.rm_33, 'String', r(3, 3));

function SetEulerRot(update, r)
    [e_axis, e_angle] = Raxisangle(r);
    set(update.u_angle_edit, 'String', e_angle);
    set(update.u_x_edit, 'String', e_axis(1));
    set(update.u_y_edit, 'String', e_axis(2));
    set(update.u_z_edit, 'String', e_axis(3));
    
function SetAnglesRot(update, r)
    [a1, a2, a3] = EulerRotationAngles(r);
    set(update.phi_edit, 'String', a1);
    set(update.theta_edit, 'String', a2);
    set(update.psi_edit, 'String', a3);
    
function SetVecRot(update, r)
    vec = Rvecrot(r);
    set(update.x_rot_edit, 'String', vec(1));
    set(update.y_rot_edit, 'String', vec(2));
    set(update.z_rot_edit, 'String', vec(3));

function SetQuatRot(update, r)
    quat = RotationQuat(r);
    set(update.q_0_edit, 'String', quat(1));
    set(update.q_1_edit, 'String', quat(2));
    set(update.q_2_edit, 'String', quat(3));
    set(update.q_3_edit, 'String', quat(4));

    
function Set_xclick(variable)
    global xclick;
    xclick = variable;
    
function x = Get_xclick
    global xclick;
    x = xclick;

function Set_yclick(variable)
    global yclick;
    yclick = variable;
    
function y = Get_yclick
    global yclick;
    y = yclick;
