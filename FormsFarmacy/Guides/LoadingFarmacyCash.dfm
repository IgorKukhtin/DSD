object LoadingFarmacyCashForm: TLoadingFarmacyCashForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1047#1072#1075#1088#1091#1079#1082#1072' FarmacyCash'
  ClientHeight = 250
  ClientWidth = 371
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
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 208
    Width = 371
    Height = 42
    Align = alBottom
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    ExplicitTop = 240
    ExplicitWidth = 430
    object btnOk: TcxButton
      Left = 40
      Top = 6
      Width = 75
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Enabled = False
      ModalResult = 1
      TabOrder = 0
    end
    object btnCancel: TcxButton
      Left = 240
      Top = 6
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object cxMemo1: TcxMemo
    Left = 0
    Top = 0
    Align = alClient
    Enabled = False
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -17
    Style.Font.Name = 'Times New Roman'
    Style.Font.Style = []
    Style.IsFontAssigned = True
    StyleDisabled.BorderColor = clWindowFrame
    StyleDisabled.TextColor = clWindowText
    TabOrder = 1
    ExplicitLeft = 168
    ExplicitTop = 56
    Height = 208
    Width = 371
  end
  object Timer: TTimer
    Enabled = False
    Interval = 200
    OnTimer = TimerTimer
    Left = 16
    Top = 16
  end
end
