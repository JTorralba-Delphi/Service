object Sample: TSample
  OldCreateOrder = False
  DisplayName = 'Sample'
  AfterInstall = Service_AfterInstall
  OnContinue = Service_Resume
  OnExecute = Service_Execute
  OnPause = Service_Pause
  OnStart = Service_Start
  OnStop = Service_Stop
  Height = 155
  Width = 241
end
