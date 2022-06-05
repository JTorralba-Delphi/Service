unit Back;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Win.Registry,
  VCL.SvcMgr,
  WinAPI.Windows,

  Core;

type
  TDelphi = class(TService)
    procedure Service_AfterInstall(Sender: TService);
    procedure Service_Execute(Sender: TService);
    procedure Service_Start(Sender: TService; var Started: Boolean);
    procedure Service_Stop(Sender: TService; var Stopped: Boolean);
    procedure Service_Pause(Sender: TService; var Paused: Boolean);
    procedure Service_Resume(Sender: TService; var Resumed: Boolean);
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
  Result:= ServiceController;
end;

procedure TDelphi.Service_AfterInstall(Sender: TService);
var
  Registry: TRegistry;
  CMD: ANSIString;
begin
  Registry:= TRegistry.Create(KEY_READ or KEY_WRITE);
  try
    Registry.RootKey:= HKEY_LOCAL_MACHINE;
    if Registry.OpenKey('\SYSTEM\CurrentControlSet\Services\' + Name, False) then
      begin
        Registry.WriteString('Description', Delphi.Name);
        Registry.WriteExpandString('ImagePath', ImagePath);
        Registry.CloseKey;
      end;
  finally
    Registry.Free;
  end;
  CMD:= 'CMD.exe /c net start ' + Delphi.Name;
  WinExec(@CMD[1], SW_Hide);
end;

procedure TDelphi.Service_BeforeUninstall(Sender: TService);
var
  CMD: ANSIString;
begin
  CMD :=  'CMD.exe /c net stop ' + Delphi.Name;
  WinExec(@CMD[1], SW_Hide);
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
  THR_Back:= THR_Core.Create(True);
  THR_Back.Start;
  Started:= True;
end;

procedure TDelphi.Service_Stop(Sender: TService; var Stopped: Boolean);
begin
  THR_Back.Terminate;
  THR_Back.WaitFor;
  FreeAndNil(THR_Back);
  Stopped:= True;
end;

procedure TDelphi.Service_Pause(Sender: TService; var Paused: Boolean);
begin
  THR_Back.Pause;
  Paused:= True;
end;

procedure TDelphi.Service_Resume(Sender: TService; var Resumed: Boolean);
begin
  THR_Back.Resume;
  Resumed:= True;
end;

end.

