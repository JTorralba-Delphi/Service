unit Base;

interface
  procedure Log(Node: String; Text: String);
  procedure GetParameters();
  function GetParameterValue(Parameter: String): String;
  function GetImagePath(): String;

implementation

uses
  System.Classes,
  System.IOUtils,
  System.SysUtils,

  IDStrings;

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
          Log('Exception_Log', E.ClassName + ' ' + E.Message);
        end
  end;
end;

procedure GetParameters();
var
  I: Integer;
begin
  try
    try
      for I := 0 to ParamCount do
        begin
          Log('GetParameters', I.ToString + ' ' + UpperCase(ParamStr(I)));
        end;
    finally
    end;
    except
      on E: Exception do
        begin
          Log('Exception_GetParameters', E.ClassName + ' ' + E.Message);
        end
  end;
end;

function GetParameterValue(Parameter: String): String;
var
  I: Integer;
  Key: String;
  Value: String;
begin
  try
    try
      for I := 0 to ParamCount do
        begin
          IDStrings.SplitString(UpperCase(ParamStr(I)), '=', Key, Value);
          if Parameter = Key then Result := Value;
        end;
    finally
    end;
    except
      on E: Exception do
        begin
          Log('Exception_GetParameterValue', E.ClassName + ' ' + E.Message);
        end
  end;
end;

function GetImagePath(): String;
var
  I: Integer;
  ImagePath: String;
begin
  try
    try
      for I := 0 to ParamCount do
        begin
          if (UpperCase(ParamStr(I)) <> '/GUI') and (UpperCase(ParamStr(I)) <> '/INSTALL') and (UpperCase(ParamStr(I)) <> '/S') and (UpperCase(ParamStr(I)) <> '/UNINSTALL') then
            ImagePath := Trim(ImagePath + ' ' + ParamStr(I));
        end;
    finally
    end;
    except
      on E: Exception do
        begin
          Log('Exception_GetImagePath', E.ClassName + ' ' + E.Message);
        end
  end;
  Result := ImagePath;
end;

end.

