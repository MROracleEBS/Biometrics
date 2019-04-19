function varargout = MAIN_GUIII(varargin)
% MAIN_GUIII M-file for MAIN_GUIII.fig
%      MAIN_GUIII, by itself, creates a new MAIN_GUIII or raises the existing
%      singleton*.
%
%      H = MAIN_GUIII returns the handle to a new MAIN_GUIII or the handle to
%      the existing singleton*.
%
%      MAIN_GUIII('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_GUIII.M with the given input arguments.
%
%      MAIN_GUIII('Property','Value',...) creates a new MAIN_GUIII or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MAIN_GUIII_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MAIN_GUIII_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MAIN_GUIII

% Last Modified by GUIDE v2.5 23-Dec-2018 10:31:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MAIN_GUIII_OpeningFcn, ...
                   'gui_OutputFcn',  @MAIN_GUIII_OutputFcn, ...
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


% --- Executes just before MAIN_GUIII is made visible.
function MAIN_GUIII_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MAIN_GUIII (see VARARGIN)

% Choose default command line output for MAIN_GUIII
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MAIN_GUIII wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MAIN_GUIII_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Loading the Image
[filename, pathname]=uigetfile( ...
    {'*.jpg','BMP File (*.jpg)'; ...
     '*.*','Any Image file (*.*)'}, ...
     'Pick an image file');
inp=imread(filename);
axes(handles.axes4);
imshow(inp);
title('Input image ')
guidata(hObject, handles);

if(length(size(inp))==3)
    I=rgb2gray(inp);
else
    I=inp;
end



T = 3; % threshold value
tic % tic; any_statements; toc;
% Applying standard median filter
filt1 = medfilt2(I); % performs median filtering using default 3*3 neighborhood
% figure, imshow(filt2); % shows the filtered image using 4*4 median filter
% title('median filter')
c3=corr2(double(I),double(filt1));
A=double(I)./255;
B=double(filt1)./255;
p1=PSNR(A,B);
axes(handles.axes2);
imshow(filt1),title('Median filter')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Applying standard average filter
set = ones(3,3) / 3^2; % the average of 9 values (3^2)
filt2 = imfilter(filt1,set); % to filter the multidimensional array (I)
%with the multidimensional filter (set).
%figure, imshow(filt3), title('average filter')
A=double(filt1)./255;
B=double(filt2)./255;
c1=corr2(double(filt1),double(filt2));
p2=PSNR(A,B);
axes(handles.axes9);
imshow(filt2),title('Average filter')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% tic starts a stopwatch timer to calculate the time in seconds needed
%to execute the statements (any_statements) until toc stops the timer.
[x,y] = size(filt2); % returns the size of matrix (I) in separate variables x & y
prec = double(filt2); % convert the image to double precision
delta = .1;
value = 0.01;
for S = 1:T; % to execute the block code a number of times
    calc = exp(-S*.2); % it returns the exponential for each element of (-S*.2)
    [Ix,Iy] = gradient(prec); % returns the x and y components of the
    %two dimensional numerical gradient.
    sqroot = sqrt(Ix.^2+Iy.^2); % returns the square root for each element
    %of the array(Ix.^2+Iy.^2).
    disLap = del2(prec); % to calculate the discrete laplacian
    N1 = 0.5*((sqroot./(prec+value)).^2);
    N2 = 0.0625*((disLap./(prec+value)).^2);
    N3 = (1+(0.25*(disLap./(prec+value)))).^2;
    N = sqrt((N1-N2)./(N3+value));
    calc1 = (N.^2-calc.^2)./((calc.^2*(1+calc.^2)+value));
    calc2 = 1./(1+calc1);
    [M1,M2] = gradient(calc2.*Ix);
    [M3,M4] = gradient(calc2.*Iy);
    M = M1+M4;
    prec = real(prec+delta.*M); % returns the real part of the elements
    %of the complex array (prec+delta .*M).
end % termination of the for statement.
% is used to stop the timer and display the time elapsed to
%execute the statements.
img = uint8(prec); % converts the output image to unsigned 8-bit integer.
% figure,imshow(img); % imshow is used to show the filtered image where
%figure is used to plot the image in a separate window.
% title('diffusion filter')
c2=corr2(double(filt2),double(img));
A=double(filt2)./255;
B=double(img)./255;
p3=PSNR(A,B);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

axes(handles.axes11);
imshow(img),title('Diffusion filter')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
BW = edge(img,'sobel'); %finding edges 

BW2 = bwareaopen(BW,5);
axes(handles.axes12);
imshow(BW)
axes(handles.axes13);
imshow(BW2)



[imx,imy]=size(BW2);
msk=[0 0 0 0 0;
     0 1 1 1 0;
     0 1 1 1 0;
     0 1 1 1 0;
     0 0 0 0 0;];
B=conv2(double(BW2),double(msk)); %Smoothing  image to reduce the number of connected components
L = bwlabel(B,8);% Calculating connected components
mx=max(max(L));

[r,c] = find(L==34);  
rc = [r c];
[sx sy]=size(rc);
n1=zeros(imx,imy); 
for i=1:sx
    x1=rc(i,1);
    y1=rc(i,2);
    n1(x1,y1)=255;
end % Storing the extracted image in an array


axes(handles.axes14);
imshow(B);
axes(handles.axes15);
imshow(n1,[]);
cc = bwconncomp(B);
labeled = labelmatrix(cc);
RGB_label = label2rgb(labeled, @copper, 'c', 'shuffle');
axes(handles.axes16);
imshow(RGB_label,'InitialMagnification','fit')
handles.edit2.String = sprintf('%5.2f dB',p1);
handles.edit3.String = sprintf('%5.2f dB',p2);
handles.edit4.String = sprintf('%5.2f dB',p3);
handles.edit6.String = sprintf('%5.2f ',c3);
handles.edit7.String = sprintf('%5.2f ',c2);
handles.edit8.String = sprintf('%5.2f ',c1);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
