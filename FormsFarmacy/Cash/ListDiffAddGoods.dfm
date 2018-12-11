object ListDiffAddGoodsForm: TListDiffAddGoodsForm
  Left = 367
  Top = 319
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1087#1088#1077#1087#1072#1088#1072#1090#1072' '#1074' '#1083#1080#1089#1090' '#1086#1090#1082#1072#1079#1086#1074
  ClientHeight = 228
  ClientWidth = 403
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    403
    228)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 48
    Height = 16
    Caption = 'Label1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 21
    Top = 123
    Width = 59
    Height = 13
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object Label3: TLabel
    Left = 21
    Top = 150
    Width = 63
    Height = 13
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object bbOk: TcxButton
    Left = 180
    Top = 187
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object bbCancel: TcxButton
    Left = 301
    Top = 187
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object ceAmount: TcxCurrencyEdit
    Left = 93
    Top = 120
    Margins.Left = 1
    Margins.Top = 1
    AutoSize = False
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.000'
    TabOrder = 0
    Height = 21
    Width = 121
  end
  object cbNote: TComboBox
    Left = 93
    Top = 147
    Width = 297
    Height = 21
    Style = csDropDownList
    TabOrder = 1
    Items.Strings = (
      #1047#1072#1082#1072#1079' '#1082#1083#1080#1077#1085#1090#1072
      #1047#1072#1082#1072#1079' '#1082#1083#1080#1077#1085#1090#1072' ('#1089#1088#1086#1082' '#1087#1086#1076#1093#1086#1076#1080#1090')'
      #1054#1090#1082#1072#1079' ('#1079#1072#1082#1088#1099#1090' '#1082#1086#1076' '#1087#1086' '#1074#1089#1077#1081' '#1089#1077#1090#1080')'
      #1054#1090#1082#1072#1079' ('#1085#1077#1090' '#1074' '#1053#1058#1047' - '#1085#1077' '#1095#1072#1089#1090#1086' '#1089#1087#1088#1072#1096#1080#1074#1072#1077#1084#1099#1081' '#1090#1086#1074#1072#1088')'
      #1054#1090#1082#1072#1079' ('#1077#1089#1090#1100' '#1074' '#1053#1058#1047')'
      #1055#1086#1096#1077#1083' '#1089#1087#1088#1086#1089', '#1085#1077' '#1093#1074#1072#1090#1072#1077#1090' '#1086#1089#1090#1072#1090#1082#1072' '#1087#1086' '#1053#1058#1047
      #1054#1090#1082#1072#1079' - '#1094#1077#1085#1072' '#1085#1080#1078#1077' '#1091' '#1082#1086#1085#1082#1091#1088#1077#1085#1090#1086#1074' '#1088#1103#1076#1086#1084)
  end
  object ListDiffCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 24
    Top = 176
  end
end
