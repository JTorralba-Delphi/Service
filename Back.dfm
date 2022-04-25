object Delphi: TDelphi
  OldCreateOrder = False
  DisplayName = 'Delphi'
  AfterInstall = Service_AfterInstall
  BeforeUninstall = Service_BeforeUninstall
  OnContinue = Service_Resume
  OnExecute = Service_Execute
  OnPause = Service_Pause
  OnStart = Service_Start
  OnStop = Service_Stop
  Height = 155
  Width = 241
end
