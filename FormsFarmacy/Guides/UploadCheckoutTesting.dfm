object UploadCheckoutTestingForm: TUploadCheckoutTestingForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1054#1090#1087#1088#1072#1074#1082#1072' '#1092#1072#1081#1083#1086#1074' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1080' '#1089#1077#1088#1074#1080#1089#1072
  ClientHeight = 120
  ClientWidth = 430
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object edMsgDescription: TEdit
    Left = 16
    Top = 16
    Width = 393
    Height = 21
    TabStop = False
    BevelInner = bvNone
    BevelOuter = bvNone
    BiDiMode = bdLeftToRight
    Color = clScrollBar
    ParentBiDiMode = False
    ReadOnly = True
    TabOrder = 0
  end
  object cxProgressBar1: TcxProgressBar
    Left = 16
    Top = 47
    Properties.AnimationPath = cxapPingPong
    Properties.AnimationRestartDelay = 2
    Properties.AnimationSpeed = 2
    Properties.Marquee = True
    TabOrder = 1
    Width = 393
  end
  object labInterval: TcxLabel
    Left = 16
    Top = 74
    Caption = '0:00'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -21
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object Timer: TTimer
    Enabled = False
    Interval = 200
    OnTimer = TimerTimer
    Left = 384
    Top = 16
  end
end
