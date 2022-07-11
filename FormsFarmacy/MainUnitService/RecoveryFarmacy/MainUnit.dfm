object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1042#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' Farmacy.exe'
  ClientHeight = 98
  ClientWidth = 432
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Times New Roman'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 19
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 432
    Height = 33
    Align = alTop
    TabOrder = 0
    object btnAll: TButton
      Left = 16
      Top = 2
      Width = 129
      Height = 25
      Caption = #1042#1086#1089#1090#1072#1085#1086#1074#1080#1090#1100'!'
      TabOrder = 0
      OnClick = btnAllClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 33
    Width = 432
    Height = 65
    Align = alClient
    Caption = #1055#1086#1076#1086#1078#1076#1080#1090#1077' '#1080#1076#1077#1090' '#1074#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' Farmacy.exe'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 24
    Top = 48
  end
end
