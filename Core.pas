unit Core;

interface

uses
  IDComponent,
  IDContext,
  IDGLobal,
  IDTCPServer,
  System.Classes,
  System.StrUtils,
  System.SysUtils,

  Base;

type
  THR_Core = class(TThread)
  private
    MS: Integer;
    Paused: Boolean;
  protected
    procedure Execute; override;
  public
    procedure Resume;
    procedure Pause;
    function IsPaused: Boolean;
end;

type
  TCP_Core = class(TIDTCPServer)
  private
    procedure Connect(AContext: TIDContext);
    procedure Execute(AContext: TIDContext);
    procedure Status(ASender: TObject; const AStatus: TIDStatus; const AStatusText: String);
    procedure Disconnect(AContext: TIDContext);
  protected
  public
    Mode: String;
    procedure Start;
end;

implementation

procedure THR_Core.Execute;
begin
  try
    Paused:= False;

    if GetParameterValue('/MS') <> '' then MS := GetParameterValue('/MS').ToInteger;
    if MS = 0 then MS:= 5000;

    try
      while not Terminated do
        begin
          if not Paused then
            begin
              Log('S: ' + '.');
            end;
          TThread.Sleep(MS);
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

procedure THR_Core.Resume;
begin
  Paused:= False;
end;

procedure THR_Core.Pause;
begin
  Paused:= True;
end;

function THR_Core.IsPaused: Boolean;
begin
  Result:= Paused;
end;

procedure TCP_Core.Start;
begin
  Self.Bindings.Clear;

  if FindCmdLineSwitch('GUI', ['/'], True) then
    Self.Bindings.Add.SetBinding('192.168.0.200', 36264, ID_IPV4)
  else
    Self.Bindings.Add.SetBinding('192.168.0.200', 36263, ID_IPV4);

  Self.OnConnect:= self.Connect;
  Self.OnExecute:= self.Execute;
  Self.OnStatus:= self.Status;
  Self.OnDisconnect:= self.Disconnect;

  try
    Self.Active:= True;
    Log('S: ' + '_');
  except
    on E: Exception do
    begin
      Log('E: ' + E.ClassName + ') ' + E.Message);
      Exit;
    end;
  end;
end;

procedure TCP_Core.Connect(AContext: TIDContext);
begin
  Log('C: ' + AContext.Binding.PeerIP);
  AContext.Connection.IOHandler.Write('Hi ' + AContext.Binding.PeerIP + '!');
end;

procedure TCP_Core.Execute(AContext: TIDContext);
var Bytes: TIDBytes;
var Bytes_String: String;
var Bytes_String_Reverse: String;
begin
  AContext.Connection.Socket.ReadBytes(Bytes, -1);
  Bytes_String := BytesToString(Bytes,IndyTextEncoding_UTF8);
  Log('R: ' + Bytes_String);
  Bytes_String_Reverse:= ReverseString(Bytes_String);
  AContext.Connection.IOHandler.Write(Bytes_String_Reverse);
  Log('T: ' + Bytes_String_Reverse);
end;

procedure TCP_Core.Status(ASender: TObject; const AStatus: TIDStatus; const AStatusText: String);
begin
  Log('S: ' + AStatusText);
end;

procedure TCP_Core.Disconnect(AContext: TIDContext);
begin
  Log('D: ' + AContext.Binding.PeerIP);
  AContext.Connection.IOHandler.Write('Bye ' + AContext.Binding.PeerIP + '!');
end;

end.

