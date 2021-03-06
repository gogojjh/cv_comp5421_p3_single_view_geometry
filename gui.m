%% gui initialize
function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 11-Apr-2018 23:04:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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

% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


%%
function loadimage_Callback(hObject, eventdata, handles)
global img_ori;
global filename;
global line_xaxes;
global line_yaxes;
global line_zaxes;
global refer_points;
global gui_fig;
global image_fig;
global vp_fig;
global rp_fig;
global selected_point_fig;
global vp_x;
global vp_y;
global vp_z;
global alpha;
global x_image;
global X_world;
global H;

filename = 'box_sample';
img_ori = imread(['image/', filename, '.png']);
mat_name = ['param/', filename, '_line_xyz.mat'];
if exist(mat_name,'file') ~= 0
    load(mat_name);
end

gui_fig = 1;
image_fig = 2;
vp_fig = 3;
rp_fig = 4;
selected_point_fig = 5;


% draw existing points and lines
figure(image_fig);
imshow(img_ori); hold on;
drawallline(line_xaxes, line_yaxes, line_zaxes);

if ~isempty(refer_points)
    figure(rp_fig);
    imshow(img_ori); hold on;
    drawreferpoint(refer_points, 'w--', 3, 20);
    for i=2:length(alpha)
        text((refer_points(1,1)+refer_points(i,1))/2, ...
            (refer_points(1,2)+refer_points(i,2))/2, ...,
            [int2str(alpha(i)), 'px'], 'Color', 'w', 'FontSize', 20);
    end
end

figure(vp_fig);
imshow(img_ori); hold on;
drawline_vp(vp_x, line_xaxes, 'r--', 1);
drawline_vp(vp_y, line_yaxes, 'g--', 1);
drawline_vp(vp_z, line_zaxes, 'b--', 1);
text(vp_x(1), vp_x(2), 'vp_x'); hold on;
text(vp_y(1), vp_y(2), 'vp_y'); hold on;
text(vp_z(1), vp_z(2), 'vp_z'); hold on;
x = [vp_x(1), vp_y(1), vp_x(1), vp_z(1), vp_y(1), vp_z(1)];
y = [vp_x(2), vp_y(2), vp_x(2), vp_z(2), vp_y(2), vp_z(2)];
plot(x, y, 'c-'); hold on;
axis([min(x), max(x), min(y), max(y)]);

%%
function addlinex_Callback(hObject, eventdata, handles)
global image_fig;
global line_xaxes;
figure(image_fig);
pos = addnewline('r-', 3, 'x');
line_xaxes = [line_xaxes; pos];

function addliney_Callback(hObject, eventdata, handles)
global image_fig;
global line_yaxes;
figure(image_fig);
pos = addnewline('g-', 3, 'y');
line_yaxes = [line_yaxes; pos];

function addlinez_Callback(hObject, eventdata, handles)
global image_fig;
global line_zaxes;
figure(image_fig);
pos = addnewline('b-', 3, 'z');
line_zaxes = [line_zaxes; pos];

%%
function deletelinex_Callback(hObject, eventdata, handles)
global line_xaxes;
global line_yaxes; 
global line_zaxes;
if isempty(line_xaxes)
    return;
end
global img_ori;
figure(2);
hold off;
imshow(img_ori);
hold on;
line_xaxes(end, :) = [];
drawallline(line_xaxes, line_yaxes, line_zaxes);

function deleteliney_Callback(hObject, eventdata, handles)
global line_xaxes;
global line_yaxes; 
global line_zaxes;
if isempty(line_yaxes)
    return;
end
global img_ori;
figure(2);
hold off;
imshow(img_ori);
hold on;
line_yaxes(end, :) = [];
drawallline(line_xaxes, line_yaxes, line_zaxes);

function deletelinez_Callback(hObject, eventdata, handles)
global line_xaxes;
global line_yaxes; 
global line_zaxes;
if isempty(line_zaxes)
    return;
end
global img_ori;
figure(2);
hold off;
imshow(img_ori);
hold on;
line_zaxes(end, :) = [];
drawallline(line_xaxes, line_yaxes, line_zaxes);

%%
function save_Callback(hObject, eventdata, handles)
global line_xaxes;
global line_yaxes;
global line_zaxes;
global vp_x;
global vp_y;
global vp_z;
global vl_xy;
global vl_xz;
global vl_yz;
global refer_points;
global alpha;
global x_image;
global X_world;
global H;
global filename;

