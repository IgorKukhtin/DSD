object MainForm: TMainForm
  Left = 202
  Top = 180
  Caption = 'MainForm'
  ClientHeight = 720
  ClientWidth = 1020
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
    Width = 249
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
    Width = 1020
    Height = 56
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 1240
    object Gauge: TGauge
      Left = 0
      Top = 0
      Width = 1240
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
      Top = 26
      Width = 137
      Height = 25
      Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1077#1081#1089#1090#1074#1080#1077
      TabOrder = 1
      OnClick = StopButtonClick
    end
    object CloseButton: TButton
      Left = 654
      Top = 27
      Width = 87
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
      Left = 178
      Top = 25
      Width = 135
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      TabOrder = 5
      OnClick = OKDocumentButtonClick
    end
    object OKCompleteDocumentButton: TButton
      Left = 326
      Top = 25
      Width = 151
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
  end
  object GuidePanel: TPanel
    Left = 249
    Top = 0
    Width = 321
    Height = 664
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitLeft = 469
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
      Top = 128
      Width = 138
      Height = 17
      Caption = '2.2. '#1042#1080#1076#1099' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
      Enabled = False
      TabOrder = 6
    end
    object cbContractFl: TCheckBox
      Tag = 10
      Left = 15
      Top = 148
      Width = 138
      Height = 17
      Caption = '2.3. '#1044#1086#1075#1086#1074#1086#1088#1072' Fl'
      Enabled = False
      TabOrder = 7
    end
    object cbJuridicalBranchNal: TCheckBox
      Tag = 10
      Left = 15
      Top = 224
      Width = 225
      Height = 17
      Caption = '3.2.2. '#1070#1088'.'#1083#1080#1094#1072' '#1060#1080#1083#1080#1072#1083'-'#1053#1072#1083
      Enabled = False
      TabOrder = 8
    end
    object cbPartnerBranchNal: TCheckBox
      Tag = 10
      Left = 15
      Top = 240
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
      Top = 168
      Width = 168
      Height = 17
      Caption = '2.7. '#1057#1086#1088#1090#1080#1088#1086#1074#1082#1080' '#1052#1072#1088#1096#1088#1091#1090#1086#1074
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
      Top = 240
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
      TabOrder = 39
    end
    object cbJuridicalInt: TCheckBox
      Tag = 10
      Left = 151
      Top = 108
      Width = 225
      Height = 17
      Caption = '2.4. '#1070#1088'.'#1083#1080#1094#1072' Int'
      TabOrder = 40
    end
    object cbPartnerInt: TCheckBox
      Tag = 10
      Left = 156
      Top = 145
      Width = 146
      Height = 17
      Caption = '2.6. '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' Int'
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
      Top = 209
      Width = 290
      Height = 17
      Caption = '3.2.1. 1Find+2Insert : Partner1C_BranchNal'
      Enabled = False
      TabOrder = 43
    end
    object cbJuridicalGroup: TCheckBox
      Tag = 10
      Left = 196
      Top = 224
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
      TabOrder = 45
    end
    object cbQuality: TCheckBox
      Tag = 10
      Left = 15
      Top = 504
      Width = 289
      Height = 17
      Caption = '11.1. '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074'.'
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
      Top = 187
      Width = 266
      Height = 17
      Caption = #1059#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072' - '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1053#1040#1051
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
      TabOrder = 50
    end
    object cbOrderType: TCheckBox
      Tag = 10
      Left = 15
      Top = 446
      Width = 289
      Height = 17
      Caption = '6.4. '#1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1079#1072#1103#1074#1082#1077' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      TabOrder = 51
    end
    object cbPartnerIntUpdate: TCheckBox
      Tag = 10
      Left = 15
      Top = 167
      Width = 135
      Height = 17
      Caption = '2.8. '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' Udate'
      TabOrder = 52
    end
  end
  object DocumentPanel: TPanel
    Left = 570
    Top = 0
    Width = 238
    Height = 664
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitLeft = 790
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
    object cbIncomeBN: TCheckBox
      Tag = 20
      Left = 3
      Top = 61
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
      Width = 90
    end
    object EndDateEdit: TcxDateEdit
      Left = 122
      Top = 18
      TabOrder = 3
      Width = 90
    end
    object cbIncomePacker: TCheckBox
      Tag = 20
      Left = 3
      Top = 99
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
      Left = 3
      Top = 233
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
    end
    object cbReturnOutBN: TCheckBox
      Tag = 20
      Left = 3
      Top = 79
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
      Left = 3
      Top = 252
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
    end
    object cbProductionUnion: TCheckBox
      Tag = 20
      Left = 3
      Top = 299
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
    end
    object cbProductionSeparate: TCheckBox
      Tag = 20
      Left = 3
      Top = 319
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
    end
    object cbLoss: TCheckBox
      Tag = 20
      Left = 3
      Top = 342
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
    end
    object cbInventory: TCheckBox
      Tag = 20
      Left = 3
      Top = 365
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
    end
    object cbOrderExternal: TCheckBox
      Tag = 20
      Left = 3
      Top = 392
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
    end
    object cbOnlyInsertDocument: TCheckBox
      Left = 3
      Top = 41
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
      Left = 175
      Top = 499
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
      Top = 498
      Width = 235
      Height = 17
      Caption = '3.4.'#1042#1086#1079'.'#1086#1090' '#1087#1086#1082'.Int - '#1041#1053
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 19
    end
    object cbSaleInt: TCheckBox
      Tag = 20
      Left = 6
      Top = 478
      Width = 235
      Height = 17
      Caption = '3.3.'#1055#1088#1086#1076'.'#1087#1086#1082'.Int - '#1041#1053
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 20
    end
    object OKPOEdit: TEdit
      Left = 3
      Top = 640
      Width = 104
      Height = 21
      TabOrder = 21
    end
    object cbOKPO: TCheckBox
      Left = 3
      Top = 621
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
    end
    object cbDeleteFl: TCheckBox
      Tag = 20
      Left = 175
      Top = 515
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
      Top = 571
      Width = 235
      Height = 17
      Caption = '3.0.2.'#1059#1076#1072#1083#1077#1085#1080#1077' Int'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 24
    end
    object cbTaxInt: TCheckBox
      Tag = 20
      Left = 3
      Top = 522
      Width = 143
      Height = 17
      Caption = '8.3. '#1053#1072#1083#1086#1075#1086#1074#1099#1077' Int'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 25
    end
    object cbClearDelete: TCheckBox
      Left = 3
      Top = 550
      Width = 235
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
    end
    object cbOnlyUpdateInt: TCheckBox
      Left = 3
      Top = 461
      Width = 235
      Height = 17
      Caption = #1058#1086#1083#1100#1082#1086' '#1076#1072#1085#1085#1099#1077' '#1057#1082#1083#1072#1076#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 27
    end
    object cbErr: TCheckBox
      Left = 175
      Top = 475
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
      Top = 487
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
      Left = 175
      Top = 501
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
      Top = 598
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
    end
    object cbIncomeNal: TCheckBox
      Tag = 20
      Left = 6
      Top = 118
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
      Left = 3
      Top = 140
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
      Left = 25
      Top = 160
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
      Top = 271
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
    end
    object cbOrderInternal: TCheckBox
      Tag = 20
      Left = 3
      Top = 411
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
    end
    object cbLossDebt: TCheckBox
      Left = 133
      Top = 570
      Width = 107
      Height = 17
      Caption = #1044#1086#1083#1075#1080' Int-'#1053#1040#1051
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 38
    end
    object cbCash: TCheckBox
      Tag = 20
      Left = 3
      Top = 436
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
    end
    object cbLossGuide: TCheckBox
      Tag = 20
      Left = 132
      Top = 341
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
      WordWrap = True
    end
    object cbWeighingPartner: TCheckBox
      Tag = 20
      Left = 120
      Top = 392
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
    end
    object cbWeighingProduction: TCheckBox
      Tag = 20
      Left = 120
      Top = 411
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
    end
    object cbBranchSendOnPrice: TCheckBox
      Left = 137
      Top = 621
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
    end
    object UnitCodeSendOnPriceEdit: TEdit
      Left = 129
      Top = 640
      Width = 104
      Height = 21
      TabOrder = 44
      Text = '22121'
    end
    object cbFillSoldTable: TCheckBox
      Left = 133
      Top = 531
      Width = 98
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
  end
  object CompleteDocumentPanel: TPanel
    Left = 808
    Top = 0
    Width = 212
    Height = 664
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 4
    ExplicitLeft = 1028
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
      Top = 623
      Width = 95
      Height = 13
      Caption = #1057#1082#1083#1072#1076' '#1056#1077#1072#1083#1080#1079#1072#1094#1080#1080
    end
    object Label6: TLabel
      Left = 127
      Top = 623
      Width = 46
      Height = 13
      Caption = 'SessionId'
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
      Top = 101
      Width = 194
      Height = 17
      Caption = '1.1. '#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' - '#1041#1053
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
      Top = 206
      Width = 194
      Height = 17
      Caption = '2.1. '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
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
      Top = 224
      Width = 194
      Height = 17
      Caption = '2.2. '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1089' '#1092#1080#1083#1080#1072#1083#1072#1084#1080
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
      Top = 81
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
      Top = 299
      Width = 194
      Height = 17
      Caption = '4.1. '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077
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
      Top = 319
      Width = 194
      Height = 17
      Caption = '4.2. '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
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
      Top = 61
      Width = 191
      Height = 17
      Caption = '!!!'#1073#1077#1079' '#1087#1088#1086#1074#1086#1076#1086#1082' C/C!!!'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      State = cbChecked
      TabOrder = 11
      OnClick = cbUnCompleteClick
    end
    object cbCompleteInventory: TCheckBox
      Tag = 30
      Left = 15
      Top = 370
      Width = 194
      Height = 17
      Caption = '6. '#1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
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
      Top = 251
      Width = 200
      Height = 17
      Caption = '3.1.'#1055#1088#1086#1076'.'#1087#1086#1082'. - '#1053#1040#1051
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
      Top = 269
      Width = 200
      Height = 17
      Caption = '3.2.'#1042#1086#1079'.'#1086#1090' '#1087#1086#1082'. - '#1053#1040#1051
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
      Top = 119
      Width = 194
      Height = 17
      Caption = '1.2. '#1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' - '#1041#1053
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
      Left = 15
      Top = 480
      Width = 200
      Height = 17
      Caption = '3.3.'#1055#1088#1086#1076'.'#1087#1086#1082'.Int - '#1041#1053
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 16
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCompleteReturnInInt: TCheckBox
      Tag = 30
      Left = 15
      Top = 498
      Width = 200
      Height = 17
      Caption = '3.4.'#1042#1086#1079'.'#1086#1090' '#1087#1086#1082'.Int - '#1041#1053
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 17
      OnClick = cbCompleteIncomeBNClick
    end
    object cbCompleteTaxFl: TCheckBox
      Tag = 30
      Left = 162
      Top = 482
      Width = 194
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
      Left = 162
      Top = 498
      Width = 194
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
      Left = 15
      Top = 522
      Width = 194
      Height = 17
      Caption = '8.3. '#1053#1072#1083#1086#1075#1086#1074#1099#1077' Int'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 20
      OnClick = cbCompleteIncomeBNClick
    end
    object cbSelectData_afterLoad: TCheckBox
      Left = 15
      Top = 577
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
      Top = 603
      Width = 71
      Height = 17
      Caption = #1055#1088#1086#1076'.'#1087#1086#1082'.'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 22
      WordWrap = True
    end
    object cbSelectData_afterLoad_Tax: TCheckBox
      Left = 89
      Top = 603
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
      Top = 603
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
      Left = 15
      Top = 637
      Width = 98
      Height = 21
      TabOrder = 25
      Text = '8459'
    end
    object cbBeforeSave: TCheckBox
      Left = 15
      Top = 558
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
      Left = 127
      Top = 637
      Width = 48
      Height = 21
      TabOrder = 27
      Text = '0'
    end
    object cbCompleteIncomeNal: TCheckBox
      Tag = 30
      Left = 15
      Top = 137
      Width = 194
      Height = 17
      Caption = '1.4. '#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' - '#1053#1040#1051
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
      Top = 156
      Width = 194
      Height = 17
      Caption = '1.5. '#1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' - '#1053#1040#1051
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
      Top = 393
      Width = 194
      Height = 17
      Caption = '7.1. '#1047#1072#1103#1074#1082#1080' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081
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
      Top = 410
      Width = 194
      Height = 17
      Caption = '7.2. '#1047#1072#1103#1074#1082#1080' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
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
      Left = 151
      Top = 438
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
      Top = 350
      Width = 106
      Height = 17
      Caption = '5. '#1057#1087#1080#1089#1072#1085#1080#1077
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
      Top = 350
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
      Top = 456
      Width = 184
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
      Left = 16
      Top = 178
      Width = 194
      Height = 17
      Caption = '1.6. '#1048#1089#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072' '#1087#1088#1080#1093#1086#1076
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
      Top = 433
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
  end
  object DataSource: TDataSource
    DataSet = fromQuery
    Left = 248
    Top = 192
  end
  object fromADOConnection: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Password=qazqazint;Persist Security Info=True' +
      ';User ID=dba_adm;Data Source=v9ProfiMeatingDS'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 344
    Top = 248
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
    Top = 320
  end
  object toSqlQuery: TZQuery
    Connection = toZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 168
    Top = 416
  end
  object toStoredProc: TdsdStoredProc
    DataSets = <>
    Params = <>
    PackSize = 1
    Left = 128
    Top = 248
  end
  object toStoredProc_two: TdsdStoredProc
    DataSets = <>
    Params = <>
    PackSize = 1
    Left = 120
    Top = 160
  end
  object fromQuery_two: TADOQuery
    Connection = fromADOConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from Goods where HasChildren<>-1 order by 1 desc')
    Left = 312
    Top = 384
  end
  object toZConnection: TZConnection
    ControlsCodePage = cCP_UTF16
    UTF8StringsAsWideField = True
    Catalog = 'public'
    DesignConnection = True
    HostName = 'localhost'
    Port = 0
    Database = 'project'
    User = 'postgres'
    Password = 'postgres'
    Protocol = 'postgresql-9'
    Left = 144
    Top = 360
  end
  object fromFlADOConnection: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Password=qazqazflo;Persist Security Info=True' +
      ';User ID=dba;Data Source=v9_2ProfiMeatingDS'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 320
    Top = 72
  end
  object fromFlQuery: TADOQuery
    Connection = fromFlADOConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from Goods where HasChildren<>-1 order by 1 desc')
    Left = 312
    Top = 128
  end
  object fromFlSqlQuery: TADOQuery
    Connection = fromFlADOConnection
    Parameters = <>
    Left = 376
    Top = 118
  end
  object toStoredProc_three: TdsdStoredProc
    DataSets = <>
    Params = <>
    PackSize = 1
    Left = 120
    Top = 112
  end
  object toSqlQuery_two: TZQuery
    Connection = toZConnection
    SQL.Strings = (
      'select  * from Object')
    Params = <>
    Properties.Strings = (
      'select * from Object order by 1 desc')
    Left = 168
    Top = 464
  end
  object fromQueryDate: TADOQuery
    Connection = fromADOConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from Goods where HasChildren<>-1 order by 1 desc')
    Left = 320
    Top = 504
  end
end
