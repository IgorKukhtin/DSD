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
    Action = actUpdate_summ_after
    TabOrder = 9
  end
  object cxButton2: TcxButton
    Left = 293
    Top = 345
    Width = 75
    Height = 25
    Action = actFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 10
  end
  object cxLabel18: TcxLabel
    Left = 15
    Top = 65
    Caption = '1. Summe EK :'
  end
  object ceTotalSummMVAT: TcxCurrencyEdit
    Left = 155
    Top = 60
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    Style.Color = clGradientInactiveCaption
    TabOrder = 12
    Width = 75
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
    TabOrder = 11
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
    TabOrder = 16
    Width = 129
  end
  object cxLabel1: TcxLabel
    Left = 48
    Top = 91
    Caption = '- Rabbat %'
  end
  object ceDiscountTax: TcxCurrencyEdit
    Left = 155
    Top = 90
    Hint = '% '#1089#1082#1080#1076#1082#1080
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 0
    Width = 75
  end
  object cxLabel3: TcxLabel
    Left = 48
    Top = 115
    Caption = '- Rabbat Brutto'
  end
  object ceSummTaxPVAT: TcxCurrencyEdit
    Left = 156
    Top = 114
    Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1089' '#1053#1044#1057
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 1
    Width = 75
  end
  object cxLabel7: TcxLabel
    Left = 48
    Top = 142
    Caption = '- Rabbat Netto'
  end
  object ceSummTaxMVAT: TcxCurrencyEdit
    Left = 155
    Top = 141
    Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1073#1077#1079' '#1053#1044#1057
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 2
    Width = 75
  end
  object cxLabel9: TcxLabel
    Left = 15
    Top = 175
    Caption = '2. Zwischensumme :'
  end
  object cxLabel11: TcxLabel
    Left = 300
    Top = 91
    Caption = '+ Porto Netto'
  end
  object cxLabel13: TcxLabel
    Left = 300
    Top = 115
    Caption = '+ Verpackung Netto'
  end
  object cxLabel15: TcxLabel
    Left = 300
    Top = 142
    Caption = '+ Versicherung Netto'
  end
  object ceSummInsur: TcxCurrencyEdit
    Left = 410
    Top = 141
    Hint = #1057#1090#1088#1072#1093#1086#1074#1082#1072' '#1088#1072#1089#1093#1086#1076#1099', '#1073#1077#1079' '#1053#1044#1057
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 5
    Width = 75
  end
  object ceSummPack: TcxCurrencyEdit
    Left = 410
    Top = 114
    Hint = #1059#1087#1072#1082#1086#1074#1082#1072' '#1088#1072#1089#1093#1086#1076#1099', '#1073#1077#1079' '#1053#1044#1057
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 4
    Width = 75
  end
  object ceSummPost: TcxCurrencyEdit
    Left = 410
    Top = 90
    Hint = #1055#1086#1095#1090#1086#1074#1099#1077' '#1088#1072#1089#1093#1086#1076#1099', '#1073#1077#1079' '#1053#1044#1057
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 3
    Width = 75
  end
  object ceSumm2: TcxCurrencyEdit
    Left = 155
    Top = 171
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    Style.Color = clGradientInactiveCaption
    TabOrder = 24
    Width = 75
  end
  object cxLabel16: TcxLabel
    Left = 267
    Top = 175
    Caption = '3. Zwischensumme :'
  end
  object cxLabel17: TcxLabel
    Left = 48
    Top = 216
    Caption = '- Scontobetr %'
  end
  object cxLabel19: TcxLabel
    Left = 48
    Top = 241
    Caption = '- Scontobetr Brutto'
  end
  object cxLabel20: TcxLabel
    Left = 48
    Top = 264
    Caption = '- Scontobetr Netto'
  end
  object ceTotalSummTaxMVAT: TcxCurrencyEdit
    Left = 155
    Top = 263
    Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1073#1077#1079' '#1053#1044#1057' '#1080#1090#1086#1075#1086
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 8
    Width = 75
  end
  object ceTotalSummTaxPVAT: TcxCurrencyEdit
    Left = 155
    Top = 239
    Hint = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1089' '#1053#1044#1057' '#1080#1090#1086#1075#1086
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 7
    Width = 75
  end
  object ceTotalDiscountTax: TcxCurrencyEdit
    Left = 155
    Top = 215
    Hint = '% '#1089#1082#1080#1076#1082#1080' '#1080#1090#1086#1075#1086
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 6
    Width = 75
  end
  object ceSumm3: TcxCurrencyEdit
    Left = 410
    Top = 174
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    Style.Color = clGradientInactiveCaption
    TabOrder = 29
    Width = 75
  end
  object cxLabel10: TcxLabel
    Left = 15
    Top = 291
    Caption = '4. Gesamt :'
  end
  object ceTotalSumm: TcxCurrencyEdit
    Left = 155
    Top = 290
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    Style.Color = clGradientInactiveCaption
    TabOrder = 31
    Width = 75
  end
  object ActionList: TActionList
    Left = 8
    Top = 248
    object actFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
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
      RefreshOnTabSetChanges = False
    end
    object actUpdate_summ_before: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_summ_before
      StoredProcList = <
        item
          StoredProc = spUpdate_summ_before
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      RefreshOnTabSetChanges = False
    end
    object actUpdate_summ_after: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_summ_before
      StoredProcList = <
        item
          StoredProc = spUpdate_summ_before
        end>
      Caption = 'Ok'
    end
  end
  object spUpdate_summ_after: TdsdStoredProc
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
    Left = 436
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
        Name = 'SummTaxPVAT'
        Value = Null
        Component = ceSummTaxPVAT
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
        Name = 'TotalSummTaxPVAT'
        Value = Null
        Component = ceTotalSummTaxPVAT
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
  object spUpdate_summ_before: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Income_summ'
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
        Name = 'inIsBefore'
        Value = False
        DataType = ftBoolean
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
        Name = 'ioSummTaxPVAT'
        Value = 0.000000000000000000
        Component = ceSummTaxPVAT
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
        Name = 'ioTotalSummTaxPVAT'
        Value = Null
        Component = ceTotalSummTaxPVAT
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
        Control = ceSummTaxPVAT
      end
      item
        Control = ceSummTaxMVAT
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
        Control = ceTotalSummTaxPVAT
      end
      item
        Control = ceTotalSummTaxMVAT
      end>
    Action = actUpdate_summ_before
    Left = 328
    Top = 208
  end
  object EnterMoveNext: TEnterMoveNext
    EnterMoveNextList = <
      item
        Control = ceDiscountTax
      end
      item
        Control = ceSummTaxPVAT
      end
      item
        Control = ceSummTaxMVAT
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
        Control = ceTotalSummTaxPVAT
      end
      item
        Control = ceTotalSummTaxMVAT
      end
      item
        Control = cxButton1
      end>
    Left = 352
    Top = 264
  end
end
