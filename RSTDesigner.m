% This file handles the user interface
% Written by Louis Saint-Raymond
% 
% Just run it to use the RST Designer

function varargout = RSTDesigner(varargin)
% RSTDESIGNER M-file for RSTDesigner.fig
%      RSTDESIGNER, by itself, creates a new RSTDESIGNER or raises the existing
%      singleton*.
%
%      H = RSTDESIGNER returns the handle to a new RSTDESIGNER or the handle to
%      the existing singleton*.
%
%      RSTDESIGNER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RSTDESIGNER.M with the given input arguments.
%
%      RSTDESIGNER('Property','Value',...) creates a new RSTDESIGNER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RSTDesigner_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RSTDesigner_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RSTDesigner

% Last Modified by GUIDE v2.5 02-Sep-2012 17:15:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RSTDesigner_OpeningFcn, ...
                   'gui_OutputFcn',  @RSTDesigner_OutputFcn, ...
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

% --- Executes just before RSTDesigner is made visible.
function RSTDesigner_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RSTDesigner (see VARARGIN)

% Choose default command line output for RSTDesigner
handles.output = hObject;
set(handles.uipanel_Order,'SelectionChangeFcn',@Radiobutton_Order);
set(handles.uipanel_step,'SelectionChangeFcn',@Radiobutton_Step);
set(handles.uipanel_Compute,'SelectionChangeFcn',@Radiobutton_Compute);
%Initialization of the sampling time
handles.Te=20e-3;%Sampling time
string = ['Sampling time: Te = ',num2str(handles.Te*10^3),'ms'];
set(handles.text_Te,'String',string);
set(handles.edit_Te,'String',num2str(handles.Te*10^3));
%Absolute conditions
a=20;   ka=10;
handles.absolute_r=exp(-log(a)/ka);
%Relative conditions
a=535;  N=1;
handles.relative=log(a)/(2*N*pi);
%Initialization of Hsyst(z)
handles.Asyst=[1 -3.031 3.944 -2.619 0.7507];
handles.Bsyst=[0.03874 -0.005147 -0.03728 0.04327];
set(handles.textbox_Az,'String',num2str(handles.Asyst))
set(handles.textbox_Bz,'String',num2str(handles.Bsyst))
axes(handles.axes_Hsyst_text)
axis off
%Initialization of P(z)
handles.P_order=1;
handles.P_p1=complex(0.7,0);
set(handles.textbox_Pz_first,'String',num2str(handles.P_p1));
set(handles.radiobutton_P_first,'Value',1)
set(handles.radiobutton_P_second,'Value',0)
set(handles.textbox_Pz_second,'Enable','off')
set(handles.text_Second_Pole,'Enable','off')
axes(handles.axes_P_text)
axis off
%Initialisation of Pa(z)
set(handles.checkbox_Pa_pile,'Value',0);
handles.Pa_pile='no';
handles.Pa_pnumber=1;
axes(handles.axes_Pa_text)
axis off
%Initialisation of A0(z)
set(handles.checkbox_A0_pile,'Value',0);
handles.A0_pile='no';
handles.A0_pnumber=1;
axes(handles.axes_A0_text)
axis off
%Initialization of fix terms polynomials Pr and Ps
handles.Pr = 1;
handles.Ps = 1;
%Initialization of Advanced mode
handles.nbIntegrator = 0;
handles.cancel_drag = 0;
%Initialization of graphics
set(handles.popup_graphleft,'Enable','off')
set(handles.popup_graphright,'Enable','off')
handles.output_first_time=1;
handles.command_first_time=1;
handles.noise_first_time=1;
handles.nyquist_first_time=1;
handles.sensibility_first_time=1;
handles.ramp_first_time=1;
handles.closed_loop_first_time = 1;
handles.bode_open_loop_first_time=1;
handles.regulation_first_time=1;
%hide
set(handles.uipanel_Step_Info,'Visible','off')
set(handles.uipanel_Step_Advanced,'Visible','off')
set(handles.uipanel_Step_Results,'Visible','off') 
%display
set(handles.uipanel_Step_System,'Visible','on')

