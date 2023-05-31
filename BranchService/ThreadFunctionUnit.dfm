object ThreadFunctionForm: TThreadFunctionForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = #1055#1077#1088#1077#1085#1086#1089' '#1092#1091#1085#1082#1094#1080#1081
  ClientHeight = 146
  ClientWidth = 515
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanelMain: TPanel
    Left = 0
    Top = 0
    Width = 515
    Height = 105
    Align = alClient
    Caption = 'PanelMain'
    ShowCaption = False
    TabOrder = 0
    object pbAll: TcxProgressBar
      Left = 24
      Top = 45
      TabOrder = 0
      Width = 473
    end
    object lblActionTake: TcxLabel
      Left = 24
      Top = 22
      Caption = #1063#1090#1086' '#1076#1077#1083#1072#1077#1084
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 105
    Width = 515
    Height = 41
    Align = alBottom
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    ExplicitTop = 228
    object Button1: TButton
      Left = 344
      Top = 8
      Width = 139
      Height = 25
      Caption = #1055#1088#1077#1088#1074#1072#1090#1100' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1077
      ModalResult = 2
      TabOrder = 0
    end
  end
end
