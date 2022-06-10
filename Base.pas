unit Base;

interface
  procedure Log(Data: ANSIString);
  procedure LogParameters();
  function GetImagePath(): String;
  function GetParameterValue(Parameter: String): String;
  function Tick(): String;

implementation

uses
  IDStrings,
  System.Classes,
  System.IOUtils,
  System.SysUtils;

procedure Log(Data: ANSIString);
var
  FilePath: String;
  FileName: String;
  FileNode: TStreamWriter;
begin
  FilePath:= TPath.GetDirectoryName(GetModuleName(HInstance));
  FileName:= TPath.Combine(FilePath, 'DEBUG' + '.log');
  FileNode:= TStreamWriter.Create(FileName, True, TEncoding.UTF8);
  try
    try
      FileNode.WriteLine(Tick() + ' ' + Data);
    finally
      FileNode.Free;
    end;
    except
      on E: Exception do
        begin
          Log('E: ' + E.ClassName + ' ' + E.Message);
        end
  end;
end;

procedure LogParameters();
var
  I: Integer;
begin
  try
    try
      Log(StringReplace(UpperCase(CMDLine), '  ', ' ', [RFReplaceAll, RFIgnoreCase]));
      for I:= 0 to ParamCount do
        begin
          Log('S: ' + I.ToString + ' ' + UpperCase(ParamStr(I)));
        end;
    finally
    end;
    except
      on E: Exception do
        begin
          Log('E: ' + E.ClassName + ' ' + E.Message);
        end
  end;
end;

function GetImagePath(): String;
var
  ImagePath: String;
  I: Integer;
begin
  try
    try
      for I:= 0 to ParamCount do
        begin
          if (UpperCase(ParamStr(I)) <> '/GUI') and (UpperCase(ParamStr(I)) <> '/INSTALL') and (UpperCase(ParamStr(I)) <> '/S') and (UpperCase(ParamStr(I)) <> '/UNINSTALL') then
            ImagePath:= Trim(ImagePath + ' ' + ParamStr(I));
        end;
    finally
    end;
    except
      on E: Exception do
        begin
          Log('E: ' + E.ClassName + ' ' + E.Message);
        end
  end;
  Result:= ImagePath;
end;

function GetParameterValue(Parameter: String): String;
var
  I: Integer;
  Key: String;
  Value: String;
begin
  try
    try
      for I:= 0 to ParamCount do
        begin
          IDStrings.SplitString(UpperCase(ParamStr(I)), '=', Key, Value);
          if Parameter = Key then Result:= Value;
        end;
    finally
    end;
    except
      on E: Exception do
        begin
          Log('E: ' + E.ClassName + ' ' + E.Message);
        end
  end;
end;

function Tick(): String;
begin
  Result:= FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now);
end;

end.

