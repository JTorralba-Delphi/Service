unit Fore;

interface

uses
  System.Classes,
  System.SysUtils,
  VCL.AppEvnts,
  VCL.Controls,
  VCL.Forms,
  VCL.StdCtrls,

  Core;

type
  TDelphi_GUI = class(TForm)
    ApplicationEvents: TApplicationEvents;
    BTN_Start: TButton;
    BTN_Resume: TButton;
    BTN_Pause: TButton;
    BTN_Stop: TButton;
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure BTN_StartClick(Sender: TObject);
    procedure BTN_ResumeClick(Sender: TObject);
    procedure BTN_PauseClick(Sender: TObject);
    procedure BTN_StopClick(Sender: TObject);
  private
    THR_Fore: THR_Core;
    TCP_Fore: TCP_Core;
  public
    Mode: String;
end;

{$R *.dfm}

var
  Delphi_GUI: TDelphi_GUI;

implementation

procedure TDelphi_GUI.ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
begin
  BTN_Start.Enabled:= not Assigned(THR_Fore);
  BTN_Resume.Enabled:= Assigned(THR_Fore) and THR_Fore.IsPaused;
  BTN_Pause.Enabled:= Assigned(THR_Fore) and (not THR_Fore.IsPaused);
  BTN_Stop.Enabled:= Assigned(THR_Fore);
 end;

procedure TDelphi_GUI.FormDestroy(Sender: TObject);
begin
  if Assigned(THR_Fore) then
    begin
      THR_Fore.Terminate;
      THR_Fore.WaitFor;
      FreeAndNil(THR_Fore);
      TCP_Fore.Destroy;
    end;
end;

procedure TDelphi_GUI.BTN_StartClick(Sender: TObject);
begin
  THR_Fore:= THR_Core.Create(True);
  THR_Fore.Mode:= 'GUI';
  THR_Fore.Start;
  TCP_Fore:= TCP_Core.Create(self);
  TCP_Fore.Mode:= 'GUI';
  TCP_Fore.Start;
end;

procedure TDelphi_GUI.BTN_ResumeClick(Sender: TObject);
begin
  THR_Fore.Resume;
  TCP_Fore.Active:= True;
end;

procedure TDelphi_GUI.BTN_PauseClick(Sender: TObject);
begin
  THR_Fore.Pause;
  TCP_Fore.Active:= False;
end;

procedure TDelphi_GUI.BTN_StopClick(Sender: TObject);
begin
  BTN_Pause.Enabled:= False;
  BTN_Resume.Enabled:= False;
  THR_Fore.Terminate;
  THR_Fore.WaitFor;
  FreeAndNil(THR_Fore);
  TCP_Fore.Destroy;
end;

end.

