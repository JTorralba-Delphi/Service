unit Back;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Win.Registry,

  WinAPI.Messages,
  WinAPI.Windows,

  VCL.Controls,
  VCL.Dialogs,
  VCL.Graphics,
  VCL.SvcMgr,

  Core;

type
  TFRM_Back = class(TService)
    procedure Service_Execute(Sender: TService);
    procedure Service_Start(Sender: TService; var Started: Boolean);
    procedure Service_Stop(Sender: TService; var Stopped: Boolean);
    procedure Service_Pause(Sender: TService; var Paused: Boolean);
    procedure Service_Resume(Sender: TService; var Resumed: Boolean);
    procedure Service_AfterInstall(Sender: TService);
    procedure Service_BeforeUninstall(Sender: TService);
  private
    THR_Back: THR_Core;
  public
    function GetServiceController: TServiceController; override;
end;

{$R *.dfm}

var
  FRM_Back: TFRM_Back;

implementation

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  FRM_Back.Controller(CtrlCode);
end;

function TFRM_Back.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TFRM_Back.Service_AfterInstall(Sender: TService);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_READ or KEY_WRITE);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\SYSTEM\CurrentControlSet\Services\' + Name, false) then
      begin
        Reg.WriteString('Description', 'FRM_Back');
        Reg.CloseKey;
      end;
  finally
    Reg.Free;
  end;
  WinExec('CMD.exe /c net start FRM_Back',sw_hide);
end;

procedure TFRM_Back.Service_BeforeUninstall(Sender: TService);
begin
  WinExec('CMD.exe /c net stop FRM_Back',sw_hide);
end;

procedure TFRM_Back.Service_Execute(Sender: TService);
begin
  while not Terminated do
    begin
      ServiceThread.ProcessRequests(False);
      TThread.Sleep(1000);
    end;
end;

procedure TFRM_Back.Service_Start(Sender: TService; var Started: Boolean);
begin
  THR_Back := THR_Core.Create(True);
  THR_Back.Start;
  Started := True;
end;

procedure TFRM_Back.Service_Stop(Sender: TService; var Stopped: Boolean);
begin
  THR_Back.Terminate;
  THR_Back.WaitFor;
  FreeAndNil(THR_Back);
  Stopped := True;
end;

procedure TFRM_Back.Service_Pause(Sender: TService; var Paused: Boolean);
begin
  THR_Back.Pause;
  Paused := True;
end;

procedure TFRM_Back.Service_Resume(Sender: TService; var Resumed: Boolean);
begin
  THR_Back.Resume;
  Resumed := True;
end;

end.

