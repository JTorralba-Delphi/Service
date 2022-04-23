unit Base;

interface
  procedure Parameters;

implementation

uses

  System.Classes,
  System.IOUtils,
  System.SysUtils;

procedure Parameters;
var
  File_Path: String;
  File_Name: String;
  File_Node: TStreamWriter;
  I: Integer;
begin
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
end;

end.
