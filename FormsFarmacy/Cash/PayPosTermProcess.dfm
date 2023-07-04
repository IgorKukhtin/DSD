object PayPosTermProcessForm: TPayPosTermProcessForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1054#1087#1083#1072#1090#1072' '#1085#1072' POS-'#1090#1077#1088#1084#1080#1085#1072#1083#1077
  ClientHeight = 83
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
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object edMsgDescription: TEdit
    Left = 16
    Top = 12
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
  object Timer: TTimer
    Enabled = False
    Interval = 200
    OnTimer = TimerTimer
    Left = 384
    Top = 16
  end
end
