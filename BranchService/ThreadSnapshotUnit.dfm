object ThreadSnapshotForm: TThreadSnapshotForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = #1055#1077#1088#1077#1085#1086#1089' '#1076#1072#1085#1085#1099#1093' ('#1089#1085#1072#1087#1096#1086#1090')'
  ClientHeight = 269
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
    Height = 228
    Align = alClient
    Caption = 'PanelMain'
    ShowCaption = False
    TabOrder = 0
    object lblActionTake: TcxLabel
      Left = 24
      Top = 33
      Caption = #1042#1099#1087#1086#1083#1085#1103#1077#1084#1086#1077' '#1076#1077#1081#1089#1090#1074#1080#1077
    end
    object pbTable: TcxProgressBar
      Left = 24
      Top = 56
      TabOrder = 1
      Width = 473
    end
    object pbCurrTable: TcxProgressBar
      Left = 24
      Top = 119
      TabOrder = 2
      Width = 473
    end
    object cxLabel1: TcxLabel
      Left = 24
      Top = 96
      Caption = #1055#1088#1086#1075#1088#1072#1089#1089' '#1086#1073#1088#1072#1073#1072#1090#1099#1074#1072#1077#1084#1086#1081' '#1090#1072#1073#1083#1080#1094#1099
    end
    object pbAll: TcxProgressBar
      Left = 24
      Top = 184
      TabOrder = 4
      Width = 473
    end
    object cxLabel2: TcxLabel
      Left = 24
      Top = 160
      Caption = #1054#1073#1097#1080#1081' '#1087#1088#1086#1075#1088#1077#1089#1089' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 228
    Width = 515
    Height = 41
    Align = alBottom
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    object btnEqualizationBreak: TButton
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
