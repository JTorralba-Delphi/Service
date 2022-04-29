unit Back;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Win.Registry,

  WinAPI.Windows,

  VCL.SvcMgr,

  Core;

type
  TDelphi = class(TService)
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
    ImagePath: String;
    function GetServiceController: TServiceController; override;
end;

{$R *.dfm}

var
  Delphi: TDelphi;

implementation

procedure ServiceController(CtrlCode: DWord); StdCall;
begin
  Delphi.Controller(CtrlCode);
end;

function TDelphi.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TDelphi.Service_AfterInstall(Sender: TService);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create(KEY_READ or KEY_WRITE);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\SYSTEM\CurrentControlSet\Services\' + Name, False) then
      begin
        Reg.WriteString('Description', Delphi.Name);
        Reg.WriteExpandString('ImagePath', ImagePath);
        Reg.CloseKey;
      end;
  finally
    Reg.Free;
  end;
  WinExec('CMD.exe /c net start Delphi', SW_Hide);
end;

procedure TDelphi.Service_BeforeUninstall(Sender: TService);
begin
  WinExec('CMD.exe /c net stop Delphi', SW_Hide);
end;

procedure TDelphi.Service_Execute(Sender: TService);
begin
  while not Terminated do
    begin
      ServiceThread.ProcessRequests(False);
      TThread.Sleep(1000);
    end;
end;

procedure TDelphi.Service_Start(Sender: TService; var Started: Boolean);
begin
  THR_Back := THR_Core.Create(True);
  THR_Back.Start;
  Started := True;
end;

procedure TDelphi.Service_Stop(Sender: TService; var Stopped: Boolean);
begin
  THR_Back.Terminate;
  THR_Back.WaitFor;
  FreeAndNil(THR_Back);
  Stopped := True;
end;

procedure TDelphi.Service_Pause(Sender: TService; var Paused: Boolean);
begin
  THR_Back.Pause;
  Paused := True;
end;

procedure TDelphi.Service_Resume(Sender: TService; var Resumed: Boolean);
begin
  THR_Back.Resume;
  Resumed := True;
end;

end.