mat_name = ['param/', filename, '_line_xyz.mat'];
save(mat_name, 'line_xaxes', 'line_yaxes', 'line_zaxes', ...
    'vp_x', 'vp_y', 'vp_z', 'vl_xy', 'vl_xz', 'vl_yz', ...
    'refer_points', 'alpha', ....
    'x_image', 'X_world', 'H');

%%
function computevanishpoint_Callback(hObject, eventdata, handles)
global line_xaxes;
global line_yaxes;
global line_zaxes;
global img_ori;
global vp_x;
global vp_y;
global vp_z;
global vl_xy;
global vl_xz;
global vl_yz;
figure(3);
w = 1;
vp_x = [];
vp_y = [];
vp_z = [];

% property of vanishing point
% l x = 0; x'l' = 0
% x'l'lx = 0
% min(x'l1'l1x + x'l2'l2x + ...) = min(x'Mx) = min(x' lambda x) ???

% calculate vanishing point at x
M_x = zeros(3, 3);
for i = 1:size(line_xaxes, 1)
    p = [line_xaxes(i, 1); line_xaxes(i, 3); w];
    q = [line_xaxes(i, 2); line_xaxes(i, 4); w];
    l = cross(p, q);
    M_x = M_x + l * l';
end
[V, D] = eig(M_x);
vp_x = V(:, 1);
vp_x = vp_x / vp_x(3)
plot(vp_x(1), vp_x(2), 'ro'); hold on;
text(vp_x(1), vp_x(2), 'vp_x'); hold on;
drawline_vp(vp_x, line_xaxes, 'r--', 1);

% calculate vanishing point at y
M_y = zeros(3, 3);
for i = 1:size(line_yaxes, 1)
    p = [line_yaxes(i, 1); line_yaxes(i, 3); w];
    q = [line_yaxes(i, 2); line_yaxes(i, 4); w];
    l = cross(p, q);
    M_y = M_y + l * l';
end
[V, D] = eig(M_y);
vp_y = V(:, 1);
vp_y = vp_y / vp_y(3)
plot(vp_y(1), vp_y(2), 'ro'); hold on;
text(vp_y(1), vp_y(2), 'vp_y'); hold on;
drawline_vp(vp_y, line_yaxes, 'g--', 1);

% calculate vanishing point at z
M_z = zeros(3, 3);
for i = 1:size(line_zaxes, 1)
    p = [line_zaxes(i, 1); line_zaxes(i, 3); w];
    q = [line_zaxes(i, 2); line_zaxes(i, 4); w];
    l = cross(p, q);
    M_z = M_z + l * l';
end
[V, D] = eig(M_z);
vp_z = V(:, 1);
vp_z = vp_z / vp_z(3)
plot(vp_z(1), vp_z(2), 'ro'); hold on;
text(vp_z(1), vp_z(2), 'vp_z'); hold on;
drawline_vp(vp_z, line_zaxes, 'b--', 1);

% calculate vl_xy, vl_xz, vl_yz
vl_xy = cross(vp_x, vp_y);
vl_xz = cross(vp_x, vp_z);
vl_yz = cross(vp_y, vp_z);

% draw three lines between vanishing points at x,y,z
x = [vp_x(1), vp_y(1), vp_x(1), vp_z(1), vp_y(1), vp_z(1)];
y = [vp_x(2), vp_y(2), vp_x(2), vp_z(2), vp_y(2), vp_z(2)];
plot(x, y, 'c-'); hold on;

axis([min(x), max(x), min(y), max(y)]);

