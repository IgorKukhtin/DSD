object CashSettingsEditForm: TCashSettingsEditForm
  Left = 0
  Top = 0
  Caption = #1054#1073#1097#1080#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1082#1072#1089#1089
  ClientHeight = 569
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
  object edShareFromPriceName: TcxTextEdit
    Left = 16
    Top = 39
    TabOrder = 0
    Width = 509
  end
  object cxLabel1: TcxLabel
    Left = 16
    Top = 19
    Caption = 
      #1055#1077#1088#1077#1095#1077#1085#1100' '#1092#1088#1072#1079' '#1074' '#1085#1072#1079#1074#1072#1085#1080#1103#1093' '#1090#1086#1074#1072#1088#1086#1074' '#1082#1086#1090#1086#1088#1099#1077' '#1084#1086#1078#1085#1086' '#1076#1077#1083#1080#1090#1100' '#1089' '#1083#1102#1073#1086#1081' '#1094 +
      #1077#1085#1086#1081
  end
  object cxButton1: TcxButton
    Left = 230
    Top = 532
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 604
    Top = 536
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object edShareFromPriceCode: TcxTextEdit
    Left = 16
    Top = 87
    TabOrder = 4
    Width = 509
  end
  object cxLabel2: TcxLabel
    Left = 16
    Top = 67
    Caption = #1055#1077#1088#1077#1095#1077#1085#1100' '#1082#1086#1076#1086#1074' '#1090#1086#1074#1072#1088#1086#1074' '#1082#1086#1090#1086#1088#1099#1077' '#1084#1086#1078#1085#1086' '#1076#1077#1083#1080#1090#1100' '#1089' '#1083#1102#1073#1086#1081' '#1094#1077#1085#1086#1081
  end
  object cbGetHardwareData: TcxCheckBox
    Left = 16
    Top = 118
    Hint = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
    Caption = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    Width = 215
  end
  object edDateBanSUN: TcxDateEdit
    Left = 191
    Top = 168
    EditValue = 42993d
    Properties.ReadOnly = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 7
    Width = 90
  end
  object cxLabel11: TcxLabel
    Left = 16
    Top = 169
    Caption = ' '#1044#1072#1090#1072' '#1079#1072#1087#1088#1077#1090#1072' '#1088#1072#1073#1086#1090#1099' '#1087#1086' '#1057#1059#1053' '
  end
  object edSummaFormSendVIP: TcxCurrencyEdit
    Left = 404
    Top = 193
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 9
    Width = 121
  end
  object cxLabel3: TcxLabel
    Left = 20
    Top = 194
    Caption = #1057#1091#1084#1084#1072' '#1086#1090' '#1082#1086#1090#1086#1088#1086#1081' '#1087#1086#1082#1072#1079#1072#1085' '#1090#1086#1074#1072#1088' '#1087#1088#1080' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1080' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' VIP'
  end
  object edSummaUrgentlySendVIP: TcxCurrencyEdit
    Left = 404
    Top = 213
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 11
    Width = 121
  end
  object cxLabel4: TcxLabel
    Left = 20
    Top = 214
    Caption = #1057#1091#1084#1084#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1086#1090' '#1082#1086#1090#1086#1088#1086#1081' '#1088#1072#1079#1088#1077#1096#1077#1085' '#1087#1088#1080#1079#1085#1072#1082' '#1089#1088#1086#1095#1085#1086' '
  end
  object cbBlockVIP: TcxCheckBox
    Left = 256
    Top = 137
    Hint = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
    Caption = #1041#1083#1086#1082#1080#1088#1086#1074#1072#1090#1100' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' VIP'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 13
    Width = 269
  end
  object cbPairedOnlyPromo: TcxCheckBox
    Left = 531
    Top = 118
    Hint = #1055#1088#1080' '#1086#1087#1091#1089#1082#1072#1085#1080#1080' '#1087#1072#1088#1085#1099#1093' '#1082#1086#1085#1090#1088#1086#1083#1080#1088#1086#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1072#1082#1094#1080#1086#1085#1085#1099#1081
    Caption = #1055#1088#1080' '#1086#1087#1091#1089#1082#1072#1085#1080#1080' '#1087#1072#1088#1085#1099#1093' '#1082#1086#1085#1090#1088#1086#1083#1080#1088#1086#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1072#1082#1094#1080#1086#1085#1085#1099#1081
    ParentShowHint = False
    ShowHint = True
    TabOrder = 14
    Width = 338
  end
  object edDaySaleForSUN: TcxCurrencyEdit
    Left = 404
    Top = 234
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 15
    Width = 121
  end
  object cxLabel5: TcxLabel
    Left = 20
    Top = 235
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1082#1086#1085#1090#1088#1086#1083#1103' <'#1055#1088#1086#1076#1072#1085#1086'/'#1055#1088#1086#1076#1072#1078#1072' '#1076#1086' '#1089#1083#1077#1076' '#1057#1059#1053'>'
  end
  object edAttemptsSub: TcxCurrencyEdit
    Left = 404
    Top = 276
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 17
    Width = 121
  end
  object cxLabel6: TcxLabel
    Left = 20
    Top = 277
    Caption = 
      #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1086#1087#1099#1090#1086#1082' '#1076#1086' '#1091#1089#1087#1077#1096#1085#1086#1081' '#1089#1076#1072#1095#1080' '#1090#1077#1089#1090#1072' '#1076#1083#1103' '#1087#1088#1077#1076#1083#1086#1078#1077#1085#1080#1103' '#1087#1086#1076#1084#1077 +
      #1085
  end
  object edDayNonCommoditySUN: TcxCurrencyEdit
    Left = 404
    Top = 255
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 19
    Width = 121
  end
  object cxLabel7: TcxLabel
    Left = 20
    Top = 256
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1082#1086#1085#1090#1088#1086#1083#1103' '#1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1103' "'#1053#1077#1090#1086#1074#1072#1088#1085#1099#1081' '#1074#1080#1076'"'
  end
  object edLowerLimitPromoBonus: TcxCurrencyEdit
    Left = 404
    Top = 319
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 21
    Width = 121
  end
  object edUpperLimitPromoBonus: TcxCurrencyEdit
    Left = 404
    Top = 298
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 22
    Width = 121
  end
  object cxLabel8: TcxLabel
    Left = 20
    Top = 320
    Caption = #9#1053#1080#1078#1085#1080#1081' '#1087#1088#1077#1076#1077#1083' '#1089#1088#1072#1074#1085#1077#1085#1080#1103' ('#1084#1072#1088#1082#1077#1090' '#1073#1086#1085#1091#1089#1099')'
  end
  object cxLabel9: TcxLabel
    Left = 20
    Top = 299
    Caption = #1042#1077#1088#1093#1085#1080#1081' '#1087#1088#1077#1076#1077#1083' '#1089#1088#1072#1074#1085#1077#1085#1080#1103' ('#1084#1072#1088#1082#1077#1090' '#1073#1086#1085#1091#1089#1099')'
  end
  object edMinPercentPromoBonus: TcxCurrencyEdit
    Left = 404
    Top = 340
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 25
    Width = 121
  end
  object cxLabel10: TcxLabel
    Left = 20
    Top = 341
    Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1072#1103' '#1085#1072#1094#1077#1085#1082#1072' ('#1084#1072#1088#1082#1077#1090' '#1073#1086#1085#1091#1089#1099')'
  end
  object ceDayCompensDiscount: TcxCurrencyEdit
    Left = 404
    Top = 361
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 27
    Width = 121
  end
  object cxLabel12: TcxLabel
    Left = 20
    Top = 362
    Caption = #1044#1085#1077#1081' '#1076#1086' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080' '#1087#1086' '#1076#1080#1089#1082#1086#1085#1090#1085#1099#1084' '#1087#1088#1086#1077#1082#1090#1072#1084
  end
  object edMethodsAssortment: TcxButtonEdit
    Left = 232
    Top = 482
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 29
    Width = 293
  end
  object cxLabel13: TcxLabel
    Left = 20
    Top = 482
    Caption = #1052#1077#1090#1086#1076#1099' '#1074#1099#1073#1086#1088#1072' '#1072#1087#1090#1077#1082' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072
  end
  object ceAssortmentGeograph: TcxCurrencyEdit
    Left = 232
    Top = 505
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 31
    Width = 73
  end
  object cxLabel14: TcxLabel
    Left = 20
    Top = 506
    Caption = #9#1040#1087#1090#1077#1082' '#1072#1085#1072#1083#1080#1090#1080#1082#1086#1074' '#1087#1086' '#1075#1077#1086#1075#1088#1072#1092#1080#1080
  end
  object ceAssortmentSales: TcxCurrencyEdit
    Left = 452
    Top = 505
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 33
    Width = 73
  end
  object cxLabel15: TcxLabel
    Left = 367
    Top = 506
    Caption = #1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084
  end
  object ceCustomerThreshold: TcxCurrencyEdit
    Left = 404
    Top = 383
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 35
    Width = 121
  end
  object cxLabel16: TcxLabel
    Left = 20
    Top = 385
    Caption = #1055#1086#1088#1086#1075' '#1089#1088#1072#1073#1072#1090#1099#1074#1072#1085#1080#1077' '#1085#1072' '#1094#1077#1085#1091' '#1077#1076#1080#1085#1080#1094#1099' '#1090#1086#1074#1072#1088#1072' '#1087#1088#1080' '#1079#1072#1082#1072#1079#1077' '#1082#1083#1080#1077#1085#1090#1091
  end
  object cePriceCorrectionDay: TcxCurrencyEdit
    Left = 404
    Top = 404
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 37
    Width = 121
  end
  object cxLabel17: TcxLabel
    Left = 20
    Top = 406
    Hint = 
      #1055#1077#1088#1080#1086#1076' '#1076#1085#1077#1081' '#1076#1083#1103' '#1089#1080#1089#1090#1077#1084#1099' '#1082#1086#1088#1088#1077#1082#1094#1080#1080' '#1094#1077#1085#1099' '#1087#1086' '#1080#1090#1086#1075#1072#1084' '#1088#1086#1089#1090#1072'/'#1087#1072#1076#1077#1085#1080#1103' '#1089 +
      #1088#1077#1076#1085#1080#1093' '#1087#1088#1086#1076#1072#1078
    Caption = #1055#1077#1088#1080#1086#1076' '#1076#1085#1077#1081' '#1076#1083#1103' '#1089#1080#1089#1090#1077#1084#1099' '#1082#1086#1088#1088#1077#1082#1094#1080#1080' '#1094#1077#1085#1099
    ParentShowHint = False
    ShowHint = True
  end
  object cbRequireUkrName: TcxCheckBox
    Left = 256
    Top = 118
    Hint = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
    Caption = #1058#1088#1077#1073#1086#1074#1072#1090#1100' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1059#1082#1088#1072#1080#1085#1089#1082#1086#1075#1086' '#1085#1072#1079#1074#1072#1085#1080#1103
    ParentShowHint = False
    ShowHint = True
    TabOrder = 39
    Width = 269
  end
  object cbRemovingPrograms: TcxCheckBox
    Left = 16
    Top = 137
    Hint = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
    Caption = #1059#1076#1072#1083#1077#1085#1080#1077' '#1089#1090#1086#1088#1086#1085#1085#1080#1093' '#1087#1088#1086#1075#1088#1072#1084#1084
    ParentShowHint = False
    ShowHint = True
    TabOrder = 40
    Width = 215
  end
  object cePriceSamples: TcxCurrencyEdit
    Left = 759
    Top = 193
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 41
    Width = 121
  end
  object cxLabel18: TcxLabel
    Left = 540
    Top = 194
    Caption = #1055#1086#1088#1086#1075' '#1094#1077#1085#1099' '#1057#1101#1084#1087#1083#1086#1074' '#1086#1090
  end
  object ceSamples21: TcxCurrencyEdit
    Left = 759
    Top = 213
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 43
    Width = 121
  end
  object cxLabel19: TcxLabel
    Left = 540
    Top = 214
    Caption = #1057#1082#1080#1076#1082#1072' '#1089#1101#1084#1087#1083#1086#1074' '#1082#1072#1090' 2.1 ('#1086#1090' 90-200 '#1076#1085#1077#1081')'
  end
  object cxLabel20: TcxLabel
    Left = 540
    Top = 235
    Caption = #1057#1082#1080#1076#1082#1072' '#1089#1101#1084#1087#1083#1086#1074' '#1082#1072#1090' 2.2 ('#1086#1090' 50-90 '#1076#1085#1077#1081')'
  end
  object ceSamples22: TcxCurrencyEdit
    Left = 759
    Top = 234
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 46
    Width = 121
  end
  object cxLabel21: TcxLabel
    Left = 540
    Top = 256
    Caption = #1057#1082#1080#1076#1082#1072' '#1089#1101#1084#1087#1083#1086#1074' '#1082#1072#1090' 3 ('#1086#1090' 0 '#1076#1086' 50 '#1076#1085#1077#1081')'
  end
  object ceSamples3: TcxCurrencyEdit
    Left = 759
    Top = 255
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 48
    Width = 121
  end
  object edTelegramBotToken: TcxTextEdit
    Left = 531
    Top = 87
    TabOrder = 49
    Width = 349
  end
  object cxLabel22: TcxLabel
    Left = 531
    Top = 67
    Caption = #1058#1086#1082#1077#1085' '#1090#1077#1083#1077#1075#1088#1072#1084' '#1073#1086#1090#1072
  end
  object cxLabel23: TcxLabel
    Left = 20
    Top = 427
    Caption = #1055#1088#1086#1094#1077#1085#1090' '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1089#1090#1088#1072#1093#1086#1074#1099#1084' '#1082#1086#1084#1087#1072#1085#1080#1103#1084' '#1076#1083#1103' '#1079'/'#1087' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1072#1084
  end
  object cePercentIC: TcxCurrencyEdit
    Left = 404
    Top = 426
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 52
    Width = 121
  end
  object cePercentUntilNextSUN: TcxCurrencyEdit
    Left = 404
    Top = 447
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 53
    Width = 121
  end
  object cxLabel24: TcxLabel
    Left = 20
    Top = 448
    Caption = #1055#1088#1086#1094#1077#1085#1090' '#1076#1083#1103' '#1087#1086#1076#1089#1074#1077#1090#1082#1080' '#1082#1086#1084#1077#1085#1090#1072' "'#1055#1088#1086#1076#1072#1085#1086'/'#1055#1088#1086#1076#1072#1078#1072' '#1076#1086' '#1089#1083#1077#1076' '#1057#1059#1053'"'
  end
  object ActionList: TActionList
    Left = 344
    Top = 76
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
      end>
    PackSize = 1
    Left = 456
    Top = 80
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_CashSettings'
    DataSets = <>
    OutputType = otResult
    Params = <
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
      end>
    PackSize = 1
    Left = 456
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 328
    Top = 15
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
    Left = 384
    Top = 16
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 456
    Top = 152
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
    Left = 373
    Top = 460
  end
end
