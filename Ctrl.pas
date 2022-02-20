unit Ctrl;

interface

uses
  System.SysUtils,
  Task,
  VCL.SvcMgr,
  WinAPI.Windows;

type
  TDelphi_Service = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    Task: TThread_;
  public
    function GetServiceController: TServiceController; override;
  end;

var
  Delphi_Service: TDelphi_Service;

implementation

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  Delphi_Service.Controller(CtrlCode);
end;

function TDelphi_Service.GetServiceController: TServiceController;
begin
  Result:= ServiceController;
end;

procedure TDelphi_Service.ServiceStart(Sender: TService; var Started: Boolean);
begin
  Task:= TThread_.Create(true);
  Task.Start;
end;

procedure TDelphi_Service.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  Task.Terminate;
  Task.WaitFor;
  FreeAndNil(Task);
end;

end.
