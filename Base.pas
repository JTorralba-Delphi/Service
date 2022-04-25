unit Base;

interface
  procedure Log(Node: String; Text: String);
  procedure Parameters;

implementation

uses
  System.Classes,
  System.IOUtils,
  System.SysUtils;

procedure Log(Node: String; Text: String);
var
  FilePath: String;
  FileName: String;
  FileNode: TStreamWriter;
begin
  FilePath := TPath.GetDirectoryName(GetModuleName(HInstance));
  FileName := TPath.Combine(FilePath, Node + '.log');
  FileNode := TStreamWriter.Create(FileName, True, TEncoding.UTF8);
  try
    try
      FileNode.WriteLine(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + ' ' + Text);
    finally
      FileNode.Free;
    end;
    except
      on E: Exception do
        begin
          Log('Exception', E.ClassName + ' ' + E.Message);
        end
  end;
end;

procedure Parameters;
var
  I: Integer;
begin
  try
    try
      for I := 0 to ParamCount do
        begin
              Log('Parameters', UpperCase(ParamStr(I)));
        end;
    finally
    end;
    except
      on E: Exception do
        begin
          Log('Exception', E.ClassName + ' ' + E.Message);
        end
  end;
end;

end.

