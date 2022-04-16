unit Core;

interface

uses
  System.Classes,
  System.ioutils,
  System.SysUtils;

type
  THR_Core = class(TThread)
  private
    Paused: Boolean;
  protected
    procedure Execute; override;
  public
    procedure Pause;
    procedure Resume;
    function IsPaused: Boolean;
end;

implementation

procedure THR_Core.Execute;
var
  File_Path: string;
  File_Name: string;
  File_Node: TStreamWriter;
begin
  try
    Paused := False;

    File_Path := TPath.GetDirectoryName(GetModuleName(HInstance));
//  File_Name := TPath.Combine(File_Path, ClassName + '_' + IntToStr(CurrentThread.ThreadID) + '.log');
    File_Name := TPath.Combine(File_Path, 'Core_' + IntToStr(CurrentThread.ThreadID) + '.log');
    File_Node := TStreamWriter.Create(TFileStream.Create(File_Name, fmCreate or fmShareDenyWrite));

    try
      while not Terminated do
        begin
          if not Paused then
            begin
              File_Node.WriteLine(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', now));
            end;
          TThread.Sleep(1000);
        end;
    finally
      File_Node.Free;
    end;

    except
      on E: Exception do
        begin
//        TFile.WriteAllText(TPath.Combine(File_Path, ExtractFileName(ParamStr(0)) + '.dbg'), E.ClassName + ' ' + E.Message);
          TFile.WriteAllText(TPath.Combine(File_Path, 'Core.dbg'), E.Message);
        end
  end;
end;

procedure THR_Core.Pause;
begin
  Paused := True;
end;

procedure THR_Core.Resume;
begin
  Paused := False;
end;

function THR_Core.IsPaused: Boolean;
begin
  Result := Paused;
end;

end.

