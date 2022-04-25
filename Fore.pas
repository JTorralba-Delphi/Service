unit Fore;

interface

uses
  System.Classes,
  System.SysUtils,

  WinAPI.Messages,
  WinAPI.Windows,

  VCL.AppEvnts,
  VCL.Controls,
  VCL.Dialogs,
  VCL.Forms,
  VCL.Graphics,
  VCL.StdCtrls,

  Core;

type
  TDelphi_GUI = class(TForm)
    ApplicationEvents: TApplicationEvents;
    BTN_Start: TButton;
    BTN_Stop: TButton;
    BTN_Pause: TButton;
    BTN_Resume: TButton;
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure BTN_StartClick(Sender: TObject);
    procedure BTN_StopClick(Sender: TObject);
    procedure BTN_PauseClick(Sender: TObject);
    procedure BTN_ResumeClick(Sender: TObject);
  private
    THR_Fore: THR_Core;
  public
end;

{$R *.dfm}

var
  Delphi_GUI: TDelphi_GUI;

implementation

procedure TDelphi_GUI.ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
begin
  BTN_Start.Enabled := not Assigned(THR_Fore);
  BTN_Stop.Enabled := Assigned(THR_Fore);
  BTN_Pause.Enabled := Assigned(THR_Fore) and (not THR_Fore.IsPaused);
  BTN_Resume.Enabled := Assigned(THR_Fore) and THR_Fore.IsPaused;
end;

procedure TDelphi_GUI.FormDestroy(Sender: TObject);
begin
  if Assigned(THR_Fore) then
    begin
      THR_Fore.Terminate;
      THR_Fore.WaitFor;
      FreeAndNil(THR_Fore);
    end;
end;

procedure TDelphi_GUI.BTN_StartClick(Sender: TObject);
begin
  THR_Fore := THR_Core.Create(True);
  THR_Fore.Start;
end;

procedure TDelphi_GUI.BTN_StopClick(Sender: TObject);
begin
  BTN_Pause.Enabled := False;
  BTN_Resume.Enabled := False;
  THR_Fore.Terminate;
  THR_Fore.WaitFor;
  FreeAndNil(THR_Fore);
end;

procedure TDelphi_GUI.BTN_PauseClick(Sender: TObject);
begin
  THR_Fore.Pause;
end;

procedure TDelphi_GUI.BTN_ResumeClick(Sender: TObject);
begin
  THR_Fore.Resume;
end;

end.

