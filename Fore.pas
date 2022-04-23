unit Fore;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Variants,

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
  TFRM_Fore = class(TForm)
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
  FRM_Fore: TFRM_Fore;

implementation

procedure TFRM_Fore.ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
begin
  BTN_Start.Enabled := not Assigned(THR_Fore);
  BTN_Stop.Enabled := Assigned(THR_Fore);
  BTN_Pause.Enabled := Assigned(THR_Fore) and (not THR_Fore.IsPaused);
  BTN_Resume.Enabled := Assigned(THR_Fore) and THR_Fore.IsPaused;
end;

procedure TFRM_Fore.FormDestroy(Sender: TObject);
begin
  if Assigned(THR_Fore) then
    begin
      THR_Fore.Terminate;
      THR_Fore.WaitFor;
      FreeAndNil(THR_Fore);
    end;
end;

procedure TFRM_Fore.BTN_StartClick(Sender: TObject);
begin
  THR_Fore := THR_Core.Create(True);
  THR_Fore.Start;
end;

procedure TFRM_Fore.BTN_StopClick(Sender: TObject);
begin
  BTN_Pause.Enabled := False;
  BTN_Resume.Enabled := False;
  THR_Fore.Terminate;
  THR_Fore.WaitFor;
  FreeAndNil(THR_Fore);
end;

procedure TFRM_Fore.BTN_PauseClick(Sender: TObject);
begin
  THR_Fore.Pause;
end;

procedure TFRM_Fore.BTN_ResumeClick(Sender: TObject);
begin
  THR_Fore.Resume;
end;

end.

