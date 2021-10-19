object IncomeEditForm: TIncomeEditForm
  Left = 0
  Top = 0
  Caption = 'Abschluudaten Wareneingang'
  ClientHeight = 389
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 156
    Top = 345
    Width = 75
    Height = 25
    Action = actInsertUpdate
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 293
    Top = 345
    Width = 75
    Height = 25
    Action = actFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object cxLabel18: TcxLabel
    Left = 16
    Top = 65
    Caption = '1. Summe EK :'
  end
  object ceTotalSummMVAT: TcxCurrencyEdit
    Left = 158
    Top = 64
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    Style.Color = clGradientInactiveCaption
    TabOrder = 1
    Width = 74
  end
  object cxLabel12: TcxLabel
    Left = 150
    Top = 8
    Caption = 'Lieferanten'
  end
  object edFrom: TcxButtonEdit
    Left = 150
    Top = 26
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 0
    Width = 347
  end
  object cxLabel14: TcxLabel
    Left = 8
    Top = 8
    Caption = 'Interne Nr'
  end
  object edInvNumber: TcxTextEdit
    Left = 8
    Top = 26
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 129
  end
  object cxLabel1: TcxLabel
    Left = 47
    Top = 88
    Caption = '- Rabbat %'
  end
  object ceDiscountTax: TcxCurrencyEdit
    Left = 158
    Top = 87
    Hint = '% '#1089#1082#1080#1076#1082#1080
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 9
    Width = 74
  end
  object cxLabel3: TcxLabel
    Left = 47
    Top = 112
    Caption = '- Rabbat Brutto'
  end
  object ceSummTaxMVAT: TcxCurrencyEdit
    Left = 158
    Top = 111
    Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1089' '#1053#1044#1057
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 11
    Width = 74
  end
  object cxLabel7: TcxLabel
    Left = 47
    Top = 136
    Caption = '- Rabbat Netto'
  end
  object ceSummTaxPVAT: TcxCurrencyEdit
    Left = 158
    Top = 135
    Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1073#1077#1079' '#1053#1044#1057
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 13
    Width = 74
  end
  object cxLabel9: TcxLabel
    Left = 16
    Top = 165
    Caption = '2. Zwischensumme :'
  end
  object cxLabel11: TcxLabel
    Left = 298
    Top = 87
    Caption = '+ Porto Netto'
  end
  object cxLabel13: TcxLabel
    Left = 298
    Top = 111
    Caption = '+ Verpackung Netto'
  end
  object cxLabel15: TcxLabel
    Left = 298
    Top = 135
    Caption = '+ Versicherung Netto'
  end
  object ceSummInsur: TcxCurrencyEdit
    Left = 409
    Top = 134
    Hint = #1057#1090#1088#1072#1093#1086#1074#1082#1072' '#1088#1072#1089#1093#1086#1076#1099', '#1073#1077#1079' '#1053#1044#1057
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 18
    Width = 74
  end
  object ceSummPack: TcxCurrencyEdit
    Left = 409
    Top = 110
    Hint = #1059#1087#1072#1082#1086#1074#1082#1072' '#1088#1072#1089#1093#1086#1076#1099', '#1073#1077#1079' '#1053#1044#1057
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 19
    Width = 74
  end
  object ceSummPost: TcxCurrencyEdit
    Left = 409
    Top = 86
    Hint = #1055#1086#1095#1090#1086#1074#1099#1077' '#1088#1072#1089#1093#1086#1076#1099', '#1073#1077#1079' '#1053#1044#1057
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 20
    Width = 74
  end
  object ceSumm2: TcxCurrencyEdit
    Left = 158
    Top = 164
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    Style.Color = clGradientInactiveCaption
    TabOrder = 21
    Width = 74
  end
  object cxLabel16: TcxLabel
    Left = 267
    Top = 165
    Caption = '3. Zwischensumme :'
  end
  object cxLabel17: TcxLabel
    Left = 47
    Top = 216
    Caption = '- Scontobetr %'
  end
  object cxLabel19: TcxLabel
    Left = 47
    Top = 240
    Caption = '- Scontobetr Brutto'
  end
  object cxLabel20: TcxLabel
    Left = 47
    Top = 264
    Caption = '- Scontobetr Netto'
  end
  object ceTotalSummTaxPVAT: TcxCurrencyEdit
    Left = 158
    Top = 263
    Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1073#1077#1079' '#1053#1044#1057' '#1080#1090#1086#1075#1086
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 26
    Width = 74
  end
  object ceTotalSummTaxMVAT: TcxCurrencyEdit
    Left = 158
    Top = 239
    Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1089' '#1053#1044#1057' '#1080#1090#1086#1075#1086
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 27
    Width = 74
  end
  object ceTotalDiscountTax: TcxCurrencyEdit
    Left = 158
    Top = 215
    Hint = '% '#1089#1082#1080#1076#1082#1080' '#1080#1090#1086#1075#1086
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 28
    Width = 74
  end
  object ceSumm3: TcxCurrencyEdit
    Left = 409
    Top = 164
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    Style.Color = clGradientInactiveCaption
    TabOrder = 29
    Width = 74
  end
  object cxLabel10: TcxLabel
    Left = 16
    Top = 292
    Caption = '4. Gesamt :'
  end
  object ceTotalSumm: TcxCurrencyEdit
    Left = 158
    Top = 291
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    Style.Color = clGradientInactiveCaption
    TabOrder = 31
    Width = 74
  end
  object ActionList: TActionList
    Left = 8
    Top = 248
    object actRefresh: TdsdDataSetRefresh
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
    object actInsertUpdate: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Price
      StoredProcList = <
        item
          StoredProc = spUpdate_Price
        end>
      Caption = 'Ok'
    end
    object actFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
    object actRefreshOperPriceList: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_Price
      StoredProcList = <
        item
          StoredProc = spUpdate_Price
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actUpdate_PriceWithoutPersent: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Price
      StoredProcList = <
        item
          StoredProc = spUpdate_Price
        end>
      Caption = #1088#1072#1089#1095#1077#1090' '#1074#1093'. '#1094#1077#1085#1099' '#1073#1077#1079' '#1087#1088#1086#1094#1077#1085#1090#1072
      Hint = #1088#1072#1089#1095#1077#1090' '#1074#1093'. '#1094#1077#1085#1099' '#1073#1077#1079' '#1087#1088#1086#1094#1077#1085#1090#1072
      ImageIndex = 56
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MIEdit_Income'
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
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountForPrice'
        Value = 1.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 2.000000000000000000
        Component = ceTotalSummMVAT
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPrice_orig'
        Value = 45.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPrice'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountTax'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummIn'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPriceList'
        Value = 55.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 452
    Top = 328
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
        Name = 'InvNumber'
        Value = Null
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_IncomeEdit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummMVAT'
        Value = Null
        Component = ceTotalSummMVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountTax'
        Value = ''
        Component = ceDiscountTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummTaxMVAT'
        Value = Null
        Component = ceSummTaxMVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummTaxPVAT'
        Value = Null
        Component = ceSummTaxPVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Summ2'
        Value = Null
        Component = ceSumm2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummPost'
        Value = Null
        Component = ceSummPost
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummPack'
        Value = Null
        Component = ceSummPack
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummInsur'
        Value = Null
        Component = ceSummInsur
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Summ3'
        Value = Null
        Component = ceSumm3
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalDiscountTax'
        Value = Null
        Component = ceTotalDiscountTax
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummTaxMVAT'
        Value = Null
        Component = ceTotalSummTaxMVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummTaxPVAT'
        Value = Null
        Component = ceTotalSummTaxPVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Summ4'
        Value = Null
        Component = ceTotalSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 280
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
    Left = 280
    Top = 272
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 64
    Top = 336
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 223
    Top = 15
  end
  object spUpdate_Price: TdsdStoredProc
    StoredProcName = 'gpUpdate_IncomeEdit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTotalSummMVAT'
        Value = Null
        Component = ceTotalSummMVAT
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioDiscountTax'
        Value = Null
        Component = ceDiscountTax
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummTaxMVAT'
        Value = Null
        Component = ceSummTaxMVAT
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummTaxPVAT'
        Value = 0.000000000000000000
        Component = ceSummTaxPVAT
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummPost'
        Value = Null
        Component = ceSummPost
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummPack'
        Value = 0.000000000000000000
        Component = ceSummPack
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummInsur'
        Value = Null
        Component = ceSummInsur
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioTotalDiscountTax'
        Value = Null
        Component = ceTotalDiscountTax
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioTotalSummTaxMVAT'
        Value = Null
        Component = ceTotalSummTaxMVAT
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioTotalSummTaxPVAT'
        Value = Null
        Component = ceTotalSummTaxPVAT
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumm2'
        Value = Null
        Component = ceSumm2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumm3'
        Value = Null
        Component = ceSumm3
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumm4'
        Value = Null
        Component = ceTotalSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 216
  end
  object HeaderExit: THeaderExit
    ExitList = <
      item
        Control = ceDiscountTax
      end
      item
        Control = ceSummTaxMVAT
      end
      item
        Control = ceSummTaxPVAT
      end
      item
        Control = ceSummPost
      end
      item
        Control = ceSummPack
      end
      item
        Control = ceSummInsur
      end
      item
        Control = ceTotalDiscountTax
      end
      item
        Control = ceTotalSummTaxMVAT
      end
      item
        Control = ceTotalSummTaxPVAT
      end>
    Action = actRefreshOperPriceList
    Left = 328
    Top = 208
  end
end
