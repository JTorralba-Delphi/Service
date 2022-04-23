program Service;

uses

  System.SysUtils,

  VCL.Forms,
  VCL.SvcMgr,

  Back in 'Back.pas',
  Core in 'Core.pas',
  Fore in 'Fore.pas',
  Base in 'Base.pas';

{$R *.RES}

begin

  if FindCmdLineSwitch('GUI', ['/'], True) then
    begin
      VCL.Forms.Application.Initialize;
      VCL.Forms.Application.MainFormOnTaskbar := True;
      VCL.Forms.Application.CreateForm(TFRM_Fore, FRM_Fore);
      VCL.Forms.Application.Run;
    end
  else
    begin
      if not VCL.SvcMgr.Application.DelayInitialize or VCL.SvcMgr.Application.Installing then VCL.SvcMgr.Application.Initialize;
      VCL.SvcMgr.Application.CreateForm(TFRM_Back, FRM_Back);
      VCL.SvcMgr.Application.Run;
    end;

  Parameters;

end.
