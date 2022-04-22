program Service;

uses
  System.Classes,
  System.IOUtils,
  System.SysUtils,

  VCL.Forms,
  VCL.SvcMgr,

  Back in 'Back.pas',
  Core in 'Core.pas',
  Fore in 'Fore.pas';

{$R *.RES}

var
  File_Path: string;
  File_Name: string;
  File_Node: TStreamWriter;

  I: integer;

begin

  if FindCmdLineSwitch('GUI', ['/'], true) then
    begin
      VCL.Forms.Application.Initialize;
      VCL.Forms.Application.MainFormOnTaskbar := True;
      VCL.Forms.Application.CreateForm(TFRM_Fore, FRM_Fore);
      VCL.Forms.Application.Run;
    end
  else
    begin
      if not VCL.SvcMgr.Application.DelayInitialize or VCL.SvcMgr.Application.Installing then
        VCL.SvcMgr.Application.Initialize;
      VCL.SvcMgr.Application.CreateForm(TFRM_Back, FRM_Back);
      VCL.SvcMgr.Application.Run;
    end;

  try
    File_Path := TPath.GetDirectoryName(GetModuleName(HInstance));
    File_Name := TPath.Combine(File_Path, 'Parameters.dbg');
    File_Node := TStreamWriter.Create(TFileStream.Create(File_Name, fmCreate or fmShareDenyWrite));
    try
      for I := 0 to ParamCount do
        begin
          if I <> 0 then
            begin
              File_Node.WriteLine(UpperCase(ParamStr(I)));
            end;
        end;
    finally
      File_Node.Free;
    end;
    except
      on E: Exception do
        begin
          File_Node.Close;
          TFile.WriteAllText(TPath.Combine(File_Path, 'Parameters.err'), E.ClassName + ' ' + E.Message);
        end
  end;

end.

