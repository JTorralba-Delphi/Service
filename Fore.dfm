object FRM_Fore: TFRM_Fore
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'FRM_Fore'
  ClientHeight = 179
  ClientWidth = 302
  Color = clBtnFace
  Constraints.MaxHeight = 218
  Constraints.MaxWidth = 318
  Constraints.MinHeight = 218
  Constraints.MinWidth = 318
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = BTN_StartClick
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object BTN_Start: TButton
    Left = 24
    Top = 24
    Width = 121
    Height = 49
    Caption = 'Start'
    TabOrder = 0
    OnClick = BTN_StartClick
  end
  object BTN_Stop: TButton
    Left = 151
    Top = 24
    Width = 121
    Height = 49
    Caption = 'Stop'
    TabOrder = 1
    OnClick = BTN_StopClick
  end
  object BTN_Pause: TButton
    Left = 24
    Top = 104
    Width = 121
    Height = 49
    Caption = 'Pause'
    TabOrder = 2
    OnClick = BTN_PauseClick
  end
  object BTN_Resume: TButton
    Left = 151
    Top = 104
    Width = 121
    Height = 49
    Caption = 'Resume'
    TabOrder = 3
    OnClick = BTN_ResumeClick
  end
  object ApplicationEvents: TApplicationEvents
    OnIdle = ApplicationEventsIdle
    Left = 136
    Top = 72
  end
end
