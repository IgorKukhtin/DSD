object CashSettingsEditForm: TCashSettingsEditForm
  Left = 0
  Top = 0
  Caption = #1054#1073#1097#1080#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1082#1072#1089#1089
  ClientHeight = 429
  ClientWidth = 533
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
    Left = 156
    Top = 388
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 306
    Top = 388
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
    Width = 233
  end
  object edDateBanSUN: TcxDateEdit
    Left = 191
    Top = 154
    EditValue = 42993d
    Properties.ReadOnly = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 7
    Width = 90
  end
  object cxLabel11: TcxLabel
    Left = 16
    Top = 155
    Caption = ' '#1044#1072#1090#1072' '#1079#1072#1087#1088#1077#1090#1072' '#1088#1072#1073#1086#1090#1099' '#1087#1086' '#1057#1059#1053' '
  end
  object edSummaFormSendVIP: TcxCurrencyEdit
    Left = 404
    Top = 185
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 9
    Width = 121
  end
  object cxLabel3: TcxLabel
    Left = 20
    Top = 186
    Caption = #1057#1091#1084#1084#1072' '#1086#1090' '#1082#1086#1090#1086#1088#1086#1081' '#1087#1086#1082#1072#1079#1072#1085' '#1090#1086#1074#1072#1088' '#1087#1088#1080' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1080' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' VIP'
  end
  object edSummaUrgentlySendVIP: TcxCurrencyEdit
    Left = 404
    Top = 205
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 11
    Width = 121
  end
  object cxLabel4: TcxLabel
    Left = 20
    Top = 207
    Caption = #1057#1091#1084#1084#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1086#1090' '#1082#1086#1090#1086#1088#1086#1081' '#1088#1072#1079#1088#1077#1096#1077#1085' '#1087#1088#1080#1079#1085#1072#1082' '#1089#1088#1086#1095#1085#1086' '
  end
  object cbBlockVIP: TcxCheckBox
    Left = 16
    Top = 333
    Hint = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
    Caption = #1041#1083#1086#1082#1080#1088#1086#1074#1072#1090#1100' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' VIP'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 13
    Width = 365
  end
  object cbPairedOnlyPromo: TcxCheckBox
    Left = 16
    Top = 356
    Hint = #1055#1088#1080' '#1086#1087#1091#1089#1082#1072#1085#1080#1080' '#1087#1072#1088#1085#1099#1093' '#1082#1086#1085#1090#1088#1086#1083#1080#1088#1086#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1072#1082#1094#1080#1086#1085#1085#1099#1081
    Caption = #1055#1088#1080' '#1086#1087#1091#1089#1082#1072#1085#1080#1080' '#1087#1072#1088#1085#1099#1093' '#1082#1086#1085#1090#1088#1086#1083#1080#1088#1086#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1072#1082#1094#1080#1086#1085#1085#1099#1081
    ParentShowHint = False
    ShowHint = True
    TabOrder = 14
    Width = 365
  end
  object edDaySaleForSUN: TcxCurrencyEdit
    Left = 404
    Top = 226
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 15
    Width = 121
  end
  object cxLabel5: TcxLabel
    Left = 20
    Top = 228
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1082#1086#1085#1090#1088#1086#1083#1103' <'#1055#1088#1086#1076#1072#1085#1086'/'#1055#1088#1086#1076#1072#1078#1072' '#1076#1086' '#1089#1083#1077#1076' '#1057#1059#1053'>'
  end
  object edAttemptsSub: TcxCurrencyEdit
    Left = 404
    Top = 269
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 17
    Width = 121
  end
  object cxLabel6: TcxLabel
    Left = 20
    Top = 271
    Caption = 
      #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1086#1087#1099#1090#1086#1082' '#1076#1086' '#1091#1089#1087#1077#1096#1085#1086#1081' '#1089#1076#1072#1095#1080' '#1090#1077#1089#1090#1072' '#1076#1083#1103' '#1087#1088#1077#1076#1083#1086#1078#1077#1085#1080#1103' '#1087#1086#1076#1084#1077 +
      #1085
  end
  object edDayNonCommoditySUN: TcxCurrencyEdit
    Left = 404
    Top = 248
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 19
    Width = 121
  end
  object cxLabel7: TcxLabel
    Left = 20
    Top = 250
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1082#1086#1085#1090#1088#1086#1083#1103' '#1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1103' "'#1053#1077#1090#1086#1074#1072#1088#1085#1099#1081' '#1074#1080#1076'"'
  end
  object edLowerLimitPromoBonus: TcxCurrencyEdit
    Left = 404
    Top = 312
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 21
    Width = 121
  end
  object edUpperLimitPromoBonus: TcxCurrencyEdit
    Left = 404
    Top = 291
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 22
    Width = 121
  end
  object cxLabel8: TcxLabel
    Left = 20
    Top = 314
    Caption = #9#1053#1080#1078#1085#1080#1081' '#1087#1088#1077#1076#1077#1083' '#1089#1088#1072#1074#1085#1077#1085#1080#1103' ('#1084#1072#1088#1082#1077#1090' '#1073#1086#1085#1091#1089#1099')'
  end
  object cxLabel9: TcxLabel
    Left = 20
    Top = 293
    Caption = #1042#1077#1088#1093#1085#1080#1081' '#1087#1088#1077#1076#1077#1083' '#1089#1088#1072#1074#1085#1077#1085#1080#1103' ('#1084#1072#1088#1082#1077#1090' '#1073#1086#1085#1091#1089#1099')'
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
    Top = 144
  end
end
