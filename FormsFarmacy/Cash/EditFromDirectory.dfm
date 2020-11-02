object EditFromDirectoryForm: TEditFromDirectoryForm
  Left = 0
  Top = 0
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
  ClientHeight = 209
  ClientWidth = 445
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 445
    Height = 169
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 405
    ExplicitHeight = 25
    DesignSize = (
      445
      169)
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 70
      Height = 18
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 16
      Top = 88
      Width = 62
      Height = 18
      Caption = #1042#1074#1077#1076#1080#1090#1077':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edMaskName: TcxMaskEdit
      Left = 16
      Top = 48
      Anchors = [akLeft, akTop, akRight]
      ParentFont = False
      Properties.CharCase = ecUpperCase
      Properties.ValidationOptions = []
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -16
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      Width = 409
    end
    object edMaskSecond: TcxMaskEdit
      Left = 16
      Top = 112
      Anchors = [akLeft, akTop, akRight]
      ParentFont = False
      Properties.CharCase = ecUpperCase
      Properties.ValidationOptions = []
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -16
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 1
      Width = 409
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 169
    Width = 445
    Height = 40
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 192
    DesignSize = (
      445
      40)
    object bbCancel: TcxButton
      Left = 350
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      OnClick = bbCancelClick
    end
    object bbOk: TcxButton
      Left = 257
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      Default = True
      TabOrder = 0
      OnClick = bbOkClick
    end
  end
end
