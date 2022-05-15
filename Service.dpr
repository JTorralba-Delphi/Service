program Service;

uses

  System.SysUtils,

  VCL.Forms,
  VCL.SvcMgr,

  Back in 'Back.pas',
  Base in 'Base.pas',
  Core in 'Core.pas',
  Fore in 'Fore.pas';

{$R *.RES}

begin
  if FindCmdLineSwitch('GUI', ['/'], True) then
    begin
      VCL.Forms.Application.Initialize;
      VCL.Forms.Application.MainFormOnTaskbar := True;
      VCL.Forms.Application.CreateForm(TDelphi_GUI, Delphi_GUI);
      VCL.Forms.Application.Run;
    end
  else if FindCmdLineSwitch('INSTALL', ['/'], True) or FindCmdLineSwitch('UNINSTALL', ['/'], True) then
    begin
      if not VCL.SvcMgr.Application.DelayInitialize or VCL.SvcMgr.Application.Installing then VCL.SvcMgr.Application.Initialize;
      VCL.SvcMgr.Application.CreateForm(TDelphi, Delphi);
      Delphi.ImagePath := GetImagePath;
      VCL.SvcMgr.Application.Run;
    end
    else
    begin
      Log('Service', 'Invalid argument(s).');
    end;
end.

