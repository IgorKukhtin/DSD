object CashSettingsEditForm: TCashSettingsEditForm
  Left = 0
  Top = 0
  Caption = #1054#1073#1097#1080#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1082#1072#1089#1089
  ClientHeight = 578
  ClientWidth = 898
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxPageControl1: TcxPageControl
    Left = 0
    Top = 30
    Width = 898
    Height = 507
    Align = alClient
    TabOrder = 1
    Properties.ActivePage = cxTabSheet1
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 507
    ClientRectRight = 898
    ClientRectTop = 24
    object cxTabSheet1: TcxTabSheet
      Caption = #1054#1073#1097#1080#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080
      ImageIndex = 0
      object cxLabel1: TcxLabel
        Left = 14
        Top = 3
        Caption = 
          #1055#1077#1088#1077#1095#1077#1085#1100' '#1092#1088#1072#1079' '#1074' '#1085#1072#1079#1074#1072#1085#1080#1103#1093' '#1090#1086#1074#1072#1088#1086#1074' '#1082#1086#1090#1086#1088#1099#1077' '#1084#1086#1078#1085#1086' '#1076#1077#1083#1080#1090#1100' '#1089' '#1083#1102#1073#1086#1081' '#1094 +
          #1077#1085#1086#1081
      end
      object cxLabel2: TcxLabel
        Left = 14
        Top = 44
        Caption = #1055#1077#1088#1077#1095#1077#1085#1100' '#1082#1086#1076#1086#1074' '#1090#1086#1074#1072#1088#1086#1074' '#1082#1086#1090#1086#1088#1099#1077' '#1084#1086#1078#1085#1086' '#1076#1077#1083#1080#1090#1100' '#1089' '#1083#1102#1073#1086#1081' '#1094#1077#1085#1086#1081
      end
      object cxLabel22: TcxLabel
        Left = 529
        Top = 3
        Caption = #1058#1086#1082#1077#1085' '#1090#1077#1083#1077#1075#1088#1072#1084' '#1073#1086#1090#1072
      end
      object edShareFromPriceCode: TcxTextEdit
        Left = 14
        Top = 64
        TabOrder = 3
        Width = 509
      end
      object edShareFromPriceName: TcxTextEdit
        Left = 14
        Top = 23
        TabOrder = 4
        Width = 509
      end
      object edTelegramBotToken: TcxTextEdit
        Left = 529
        Top = 23
        TabOrder = 5
        Width = 349
      end
      object cbBlockVIP: TcxCheckBox
        Left = 260
        Top = 107
        Hint = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
        Caption = #1041#1083#1086#1082#1080#1088#1086#1074#1072#1090#1100' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' VIP'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        Width = 269
      end
      object cbGetHardwareData: TcxCheckBox
        Left = 20
        Top = 89
        Hint = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
        Caption = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        Width = 215
      end
      object cbPairedOnlyPromo: TcxCheckBox
        Left = 535
        Top = 89
        Hint = #1055#1088#1080' '#1086#1087#1091#1089#1082#1072#1085#1080#1080' '#1087#1072#1088#1085#1099#1093' '#1082#1086#1085#1090#1088#1086#1083#1080#1088#1086#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1072#1082#1094#1080#1086#1085#1085#1099#1081
        Caption = #1055#1088#1080' '#1086#1087#1091#1089#1082#1072#1085#1080#1080' '#1087#1072#1088#1085#1099#1093' '#1082#1086#1085#1090#1088#1086#1083#1080#1088#1086#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1072#1082#1094#1080#1086#1085#1085#1099#1081
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        Width = 338
      end
      object cbRemovingPrograms: TcxCheckBox
        Left = 20
        Top = 108
        Hint = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
        Caption = #1059#1076#1072#1083#1077#1085#1080#1077' '#1089#1090#1086#1088#1086#1085#1085#1080#1093' '#1087#1088#1086#1075#1088#1072#1084#1084
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        Width = 215
      end
      object cbRequireUkrName: TcxCheckBox
        Left = 260
        Top = 89
        Hint = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
        Caption = #1058#1088#1077#1073#1086#1074#1072#1090#1100' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1059#1082#1088#1072#1080#1085#1089#1082#1086#1075#1086' '#1085#1072#1079#1074#1072#1085#1080#1103
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
        Width = 269
      end
      object cdWagesCheckTesting: TcxCheckBox
        Left = 535
        Top = 107
        Hint = #1050#1086#1085#1090#1088#1086#1083#1100' '#1089#1076#1072#1095#1080' '#1101#1082#1079#1072#1084#1077#1085' '#1087#1088#1080' '#1074#1099#1076#1072#1095#1072' '#1079#1072#1088#1087#1083#1072#1090#1099
        Caption = #1050#1086#1085#1090#1088#1086#1083#1100' '#1089#1076#1072#1095#1080' '#1101#1082#1079#1072#1084#1077#1085' '#1087#1088#1080' '#1074#1099#1076#1072#1095#1072' '#1079#1072#1088#1087#1083#1072#1090#1099
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
        Width = 338
      end
      object ceCustomerThreshold: TcxCurrencyEdit
        Left = 402
        Top = 335
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 12
        Width = 121
      end
      object ceDayCompensDiscount: TcxCurrencyEdit
        Left = 402
        Top = 313
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 13
        Width = 121
      end
      object cePercentIC: TcxCurrencyEdit
        Left = 402
        Top = 378
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 14
        Width = 121
      end
      object cePriceCorrectionDay: TcxCurrencyEdit
        Left = 402
        Top = 356
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 15
        Width = 121
      end
      object cxLabel10: TcxLabel
        Left = 18
        Top = 293
        Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1072#1103' '#1085#1072#1094#1077#1085#1082#1072' ('#1084#1072#1088#1082#1077#1090' '#1073#1086#1085#1091#1089#1099')'
      end
      object cxLabel12: TcxLabel
        Left = 18
        Top = 314
        Caption = #1044#1085#1077#1081' '#1076#1086' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080' '#1087#1086' '#1076#1080#1089#1082#1086#1085#1090#1085#1099#1084' '#1087#1088#1086#1077#1082#1090#1072#1084
      end
      object cxLabel16: TcxLabel
        Left = 18
        Top = 337
        Caption = #1055#1086#1088#1086#1075' '#1089#1088#1072#1073#1072#1090#1099#1074#1072#1085#1080#1077' '#1085#1072' '#1094#1077#1085#1091' '#1077#1076#1080#1085#1080#1094#1099' '#1090#1086#1074#1072#1088#1072' '#1087#1088#1080' '#1079#1072#1082#1072#1079#1077' '#1082#1083#1080#1077#1085#1090#1091
      end
      object cxLabel17: TcxLabel
        Left = 18
        Top = 358
        Hint = 
          #1055#1077#1088#1080#1086#1076' '#1076#1085#1077#1081' '#1076#1083#1103' '#1089#1080#1089#1090#1077#1084#1099' '#1082#1086#1088#1088#1077#1082#1094#1080#1080' '#1094#1077#1085#1099' '#1087#1086' '#1080#1090#1086#1075#1072#1084' '#1088#1086#1089#1090#1072'/'#1087#1072#1076#1077#1085#1080#1103' '#1089 +
          #1088#1077#1076#1085#1080#1093' '#1087#1088#1086#1076#1072#1078
        Caption = #1055#1077#1088#1080#1086#1076' '#1076#1085#1077#1081' '#1076#1083#1103' '#1089#1080#1089#1090#1077#1084#1099' '#1082#1086#1088#1088#1077#1082#1094#1080#1080' '#1094#1077#1085#1099
        ParentShowHint = False
        ShowHint = True
      end
      object cxLabel23: TcxLabel
        Left = 18
        Top = 379
        Caption = #1055#1088#1086#1094#1077#1085#1090' '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1089#1090#1088#1072#1093#1086#1074#1099#1084' '#1082#1086#1084#1087#1072#1085#1080#1103#1084' '#1076#1083#1103' '#1079'/'#1087' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1072#1084
      end
      object cxLabel29: TcxLabel
        Left = 18
        Top = 185
        Caption = #1062#1077#1085#1072' '#1086#1090' '#1082#1086#1090#1086#1088#1086#1081' '#1087#1086#1082#1072#1079#1072#1085' '#1090#1086#1074#1072#1088' '#1087#1088#1080' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1080' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' VIP'
      end
      object cxLabel3: TcxLabel
        Left = 18
        Top = 164
        Caption = #1057#1091#1084#1084#1072' '#1086#1090' '#1082#1086#1090#1086#1088#1086#1081' '#1087#1086#1082#1072#1079#1072#1085' '#1090#1086#1074#1072#1088' '#1087#1088#1080' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1080' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' VIP'
      end
      object cxLabel4: TcxLabel
        Left = 18
        Top = 207
        Caption = #1057#1091#1084#1084#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1086#1090' '#1082#1086#1090#1086#1088#1086#1081' '#1088#1072#1079#1088#1077#1096#1077#1085' '#1087#1088#1080#1079#1085#1072#1082' '#1089#1088#1086#1095#1085#1086' '
      end
      object cxLabel6: TcxLabel
        Left = 18
        Top = 229
        Caption = 
          #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1086#1087#1099#1090#1086#1082' '#1076#1086' '#1091#1089#1087#1077#1096#1085#1086#1081' '#1089#1076#1072#1095#1080' '#1090#1077#1089#1090#1072' '#1076#1083#1103' '#1087#1088#1077#1076#1083#1086#1078#1077#1085#1080#1103' '#1087#1086#1076#1084#1077 +
          #1085
      end
      object cxLabel8: TcxLabel
        Left = 18
        Top = 272
        Caption = #9#1053#1080#1078#1085#1080#1081' '#1087#1088#1077#1076#1077#1083' '#1089#1088#1072#1074#1085#1077#1085#1080#1103' ('#1084#1072#1088#1082#1077#1090' '#1073#1086#1085#1091#1089#1099')'
      end
      object cxLabel9: TcxLabel
        Left = 18
        Top = 251
        Caption = #1042#1077#1088#1093#1085#1080#1081' '#1087#1088#1077#1076#1077#1083' '#1089#1088#1072#1074#1085#1077#1085#1080#1103' ('#1084#1072#1088#1082#1077#1090' '#1073#1086#1085#1091#1089#1099')'
      end
      object edAttemptsSub: TcxCurrencyEdit
        Left = 402
        Top = 228
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 27
        Width = 121
      end
      object edLowerLimitPromoBonus: TcxCurrencyEdit
        Left = 402
        Top = 271
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 28
        Width = 121
      end
      object edMinPercentPromoBonus: TcxCurrencyEdit
        Left = 402
        Top = 292
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 29
        Width = 121
      end
      object edPriceFormSendVIP: TcxCurrencyEdit
        Left = 402
        Top = 184
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 30
        Width = 121
      end
      object edSummaFormSendVIP: TcxCurrencyEdit
        Left = 402
        Top = 163
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 31
        Width = 121
      end
      object edSummaUrgentlySendVIP: TcxCurrencyEdit
        Left = 402
        Top = 206
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 32
        Width = 121
      end
      object edUpperLimitPromoBonus: TcxCurrencyEdit
        Left = 402
        Top = 250
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 33
        Width = 121
      end
      object ceAddMarkupTabletki: TcxCurrencyEdit
        Left = 402
        Top = 445
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        Properties.EditFormat = ',0.00'
        TabOrder = 34
        Width = 121
      end
      object ceDeviationsPrice1303: TcxCurrencyEdit
        Left = 759
        Top = 272
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        Properties.EditFormat = ',0.00'
        TabOrder = 35
        Width = 121
      end
      object ceExpressVIPConfirm: TcxCurrencyEdit
        Left = 402
        Top = 400
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = ',0'
        TabOrder = 36
        Width = 121
      end
      object ceFixedPercent: TcxCurrencyEdit
        Left = 402
        Top = 422
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        Properties.EditFormat = ',0.00'
        TabOrder = 37
        Width = 121
      end
      object ceLimitCash: TcxCurrencyEdit
        Left = 759
        Top = 361
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        Properties.EditFormat = ',0.00'
        TabOrder = 38
        Width = 121
      end
      object ceMinPriceSale: TcxCurrencyEdit
        Left = 759
        Top = 250
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        Properties.EditFormat = ',0.00'
        TabOrder = 39
        Width = 121
      end
      object ceMobMessCount: TcxCurrencyEdit
        Left = 759
        Top = 433
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = ',0'
        Properties.EditFormat = ',0'
        TabOrder = 40
        Width = 121
      end
      object ceMobMessSum: TcxCurrencyEdit
        Left = 759
        Top = 411
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        Properties.EditFormat = ',0.00'
        TabOrder = 41
        Width = 121
      end
      object ceNormNewMobileOrders: TcxCurrencyEdit
        Left = 816
        Top = 295
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = ',0'
        Properties.EditFormat = ',0'
        TabOrder = 42
        Width = 64
      end
      object cePriceSamples: TcxCurrencyEdit
        Left = 759
        Top = 163
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 43
        Width = 121
      end
      object ceSamples21: TcxCurrencyEdit
        Left = 759
        Top = 184
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 44
        Width = 121
      end
      object ceSamples22: TcxCurrencyEdit
        Left = 759
        Top = 206
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 45
        Width = 121
      end
      object ceSamples3: TcxCurrencyEdit
        Left = 759
        Top = 228
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 46
        Width = 121
      end
      object cxLabel18: TcxLabel
        Left = 540
        Top = 164
        Caption = #1055#1086#1088#1086#1075' '#1094#1077#1085#1099' '#1057#1101#1084#1087#1083#1086#1074' '#1086#1090
      end
      object cxLabel19: TcxLabel
        Left = 540
        Top = 185
        Caption = #1057#1082#1080#1076#1082#1072' '#1089#1101#1084#1087#1083#1086#1074' '#1082#1072#1090' 2.1 ('#1086#1090' 90-200 '#1076#1085#1077#1081')'
      end
      object cxLabel20: TcxLabel
        Left = 540
        Top = 207
        Caption = #1057#1082#1080#1076#1082#1072' '#1089#1101#1084#1087#1083#1086#1074' '#1082#1072#1090' 2.2 ('#1086#1090' 50-90 '#1076#1085#1077#1081')'
      end
      object cxLabel21: TcxLabel
        Left = 540
        Top = 229
        Caption = #1057#1082#1080#1076#1082#1072' '#1089#1101#1084#1087#1083#1086#1074' '#1082#1072#1090' 3 ('#1086#1090' 0 '#1076#1086' 50 '#1076#1085#1077#1081')'
      end
      object cxLabel28: TcxLabel
        Left = 18
        Top = 401
        Caption = 
          #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1095#1077#1082#1080' '#1089' '#1082#1086#1083'-'#1074#1086#1084' '#1087#1086#1079#1080#1094#1080#1081'  '#1076#1083#1103' '#1101#1082#1089#1087#1088#1077#1089#1089' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1042#1048 +
          #1055' '#1076#1086
      end
      object cxLabel30: TcxLabel
        Left = 540
        Top = 251
        Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1072#1103' '#1094#1077#1085#1072' '#1090#1086#1074#1072#1088#1072' '#1087#1088#1080' '#1086#1090#1087#1091#1089#1082#1077
      end
      object cxLabel31: TcxLabel
        Left = 540
        Top = 273
        Hint = 
          #1055#1088#1086#1094#1077#1085#1090' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1086#1090' '#1086#1090#1087#1091#1089#1082#1085#1086#1081' '#1094#1077#1085#1099' '#1087#1088#1080' '#1086#1090#1087#1091#1089#1082#1077' '#1087#1086' 1303 '#1076#1083#1103' '#1073#1083#1086 +
          #1082#1080#1088#1086#1074#1082#1080
        Caption = '% '#1073#1083#1086#1082#1072' '#1087#1088#1080' '#1086#1090#1087#1091#1089#1082#1085#1086#1081' '#1094#1077#1085#1099' '#1087#1086' 1303'
      end
      object cxLabel32: TcxLabel
        Left = 540
        Top = 320
        Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' '#1076#1083#1103' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1074' '#1047#1055' '#1089#1091#1084#1084#1099' '#1052#1072#1088#1082#1077#1090#1080#1085#1075#1072
      end
      object cxLabel33: TcxLabel
        Left = 540
        Top = 296
        Hint = 
          #1055#1088#1086#1094#1077#1085#1090' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1086#1090' '#1086#1090#1087#1091#1089#1082#1085#1086#1081' '#1094#1077#1085#1099' '#1087#1088#1080' '#1086#1090#1087#1091#1089#1082#1077' '#1087#1086' 1303 '#1076#1083#1103' '#1073#1083#1086 +
          #1082#1080#1088#1086#1074#1082#1080
        Caption = #1053#1086#1088#1084#1072' '#1087#1086' '#1085#1086#1074#1099#1084' '#1079#1072#1082#1072#1079#1072#1084' '#1084#1086#1073#1080#1083#1100#1085#1086#1075#1086' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103
      end
      object cxLabel34: TcxLabel
        Left = 540
        Top = 362
        Hint = 
          #1055#1088#1086#1094#1077#1085#1090' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1086#1090' '#1086#1090#1087#1091#1089#1082#1085#1086#1081' '#1094#1077#1085#1099' '#1087#1088#1080' '#1086#1090#1087#1091#1089#1082#1077' '#1087#1086' 1303 '#1076#1083#1103' '#1073#1083#1086 +
          #1082#1080#1088#1086#1074#1082#1080
        Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1087#1088#1080' '#1087#1086#1082#1091#1087#1082#1080' '#1085#1072#1083#1080#1095#1085#1099#1084#1080
      end
      object cxLabel35: TcxLabel
        Left = 18
        Top = 449
        Hint = #1044#1086#1087' '#1085#1072#1094#1077#1085#1082#1072' '#1085#1072' '#1058#1072#1073#1083#1077#1090#1082#1080' '#1085#1072' '#1087#1086#1079' '#1087#1086' '#1074#1099#1089#1090#1072#1074#1083#1077#1085#1085#1099#1084' '#1085#1072#1094#1077#1085#1082#1072#1084
        Caption = #1044#1086#1087' '#1085#1072#1094#1077#1085#1082#1072' '#1085#1072' '#1058#1072#1073#1083#1077#1090#1082#1080' '#1085#1072' '#1087#1086#1079' '#1087#1086' '#1074#1099#1089#1090#1072#1074#1083#1077#1085#1085#1099#1084' '#1085#1072#1094#1077#1085#1082#1072#1084
      end
      object cxLabel36: TcxLabel
        Left = 18
        Top = 426
        Hint = #9#1060#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1099#1081' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1087#1083#1072#1085#1072
        Caption = #9#1060#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1099#1081' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1087#1083#1072#1085#1072
      end
      object cxLabel37: TcxLabel
        Left = 540
        Top = 388
        Caption = #9#1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1087#1086' '#1089#1086#1079#1076#1072#1085#1080#1102' '#1079#1072#1082#1072#1079#1072' '#1087#1086' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1102
      end
      object cxLabel38: TcxLabel
        Left = 540
        Top = 412
        Hint = 
          #1055#1088#1086#1094#1077#1085#1090' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1086#1090' '#1086#1090#1087#1091#1089#1082#1085#1086#1081' '#1094#1077#1085#1099' '#1087#1088#1080' '#1086#1090#1087#1091#1089#1082#1077' '#1087#1086' 1303 '#1076#1083#1103' '#1073#1083#1086 +
          #1082#1080#1088#1086#1074#1082#1080
        Caption = #1054#1090' '#1089#1091#1084#1084#1099' '#1095#1077#1082#1086#1074
      end
      object cxLabel39: TcxLabel
        Left = 540
        Top = 434
        Hint = 
          #1055#1088#1086#1094#1077#1085#1090' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1086#1090' '#1086#1090#1087#1091#1089#1082#1085#1086#1081' '#1094#1077#1085#1099' '#1087#1088#1080' '#1086#1090#1087#1091#1089#1082#1077' '#1087#1086' 1303 '#1076#1083#1103' '#1073#1083#1086 +
          #1082#1080#1088#1086#1074#1082#1080
        Caption = #1044#1083#1103' '#1082#1072#1078#1076#1086#1075#1086' N '#1095#1077#1082#1072
      end
      object edUserUpdateMarketing: TcxButtonEdit
        Left = 587
        Top = 338
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 62
        Width = 293
      end
      object edSendCashErrorTelId: TcxTextEdit
        Left = 529
        Top = 64
        TabOrder = 63
        Width = 349
      end
      object cxLabel40: TcxLabel
        Left = 529
        Top = 44
        Caption = 'ID '#1074' '#1090#1077#1083#1077#1075#1088#1072#1084' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1086#1096#1080#1073#1086#1082' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      end
    end
    object cxTabSheet2: TcxTabSheet
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1057#1059#1053
      ImageIndex = 1
      object cbEliminateColdSUN: TcxCheckBox
        Left = 535
        Top = 71
        Hint = #1048#1089#1082#1083#1102#1095#1072#1090#1100' '#1061#1086#1083#1086#1076' '#1080#1079' '#1057#1059#1053
        Caption = #1048#1089#1082#1083#1102#1095#1072#1090#1100' '#1061#1086#1083#1086#1076' '#1080#1079' '#1057#1059#1053' 1'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Width = 179
      end
      object cbOnlyColdSUN: TcxCheckBox
        Left = 715
        Top = 71
        Hint = #1058#1086#1083#1100#1082#1086' '#1087#1086' '#1061#1086#1083#1086#1076#1091' '#1057#1059#1053
        Caption = #1058#1086#1083#1100#1082#1086' '#1087#1086' '#1061#1086#1083#1086#1076#1091' '#1057#1059#1053' 1'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Width = 166
      end
      object cbShoresSUN: TcxCheckBox
        Left = 535
        Top = 52
        Hint = #1048#1089#1082#1083#1102#1095#1072#1090#1100' '#1061#1086#1083#1086#1076' '#1080#1079' '#1057#1059#1053
        Caption = #1041#1077#1088#1077#1075#1072' '#1086#1090#1076#1077#1083#1100#1085#1086' '#1087#1086' '#1057#1059#1053
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Width = 179
      end
      object cbOnlyColdSUN2: TcxCheckBox
        Left = 715
        Top = 88
        Hint = #1058#1086#1083#1100#1082#1086' '#1087#1086' '#1061#1086#1083#1086#1076#1091' '#1057#1059#1053
        Caption = #1058#1086#1083#1100#1082#1086' '#1087#1086' '#1061#1086#1083#1086#1076#1091' '#1057#1059#1053' 2'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        Width = 166
      end
      object cbEliminateColdSUN2: TcxCheckBox
        Left = 535
        Top = 88
        Hint = #1048#1089#1082#1083#1102#1095#1072#1090#1100' '#1061#1086#1083#1086#1076' '#1080#1079' '#1057#1059#1053
        Caption = #1048#1089#1082#1083#1102#1095#1072#1090#1100' '#1061#1086#1083#1086#1076' '#1080#1079' '#1057#1059#1053' 2'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Width = 179
      end
      object cbOnlyColdSUN3: TcxCheckBox
        Left = 715
        Top = 107
        Hint = #1058#1086#1083#1100#1082#1086' '#1087#1086' '#1061#1086#1083#1086#1076#1091' '#1057#1059#1053
        Caption = #1058#1086#1083#1100#1082#1086' '#1087#1086' '#1061#1086#1083#1086#1076#1091' '#1057#1059#1053' '#1069
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        Width = 166
      end
      object cbEliminateColdSUN3: TcxCheckBox
        Left = 535
        Top = 107
        Hint = #1048#1089#1082#1083#1102#1095#1072#1090#1100' '#1061#1086#1083#1086#1076' '#1080#1079' '#1057#1059#1053
        Caption = #1048#1089#1082#1083#1102#1095#1072#1090#1100' '#1061#1086#1083#1086#1076' '#1080#1079' '#1057#1059#1053' '#1069
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        Width = 179
      end
      object cbOnlyColdSUN4: TcxCheckBox
        Left = 715
        Top = 126
        Hint = #1058#1086#1083#1100#1082#1086' '#1087#1086' '#1061#1086#1083#1086#1076#1091' '#1057#1059#1053
        Caption = #1058#1086#1083#1100#1082#1086' '#1087#1086' '#1061#1086#1083#1086#1076#1091' '#1057#1059#1053' '#1055#1048
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        Width = 166
      end
      object cbEliminateColdSUN4: TcxCheckBox
        Left = 535
        Top = 126
        Hint = #1048#1089#1082#1083#1102#1095#1072#1090#1100' '#1061#1086#1083#1086#1076' '#1080#1079' '#1057#1059#1053
        Caption = #1048#1089#1082#1083#1102#1095#1072#1090#1100' '#1061#1086#1083#1086#1076' '#1080#1079' '#1057#1059#1053' '#1055#1048
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        Width = 179
      end
      object ceAssortmentGeograph: TcxCurrencyEdit
        Left = 759
        Top = 216
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 9
        Width = 73
      end
      object ceAssortmentSales: TcxCurrencyEdit
        Left = 759
        Top = 238
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 10
        Width = 73
      end
      object ceDeySupplInSUN2: TcxCurrencyEdit
        Left = 404
        Top = 157
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = ',0'
        TabOrder = 11
        Width = 121
      end
      object ceDeySupplOutSUN2: TcxCurrencyEdit
        Left = 404
        Top = 136
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = ',0'
        TabOrder = 12
        Width = 121
      end
      object cePercentUntilNextSUN: TcxCurrencyEdit
        Left = 404
        Top = 94
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        TabOrder = 13
        Width = 121
      end
      object ceTurnoverMoreSUN2: TcxCurrencyEdit
        Left = 404
        Top = 115
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00; ;'
        TabOrder = 14
        Width = 121
      end
      object cxLabel13: TcxLabel
        Left = 540
        Top = 175
        Caption = #1052#1077#1090#1086#1076#1099' '#1074#1099#1073#1086#1088#1072' '#1072#1087#1090#1077#1082' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072
      end
      object cxLabel14: TcxLabel
        Left = 540
        Top = 217
        Caption = #9#1040#1087#1090#1077#1082' '#1072#1085#1072#1083#1080#1090#1080#1082#1086#1074' '#1087#1086' '#1075#1077#1086#1075#1088#1072#1092#1080#1080
      end
      object cxLabel15: TcxLabel
        Left = 640
        Top = 239
        Caption = #1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084
      end
      object cxLabel24: TcxLabel
        Left = 20
        Top = 95
        Caption = #1055#1088#1086#1094#1077#1085#1090' '#1076#1083#1103' '#1087#1086#1076#1089#1074#1077#1090#1082#1080' '#1082#1086#1084#1077#1085#1090#1072' "'#1055#1088#1086#1076#1072#1085#1086'/'#1055#1088#1086#1076#1072#1078#1072' '#1076#1086' '#1089#1083#1077#1076' '#1057#1059#1053'"'
      end
      object cxLabel25: TcxLabel
        Left = 20
        Top = 116
        Caption = #1054#1073#1086#1088#1086#1090' '#1073#1086#1083#1100#1096#1077' '#1079#1072' '#1087#1088#1086#1096#1083#1099#1081' '#1084#1077#1089#1103#1094' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103' '#1057#1059#1053' 2'
      end
      object cxLabel26: TcxLabel
        Left = 20
        Top = 158
        Caption = #1055#1088#1086#1076#1072#1078#1080' '#1076#1085#1077#1081' '#1076#1083#1103' '#1072#1087#1090#1077#1082' '#1082#1091#1076#1072' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1103' '#1057#1059#1053' 2'
      end
      object cxLabel27: TcxLabel
        Left = 20
        Top = 137
        Caption = #1055#1088#1086#1076#1072#1078#1080' '#1076#1085#1077#1081' '#1076#1083#1103' '#1072#1087#1090#1077#1082' '#1086#1090#1082#1091#1076#1072' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1103' '#1057#1059#1053' 2'
      end
      object cxLabel5: TcxLabel
        Left = 20
        Top = 52
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1082#1086#1085#1090#1088#1086#1083#1103' <'#1055#1088#1086#1076#1072#1085#1086'/'#1055#1088#1086#1076#1072#1078#1072' '#1076#1086' '#1089#1083#1077#1076' '#1057#1059#1053'>'
      end
      object cxLabel7: TcxLabel
        Left = 20
        Top = 73
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1082#1086#1085#1090#1088#1086#1083#1103' '#1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1103' "'#1053#1077#1090#1086#1074#1072#1088#1085#1099#1081' '#1074#1080#1076'"'
      end
      object edDayNonCommoditySUN: TcxCurrencyEdit
        Left = 404
        Top = 72
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 24
        Width = 121
      end
      object edDaySaleForSUN: TcxCurrencyEdit
        Left = 404
        Top = 51
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 25
        Width = 121
      end
      object edMethodsAssortment: TcxButtonEdit
        Left = 587
        Top = 194
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 26
        Width = 293
      end
      object cxLabel11: TcxLabel
        Left = 25
        Top = 19
        Caption = ' '#1044#1072#1090#1072' '#1079#1072#1087#1088#1077#1090#1072' '#1088#1072#1073#1086#1090#1099' '#1087#1086' '#1057#1059#1053' '
      end
      object edDateBanSUN: TcxDateEdit
        Left = 200
        Top = 18
        EditValue = 42993d
        Properties.ReadOnly = False
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 28
        Width = 90
      end
      object cbOnlyColdSUA: TcxCheckBox
        Left = 715
        Top = 145
        Hint = #1058#1086#1083#1100#1082#1086' '#1087#1086' '#1061#1086#1083#1086#1076#1091' '#1057#1059#1053
        Caption = #1058#1086#1083#1100#1082#1086' '#1087#1086' '#1061#1086#1083#1086#1076#1091' '#1057#1059#1040
        ParentShowHint = False
        ShowHint = True
        TabOrder = 29
        Width = 166
      end
      object cbEliminateColdSUA: TcxCheckBox
        Left = 535
        Top = 145
        Hint = #1048#1089#1082#1083#1102#1095#1072#1090#1100' '#1061#1086#1083#1086#1076' '#1080#1079' '#1057#1059#1053
        Caption = #1048#1089#1082#1083#1102#1095#1072#1090#1100' '#1061#1086#1083#1086#1076' '#1080#1079' '#1057#1059#1040
        ParentShowHint = False
        ShowHint = True
        TabOrder = 30
        Width = 179
      end
      object cbCancelBansSUN: TcxCheckBox
        Left = 715
        Top = 52
        Hint = #1054#1090#1084#1077#1085#1072' '#1079#1072#1087#1088#1077#1090#1086#1074' '#1087#1086' '#1074#1089#1077#1084' '#1057#1059#1053
        Caption = #1054#1090#1084#1077#1085#1072' '#1079#1072#1087#1088#1077#1090#1086#1074' '#1087#1086' '#1074#1089#1077#1084' '#1057#1059#1053
        ParentShowHint = False
        ShowHint = True
        TabOrder = 31
        Width = 179
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 537
    Width = 898
    Height = 41
    Align = alBottom
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 5
    object cxButton1: TcxButton
      Left = 224
      Top = 6
      Width = 75
      Height = 25
      Action = dsdInsertUpdateGuides
      Default = True
      ModalResult = 8
      TabOrder = 0
    end
    object cxButton2: TcxButton
      Left = 598
      Top = 6
      Width = 75
      Height = 25
      Action = dsdFormClose
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 8
      TabOrder = 1
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 408
    Top = 38
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
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
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
    object actCashSettingsHistory: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1089#1090#1086#1088#1080#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1054#1073#1097#1080#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1082#1072#1089#1089
      Hint = #1048#1089#1090#1086#1088#1080#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1054#1073#1097#1080#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1082#1072#1089#1089
      ImageIndex = 28
      FormName = 'TCashSettingsHistoryForm'
      FormNameParam.Value = 'TCashSettingsHistoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'CashSettingsId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = #1054#1073#1097#1080#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1082#1072#1089#1089
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_CashSettings'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inShareFromPriceName'
        Value = ''
        Component = edShareFromPriceName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShareFromPriceCode'
        Value = 0.000000000000000000
        Component = edShareFromPriceCode
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGetHardwareData'
        Value = Null
        Component = cbGetHardwareData
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateBanSUN'
        Value = Null
        Component = edDateBanSUN
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummaFormSendVIP'
        Value = Null
        Component = edSummaFormSendVIP
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummaUrgentlySendVIP'
        Value = Null
        Component = edSummaUrgentlySendVIP
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDaySaleForSUN'
        Value = Null
        Component = edDaySaleForSUN
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDayNonCommoditySUN'
        Value = Null
        Component = edDayNonCommoditySUN
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisBlockVIP'
        Value = Null
        Component = cbBlockVIP
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPairedOnlyPromo'
        Value = Null
        Component = cbPairedOnlyPromo
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAttemptsSub'
        Value = Null
        Component = edAttemptsSub
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUpperLimitPromoBonus'
        Value = Null
        Component = edUpperLimitPromoBonus
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLowerLimitPromoBonus'
        Value = Null
        Component = edLowerLimitPromoBonus
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinPercentPromoBonus'
        Value = Null
        Component = edMinPercentPromoBonus
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDayCompensDiscount'
        Value = Null
        Component = ceDayCompensDiscount
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMethodsAssortmentGuidesId'
        Value = Null
        Component = MethodsAssortmentGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAssortmentGeograph'
        Value = Null
        Component = ceAssortmentGeograph
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAssortmentSales'
        Value = Null
        Component = ceAssortmentSales
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCustomerThreshold'
        Value = Null
        Component = ceCustomerThreshold
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceCorrectionDay'
        Value = Null
        Component = cePriceCorrectionDay
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisRequireUkrName'
        Value = Null
        Component = cbRequireUkrName
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisRemovingPrograms'
        Value = Null
        Component = cbRemovingPrograms
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceSamples'
        Value = Null
        Component = cePriceSamples
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSamples21'
        Value = Null
        Component = ceSamples21
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSamples22'
        Value = Null
        Component = ceSamples22
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSamples3'
        Value = Null
        Component = ceSamples3
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTelegramBotToken'
        Value = Null
        Component = edTelegramBotToken
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercentIC'
        Value = Null
        Component = cePercentIC
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercentUntilNextSUN'
        Value = Null
        Component = cePercentUntilNextSUN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisEliminateColdSUN'
        Value = Null
        Component = cbEliminateColdSUN
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTurnoverMoreSUN2'
        Value = Null
        Component = ceTurnoverMoreSUN2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDeySupplOutSUN2'
        Value = Null
        Component = ceDeySupplOutSUN2
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDeySupplInSUN2'
        Value = Null
        Component = ceDeySupplInSUN2
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inExpressVIPConfirm'
        Value = Null
        Component = ceExpressVIPConfirm
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceFormSendVIP'
        Value = Null
        Component = edPriceFormSendVIP
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinPriceSale'
        Value = Null
        Component = ceMinPriceSale
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDeviationsPrice1303'
        Value = Null
        Component = ceDeviationsPrice1303
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisWagesCheckTesting'
        Value = Null
        Component = cdWagesCheckTesting
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNormNewMobileOrders'
        Value = Null
        Component = ceNormNewMobileOrders
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserUpdateMarketingId'
        Value = Null
        Component = UserUpdateMarketingGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLimitCash'
        Value = Null
        Component = ceLimitCash
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAddMarkupTabletki'
        Value = Null
        Component = ceAddMarkupTabletki
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShoresSUN'
        Value = Null
        Component = cbShoresSUN
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFixedPercent'
        Value = Null
        Component = ceFixedPercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMobMessSum'
        Value = Null
        Component = ceMobMessSum
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMobMessCount'
        Value = Null
        Component = ceMobMessCount
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisEliminateColdSUN2'
        Value = Null
        Component = cbEliminateColdSUN2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisEliminateColdSUN3'
        Value = Null
        Component = cbEliminateColdSUN3
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisEliminateColdSUN4'
        Value = Null
        Component = cbEliminateColdSUN4
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisEliminateColdSUA'
        Value = Null
        Component = cbEliminateColdSUA
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOnlyColdSUN'
        Value = Null
        Component = cbOnlyColdSUN
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOnlyColdSUN2'
        Value = Null
        Component = cbOnlyColdSUN2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOnlyColdSUN3'
        Value = Null
        Component = cbOnlyColdSUN3
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOnlyColdSUN4'
        Value = Null
        Component = cbOnlyColdSUN4
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOnlyColdSUA'
        Value = Null
        Component = cbOnlyColdSUA
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSendCashErrorTelId'
        Value = Null
        Component = edSendCashErrorTelId
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCancelBansSUN'
        Value = Null
        Component = cbCancelBansSUN
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 696
    Top = 34
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_CashSettings'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShareFromPriceName'
        Value = ''
        Component = edShareFromPriceName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShareFromPriceCode'
        Value = 0.000000000000000000
        Component = edShareFromPriceCode
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGetHardwareData'
        Value = Null
        Component = cbGetHardwareData
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateBanSUN'
        Value = Null
        Component = edDateBanSUN
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaFormSendVIP'
        Value = Null
        Component = edSummaFormSendVIP
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaUrgentlySendVIP'
        Value = Null
        Component = edSummaUrgentlySendVIP
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DaySaleForSUN'
        Value = Null
        Component = edDaySaleForSUN
        MultiSelectSeparator = ','
      end
      item
        Name = 'DayNonCommoditySUN'
        Value = Null
        Component = edDayNonCommoditySUN
        MultiSelectSeparator = ','
      end
      item
        Name = 'isBlockVIP'
        Value = Null
        Component = cbBlockVIP
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPairedOnlyPromo'
        Value = Null
        Component = cbPairedOnlyPromo
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AttemptsSub'
        Value = Null
        Component = edAttemptsSub
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpperLimitPromoBonus'
        Value = Null
        Component = edUpperLimitPromoBonus
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LowerLimitPromoBonus'
        Value = Null
        Component = edLowerLimitPromoBonus
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MinPercentPromoBonus'
        Value = Null
        Component = edMinPercentPromoBonus
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DayCompensDiscount'
        Value = Null
        Component = ceDayCompensDiscount
        MultiSelectSeparator = ','
      end
      item
        Name = 'MethodsAssortmentId'
        Value = Null
        Component = MethodsAssortmentGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MethodsAssortmentName'
        Value = Null
        Component = MethodsAssortmentGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AssortmentGeograph'
        Value = Null
        Component = ceAssortmentGeograph
        MultiSelectSeparator = ','
      end
      item
        Name = 'AssortmentSales'
        Value = Null
        Component = ceAssortmentSales
        MultiSelectSeparator = ','
      end
      item
        Name = 'CustomerThreshold'
        Value = Null
        Component = ceCustomerThreshold
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceCorrectionDay'
        Value = Null
        Component = cePriceCorrectionDay
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRequireUkrName'
        Value = Null
        Component = cbRequireUkrName
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRemovingPrograms'
        Value = Null
        Component = cbRemovingPrograms
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceSamples'
        Value = Null
        Component = cePriceSamples
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Samples21'
        Value = Null
        Component = ceSamples21
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Samples22'
        Value = Null
        Component = ceSamples22
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Samples3'
        Value = Null
        Component = ceSamples3
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TelegramBotToken'
        Value = Null
        Component = edTelegramBotToken
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentIC'
        Value = Null
        Component = cePercentIC
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentUntilNextSUN'
        Value = Null
        Component = cePercentUntilNextSUN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEliminateColdSUN'
        Value = Null
        Component = cbEliminateColdSUN
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'TurnoverMoreSUN2'
        Value = Null
        Component = ceTurnoverMoreSUN2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DeySupplOutSUN2'
        Value = Null
        Component = ceDeySupplOutSUN2
        MultiSelectSeparator = ','
      end
      item
        Name = 'DeySupplInSUN2'
        Value = Null
        Component = ceDeySupplInSUN2
        MultiSelectSeparator = ','
      end
      item
        Name = 'ExpressVIPConfirm'
        Value = Null
        Component = ceExpressVIPConfirm
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceFormSendVIP'
        Value = Null
        Component = edPriceFormSendVIP
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MinPriceSale'
        Value = Null
        Component = ceMinPriceSale
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DeviationsPrice1303'
        Value = Null
        Component = ceDeviationsPrice1303
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWagesCheckTesting'
        Value = Null
        Component = cdWagesCheckTesting
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'NormNewMobileOrders'
        Value = Null
        Component = ceNormNewMobileOrders
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserUpdateMarketingId'
        Value = Null
        Component = UserUpdateMarketingGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserUpdateMarketingName'
        Value = Null
        Component = UserUpdateMarketingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LimitCash'
        Value = Null
        Component = ceLimitCash
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AddMarkupTabletki'
        Value = Null
        Component = ceAddMarkupTabletki
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isShoresSUN'
        Value = Null
        Component = cbShoresSUN
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'FixedPercent'
        Value = Null
        Component = ceFixedPercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MobMessSum'
        Value = Null
        Component = ceMobMessSum
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MobMessCount'
        Value = Null
        Component = ceMobMessCount
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEliminateColdSUN2'
        Value = Null
        Component = cbEliminateColdSUN2
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEliminateColdSUN3'
        Value = Null
        Component = cbEliminateColdSUN3
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEliminateColdSUN4'
        Value = Null
        Component = cbEliminateColdSUN4
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'iscliminateColdSUA'
        Value = Null
        Component = cbEliminateColdSUA
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOnlyColdSUN'
        Value = Null
        Component = cbOnlyColdSUN
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOnlyColdSUN2'
        Value = Null
        Component = cbOnlyColdSUN2
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOnlyColdSUN3'
        Value = Null
        Component = cbOnlyColdSUN3
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOnlyColdSUN4'
        Value = Null
        Component = cbOnlyColdSUN4
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOnlyColdSUA'
        Value = Null
        Component = cbOnlyColdSUA
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'SendCashErrorTelId'
        Value = Null
        Component = edSendCashErrorTelId
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCancelBansSUN'
        Value = Null
        Component = cbCancelBansSUN
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 616
    Top = 26
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 792
    Top = 33
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
    Left = 512
    Top = 34
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 306
  end
  object MethodsAssortmentGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMethodsAssortment
    FormNameParam.Value = 'TMethodsAssortmentForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMethodsAssortmentForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MethodsAssortmentGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MethodsAssortmentGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 757
    Top = 240
  end
  object UserUpdateMarketingGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUserUpdateMarketing
    FormNameParam.Value = 'TUserNickForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserNickForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UserUpdateMarketingGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UserUpdateMarketingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 781
    Top = 384
  end
  object BarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 344
    Top = 34
    DockControlHeights = (
      0
      0
      30
      0)
    object Bar: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'bbChoice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object bbGridToExcel: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbChoice: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton1: TdxBarButton
      Action = actCashSettingsHistory
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actProtocolOpenForm
      Category = 0
    end
  end
end
