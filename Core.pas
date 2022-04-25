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
    try
      while not Terminated do
        begin
          if not Paused then
            begin
              Log('Core', FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now));
            end;
          TThread.Sleep(1000);
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

