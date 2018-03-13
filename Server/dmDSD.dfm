object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 262
  Width = 253
  object HTTPServer: TIdHTTPServer
    Bindings = <>
    DefaultPort = 7001
    OnException = HTTPServerException
    UseNagle = False
    OnCommandOther = HTTPServerCommandGet
    OnCommandGet = HTTPServerCommandGet
    Left = 24
    Top = 16
  end
  object Timer: TTimer
    Enabled = False
    Interval = 5000
    Left = 24
    Top = 64
  end
end
