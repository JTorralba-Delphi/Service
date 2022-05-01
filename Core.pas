unit Core;

interface

uses
  System.Classes,
  System.SysUtils,

  Base;

type
  THR_Core = class(TThread)
  private
    Paused: Boolean;
    MS: Integer;
  protected
    procedure Execute; override;
  public
    procedure Pause;
    procedure Resume;
    function IsPaused: Boolean;
end;

implementation

procedure THR_Core.Execute;
begin
  try
    Paused := False;

    if GetParameterValue('/MS') <> '' then MS := GetParameterValue('/MS').ToInteger;
    if MS = 0 then MS := 1000;

    try
      while not Terminated do
        begin
          if not Paused then
            begin
              Log('Core', FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now));
            end;
          TThread.Sleep(MS);
        end;
    finally
    end;
    except
      on E: Exception do
        begin
          Log('Exception_Core', E.ClassName + ' ' + E.Message);
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

