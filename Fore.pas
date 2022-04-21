unit Fore;

interface

uses

  System.Classes,
  System.IOUtils,
  System.SysUtils,
  System.Variants,

  WinAPI.Messages,
  WinAPI.Windows,

  VCL.AppEvnts,
  VCL.Controls,
  VCL.Dialogs,
  VCL.Forms,
  VCL.Graphics,
  VCL.StdCtrls,

  Core;

type
  TFRM_Fore = class(TForm)
    ApplicationEvents: TApplicationEvents;
    BTN_Start: TButton;
    BTN_Stop: TButton;
    BTN_Pause: TButton;
    BTN_Resume: TButton;
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure BTN_StartClick(Sender: TObject);
    procedure BTN_StopClick(Sender: TObject);
    procedure BTN_PauseClick(Sender: TObject);
    procedure BTN_ResumeClick(Sender: TObject);
    procedure ShowParameter;
  private
    THR_Fore: THR_Core;
  public
end;

{$R *.dfm}

var
  FRM_Fore: TFRM_Fore;

implementation

procedure TFRM_Fore.ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
begin
  BTN_Start.Enabled := not Assigned(THR_Fore);
  BTN_Stop.Enabled := Assigned(THR_Fore);
  BTN_Pause.Enabled := Assigned(THR_Fore) and (not THR_Fore.IsPaused);
  BTN_Resume.Enabled := Assigned(THR_Fore) and THR_Fore.IsPaused;
end;

procedure TFRM_Fore.FormDestroy(Sender: TObject);
begin
  if Assigned(THR_Fore) then
    begin
      THR_Fore.Terminate;
      THR_Fore.WaitFor;
      FreeAndNil(THR_Fore);
    end;
end;

procedure TFRM_Fore.BTN_StartClick(Sender: TObject);
begin
  ShowParameter;
  THR_Fore := THR_Core.Create(True);
  THR_Fore.Start;
end;

procedure TFRM_Fore.BTN_StopClick(Sender: TObject);
begin
  THR_Fore.Terminate;
  THR_Fore.WaitFor;
  FreeAndNil(THR_Fore);
end;

procedure TFRM_Fore.BTN_PauseClick(Sender: TObject);
begin
  THR_Fore.Pause;
end;

procedure TFRM_Fore.BTN_ResumeClick(Sender: TObject);
begin
  THR_Fore.Resume;
end;

procedure TFRM_Fore.ShowParameter;
var
  File_Path: string;
  File_Name: string;
  File_Node: TStreamWriter;

  I: integer;

begin
  try
    File_Path := TPath.GetDirectoryName(GetModuleName(HInstance));
    File_Name := TPath.Combine(File_Path, 'Service' + '.dbg');
    File_Node := TStreamWriter.Create(TFileStream.Create(File_Name, fmCreate or fmShareDenyWrite));
    try
      for I := 0 to ParamCount do
        begin
          if I <> 0 then
            begin
              File_Node.WriteLine(ParamStr(I));
            end;
        end;
    finally
      File_Node.Free;
    end;

    except
      on E: Exception do
        begin
          TFile.WriteAllText(TPath.Combine(File_Path, ExtractFileName(ParamStr(0)) + '.err'), E.ClassName + ' ' + E.Message);
        end
  end;
end;

end.

