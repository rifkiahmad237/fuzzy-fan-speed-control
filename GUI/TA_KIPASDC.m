function varargout = TA_KIPASDC(varargin)
% TA_KIPASDC MATLAB code for TA_KIPASDC.fig
%      TA_KIPASDC, by itself, creates a new TA_KIPASDC or raises the existing
%      singleton*.
%
%      H = TA_KIPASDC returns the handle to a new TA_KIPASDC or the handle to
%      the existing singleton*.
%
%      TA_KIPASDC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TA_KIPASDC.M with the given input arguments.
%
%      TA_KIPASDC('Property','Value',...) creates a new TA_KIPASDC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TA_KIPASDC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TA_KIPASDC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TA_KIPASDC

% Last Modified by GUIDE v2.5 24-Dec-2021 20:18:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TA_KIPASDC_OpeningFcn, ...
                   'gui_OutputFcn',  @TA_KIPASDC_OutputFcn, ...
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


% --- Executes just before TA_KIPASDC is made visible.
function TA_KIPASDC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TA_KIPASDC (see VARARGIN)

% Choose default command line output for TA_KIPASDC
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TA_KIPASDC wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TA_KIPASDC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_temp_Callback(hObject, eventdata, handles)
% hObject    handle to slider_temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input_temp = get(handles.slider_temp,'Value');
input_hum = get(handles.slider_hum,'Value');
temp = num2str(input_temp);
set(handles.tb_temp,'string',temp);
if input_temp <=27
     set(handles.ket_temp,'string','Rendah');
elseif input_temp > 27 && input_temp <= 32
    set(handles.ket_temp,'string','Sedang');
else
    set(handles.ket_temp,'string','Tinggi');
end

fis = readfis('TA');
input = [input_temp input_hum];
out = evalfis(input, fis);
output = num2str(out);

if out <= 110
    pwm_motor = 'Lambat';
elseif out > 110 && out <=220
    pwm_motor = 'Sedang';
else
    pwm_motor = 'Cepat';
end

set(handles.tb_pwm,'string',output);
set(handles.ket_pwm,'string',pwm_motor);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_temp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function tb_pwm_Callback(hObject, eventdata, handles)
% hObject    handle to tb_pwm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tb_pwm as text
%        str2double(get(hObject,'String')) returns contents of tb_pwm as a double


% --- Executes during object creation, after setting all properties.
function tb_pwm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tb_pwm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ket_pwm_Callback(hObject, eventdata, handles)
% hObject    handle to ket_pwm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ket_pwm as text
%        str2double(get(hObject,'String')) returns contents of ket_pwm as a double


% --- Executes during object creation, after setting all properties.
function ket_pwm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ket_pwm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tb_temp_Callback(hObject, eventdata, handles)
% hObject    handle to tb_temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tb_temp as text
%        str2double(get(hObject,'String')) returns contents of tb_temp as a double


% --- Executes during object creation, after setting all properties.
function tb_temp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tb_temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_hum_Callback(hObject, eventdata, handles)
% hObject    handle to slider_hum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input_temp = get(handles.slider_temp,'Value');
input_hum = get(handles.slider_hum,'Value');
hum = num2str(input_hum);
set(handles.tb_hum,'string',hum);
if input_hum <= 50
     set(handles.ket_hum,'string','Rendah');
elseif input_hum > 50 && input_hum <= 66
    set(handles.ket_hum,'string','Sedang');
else
    set(handles.ket_hum,'string','Tinggi');
end

fis = readfis('TA');
input = [input_temp input_hum];
out = evalfis(input, fis);
output = num2str(out);

if out <= 110
    pwm_motor = 'Lambat';
elseif out > 110 && out <=220
    pwm_motor = 'Sedang';
else
    pwm_motor = 'Cepat';
end

set(handles.tb_pwm,'string',output);
set(handles.ket_pwm,'string',pwm_motor);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_hum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_hum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function tb_hum_Callback(hObject, eventdata, handles)
% hObject    handle to tb_hum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tb_hum as text
%        str2double(get(hObject,'String')) returns contents of tb_hum as a double


% --- Executes during object creation, after setting all properties.
function tb_hum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tb_hum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ket_temp_Callback(hObject, eventdata, handles)
% hObject    handle to ket_temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ket_temp as text
%        str2double(get(hObject,'String')) returns contents of ket_temp as a double


% --- Executes during object creation, after setting all properties.
function ket_temp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ket_temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ket_hum_Callback(hObject, eventdata, handles)
% hObject    handle to ket_hum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ket_hum as text
%        str2double(get(hObject,'String')) returns contents of ket_hum as a double


% --- Executes during object creation, after setting all properties.
function ket_hum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ket_hum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
