unit Task;

interface

uses
  System.Classes,
  System.IOUtils,
  System.SysUtils;

type
  TThread_ = class(TThread)
  private
  protected
    procedure Execute; override;
  public
  end;

implementation

procedure TThread_.Execute;
var
  File_Path: string;
  File_Name: string;
  File_Node: TStreamWriter;
begin
  try
    File_Path:= TPath.GetDirectoryName(getmodulename(hinstance));
    File_Name:= TPath.Combine(File_Path, ExtractFileName(ParamStr(0)) + '.log');
    File_Node:= TStreamWriter.Create(TFileStream.Create(File_Name, fmCreate or fmShareDenyWrite));
    try
      while not terminated do
      begin
        File_Node.WriteLine(formatdatetime('yyyy-mm-dd hh:nn:ss.zzz', now));
        TThread.Sleep(1000);
      end;
    finally
      File_Node.Free;
    end;
  except
    on E: exception do
    begin
      TFile.WriteAllText(TPath.Combine(File_Path, ExtractFileName(ParamStr(0)) + '.dbg'), E.ClassName + ' ' + E.Message);
    end;
  end;
end;

end.
