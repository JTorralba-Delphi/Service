program Service;

uses
  Ctrl in 'Ctrl.pas',
  Task in 'Task.pas',
  VCL.SvcMgr;

{$R *.RES}

begin
  if not Application.DelayInitialize or Application.Installing then
    Application.Initialize;
  Application.CreateForm(TDelphi_Service, Delphi_Service);
  Application.Run;
end.
