object MainForm: TMainForm
  Left = 202
  Top = 180
  Caption = 'LoadBoutique - MainForm'
  ClientHeight = 560
  ClientWidth = 1025
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
  object Splitter1: TSplitter
    Left = 442
    Top = 0
    Height = 496
    Align = alRight
    ExplicitLeft = 683
    ExplicitTop = 32
    ExplicitHeight = 409
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 0
    Width = 442
    Height = 496
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
    Top = 496
    Width = 1025
    Height = 64
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    OnDblClick = ButtonPanelDblClick
    object Gauge: TGauge
      Left = 0
      Top = 0
      Width = 1025
      Height = 19
      Align = alTop
      Progress = 50
      ExplicitWidth = 1307
    end
    object OKGuideButton: TButton
      Left = 8
      Top = 25
      Width = 135
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      TabOrder = 0
      OnClick = OKGuideButtonClick
    end
    object StopButton: TButton
      Left = 454
      Top = 25
      Width = 137
      Height = 25
      Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1077#1081#1089#1090#1074#1080#1077
      TabOrder = 1
      OnClick = StopButtonClick
    end
    object CloseButton: TButton
      Left = 597
      Top = 25
      Width = 87
      Height = 25
      Caption = #1042#1099#1093#1086#1076
      TabOrder = 2
      OnClick = CloseButtonClick
    end
    object cbOnlyOpen: TCheckBox
      Left = 712
      Top = 24
      Width = 173
      Height = 17
      Caption = #1054#1090#1082#1083#1102#1095#1080#1090#1100' ('#1090#1086#1083#1100#1082#1086' '#1087#1088#1086#1089#1084#1086#1090#1088')'
      TabOrder = 3
    end
    object OKDocumentButton: TButton
      Left = 149
      Top = 25
      Width = 135
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      TabOrder = 4
      OnClick = OKDocumentButtonClick
    end
    object OKCompleteDocumentButton: TButton
      Left = 297
      Top = 25
      Width = 151
      Height = 25
      Caption = #1055#1088#1086#1074#1086#1076#1082#1080' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      TabOrder = 5
      OnClick = OKCompleteDocumentButtonClick
    end
    object cbOnlyOpenMIMaster: TCheckBox
      Left = 891
      Top = 25
      Width = 117
      Height = 17
      Caption = #1090#1086#1083#1100#1082#1086' MI - Master'
      TabOrder = 6
    end
    object сbNotVisibleCursor: TCheckBox
      Left = 712
      Top = 41
      Width = 150
      Height = 17
      Caption = #1057#1082#1088#1099#1074#1072#1090#1100' '#1082#1091#1088#1089#1086#1088' '#1075#1088#1080#1076#1072
      TabOrder = 7
      OnClick = сbNotVisibleCursorClick
    end
    object cbOnlyOpenMIChild: TCheckBox
      Left = 891
      Top = 42
      Width = 117
      Height = 17
      Caption = #1090#1086#1083#1100#1082#1086' MI - Child'
      TabOrder = 8
    end
  end
  object PageControl1: TPageControl
    Left = 445
    Top = 0
    Width = 580
    Height = 496
    ActivePage = TabSheet1
    Align = alRight
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080' - '#1044#1086#1082#1091#1084#1077#1085#1090#1099
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GuidePanel: TPanel
        Left = 0
        Top = 0
        Width = 182
        Height = 468
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object cbAllGuide: TCheckBox
          Tag = 1
          Left = 15
          Top = 1
          Width = 122
          Height = 17
          Caption = #1042#1089#1077' '#1089#1087#1088#1072#1074'.'
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
        object cbComposition: TCheckBox
          Tag = 10
          Left = 15
          Top = 47
          Width = 122
          Height = 17
          Caption = '1.3. '#1057#1086#1089#1090#1072#1074' '#1090#1086#1074#1072#1088#1072
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
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
          TabOrder = 4
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
          TabOrder = 5
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
          TabOrder = 6
        end
        object cbLineFabrica: TCheckBox
          Tag = 10
          Left = 15
          Top = 111
          Width = 194
          Height = 17
          Caption = '1.7. '#1051#1080#1085#1080#1103' '#1082#1086#1083#1083#1077#1082#1094#1080#1080
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
        end
        object cbGoodsInfo: TCheckBox
          Tag = 10
          Left = 15
          Top = 128
          Width = 194
          Height = 17
          Caption = '1.8. '#1054#1087#1080#1089#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
        end
        object cbGoodsSize: TCheckBox
          Tag = 10
          Left = 15
          Top = 144
          Width = 194
          Height = 17
          Caption = '1.9. '#1056#1072#1079#1084#1077#1088' '#1090#1086#1074#1072#1088#1072
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
        end
        object cbCash: TCheckBox
          Tag = 10
          Left = 15
          Top = 288
          Width = 194
          Height = 12
          Caption = '1.17. '#1050#1072#1089#1089#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
        end
        object cbValuta: TCheckBox
          Tag = 10
          Left = 15
          Top = 160
          Width = 194
          Height = 17
          Caption = '1.10. '#1042#1072#1083#1102#1090#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
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
          TabOrder = 12
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
          TabOrder = 13
        end
        object cbDiscount: TCheckBox
          Tag = 10
          Left = 15
          Top = 225
          Width = 226
          Height = 17
          Caption = '1.14. '#1053#1072#1079#1074#1072#1085#1080#1103' '#1085#1072#1082#1086#1087#1080#1090'. '#1089#1082#1080#1076#1086#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 14
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
          TabOrder = 15
          WordWrap = True
        end
        object cbPartner: TCheckBox
          Tag = 10
          Left = 15
          Top = 264
          Width = 178
          Height = 24
          Caption = '1.16. '#1055#1086'c'#1090#1072#1074#1097#1080#1082#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 16
          WordWrap = True
        end
        object cbUnit: TCheckBox
          Tag = 10
          Left = 15
          Top = 176
          Width = 178
          Height = 17
          Caption = '1.11. '#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 17
          WordWrap = True
        end
        object cbLabel: TCheckBox
          Tag = 10
          Left = 15
          Top = 300
          Width = 178
          Height = 24
          Caption = '1.18. '#1053#1072#1079#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1094#1077#1085#1085#1080#1082#1072
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 18
          WordWrap = True
        end
        object cbGoods: TCheckBox
          Tag = 10
          Left = 15
          Top = 318
          Width = 178
          Height = 24
          Caption = '1.19. '#1058#1086#1074#1072#1088#1099
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 19
          WordWrap = True
        end
        object cbGoodsItem: TCheckBox
          Tag = 10
          Left = 15
          Top = 336
          Width = 178
          Height = 24
          Caption = '1.20. '#1058#1086#1074#1072#1088#1099' c '#1088#1072#1079#1084#1077#1088#1072#1084#1080
          Enabled = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 20
          WordWrap = True
        end
        object cbClient: TCheckBox
          Tag = 10
          Left = 15
          Top = 445
          Width = 178
          Height = 24
          Caption = '1.26. '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 21
          WordWrap = True
        end
        object cbCity: TCheckBox
          Tag = 10
          Left = 15
          Top = 354
          Width = 178
          Height = 24
          Caption = '1.21. '#1043#1086#1088#1086#1076
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 22
          WordWrap = True
        end
        object cbJuridical: TCheckBox
          Tag = 10
          Left = 15
          Top = 372
          Width = 178
          Height = 24
          Caption = '1.22. '#1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 23
          WordWrap = True
        end
        object cbPriceList: TCheckBox
          Tag = 10
          Left = 15
          Top = 390
          Width = 178
          Height = 24
          Caption = '1.23. '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 24
          WordWrap = True
        end
        object cbMember: TCheckBox
          Tag = 10
          Left = 15
          Top = 408
          Width = 178
          Height = 24
          Caption = '1.24. '#1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 25
          WordWrap = True
        end
        object cbUser: TCheckBox
          Tag = 10
          Left = 15
          Top = 426
          Width = 178
          Height = 24
          Caption = '1.25. '#1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 26
          WordWrap = True
        end
        object cbClientNew: TCheckBox
          Left = 131
          Top = 448
          Width = 61
          Height = 17
          Caption = #1053#1086#1074#1099#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 27
        end
        object cbPartnerNew: TCheckBox
          Left = 131
          Top = 267
          Width = 61
          Height = 17
          Caption = #1053#1086#1074#1099#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 28
        end
      end
      object DocumentPanel: TPanel
        Left = 182
        Top = 0
        Width = 200
        Height = 468
        Align = alLeft
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
          Left = 98
          Top = 22
          Width = 12
          Height = 13
          Caption = #1087#1086
        end
        object cbAllDocument: TCheckBox
          Tag = 2
          Left = 15
          Top = 1
          Width = 72
          Height = 17
          Caption = #1042#1089#1077' '#1076#1086#1082'.'
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
          Width = 80
        end
        object EndDateEdit: TcxDateEdit
          Left = 111
          Top = 18
          TabOrder = 2
          Width = 80
        end
        object cbIncome: TCheckBox
          Tag = 20
          Left = 6
          Top = 70
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
        object cbReturnOut: TCheckBox
          Tag = 20
          Left = 6
          Top = 88
          Width = 235
          Height = 17
          Caption = '1.2. '#1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
        end
        object cbSend: TCheckBox
          Tag = 20
          Left = 6
          Top = 107
          Width = 235
          Height = 17
          Caption = '1.3. '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object cbLoss: TCheckBox
          Tag = 20
          Left = 6
          Top = 126
          Width = 235
          Height = 17
          Caption = '1.4. '#1057#1087#1080#1089#1072#1085#1080#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
        end
        object cbDiscountPeriodItem: TCheckBox
          Tag = 20
          Left = 6
          Top = 329
          Width = 204
          Height = 17
          Caption = '3. '#1048#1089#1090#1086#1088#1080#1103' '#1089#1082#1080#1076#1086#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          WordWrap = True
        end
        object cbPriceListItem: TCheckBox
          Tag = 20
          Left = 6
          Top = 313
          Width = 204
          Height = 17
          Caption = '2. '#1048#1089#1090#1086#1088#1080#1103' '#1094#1077#1085#1099
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          WordWrap = True
        end
        object cbInventory: TCheckBox
          Tag = 20
          Left = 6
          Top = 143
          Width = 235
          Height = 17
          Caption = '1.5. '#1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
        end
        object cbSale: TCheckBox
          Tag = 20
          Left = 6
          Top = 168
          Width = 235
          Height = 17
          Caption = '1.8. '#1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
        end
        object cbReturnIn: TCheckBox
          Tag = 20
          Left = 6
          Top = 185
          Width = 235
          Height = 17
          Caption = '1.9. '#1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
        end
        object cbSale_Child: TCheckBox
          Tag = 20
          Left = 6
          Top = 214
          Width = 235
          Height = 17
          Caption = '1.10. '#1054#1087#1083#1072#1090#1099' '#1074' '#1087#1088#1086#1076#1072#1078#1072#1093
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 12
        end
        object cbReturnIn_Child: TCheckBox
          Tag = 20
          Left = 6
          Top = 231
          Width = 235
          Height = 17
          Caption = '1.11. '#1054#1087#1083#1072#1090#1099' '#1074' '#1074#1086#1079#1074#1088#1072#1090#1072#1093
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 13
        end
        object cbTest: TCheckBox
          Left = 19
          Top = 423
          Width = 142
          Height = 17
          Caption = #1058#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1058#1077#1089#1090' Id :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 14
        end
        object TestEdit: TEdit
          Left = 19
          Top = 444
          Width = 104
          Height = 21
          TabOrder = 15
        end
        object cbGoodsAccount: TCheckBox
          Tag = 20
          Left = 6
          Top = 254
          Width = 195
          Height = 19
          Caption = '1.12. '#1056#1072#1089#1095#1077#1090#1099' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 16
          WordWrap = True
        end
        object cbCurrency: TCheckBox
          Tag = 20
          Left = 6
          Top = 45
          Width = 235
          Height = 17
          Caption = '1.0. '#1050#1059#1056#1057#1067
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 17
        end
        object cbLast: TCheckBox
          Left = 6
          Top = 296
          Width = 142
          Height = 17
          Caption = #1058#1086#1083#1100#1082#1086' Last :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 18
        end
        object cbErr: TCheckBox
          Left = 6
          Top = 384
          Width = 142
          Height = 17
          Caption = #1058#1086#1083#1100#1082#1086' Err  :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 19
        end
        object cbMovementNotOne: TCheckBox
          Left = 54
          Top = 273
          Width = 51
          Height = 17
          Caption = '1 '#1053#1045#1058
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 20
        end
        object cbMINotTwo: TCheckBox
          Left = 111
          Top = 273
          Width = 51
          Height = 17
          Caption = '2 '#1053#1045#1058
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 21
        end
        object cbSelect_MovementItem_Sale_Sybase_Check: TCheckBox
          Left = 8
          Top = 357
          Width = 177
          Height = 17
          Caption = '!!!gpSale_Sybase_Check!!!'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 22
        end
        object cbSaleErr: TCheckBox
          Left = 164
          Top = 168
          Width = 35
          Height = 17
          Caption = 'Err'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 23
        end
        object cbReturnInErr: TCheckBox
          Left = 164
          Top = 185
          Width = 35
          Height = 17
          Caption = 'Err'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 24
        end
      end
      object CompleteDocumentPanel: TPanel
        Left = 382
        Top = 0
        Width = 190
        Height = 468
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        ExplicitLeft = 373
        ExplicitWidth = 198
        object Label5: TLabel
          Left = 6
          Top = 22
          Width = 6
          Height = 13
          Caption = #1089
        end
        object Label6: TLabel
          Left = 97
          Top = 22
          Width = 12
          Height = 13
          Caption = #1087#1086
        end
        object cbAllCompleteDocument: TCheckBox
          Tag = 3
          Left = 15
          Top = 1
          Width = 73
          Height = 17
          Caption = #1042#1089#1077' '#1076#1086#1082
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = cbAllCompleteDocumentClick
        end
        object cbCompleteIncome: TCheckBox
          Tag = 30
          Left = 15
          Top = 86
          Width = 194
          Height = 17
          Caption = '1.1. '#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = cbCompleteIncomeClick
        end
        object StartDateCompleteEdit: TcxDateEdit
          Left = 14
          Top = 18
          TabOrder = 2
          Width = 80
        end
        object EndDateCompleteEdit: TcxDateEdit
          Left = 110
          Top = 18
          TabOrder = 3
          Width = 80
        end
        object cbComplete: TCheckBox
          Left = 15
          Top = 41
          Width = 76
          Height = 17
          Caption = #1055#1088#1086#1074#1077#1089#1090#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
        end
        object cbUnComplete: TCheckBox
          Left = 98
          Top = 41
          Width = 95
          Height = 17
          Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
        end
        object cbCompleteSend: TCheckBox
          Tag = 30
          Left = 15
          Top = 134
          Width = 194
          Height = 17
          Caption = '2. '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnClick = cbCompleteIncomeClick
        end
        object cbLastComplete: TCheckBox
          Left = 15
          Top = 61
          Width = 191
          Height = 17
          Caption = '!!!'#1073#1077#1079' '#1087#1088#1086#1074#1086#1076#1086#1082' C/C!!!'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 7
        end
        object cbCompleteInventory: TCheckBox
          Tag = 30
          Left = 15
          Top = 174
          Width = 194
          Height = 17
          Caption = '4. '#1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          OnClick = cbCompleteIncomeClick
        end
        object cbCompleteSale: TCheckBox
          Tag = 30
          Left = 15
          Top = 209
          Width = 200
          Height = 17
          Caption = '5. '#1055#1088#1086#1076'.'#1087#1086#1082'.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
          OnClick = cbCompleteIncomeClick
        end
        object cbCompleteReturnIn: TCheckBox
          Tag = 30
          Left = 15
          Top = 232
          Width = 200
          Height = 17
          Caption = '6. '#1042#1086#1079'.'#1086#1090' '#1087#1086#1082'.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 10
          OnClick = cbCompleteIncomeClick
        end
        object cbCompleteReturnOut: TCheckBox
          Tag = 30
          Left = 15
          Top = 105
          Width = 194
          Height = 17
          Caption = '1.2. '#1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
          OnClick = cbCompleteIncomeClick
        end
        object cbCompleteAccount: TCheckBox
          Tag = 30
          Left = 15
          Top = 255
          Width = 194
          Height = 17
          Caption = '7. '#1056#1072#1089#1095#1077#1090#1099' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 12
          OnClick = cbCompleteIncomeClick
        end
        object cbCompleteLoss: TCheckBox
          Tag = 30
          Left = 15
          Top = 154
          Width = 106
          Height = 17
          Caption = '3. '#1057#1087#1080#1089#1072#1085#1080#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 13
          OnClick = cbCompleteIncomeClick
        end
        object cbComplete_List: TCheckBox
          Left = 15
          Top = 351
          Width = 176
          Height = 17
          Caption = '!!! C'#1087#1080#1089#1086#1082' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' !!!'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHighlight
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 14
          OnClick = cbCompleteIncomeClick
        end
        object cb100MSec: TCheckBox
          Left = 15
          Top = 374
          Width = 76
          Height = 17
          Caption = '100MSec'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 15
        end
        object btnNullGuideId_Postgres: TButton
          Left = 24
          Top = 410
          Width = 137
          Height = 25
          Caption = '1. Guide - NULL Id_PG'
          TabOrder = 16
          OnClick = btnNullGuideId_PostgresClick
        end
        object btnNullDocId_Postgres: TButton
          Left = 24
          Top = 441
          Width = 137
          Height = 25
          Caption = '2. Doc - NULL Id_PG'
          TabOrder = 17
          OnClick = btnNullDocId_PostgresClick
        end
        object btnAddGuideId_Postgres: TButton
          Left = 24
          Top = 282
          Width = 137
          Height = 25
          Caption = '1. Guide - Add Id_PG'
          TabOrder = 18
          OnClick = btnAddGuideId_PostgresClick
        end
        object btnAddlDocId_Postgres: TButton
          Left = 24
          Top = 313
          Width = 137
          Height = 25
          Caption = '2. Doc - Add Id_PG'
          TabOrder = 19
          OnClick = btnAddlDocId_PostgresClick
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1080#1079' '#1092#1072#1081#1083#1086#1074
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 572
        Height = 468
        Align = alClient
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
        object lResultCSV: TLabel
          Left = 345
          Top = 130
          Width = 30
          Height = 13
          Caption = 'Result'
        end
        object lDropTableDat: TLabel
          Left = 125
          Top = 222
          Width = 30
          Height = 13
          Caption = 'Result'
        end
        object lInsertGoods2: TLabel
          Left = 345
          Top = 38
          Width = 30
          Height = 13
          Caption = 'Result'
        end
        object lInsertHasChildGoods2: TLabel
          Left = 345
          Top = 68
          Width = 30
          Height = 13
          Caption = 'Result'
        end
        object lUpdateGoods2: TLabel
          Left = 345
          Top = 100
          Width = 30
          Height = 13
          Caption = 'Result'
        end
        object lLoadDat: TLabel
          Left = 345
          Top = 354
          Width = 30
          Height = 13
          Caption = 'Result'
        end
        object lCreateTableDat: TLabel
          Left = 345
          Top = 254
          Width = 30
          Height = 13
          Caption = 'Result'
        end
        object lResultGroupCSV: TLabel
          Left = 345
          Top = 162
          Width = 30
          Height = 13
          Caption = 'Result'
        end
        object btnCreateTableDat: TButton
          Left = 88
          Top = 249
          Width = 255
          Height = 25
          Caption = '1. '#1057#1086#1079#1076#1072#1090#1100' '#1090#1072#1073#1083#1080#1094#1099' checked'
          TabOrder = 0
          OnClick = btnCreateTableDatClick
        end
        object cbChado: TCheckBox
          Tag = 11
          Left = 2
          Top = 8
          Width = 97
          Height = 17
          Caption = 'Chado.dat'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object btnLoadDat: TButton
          Left = 88
          Top = 347
          Width = 255
          Height = 25
          Caption = '2. *.dat - '#1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1074' checked'
          TabOrder = 2
          OnClick = btnLoadDatClick
        end
        object PathDatFiles: TEdit
          Left = 2
          Top = 299
          Width = 215
          Height = 21
          TabOrder = 3
          Text = 'E:\Project\DATABASE\DatFiles'
        end
        object cbEsc: TCheckBox
          Tag = 11
          Left = 2
          Top = 31
          Width = 97
          Height = 17
          Caption = 'Esc.dat'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
        object cbMM: TCheckBox
          Tag = 11
          Left = 2
          Top = 54
          Width = 97
          Height = 17
          Caption = 'MM.dat'
          Checked = True
          State = cbChecked
          TabOrder = 5
        end
        object cbSAV: TCheckBox
          Tag = 11
          Left = 2
          Top = 77
          Width = 97
          Height = 17
          Caption = 'SAV.dat'
          Checked = True
          State = cbChecked
          TabOrder = 6
        end
        object cbSav_out: TCheckBox
          Tag = 11
          Left = 2
          Top = 100
          Width = 97
          Height = 17
          Caption = 'Sav_out.dat'
          Checked = True
          State = cbChecked
          TabOrder = 7
        end
        object cbTer_Out: TCheckBox
          Tag = 11
          Left = 2
          Top = 123
          Width = 97
          Height = 17
          Caption = 'Ter_Out.dat'
          Checked = True
          State = cbChecked
          TabOrder = 8
        end
        object cbTL: TCheckBox
          Tag = 11
          Left = 2
          Top = 146
          Width = 97
          Height = 17
          Caption = 'TL.dat'
          Checked = True
          State = cbChecked
          TabOrder = 9
        end
        object cbVint: TCheckBox
          Tag = 11
          Left = 2
          Top = 169
          Width = 97
          Height = 17
          Caption = 'Vint.dat'
          Checked = True
          State = cbChecked
          TabOrder = 10
        end
        object cbSop: TCheckBox
          Tag = 11
          Left = 2
          Top = 192
          Width = 97
          Height = 17
          Caption = 'Sop.dat'
          Checked = True
          State = cbChecked
          TabOrder = 11
        end
        object cbGoods2: TCheckBox
          Tag = 11
          Left = 114
          Top = 8
          Width = 97
          Height = 17
          Caption = 'Goods2'
          Checked = True
          State = cbChecked
          TabOrder = 12
        end
        object btnInsertGoods2: TButton
          Left = 88
          Top = 31
          Width = 255
          Height = 25
          Caption = '3. insert into Goods2'
          TabOrder = 13
          OnClick = btnInsertGoods2Click
        end
        object btnDropTableDat: TButton
          Left = 2
          Top = 215
          Width = 121
          Height = 25
          Caption = '0. Drop table checked'
          TabOrder = 14
          OnClick = btnDropTableDatClick
        end
        object btnInsertHasChildGoods2: TButton
          Left = 88
          Top = 62
          Width = 255
          Height = 25
          Caption = '4. insert into Goods2 HasChildren = -1'
          TabOrder = 15
          OnClick = btnInsertHasChildGoods2Click
        end
        object cbAllTables: TCheckBox
          Left = 98
          Top = 192
          Width = 97
          Height = 17
          Caption = #1042#1089#1077' '#1090#1072#1073#1083#1080#1094#1099
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          State = cbChecked
          TabOrder = 16
          OnClick = cbAllTablesClick
        end
        object btnResultCSV: TButton
          Left = 88
          Top = 124
          Width = 255
          Height = 25
          Caption = #1060#1048#1053#1048#1064' - create Goods2.csv '#1089' ParentId = 50000'
          TabOrder = 17
          OnClick = btnResultCSVClick
        end
        object btnUpdateGoods2: TButton
          Left = 88
          Top = 93
          Width = 255
          Height = 25
          Caption = '5. Update - find '#1076#1083#1103'  ParentId = 50000'
          TabOrder = 18
          OnClick = btnUpdateGoods2Click
        end
        object btnResultGroupCSV: TButton
          Left = 88
          Top = 157
          Width = 255
          Height = 25
          Caption = #1060#1048#1053#1048#1064' - create GROUP2.csv '#1089' ParentId = 50000'
          TabOrder = 19
          OnClick = btnResultGroupCSVClick
        end
        object cbGroup11: TCheckBox
          Tag = 11
          Left = 218
          Top = 8
          Width = 63
          Height = 17
          Caption = 'Group11'
          Checked = True
          State = cbChecked
          TabOrder = 20
        end
        object cbGroup22: TCheckBox
          Tag = 11
          Left = 290
          Top = 8
          Width = 71
          Height = 17
          Caption = 'Group22'
          Checked = True
          State = cbChecked
          TabOrder = 21
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
    UTF8StringsAsWideField = True
    Catalog = 'public'
    DesignConnection = True
    HostName = '212.115.238.8:5432'
    Port = 5432
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
  object DatabaseSybase: TDatabase
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
