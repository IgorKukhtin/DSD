object MainForm: TMainForm
  Left = 202
  Top = 180
  Caption = 'MainForm'
  ClientHeight = 465
  ClientWidth = 1172
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid: TDBGrid
    Left = 0
    Top = 0
    Width = 688
    Height = 409
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
    Top = 409
    Width = 1172
    Height = 56
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Gauge: TGauge
      Left = 0
      Top = 0
      Width = 1172
      Height = 19
      Align = alTop
      Progress = 50
      ExplicitWidth = 1307
    end
    object OKGuideButton: TButton
      Left = 37
      Top = 25
      Width = 135
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      TabOrder = 0
      OnClick = OKGuideButtonClick
    end
    object StopButton: TButton
      Left = 502
      Top = 25
      Width = 137
      Height = 25
      Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1077#1081#1089#1090#1074#1080#1077
      TabOrder = 1
      OnClick = StopButtonClick
    end
    object CloseButton: TButton
      Left = 654
      Top = 25
      Width = 87
      Height = 25
      Caption = #1042#1099#1093#1086#1076
      TabOrder = 2
      OnClick = CloseButtonClick
    end
    object cbOnlyOpen: TCheckBox
      Left = 747
      Top = 29
      Width = 264
      Height = 17
      Caption = #1054#1090#1082#1083#1102#1095#1080#1090#1100' '#1076#1077#1081#1089#1090#1074#1080#1077' ('#1090#1086#1083#1100#1082#1086' '#1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077')'
      TabOrder = 3
    end
    object OKDocumentButton: TButton
      Left = 178
      Top = 25
      Width = 135
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      TabOrder = 4
      OnClick = OKDocumentButtonClick
    end
    object OKCompleteDocumentButton: TButton
      Left = 326
      Top = 25
      Width = 151
      Height = 25
      Caption = #1055#1088#1086#1074#1086#1076#1082#1080' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      TabOrder = 5
      OnClick = OKCompleteDocumentButtonClick
    end
  end
  object PageControl1: TPageControl
    Left = 688
    Top = 0
    Width = 484
    Height = 409
    ActivePage = TabSheet2
    Align = alRight
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080' - '#1044#1086#1082#1091#1084#1077#1085#1090#1099
      object GuidePanel: TPanel
        Left = -13
        Top = 0
        Width = 265
        Height = 381
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object cbAllGuide: TCheckBox
          Tag = 1
          Left = 15
          Top = 1
          Width = 122
          Height = 17
          Caption = #1042#1089#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = cbAllGuideClick
        end
        object cbMeasure: TCheckBox
          Tag = 10
          Left = 15
          Top = 17
          Width = 121
          Height = 17
          Caption = '1.1. '#1045#1076'.'#1080#1079#1084'.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object cbCompositionGroup: TCheckBox
          Tag = 10
          Left = 15
          Top = 32
          Width = 194
          Height = 17
          Caption = '1.2. '#1043#1088#1091#1087#1087#1072' '#1076#1083#1103' '#1089#1086#1089#1090#1072#1074#1072' '#1090#1086#1074#1072#1088#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
        end
        object cbId_Postgres: TCheckBox
          Tag = 1
          Left = 142
          Top = 1
          Width = 114
          Height = 17
          Caption = 'add Id_Postgres'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
        end
        object cbNullId_Postgres: TCheckBox
          Tag = 1
          Left = 142
          Top = 17
          Width = 114
          Height = 17
          Caption = 'NULL Id_Postgres'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object cbComposition: TCheckBox
          Tag = 10
          Left = 15
          Top = 47
          Width = 122
          Height = 17
          Caption = '1.3. '#1057#1086#1089#1090#1072#1074' '#1090#1086#1074#1072#1088#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object cbCountryBrand: TCheckBox
          Tag = 10
          Left = 15
          Top = 63
          Width = 194
          Height = 17
          Caption = '1.4. '#1057#1090#1088#1072#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object cbBrand: TCheckBox
          Tag = 10
          Left = 15
          Top = 79
          Width = 194
          Height = 17
          Caption = '1.5. '#1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
        end
        object cbFabrika: TCheckBox
          Tag = 10
          Left = 15
          Top = 95
          Width = 194
          Height = 17
          Caption = '1.6. '#1060#1072#1073#1088#1080#1082#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
        end
        object cbLineFabrica: TCheckBox
          Tag = 10
          Left = 15
          Top = 111
          Width = 194
          Height = 17
          Caption = '1.7. '#1051#1080#1085#1080#1103' '#1082#1086#1083#1083#1077#1082#1094#1080#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
        end
        object cbGoodsInfo: TCheckBox
          Tag = 10
          Left = 15
          Top = 128
          Width = 194
          Height = 17
          Caption = '1.8. '#1054#1087#1080#1089#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
        end
        object cbGoodsSize: TCheckBox
          Tag = 10
          Left = 15
          Top = 144
          Width = 194
          Height = 17
          Caption = '1.9. '#1056#1072#1079#1084#1077#1088' '#1090#1086#1074#1072#1088#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
        end
        object cbKassa: TCheckBox
          Tag = 10
          Left = 15
          Top = 160
          Width = 194
          Height = 17
          Caption = '1.10. '#1050#1072#1089#1089#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 12
        end
        object cbValuta: TCheckBox
          Tag = 10
          Left = 15
          Top = 176
          Width = 194
          Height = 17
          Caption = '1.11. '#1042#1072#1083#1102#1090#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 13
        end
        object cbPeriod: TCheckBox
          Tag = 10
          Left = 15
          Top = 193
          Width = 122
          Height = 17
          Caption = '1.12. '#1055#1077#1088#1080#1086#1076
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 14
        end
        object cbGoodsGroup: TCheckBox
          Tag = 10
          Left = 15
          Top = 209
          Width = 162
          Height = 17
          Caption = '1.13. '#1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 15
        end
        object cbDiscount: TCheckBox
          Tag = 10
          Left = 15
          Top = 225
          Width = 226
          Height = 17
          Caption = '1.14. '#1053#1072#1079#1074#1072#1085#1080#1103' '#1085#1072#1082#1086#1087#1080#1090#1077#1083#1100#1085#1099#1093' '#1089#1082#1080#1076#1086#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 16
        end
        object cbDiscountTools: TCheckBox
          Tag = 10
          Left = 15
          Top = 241
          Width = 178
          Height = 24
          Caption = '1.15. '#1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1088#1086#1094#1077#1085#1090#1086#1074' '#1087#1086' '#1085#1072#1082#1086#1087#1080#1090#1077#1083#1100#1085#1099#1084' '#1089#1082#1080#1076#1082#1072#1084
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 17
          WordWrap = True
        end
        object cbPartner: TCheckBox
          Tag = 10
          Left = 15
          Top = 265
          Width = 178
          Height = 24
          Caption = '1.16. '#1055#1086'c'#1090#1072#1074#1097#1080#1082#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 18
          WordWrap = True
        end
        object cbUnit: TCheckBox
          Tag = 10
          Left = 15
          Top = 284
          Width = 178
          Height = 24
          Caption = '1.17. '#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 19
          WordWrap = True
        end
        object cbLabel: TCheckBox
          Tag = 10
          Left = 15
          Top = 302
          Width = 178
          Height = 24
          Caption = '1.18. '#1053#1072#1079#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1094#1077#1085#1085#1080#1082#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 20
          WordWrap = True
        end
        object cbGoods: TCheckBox
          Tag = 10
          Left = 15
          Top = 321
          Width = 178
          Height = 24
          Caption = '1.19. '#1058#1086#1074#1072#1088#1099
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 21
          WordWrap = True
        end
        object cbGoodsItem: TCheckBox
          Tag = 10
          Left = 15
          Top = 339
          Width = 178
          Height = 24
          Caption = '1.20. '#1058#1086#1074#1072#1088#1099' c '#1088#1072#1079#1084#1077#1088#1072#1084#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 22
          WordWrap = True
        end
        object cbClient: TCheckBox
          Tag = 10
          Left = 15
          Top = 379
          Width = 178
          Height = 24
          Caption = '1.22. '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 23
          WordWrap = True
        end
        object cbCity: TCheckBox
          Tag = 10
          Left = 15
          Top = 359
          Width = 178
          Height = 24
          Caption = '1.21. '#1043#1086#1088#1086#1076
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 24
          WordWrap = True
        end
      end
      object DocumentPanel: TPanel
        Left = 252
        Top = 0
        Width = 224
        Height = 381
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        object Label1: TLabel
          Left = 6
          Top = 22
          Width = 6
          Height = 13
          Caption = #1089
        end
        object Label2: TLabel
          Left = 109
          Top = 22
          Width = 12
          Height = 13
          Caption = #1087#1086
        end
        object cbAllDocument: TCheckBox
          Tag = 2
          Left = 3
          Top = 1
          Width = 235
          Height = 17
          Caption = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = cbAllDocumentClick
        end
        object StartDateEdit: TcxDateEdit
          Left = 15
          Top = 18
          TabOrder = 1
          Width = 90
        end
        object EndDateEdit: TcxDateEdit
          Left = 122
          Top = 18
          TabOrder = 2
          Width = 90
        end
        object cbIncome: TCheckBox
          Tag = 20
          Left = 6
          Top = 45
          Width = 235
          Height = 17
          Caption = '1.1. '#1055#1088#1080#1093#1086#1076
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1080#1079' '#1092#1072#1081#1083#1086#1074
      ImageIndex = 1
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 225
        Height = 381
        Align = alLeft
        TabOrder = 0
        object Label3: TLabel
          Left = 8
          Top = 280
          Width = 127
          Height = 13
          Caption = #1055#1091#1090#1100' '#1082' '#1087#1072#1087#1082#1077' '#1089' '#1092#1072#1081#1083#1072#1084#1080' '
        end
        object Label4: TLabel
          Left = 64
          Top = 328
          Width = 151
          Height = 13
          Caption = #1060#1072#1081#1083#1099' '#1074' '#1082#1086#1076#1080#1088#1086#1074#1082#1077' EOM 866'
        end
        object CreateTableButton: TButton
          Left = 75
          Top = 227
          Width = 142
          Height = 25
          Caption = #1057#1086#1079#1076#1072#1090#1100' '#1090#1072#1073#1083#1080#1094#1099
          TabOrder = 0
          OnClick = CreateTableButtonClick
        end
        object cbChado: TCheckBox
          Tag = 11
          Left = 2
          Top = 8
          Width = 97
          Height = 17
          Caption = 'Chado.dat'
          TabOrder = 1
        end
        object Button1: TButton
          Left = 75
          Top = 347
          Width = 142
          Height = 25
          Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1090#1072#1073#1083#1080#1094#1099
          TabOrder = 2
          OnClick = Button1Click
        end
        object PathDatFiles: TEdit
          Left = 2
          Top = 299
          Width = 215
          Height = 21
          TabOrder = 3
          Text = 'd:\DatFiles'
        end
        object cbEsc: TCheckBox
          Tag = 11
          Left = 2
          Top = 31
          Width = 97
          Height = 17
          Caption = 'Esc.dat'
          TabOrder = 4
        end
        object cbMM: TCheckBox
          Tag = 11
          Left = 2
          Top = 54
          Width = 97
          Height = 17
          Caption = 'MM.dat'
          TabOrder = 5
        end
        object cbSAV: TCheckBox
          Tag = 11
          Left = 2
          Top = 77
          Width = 97
          Height = 17
          Caption = 'SAV.dat'
          TabOrder = 6
        end
        object cbSav_out: TCheckBox
          Tag = 11
          Left = 2
          Top = 100
          Width = 97
          Height = 17
          Caption = 'Sav_out.dat'
          TabOrder = 7
        end
        object cbTer_Out: TCheckBox
          Tag = 11
          Left = 2
          Top = 123
          Width = 97
          Height = 17
          Caption = 'Ter_Out.dat'
          TabOrder = 8
        end
        object cbTL: TCheckBox
          Tag = 11
          Left = 2
          Top = 146
          Width = 97
          Height = 17
          Caption = 'TL.dat'
          TabOrder = 9
        end
        object cbVint: TCheckBox
          Tag = 11
          Left = 2
          Top = 169
          Width = 97
          Height = 17
          Caption = 'Vint.dat'
          TabOrder = 10
        end
        object cbSop: TCheckBox
          Tag = 11
          Left = 2
          Top = 192
          Width = 97
          Height = 17
          Caption = 'Sop.dat'
          TabOrder = 11
        end
        object cbGoods2: TCheckBox
          Tag = 11
          Left = 114
          Top = 8
          Width = 97
          Height = 17
          Caption = 'Goods2'
          TabOrder = 12
        end
        object InsertGoods2Button: TButton
          Left = 96
          Top = 31
          Width = 121
          Height = 25
          Caption = 'insert into Goods2'
          TabOrder = 13
          OnClick = InsertGoods2ButtonClick
        end
        object Button2: TButton
          Left = 96
          Top = 93
          Width = 121
          Height = 25
          Caption = 'Drop table Goods2'
          TabOrder = 14
          OnClick = Button2Click
        end
        object Button3: TButton
          Left = 96
          Top = 62
          Width = 121
          Height = 25
          Caption = 'Insert HasChildren = -1'
          TabOrder = 15
          OnClick = Button3Click
        end
        object cbAllTables: TCheckBox
          Left = 98
          Top = 192
          Width = 97
          Height = 17
          Caption = #1042#1089#1077' '#1090#1072#1073#1083#1080#1094#1099
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 16
          OnClick = cbAllTablesClick
        end
      end
    end
  end
  object DataSource: TDataSource
    Left = 24
    Top = 48
  end
  object toSqlQuery: TZQuery
    Connection = toZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 56
    Top = 320
  end
  object toStoredProc: TdsdStoredProc
    DataSets = <>
    Params = <>
    PackSize = 1
    Left = 24
    Top = 208
  end
  object toStoredProc_two: TdsdStoredProc
    DataSets = <>
    Params = <>
    PackSize = 1
    Left = 24
    Top = 152
  end
  object toZConnection: TZConnection
    ControlsCodePage = cCP_UTF16
    Catalog = 'public'
    DesignConnection = True
    AfterConnect = toZConnectionAfterConnect
    HostName = 'localhost'
    Port = 0
    Database = 'boutique'
    User = 'postgres'
    Password = 'postgres'
    Protocol = 'postgresql-9'
    Left = 56
    Top = 272
  end
  object toStoredProc_three: TdsdStoredProc
    DataSets = <>
    Params = <>
    PackSize = 1
    Left = 24
    Top = 104
  end
  object toSqlQuery_two: TZQuery
    Connection = toZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 56
    Top = 368
  end
  object Database1: TDatabase
    AliasName = 'tProfiManagerDS'
    DatabaseName = 'tProfiManagerDS'
    KeepConnection = False
    LoginPrompt = False
    SessionName = 'Default'
    Left = 175
    Top = 31
  end
  object fromQuery: TQuery
    DatabaseName = 'tProfiManagerDS'
    SessionName = 'Default'
    Left = 450
    Top = 97
  end
  object fromSqlQuery: TQuery
    DatabaseName = 'tProfiManagerDS'
    SessionName = 'Default'
    Left = 562
    Top = 99
  end
  object fromQuery_two: TQuery
    DatabaseName = 'tProfiManagerDS'
    SessionName = 'Default'
    Left = 452
    Top = 160
  end
  object fromQueryDate: TQuery
    DatabaseName = 'tProfiManagerDS'
    SessionName = 'Default'
    Left = 456
    Top = 228
  end
  object fromQueryDate_recalc: TQuery
    DatabaseName = 'tProfiManagerDS'
    SessionName = 'Default'
    Left = 457
    Top = 287
  end
end
