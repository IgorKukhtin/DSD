object MainForm: TMainForm
  Left = 421
  Top = 37
  Caption = 'MainForm'
  ClientHeight = 647
  ClientWidth = 1016
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid: TDBGrid
    Left = 0
    Top = 0
    Width = 746
    Height = 591
    Align = alClient
    DataSource = DataSource
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object ButtonPanel: TPanel
    Left = 0
    Top = 591
    Width = 1016
    Height = 56
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Gauge: TGauge
      Left = 0
      Top = 0
      Width = 1016
      Height = 19
      Align = alTop
      Progress = 50
    end
    object OKGuideButton: TButton
      Left = 56
      Top = 25
      Width = 171
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      TabOrder = 0
      OnClick = OKGuideButtonClick
    end
    object StopButton: TButton
      Left = 296
      Top = 26
      Width = 137
      Height = 25
      Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091
      TabOrder = 1
      OnClick = StopButtonClick
    end
    object CloseButton: TButton
      Left = 512
      Top = 27
      Width = 137
      Height = 25
      Caption = #1042#1099#1093#1086#1076
      TabOrder = 2
      OnClick = CloseButtonClick
    end
  end
  object Panel1: TPanel
    Left = 746
    Top = 0
    Width = 270
    Height = 591
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    object cbGoodsGroup: TCheckBox
      Tag = 10
      Left = 15
      Top = 41
      Width = 225
      Height = 17
      Caption = '1.2. '#1043#1088#1091#1087#1087#1099' '#1058#1086#1074#1072#1088#1086#1074
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object cbAllGuide: TCheckBox
      Tag = 1
      Left = 15
      Top = 1
      Width = 225
      Height = 17
      Caption = #1042#1089#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = cbAllGuideClick
    end
    object cbGoods: TCheckBox
      Tag = 10
      Left = 15
      Top = 61
      Width = 225
      Height = 17
      Caption = '1.3. '#1058#1086#1074#1072#1088#1099
      TabOrder = 2
    end
    object cbMeasure: TCheckBox
      Tag = 10
      Left = 15
      Top = 21
      Width = 225
      Height = 17
      Caption = '1.1. '#1045#1076'.'#1080#1079#1084'.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object cbGoodsKind: TCheckBox
      Tag = 10
      Left = 15
      Top = 81
      Width = 225
      Height = 17
      Caption = '1.4. '#1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074
      TabOrder = 4
    end
    object cbPaidKind: TCheckBox
      Tag = 10
      Left = 15
      Top = 111
      Width = 225
      Height = 17
      Caption = '2.1. '#1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
      Enabled = False
      TabOrder = 5
    end
    object cbJuridicalGroup: TCheckBox
      Tag = 10
      Left = 15
      Top = 181
      Width = 225
      Height = 17
      Caption = '3.1. '#1043#1088#1091#1087#1087#1099' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1093' '#1083#1080#1094' '
      TabOrder = 6
    end
    object cbContractKind: TCheckBox
      Tag = 10
      Left = 15
      Top = 131
      Width = 225
      Height = 17
      Caption = '2.2. '#1042#1080#1076#1099' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
      TabOrder = 7
    end
    object cbContract: TCheckBox
      Tag = 10
      Left = 15
      Top = 151
      Width = 225
      Height = 17
      Caption = '2.3. '#1044#1086#1075#1086#1074#1086#1088#1072
      Enabled = False
      TabOrder = 8
    end
    object cbJuridical: TCheckBox
      Tag = 10
      Left = 15
      Top = 201
      Width = 225
      Height = 17
      Caption = '3.2. '#1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      TabOrder = 9
    end
    object cbPartner: TCheckBox
      Tag = 10
      Left = 15
      Top = 221
      Width = 225
      Height = 17
      Caption = '3.3. '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      TabOrder = 10
    end
    object cbBusiness: TCheckBox
      Tag = 10
      Left = 15
      Top = 251
      Width = 225
      Height = 17
      Caption = '4.1. '#1041#1080#1079#1085#1077#1089#1099
      Enabled = False
      TabOrder = 11
    end
    object cbBranch: TCheckBox
      Tag = 10
      Left = 15
      Top = 271
      Width = 225
      Height = 17
      Caption = '4.2. '#1060#1080#1083#1080#1072#1083#1099
      Enabled = False
      TabOrder = 12
    end
    object cbUnitGroup: TCheckBox
      Tag = 10
      Left = 15
      Top = 291
      Width = 225
      Height = 17
      Caption = '4.3. '#1043#1088#1091#1087#1087#1099' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
      TabOrder = 13
    end
    object cbUnit: TCheckBox
      Tag = 10
      Left = 15
      Top = 311
      Width = 225
      Height = 17
      Caption = '4.4. '#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '
      TabOrder = 14
    end
    object cbPriceList: TCheckBox
      Tag = 10
      Left = 15
      Top = 341
      Width = 225
      Height = 17
      Caption = '5.1. '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099
      TabOrder = 15
    end
    object cbPriceListItems: TCheckBox
      Tag = 10
      Left = 15
      Top = 361
      Width = 225
      Height = 17
      Caption = '5.2. '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' - '#1094#1077#1085#1099
      Enabled = False
      TabOrder = 16
    end
  end
  object DataSource: TDataSource
    DataSet = fromQuery
    Left = 248
    Top = 192
  end
  object fromADOConnection: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Password=qazqazint;Persist Security Info=True' +
      ';User ID=dba;Data Source=v9ProfiMeatingDS'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 344
    Top = 248
  end
  object toADOConnection: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Password=postgres;Persist Security Info=True;' +
      'User ID=postgres;Data Source=PostgreSQLDS'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 192
    Top = 256
  end
  object toStoredProc: TADOStoredProc
    Connection = toADOConnection
    Parameters = <>
    Prepared = True
    Left = 104
    Top = 328
  end
  object fromQuery: TADOQuery
    Connection = fromADOConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from Goods where HasChildren<>-1 order by 1 desc')
    Left = 304
    Top = 320
  end
  object fromSqlQuery: TADOQuery
    Connection = fromADOConnection
    Parameters = <>
    Left = 384
    Top = 304
  end
  object toQuery: TADOQuery
    Connection = toADOConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from Object order by 1 desc')
    Left = 184
    Top = 328
  end
  object toStoredProcTwo: TADOStoredProc
    Connection = toADOConnection
    Parameters = <>
    Prepared = True
    Left = 104
    Top = 378
  end
end
