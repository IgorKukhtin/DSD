object ListDiffAddGoodsForm: TListDiffAddGoodsForm
  Left = 367
  Top = 319
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1087#1088#1077#1087#1072#1088#1072#1090#1072' '#1074' '#1083#1080#1089#1090' '#1086#1090#1082#1072#1079#1086#1074
  ClientHeight = 267
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
    267)
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
    Top = 139
    Width = 59
    Height = 13
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object Label3: TLabel
    Left = 21
    Top = 198
    Width = 63
    Height = 13
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object Label4: TLabel
    Left = 21
    Top = 170
    Width = 57
    Height = 13
    Caption = #1042#1080#1076' '#1086#1090#1082#1072#1079#1072
  end
  object Label5: TLabel
    Left = 24
    Top = 113
    Width = 48
    Height = 16
    Caption = 'Label5'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object bbOk: TcxButton
    Left = 180
    Top = 227
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
    Top = 227
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
    Top = 136
    Margins.Left = 1
    Margins.Top = 1
    AutoSize = False
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.000'
    TabOrder = 0
    Height = 21
    Width = 121
  end
  object meComent: TcxMaskEdit
    Left = 93
    Top = 195
    TabOrder = 4
    Width = 283
  end
  object lcbDiffKind: TcxLookupComboBox
    Left = 93
    Top = 167
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = DiffKindDS
    TabOrder = 1
    Width = 283
  end
  object ListDiffCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 24
    Top = 216
  end
  object DiffKindCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 272
    Top = 16
  end
  object DiffKindDS: TDataSource
    DataSet = DiffKindCDS
    Left = 336
    Top = 16
  end
  object ListGoodsCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'GoodsName'
    Params = <>
    StoreDefs = True
    Left = 272
    Top = 72
  end
end