% output value
disp(vp_x');
disp(vp_y');
disp(vp_z');

%%
function DefineRP_Callback(hObject, eventdata, handles)
disp("[INFO] DefineRP_Callback");
global img_ori;
global rp_fig;
global refer_points;
global alpha;
figure(rp_fig); hold off;
imshow(img_ori); hold on;
refer_points = [];
for i=1:4
    mouse = impoint(gca);
    refer_points = [refer_points; getPosition(mouse)]; 
    fprintf('%d: (%d %d) \n', i, floor(refer_points(i, :)));
    alpha(i) = pdist([refer_points(1,:); refer_points(i,:)]);
end
drawreferpoint(refer_points, 'w--', 1, 20);
for i=2:length(alpha)
    text((refer_points(1,1)+refer_points(i,1))/2, ...
        (refer_points(1,2)+refer_points(i,2))/2, ...,
        [int2str(alpha(i)), 'px'], 'w', 'FontSize', 20);
end

%% TODO: set points manual
function Compute3DModel_Callback(hObject, eventdata, handles)
global img_ori;
global vp_x;
global vp_y;
global vp_z;
global vl_xy;
global vl_xz;
global vl_yz;
global refer_points;
global x_image;
global X_world;
global alpha;
global rp_fig;

figure(rp_fig); 
imshow(img_ori); hold on;
drawreferpoint(refer_points, 'w--', 1, 20); hold on;

fprintf('[INFO] Selected %d planes', floor(size(X_world, 1) / 4) + 1);

X = zeros(1, 3);
o = [refer_points(1, :), 1];

disp('Select start point');
mouse = impoint(gca); x = [getPosition(mouse), 1];

disp('X: b, t');
mouse = impoint(gca); b_x = [getPosition(mouse), 1];
mouse = impoint(gca); t_x = [getPosition(mouse), 1];
X(1) = compute3DPosition(o, vl_yz, vp_x, b_x, t_x, alpha(2));

disp('Y: b, t');
mouse = impoint(gca); b_y = [getPosition(mouse), 1];
mouse = impoint(gca); t_y = [getPosition(mouse), 1];
X(2) = compute3DPosition(o, vl_xz, vp_y, b_y, t_y, alpha(3));


disp('Z: b, t');
mouse = impoint(gca); b_z = [getPosition(mouse), 1];
mouse = impoint(gca); t_z = [getPosition(mouse), 1];
X(3) = compute3DPosition(o, vl_xy, vp_z, b_z, t_z, alpha(4));

% output result
disp('x: '); disp(x);
disp('X: '); disp(X);

x_image = [x_image; x];
X_world = [X_world; X];

%%
function computeH_Callback(hObject, eventdata, handles)
global x_image;
global X_world;
global H;

[x1, x2, x3, X1, X2, X3] = splitplane(x_image, X_world);
H1 = computeHomography(x1, X1); 
H2 = computeHomography(x2, X2); 
H3 = computeHomography(x3, X3); 
H = [H1; H2; H3];

%%
function createTMap_Callback(hObject, eventdata, handles)
global x_image;
global X_world;
global img_ori;
global selected_point_fig;
global H;

[x1, x2, x3, X1, X2, X3] = splitplane(x_image, X_world);
H1 = H(1:3, :); H2 = H(4:6, :); H3 = H(7:9, :);

% xz
texture_map_1 = computeTMap(x1, X1, H1, img_ori, 1);
figure(selected_point_fig + 1); imshow(texture_map_1); hold on;

% yz
texture_map_2 = computeTMap(x2, X2, H2, img_ori, 2);
figure(selected_point_fig + 2); imshow(texture_map_2); hold on;

% xy
texture_map_3 = computeTMap(x3, X3, H3, img_ori, 3);
figure(selected_point_fig + 3); imshow(texture_map_3); hold on;

imwrite(texture_map_1, 'result/box_sample_1.png');
imwrite(texture_map_2, 'result/box_sample_2.png');
imwrite(texture_map_3, 'result/box_sample_3.png');
disp('[SYSTEM] output the results');

%%
function outputVRML_Callback(hObject, eventdata, handles)


%%
function reset_Callback(hObject, eventdata, handles)
global img_ori;
global line_xaxes;
global line_yaxes;
global line_zaxes;
global vp_x;
global vp_y;
global vp_z;
global refer_points;
global x_image;
global X_world;
global H;
global filename;
img_ori = [];
line_xaxes = [];
line_yaxes = [];
line_zaxes = [];
vp_x = [];
vp_y = [];
vp_z = [];
refer_points = [];
x_image = [];
X_world = [];
H = [];
filename = 'box_sample';
disp("[SYSTEM] RESET");

%%
function reset3dmodel_Callback(hObject, eventdata, handles)
global x_image;
global X_world;
x_image = [];
X_world = [];

%%
function exit_Callback(hObject, eventdata, handles)
    close all;
%%
