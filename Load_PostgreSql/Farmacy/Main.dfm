object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 399
  ClientWidth = 884
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GuidePanel: TPanel
    Left = 458
    Top = 0
    Width = 195
    Height = 343
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
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
      TabOrder = 0
    end
    object cbGoods: TCheckBox
      Tag = 10
      Left = 15
      Top = 43
      Width = 225
      Height = 15
      Caption = '1.2. '#1058#1086#1074#1072#1088#1099
      TabOrder = 1
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
      TabOrder = 2
    end
    object cbJuridical: TCheckBox
      Tag = 10
      Left = 15
      Top = 110
      Width = 225
      Height = 17
      Caption = '3.2. '#1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      TabOrder = 3
    end
    object cbUnit: TCheckBox
      Tag = 10
      Left = 15
      Top = 159
      Width = 225
      Height = 17
      Caption = '4.4. '#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '
      TabOrder = 4
    end
    object cbPriceList: TCheckBox
      Tag = 10
      Left = 15
      Top = 186
      Width = 225
      Height = 17
      Caption = '5.1. '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099
      TabOrder = 5
    end
    object cbPriceListItems: TCheckBox
      Tag = 10
      Left = 15
      Top = 209
      Width = 225
      Height = 17
      Caption = '5.2. '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' - '#1094#1077#1085#1099
      Enabled = False
      TabOrder = 6
    end
    object cbAccountGroup: TCheckBox
      Tag = 10
      Left = 15
      Top = 511
      Width = 289
      Height = 17
      Caption = '8.1. '#1043#1088#1091#1087#1087#1099' '#1091#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1093' '#1089#1095#1077#1090#1086#1074
      TabOrder = 7
    end
    object cbAccountDirection: TCheckBox
      Tag = 10
      Left = 15
      Top = 531
      Width = 289
      Height = 17
      Caption = '8.2. '#1040#1085#1072#1083#1080#1090#1080#1082#1080' '#1091#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1093' '#1089#1095#1077#1090#1086#1074' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
      TabOrder = 8
    end
    object cbAccount: TCheckBox
      Tag = 10
      Left = 15
      Top = 551
      Width = 289
      Height = 17
      Caption = '8.3. '#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1095#1077#1090#1072
      TabOrder = 9
    end
    object cbBank: TCheckBox
      Tag = 10
      Left = 15
      Top = 132
      Width = 225
      Height = 17
      Caption = '3.2. '#1041#1072#1085#1082#1080
      Enabled = False
      TabOrder = 10
    end
    object cbGoodsPartnerCode: TCheckBox
      Tag = 10
      Left = 15
      Top = 62
      Width = 225
      Height = 17
      Caption = '1.3. '#1050#1086#1076#1099' '#1087#1088#1086#1076#1072#1074#1094#1086#1074
      Color = clBtnFace
      ParentColor = False
      TabOrder = 11
    end
    object CheckBox1: TCheckBox
      Tag = 10
      Left = 15
      Top = 245
      Width = 225
      Height = 17
      Caption = '3.1. '#1042#1080#1076#1099' '#1089#1086#1073#1089#1090#1074#1077#1085#1085#1086#1089#1090#1080
      Color = clBtnFace
      ParentColor = False
      TabOrder = 12
    end
    object CheckBox2: TCheckBox
      Tag = 10
      Left = 15
      Top = 268
      Width = 225
      Height = 17
      Caption = '3.2. '#1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      TabOrder = 13
    end
    object CheckBox3: TCheckBox
      Tag = 10
      Left = 15
      Top = 290
      Width = 225
      Height = 17
      Caption = '3.2. '#1041#1072#1085#1082#1080
      Enabled = False
      TabOrder = 14
    end
    object cbLinkGoods: TCheckBox
      Tag = 10
      Left = 15
      Top = 82
      Width = 225
      Height = 17
      Caption = '1.4. '#1040#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074#1085#1099#1077' '#1082#1086#1076#1099
      Color = clBtnFace
      ParentColor = False
      TabOrder = 15
    end
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 0
    Width = 458
    Height = 343
    Align = alClient
    DataSource = DataSource
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DocumentPanel: TPanel
    Left = 653
    Top = 0
    Width = 231
    Height = 343
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    object Label1: TLabel
      Left = 6
      Top = 24
      Width = 5
      Height = 13
      Caption = #1089
    end
    object Label2: TLabel
      Left = 109
      Top = 27
      Width = 12
      Height = 13
      Caption = #1087#1086
    end
    object cbAllDocument: TCheckBox
      Tag = 2
      Left = 15
      Top = 1
      Width = 194
      Height = 17
      Caption = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object cbIncome: TCheckBox
      Tag = 20
      Left = 15
      Top = 61
      Width = 194
      Height = 17
      Caption = '1. '#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object StartDateEdit: TcxDateEdit
      Left = 14
      Top = 22
      TabOrder = 2
      Width = 90
    end
    object EndDateEdit: TcxDateEdit
      Left = 122
      Top = 22
      TabOrder = 3
      Width = 90
    end
    object cbCashOperation: TCheckBox
      Tag = 20
      Left = 15
      Top = 125
      Width = 194
      Height = 17
      Caption = '1.1. CashOperation'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object cbBill: TCheckBox
      Tag = 20
      Left = 15
      Top = 148
      Width = 194
      Height = 17
      Caption = '1.2. Bill'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object Edit1: TEdit
      Left = 32
      Top = 304
      Width = 104
      Height = 21
      TabOrder = 6
      Text = 'Edit1'
    end
  end
  object ButtonPanel: TPanel
    Left = 0
    Top = 343
    Width = 884
    Height = 56
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object Gauge: TGauge
      Left = 0
      Top = 0
      Width = 884
      Height = 19
      Align = alTop
      Progress = 50
      ExplicitWidth = 1307
    end
    object OKGuideButton: TButton
      Left = 32
      Top = 25
      Width = 137
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      TabOrder = 0
      OnClick = OKGuideButtonClick
    end
    object StopButton: TButton
      Left = 350
      Top = 25
      Width = 131
      Height = 25
      Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091
      TabOrder = 1
      OnClick = StopButtonClick
    end
    object CloseButton: TButton
      Left = 505
      Top = 25
      Width = 64
      Height = 25
      Caption = #1042#1099#1093#1086#1076
      TabOrder = 2
      OnClick = CloseButtonClick
    end
    object cbSetNull_Id_Postgres: TCheckBox
      Left = 579
      Top = 20
      Width = 292
      Height = 17
      Caption = #1044#1083#1103' '#1087#1077#1088#1074#1086#1075#1086' '#1088#1072#1079#1072' set Sybase.'#1042#1057#1045#1052'.Id_Postgres = null'
      Enabled = False
      TabOrder = 3
    end
    object cbOnlyOpen: TCheckBox
      Left = 579
      Top = 39
      Width = 292
      Height = 17
      Caption = #1054#1090#1082#1083#1102#1095#1080#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' ('#1090#1086#1083#1100#1082#1086' '#1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077')'
      TabOrder = 4
    end
    object OKDocumentButton: TButton
      Left = 193
      Top = 25
      Width = 136
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      TabOrder = 5
      OnClick = OKDocumentButtonClick
    end
  end
  object DataSource: TDataSource
    DataSet = fromQuery
    Left = 144
    Top = 233
  end
  object fromADOConnection: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Password=sql;Persist Security Info=True;User ' +
      'ID=dba;Data Source=CodeDS'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 344
    Top = 145
  end
  object fromSqlQuery: TADOQuery
    Connection = fromADOConnection
    Parameters = <>
    Left = 392
    Top = 337
  end
  object fromQuery: TADOQuery
    Connection = fromADOConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from Goods where HasChildren<>-1 order by 1 desc')
    Left = 256
    Top = 224
  end
  object toStoredProc: TdsdStoredProc
    DataSets = <>
    Params = <>
    PackSize = 1
    Left = 120
    Top = 416
  end
  object toTwoStoredProc: TdsdStoredProc
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 72
    Top = 160
  end
  object toZConnection: TZConnection
    ControlsCodePage = cCP_UTF16
    Catalog = 'public'
    DesignConnection = True
    HostName = 'localhost'
    Port = 0
    User = 'postgres'
    Password = 'postgres'
    Protocol = 'postgresql-9'
    Left = 128
    Top = 48
  end
end
