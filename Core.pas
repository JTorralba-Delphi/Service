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
    Paused: Boolean;
    MS: Integer;
  protected
    procedure Execute; override;
  public
    Mode: String;
    procedure Pause;
    procedure Resume;
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
  LogParameters();
  try
    Paused:= False;

    if GetParameterValue('/MS') <> '' then MS := GetParameterValue('/MS').ToInteger;
    if MS = 0 then MS:= 5000;

    try
      while not Terminated do
        begin
          if not Paused then
            begin
              Log(Mode, '.:');
            end;
          TThread.Sleep(MS);
        end;
    finally
    end;
    except
      on E: Exception do
        begin
          Log('Exception_THR_' + Mode, E.ClassName + ' ' + E.Message);
        end
  end;
end;

procedure THR_Core.Pause;
begin
  Paused:= True;
end;

procedure THR_Core.Resume;
begin
  Paused:= False;
end;

function THR_Core.IsPaused: Boolean;
begin
  Result:= Paused;
end;

procedure TCP_Core.Start;
begin
  Self.Bindings.Clear;

  if Mode = 'Core' then
    Self.Bindings.Add.SetBinding('192.168.0.200', 36263, ID_IPV4)
  else
    Self.Bindings.Add.SetBinding('192.168.0.200', 36264, ID_IPV4);

  Self.OnConnect:= self.Connect;
  Self.OnDisconnect:= self.Disconnect;
  Self.OnExecute:= self.Execute;
  Self.OnStatus:= self.Status;

  try
    Self.Active:= True;
  except
    on E: Exception do
    begin
      Log('Exception_TCP_' + Mode, FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + ' Exception: (' + E.ClassName + ') ' + E.Message);
      Exit;
    end;
  end;

  Log(Mode, '_:');
end;

procedure TCP_Core.Connect(AContext: TIDContext);
begin
  Log(Mode, 'C: ' + AContext.Binding.PeerIP);
  AContext.Connection.IOHandler.Write('Hi ' + AContext.Binding.PeerIP + '!');
end;

procedure TCP_Core.Disconnect(AContext: TIDContext);
begin
  Log(Mode, 'D: ' + AContext.Binding.PeerIP);
  AContext.Connection.IOHandler.Write('Bye ' + AContext.Binding.PeerIP + '!');
end;

procedure TCP_Core.Execute(AContext: TIDContext);
var Bytes: TIDBytes;
var Bytes_String: String;
var Bytes_String_Reverse: String;
begin
  AContext.Connection.Socket.ReadBytes(Bytes, -1);
  Bytes_String := BytesToString(Bytes,IndyTextEncoding_UTF8);
  Log(Mode, 'R: ' + Bytes_String);
  Bytes_String_Reverse:= ReverseString(Bytes_String);
  AContext.Connection.IOHandler.Write(Bytes_String_Reverse);
  Log(Mode, 'T: ' + Bytes_String_Reverse);
end;

procedure TCP_Core.Status(ASender: TObject; const AStatus: TIDStatus; const AStatusText: String);
begin
  Log(Mode, 'S: ' + AStatusText);
end;

end.

