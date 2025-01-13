object MainForm: TMainForm
  Left = 202
  Top = 180
  Caption = 'MainForm'
  ClientHeight = 720
  ClientWidth = 1121
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid: TDBGrid
    Left = 0
    Top = 0
    Width = 423
    Height = 664
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
    Top = 664
    Width = 1121
    Height = 56
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Gauge: TGauge
      Left = 0
      Top = 0
      Width = 1121
      Height = 19
      Align = alTop
      Progress = 50
      ExplicitWidth = 1307
    end
    object OKGuideButton: TButton
      Left = 254
      Top = 25
      Width = 96
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' GUIDE'
      DragMode = dmAutomatic
      TabOrder = 0
      OnClick = OKGuideButtonClick
    end
    object StopButton: TButton
      Left = 594
      Top = 25
      Width = 83
      Height = 25
      Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100
      TabOrder = 1
      OnClick = StopButtonClick
    end
    object CloseButton: TButton
      Left = 683
      Top = 25
      Width = 68
      Height = 25
      Caption = #1042#1099#1093#1086#1076
      TabOrder = 2
      OnClick = CloseButtonClick
    end
    object cbSetNull_Id_Postgres: TCheckBox
      Left = 915
      Top = 38
      Width = 292
      Height = 17
      Caption = #1044#1083#1103' '#1087#1077#1088#1074#1086#1075#1086' '#1088#1072#1079#1072' set Sybase.'#1042#1057#1045#1052'.Id_Postgres = null'
      Enabled = False
      TabOrder = 3
    end
    object cbOnlyOpen: TCheckBox
      Left = 754
      Top = 21
      Width = 264
      Height = 17
      Caption = #1054#1090#1082#1083#1102#1095#1080#1090#1100' '#1076#1077#1081#1089#1090#1074#1080#1077' ('#1090#1086#1083#1100#1082#1086' '#1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077')'
      TabOrder = 4
    end
    object OKDocumentButton: TButton
      Left = 356
      Top = 25
      Width = 80
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1086#1082
      TabOrder = 5
      OnClick = OKDocumentButtonClick
    end
    object OKCompleteDocumentButton: TButton
      Left = 442
      Top = 25
      Width = 146
      Height = 25
      Caption = #1055#1088#1086#1074#1086#1076#1082#1080' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      TabOrder = 6
      OnClick = OKCompleteDocumentButtonClick
    end
    object cbOnlyOpenMI: TCheckBox
      Left = 754
      Top = 38
      Width = 132
      Height = 17
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' MI'
      TabOrder = 7
    end
    object Button1: TButton
      Left = 23
      Top = 25
      Width = 122
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' Currency_all'
      TabOrder = 8
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 151
      Top = 25
      Width = 97
      Height = 25
      Caption = 'Market Message'
      TabOrder = 9
      OnClick = Button2Click
    end
  end
  object GuidePanel: TPanel
    Left = 703
    Top = 0
    Width = 9
    Height = 664
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
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
      Width = 106
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
      Width = 118
      Height = 17
      Caption = '1.4. '#1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074
      TabOrder = 4
    end
    object cbPaidKind: TCheckBox
      Tag = 10
      Left = 15
      Top = 108
      Width = 138
      Height = 17
      Caption = '2.1. '#1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
      Enabled = False
      TabOrder = 5
    end
    object cbContractKind: TCheckBox
      Tag = 10
      Left = 15
      Top = 126
      Width = 138
      Height = 17
      Caption = '2.2. '#1042#1080#1076#1099' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
      Enabled = False
      TabOrder = 6
    end
    object cbContractFl: TCheckBox
      Tag = 10
      Left = 15
      Top = 144
      Width = 138
      Height = 17
      Caption = '2.3. '#1044#1086#1075#1086#1074#1086#1088#1072' Fl'
      Enabled = False
      TabOrder = 7
    end
    object cbJuridicalBranchNal: TCheckBox
      Tag = 10
      Left = 15
      Top = 227
      Width = 225
      Height = 17
      Caption = '3.2.2. '#1070#1088'.'#1083#1080#1094#1072' '#1060#1080#1083#1080#1072#1083'-'#1053#1072#1083
      Enabled = False
      TabOrder = 8
    end
    object cbPartnerBranchNal: TCheckBox
      Tag = 10
      Left = 15
      Top = 242
      Width = 194
      Height = 17
      Caption = '3.3. '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' '#1060#1080#1083#1072#1083'-'#1053#1072#1083
      Enabled = False
      TabOrder = 9
    end
    object cbBusiness: TCheckBox
      Tag = 10
      Left = 15
      Top = 259
      Width = 225
      Height = 17
      Caption = '4.1. '#1041#1080#1079#1085#1077#1089#1099
      Enabled = False
      TabOrder = 10
    end
    object cbBranch: TCheckBox
      Tag = 10
      Left = 15
      Top = 274
      Width = 225
      Height = 17
      Caption = '4.2. '#1060#1080#1083#1080#1072#1083#1099
      Color = clBtnFace
      Enabled = False
      ParentColor = False
      TabOrder = 11
    end
    object cbUnitGroup: TCheckBox
      Tag = 10
      Left = 15
      Top = 289
      Width = 210
      Height = 17
      Caption = '4.3. '#1043#1088#1091#1087#1087#1099' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081' !!! '#1053#1045#1058' !!!'
      Enabled = False
      TabOrder = 12
    end
    object cbUnit: TCheckBox
      Tag = 10
      Left = 15
      Top = 304
      Width = 225
      Height = 17
      Caption = '4.4. '#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '
      Enabled = False
      TabOrder = 13
    end
    object cbPriceList: TCheckBox
      Tag = 10
      Left = 15
      Top = 354
      Width = 146
      Height = 17
      Caption = '5.1. '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099
      TabOrder = 14
    end
    object cbPriceListItems: TCheckBox
      Tag = 10
      Left = 15
      Top = 373
      Width = 138
      Height = 17
      Caption = '5.2. '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' - '#1094#1077#1085#1099
      TabOrder = 15
    end
    object cbGoodsProperty: TCheckBox
      Tag = 10
      Left = 15
      Top = 398
      Width = 289
      Height = 17
      Caption = '6.1. '#1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088#1099' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1086#1074
      Enabled = False
      TabOrder = 16
    end
    object cbGoodsPropertyValue: TCheckBox
      Tag = 10
      Left = 15
      Top = 414
      Width = 289
      Height = 17
      Caption = '6.2. '#1047#1085#1072#1095#1077#1085#1080#1103' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1086#1074' '#1076#1083#1103' '#1082#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088#1072
      Enabled = False
      TabOrder = 17
    end
    object cbInfoMoneyGroup: TCheckBox
      Tag = 10
      Left = 15
      Top = 537
      Width = 289
      Height = 17
      Caption = '7.1. '#1043#1088#1091#1087#1087#1099' '#1091#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1093' '#1072#1085#1072#1083#1080#1090#1080#1082
      Enabled = False
      TabOrder = 18
    end
    object cbInfoMoneyDestination: TCheckBox
      Tag = 10
      Left = 15
      Top = 550
      Width = 289
      Height = 17
      Caption = '7.2. '#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1072#1085#1072#1083#1080#1090#1080#1082#1080' - '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
      Enabled = False
      TabOrder = 19
    end
    object cbInfoMoney: TCheckBox
      Tag = 10
      Left = 15
      Top = 563
      Width = 289
      Height = 17
      Caption = '7.3. '#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1072#1085#1072#1083#1080#1090#1080#1082#1080
      Enabled = False
      TabOrder = 20
    end
    object cbAccountGroup: TCheckBox
      Tag = 10
      Left = 15
      Top = 577
      Width = 289
      Height = 17
      Caption = '8.1. '#1043#1088#1091#1087#1087#1099' '#1091#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1093' '#1089#1095#1077#1090#1086#1074
      Enabled = False
      TabOrder = 21
    end
    object cbAccountDirection: TCheckBox
      Tag = 10
      Left = 15
      Top = 590
      Width = 289
      Height = 17
      Caption = '8.2. '#1040#1085#1072#1083#1080#1090#1080#1082#1080' '#1091#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1093' '#1089#1095#1077#1090#1086#1074' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
      Enabled = False
      TabOrder = 22
    end
    object cbAccount: TCheckBox
      Tag = 10
      Left = 15
      Top = 603
      Width = 289
      Height = 17
      Caption = '8.3. '#1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1095#1077#1090#1072
      Enabled = False
      TabOrder = 23
    end
    object cbProfitLoss: TCheckBox
      Tag = 10
      Left = 15
      Top = 643
      Width = 289
      Height = 17
      Caption = '9.3. '#1057#1090#1072#1090#1100#1080' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093' '
      Enabled = False
      TabOrder = 24
    end
    object cbProfitLossDirection: TCheckBox
      Tag = 10
      Left = 15
      Top = 630
      Width = 289
      Height = 17
      Caption = '9.2. '#1040#1085#1072#1083#1080#1090#1080#1082#1080' '#1089#1090#1072#1090#1077#1081' '#1054#1055#1048#1059' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077' '
      Enabled = False
      TabOrder = 25
    end
    object cbProfitLossGroup: TCheckBox
      Tag = 10
      Left = 15
      Top = 617
      Width = 289
      Height = 17
      Caption = '9.1. '#1043#1088#1091#1087#1087#1099' '#1089#1090#1072#1090#1077#1081' '#1086#1090#1095#1077#1090#1072' '#1086' '#1087#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1091#1073#1099#1090#1082#1072#1093
      Enabled = False
      TabOrder = 26
    end
    object cbMember_andPersonal_andRoute: TCheckBox
      Tag = 10
      Left = 15
      Top = 320
      Width = 145
      Height = 26
      Caption = '4.5. '#1060#1080#1079' '#1083'. + '#1052#1072#1088#1096#1088#1091#1090#1099' + '#1040#1074#1090#1086' : Update'
      Enabled = False
      TabOrder = 27
      WordWrap = True
    end
    object cbTradeMark: TCheckBox
      Tag = 10
      Left = 151
      Top = 81
      Width = 135
      Height = 17
      Caption = '1.5. '#1058#1086#1088#1075#1086#1074#1099#1077' '#1084#1072#1088#1082#1080
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 28
    end
    object cbRouteSorting: TCheckBox
      Tag = 10
      Left = 151
      Top = 163
      Width = 168
      Height = 17
      Caption = '2.7. '#1057#1086#1088#1090#1080#1088#1086#1074#1082#1080' '#1052#1072#1088#1096#1088#1091#1090#1086#1074
      Enabled = False
      TabOrder = 29
    end
    object cbFuel: TCheckBox
      Tag = 10
      Left = 151
      Top = 61
      Width = 135
      Height = 17
      Caption = '1.6. '#1042#1080#1076#1099' '#1058#1086#1087#1083#1080#1074#1072
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 30
    end
    object cbCar: TCheckBox
      Tag = 10
      Left = 151
      Top = 259
      Width = 115
      Height = 17
      Caption = '4.6. '#1040#1074#1090#1086#1084#1086#1073#1080#1083#1080
      Enabled = False
      TabOrder = 31
    end
    object cbRoute: TCheckBox
      Tag = 10
      Left = 151
      Top = 274
      Width = 115
      Height = 17
      Caption = '4.7. '#1052#1072#1088#1096#1088#1091#1090#1099
      Enabled = False
      TabOrder = 32
    end
    object cbCardFuel: TCheckBox
      Tag = 10
      Left = 151
      Top = 304
      Width = 139
      Height = 17
      Caption = '4.8. '#1058#1086#1087#1083#1080#1074#1085#1099#1077' '#1082#1072#1088#1090#1099
      Enabled = False
      TabOrder = 33
    end
    object cbTicketFuel: TCheckBox
      Tag = 10
      Left = 151
      Top = 41
      Width = 145
      Height = 17
      Caption = '1.7. '#1058#1072#1083#1086#1085#1099' '#1085#1072' '#1090#1086#1087#1083#1080#1074#1086
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 34
    end
    object cbModelService: TCheckBox
      Tag = 10
      Left = 163
      Top = 320
      Width = 153
      Height = 17
      Caption = '4.9. '#1052#1086#1076#1077#1083#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 35
    end
    object cbStaffList: TCheckBox
      Tag = 10
      Left = 163
      Top = 335
      Width = 158
      Height = 17
      Caption = '4.10. '#1064#1090#1072#1090#1085#1086#1077' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 36
    end
    object cbMember_andPersonal_SheetWorkTime: TCheckBox
      Tag = 10
      Left = 163
      Top = 350
      Width = 160
      Height = 17
      Caption = '4.11. '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1080' '#1080#1079' '#1090#1072#1073#1077#1083#1103
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 37
    end
    object cbData1CLink: TCheckBox
      Tag = 10
      Left = 196
      Top = 242
      Width = 172
      Height = 17
      Caption = '3.5. '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080' 1'#1057' '#1092#1080#1083#1080#1072#1083#1099
      Enabled = False
      TabOrder = 38
    end
    object cbContractInt: TCheckBox
      Tag = 10
      Left = 151
      Top = 128
      Width = 138
      Height = 17
      Caption = '2.5. '#1044#1086#1075#1086#1074#1086#1088#1072' Int'
      Enabled = False
      TabOrder = 39
    end
    object cbJuridicalInt: TCheckBox
      Tag = 10
      Left = 151
      Top = 108
      Width = 225
      Height = 17
      Caption = '2.4. '#1070#1088'.'#1083#1080#1094#1072' Int'
      Enabled = False
      TabOrder = 40
    end
    object cbPartnerInt: TCheckBox
      Tag = 10
      Left = 156
      Top = 144
      Width = 146
      Height = 17
      Caption = '2.6. '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' Int'
      Enabled = False
      TabOrder = 41
    end
    object cbGoodsProperty_Detail: TCheckBox
      Tag = 10
      Left = 162
      Top = 373
      Width = 156
      Height = 17
      Caption = '4.12. GoodsProperty_Detail'
      TabOrder = 42
    end
    object cb1Find2InsertPartner1C_BranchNal: TCheckBox
      Tag = 10
      Left = 15
      Top = 212
      Width = 290
      Height = 17
      Caption = '3.2.1. 1Find+2Insert : Partner1C_BranchNal'
      Enabled = False
      TabOrder = 43
    end
    object cbJuridicalGroup: TCheckBox
      Tag = 10
      Left = 196
      Top = 227
      Width = 225
      Height = 17
      Caption = '3.1. '#1043#1088#1091#1087#1087#1099' '#1102#1088'. '#1083#1080#1094
      Enabled = False
      TabOrder = 44
    end
    object cbGoodsQuality: TCheckBox
      Tag = 10
      Left = 15
      Top = 520
      Width = 289
      Height = 17
      Caption = '11.2. '#1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1082#1072#1095#1077#1089#1090#1074'.'
      Enabled = False
      TabOrder = 45
    end
    object cbQuality: TCheckBox
      Tag = 10
      Left = 15
      Top = 504
      Width = 289
      Height = 17
      Caption = '11.1. '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074'.'
      Enabled = False
      TabOrder = 46
    end
    object cbReceiptChild: TCheckBox
      Tag = 10
      Left = 15
      Top = 483
      Width = 289
      Height = 17
      Caption = '10.2. '#1057#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088
      TabOrder = 47
    end
    object cbReceipt: TCheckBox
      Tag = 10
      Left = 15
      Top = 467
      Width = 289
      Height = 17
      Caption = '10.1. '#1056#1077#1094#1077#1087#1090#1091#1088#1099
      TabOrder = 48
    end
    object cbContractConditionDocument: TCheckBox
      Left = 15
      Top = 195
      Width = 266
      Height = 17
      Caption = #1059#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072' - '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1053#1040#1051
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 49
    end
    object cbGoodsByGoodsKind: TCheckBox
      Tag = 10
      Left = 15
      Top = 430
      Width = 289
      Height = 17
      Caption = '6.3. '#1057#1074#1103#1079#1080' '#1089' '#1090#1086#1074#1072#1088#1086#1084' ('#1074#1077#1089' '#1091#1087#1072#1082'.)'
      Enabled = False
      TabOrder = 50
    end
    object cbOrderType: TCheckBox
      Tag = 10
      Left = 15
      Top = 446
      Width = 289
      Height = 17
      Caption = '6.4. '#1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1079#1072#1103#1074#1082#1077' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      Enabled = False
      TabOrder = 51
    end
    object cbPartnerIntUpdate: TCheckBox
      Tag = 10
      Left = 15
      Top = 162
      Width = 135
      Height = 17
      Caption = '2.8. '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' Udate'
      Enabled = False
      TabOrder = 52
    end
    object cbPrintKindItem: TCheckBox
      Tag = 10
      Left = 15
      Top = 179
      Width = 135
      Height = 17
      Caption = '2.9. PrintKindItem'
      Enabled = False
      TabOrder = 53
    end
  end
  object DocumentPanel: TPanel
    Left = 712
    Top = 0
    Width = 173
    Height = 664
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 3
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
    object Count_errLabel: TLabel
      Left = 6
      Top = 48
      Width = 49
      Height = 13
      Caption = 'Count_err:'
    end
    object DeadlockLabel: TLabel
      Left = 6
      Top = 77
      Width = 49
      Height = 13
      Caption = 'Deadlock:'
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
      Visible = False
      OnClick = cbAllDocumentClick
    end
    object cbIncomeBN: TCheckBox
      Tag = 20
      Left = -1
      Top = 121
      Width = 235
      Height = 17
      Caption = '1.1. '#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' - '#1041#1053
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object StartDateEdit: TcxDateEdit
      Left = 15
      Top = 18
      TabOrder = 2
      Visible = False
      Width = 90
    end
    object EndDateEdit: TcxDateEdit
      Left = 122
      Top = 18
      TabOrder = 3
      Visible = False
      Width = 90
    end
    object cbIncomePacker: TCheckBox
      Tag = 20
      Left = 6
      Top = 137
      Width = 235
      Height = 17
      Caption = '1.3. '#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1079#1072#1075#1086#1090#1086#1074#1080#1090#1077#1083#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object cbSendUnit: TCheckBox
      Tag = 20
      Left = 3
      Top = 185
      Width = 235
      Height = 17
      Caption = '2.1. '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object cbSendPersonal: TCheckBox
      Tag = 20
      Left = 155
      Top = 218
      Width = 235
      Height = 17
      Caption = '2.2. '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1089' '#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088#1072#1084#1080
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object cbSendUnitBranch: TCheckBox
      Tag = 20
      Left = 3
      Top = 203
      Width = 235
      Height = 17
      Caption = '2.2. '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1089' '#1092#1080#1083#1080#1072#1083#1072#1084#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
    object cbSaleIntNal: TCheckBox
      Tag = 20
      Left = 6
      Top = 226
      Width = 235
      Height = 17
      Caption = '3.1.'#1055#1088#1086#1076'.'#1087#1086#1082'. - '#1053#1040#1051
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      Visible = False
    end
    object cbReturnOutBN: TCheckBox
      Tag = 20
      Left = 12
      Top = 130
      Width = 235
      Height = 17
      Caption = '1.2. '#1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' - '#1041#1053
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
    end
    object cbReturnInIntNal: TCheckBox
      Tag = 20
      Left = -3
      Top = 243
      Width = 228
      Height = 17
      Caption = '3.2.'#1042#1086#1079'.'#1086#1090' '#1087#1086#1082'. - '#1053#1040#1051
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      Visible = False
    end
    object cbProductionUnion: TCheckBox
      Tag = 20
      Left = -3
      Top = 266
      Width = 235
      Height = 17
      Caption = '4.1. '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 11
      Visible = False
    end
    object cbProductionSeparate: TCheckBox
      Tag = 20
      Left = -3
      Top = 282
      Width = 235
      Height = 17
      Caption = '4.2. '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 12
      Visible = False
    end
    object cbLoss: TCheckBox
      Tag = 20
      Left = 6
      Top = 289
      Width = 155
      Height = 17
      Caption = '5.2. '#1057#1087#1080#1089#1072#1085#1080#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 13
      Visible = False
    end
    object cbInventory: TCheckBox
      Tag = 20
      Left = -3
      Top = 305
      Width = 235
      Height = 17
      Caption = '6. '#1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 14
      Visible = False
    end
    object cbOrderExternal: TCheckBox
      Tag = 20
      Left = 6
      Top = 391
      Width = 120
      Height = 17
      Caption = '7.1. '#1047#1072#1103#1074#1082#1080' '#1087#1086#1082#1091#1087'.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 15
      Visible = False
    end
    object cbOnlyInsertDocument: TCheckBox
      Left = 6
      Top = 114
      Width = 235
      Height = 17
      Caption = #1058#1086#1083#1100#1082#1086' '#1085#1086#1074#1099#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 16
      OnClick = cbCompleteClick
    end
    object cbTaxFl: TCheckBox
      Tag = 20
      Left = 175
      Top = 484
      Width = 235
      Height = 17
      Caption = '8.1. '#1053#1072#1083#1086#1075#1086#1074#1099#1077' Fl'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 17
      Visible = False
    end
    object cbTaxCorrective: TCheckBox
      Tag = 20
      Left = 134
      Top = 465
      Width = 235
      Height = 17
      Caption = '8.2. '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080' Fl'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 18
      Visible = False
    end
    object cbReturnInInt: TCheckBox
      Tag = 20
      Left = 3
      Top = 455
      Width = 125
      Height = 17
      Caption = '3.4.'#1042#1086#1079'.'#1086#1090' '#1087#1086#1082'.Int - '#1041#1053
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 19
      Visible = False
    end
    object cbSaleInt: TCheckBox
      Tag = 20
      Left = 3
      Top = 441
      Width = 126
      Height = 17
      Caption = '3.3.'#1055#1088#1086#1076'.'#1087#1086#1082'.Int - '#1041#1053
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 20
      Visible = False
    end
    object OKPOEdit: TEdit
      Left = 6
      Top = 625
      Width = 75
      Height = 21
      TabOrder = 21
    end
    object cbOKPO: TCheckBox
      Left = 3
      Top = 647
      Width = 104
      Height = 17
      Caption = #1058#1086#1083#1100#1082#1086' '#1054#1050#1055#1054
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 22
      Visible = False
    end
    object cbDeleteFl: TCheckBox
      Tag = 20
      Left = 172
      Top = 518
      Width = 235
      Height = 17
      Caption = '3.0.1.'#1059#1076#1072#1083#1077#1085#1080#1077' Fl'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 23
      Visible = False
    end
    object cbDeleteInt: TCheckBox
      Tag = 20
      Left = 3
      Top = 492
      Width = 235
      Height = 17
      Caption = '3.0.2.'#1059#1076#1072#1083#1077#1085#1080#1077' Int'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 24
      Visible = False
    end
    object cbTaxInt: TCheckBox
      Tag = 20
      Left = 3
      Top = 468
      Width = 125
      Height = 17
      Caption = '8.3. '#1053#1072#1083#1086#1075#1086#1074#1099#1077' Int'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 25
      Visible = False
    end
    object cbClearDelete: TCheckBox
      Left = 3
      Top = 479
      Width = 190
      Height = 17
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1088#1086#1090#1086#1082#1086#1083' '#1091#1076#1072#1083#1077#1085#1080#1103
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 26
      Visible = False
    end
    object cbOnlyUpdateInt: TCheckBox
      Left = 3
      Top = 426
      Width = 157
      Height = 17
      Caption = #1058#1086#1083#1100#1082#1086' '#1076#1072#1085#1085#1099#1077' '#1057#1082#1083#1072#1076#1072
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 27
      Visible = False
    end
    object cbErr: TCheckBox
      Left = 159
      Top = 428
      Width = 63
      Height = 17
      Caption = 'Error'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 28
      Visible = False
    end
    object cbTotalTaxCorr: TCheckBox
      Left = 175
      Top = 468
      Width = 63
      Height = 17
      Caption = 'TaxCorr'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 29
      Visible = False
    end
    object cblTaxPF: TCheckBox
      Left = 132
      Top = 414
      Width = 63
      Height = 17
      Caption = 'PF'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 30
      Visible = False
    end
    object cbUpdateConrtact: TCheckBox
      Left = 185
      Top = 61
      Width = 53
      Height = 51
      Caption = #1080#1089#1087#1088#1072#1074#1080#1090#1100' '#1076#1086#1075#1086#1074#1086#1088' '#1041#1053
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 31
      WordWrap = True
    end
    object cbBill_List: TCheckBox
      Left = 3
      Top = 607
      Width = 235
      Height = 17
      Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1087#1086' '#1089#1087#1080#1089#1082#1091' '#1085#1072#1082#1083#1072#1076#1085#1099#1093
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 32
      Visible = False
    end
    object cbIncomeNal: TCheckBox
      Tag = 20
      Left = 14
      Top = 146
      Width = 235
      Height = 17
      Caption = '1.4. '#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' - '#1053#1040#1051
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 33
    end
    object cbReturnOutNal: TCheckBox
      Tag = 20
      Left = 6
      Top = 156
      Width = 235
      Height = 17
      Caption = '1.5. '#1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' - '#1053#1040#1051
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 34
    end
    object cbPartner_Income: TCheckBox
      Tag = 20
      Left = 33
      Top = 169
      Width = 213
      Height = 17
      Caption = '!!!'#1085#1086#1074#1099#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1080'/'#1076#1086#1075#1086#1074#1086#1088#1072' '#1053#1040#1051'!!!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 35
    end
    object cbPartner_Sale: TCheckBox
      Tag = 20
      Left = 25
      Top = 251
      Width = 212
      Height = 17
      Caption = '!!!'#1085#1086#1074#1099#1077' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1080'/'#1076#1086#1075#1086#1074#1086#1088#1072' '#1053#1040#1051'!!!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 36
      Visible = False
    end
    object cbOrderInternal: TCheckBox
      Tag = 20
      Left = -3
      Top = 402
      Width = 120
      Height = 17
      Caption = '7.2. '#1047#1072#1103#1074#1082#1080' '#1087#1088'-'#1074#1086
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 37
      Visible = False
    end
    object cbLossDebt: TCheckBox
      Left = 133
      Top = 493
      Width = 107
      Height = 17
      Caption = #1044#1086#1083#1075#1080' Int-'#1053#1040#1051
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 38
      Visible = False
    end
    object cbCash: TCheckBox
      Tag = 20
      Left = 1
      Top = 415
      Width = 166
      Height = 17
      Caption = '8. '#1050#1072#1089#1089#1072' Int - '#1053#1040#1051
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 39
      Visible = False
    end
    object cbLossGuide: TCheckBox
      Tag = 20
      Left = 108
      Top = 297
      Width = 108
      Height = 24
      Caption = '5.1. !!!'#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1089#1087#1080#1089#1072#1085#1080#1103'!!!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 40
      Visible = False
      WordWrap = True
    end
    object cbWeighingPartner: TCheckBox
      Tag = 20
      Left = 123
      Top = 391
      Width = 120
      Height = 17
      Caption = '9.1. '#1042#1079#1074#1077#1096'.'#1087#1086#1082#1091#1087'.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 41
      Visible = False
    end
    object cbWeighingProduction: TCheckBox
      Tag = 20
      Left = 123
      Top = 398
      Width = 120
      Height = 17
      Caption = '9.2. '#1042#1079#1074#1077#1096'.'#1087#1088'-'#1074#1086
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 42
      Visible = False
    end
    object cbBranchSendOnPrice: TCheckBox
      Left = 137
      Top = 647
      Width = 110
      Height = 17
      Caption = #1050#1086#1076' '#1087'. '#1076#1083#1103' 2.2.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 43
      Visible = False
    end
    object UnitCodeSendOnPriceEdit: TEdit
      Left = 85
      Top = 625
      Width = 87
      Height = 21
      TabOrder = 44
      Text = '22121'
    end
    object cbFillSoldTable: TCheckBox
      Left = 3
      Top = 545
      Width = 104
      Height = 17
      Caption = 'FillSoldTable'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 45
    end
    object cbDocERROR: TCheckBox
      Left = 166
      Top = 402
      Width = 75
      Height = 31
      Caption = #1058#1086#1083#1100#1082#1086' c ERROR'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 46
      Visible = False
      WordWrap = True
    end
    object cbShowContract: TCheckBox
      Left = 159
      Top = 441
      Width = 84
      Height = 31
      Caption = 'only Show Contract'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 47
      Visible = False
      WordWrap = True
    end
    object cbShowAll: TCheckBox
      Left = 159
      Top = 463
      Width = 70
      Height = 14
      Caption = 'Show All'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 48
      Visible = False
      WordWrap = True
    end
    object cbGoodsListSale: TCheckBox
      Left = 3
      Top = 526
      Width = 163
      Height = 17
      Caption = 'GoodsListSale + Income'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 49
    end
    object cbFillAuto: TCheckBox
      Left = 3
      Top = 564
      Width = 105
      Height = 17
      Caption = 'FillAuto 1+2+3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 50
    end
    object BranchEdit: TEdit
      Left = 6
      Top = 586
      Width = 222
      Height = 21
      TabOrder = 51
      Text = 'BranchEdit'
    end
    object cbTransportList: TCheckBox
      Left = 3
      Top = 507
      Width = 171
      Height = 17
      Caption = 'TransportList-PartnerCount'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 52
    end
    object cbHistoryCost_8379: TCheckBox
      Left = 5
      Top = 340
      Width = 150
      Height = 17
      Caption = 'HistoryCost-8379'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 53
    end
    object cbHistoryCost_0: TCheckBox
      Left = 5
      Top = 320
      Width = 150
      Height = 17
      Caption = 'HistoryCost-0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 54
    end
    object cbHistoryCost_8374: TCheckBox
      Left = 5
      Top = 360
      Width = 150
      Height = 17
      Caption = 'HistoryCost-8374'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 55
    end
    object cbHistoryCost_oth: TCheckBox
      Left = 5
      Top = 380
      Width = 150
      Height = 17
      Caption = 'HistoryCost-oth'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 56
    end
    object Count_errEdit: TEdit
      Left = 60
      Top = 45
      Width = 80
      Height = 21
      TabOrder = 57
      Text = '0'
    end
    object DeadlockEdit: TEdit
      Left = 60
      Top = 74
      Width = 80
      Height = 21
      TabOrder = 58
      Text = '0'
    end
  end
  object CompleteDocumentPanel: TPanel
    Left = 885
    Top = 0
    Width = 236
    Height = 664
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 4
    object Label3: TLabel
      Left = 6
      Top = 22
      Width = 6
      Height = 13
      Caption = #1089
    end
    object Label4: TLabel
      Left = 109
      Top = 22
      Width = 12
      Height = 13
      Caption = #1087#1086
    end
    object Label5: TLabel
      Left = 15
      Top = 611
      Width = 95
      Height = 13
      Caption = #1057#1082#1083#1072#1076' '#1056#1077#1072#1083#1080#1079#1072#1094#1080#1080
    end
    object Label6: TLabel
      Left = 127
      Top = 609
      Width = 46
      Height = 13
      Caption = 'SessionId'
    end
    object Label7: TLabel
      Left = 16
      Top = 517
      Width = 106
      Height = 13
      Caption = 'MovementId_start:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cbAllCompleteDocument: TCheckBox
      Tag = 3
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
      OnClick = cbAllCompleteDocumentClick
    end
    object cbCompleteIncomeBN: TCheckBox
      Tag = 30
      Left = 15
      Top = 146
      Width = 194
      Height = 17
      Caption = '1.1. '#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' - '#1041#1053
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = cbCompleteIncomeBNClick
    end
    object StartDateCompleteEdit: TcxDateEdit
      Left = 14
      Top = 18
      TabOrder = 2
      Width = 90
    end
    object EndDateCompleteEdit: TcxDateEdit
      Left = 122
      Top = 18
      TabOrder = 3
      Width = 90
    end
    object cbComplete: TCheckBox
      Left = 15
      Top = 41
      Width = 102
      Height = 17
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = cbCompleteClick
    end
    object cbUnComplete: TCheckBox
      Left = 122
      Top = 41
      Width = 102
      Height = 17
      Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = cbUnCompleteClick
    end
    object cbCompleteSend: TCheckBox
      Tag = 30
      Left = 15
      Top = 215
      Width = 194
      Height = 17
      Caption = '2.1. '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCompleteSendOnPrice: TCheckBox
      Tag = 30
      Left = 15
      Top = 228
      Width = 194
      Height = 17
      Caption = '2.2. '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1089' '#1092#1080#1083#1080#1072#1083#1072#1084#1080
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = cbCompleteIncomeBNClick
    end
    object cbInsertHistoryCost: TCheckBox
      Tag = 100
      Left = 15
      Top = 85
      Width = 194
      Height = 17
      Caption = #1057#1045#1041#1045#1057#1058#1054#1048#1052#1054#1057#1058#1068' '#1087#1086' '#1052#1045#1057#1071#1062#1040#1052
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
    end
    object cbCompleteProductionUnion: TCheckBox
      Tag = 30
      Left = 15
      Top = 267
      Width = 194
      Height = 17
      Caption = '4.1. '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCompleteProductionSeparate: TCheckBox
      Tag = 30
      Left = 15
      Top = 281
      Width = 194
      Height = 17
      Caption = '4.2. '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      OnClick = cbCompleteIncomeBNClick
    end
    object cbLastComplete: TCheckBox
      Left = 15
      Top = 64
      Width = 191
      Height = 17
      Caption = '!!!'#1073#1077#1079' '#1087#1088#1086#1074#1086#1076#1086#1082' C/C!!!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 11
      OnClick = cbUnCompleteClick
    end
    object cbCompleteInventory: TCheckBox
      Tag = 30
      Left = 15
      Top = 309
      Width = 194
      Height = 17
      Caption = '6. '#1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 12
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCompleteSaleIntNal: TCheckBox
      Tag = 30
      Left = 15
      Top = 241
      Width = 200
      Height = 17
      Caption = '3.1.'#1055#1088#1086#1076'.'#1087#1086#1082'. - '#1053#1040#1051
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 13
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCompleteReturnInIntNal: TCheckBox
      Tag = 30
      Left = 15
      Top = 254
      Width = 200
      Height = 17
      Caption = '3.2.'#1042#1086#1079'.'#1086#1090' '#1087#1086#1082'. - '#1053#1040#1051
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 14
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCompleteReturnOutBN: TCheckBox
      Tag = 30
      Left = 15
      Top = 160
      Width = 194
      Height = 17
      Caption = '1.2. '#1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' - '#1041#1053
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 15
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCompleteSaleInt: TCheckBox
      Tag = 30
      Left = 55
      Top = 536
      Width = 34
      Height = 17
      Caption = '3.3.'#1055#1088#1086#1076'.'#1087#1086#1082'.Int - '#1041#1053
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 16
      Visible = False
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCompleteReturnInInt: TCheckBox
      Tag = 30
      Left = 111
      Top = 536
      Width = 37
      Height = 17
      Caption = '3.4.'#1042#1086#1079'.'#1086#1090' '#1087#1086#1082'.Int - '#1041#1053
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 17
      Visible = False
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCompleteTaxFl: TCheckBox
      Tag = 30
      Left = 26
      Top = 497
      Width = 34
      Height = 17
      Caption = '8.1. '#1053#1072#1083#1086#1075#1086#1074#1099#1077' Fl'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 18
      Visible = False
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCompleteTaxCorrective: TCheckBox
      Tag = 30
      Left = 69
      Top = 497
      Width = 36
      Height = 17
      Caption = '8.2. '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080' Fl'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 19
      Visible = False
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCompleteTaxInt: TCheckBox
      Tag = 30
      Left = 128
      Top = 497
      Width = 37
      Height = 17
      Caption = '8.3. '#1053#1072#1083#1086#1075#1086#1074#1099#1077' Int'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 20
      Visible = False
      OnClick = cbCompleteIncomeBNClick
    end
    object cbSelectData_afterLoad: TCheckBox
      Left = 15
      Top = 569
      Width = 176
      Height = 17
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1076#1072#1085#1085#1099#1093' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 21
      WordWrap = True
    end
    object cbSelectData_afterLoad_Sale: TCheckBox
      Left = 15
      Top = 584
      Width = 71
      Height = 17
      Caption = #1055#1088#1086#1076'.'#1087#1086#1082'.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 22
      WordWrap = True
    end
    object cbSelectData_afterLoad_Tax: TCheckBox
      Left = 89
      Top = 584
      Width = 52
      Height = 17
      Caption = #1053#1072#1083#1086#1075
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 23
      WordWrap = True
    end
    object cbSelectData_afterLoad_ReturnIn: TCheckBox
      Left = 147
      Top = 584
      Width = 63
      Height = 17
      Caption = #1042#1086#1079'.'#1087#1086#1082'.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 24
      WordWrap = True
    end
    object UnitIdEdit: TEdit
      Left = 14
      Top = 626
      Width = 98
      Height = 21
      TabOrder = 25
      Text = '8459'
    end
    object cbBeforeSave: TCheckBox
      Left = 15
      Top = 553
      Width = 146
      Height = 17
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 26
    end
    object SessionIdEdit: TEdit
      Left = 128
      Top = 626
      Width = 48
      Height = 21
      TabOrder = 27
      Text = '0'
    end
    object cbCompleteIncomeNal: TCheckBox
      Tag = 30
      Left = 15
      Top = 173
      Width = 194
      Height = 17
      Caption = '1.4. '#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' - '#1053#1040#1051
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 28
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCompleteReturnOutNal: TCheckBox
      Tag = 30
      Left = 15
      Top = 187
      Width = 194
      Height = 17
      Caption = '1.5. '#1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' - '#1053#1040#1051
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 29
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCompleteOrderExternal: TCheckBox
      Tag = 30
      Left = 15
      Top = 323
      Width = 194
      Height = 17
      Caption = '7.1. '#1047#1072#1103#1074#1082#1080' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 30
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCompleteOrderInternal: TCheckBox
      Tag = 30
      Left = 15
      Top = 337
      Width = 194
      Height = 17
      Caption = '7.2. '#1047#1072#1103#1074#1082#1080' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 31
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCompleteCash: TCheckBox
      Tag = 30
      Left = 167
      Top = 335
      Width = 194
      Height = 17
      Caption = '8. '#1050#1072#1089#1089#1072' Int - '#1053#1040#1051
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 32
      Visible = False
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCompleteLoss: TCheckBox
      Tag = 30
      Left = 15
      Top = 295
      Width = 106
      Height = 17
      Caption = '5. '#1057#1087#1080#1089#1072#1085#1080#1077
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 33
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCompleteLossNotError: TCheckBox
      Left = 137
      Top = 295
      Width = 72
      Height = 17
      Caption = 'Not Error'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 34
    end
    object cbComplete_List: TCheckBox
      Tag = 30
      Left = 15
      Top = 482
      Width = 218
      Height = 17
      Caption = '!!! C'#1087#1080#1089#1086#1082' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' !!!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 35
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCompleteIncome_UpdateConrtact: TCheckBox
      Tag = 30
      Left = 15
      Top = 201
      Width = 194
      Height = 17
      Caption = '1.6. '#1048#1089#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072' '#1087#1088#1080#1093#1086#1076
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 36
      OnClick = cbCompleteIncomeBNClick
    end
    object cbInsertHistoryCost_andReComplete: TCheckBox
      Tag = 30
      Left = 15
      Top = 354
      Width = 200
      Height = 17
      Caption = '10. !!!'#1057'/'#1057' + '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077'!!!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 37
      OnClick = cbCompleteIncomeBNClick
    end
    object cbDefroster: TCheckBox
      Tag = 30
      Left = 15
      Top = 403
      Width = 80
      Height = 17
      Caption = #1044#1077#1092#1088#1086#1089#1090#1077#1088
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 38
      OnClick = cbCompleteIncomeBNClick
    end
    object cbPack: TCheckBox
      Tag = 30
      Left = 15
      Top = 421
      Width = 80
      Height = 17
      Caption = #1059#1087#1072#1082#1086#1074#1082#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 39
      OnClick = cbCompleteIncomeBNClick
    end
    object cbKopchenie: TCheckBox
      Tag = 30
      Left = 15
      Top = 440
      Width = 184
      Height = 17
      Caption = #1050#1086#1087#1095#1077#1085#1080#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 40
      OnClick = cbCompleteIncomeBNClick
    end
    object cbPartion: TCheckBox
      Tag = 30
      Left = 15
      Top = 459
      Width = 132
      Height = 17
      Caption = #1055#1072#1088#1090#1080#1080' '#1055#1060'-'#1043#1055
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 41
      OnClick = cbCompleteIncomeBNClick
    end
    object cbHistoryCost_diff: TCheckBox
      Tag = 30
      Left = 15
      Top = 369
      Width = 107
      Height = 17
      Caption = #1089'/'#1089' "'#1054#1082#1088#1091#1075#1083#1077#1085#1080#1103'"'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 42
      OnClick = cbCompleteIncomeBNClick
    end
    object cbLastCost: TCheckBox
      Left = 153
      Top = 473
      Width = 72
      Height = 17
      Caption = '!!!LAST!!!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 43
      Visible = False
    end
    object cb100MSec: TCheckBox
      Left = 153
      Top = 459
      Width = 76
      Height = 17
      Caption = '100MSec'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 44
    end
    object cbOnlySale: TCheckBox
      Tag = 100
      Left = 15
      Top = 104
      Width = 194
      Height = 17
      Caption = #1054#1044#1048#1053' '#1088#1072#1079' '#1042#1052#1045#1057#1058#1045' '#1089' '#1055#1088#1086#1076#1072#1078#1077#1081
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 45
    end
    object cbReturnIn_Auto: TCheckBox
      Tag = 30
      Left = 96
      Top = 421
      Width = 141
      Height = 17
      Caption = #1055#1088#1080#1074#1103#1079#1082#1072' '#1042#1086#1079#1074#1088#1072#1090#1099
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 46
      OnClick = cbCompleteIncomeBNClick
    end
    object cbOnlyTwo: TCheckBox
      Left = 16
      Top = 123
      Width = 217
      Height = 17
      Caption = '!!!'#1058#1054#1051#1068#1050#1054' '#8470'2 ('#1088#1091#1095#1085'. '#1088#1077#1078#1080#1084')!!!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 47
      OnClick = cbUnCompleteClick
    end
    object cbPromo: TCheckBox
      Tag = 30
      Left = 96
      Top = 403
      Width = 141
      Height = 17
      Caption = #1056#1072#1089#1095#1077#1090' '#1072#1082#1094#1080#1081
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 48
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCurrency: TCheckBox
      Tag = 30
      Left = 96
      Top = 385
      Width = 141
      Height = 17
      Caption = #1056#1072#1089#1095#1077#1090' '#1082#1091#1088#1089#1086#1074#1099#1093' '#1088#1072#1079#1085'.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 49
      OnClick = cbCompleteIncomeBNClick
    end
    object cbOnlyTush: TCheckBox
      Left = 97
      Top = 439
      Width = 128
      Height = 17
      Caption = #1058#1086#1083#1100#1082#1086' '#1058#1091#1096#1077#1085#1082#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 50
    end
    object MovementId_startEdit: TEdit
      Left = 128
      Top = 513
      Width = 92
      Height = 21
      TabOrder = 51
      Text = '0'
    end
  end
  object LogPanel: TPanel
    Left = 423
    Top = 0
    Width = 280
    Height = 664
    Align = alRight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    object PanelErr: TPanel
      Left = 1
      Top = 1
      Width = 278
      Height = 38
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnDblClick = PanelErrDblClick
      object EditRepl1: TEdit
        Left = 119
        Top = 17
        Width = 48
        Height = 21
        TabOrder = 0
        Text = '1'
        Visible = False
      end
      object EditRepl2: TEdit
        Left = 170
        Top = 17
        Width = 48
        Height = 21
        TabOrder = 1
        Text = '1000000'
        Visible = False
      end
      object EditRepl3: TEdit
        Left = 98
        Top = -4
        Width = 78
        Height = 21
        TabOrder = 2
        Text = 'Project_master'
        Visible = False
      end
      object cbRepl4: TCheckBox
        Left = 11
        Top = 4
        Width = 80
        Height = 17
        Caption = #1045#1097#1077' test2'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        Visible = False
      end
      object cbSnapshot: TCheckBox
        Left = 12
        Top = 21
        Width = 101
        Height = 17
        Caption = #1076#1083#1103' snapshot'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        Visible = False
        OnClick = cbSnapshotClick
      end
      object EditRepl_offset: TEdit
        Left = 182
        Top = -4
        Width = 48
        Height = 21
        TabOrder = 5
        Text = '0'
        Visible = False
      end
    end
    object LogMemo: TMemo
      Left = 1
      Top = 39
      Width = 278
      Height = 309
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'LogMemo')
      ParentFont = False
      TabOrder = 1
    end
    object LogMemo2: TMemo
      Left = 1
      Top = 348
      Width = 278
      Height = 315
      Align = alBottom
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'LogMemo2')
      ParentFont = False
      TabOrder = 2
      Visible = False
    end
  end
  object DataSource: TDataSource
    DataSet = fromZQuery
    Left = 176
    Top = 184
  end
  object toSqlQuery: TZQuery
    Connection = toZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 88
    Top = 496
  end
  object toStoredProc: TdsdStoredProc
    DataSets = <>
    Params = <>
    PackSize = 1
    Left = 40
    Top = 224
  end
  object toStoredProc_two: TdsdStoredProc
    DataSets = <>
    Params = <>
    PackSize = 1
    Left = 48
    Top = 160
  end
  object toZConnection: TZConnection
    ControlsCodePage = cCP_UTF16
    UTF8StringsAsWideField = True
    Catalog = 'public'
    DesignConnection = True
    HostName = '192.168.0.194'
    Port = 0
    Password = 'sqoII5szOnrcZxJVF1BL'
    Protocol = 'postgresql-9'
    Left = 40
    Top = 328
  end
  object toStoredProc_three: TdsdStoredProc
    DataSets = <>
    Params = <>
    PackSize = 1
    Left = 56
    Top = 96
  end
  object toSqlQuery_two: TZQuery
    Connection = toZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 88
    Top = 544
  end
  object zConnection_vacuum: TZConnection
    ControlsCodePage = cCP_UTF16
    UTF8StringsAsWideField = True
    Catalog = 'public'
    DesignConnection = True
    HostName = '192.168.0.194'
    Port = 0
    Protocol = 'postgresql-9'
    Left = 56
    Top = 384
  end
  object Timer: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = TimerTimer
    Left = 432
    Top = 136
  end
  object fromZQuery: TZQuery
    Connection = fromZConnection
    SQL.Strings = (
      'select DATE_TRUNC ('#39'MONTH'#39', '#39'3.7.2020'#39' :: TDateTime) as RetV')
    Params = <>
    Left = 264
    Top = 272
  end
  object fromSqlZQuery: TZQuery
    Connection = fromZConnection
    Params = <>
    Left = 280
    Top = 328
  end
  object fromZQuery_two: TZQuery
    Connection = fromZConnection
    Params = <>
    Left = 288
    Top = 384
  end
  object fromZQueryDate_recalc: TZQuery
    Connection = fromZConnection
    Params = <>
    Left = 280
    Top = 504
  end
  object fromZQueryDate: TZQuery
    Connection = fromZConnection
    Params = <>
    Left = 272
    Top = 448
  end
  object fromZConnection: TZConnection
    ControlsCodePage = cCP_UTF16
    UTF8StringsAsWideField = True
    Catalog = 'public'
    DesignConnection = True
    HostName = '192.168.0.194'
    Port = 0
    User = 'admin'
    Password = 'sqoII5szOnrcZxJVF1BL'
    Protocol = 'postgresql-9'
    Left = 40
    Top = 272
  end
  object ZConnection_test: TZConnection
    ControlsCodePage = cCP_UTF16
    UTF8StringsAsWideField = True
    Catalog = 'public'
    DesignConnection = True
    Port = 0
    Database = 'pod_test'
    User = 'admin'
    Password = 'sqoII5szOnrcZxJVF1BL'
    Protocol = 'postgresql-9'
    Left = 472
    Top = 360
  end
  object ZQuery_test: TZQuery
    Connection = ZConnection_test
    SQL.Strings = (
      'SELECT * FROM _replica.gpSelect_Replica_union (1 , 594837 * 100)')
    Params = <>
    Left = 536
    Top = 344
  end
  object ZQuery_test2: TZQuery
    Connection = ZConnection_test
    SQL.Strings = (
      'SELECT * FROM gpSelect_Replica_union (1 , 594837 * 100)')
    Params = <>
    Properties.Strings = (
      'SELECT table_update_data.Id'
      ''
      
        ', CASE table_update_data.Operation || '#39'-'#39' || table_update_data.t' +
        'able_name || '#39'-'#39' || COALESCE (table_update_data.upd_cols,table_u' +
        'pdate_data.pk_keys) || '#39'-'#39' || table_update_data.pk_keys '
      ''
      
        ' when '#39'UPDATE-container-{amount}-id'#39' THEN '#39'update container SET ' +
        'amount = '#39'||container.amount ::TVarChar ||'#39' where id = '#39'||contai' +
        'ner.id ::TVarChar'
      ''
      
        ' when '#39'UPDATE-movement-{statusid}-id'#39' THEN '#39'update movement SET ' +
        'statusid = '#39'||movement.statusid ::TVarChar ||'#39' where id = '#39'||mov' +
        'ement.id ::TVarChar'
      ''
      
        ' when '#39'UPDATE-movementfloat-{valuedata}-{descid, movementid}'#39' TH' +
        'EN '#39'update movementfloat SET valuedata = '#39'||movementfloat.valued' +
        'ata ::TVarChar ||'#39' where descid = '#39'||movementfloat.descid ::TVar' +
        'Char||'#39' AND movementid = '#39'||movementfloat.movementid ::TVarChar'
      ''
      
        ' when '#39'UPDATE-movementitem-{amount}-id'#39' THEN '#39'update movementite' +
        'm SET amount = '#39'||movementitem.amount ::TVarChar ||'#39' where id = ' +
        #39'||movementitem.id ::TVarChar'
      ''
      
        ' when '#39'UPDATE-movementitemfloat-{valuedata}-{descid, movementite' +
        'mid}'#39' THEN '#39'update movementitemfloat SET valuedata = '#39'||movement' +
        'itemfloat.valuedata ::TVarChar ||'#39' where descid = '#39'||movementite' +
        'mfloat.descid ::TVarChar||'#39' AND movementitemid = '#39'||movementitem' +
        'float.movementitemid ::TVarChar'
      ''
      
        ' when '#39'UPDATE-movementlinkobject-{objectid}-{descid, movementid}' +
        #39' THEN '#39'update movementlinkobject SET objectid = '#39'||movementlink' +
        'object.objectid ::TVarChar ||'#39' where descid = '#39'||movementlinkobj' +
        'ect.descid ::TVarChar||'#39' AND movementid = '#39'||movementlinkobject.' +
        'movementid ::TVarChar'
      ''
      
        ' when '#39'UPDATE-object-{valuedata}-id'#39' THEN '#39'update object SET val' +
        'uedata = '#39'||object.valuedata ::TVarChar ||'#39' where id = '#39'||object' +
        '.id ::TVarChar'
      ''
      
        ' when '#39'UPDATE-object_partiongoods-{amount}-movementitemid'#39' THEN ' +
        #39'update object_partiongoods SET amount = '#39'||object_partiongoods.' +
        'amount ::TVarChar ||'#39' where movementitemid = '#39'||object_partiongo' +
        'ods.movementitemid ::TVarChar'
      ''
      
        ' when '#39'UPDATE-object_partiongoods-{brandid,partnerid,periodyear}' +
        '-movementitemid'#39' THEN '#39'update object_partiongoods SET brandid = ' +
        #39'||object_partiongoods.brandid ::TVarChar ||'#39', partnerid = '#39'||ob' +
        'ject_partiongoods.partnerid ::TVarChar||'#39' , periodyear = '#39'||obje' +
        'ct_partiongoods.periodyear ::TVarChar||'#39' where movementitemid = ' +
        #39'||object_partiongoods.movementitemid ::TVarChar'
      ''
      
        ' when '#39'UPDATE-object_partiongoods-{brandid,periodid,partnerid}-m' +
        'ovementitemid'#39' THEN '#39'update object_partiongoods SET brandid = '#39'|' +
        '|object_partiongoods.brandid ::TVarChar ||'#39', periodid = '#39'||objec' +
        't_partiongoods.periodid ::TVarChar||'#39' , partnerid = '#39'||object_pa' +
        'rtiongoods.partnerid ::TVarChar||'#39' where movementitemid = '#39'||obj' +
        'ect_partiongoods.movementitemid ::TVarChar'
      ''
      
        ' when '#39'UPDATE-object_partiongoods-{fabrikaid}-movementitemid'#39' TH' +
        'EN '#39'update object_partiongoods SET fabrikaid = '#39'||object_partion' +
        'goods.fabrikaid ::TVarChar ||'#39' where movementitemid = '#39'||object_' +
        'partiongoods.movementitemid ::TVarChar'
      ''
      
        ' when '#39'UPDATE-object_partiongoods-{isarc,amount,iserased}-moveme' +
        'ntitemid'#39' THEN '#39'update object_partiongoods SET isarc = '#39'||object' +
        '_partiongoods.isarc ::TVarChar ||'#39', amount = '#39'||object_partiongo' +
        'ods.amount ::TVarChar||'#39' , iserased = '#39'||object_partiongoods.ise' +
        'rased ::TVarChar||'#39' where movementitemid = '#39'||object_partiongood' +
        's.movementitemid ::TVarChar'
      ''
      
        ' when '#39'UPDATE-object_partiongoods-{isarc,iserased}-movementitemi' +
        'd'#39' THEN '#39'update object_partiongoods SET isarc = '#39'||object_partio' +
        'ngoods.isarc ::TVarChar ||'#39', iserased = '#39'||object_partiongoods.i' +
        'serased ::TVarChar||'#39' where movementitemid = '#39'||object_partiongo' +
        'ods.movementitemid ::TVarChar'
      ''
      
        ' when '#39'UPDATE-object_partiongoods-{operprice,compositionid,operp' +
        'ricelist}-movementitemid'#39' THEN '#39'update object_partiongoods SET o' +
        'perprice = '#39'||object_partiongoods.operprice ::TVarChar ||'#39', comp' +
        'ositionid = '#39'||object_partiongoods.compositionid ::TVarChar||'#39' ,' +
        ' operpricelist = '#39'||object_partiongoods.operpricelist ::TVarChar' +
        '||'#39' where movementitemid = '#39'||object_partiongoods.movementitemid' +
        ' ::TVarChar'
      ''
      
        ' when '#39'UPDATE-object_partiongoods-{operprice,operpricelist}-move' +
        'mentitemid'#39' THEN '#39'update object_partiongoods SET operprice = '#39'||' +
        'object_partiongoods.operprice ::TVarChar ||'#39', operpricelist = '#39'|' +
        '|object_partiongoods.operpricelist ::TVarChar||'#39' where movementi' +
        'temid = '#39'||object_partiongoods.movementitemid ::TVarChar'
      ''
      
        ' when '#39'UPDATE-objectdate-{valuedata}-{descid, objectid}'#39' THEN '#39'u' +
        'pdate objectdate SET valuedata = '#39'||objectdate.valuedata ::TVarC' +
        'har ||'#39' where descid = '#39'||objectdate.descid ::TVarChar||'#39' AND ob' +
        'jectid = '#39'||objectdate.objectid ::TVarChar'
      ''
      
        ' when '#39'UPDATE-objecthistoryfloat-{valuedata}-{descid, objecthist' +
        'oryid}'#39' THEN '#39'update objecthistoryfloat SET valuedata = '#39'||objec' +
        'thistoryfloat.valuedata ::TVarChar ||'#39' where descid = '#39'||objecth' +
        'istoryfloat.descid ::TVarChar||'#39' AND objecthistoryid = '#39'||object' +
        'historyfloat.objecthistoryid ::TVarChar'
      ''
      
        ' when '#39'UPDATE-objectlink-{childobjectid}-{descid, objectid}'#39' THE' +
        'N '#39'update objectlink SET childobjectid = '#39'||objectlink.childobje' +
        'ctid ::TVarChar ||'#39' where descid = '#39'||objectlink.descid ::TVarCh' +
        'ar||'#39' AND objectid = '#39'||objectlink.objectid ::TVarChar'
      ''
      
        ' when '#39'DELETE-movementitemcontainer-id-id'#39' THEN '#39'DELETE FROM  mo' +
        'vementitemcontainer where id = '#39'|| zfCalc_WordText_Split_replica' +
        ' (table_update_data.pk_values, 1) :: TVarChar'
      ''
      
        ' when '#39'INSERT-movementitemcontainer-id-id'#39' THEN '#39'INSERT INTO mov' +
        'ementitemcontainer (id,'#39'||'#39'descid,'#39'||'#39'movementid,'#39'||'#39'containerid' +
        ','#39'||'#39'amount,'#39'||'#39'operdate,'#39'||'#39'movementitemid,'#39'||'#39'parentid,'#39'||'#39'isa' +
        'ctive,'#39'||'#39'movementdescid,'#39'||'#39'analyzerid,'#39'||'#39'accountid,'#39'||'#39'object' +
        'id_analyzer,'#39'||'#39'whereobjectid_analyzer,'#39'||'#39'containerid_analyzer,' +
        #39'||'#39'accountid_analyzer,'#39'||'#39'containerintid_analyzer,'#39'||'#39'objectint' +
        'id_analyzer,'#39'||'#39'objectextid_analyzer,'#39'||'#39'partionid) VALUES ( '#39'||' +
        'CASE WHEN movementitemcontainer.id :: TVarChar IS NULL THEN '#39'NUL' +
        'L'#39' ELSE movementitemcontainer.id :: TVarChar  END||'#39','#39'||CASE WHE' +
        'N movementitemcontainer.descid :: TVarChar IS NULL THEN '#39'NULL'#39' E' +
        'LSE movementitemcontainer.descid :: TVarChar  END||'#39','#39'||CASE WHE' +
        'N movementitemcontainer.movementid :: TVarChar IS NULL THEN '#39'NUL' +
        'L'#39' ELSE movementitemcontainer.movementid :: TVarChar  END||'#39','#39'||' +
        'CASE WHEN movementitemcontainer.containerid :: TVarChar IS NULL ' +
        'THEN '#39'NULL'#39' ELSE movementitemcontainer.containerid :: TVarChar  ' +
        'END||'#39','#39'||CASE WHEN movementitemcontainer.amount :: TVarChar IS ' +
        'NULL THEN '#39'NULL'#39' ELSE movementitemcontainer.amount :: TVarChar  ' +
        'END||'#39','#39'||CASE WHEN movementitemcontainer.operdate :: TVarChar I' +
        'S NULL THEN '#39'NULL'#39' ELSE movementitemcontainer.operdate :: TVarCh' +
        'ar  END||'#39','#39'||CASE WHEN movementitemcontainer.movementitemid :: ' +
        'TVarChar IS NULL THEN '#39'NULL'#39' ELSE movementitemcontainer.movement' +
        'itemid :: TVarChar  END||'#39','#39'||CASE WHEN movementitemcontainer.pa' +
        'rentid :: TVarChar IS NULL THEN '#39'NULL'#39' ELSE movementitemcontaine' +
        'r.parentid :: TVarChar  END||'#39','#39'||CASE WHEN movementitemcontaine' +
        'r.isactive :: TVarChar IS NULL THEN '#39'NULL'#39' ELSE movementitemcont' +
        'ainer.isactive :: TVarChar  END||'#39','#39'||CASE WHEN movementitemcont' +
        'ainer.movementdescid :: TVarChar IS NULL THEN '#39'NULL'#39' ELSE moveme' +
        'ntitemcontainer.movementdescid :: TVarChar  END||'#39','#39'||CASE WHEN ' +
        'movementitemcontainer.analyzerid :: TVarChar IS NULL THEN '#39'NULL'#39 +
        ' ELSE movementitemcontainer.analyzerid :: TVarChar  END||'#39','#39'||CA' +
        'SE WHEN movementitemcontainer.accountid :: TVarChar IS NULL THEN' +
        ' '#39'NULL'#39' ELSE movementitemcontainer.accountid :: TVarChar  END||'#39 +
        ','#39'||CASE WHEN movementitemcontainer.objectid_analyzer :: TVarCha' +
        'r IS NULL THEN '#39'NULL'#39' ELSE movementitemcontainer.objectid_analyz' +
        'er :: TVarChar  END||'#39','#39'||CASE WHEN movementitemcontainer.whereo' +
        'bjectid_analyzer :: TVarChar IS NULL THEN '#39'NULL'#39' ELSE movementit' +
        'emcontainer.whereobjectid_analyzer :: TVarChar  END||'#39','#39'||CASE W' +
        'HEN movementitemcontainer.containerid_analyzer :: TVarChar IS NU' +
        'LL THEN '#39'NULL'#39' ELSE movementitemcontainer.containerid_analyzer :' +
        ': TVarChar  END||'#39','#39'||CASE WHEN movementitemcontainer.accountid_' +
        'analyzer :: TVarChar IS NULL THEN '#39'NULL'#39' ELSE movementitemcontai' +
        'ner.accountid_analyzer :: TVarChar  END||'#39','#39'||CASE WHEN movement' +
        'itemcontainer.containerintid_analyzer :: TVarChar IS NULL THEN '#39 +
        'NULL'#39' ELSE movementitemcontainer.containerintid_analyzer :: TVar' +
        'Char  END||'#39','#39'||CASE WHEN movementitemcontainer.objectintid_anal' +
        'yzer :: TVarChar IS NULL THEN '#39'NULL'#39' ELSE movementitemcontainer.' +
        'objectintid_analyzer :: TVarChar  END||'#39','#39'||CASE WHEN movementit' +
        'emcontainer.objectextid_analyzer :: TVarChar IS NULL THEN '#39'NULL'#39 +
        ' ELSE movementitemcontainer.objectextid_analyzer :: TVarChar  EN' +
        'D||'#39','#39'||CASE WHEN movementitemcontainer.partionid :: TVarChar IS' +
        ' NULL THEN '#39'NULL'#39' ELSE movementitemcontainer.partionid :: TVarCh' +
        'ar  END||'#39')'#39
      ''
      
        ' when '#39'INSERT-movementitemprotocol-id-id'#39' THEN '#39'INSERT INTO move' +
        'mentitemprotocol (id,'#39'||'#39'movementitemid,'#39'||'#39'userid,'#39'||'#39'operdate,' +
        #39'||'#39'protocoldata,'#39'||'#39'isinsert) VALUES ( '#39'||CASE WHEN movementite' +
        'mprotocol.id :: TVarChar IS NULL THEN '#39'NULL'#39' ELSE movementitempr' +
        'otocol.id :: TVarChar  END||'#39','#39'||CASE WHEN movementitemprotocol.' +
        'movementitemid :: TVarChar IS NULL THEN '#39'NULL'#39' ELSE movementitem' +
        'protocol.movementitemid :: TVarChar  END||'#39','#39'||CASE WHEN movemen' +
        'titemprotocol.userid :: TVarChar IS NULL THEN '#39'NULL'#39' ELSE moveme' +
        'ntitemprotocol.userid :: TVarChar  END||'#39','#39'||CASE WHEN movementi' +
        'temprotocol.operdate :: TVarChar IS NULL THEN '#39'NULL'#39' ELSE moveme' +
        'ntitemprotocol.operdate :: TVarChar  END||'#39','#39'||CASE WHEN movemen' +
        'titemprotocol.protocoldata :: TVarChar IS NULL THEN '#39'NULL'#39' ELSE ' +
        'movementitemprotocol.protocoldata :: TVarChar  END||'#39','#39'||CASE WH' +
        'EN movementitemprotocol.isinsert :: TVarChar IS NULL THEN '#39'NULL'#39 +
        ' ELSE movementitemprotocol.isinsert :: TVarChar  END||'#39')'#39
      ''
      
        ' when '#39'INSERT-movementprotocol-id-id'#39' THEN '#39'INSERT INTO movement' +
        'protocol (id,'#39'||'#39'movementid,'#39'||'#39'userid,'#39'||'#39'operdate,'#39'||'#39'protocol' +
        'data,'#39'||'#39'isinsert) VALUES ( '#39'||CASE WHEN movementprotocol.id :: ' +
        'TVarChar IS NULL THEN '#39'NULL'#39' ELSE movementprotocol.id :: TVarCha' +
        'r  END||'#39','#39'||CASE WHEN movementprotocol.movementid :: TVarChar I' +
        'S NULL THEN '#39'NULL'#39' ELSE movementprotocol.movementid :: TVarChar ' +
        ' END||'#39','#39'||CASE WHEN movementprotocol.userid :: TVarChar IS NULL' +
        ' THEN '#39'NULL'#39' ELSE movementprotocol.userid :: TVarChar  END||'#39','#39'|' +
        '|CASE WHEN movementprotocol.operdate :: TVarChar IS NULL THEN '#39'N' +
        'ULL'#39' ELSE movementprotocol.operdate :: TVarChar  END||'#39','#39'||CASE ' +
        'WHEN movementprotocol.protocoldata :: TVarChar IS NULL THEN '#39'NUL' +
        'L'#39' ELSE movementprotocol.protocoldata :: TVarChar  END||'#39','#39'||CAS' +
        'E WHEN movementprotocol.isinsert :: TVarChar IS NULL THEN '#39'NULL'#39 +
        ' ELSE movementprotocol.isinsert :: TVarChar  END||'#39')'#39
      ''
      
        ' when '#39'INSERT-object-id-id'#39' THEN '#39'INSERT INTO object (id,'#39'||'#39'des' +
        'cid,'#39'||'#39'objectcode,'#39'||'#39'valuedata,'#39'||'#39'accesskeyid,'#39'||'#39'iserased) V' +
        'ALUES ( '#39'||CASE WHEN object.id :: TVarChar IS NULL THEN '#39'NULL'#39' E' +
        'LSE object.id :: TVarChar  END||'#39','#39'||CASE WHEN object.descid :: ' +
        'TVarChar IS NULL THEN '#39'NULL'#39' ELSE object.descid :: TVarChar  END' +
        '||'#39','#39'||CASE WHEN object.objectcode :: TVarChar IS NULL THEN '#39'NUL' +
        'L'#39' ELSE object.objectcode :: TVarChar  END||'#39','#39'||CASE WHEN objec' +
        't.valuedata :: TVarChar IS NULL THEN '#39'NULL'#39' ELSE object.valuedat' +
        'a :: TVarChar  END||'#39','#39'||CASE WHEN object.accesskeyid :: TVarCha' +
        'r IS NULL THEN '#39'NULL'#39' ELSE object.accesskeyid :: TVarChar  END||' +
        #39','#39'||CASE WHEN object.iserased :: TVarChar IS NULL THEN '#39'NULL'#39' E' +
        'LSE object.iserased :: TVarChar  END||'#39')'#39
      ''
      
        ' when '#39'INSERT-objectprotocol-id-id'#39' THEN '#39'INSERT INTO objectprot' +
        'ocol (id,'#39'||'#39'objectid,'#39'||'#39'userid,'#39'||'#39'operdate,'#39'||'#39'protocoldata,'#39 +
        '||'#39'isinsert) VALUES ( '#39'||CASE WHEN objectprotocol.id :: TVarChar' +
        ' IS NULL THEN '#39'NULL'#39' ELSE objectprotocol.id :: TVarChar  END||'#39',' +
        #39'||CASE WHEN objectprotocol.objectid :: TVarChar IS NULL THEN '#39'N' +
        'ULL'#39' ELSE objectprotocol.objectid :: TVarChar  END||'#39','#39'||CASE WH' +
        'EN objectprotocol.userid :: TVarChar IS NULL THEN '#39'NULL'#39' ELSE ob' +
        'jectprotocol.userid :: TVarChar  END||'#39','#39'||CASE WHEN objectproto' +
        'col.operdate :: TVarChar IS NULL THEN '#39'NULL'#39' ELSE objectprotocol' +
        '.operdate :: TVarChar  END||'#39','#39'||CASE WHEN objectprotocol.protoc' +
        'oldata :: TVarChar IS NULL THEN '#39'NULL'#39' ELSE objectprotocol.proto' +
        'coldata :: TVarChar  END||'#39','#39'||CASE WHEN objectprotocol.isinsert' +
        ' :: TVarChar IS NULL THEN '#39'NULL'#39' ELSE objectprotocol.isinsert ::' +
        ' TVarChar  END||'#39')'#39
      ''
      ' END :: TVarChar AS RESULT'
      ''
      ', table_update_data.*'
      ''
      'FROM _replica.table_update_data'
      ''
      
        'LEFT JOIN movement ON movement.id = CASE WHEN '#39'movement'#39'= table_' +
        'update_data.table_name THEN zfCalc_WordText_Split_replica (table' +
        '_update_data.pk_values,1)::Integer ELSE NULL END'
      ''
      
        'LEFT JOIN movementitemcontainer ON movementitemcontainer.id = CA' +
        'SE WHEN '#39'movementitemcontainer'#39'= table_update_data.table_name TH' +
        'EN zfCalc_WordText_Split_replica (table_update_data.pk_values,1)' +
        '::Integer ELSE NULL END'
      ''
      
        'LEFT JOIN object_partiongoods ON object_partiongoods.movementite' +
        'mid = CASE WHEN '#39'object_partiongoods'#39'= table_update_data.table_n' +
        'ame THEN zfCalc_WordText_Split_replica (table_update_data.pk_val' +
        'ues,1)::Integer ELSE NULL END'
      ''
      
        'LEFT JOIN objecthistoryfloat ON objecthistoryfloat.descid = CASE' +
        ' WHEN '#39'objecthistoryfloat'#39'= table_update_data.table_name THEN zf' +
        'Calc_WordText_Split_replica (table_update_data.pk_values,1)::Int' +
        'eger ELSE NULL END AND objecthistoryfloat.objecthistoryid = CASE' +
        ' WHEN '#39'objecthistoryfloat'#39'= table_update_data.table_name THEN zf' +
        'Calc_WordText_Split_replica (table_update_data.pk_values, 2) ::I' +
        'nteger ELSE NULL END'
      ''
      
        'LEFT JOIN object ON object.id = CASE WHEN '#39'object'#39'= table_update' +
        '_data.table_name THEN zfCalc_WordText_Split_replica (table_updat' +
        'e_data.pk_values,1)::Integer ELSE NULL END'
      ''
      
        'LEFT JOIN movementitem ON movementitem.id = CASE WHEN '#39'movementi' +
        'tem'#39'= table_update_data.table_name THEN zfCalc_WordText_Split_re' +
        'plica (table_update_data.pk_values,1)::Integer ELSE NULL END'
      ''
      
        'LEFT JOIN container ON container.id = CASE WHEN '#39'container'#39'= tab' +
        'le_update_data.table_name THEN zfCalc_WordText_Split_replica (ta' +
        'ble_update_data.pk_values,1)::Integer ELSE NULL END'
      ''
      
        'LEFT JOIN objectlink ON objectlink.descid = CASE WHEN '#39'objectlin' +
        'k'#39'= table_update_data.table_name THEN zfCalc_WordText_Split_repl' +
        'ica (table_update_data.pk_values,1)::Integer ELSE NULL END AND o' +
        'bjectlink.objectid = CASE WHEN '#39'objectlink'#39'= table_update_data.t' +
        'able_name THEN zfCalc_WordText_Split_replica (table_update_data.' +
        'pk_values, 2) ::Integer ELSE NULL END'
      ''
      
        'LEFT JOIN movementlinkobject ON movementlinkobject.descid = CASE' +
        ' WHEN '#39'movementlinkobject'#39'= table_update_data.table_name THEN zf' +
        'Calc_WordText_Split_replica (table_update_data.pk_values,1)::Int' +
        'eger ELSE NULL END AND movementlinkobject.movementid = CASE WHEN' +
        ' '#39'movementlinkobject'#39'= table_update_data.table_name THEN zfCalc_' +
        'WordText_Split_replica (table_update_data.pk_values, 2) ::Intege' +
        'r ELSE NULL END'
      ''
      
        'LEFT JOIN objectdate ON objectdate.descid = CASE WHEN '#39'objectdat' +
        'e'#39'= table_update_data.table_name THEN zfCalc_WordText_Split_repl' +
        'ica (table_update_data.pk_values,1)::Integer ELSE NULL END AND o' +
        'bjectdate.objectid = CASE WHEN '#39'objectdate'#39'= table_update_data.t' +
        'able_name THEN zfCalc_WordText_Split_replica (table_update_data.' +
        'pk_values, 2) ::Integer ELSE NULL END'
      ''
      
        'LEFT JOIN movementfloat ON movementfloat.descid = CASE WHEN '#39'mov' +
        'ementfloat'#39'= table_update_data.table_name THEN zfCalc_WordText_S' +
        'plit_replica (table_update_data.pk_values,1)::Integer ELSE NULL ' +
        'END AND movementfloat.movementid = CASE WHEN '#39'movementfloat'#39'= ta' +
        'ble_update_data.table_name THEN zfCalc_WordText_Split_replica (t' +
        'able_update_data.pk_values, 2) ::Integer ELSE NULL END'
      ''
      
        'LEFT JOIN objectprotocol ON objectprotocol.id = CASE WHEN '#39'objec' +
        'tprotocol'#39'= table_update_data.table_name THEN zfCalc_WordText_Sp' +
        'lit_replica (table_update_data.pk_values,1)::Integer ELSE NULL E' +
        'ND'
      ''
      
        'LEFT JOIN movementitemfloat ON movementitemfloat.descid = CASE W' +
        'HEN '#39'movementitemfloat'#39'= table_update_data.table_name THEN zfCal' +
        'c_WordText_Split_replica (table_update_data.pk_values,1)::Intege' +
        'r ELSE NULL END AND movementitemfloat.movementitemid = CASE WHEN' +
        ' '#39'movementitemfloat'#39'= table_update_data.table_name THEN zfCalc_W' +
        'ordText_Split_replica (table_update_data.pk_values, 2) ::Integer' +
        ' ELSE NULL END'
      ''
      
        'LEFT JOIN movementprotocol ON movementprotocol.id = CASE WHEN '#39'm' +
        'ovementprotocol'#39'= table_update_data.table_name THEN zfCalc_WordT' +
        'ext_Split_replica (table_update_data.pk_values,1)::Integer ELSE ' +
        'NULL END'
      ''
      
        'LEFT JOIN movementitemprotocol ON movementitemprotocol.id = CASE' +
        ' WHEN '#39'movementitemprotocol'#39'= table_update_data.table_name THEN ' +
        'zfCalc_WordText_Split_replica (table_update_data.pk_values,1)::I' +
        'nteger ELSE NULL END'
      ''
      
        'LEFT JOIN gpSelect_Replica_Column(785413,1000000 ) AS tmpColumn ' +
        'ON tmpColumn.Table_Name = table_update_data.Table_Name'
      ''
      'WHERE table_update_data.Id BETWEEN 785413 AND 1000000'
      ''
      'ORDER BY table_update_data.Id')
    Left = 552
    Top = 392
  end
  object Timer_Auto_PrimeCost: TTimer
    Enabled = False
    Interval = 20000
    OnTimer = Timer_Auto_PrimeCostTimer
    Left = 344
    Top = 48
  end
  object ActionList: TActionList
    Left = 192
    Top = 352
    object actSendTelegramBot: TdsdSendTelegramBotAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actSendTelegramBot'
      BaseURLParam.Value = 'https://api.telegram.org'
      BaseURLParam.DataType = ftString
      BaseURLParam.MultiSelectSeparator = ','
      Token.Value = ''
      Token.DataType = ftString
      Token.MultiSelectSeparator = ','
      ChatId.Value = ''
      ChatId.DataType = ftString
      ChatId.MultiSelectSeparator = ','
      isSeend.Value = True
      isSeend.DataType = ftBoolean
      isSeend.MultiSelectSeparator = ','
      isErroeSend.Value = False
      isErroeSend.DataType = ftBoolean
      isErroeSend.MultiSelectSeparator = ','
      Error.Value = ''
      Error.DataType = ftString
      Error.MultiSelectSeparator = ','
      Message.Value = ''
      Message.DataType = ftString
      Message.MultiSelectSeparator = ','
    end
  end
  object toSqlQuery_three: TZQuery
    Connection = toZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 152
    Top = 552
  end
end
