object ProductEditForm: TProductEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1051#1086#1076#1082#1072'>'
  ClientHeight = 567
  ClientWidth = 594
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actDataSetRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 8
    Top = 524
    Width = 75
    Height = 25
    Action = actInsertUpdateGuides
    Default = True
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 103
    Top = 524
    Width = 75
    Height = 25
    Action = actFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
  end
  object cxButton4: TcxButton
    Left = 206
    Top = 524
    Width = 106
    Height = 25
    Action = mactLoadAgilis_all
    TabOrder = 2
  end
  object cxPageControl1: TcxPageControl
    Left = 0
    Top = 0
    Width = 594
    Height = 497
    Align = alTop
    TabOrder = 3
    Properties.ActivePage = cxTabSheet1
    Properties.CustomButtons.Buttons = <>
    Properties.Options = [pcoAlwaysShowGoDialogButton, pcoGradient, pcoGradientClientArea]
    ClientRectBottom = 497
    ClientRectRight = 594
    ClientRectTop = 24
    object cxTabSheet1: TcxTabSheet
      Caption = 'Main'
      ImageIndex = 0
      object edName: TcxTextEdit
        Left = 10
        Top = 393
        TabOrder = 0
        Width = 273
      end
      object cxLabel1: TcxLabel
        Left = 10
        Top = 375
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
      end
      object cxLabel2: TcxLabel
        Left = 11
        Top = 8
        Caption = 'Interne Nr'
      end
      object edCode: TcxCurrencyEdit
        Left = 10
        Top = 29
        EditValue = 0.000000000000000000
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        Properties.ReadOnly = False
        TabOrder = 4
        Width = 54
      end
      object cxLabel3: TcxLabel
        Left = 10
        Top = 419
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
      end
      object edComment: TcxTextEdit
        Left = 10
        Top = 439
        TabOrder = 6
        Width = 273
      end
      object cxLabel6: TcxLabel
        Left = 10
        Top = 330
        Hint = #1053#1072#1095#1072#1083#1086' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
        Caption = #1053#1072#1095#1072#1083#1086' '#1087#1088#1086#1080#1079#1074'.'
        ParentShowHint = False
        ShowHint = True
      end
      object edHours: TcxCurrencyEdit
        Left = 151
        Top = 305
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        TabOrder = 8
        Width = 132
      end
      object cxLabel4: TcxLabel
        Left = 105
        Top = 330
        Hint = #1050#1086#1075#1076#1072' '#1087#1083#1072#1085#1080#1088#1091#1077#1090#1089#1103' '#1079#1072#1074#1077#1088#1096#1080#1090#1100' '#1089#1073#1086#1088#1082#1091' '#1083#1086#1076#1082#1080
        Caption = #1044#1072#1090#1072' '#1087#1083#1072#1085
        ParentShowHint = False
        ShowHint = True
      end
      object cxLabel5: TcxLabel
        Left = 201
        Top = 330
        Hint = #1055#1088#1086#1076#1072#1078#1072
        Caption = #1055#1088#1086#1076#1072#1078#1072
      end
      object cxLabel7: TcxLabel
        Left = 151
        Top = 284
        Caption = #1055#1086#1089#1083'. '#1074#1088#1077#1084#1103' '#1086#1073#1089#1083#1091#1078'.,'#1095'.'
      end
      object cxLabel9: TcxLabel
        Left = 10
        Top = 58
        Caption = 'CIN Nr.'
      end
      object edDateStart: TcxDateEdit
        Left = 10
        Top = 350
        EditValue = 42160d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 12
        Width = 82
      end
      object edDateBegin: TcxDateEdit
        Left = 105
        Top = 350
        Hint = #1050#1086#1075#1076#1072' '#1087#1083#1072#1085#1080#1088#1091#1077#1090#1089#1103' '#1079#1072#1074#1077#1088#1096#1080#1090#1100' '#1089#1073#1086#1088#1082#1091' '#1083#1086#1076#1082#1080
        EditValue = 42160d
        ParentShowHint = False
        Properties.SaveTime = False
        Properties.ShowTime = False
        ShowHint = True
        TabOrder = 13
        Width = 82
      end
      object edDateSale: TcxDateEdit
        Left = 201
        Top = 350
        EditValue = 42160d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 14
        Width = 82
      end
      object edCIN: TcxTextEdit
        Left = 10
        Top = 78
        TabOrder = 16
        Width = 209
      end
      object cxLabel10: TcxLabel
        Left = 10
        Top = 285
        Caption = 'Engine Nr.'
      end
      object edEngineNum: TcxTextEdit
        Left = 10
        Top = 305
        Properties.ReadOnly = True
        TabOrder = 18
        Width = 132
      end
      object cxLabel11: TcxLabel
        Left = 10
        Top = 195
        Caption = #1052#1072#1088#1082#1072' '#1084#1086#1076#1077#1083#1080
      end
      object edBrand: TcxButtonEdit
        Left = 10
        Top = 215
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 20
        Width = 273
      end
      object cxLabel12: TcxLabel
        Left = 10
        Top = 102
        Caption = #1052#1086#1076#1077#1083#1100
      end
      object edModel: TcxButtonEdit
        Left = 10
        Top = 121
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 22
        Width = 273
      end
      object cxLabel13: TcxLabel
        Left = 10
        Top = 241
        Caption = #1052#1086#1090#1086#1088
      end
      object edEngine: TcxButtonEdit
        Left = 10
        Top = 261
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 23
        Width = 273
      end
      object cbBasicConf: TcxCheckBox
        Left = 148
        Top = 8
        Caption = #1041#1072#1079#1086#1074#1072#1103' '#1082#1086#1085#1092'.'
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clBlue
        Style.Font.Height = -16
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 24
        Width = 155
      end
      object cbProdColorPattern: TcxCheckBox
        Left = 148
        Top = 36
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088
        TabOrder = 26
        Width = 152
      end
      object cxLabel14: TcxLabel
        Left = 10
        Top = 148
        Caption = #1064#1072#1073#1083#1086#1085' '#1089#1073#1086#1088#1082#1080' '#1052#1086#1076#1077#1083#1080
      end
      object edReceiptProdModel: TcxButtonEdit
        Left = 10
        Top = 168
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 27
        Width = 273
      end
      object edDiscountNextTax: TcxCurrencyEdit
        Left = 418
        Top = 168
        Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081')'
        ParentShowHint = False
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        ShowHint = True
        TabOrder = 29
        Width = 80
      end
      object cxLabel15: TcxLabel
        Left = 419
        Top = 148
        Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1081')'
        Caption = '% '#1089#1082'. ('#1076#1086#1087'.)'
        ParentShowHint = False
        ShowHint = True
      end
      object cxLabel16: TcxLabel
        Left = 331
        Top = 148
        Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
        Caption = '% '#1089#1082'. ('#1086#1089#1085'.)'
        ParentShowHint = False
        ShowHint = True
      end
      object edClienttext: TcxLabel
        Left = 332
        Top = 58
        Hint = #1050#1083#1080#1077#1085#1090
        Caption = 'Kunden'
        ParentShowHint = False
        ShowHint = True
      end
      object edClient: TcxButtonEdit
        Left = 332
        Top = 78
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 32
        Width = 147
      end
      object edDiscountTax: TcxCurrencyEdit
        Left = 333
        Top = 168
        Hint = '% '#1089#1082#1080#1076#1082#1080' ('#1086#1089#1085#1086#1074#1085#1086#1081')'
        ParentShowHint = False
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        ShowHint = True
        TabOrder = 34
        Width = 80
      end
      object cxLabel8: TcxLabel
        Left = 331
        Top = 9
        Caption = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072
      end
      object cxLabel17: TcxLabel
        Left = 485
        Top = 9
        Caption = #8470' '#1076#1086#1082'.'
      end
      object edInvNumberOrderClient: TcxTextEdit
        Left = 485
        Top = 28
        Properties.ReadOnly = True
        TabOrder = 37
        Width = 85
      end
      object cxLabel18: TcxLabel
        Left = 485
        Top = 58
        Caption = #1044#1072#1090#1072
      end
      object edOperDateOrderClient: TcxDateEdit
        Left = 485
        Top = 78
        EditValue = 42160d
        Properties.ReadOnly = False
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 38
        Width = 85
      end
      object ceStatus: TcxButtonEdit
        Left = 332
        Top = 29
        Properties.Buttons = <
          item
            Action = CompleteMovement
            Kind = bkGlyph
          end
          item
            Action = UnCompleteMovement
            Default = True
            Kind = bkGlyph
          end
          item
            Action = DeleteMovement
            Kind = bkGlyph
          end>
        Properties.Images = dmMain.ImageList
        Properties.ReadOnly = True
        TabOrder = 40
        Width = 148
      end
      object cxLabel19: TcxLabel
        Left = 331
        Top = 195
        Caption = #1057#1091#1084#1084#1072' c '#1053#1044#1057
      end
      object edTotalSummPVAT: TcxCurrencyEdit
        Left = 331
        Top = 214
        ParentFont = False
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clBlue
        Style.Font.Height = -12
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 42
        Width = 80
      end
      object cxLabel20: TcxLabel
        Left = 418
        Top = 195
        Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
      end
      object edTotalSummMVAT: TcxCurrencyEdit
        Left = 418
        Top = 215
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        TabOrder = 44
        Width = 80
      end
      object cxLabel21: TcxLabel
        Left = 504
        Top = 195
        Caption = #1057#1091#1084#1084#1072' '#1053#1044#1057
      end
      object edTotalSummVAT: TcxCurrencyEdit
        Left = 502
        Top = 215
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        TabOrder = 45
        Width = 68
      end
      object ceAmountInInvoice: TcxCurrencyEdit
        Left = 331
        Top = 305
        Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1087#1077#1088#1074#1086#1084#1091' '#1074#1099#1087#1080#1089#1072#1085#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
        ParentShowHint = False
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        ShowHint = True
        TabOrder = 46
        Width = 114
      end
      object ceAmountInInvoiceAll: TcxCurrencyEdit
        Left = 456
        Top = 305
        Hint = #1057#1091#1084#1084#1072' '#1080#1090#1086#1075#1086' '#1087#1086' '#1074#1089#1077#1084' '#1089#1095#1077#1090#1072#1084
        ParentShowHint = False
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        ShowHint = True
        TabOrder = 49
        Width = 114
      end
      object cxLabel26: TcxLabel
        Left = 456
        Top = 285
        Hint = #1057#1091#1084#1084#1072' '#1080#1090#1086#1075#1086' '#1087#1086' '#1074#1089#1077#1084' '#1089#1095#1077#1090#1072#1084
        Caption = #1057#1091#1084#1084#1072' (Invoice All)'
        ParentShowHint = False
        ShowHint = True
      end
      object cxLabel27: TcxLabel
        Left = 331
        Top = 330
        Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1087#1077#1088#1074#1086#1084#1091' '#1074#1099#1087#1080#1089#1072#1085#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
        Caption = #1054#1087#1083#1072#1090#1072' (Invoice)'
        ParentShowHint = False
        ShowHint = True
      end
      object ceAmountInBankAccount: TcxCurrencyEdit
        Left = 331
        Top = 348
        Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1087#1077#1088#1074#1086#1084#1091' '#1074#1099#1087#1080#1089#1072#1085#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
        ParentShowHint = False
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        Properties.ReadOnly = True
        ShowHint = True
        TabOrder = 50
        Width = 114
      end
      object ceAmountInBankAccountAll: TcxCurrencyEdit
        Left = 456
        Top = 348
        Hint = #1054#1087#1083#1072#1090#1072' '#1080#1090#1086#1075#1086' '#1087#1086' '#1074#1089#1077#1084' '#1089#1095#1077#1090#1072#1084
        ParentShowHint = False
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        Properties.ReadOnly = True
        ShowHint = True
        TabOrder = 53
        Width = 114
      end
      object cxLabel28: TcxLabel
        Left = 456
        Top = 330
        Hint = #1054#1087#1083#1072#1090#1072' '#1080#1090#1086#1075#1086' '#1087#1086' '#1074#1089#1077#1084' '#1089#1095#1077#1090#1072#1084
        Caption = #1054#1087#1083#1072#1090#1072' (Invoice All)'
        ParentShowHint = False
        ShowHint = True
      end
      object cxLabel29: TcxLabel
        Left = 504
        Top = 148
        Caption = '% '#1053#1044#1057
      end
      object edVATPercentOrderClient: TcxCurrencyEdit
        Left = 502
        Top = 168
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = ',0'
        Properties.ReadOnly = True
        TabOrder = 55
        Width = 68
      end
      object cxLabel30: TcxLabel
        Left = 332
        Top = 375
        Hint = #1054#1089#1090#1072#1090#1086#1082' '#1082' '#1086#1087#1083#1072#1090#1077' '#1087#1086' '#1042#1057#1045#1052' '#1089#1095#1077#1090#1072#1084
        Caption = #1054#1089#1090#1072#1090#1086#1082' '#1087#1086' '#1089#1095#1077#1090#1072#1084
        ParentShowHint = False
        ShowHint = True
      end
      object edAmountIn_rem: TcxCurrencyEdit
        Left = 331
        Top = 392
        Hint = #1054#1089#1090#1072#1090#1086#1082' '#1082' '#1086#1087#1083#1072#1090#1077' '#1087#1086' '#1042#1057#1045#1052' '#1089#1095#1077#1090#1072#1084
        ParentFont = False
        ParentShowHint = False
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        Properties.ReadOnly = True
        ShowHint = True
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clBlue
        Style.Font.Height = -12
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 56
        Width = 114
      end
      object edAmountIn_remAll: TcxCurrencyEdit
        Left = 451
        Top = 391
        Hint = #1054#1089#1090#1072#1090#1086#1082' '#1048#1058#1054#1043#1054' '#1082' '#1086#1087#1083#1072#1090#1077
        ParentFont = False
        ParentShowHint = False
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        Properties.ReadOnly = True
        ShowHint = True
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clBlue
        Style.Font.Height = -12
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 58
        Width = 114
      end
      object cxLabel31: TcxLabel
        Left = 456
        Top = 375
        Hint = #1054#1089#1090#1072#1090#1086#1082' '#1048#1058#1054#1043#1054' '#1082' '#1086#1087#1083#1072#1090#1077
        Caption = #1054#1089#1090#1072#1090#1086#1082' '#1048#1058#1054#1043#1054
        ParentShowHint = False
        ShowHint = True
      end
      object cxButton3: TcxButton
        Left = 225
        Top = 76
        Width = 58
        Height = 25
        Action = actGetCIN
        Default = True
        TabOrder = 60
      end
      object edInvNumberOrderClient_load: TcxTextEdit
        Left = 331
        Top = 439
        TabOrder = 64
        Width = 80
      end
      object cxLabel32: TcxLabel
        Left = 331
        Top = 419
        Caption = #8470' '#1079#1072#1082#1072#1079#1072' '#1089#1072#1081#1090
      end
      object cxLabel33: TcxLabel
        Left = 419
        Top = 419
        Caption = 'Price (Order)'
      end
      object edOperPrice_load: TcxCurrencyEdit
        Left = 416
        Top = 439
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        TabOrder = 71
        Width = 79
      end
      object edTransportSumm_load: TcxCurrencyEdit
        Left = 500
        Top = 439
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        TabOrder = 59
        Width = 73
      end
      object cxLabel34: TcxLabel
        Left = 497
        Top = 419
        Caption = 'Transp (Order)'
      end
      object cxLabel35: TcxLabel
        Left = 71
        Top = 9
        Caption = #8470' '#1074' '#1086#1095#1077#1088#1077#1076#1080
      end
      object edNPP: TcxCurrencyEdit
        Left = 71
        Top = 29
        Hint = #1054#1095#1077#1088#1077#1076#1085#1086#1089#1090#1100' '#1089#1073#1086#1088#1082#1080
        ParentShowHint = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = ',0.###'
        ShowHint = True
        TabOrder = 61
        Width = 72
      end
      object cxLabel36: TcxLabel
        Left = 334
        Top = 102
        Hint = 'C'#1091#1084#1084#1072' '#1086#1090#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1072#1085#1085#1086#1081' '#1089#1082#1080#1076#1082#1080', '#1073#1077#1079' '#1053#1044#1057
        Caption = #1057#1082#1080#1076#1082#1072' ('#1074#1074#1086#1076')'
        ParentShowHint = False
        ShowHint = True
      end
      object edSummTax: TcxCurrencyEdit
        Left = 333
        Top = 121
        Hint = 'C'#1091#1084#1084#1072' '#1086#1090#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1072#1085#1085#1086#1081' '#1089#1082#1080#1076#1082#1080', '#1073#1077#1079' '#1053#1044#1057
        ParentShowHint = False
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        ShowHint = True
        TabOrder = 65
        Width = 80
      end
      object cxLabel37: TcxLabel
        Left = 419
        Top = 102
        Hint = 
          #1048#1058#1054#1043#1054' '#1086#1090#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1072#1085#1085#1072#1103' '#1089#1091#1084#1084#1072', '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082', '#1073#1077#1079' '#1058#1088#1072#1085#1089#1087 +
          #1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
        Caption = 'Total LP ('#1074#1074#1086#1076') :'
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -11
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
      end
      object edSummReal: TcxCurrencyEdit
        Left = 419
        Top = 121
        Hint = 
          #1048#1058#1054#1043#1054' '#1086#1090#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1072#1085#1085#1072#1103' '#1089#1091#1084#1084#1072', '#1089' '#1091#1095#1077#1090#1086#1084' '#1074#1089#1077#1093' '#1089#1082#1080#1076#1086#1082', '#1073#1077#1079' '#1058#1088#1072#1085#1089#1087 +
          #1086#1088#1090#1072', '#1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
        ParentShowHint = False
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        ShowHint = True
        Style.Color = clGradientInactiveCaption
        TabOrder = 66
        Width = 151
      end
      object cxLabel25: TcxLabel
        Left = 331
        Top = 285
        Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1087#1077#1088#1074#1086#1084#1091' '#1074#1099#1087#1080#1089#1072#1085#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
        Caption = #1057#1091#1084#1084#1072' (Invoice)'
        ParentShowHint = False
        ShowHint = True
      end
    end
    object cxTabSheet2: TcxTabSheet
      Caption = 'Invoice'
      ImageIndex = 1
      object cxLabel22: TcxLabel
        Left = 611
        Top = 59
        Caption = #1057#1090#1072#1090#1091#1089' (Invoice)'
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object cxLabel23: TcxLabel
        Left = 736
        Top = 13
        Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1087#1077#1088#1074#1086#1084#1091' '#1074#1099#1087#1080#1089#1072#1085#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
        Caption = #1044#1072#1090#1072' (Invoice)'
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object edOperDateInvoice: TcxDateEdit
        Left = 736
        Top = 36
        Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1087#1077#1088#1074#1086#1084#1091' '#1074#1099#1087#1080#1089#1072#1085#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
        EditValue = 42160d
        ParentShowHint = False
        Properties.SaveTime = False
        Properties.ShowTime = False
        ShowHint = True
        TabOrder = 2
        Visible = False
        Width = 114
      end
      object cxLabel24: TcxLabel
        Left = 611
        Top = 13
        Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1087#1077#1088#1074#1086#1084#1091' '#1074#1099#1087#1080#1089#1072#1085#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
        Caption = #8470' '#1076#1086#1082'. (Invoice)'
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object edInvNumberInvoice: TcxTextEdit
        Left = 611
        Top = 36
        Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1087#1077#1088#1074#1086#1084#1091' '#1074#1099#1087#1080#1089#1072#1085#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
        ParentShowHint = False
        Properties.ReadOnly = True
        ShowHint = True
        TabOrder = 4
        Visible = False
        Width = 114
      end
      object ceStatusInvoice: TcxButtonEdit
        Left = 611
        Top = 80
        ParentShowHint = False
        Properties.Buttons = <
          item
            Action = CompleteMovementInvoice
            Kind = bkGlyph
          end
          item
            Action = UnCompleteMovementInvoice
            Default = True
            Kind = bkGlyph
          end
          item
            Action = DeleteMovementInvoice
            Kind = bkGlyph
          end>
        Properties.Images = dmMain.ImageList
        Properties.ReadOnly = True
        ShowHint = True
        TabOrder = 5
        Visible = False
        Width = 239
      end
      object cxLabel38: TcxLabel
        Left = 611
        Top = 108
        Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1087#1077#1088#1074#1086#1084#1091' '#1074#1099#1087#1080#1089#1072#1085#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
        Caption = #1057#1091#1084#1084#1072' (Invoice)'
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object cxLabel39: TcxLabel
        Left = 731
        Top = 108
        Hint = #1057#1091#1084#1084#1072' '#1080#1090#1086#1075#1086' '#1087#1086' '#1074#1089#1077#1084' '#1089#1095#1077#1090#1072#1084
        Caption = #1057#1091#1084#1084#1072' (Invoice All)'
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object ceAmountInInvoice2: TcxCurrencyEdit
        Left = 611
        Top = 126
        Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1087#1077#1088#1074#1086#1084#1091' '#1074#1099#1087#1080#1089#1072#1085#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
        ParentShowHint = False
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        ShowHint = True
        TabOrder = 8
        Visible = False
        Width = 114
      end
      object ceAmountInInvoiceAll2: TcxCurrencyEdit
        Left = 731
        Top = 126
        Hint = #1057#1091#1084#1084#1072' '#1080#1090#1086#1075#1086' '#1087#1086' '#1074#1089#1077#1084' '#1089#1095#1077#1090#1072#1084
        ParentShowHint = False
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        ShowHint = True
        TabOrder = 9
        Visible = False
        Width = 114
      end
      object cxLabel40: TcxLabel
        Left = 611
        Top = 153
        Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1087#1077#1088#1074#1086#1084#1091' '#1074#1099#1087#1080#1089#1072#1085#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
        Caption = #1054#1087#1083#1072#1090#1072' (Invoice)'
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object ceAmountInBankAccount2: TcxCurrencyEdit
        Left = 611
        Top = 173
        Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1087#1077#1088#1074#1086#1084#1091' '#1074#1099#1087#1080#1089#1072#1085#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
        ParentShowHint = False
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        Properties.ReadOnly = True
        ShowHint = True
        TabOrder = 11
        Visible = False
        Width = 114
      end
      object ceAmountInBankAccountAll2: TcxCurrencyEdit
        Left = 731
        Top = 173
        Hint = #1054#1087#1083#1072#1090#1072' '#1080#1090#1086#1075#1086' '#1087#1086' '#1074#1089#1077#1084' '#1089#1095#1077#1090#1072#1084
        ParentShowHint = False
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        Properties.ReadOnly = True
        ShowHint = True
        TabOrder = 12
        Visible = False
        Width = 114
      end
      object cxLabel41: TcxLabel
        Left = 731
        Top = 153
        Hint = #1054#1087#1083#1072#1090#1072' '#1080#1090#1086#1075#1086' '#1087#1086' '#1074#1089#1077#1084' '#1089#1095#1077#1090#1072#1084
        Caption = #1054#1087#1083#1072#1090#1072' (Invoice All)'
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object edInvNumberBankAccount3: TcxTextEdit
        Left = 601
        Top = 226
        Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1087#1077#1088#1074#1086#1084#1091' '#1074#1099#1087#1080#1089#1072#1085#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
        ParentShowHint = False
        Properties.ReadOnly = True
        ShowHint = True
        TabOrder = 14
        Visible = False
        Width = 116
      end
      object edInvNumberBankAccountText: TcxLabel
        Left = 609
        Top = 203
        Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1087#1077#1088#1074#1086#1084#1091' '#1074#1099#1087#1080#1089#1072#1085#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
        Caption = #8470' '#1076#1086#1082'. (BankAccount)'
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object cxLabel45: TcxLabel
        Left = 601
        Top = 249
        Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
        Visible = False
      end
      object ceBankAccount: TcxButtonEdit
        Left = 601
        Top = 270
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 17
        Visible = False
        Width = 243
      end
      object edSummaBank: TcxCurrencyEdit
        Left = 731
        Top = 316
        Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1087#1077#1088#1074#1086#1084#1091' '#1074#1099#1087#1080#1089#1072#1085#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
        ParentShowHint = False
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        Properties.ReadOnly = False
        ShowHint = True
        TabOrder = 6
        Visible = False
        Width = 114
      end
      object cxLabel42: TcxLabel
        Left = 731
        Top = 298
        Hint = #1057#1091#1084#1084#1072' '#1086#1087#1083#1072#1090#1072' '#1087#1086' '#1089#1095#1077#1090#1091
        Caption = #1054#1087#1083#1072#1090#1072' '#1087#1086' '#1089#1095#1077#1090#1091
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object cxLabel43: TcxLabel
        Left = 731
        Top = 203
        Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1087#1077#1088#1074#1086#1084#1091' '#1074#1099#1087#1080#1089#1072#1085#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
        Caption = #1044#1072#1090#1072' (BankAccount)'
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object edOperDateBankAccount: TcxDateEdit
        Left = 731
        Top = 226
        Hint = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1087#1077#1088#1074#1086#1084#1091' '#1074#1099#1087#1080#1089#1072#1085#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
        EditValue = 42160d
        ParentShowHint = False
        Properties.SaveTime = False
        Properties.ShowTime = False
        ShowHint = True
        TabOrder = 10
        Visible = False
        Width = 114
      end
      object Panel1: TPanel
        Left = 0
        Top = 217
        Width = 594
        Height = 256
        Align = alClient
        Caption = 'Panel1'
        TabOrder = 22
        object dxBarDockControl1: TdxBarDockControl
          Left = 1
          Top = 1
          Width = 592
          Height = 26
          Align = dalTop
          BarManager = BarManager
        end
        object cxGrid1: TcxGrid
          Left = 1
          Top = 27
          Width = 592
          Height = 228
          Align = alClient
          TabOrder = 1
          object cxGridDBTableView1: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = BankDS
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Summary.DefaultGroupSummaryItems = <
              item
                Format = ',0.00##'
                Kind = skSum
                Column = AmountIn
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = AmountOut
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = Amount_diff
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = Amount_Invoice
              end>
            DataController.Summary.FooterSummaryItems = <
              item
                Format = ',0.00##'
                Kind = skSum
                Column = AmountIn
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = AmountOut
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = Amount_diff
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = Amount_Invoice
              end>
            DataController.Summary.SummaryGroups = <>
            Images = dmMain.SortImageList
            OptionsBehavior.GoToNextCellOnEnter = True
            OptionsBehavior.FocusCellOnCycle = True
            OptionsCustomize.ColumnHiding = True
            OptionsCustomize.ColumnsQuickCustomization = True
            OptionsCustomize.DataRowSizing = True
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Inserting = False
            OptionsView.Footer = True
            OptionsView.GroupByBox = False
            OptionsView.GroupSummaryLayout = gslAlignWithColumns
            OptionsView.HeaderAutoHeight = True
            OptionsView.Indicator = True
            Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
            object cxGridDBColumn1: TcxGridDBColumn
              Caption = #1057#1090#1072#1090#1091#1089
              DataBinding.FieldName = 'StatusCode'
              PropertiesClassName = 'TcxImageComboBoxProperties'
              Properties.Images = dmMain.ImageList
              Properties.Items = <
                item
                  Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                  ImageIndex = 11
                  Value = 1
                end
                item
                  Description = #1055#1088#1086#1074#1077#1076#1077#1085
                  ImageIndex = 12
                  Value = 2
                end
                item
                  Description = #1059#1076#1072#1083#1077#1085
                  ImageIndex = 13
                  Value = 3
                end>
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object cxGridDBColumn2: TcxGridDBColumn
              Caption = 'Interne Nr'
              DataBinding.FieldName = 'InvNumber'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
              Options.Editing = False
              Width = 55
            end
            object InvNumberParent: TcxGridDBColumn
              Caption = 'External Nr'
              DataBinding.FieldName = 'InvNumberParent'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
              Options.Editing = False
              Width = 56
            end
            object cxGridDBColumn40: TcxGridDBColumn
              Caption = #1044#1072#1090#1072
              DataBinding.FieldName = 'OperDate'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 55
            end
            object BankAccountName: TcxGridDBColumn
              Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
              DataBinding.FieldName = 'BankAccountName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 101
            end
            object BankName: TcxGridDBColumn
              Caption = #1041#1072#1085#1082
              DataBinding.FieldName = 'BankName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 86
            end
            object AmountIn: TcxGridDBColumn
              Caption = #1044#1077#1073#1077#1090
              DataBinding.FieldName = 'AmountIn'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 80
            end
            object AmountOut: TcxGridDBColumn
              Caption = #1050#1088#1077#1076#1080#1090
              DataBinding.FieldName = 'AmountOut'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 80
            end
            object MoneyPlaceName: TcxGridDBColumn
              Caption = 'Lieferanten / Kunden'
              DataBinding.FieldName = 'MoneyPlaceName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 103
            end
            object ItemName: TcxGridDBColumn
              Caption = #1069#1083#1077#1084#1077#1085#1090
              DataBinding.FieldName = 'ItemName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 55
            end
            object InfoMoneyCode_Invoice: TcxGridDBColumn
              Caption = #1050#1086#1076' '#1059#1055
              DataBinding.FieldName = 'InfoMoneyCode_Invoice'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
              Options.Editing = False
              Width = 33
            end
            object InfoMoneyGroupName_Invoice: TcxGridDBColumn
              Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
              DataBinding.FieldName = 'InfoMoneyGroupName_Invoice'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
              Options.Editing = False
              Width = 80
            end
            object InfoMoneyDestinationName_Invoice: TcxGridDBColumn
              Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
              DataBinding.FieldName = 'InfoMoneyDestinationName_Invoice'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
              Options.Editing = False
              Width = 80
            end
            object InfoMoneyName_Invoice: TcxGridDBColumn
              Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
              DataBinding.FieldName = 'InfoMoneyName_Invoice'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
              Options.Editing = False
              Width = 80
            end
            object InfoMoneyName_all_Invoice: TcxGridDBColumn
              Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
              DataBinding.FieldName = 'InfoMoneyName_all_Invoice'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
              Options.Editing = False
              Width = 80
            end
            object UnitName_Invoice: TcxGridDBColumn
              Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
              DataBinding.FieldName = 'UnitName_Invoice'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
              Options.Editing = False
              Width = 101
            end
            object Amount_diff: TcxGridDBColumn
              Caption = #1056#1072#1079#1085#1080#1094#1072' '#1057#1095#1077#1090
              DataBinding.FieldName = 'Amount_diff'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1056#1072#1079#1085#1080#1094#1072' '#1089' '#1089#1091#1084#1084#1086#1081' '#1087#1086' '#1057#1095#1077#1090#1091
              Options.Editing = False
              Width = 70
            end
            object isDiff: TcxGridDBColumn
              Caption = #1056#1072#1079#1085'.'
              DataBinding.FieldName = 'isDiff'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1045#1089#1090#1100' '#1088#1072#1079#1085#1080#1094#1072' '#1089' '#1089#1091#1084#1084#1086#1081' '#1087#1086' '#1089#1095#1077#1090#1091' '#1076#1072'/'#1085#1077#1090
              Options.Editing = False
              Width = 51
            end
            object Comment: TcxGridDBColumn
              Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
              DataBinding.FieldName = 'Comment'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 100
            end
            object ReceiptNumber_Invoice: TcxGridDBColumn
              Caption = '***Quittung Nr'
              DataBinding.FieldName = 'ReceiptNumber_Invoice'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1054#1092#1080#1094#1080#1072#1083#1100#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1082#1074#1080#1090#1072#1085#1094#1080#1080' '#1074' '#1044#1086#1082#1091#1084#1077#1085#1090#1077' '#1057#1095#1077#1090
              Options.Editing = False
              Width = 55
            end
            object InvNumber_Invoice_Full: TcxGridDBColumn
              Caption = '***Interne Nr'
              DataBinding.FieldName = 'InvNumber_Invoice_Full'
              PropertiesClassName = 'TcxButtonEditProperties'
              Properties.Buttons = <
                item
                  Default = True
                  Kind = bkEllipsis
                end>
              Properties.ReadOnly = True
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090
              Width = 70
            end
            object PaidKindName_Invoice: TcxGridDBColumn
              Caption = '***'#1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
              DataBinding.FieldName = 'PaidKindName_Invoice'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
              Options.Editing = False
              Width = 56
            end
            object Amount_Invoice: TcxGridDBColumn
              Caption = '***'#1057#1091#1084#1084#1072' '#1057#1095#1077#1090
              DataBinding.FieldName = 'Amount_Invoice'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1057#1091#1084#1084#1072' '#1087#1086' '#1057#1095#1077#1090#1091
              Options.Editing = False
              Width = 80
            end
            object ObjectName_Invoice: TcxGridDBColumn
              Caption = '***Lieferanten / Kunden'
              DataBinding.FieldName = 'ObjectName_Invoice'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1055#1086#1089#1090#1072#1074#1097#1080#1082' / '#1050#1083#1080#1077#1085#1090' '#1074' '#1044#1086#1082#1091#1084#1077#1085#1090#1077' '#1057#1095#1077#1090
              Options.Editing = False
              Width = 128
            end
            object DescName_Invoice: TcxGridDBColumn
              Caption = '***'#1069#1083#1077#1084#1077#1085#1090
              DataBinding.FieldName = 'DescName_Invoice'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1055#1086#1089#1090#1072#1074#1097#1080#1082' / '#1050#1083#1080#1077#1085#1090' '#1074' '#1044#1086#1082#1091#1084#1077#1085#1090#1077' '#1057#1095#1077#1090
              Options.Editing = False
              Width = 70
            end
            object Comment_Invoice: TcxGridDBColumn
              Caption = '***'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
              DataBinding.FieldName = 'Comment_Invoice'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1057#1095#1077#1090
              Options.Editing = False
              Width = 110
            end
            object ProductCIN_Invoice: TcxGridDBColumn
              Caption = '***CIN Nr. Boat'
              DataBinding.FieldName = 'ProductCIN_Invoice'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
              Options.Editing = False
              Width = 100
            end
            object ProductCode_Invoice: TcxGridDBColumn
              Caption = '***Interne Nr Boat'
              DataBinding.FieldName = 'ProductCode_Invoice'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076' '#1083#1086#1076#1082#1080' '#1074' '#1044#1086#1082#1091#1084#1077#1085#1090#1077' '#1047#1072#1082#1072#1079#1077' '#1050#1083#1080#1077#1085#1090#1072
              Options.Editing = False
              Width = 43
            end
            object ProductName_Invoice: TcxGridDBColumn
              Caption = '***Boat'
              DataBinding.FieldName = 'ProductName_Invoice'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
              Options.Editing = False
              Width = 78
            end
            object InsertName: TcxGridDBColumn
              Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
              DataBinding.FieldName = 'InsertName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
              Options.Editing = False
              Width = 101
            end
            object InsertDate: TcxGridDBColumn
              Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
              DataBinding.FieldName = 'InsertDate'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
              Options.Editing = False
              Width = 78
            end
            object UpdateName: TcxGridDBColumn
              Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
              DataBinding.FieldName = 'UpdateName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
              Options.Editing = False
              Width = 101
            end
            object UpdateDate: TcxGridDBColumn
              Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
              DataBinding.FieldName = 'UpdateDate'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
              Options.Editing = False
              Width = 78
            end
          end
          object cxGridLevel1: TcxGridLevel
            GridView = cxGridDBTableView1
          end
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 594
        Height = 217
        Align = alTop
        Caption = 'Panel1'
        TabOrder = 23
        object dxBarDockControl3: TdxBarDockControl
          Left = 1
          Top = 1
          Width = 592
          Height = 26
          Align = dalTop
          BarManager = BarManager
        end
        object cxGrid: TcxGrid
          Left = 1
          Top = 27
          Width = 592
          Height = 189
          Align = alClient
          TabOrder = 1
          object cxGridDBTableView: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = InvoiceDS
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Summary.DefaultGroupSummaryItems = <
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn7
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn8
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn11
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn12
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn9
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn10
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn15
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn16
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn17
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn18
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn13
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn14
              end>
            DataController.Summary.FooterSummaryItems = <
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn7
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn8
              end
              item
                Format = ',0.00##'
                Kind = skSum
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn12
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn9
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn10
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn15
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn16
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn17
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn18
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn13
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn14
              end
              item
                Format = ',0.00##'
                Kind = skSum
                Column = cxGridDBColumn11
              end>
            DataController.Summary.SummaryGroups = <>
            Images = dmMain.SortImageList
            OptionsBehavior.GoToNextCellOnEnter = True
            OptionsBehavior.FocusCellOnCycle = True
            OptionsCustomize.ColumnHiding = True
            OptionsCustomize.ColumnsQuickCustomization = True
            OptionsCustomize.DataRowSizing = True
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Inserting = False
            OptionsView.Footer = True
            OptionsView.GroupByBox = False
            OptionsView.GroupSummaryLayout = gslAlignWithColumns
            OptionsView.HeaderAutoHeight = True
            OptionsView.Indicator = True
            Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
            object colStatus: TcxGridDBColumn
              Caption = #1057#1090#1072#1090#1091#1089
              DataBinding.FieldName = 'StatusCode'
              PropertiesClassName = 'TcxImageComboBoxProperties'
              Properties.Images = dmMain.ImageList
              Properties.Items = <
                item
                  Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                  ImageIndex = 11
                  Value = 1
                end
                item
                  Description = #1055#1088#1086#1074#1077#1076#1077#1085
                  ImageIndex = 12
                  Value = 2
                end
                item
                  Description = #1059#1076#1072#1083#1077#1085
                  ImageIndex = 13
                  Value = 3
                end>
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 69
            end
            object cxGridDBColumn3: TcxGridDBColumn
              Caption = 'Quittung Nr'
              DataBinding.FieldName = 'ReceiptNumber'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1054#1092#1080#1094#1080#1072#1083#1100#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1082#1074#1080#1090#1072#1085#1094#1080#1080
              Options.Editing = False
              Width = 70
            end
            object colInvNumber: TcxGridDBColumn
              Caption = 'Interne Nr'
              DataBinding.FieldName = 'InvNumber'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 63
            end
            object cxGridDBColumn4: TcxGridDBColumn
              Caption = 'Externe Nr'
              DataBinding.FieldName = 'InvNumberPartner'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1082#1083#1080#1077#1085#1090#1072
              Options.Editing = False
              Width = 55
            end
            object colOperDate: TcxGridDBColumn
              Caption = #1044#1072#1090#1072
              DataBinding.FieldName = 'OperDate'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object cxGridDBColumn5: TcxGridDBColumn
              Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099' ('#1087#1083#1072#1085')'
              DataBinding.FieldName = 'PlanDate'
              Visible = False
              FooterAlignmentHorz = taCenter
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1055#1083#1072#1085#1086#1074#1072#1103' '#1076#1072#1090#1072' '#1086#1087#1083#1072#1090#1099' '#1087#1086' '#1057#1095#1077#1090#1091
              Options.Editing = False
              Width = 70
            end
            object cxGridDBColumn6: TcxGridDBColumn
              Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
              DataBinding.FieldName = 'PaidKindName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 52
            end
            object cxGridDBColumn7: TcxGridDBColumn
              Caption = 'Debet'
              DataBinding.FieldName = 'AmountIn'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1055#1088#1080#1093#1086#1076' '#1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
              Options.Editing = False
              Width = 70
            end
            object cxGridDBColumn8: TcxGridDBColumn
              Caption = 'Kredit'
              DataBinding.FieldName = 'AmountOut'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1056#1072#1089#1093#1086#1076' '#1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
              Options.Editing = False
              Width = 70
            end
            object cxGridDBColumn9: TcxGridDBColumn
              Caption = 'Debet Vat'
              DataBinding.FieldName = 'AmountIn_VAT'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1055#1088#1080#1093#1086#1076' '#1057#1091#1084#1084#1072' '#1053#1044#1057
              Options.Editing = False
              Width = 70
            end
            object cxGridDBColumn10: TcxGridDBColumn
              Caption = 'Kredit Vat'
              DataBinding.FieldName = 'AmountOut_VAT'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1056#1072#1089#1093#1086#1076' '#1057#1091#1084#1084#1072' '#1053#1044#1057
              Options.Editing = False
              Width = 70
            end
            object cxGridDBColumn11: TcxGridDBColumn
              Caption = 'Debet no_Vat'
              DataBinding.FieldName = 'AmountIn_NotVAT'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1055#1088#1080#1093#1086#1076' '#1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
              Options.Editing = False
              Width = 70
            end
            object cxGridDBColumn12: TcxGridDBColumn
              Caption = 'Kredit no_Vat'
              DataBinding.FieldName = 'AmountOut_NotVAT'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1056#1072#1089#1093#1086#1076' '#1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
              Options.Editing = False
              Width = 70
            end
            object cxGridDBColumn13: TcxGridDBColumn
              Caption = 'Total (Payment)'
              DataBinding.FieldName = 'Amount_BankAccount'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1048#1090#1086#1075#1086' '#1054#1087#1083#1072#1090#1072' '#1087#1086' '#1057#1095#1077#1090#1091' - '#1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
              Options.Editing = False
              Width = 70
            end
            object cxGridDBColumn14: TcxGridDBColumn
              Caption = 'Total (balance)'
              DataBinding.FieldName = 'Amount_rem'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1048#1090#1086#1075#1086' '#1054#1089#1090#1072#1090#1086#1082' '#1087#1086' '#1057#1095#1077#1090#1091' - '#1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
              Options.Editing = False
              Width = 70
            end
            object cxGridDBColumn15: TcxGridDBColumn
              Caption = 'Debet (Payment)'
              DataBinding.FieldName = 'AmountIn_BankAccount'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1054#1087#1083#1072#1090#1072' '#1087#1086' '#1057#1095#1077#1090#1091' - '#1055#1088#1080#1093#1086#1076' '#1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
              Options.Editing = False
              Width = 70
            end
            object cxGridDBColumn16: TcxGridDBColumn
              Caption = 'Kredit (Payment)'
              DataBinding.FieldName = 'AmountOut_BankAccount'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1054#1087#1083#1072#1090#1072' '#1087#1086' '#1057#1095#1077#1090#1091' - '#1056#1072#1089#1093#1086#1076' '#1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
              Options.Editing = False
              Width = 70
            end
            object cxGridDBColumn17: TcxGridDBColumn
              Caption = 'Debet (balance)'
              DataBinding.FieldName = 'AmountIn_rem'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1054#1089#1090#1072#1090#1086#1082' '#1087#1086' '#1089#1095#1077#1090#1091' '#1055#1088#1080#1093#1086#1076
              Options.Editing = False
              Width = 70
            end
            object cxGridDBColumn18: TcxGridDBColumn
              Caption = 'Kredit (balance)'
              DataBinding.FieldName = 'AmountOut_rem'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1054#1089#1090#1072#1090#1086#1082' '#1087#1086' '#1089#1095#1077#1090#1091' '#1056#1072#1089#1093#1086#1076
              Options.Editing = False
              Width = 70
            end
            object cxGridDBColumn19: TcxGridDBColumn
              Caption = '% '#1053#1044#1057
              DataBinding.FieldName = 'VATPercent'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
              Visible = False
              Options.Editing = False
              Width = 60
            end
            object cxGridDBColumn20: TcxGridDBColumn
              Caption = 'Lieferanten / Kunden'
              DataBinding.FieldName = 'ObjectName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1055#1086#1089#1090#1072#1074#1097#1080#1082' / '#1050#1083#1080#1077#1085#1090
              Options.Editing = False
              Width = 128
            end
            object cxGridDBColumn21: TcxGridDBColumn
              Caption = #1069#1083#1077#1084#1077#1085#1090
              DataBinding.FieldName = 'DescName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object cxGridDBColumn22: TcxGridDBColumn
              Caption = #1050#1086#1076' '#1059#1055
              DataBinding.FieldName = 'InfoMoneyCode'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 33
            end
            object cxGridDBColumn23: TcxGridDBColumn
              Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
              DataBinding.FieldName = 'InfoMoneyGroupName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object cxGridDBColumn24: TcxGridDBColumn
              Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
              DataBinding.FieldName = 'InfoMoneyDestinationName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
            end
            object cxGridDBColumn25: TcxGridDBColumn
              Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
              DataBinding.FieldName = 'InfoMoneyName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 83
            end
            object cxGridDBColumn26: TcxGridDBColumn
              Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
              DataBinding.FieldName = 'InfoMoneyName_all'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 80
            end
            object cxGridDBColumn27: TcxGridDBColumn
              Caption = #1050#1086#1076' '#1087#1086#1076#1088'.'
              DataBinding.FieldName = 'UnitCode'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 55
            end
            object cxGridDBColumn28: TcxGridDBColumn
              Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
              DataBinding.FieldName = 'UnitName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 101
            end
            object cxGridDBColumn29: TcxGridDBColumn
              Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
              DataBinding.FieldName = 'Comment'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 95
            end
            object cxGridDBColumn30: TcxGridDBColumn
              Caption = 'CIN Nr.'
              DataBinding.FieldName = 'ProductCIN'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 100
            end
            object cxGridDBColumn31: TcxGridDBColumn
              Caption = 'Interne Nr (Boat)'
              DataBinding.FieldName = 'ProductCode'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1042#1085#1091#1090#1088#1077#1085#1085#1080#1081' '#1082#1086#1076' '#1083#1086#1076#1082#1080
              Options.Editing = False
              Width = 43
            end
            object cxGridDBColumn32: TcxGridDBColumn
              Caption = 'Boat'
              DataBinding.FieldName = 'ProductName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 78
            end
            object cxGridDBColumn33: TcxGridDBColumn
              Caption = #1047#1072#1082#1072#1079
              DataBinding.FieldName = 'InvNumber_parent'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 109
            end
            object cxGridDBColumn34: TcxGridDBColumn
              Caption = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
              DataBinding.FieldName = 'DescName_parent'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 110
            end
            object cxGridDBColumn35: TcxGridDBColumn
              Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
              DataBinding.FieldName = 'InsertName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
              Options.Editing = False
              Width = 101
            end
            object cxGridDBColumn36: TcxGridDBColumn
              Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
              DataBinding.FieldName = 'InsertDate'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
              Options.Editing = False
              Width = 78
            end
            object cxGridDBColumn37: TcxGridDBColumn
              Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
              DataBinding.FieldName = 'UpdateName'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
              Options.Editing = False
              Width = 101
            end
            object cxGridDBColumn38: TcxGridDBColumn
              Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
              DataBinding.FieldName = 'UpdateDate'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
              Options.Editing = False
              Width = 85
            end
            object cxGridDBColumn39: TcxGridDBColumn
              DataBinding.FieldName = 'Color_Pay'
              Visible = False
              Options.Editing = False
              VisibleForCustomization = False
              Width = 30
            end
          end
          object cxGridLevel: TcxGridLevel
            GridView = cxGridDBTableView
          end
        end
      end
    end
  end
  object ActionList: TActionList
    Left = 136
    Top = 163
    object actDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelectInvoice
        end
        item
          StoredProc = spSelectBank
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actDataSetRefreshBank: TdsdDataSetRefresh
      Category = 'Doc'
      MoveParams = <>
      StoredProc = spSelectBank
      StoredProcList = <
        item
          StoredProc = spSelectBank
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object actFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
    object UnCompleteMovementInvoice: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatusInvoice
      StoredProcList = <
        item
          StoredProc = spChangeStatusInvoice
        end
        item
        end
        item
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 11
      Status = mtUncomplete
      Guides = GuidesStatusInvoice
    end
    object actGetCIN: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGetCIN
      StoredProcList = <
        item
          StoredProc = spGetCIN
        end>
      Caption = 'get CIN'
      Hint = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' CIN Nr.'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actShowErasedBank: TBooleanStoredProcAction
      Category = 'Doc'
      MoveParams = <>
      StoredProc = spSelectBank
      StoredProcList = <
        item
          StoredProc = spSelectBank
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object CompleteMovementInvoice: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatusInvoice
      StoredProcList = <
        item
          StoredProc = spChangeStatusInvoice
        end
        item
        end
        item
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      Guides = GuidesStatusInvoice
    end
    object UnCompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 11
      Status = mtUncomplete
      Guides = GuidesStatus
    end
    object DeleteMovementInvoice: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatusInvoice
      StoredProcList = <
        item
          StoredProc = spChangeStatusInvoice
        end
        item
        end
        item
        end>
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      Hint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      ImageIndex = 13
      Status = mtDelete
      Guides = GuidesStatusInvoice
    end
    object CompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      Guides = GuidesStatus
    end
    object DeleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      Hint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      ImageIndex = 13
      Status = mtDelete
      Guides = GuidesStatus
    end
    object actDataSetRefreshInv: TdsdDataSetRefresh
      Category = 'Doc'
      MoveParams = <>
      StoredProc = spSelectInvoice
      StoredProcList = <
        item
          StoredProc = spSelectInvoice
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actUnComplete: TdsdChangeMovementStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 11
      Status = mtUncomplete
    end
    object actComplete: TdsdChangeMovementStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
    end
    object actSetErased: TdsdChangeMovementStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      Hint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      ImageIndex = 13
      Status = mtDelete
    end
    object mactLoadAgilis_all: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actLoadAgilis
        end
        item
          Action = mactInsertUpdate_load
        end
        item
          Action = actDataSetRefresh
        end
        item
          Action = mactLoad_Doc
        end
        item
          Action = mactLoad_Photo
        end
        item
          Action = actGetCIN
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089' '#1089#1072#1081#1090#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1079#1072#1082#1072#1079' '#1082#1083#1080#1077#1085#1090#1072' '#1089' '#1089#1072#1081#1090#1072
    end
    object actMovementProtocolOpenFormBank: TdsdOpenForm
      Category = 'Doc'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1054#1087#1083#1072#1090#1099'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1054#1087#1083#1072#1090#1099'>'
      ImageIndex = 34
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = 'TMovementProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = BankCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = BankCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actLoadAgilis: TdsdLoadAgilis
      Category = 'DSDLib'
      MoveParams = <>
      URLParam.Value = 
        'https://agilis-jettenders.com/wp-admin/admin-ajax.php?action=cat' +
        'alog_csv3&order='
      URLParam.DataType = ftString
      URLParam.MultiSelectSeparator = ','
      OrderParam.Value = ''
      OrderParam.Component = edInvNumberOrderClient_load
      OrderParam.DataType = ftString
      OrderParam.MultiSelectSeparator = ','
      DataSet = ClientDataSet
      CreateFileTitleParam.Value = True
      CreateFileTitleParam.DataType = ftBoolean
      CreateFileTitleParam.MultiSelectSeparator = ','
      FieldCountParam.Value = 20
      FieldCountParam.MultiSelectSeparator = ','
      FieldTitleParam.Value = 'Title'
      FieldTitleParam.DataType = ftString
      FieldTitleParam.MultiSelectSeparator = ','
      FieldValueParam.Value = 'Value'
      FieldValueParam.DataType = ftString
      FieldValueParam.MultiSelectSeparator = ','
      Caption = 'actLoadAgilis'
    end
    object mactInsertUpdate_load: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdate_load
        end>
      DataSource = DS
      Caption = 'mactInsertUpdate_load'
    end
    object actInsertUpdate_load: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_load
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_load
        end>
      Caption = 'actInsertUpdate_load'
    end
    object mactLoad_Doc: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_ProductDocument
        end
        item
          Action = actLoadFile_Doc
        end
        item
          Action = actInsertUpdate_Doc
        end>
      Caption = 'mactLoad_Doc'
    end
    object actGet_ProductPhoto: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_ProductPhoto
      StoredProcList = <
        item
          StoredProc = spGet_ProductPhoto
        end>
      Caption = 'actGet_ProductPhoto'
    end
    object actGet_ProductDocument: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_ProductDocument
      StoredProcList = <
        item
          StoredProc = spGet_ProductDocument
        end>
      Caption = 'actGet_ProductDocument'
    end
    object actLoadFile_Doc: TdsdLoadFile_https
      Category = 'DSDLib'
      MoveParams = <>
      URLParam.Value = 
        'https://agilis-jettenders.com/constructor-pdf/agilis-configurati' +
        'on-'
      URLParam.Component = FormParams
      URLParam.ComponentItem = 'inUrl_Doc'
      URLParam.DataType = ftString
      URLParam.MultiSelectSeparator = ','
      DataParam.Value = ''
      DataParam.Component = FormParams
      DataParam.ComponentItem = 'inDocument'
      DataParam.DataType = ftWideString
      DataParam.MultiSelectSeparator = ','
      Caption = 'actLoadFile_Doc'
    end
    object actInsertUpdate_Doc: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_ProductDocument
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_ProductDocument
        end>
      Caption = 'actInsertUpdate_Doc'
    end
    object mactLoad_Photo: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_ProductPhoto
        end
        item
          Action = actLoadFile_Photo
        end
        item
          Action = actInsertUpdate_Photo
        end>
      Caption = 'mactLoad_Photo'
    end
    object actLoadFile_Photo: TdsdLoadFile_https
      Category = 'DSDLib'
      MoveParams = <>
      URLParam.Value = 
        'https://agilis-jettenders.com/constructor-images/order-construct' +
        'or-'
      URLParam.Component = FormParams
      URLParam.ComponentItem = 'inUrl_Photo'
      URLParam.DataType = ftString
      URLParam.MultiSelectSeparator = ','
      DataParam.Value = Null
      DataParam.Component = FormParams
      DataParam.ComponentItem = 'inPhoto'
      DataParam.DataType = ftWideString
      DataParam.MultiSelectSeparator = ','
      Caption = 'actLoadFile_Photo'
    end
    object actInsertUpdate_Photo: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_ProductPhoto
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_ProductPhoto
        end>
      Caption = 'actInsertUpdate_Photo'
    end
    object actGet: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelectInvoice
        end>
      Caption = 'actGet'
    end
    object mactGet: TMultiAction
      Category = 'Doc'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdate
        end
        item
          Action = actGet
        end>
      Caption = 'mactGet'
    end
    object actInsertUpdate: TdsdExecStoredProc
      Category = 'Doc'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end
        item
        end>
      Caption = 'actInsertUpdate'
    end
    object actInsertInv: TdsdInsertUpdateAction
      Category = 'Doc'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1057#1095#1077#1090
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1057#1095#1077#1090
      ImageIndex = 0
      FormName = 'TInvoiceForm'
      FormNameParam.Value = 'TInvoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 44197d
          Component = InvoiceCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_OrderClient'
          Value = '0'
          Component = FormParams
          ComponentItem = 'inMovementId_OrderClient'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProductId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ClientId'
          Value = Null
          Component = GuidesClient
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = InvoiceDS
      DataSetRefresh = actDataSetRefreshInv
      IdFieldName = 'Id'
    end
    object actUpdateInv: TdsdInsertUpdateAction
      Category = 'Doc'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1057#1095#1077#1090
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1057#1095#1077#1090
      ImageIndex = 1
      FormName = 'TInvoiceForm'
      FormNameParam.Value = 'TInvoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = InvoiceCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 44197d
          Component = InvoiceCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSetRefresh = actDataSetRefreshInv
      IdFieldName = 'Id'
    end
    object actCompleteInv: TdsdChangeMovementStatus
      Category = 'Doc'
      MoveParams = <>
      StoredProc = spMovementCompleteInv
      StoredProcList = <
        item
          StoredProc = spMovementCompleteInv
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      DataSource = InvoiceDS
    end
    object actUnCompleteInv: TdsdChangeMovementStatus
      Category = 'Doc'
      MoveParams = <>
      StoredProc = spMovementUnCompleteInv
      StoredProcList = <
        item
          StoredProc = spMovementUnCompleteInv
        end>
      Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 11
      Status = mtUncomplete
      DataSource = InvoiceDS
    end
    object actSetErasedInv: TdsdChangeMovementStatus
      Category = 'Doc'
      MoveParams = <>
      StoredProc = spMovementSetErasedInv
      StoredProcList = <
        item
          StoredProc = spMovementSetErasedInv
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 13
      Status = mtDelete
      DataSource = InvoiceDS
    end
    object actShowErasedInv: TBooleanStoredProcAction
      Category = 'Doc'
      MoveParams = <>
      StoredProc = spSelectInvoice
      StoredProcList = <
        item
          StoredProc = spSelectInvoice
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actInsertBank: TdsdInsertUpdateAction
      Category = 'Doc'
      MoveParams = <>
      AfterAction = actDataSetRefreshInv
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1054#1087#1083#1072#1090#1091
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1054#1087#1083#1072#1090#1091
      ImageIndex = 0
      FormName = 'TBankAccountMovementForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 44197d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_parent'
          Value = Null
          Component = FormParams
          ComponentItem = 'inMovementId_OrderClient'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMoneyPlaceId'
          Value = Null
          Component = GuidesClient
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_Invoice'
          Value = Null
          Component = InvoiceCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSetRefresh = actDataSetRefreshBank
      IdFieldName = 'Id'
    end
    object actUpdateBank: TdsdInsertUpdateAction
      Category = 'Doc'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1087#1083#1072#1090#1091
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1087#1083#1072#1090#1091
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TBankAccountMovementForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = BankCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
          Component = BankCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 44197d
          Component = BankCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSetRefresh = actDataSetRefreshBank
      IdFieldName = 'Id'
    end
    object actCompleteBank: TdsdChangeMovementStatus
      Category = 'Doc'
      MoveParams = <>
      StoredProc = spMovementCompleteBank
      StoredProcList = <
        item
          StoredProc = spMovementCompleteBank
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      DataSource = BankDS
    end
    object actUnCompleteBank: TdsdChangeMovementStatus
      Category = 'Doc'
      MoveParams = <>
      StoredProc = spMovementUnCompleteBank
      StoredProcList = <
        item
          StoredProc = spMovementUnCompleteBank
        end>
      Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 11
      Status = mtUncomplete
      DataSource = BankDS
    end
    object actSetErasedBank: TdsdChangeMovementStatus
      Category = 'Doc'
      MoveParams = <>
      StoredProc = spMovementSetErasedBank
      StoredProcList = <
        item
          StoredProc = spMovementSetErasedBank
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 13
      Status = mtDelete
      DataSource = BankDS
    end
    object actPrintInvoice: TdsdPrintAction
      Category = 'Doc'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090#1072
      ImageIndex = 3
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 44197d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 44197d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Invoice'
      ReportNameParam.Value = 'PrintMovement_Invoice'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actMovementProtocolOpenForm: TdsdOpenForm
      Category = 'Doc'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090'>'
      ImageIndex = 34
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = 'TMovementProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = InvoiceCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = InvoiceCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macInsertInv: TMultiAction
      Category = 'Doc'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertInv
        end
        item
          Action = actSelectInvoice
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1057#1095#1077#1090
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1057#1095#1077#1090
      ImageIndex = 0
    end
    object actSelectInvoice: TdsdExecStoredProc
      Category = 'Doc'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectInvoice
      StoredProcList = <
        item
          StoredProc = spSelectInvoice
        end>
      Caption = 'actSelectInvoice'
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Product'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = edCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBrandId'
        Value = Null
        Component = GuidesBrand
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inModelId'
        Value = Null
        Component = GuidesModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEngineId'
        Value = Null
        Component = GuidesProdEngine
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptProdModelId'
        Value = Null
        Component = GuidesReceiptProdModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inClientId'
        Value = Null
        Component = GuidesClient
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsBasicConf'
        Value = Null
        Component = cbBasicConf
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsProdColorPattern'
        Value = Null
        Component = cbProdColorPattern
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHours'
        Value = Null
        Component = edHours
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountTax'
        Value = Null
        Component = edDiscountTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountNextTax'
        Value = Null
        Component = edDiscountNextTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummTax'
        Value = Null
        Component = edSummTax
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummReal'
        Value = Null
        Component = edSummReal
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTransportSumm_load'
        Value = Null
        Component = edTransportSumm_load
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateStart'
        Value = Null
        Component = edDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateBegin'
        Value = Null
        Component = edDateBegin
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateSale'
        Value = Null
        Component = edDateSale
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCIN'
        Value = Null
        Component = edCIN
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEngineNum'
        Value = Null
        Component = edEngineNum
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber_OrderClient'
        Value = Null
        Component = edInvNumberOrderClient
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate_OrderClient'
        Value = Null
        Component = edOperDateOrderClient
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNPP_OrderClient'
        Value = Null
        Component = edNPP
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Invoice'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId_Invoice'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber_Invoice'
        Value = Null
        Component = edInvNumberInvoice
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate_Invoice'
        Value = Null
        Component = edOperDateInvoice
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountIn_Invoice'
        Value = Null
        Component = ceAmountInInvoice
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountOut_Invoice'
        Value = Null
        Component = ceAmountInInvoiceAll
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 136
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Invoice'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocument'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhoto'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUrl_Doc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUrl_Photo'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 56
    Top = 64
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Product'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCode
        DataType = ftUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'Hours'
        Value = Null
        Component = edHours
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateStart'
        Value = Null
        Component = edDateStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateBegin'
        Value = Null
        Component = edDateBegin
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateSale'
        Value = Null
        Component = edDateSale
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'CIN'
        Value = Null
        Component = edCIN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'EngineNum'
        Value = Null
        Component = edEngineNum
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandId'
        Value = Null
        Component = GuidesBrand
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandName'
        Value = Null
        Component = GuidesBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelId'
        Value = Null
        Component = GuidesModel
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelName'
        Value = Null
        Component = GuidesModel
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelName_full'
        Value = Null
        Component = FormParams
        ComponentItem = 'ModelName_full'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'EngineId'
        Value = Null
        Component = GuidesProdEngine
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'EngineName'
        Value = Null
        Component = GuidesProdEngine
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isBasicConf'
        Value = Null
        Component = cbBasicConf
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isProdColorPattern'
        Value = Null
        Component = cbProdColorPattern
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptProdModelId'
        Value = Null
        Component = GuidesReceiptProdModel
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptProdModelName'
        Value = Null
        Component = GuidesReceiptProdModel
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ClientId'
        Value = Null
        Component = GuidesClient
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ClientName'
        Value = Null
        Component = GuidesClient
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = Null
        Component = edDiscountTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountNextTax'
        Value = Null
        Component = edDiscountNextTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_OrderClient'
        Value = Null
        Component = edInvNumberOrderClient
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_OrderClient_load'
        Value = Null
        Component = edInvNumberOrderClient_load
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_OrderClient'
        Value = Null
        Component = edOperDateOrderClient
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode_OrderClient'
        Value = Null
        Component = GuidesStatus
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName_OrderClient'
        Value = Null
        Component = GuidesStatus
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent_OrderClient'
        Value = Null
        Component = edVATPercentOrderClient
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'NPP_OrderClient'
        Value = Null
        Component = edNPP
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummMVAT'
        Value = Null
        Component = edTotalSummMVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPVAT'
        Value = Null
        Component = edTotalSummPVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummVAT'
        Value = Null
        Component = edTotalSummVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperPrice_load'
        Value = Null
        Component = edOperPrice_load
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TransportSumm_load'
        Value = Null
        Component = edTransportSumm_load
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Invoice'
        Value = Null
        Component = edInvNumberInvoice
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_Invoice'
        Value = Null
        Component = edOperDateInvoice
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode_Invoice'
        Value = Null
        Component = GuidesStatusInvoice
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName_Invoice'
        Value = Null
        Component = GuidesStatusInvoice
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn_Invoice'
        Value = Null
        Component = ceAmountInInvoice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn_InvoiceAll'
        Value = Null
        Component = ceAmountInInvoiceAll
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn_BankAccount'
        Value = Null
        Component = ceAmountInBankAccount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn_BankAccountAll'
        Value = Null
        Component = ceAmountInBankAccountAll
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn_BankAccount'
        Value = Null
        Component = ceAmountInBankAccount2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn_BankAccountAll'
        Value = Null
        Component = ceAmountInBankAccountAll2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn_remAll'
        Value = Null
        Component = edAmountIn_remAll
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Invoice'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId_Invoice'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn_rem'
        Value = Null
        Component = edAmountIn_rem
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummTax'
        Value = Null
        Component = edSummTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummReal'
        Value = Null
        Component = edSummReal
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_BankAccount'
        Value = Null
        Component = edInvNumberBankAccount3
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_BankAccount'
        Value = Null
        Component = edOperDateBankAccount
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountId'
        Value = Null
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountName'
        Value = Null
        Component = GuidesBankAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn_BankAccountLast'
        Value = Null
        Component = edSummaBank
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn_InvoiceAll'
        Value = Null
        Component = ceAmountInInvoiceAll
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn_Invoice'
        Value = Null
        Component = ceAmountInInvoice2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_BankAccount'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId_BankAccount'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 64
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 128
    Top = 441
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 248
    Top = 417
  end
  object GuidesBrand: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBrand
    FormNameParam.Value = 'TBrandForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBrandForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 255
    Top = 196
  end
  object GuidesModel: TdsdGuides
    KeyField = 'Id'
    LookupControl = edModel
    FormNameParam.Value = 'TProdModelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProdModelForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesModel
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandId'
        Value = Null
        Component = GuidesBrand
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandName'
        Value = Null
        Component = GuidesBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdEngineId'
        Value = Null
        Component = GuidesProdEngine
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdEngineName'
        Value = Null
        Component = GuidesProdEngine
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptProdModelId'
        Value = Null
        Component = GuidesReceiptProdModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptProdModelName'
        Value = Null
        Component = GuidesReceiptProdModel
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 519
    Top = 338
  end
  object GuidesProdEngine: TdsdGuides
    KeyField = 'Id'
    LookupControl = edEngine
    FormNameParam.Value = 'TProdEngineForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProdEngineForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesProdEngine
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesProdEngine
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 264
    Top = 252
  end
  object GuidesReceiptProdModel: TdsdGuides
    KeyField = 'Id'
    LookupControl = edReceiptProdModel
    FormNameParam.Value = 'TReceiptProdModelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TReceiptProdModelForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesReceiptProdModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesReceiptProdModel
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandId'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandName'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdEngineId'
        Value = ''
        Component = GuidesProdEngine
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdEngineName'
        Value = ''
        Component = GuidesProdEngine
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelId'
        Value = Null
        Component = GuidesModel
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelName_full'
        Value = Null
        Component = FormParams
        ComponentItem = 'ModelName_full'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 335
    Top = 308
  end
  object GuidesClient: TdsdGuides
    KeyField = 'Id'
    LookupControl = edClient
    FormNameParam.Value = 'TClientForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TClientForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesClient
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesClient
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = Null
        Component = edDiscountTax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKind_Value'
        Value = Null
        Component = edVATPercentOrderClient
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 297
    Top = 56
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    ComponentList = <
      item
        Component = GuidesModel
      end
      item
        Component = edDateStart
      end>
    Left = 144
    Top = 64
  end
  object spGetCIN: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Product_CIN'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inModelId'
        Value = ''
        Component = GuidesModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateStart'
        Value = 42160d
        Component = edDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCIN'
        Value = ''
        Component = edCIN
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 208
  end
  object spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_OrderClient'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStatusCode'
        Value = ''
        Component = GuidesStatus
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsChild_Recalc'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 236
    Top = 30
  end
  object GuidesStatus: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatus
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 551
    Top = 262
  end
  object BarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 56
    Top = 337
    DockControlHeights = (
      0
      0
      0
      0)
    object BarManagerBar1: TdxBar
      Caption = 'Bar_Invoice'
      CaptionButtons = <>
      DockControl = dxBarDockControl3
      DockedDockControl = dxBarDockControl3
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 494
      FloatTop = 468
      FloatClientWidth = 51
      FloatClientHeight = 22
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertInv'
        end
        item
          Visible = True
          ItemName = 'bbUpdateInv'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbCompleteInv'
        end
        item
          Visible = True
          ItemName = 'bbUnCompleteInv'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedInv'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbDataSetRefreshInv'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbShowErasedInv'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbPrintInvoice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbMovementProtocolOpenForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object BarManagerBar2: TdxBar
      Caption = 'Bar_Bank'
      CaptionButtons = <>
      DockControl = dxBarDockControl1
      DockedDockControl = dxBarDockControl1
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 634
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertBank'
        end
        item
          Visible = True
          ItemName = 'bbUpdateBank'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbCompleteBank'
        end
        item
          Visible = True
          ItemName = 'bbUnCompleteBank'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedBank'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbDataSetRefreshBank'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbShowErasedBank'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenFormBank'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbCompleteMovement: TdxBarButton
      Action = CompleteMovement
      Category = 0
    end
    object bbDeleteMovement: TdxBarButton
      Action = DeleteMovement
      Category = 0
    end
    object bbDeleteDocument: TdxBarButton
      Action = UnCompleteMovement
      Category = 0
    end
    object bbInsertInv: TdxBarButton
      Action = actInsertInv
      Category = 0
      CloseSubMenuOnClick = False
    end
    object bbUpdateInv: TdxBarButton
      Action = actUpdateInv
      Category = 0
    end
    object bbCompleteInv: TdxBarButton
      Action = actCompleteInv
      Category = 0
    end
    object bbUnCompleteInv: TdxBarButton
      Action = actUnCompleteInv
      Category = 0
    end
    object bbSetErasedInv: TdxBarButton
      Action = actSetErasedInv
      Category = 0
    end
    object dxBarStatic1: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object bbShowErasedInv: TdxBarButton
      Action = actShowErasedInv
      Category = 0
    end
    object bbCompleteBank: TdxBarButton
      Action = actCompleteBank
      Category = 0
    end
    object bbInsertBank: TdxBarButton
      Action = actInsertBank
      Category = 0
    end
    object bbSetErasedBank: TdxBarButton
      Action = actSetErasedBank
      Category = 0
    end
    object bbUnCompleteBank: TdxBarButton
      Action = actUnCompleteBank
      Category = 0
    end
    object bbUpdateBank: TdxBarButton
      Action = actUpdateBank
      Category = 0
    end
    object bbShowErasedBank: TdxBarButton
      Action = actShowErasedBank
      Category = 0
    end
    object bbPrintInvoice: TdxBarButton
      Action = actPrintInvoice
      Category = 0
    end
    object bbMovementProtocolOpenForm: TdxBarButton
      Action = actMovementProtocolOpenForm
      Category = 0
    end
    object bbProtocolOpenFormBank: TdxBarButton
      Action = actMovementProtocolOpenFormBank
      Category = 0
    end
    object bbDataSetRefreshInv: TdxBarButton
      Action = actDataSetRefreshInv
      Category = 0
    end
    object bbDataSetRefreshBank: TdxBarButton
      Action = actDataSetRefreshBank
      Category = 0
    end
  end
  object GuidesStatusInvoice: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatusInvoice
    DisableGuidesOpen = True
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 583
    Top = 78
  end
  object spChangeStatusInvoice: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Invoice'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId_Invoice'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStatusCode'
        Value = ''
        Component = GuidesStatusInvoice
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 44
    Top = 118
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 288
    Top = 473
  end
  object DS: TDataSource
    DataSet = ClientDataSet
    Left = 382
    Top = 439
  end
  object spInsertUpdate_load: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_OrderClient_load'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioProductId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioMovementId_OrderClient'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId_OrderClient'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = Null
        Component = edInvNumberOrderClient_load
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTitle'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Title'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTitle1'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Title1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue1'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTitle2'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Title2'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue2'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value2'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTitle3'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Title3'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue3'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value3'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTitle4'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Title4'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue4'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value4'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTitle5'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Title5'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue5'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value5'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTitle6'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Title6'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue6'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value6'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTitle7'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Title7'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue7'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value7'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTitle8'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Title8'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue8'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value8'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTitle9'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Title9'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue9'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value9'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTitle10'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Title10'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue10'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value10'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTitle11'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Title11'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue11'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value11'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTitle12'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Title12'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue12'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Value12'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 488
    Top = 408
  end
  object spInsertUpdate_ProductDocument: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ProductDocument'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProductId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProductDocumentData'
        Value = Null
        Component = FormParams
        ComponentItem = 'inDocument'
        DataType = ftBlob
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 392
    Top = 256
  end
  object spInsertUpdate_ProductPhoto: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ProductPhoto'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhotoName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProductId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProductPhotoData'
        Value = Null
        Component = FormParams
        ComponentItem = 'inPhoto'
        DataType = ftBlob
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 408
    Top = 328
  end
  object spGet_ProductDocument: TdsdStoredProc
    StoredProcName = 'gpGet_Object_ProductDocument_https'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inProductId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outHttps'
        Value = Null
        Component = FormParams
        ComponentItem = 'inUrl_Doc'
        DataType = ftBlob
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 400
    Top = 224
  end
  object spGet_ProductPhoto: TdsdStoredProc
    StoredProcName = 'gpGet_Object_ProductPhoto_https'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inProductId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outHttps'
        Value = Null
        Component = FormParams
        ComponentItem = 'inUrl_Photo'
        DataType = ftBlob
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 288
    Top = 216
  end
  object HeaderExit: THeaderExit
    ExitList = <
      item
        Control = edDiscountTax
      end
      item
        Control = edDiscountNextTax
      end
      item
        Control = edSummTax
      end
      item
        Control = edSummReal
      end>
    Action = mactGet
    Left = 552
    Top = 200
  end
  object spInsertUpdateBank: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_BankAccountByProduct'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioid'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MovementId_BankAccount'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inoperdate'
        Value = 44231d
        Component = edOperDateBankAccount
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = Null
        Component = edInvNumberBankAccount3
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inamountin'
        Value = 0.000000000000000000
        Component = edSummaBank
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountId'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMoneyPlaceId'
        Value = ''
        Component = GuidesClient
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Invoice'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inMovementId_Invoice'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Parent'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inMovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 600
    Top = 176
  end
  object GuidesBankAccount: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBankAccount
    FormNameParam.Value = 'TBankAccountForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankAccountForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyValue'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParValue'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 44231d
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 594
    Top = 116
  end
  object InvoiceCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 24
    Top = 328
  end
  object InvoiceDS: TDataSource
    DataSet = InvoiceCDS
    Left = 104
    Top = 312
  end
  object dsdDBViewAddOnInvoice: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <
      item
        FieldName = 'Image1'
      end
      item
        FieldName = 'Image2'
      end
      item
        FieldName = 'Image3'
      end>
    PropertiesCellList = <>
    Left = 56
    Top = 168
  end
  object BankCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 32
    Top = 424
  end
  object BankDS: TDataSource
    DataSet = BankCDS
    Left = 32
    Top = 472
  end
  object dsdDBViewAddOnBank: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <
      item
        FieldName = 'Image1'
      end
      item
        FieldName = 'Image2'
      end
      item
        FieldName = 'Image3'
      end>
    PropertiesCellList = <>
    Left = 80
    Top = 448
  end
  object spMovementCompleteInv: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Invoice'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = InvoiceCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 176
    Top = 328
  end
  object spMovementSetErasedInv: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_Invoice'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = InvoiceCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 232
    Top = 320
  end
  object spMovementUnCompleteInv: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_Invoice'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = InvoiceCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 208
    Top = 344
  end
  object spSelectInvoice: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_InvoiceByProduct'
    DataSet = InvoiceCDS
    DataSets = <
      item
        DataSet = InvoiceCDS
      end>
    Params = <
      item
        Name = 'inProductId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErasedInv
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 288
    Top = 376
  end
  object spMovementCompleteBank: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_BankAccount'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = BankCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 400
    Top = 504
  end
  object spMovementSetErasedBank: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_BankAccount'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = BankCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 488
    Top = 504
  end
  object spMovementUnCompleteBank: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_BankAccount'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = BankCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 448
    Top = 496
  end
  object spSelectBank: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_BankAccountByProduct'
    DataSet = BankCDS
    DataSets = <
      item
        DataSet = BankCDS
      end>
    Params = <
      item
        Name = 'inProductId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErasedBank
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 456
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Invoice_Print'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = InvoiceCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 112
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 262
  end
end