%Update handles structure
guidata(hObject, handles);
% UIWAIT makes RSTDesigner wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function edit_Te_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Te (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Te as text
%        str2double(get(hObject,'String')) returns contents of edit_Te as a double
Te=str2num(get(hObject,'String'));
handles.Te=Te*10^3;
string = ['Sampling time: Te = ',num2str(Te),'ms'];
set(handles.text_Te,'String',string)
guidata(hObject, handles);

function textbox_Az_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_Az (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_Az as text
%        str2double(get(hObject,'String')) returns contents of textbox_Az
%        as a double
handles.Asyst=str2num(get(hObject,'String'));
guidata(hObject, handles);

function textbox_Bz_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_Bz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_Bz as text
%        str2double(get(hObject,'String')) returns contents of textbox_Bz
%        as a double
handles.Bsyst=str2num(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes on button press in pushbutton_validate_H.
function pushbutton_validate_H_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_validate_H (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
H=tf(handles.Bsyst,handles.Asyst,handles.Te);
handles.Hsyst=H;
axes(handles.axes_Hsyst_text)
axis off
display_poly(handles.Bsyst,handles.Asyst,'Hsyst','z','factorized')
[Bminus,Bplus]=spectral_factorization(handles.Bsyst,handles.absolute_r,handles.relative);%Spectral Factorization of Bsyst=Bplus*Bminus
handles.Bminus=Bminus;
handles.Bplus=Bplus;
uicontrol(handles.textbox_Pz_first)% highlight the Pz cell
guidata(hObject, handles);

function Radiobutton_Order(hObject, eventdata)
%retrieve GUI data, i.e. the handles structure
handles = guidata(hObject); 
switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'radiobutton_P_first'
        handles.P_order=1;
        set(handles.textbox_Pz_second,'Enable','off')
        set(handles.text_Second_Pole,'Enable','off')
        uicontrol(handles.textbox_Pz_first)
    case 'radiobutton_P_second'
        handles.P_order=2;
        set(handles.textbox_Pz_second,'Enable','on')
        set(handles.textbox_Pz_second,'String','0.7')
        handles.P_p2=0.7;
        set(handles.text_Second_Pole,'Enable','on')
        uicontrol(handles.textbox_Pz_second)
end
%updates the handles structure
guidata(hObject, handles);

function Radiobutton_Step(hObject, eventdata)
%retrieve GUI data, i.e. the handles structure
handles = guidata(hObject); 
%hide all
set(handles.uipanel_Step_Info,'Visible','off')
set(handles.uipanel_Step_Advanced,'Visible','off')
set(handles.uipanel_Step_Results,'Visible','off') 
set(handles.uipanel_Step_System,'Visible','off')
%display
switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'radiobutton_System'
        set(handles.uipanel_Step_System,'Visible','on') 
    case 'radiobutton_Advanced'
        set(handles.uipanel_Step_Advanced,'Visible','on')    
    case 'radiobutton_Results'
         set(handles.uipanel_Step_Results,'Visible','on')   
    case 'radiobutton_Info'
        set(handles.uipanel_Step_Info,'Visible','on') 
    otherwise %system
        set(handles.uipanel_Step_System,'Visible','on')
end
%updates the handles structure
guidata(hObject, handles);

function Radiobutton_Compute(hObject, eventdata)
%retrieve GUI data, i.e. the handles structure
handles = guidata(hObject);
switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'radiobutton_Compute'
        handles.nbIntegrator = 0;
        handles.Pr = 1;
        handles.Ps = 1;
        handles.cancel_drag = 0;
        [handles.Am_degree,handles.Pa_degree,handles.A0_degree]=Compute_polynomial_degree(handles.Asyst,handles.Bsyst,...
                                                handles.Bminus,handles.Bplus,handles.P,handles.Pr,handles.Ps,...
                                                handles.nbIntegrator,handles.cancel_drag);
        %deadbeat polynomial Pa and A0
        handles.Pa=zeros(1,handles.Pa_degree+1);
        handles.Pa(1)=1;
        handles.A0=zeros(1,handles.A0_degree+1);
        handles.A0(1)=1;
        guidata(hObject, handles);
        %Compute RST
        handles=Compute_RST(handles);
        %hide
        set(handles.uipanel_Step_Info,'Visible','off') 
        set(handles.uipanel_Step_System,'Visible','off') 
        set(handles.uipanel_Step_Advanced,'Visible','off')
        %display
        set(handles.uipanel_Step_Results,'Visible','on') 
        set(handles.radiobutton_System,'Value',0)
        set(handles.radiobutton_Advanced,'Value',0)
        set(handles.radiobutton_Info,'Value',0)
        set(handles.radiobutton_Results,'Value',1)
    case 'radiobutton_Compute_smooth'
        handles.nbIntegrator = 0;
        handles.cancel_drag = 0;
        handles.Pr = 1;
        handles.Ps = [1 1]; %smooth the command
        [handles.Am_degree,handles.Pa_degree,handles.A0_degree]=Compute_polynomial_degree(handles.Asyst,handles.Bsyst,...
                                                handles.Bminus,handles.Bplus,handles.P,handles.Pr,handles.Ps,...
                                                handles.nbIntegrator,handles.cancel_drag);
        %smoother Pa and A0
        root=min(abs(roots(handles.P)))/3; % 3 times smaller than zeros of P
        handles.Pa=poly(root*ones(1,handles.Pa_degree));
        handles.A0=poly(root*ones(1,handles.A0_degree));
        guidata(hObject, handles);
        %Compute RST
        handles=Compute_RST(handles);
        %hide
        set(handles.uipanel_Step_Info,'Visible','off')
        set(handles.uipanel_Step_System,'Visible','off')
        set(handles.uipanel_Step_Advanced,'Visible','off')
        %display
        set(handles.uipanel_Step_Results,'Visible','on')
        set(handles.radiobutton_System,'Value',0)
        set(handles.radiobutton_Advanced,'Value',0)
        set(handles.radiobutton_Info,'Value',0)
        set(handles.radiobutton_Results,'Value',1)
    case 'radiobutton_Advanced_mode'
        set(handles.pushbutton_compute_RST,'Enable','off')
        %Disable uipanel_A0
        set(handles.checkbox_Pa_pile,'Enable','off')
        set(handles.text_Pa_pole,'Enable','off')
        set(handles.textbox_Pa_pole,'Enable','off')
        set(handles.checkbox_Pa_pile,'Enable','off')
        set(handles.pushbutton_Pa_reset,'Enable','off')
        axes(handles.axes_Pa_text)
        axis off
        %Disable uipanel_Pa
        set(handles.checkbox_A0_pile,'Enable','off')
        set(handles.text_A0_pole,'Enable','off')
        set(handles.textbox_A0_pole,'Enable','off')
        set(handles.checkbox_A0_pile,'Enable','off')
        set(handles.pushbutton_A0_reset,'Enable','off')
        axes(handles.axes_A0_text)
        axis off
        %hide
        set(handles.uipanel_Step_Info,'Visible','off')
        set(handles.uipanel_Step_System,'Visible','off')
        set(handles.uipanel_Step_Results,'Visible','off')
        %display
        set(handles.uipanel_Step_Advanced,'Visible','on')
        set(handles.radiobutton_System,'Value',0)
        set(handles.radiobutton_Advanced,'Value',1)
        set(handles.radiobutton_Info,'Value',0)
        set(handles.radiobutton_Results,'Value',0)
end
%updates the handles structure
guidata(hObject, handles);

function textbox_Pz_first_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_Pz_first (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_Pz_first as text
%        str2double(get(hObject,'String')) returns contents of textbox_Pz_first as a double
p1=str2num(get(hObject,'String'));
handles.P_p1=complex(real(p1),imag(p1));
if imag(p1)~=0
    handles.P_p2=conj(p1);
    set(handles.textbox_Pz_second,'String',num2str(handles.P_p2))
end
guidata(hObject, handles);

function textbox_Pz_second_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_Pz_second (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_Pz_second as text
%        str2double(get(hObject,'String')) returns contents of
%        textbox_Pz_second as a double
p2=str2num(get(hObject,'String'));
p2=complex(real(p2),imag(p2));
if imag(p2)~=0 && p2~=conj(handles.P_p1)
    p2=handles.P_p1;
    set(handles.textbox_Pz_second,'String',num2str(p2))
end
handles.P_p2=p2;
guidata(hObject, handles);

% --- Executes on button press in pushbutton_validate_P.
function pushbutton_validate_P_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_validate_P (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.P_order == 1
    p1=handles.P_p1;
    P=poly(p1);
else
    p1=handles.P_p1;
    p2=handles.P_p2;
    P=poly([p1 p2]);
end
handles.P=P;
axes(handles.axes_P_text)
axis off
display_poly(P,1,'P','z','factorized')
set(handles.radiobutton_Compute,'Value',0)
set(handles.radiobutton_Advanced_mode,'Value',0)
set(handles.radiobutton_Compute_smooth,'Value',0)
guidata(hObject, handles);

% --- Executes on button press in checkbox_Pa_pile.
function checkbox_Pa_pile_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Pa_pile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Pa_pile
checkboxStatus = get(hObject,'Value');
if(checkboxStatus)
    handles.Pa_pile='yes';
    handles.Pa=zeros(1,handles.Pa_degree+1);
    handles.Pa(1)=1;
    axes(handles.axes_Pa_text)
    axis off
    display_poly(handles.Pa,1,'Pa','z','factorized')
    set(handles.textbox_Pa_pole,'Enable','off')
    set(handles.pushbutton_Pa_reset,'Enable','off')
    set(handles.text_Pa_pole,'Enable','off')
    handles.enable_computeRST.Pa = 1; enable_ComputeRST(handles)
else
    handles.Pa_pile='no';
    handles.Pa_pnumber=1;
    nb_pole=['Pole',num2str(handles.Pa_pnumber),' /',num2str(handles.Pa_degree)];%update the number of the pole
    set(handles.text_Pa_pole,'String',nb_pole)
    set(handles.textbox_Pa_pole,'Enable','on')
    set(handles.pushbutton_Pa_reset,'Enable','on')
    set(handles.text_Pa_pole,'Enable','on')
    handles.enable_computeRST.Pa = 0; enable_ComputeRST(handles)
    axes(handles.axes_Pa_text)
    cla
    uicontrol(handles.textbox_Pa_pole)
end
guidata(hObject, handles);

function textbox_Pa_pole_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_Pa_pole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_Pa_pole as text
%        str2double(get(hObject,'String')) returns contents of textbox_Pa_pole as a double
pole=str2num(get(hObject,'String'));
handles.Pa_pole(handles.Pa_pnumber)=pole;
handles.Pa=poly(handles.Pa_pole(1:handles.Pa_pnumber));
axes(handles.axes_Pa_text)
axis off
display_poly(handles.Pa,1,'Pa','z','factorized')
if handles.Pa_pnumber>=handles.Pa_degree %it was the last pole to store
    set(handles.textbox_Pa_pole,'Enable','off')
    set(handles.text_Pa_pole,'Enable','off')
    handles.enable_computeRST.Pa = 1; enable_ComputeRST(handles)
else
    handles.Pa_pnumber=handles.Pa_pnumber+1;
    nb_pole=['Pole',num2str(handles.Pa_pnumber),' /',num2str(handles.Pa_degree)];%update the number of the pole
    set(handles.text_Pa_pole,'String',nb_pole)
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton_Pa_reset.
function pushbutton_Pa_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Pa_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Pa=1;
handles.Pa_pnumber=1;
nb_pole=['Pole',num2str(handles.Pa_pnumber),' /',num2str(handles.Pa_degree)];%update the number of the pole
set(handles.text_Pa_pole,'String',nb_pole)
set(handles.textbox_Pa_pole,'Enable','on')
set(handles.pushbutton_Pa_reset,'Enable','on')
set(handles.text_Pa_pole,'Enable','on')
axes(handles.axes_Pa_text)
cla
uicontrol(handles.textbox_Pa_pole)
guidata(hObject, handles);

% --- Executes on button press in checkbox_A0_pile.
function checkbox_A0_pile_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_A0_pile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_A0_pile
checkboxStatus = get(hObject,'Value');
if(checkboxStatus)
    handles.A0_pile='yes';
    handles.A0=zeros(1,handles.A0_degree+1);
    handles.A0(1)=1;
    axes(handles.axes_A0_text)
    axis off
    display_poly(handles.A0,1,'A0','z','factorized')
    set(handles.textbox_A0_pole,'Enable','off')
    set(handles.pushbutton_A0_reset,'Enable','off')
    set(handles.text_A0_pole,'Enable','off')
    handles.enable_computeRST.A0 = 1; enable_ComputeRST(handles)
else
    handles.A0_pile='no';
    handles.A0_pnumber=1;
    nb_pole=['Pole',num2str(handles.A0_pnumber),' /',num2str(handles.A0_degree)];%update the number of the pole
    set(handles.text_A0_pole,'String',nb_pole)
    set(handles.textbox_A0_pole,'Enable','on')
    set(handles.pushbutton_A0_reset,'Enable','on')
    set(handles.text_A0_pole,'Enable','on')
    handles.enable_computeRST.A0 = 0; enable_ComputeRST(handles)
    axes(handles.axes_A0_text)
    cla
    uicontrol(handles.textbox_A0_pole)
end
guidata(hObject, handles);

function textbox_A0_pole_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_A0_pole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_A0_pole as text
%        str2double(get(hObject,'String')) returns contents of textbox_A0_pole as a double
pole=str2num(get(hObject,'String'));
handles.A0_pole(handles.A0_pnumber)=pole;
handles.A0=poly(handles.A0_pole(1:handles.A0_pnumber));
axes(handles.axes_A0_text)
axis off
display_poly(handles.A0,1,'A0','z','factorized')
if handles.A0_pnumber>=handles.A0_degree %it was the last pole to store
    set(handles.textbox_A0_pole,'Enable','off')
    set(handles.text_A0_pole,'Enable','off')
    handles.enable_computeRST.A0 = 1; enable_ComputeRST(handles)
else
    handles.A0_pnumber=handles.A0_pnumber+1;
    nb_pole=['Pole',num2str(handles.A0_pnumber),' /',num2str(handles.A0_degree)];%update the number of the pole
    set(handles.text_A0_pole,'String',nb_pole)
    handles.enable_computeRST.A0 = 0; enable_ComputeRST(handles)
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton_A0_reset.
function pushbutton_A0_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_A0_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.A0=1;
handles.A0_pnumber=1;
nb_pole=['Pole',num2str(handles.A0_pnumber),' /',num2str(handles.A0_degree)];%update the number of the pole
set(handles.text_A0_pole,'String',nb_pole)
set(handles.textbox_A0_pole,'Enable','on')
set(handles.pushbutton_A0_reset,'Enable','on')
set(handles.text_A0_pole,'Enable','on')
axes(handles.axes_A0_text)
cla
uicontrol(handles.textbox_A0_pole)
guidata(hObject, handles);

% --- Executes on button press in pushbutton_compute_RST.
function pushbutton_compute_RST_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_compute_RST (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=Compute_RST(handles);
%hide
set(handles.uipanel_Step_Info,'Visible','off') 
set(handles.uipanel_Step_System,'Visible','off') 
set(handles.uipanel_Step_Advanced,'Visible','off')
%display
set(handles.uipanel_Step_Results,'Visible','on')
set(handles.radiobutton_System,'Value',0)
set(handles.radiobutton_Advanced,'Value',0)
set(handles.radiobutton_Info,'Value',0)
set(handles.radiobutton_Results,'Value',1)
guidata(hObject, handles);

% --- Executes on selection change in popupmenu_nbIntegrator.
function popupmenu_nbIntegrator_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_nbIntegrator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_nbIntegrator contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_nbIntegrator
graph=get(hObject,'Value');
switch graph
    case 1 %Without integrator
        nbIntegrator=0;
    case 2 %1 integrator
        nbIntegrator=1;
    case 3 %2 integrators
        nbIntegrator=2;
    case 4 % 3 integrators
        nbIntegrator=3;
end
handles.nbIntegrator=nbIntegrator;
guidata(hObject, handles);

function edit_Relative_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Relative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Relative as text
%        str2double(get(hObject,'String')) returns contents of edit_Relative as a double
relative=str2num(get(hObject,'String'));
%Relative conditions
a=relative(1);  
N=relative(2);
handles.relative=log(a)/(2*N*pi);
guidata(hObject, handles);

function edit_Absolute_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Absolute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Absolute as text
%        str2double(get(hObject,'String')) returns contents of edit_Absolute as a double
absolute=str2num(get(hObject,'String'));
%Absolute conditions
a=absolute(1);   
ka=absolute(2);
handles.absolute_r=exp(-log(a)/ka);
uicontrol(handles.edit_Relative)
guidata(hObject, handles);

% --- Executes on button press in checkbox_Cancel_drag.
function checkbox_Cancel_drag_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_Cancel_drag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_Cancel_drag
checkboxStatus = get(hObject,'Value');
handles.cancel_drag = checkboxStatus;
guidata(hObject, handles);

% --- Executes on button press in pushbutton_Validate_Advanced.
function pushbutton_Validate_Advanced_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Validate_Advanced (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.Bminus,handles.Bplus]=spectral_factorization(handles.Bsyst,handles.absolute_r,handles.relative);%Spectral Factorization of Bsyst=Bplus*Bminus
[handles.Am_degree,handles.Pa_degree,handles.A0_degree]=Compute_polynomial_degree(handles.Asyst,handles.Bsyst,...
                                                handles.Bminus,handles.Bplus,handles.P,handles.Pr,handles.Ps,...
                                                handles.nbIntegrator,handles.cancel_drag);
set(handles.checkbox_Pa_pile,'Value',0);
set(handles.checkbox_A0_pile,'Value',0);
if handles.Pa_degree<1
    set(handles.textbox_Pa_pole,'Enable','off')
    set(handles.pushbutton_Pa_reset,'Enable','off')
    set(handles.text_Pa_pole,'Enable','off')
    set(handles.checkbox_Pa_pile,'Enable','off')
    set(handles.pushbutton_validate_Pa,'Enable','off')
else
    set(handles.checkbox_Pa_pile,'Enable','on')
    if get(handles.checkbox_Pa_pile,'Value')
        set(handles.textbox_Pa_pole,'Enable','off')
        set(handles.pushbutton_Pa_reset,'Enable','off')
        set(handles.text_Pa_pole,'Enable','off')
    else
        set(handles.textbox_Pa_pole,'Enable','on')
        set(handles.pushbutton_Pa_reset,'Enable','on')
        set(handles.text_Pa_pole,'Enable','on')
    end
end
if handles.A0_degree<1
    set(handles.textbox_A0_pole,'Enable','off')
    set(handles.pushbutton_A0_reset,'Enable','off')
    set(handles.text_A0_pole,'Enable','off')
    set(handles.checkbox_A0_pile,'Enable','off')
    set(handles.pushbutton_validate_A0,'Enable','off')
else
    set(handles.checkbox_A0_pile,'Enable','on')
    if get(handles.checkbox_A0_pile,'Value')
        set(handles.textbox_A0_pole,'Enable','off')
        set(handles.pushbutton_A0_reset,'Enable','off')
        set(handles.text_A0_pole,'Enable','off')
    else
        set(handles.textbox_A0_pole,'Enable','on')
        set(handles.pushbutton_A0_reset,'Enable','on')
        set(handles.text_A0_pole,'Enable','on')
    end
    
end
nb_pole=['Pole',num2str(handles.Pa_pnumber),' /',num2str(handles.Pa_degree)];
set(handles.text_Pa_pole,'String',nb_pole)
nb_pole=['Pole',num2str(handles.A0_pnumber),' /',num2str(handles.A0_degree)];
set(handles.text_A0_pole,'String',nb_pole)
handles.enable_computeRST.A0 = 0;
handles.enable_computeRST.Pa = 0;
guidata(hObject, handles);

function textbox_Pr_zeros_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_Pr_zeros (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_Pr_zeros as text
%        str2double(get(hObject,'String')) returns contents of textbox_Pr_zeros as a double
zeros=str2num(get(hObject,'String'));
handles.Pr = poly(zeros);
axes(handles.axes_Pr_text)
axis off
display_poly(handles.Pr,1,'Pr','z','factorized')
guidata(hObject, handles);

function textbox_Ps_zeros_Callback(hObject, eventdata, handles)
% hObject    handle to textbox_Ps_zeros (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textbox_Ps_zeros as text
%        str2double(get(hObject,'String')) returns contents of textbox_Ps_zeros as a double
zeros=str2num(get(hObject,'String'));
handles.Ps = poly(zeros);
axes(handles.axes_Ps_text)
axis off
display_poly(handles.Ps,1,'Ps','z','factorized')
guidata(hObject, handles);

% --- Executes on selection change in popup_graphleft.
function popup_graphleft_Callback(hObject, eventdata, handles)
% hObject    handle to popup_graphleft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_graphleft contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_graphleft
graph=get(hObject,'Value');
handles=Display_graph(handles, graph, 'up');
guidata(hObject, handles);

% --- Executes on selection change in popup_graphright.
function popup_graphright_Callback(hObject, eventdata, handles)
% hObject    handle to popup_graphright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_graphright contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_graphright
graph=get(hObject,'Value');
handles=Display_graph(handles, graph, 'down');
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function enable_ComputeRST(handles)
if handles.enable_computeRST.A0 && handles.enable_computeRST.Pa
   set(handles.pushbutton_compute_RST,'Enable','on')
else
    set(handles.pushbutton_compute_RST,'Enable','off')
end

function [Am_degree,Pa_degree,A0_degree]=Compute_polynomial_degree(Asyst,Bsyst,Bminus,Bplus,P,Pr,Ps,nbIntegrator,cancel_drag)
Asyst_degree = length(Asyst)-1;
Bsyst_degree = length(Bsyst)-1;
Bminus_degree = length(Bminus)-1;
Bplus_degree = length(Bplus)-1;
P_degree = length(P)-1;
Pr_degree = length(Pr)-1;
Ps_degree = length(Ps)-1;

%degree of Am, denominator of the model
Am_degree=Asyst_degree-Bsyst_degree+Bminus_degree+cancel_drag;
%degree of Pa
Pa_degree=Am_degree-P_degree;
%degree of A0
A0_degree=2*Asyst_degree - Am_degree - Bplus_degree + Pr_degree + Ps_degree + nbIntegrator - 1;

function [z_cancel_drag]=Cancel_drag(Am,Bm)
%Am: denominator of the model
%Bm: numerator of the model
poles = roots(Am);
zeros = roots(Bm);
sum_poles = 0;
sum_zeros = 0;
for i=1:length(poles)
    sum_poles = sum_poles + 1/(1-poles(i));
end
for i=1:length(zeros)
    sum_zeros = sum_zeros + 1/(1-zeros(i));
end
z_cancel_drag = 1-1/(sum_poles-sum_zeros);

function [handles]=Compute_RST(handles)
Asyst_degree = length(handles.Asyst)-1;
Pr_degree = length(handles.Pr)-1;
%degree of Rbarprime and Sprime
Rbarprime_degree=handles.Am_degree+handles.A0_degree-Asyst_degree-handles.nbIntegrator-Pr_degree;
Sprime_degree=Asyst_degree+handles.nbIntegrator-1+Pr_degree;
%Am=P*Pa;
Am=conv(handles.P,handles.Pa);
%Bm = Bminus*Bmprime --> Bmprime = P(1)*Pa(1)/Bminus(1)*(z-z_cancel_drag)/(1-z_cancel_drag)
Bmprime= polyval(handles.P,1)*polyval(handles.Pa,1)/polyval(handles.Bminus,1);
if handles.cancel_drag == 1
    Bm=conv(handles.Bminus,Bmprime);
    z_cancel_drag = Cancel_drag(Am,Bm);
    Bmprime=conv(Bmprime,[1 -z_cancel_drag])/(1-z_cancel_drag);%add a zero to Bmprime if the drag need to be cancelled
end
%integrator=(z-1)^L
integrator=[1 -1];
integrator=tf(integrator,1,handles.Te);
integrator=integrator^handles.nbIntegrator;
[integrator, ~, ~]=tfdata(integrator,'v');
%Solve the Diophante equation : Asyst*(z-1)^L*Pr*Rbarprime+Bminus*Ps*S = Am*A0;
M=conv(handles.Pr,conv(handles.Asyst,integrator)); N=conv(handles.Bminus,handles.Ps); C=conv(Am,handles.A0);
[Rbarprime, Sprime]=Diophante_eq(M, N, C, Rbarprime_degree, Sprime_degree);
R=conv(handles.Bplus,conv(integrator,Rbarprime));%R=(z-1)^L*Bplus*Rbarprime
S=conv(handles.Ps,Sprime);%S=Ps*Sprime
handles.R=R'; handles.S=S';
handles.T=conv(Bmprime,handles.A0);
%Display R S T
axes(handles.axes_R_text)
axis off
display_poly(handles.R,1,'R','z','developped')
axes(handles.axes_S_text)
axis off
display_poly(handles.S,1,'S','z','developped')
axes(handles.axes_T_text)
axis off
display_poly(handles.T,1,'T','z','developped')
%Display Hsyst, Bm, Am, A0, Pa and Bmprime
axes(handles.axes_Hsyst2_text)
axis off
display_poly(handles.Bsyst,handles.Asyst,'Hsyst','z','factorized')
axes(handles.axes_Bm_text)
axis off
Bm=conv(handles.Bminus,Bmprime);
display_poly(Bm,1,'Bm','z','factorized')
axes(handles.axes_Am_text)
axis off
display_poly(Am,1,'Am','z','factorized')
axes(handles.axes_A02_text)
axis off
display_poly(handles.A0,1,'A0','z','factorized')
axes(handles.axes_Pa2_text)
axis off
display_poly(handles.Pa,1,'Pa','z','factorized')
axes(handles.axes_Bmprime_text)
axis off
display_poly(Bmprime,1,'B''m','z','factorized')

%Store polynomials R, S and T in a .txt file
file = fopen('RST_polynomials.txt','w');
fprintf(file,'R: ');
fprintf(file,'%f\t',handles.R);
fprintf(file,'\nS: ');
fprintf(file,'%f\t',handles.S);
fprintf(file,'\nT: ');
fprintf(file,'%f\t',handles.T);
fprintf(file,'\n');
fclose(file);

%Activate graph menu
set(handles.popup_graphleft,'Enable','on')
set(handles.popup_graphright,'Enable','on')


function [handles]=Display_graph(handles, choice, which_axes)

if (strcmp(which_axes,'up'))
    axes(handles.axes_up)
else
    axes(handles.axes_down)
end
switch choice
    case 1
        graph = 3; % 3:step output
    case 2
        graph = 4; % 4:step command
    case 3
        graph = 7; % 7:ramp output
    case 4
        graph = 1 ; % 1:poles of the system
    case 5
        graph = 2; % 2:open loop Nyquist
    case 6
        graph = 9; % 9: open loop Bode
    case 7
        graph = 8; % 8:closed loop
    case 8
        graph = 6; % 6:sensibility
    case 9
        graph = 5; % 5: measurement noise
    case 10
        graph = 10; % 10: Regulation
    otherwise ;
end

switch graph   
    case 1 %poles of the system
        axes(handles.axes_up)
        pzmap(handles.Hsyst)
        hold on
        w=-pi:0.04:pi+0.1;
        plot(handles.absolute_r*exp(w*1i),'c--');%absolute conditions
        plot(exp(-handles.relative.*abs(w)).*exp(1i.*w),'m--')%relative condition
        plot(handles.P_p1,'r+')
        if handles.P_order==2
            plot(handles.P_p2,'r+')
        end
        hold off
        legend('System Poles&Zeros','Absolute Condition','Relative Condition','Model Poles')
        axis equal 
        axes(handles.axes_down)
        Bsyst=tf(handles.Bsyst,1,handles.Te);
        Asyst=tf(handles.Asyst,1,handles.Te);
        R=tf(handles.R,1,handles.Te);
        S=tf(handles.S,1,handles.Te);
        T=tf(handles.T,1,handles.Te);
        H=minreal(Bsyst*T/(Asyst*R+Bsyst*S));
        pzmap(H)
        hold on
        w=-pi:0.04:pi+0.1;
        plot(handles.absolute_r*exp(w*1i),'c--');%absolute conditions
        plot(exp(-handles.relative.*abs(w)).*exp(1i.*w),'m--')%relative condition
        hold off
        legend('Close Loop Poles&Zeros','Absolute Condition','Relative Condition')
        axis equal
    case 2 %nyquist open loop KH
        Bsyst=tf(handles.Bsyst,1,handles.Te);
        Asyst=tf(handles.Asyst,1,handles.Te);
        R=tf(handles.R,1,handles.Te);
        S=tf(handles.S,1,handles.Te);
        KH=minreal(S*Bsyst/(Asyst*R));
        if handles.nyquist_first_time==1
            handles.nyquist_first_time=0;
            nyquist(KH)
        else
            nyquist(handles.nyquist_previous, KH)  
            legend('Previous','New')
        end
        handles.nyquist_previous=KH;
        title('Nyquist diagram: Open loop (KH)') 
    case 3 %y/yc time, step output
        Bsyst=tf(handles.Bsyst,1,handles.Te);
        Asyst=tf(handles.Asyst,1,handles.Te);
        R=tf(handles.R,1,handles.Te);
        S=tf(handles.S,1,handles.Te);
        T=tf(handles.T,1,handles.Te);
        H=minreal(Bsyst*T/(Asyst*R+Bsyst*S));
        if handles.output_first_time==1
            handles.output_first_time=0;
            step(H,1)
        else
           step(handles.output_previous,H,1)  
           legend('Previous','New')
        end
        handles.output_previous=H;
        title('Output: Step response (Y/Yc)') 
    case 4 %u/yc time, command
        Bsyst=tf(handles.Bsyst,1,handles.Te);
        Asyst=tf(handles.Asyst,1,handles.Te);
        R=tf(handles.R,1,handles.Te);
        S=tf(handles.S,1,handles.Te);
        T=tf(handles.T,1,handles.Te);
        Hu=minreal(Asyst*T/(Asyst*R+Bsyst*S));
        if handles.command_first_time==1
            handles.command_first_time=0;
            step(Hu,1)
        else
           step(handles.command_previous,Hu,1)  
           legend('Previous','New')
        end
        handles.command_previous=Hu;
        title('Command: Step response (U/Yc)')
    case 5 %u/v freq measurement noise
        Bsyst=tf(handles.Bsyst,1,handles.Te);
        Asyst=tf(handles.Asyst,1,handles.Te);
        R=tf(handles.R,1,handles.Te);
        S=tf(handles.S,1,handles.Te);
        Hv=minreal(Asyst*S/(Asyst*R+Bsyst*S));
        if handles.noise_first_time==1
            handles.noise_first_time=0;
            bode(Hv)
        else
           bode(handles.noise_previous,Hv)  
           legend('Previous','New')
        end
        handles.noise_previous=Hv;
        title('Measurement noise (U/V)')
    case 6 %sensibility freq
        Bsyst=tf(handles.Bsyst,1,handles.Te);
        Asyst=tf(handles.Asyst,1,handles.Te);
        R=tf(handles.R,1,handles.Te);
        S=tf(handles.S,1,handles.Te);
        S=minreal(Asyst*R/(Asyst*R+Bsyst*S));
        if handles.sensibility_first_time==1
            handles.sensibility_first_time=0;
            bode(S)
        else
           bode(handles.sensibility_previous,S)  
           legend('Previous','New')
        end
        handles.sensibility_previous=S;
        title('Sensibility')
    case 7 %ramp y/yc time
        T_ramp=0:handles.Te:1;
        pente=1;
        U=0:pente*handles.Te:pente*1;
        U=U';
        Bsyst=tf(handles.Bsyst,1,handles.Te);
        Asyst=tf(handles.Asyst,1,handles.Te);
        R=tf(handles.R,1,handles.Te);
        S=tf(handles.S,1,handles.Te);
        T=tf(handles.T,1,handles.Te);
        H=minreal(Bsyst*T/(Asyst*R+Bsyst*S));
        if handles.ramp_first_time==1
            handles.ramp_first_time=0;
            lsim(H,U,T_ramp)
        else
           lsim(handles.ramp_previous,H,U,T_ramp)  
           legend('Previous','New')
        end
        handles.ramp_previous=H;
        title('Ramp response (y/yc)')
    case 8 % Closed loop KH/(1+KH) freq
        Bsyst=tf(handles.Bsyst,1,handles.Te);
        Asyst=tf(handles.Asyst,1,handles.Te);
        R=tf(handles.R,1,handles.Te);
        S=tf(handles.S,1,handles.Te);
        T=tf(handles.T,1,handles.Te);
        H=minreal(Bsyst*T/(Asyst*R+Bsyst*S));
        if handles.closed_loop_first_time==1
            handles.closed_loop_first_time=0;
            bode(H)
        else
           bode(handles.closed_loop_previous,H)  
           legend('Previous','New')
        end
        handles.closed_loop_previous=H;
        title('Bode diagram Closed loop: (KH/(1+KH)')
    case 9 %Bode open loop KH
        Bsyst=tf(handles.Bsyst,1,handles.Te);
        Asyst=tf(handles.Asyst,1,handles.Te);
        R=tf(handles.R,1,handles.Te);
        S=tf(handles.S,1,handles.Te);
        KH=minreal(S*Bsyst/(Asyst*R));
        if handles.bode_open_loop_first_time==1
            handles.bode_open_loop_first_time=0;
            bode(KH)
        else
            bode(handles.bode_open_loop_previous, KH)  
            legend('Previous','New')
        end
        handles.bode_open_loop_previous=KH;
        title('Bode diagram: Open loop (KH)') 
    case 10 %Bode diagram regulation H/(1+KH)
        Bsyst=tf(handles.Bsyst,1,handles.Te);
        Asyst=tf(handles.Asyst,1,handles.Te);
        R=tf(handles.R,1,handles.Te);
        S=tf(handles.S,1,handles.Te);
        S=minreal(Bsyst*R/(Asyst*R+Bsyst*S));
        if handles.regulation_first_time==1
            handles.regulation_first_time=0;
            bode(S)
        else
           bode(handles.regulation_previous,S)  
           legend('Previous','New')
        end
        handles.regulation_previous=S;
        title('Regulation (H/(1+KH)')
    otherwise ;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Outputs from this function are returned to the command line.
function varargout = RSTDesigner_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function edit_Absolute_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Absolute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_Relative_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Relative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.

function popupmenu_nbIntegrator_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_nbIntegrator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function popup_graphright_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_graphright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function textbox_A0_pole_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_A0_pole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function popup_graphleft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_graphleft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function textbox_Pa_pole_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_Pa_pole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function textbox_Pz_second_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_Pz_second (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.

function textbox_Az_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_Az (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function textbox_Bz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_Bz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function textbox_Pz_first_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_Pz_first (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit_Te_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Te (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function textbox_Pr_zeros_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_Pr_zeros (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function textbox_Ps_zeros_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textbox_Ps_zeros (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
