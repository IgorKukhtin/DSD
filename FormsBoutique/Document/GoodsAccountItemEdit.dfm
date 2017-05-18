object GoodsAccountItemEditForm: TGoodsAccountItemEditForm
  Left = 0
  Top = 0
  Caption = #1054#1087#1083#1072#1090#1072'/'#1074#1086#1079#1074#1088#1072#1090
  ClientHeight = 335
  ClientWidth = 438
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefreshStart
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 108
    Top = 291
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 252
    Top = 291
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
  end
  object cxLabel18: TcxLabel
    Left = 316
    Top = 34
    Caption = #1050#1091#1088#1089' ('#1075#1088#1085'/1 $)'
  end
  object ceCurrencyValue_USD: TcxCurrencyEdit
    Left = 316
    Top = 50
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 89
  end
  object ceAmountGRN: TcxCurrencyEdit
    Left = 173
    Top = 8
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 4
    Width = 120
  end
  object cbisPayTotal: TcxCheckBox
    Left = 316
    Top = 8
    Caption = #1054#1073#1097#1072#1103' '#1086#1087#1083#1072#1090#1072
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 104
  end
  object cbisPayGRN: TcxCheckBox
    Left = 16
    Top = 10
    Caption = #1054#1087#1083#1072#1090#1072' - '#1075#1088#1085
    Properties.ReadOnly = False
    TabOrder = 6
    Width = 104
  end
  object cbisPayUSD: TcxCheckBox
    Left = 16
    Top = 50
    Caption = #1054#1087#1083#1072#1090#1072' - $'
    Properties.ReadOnly = False
    TabOrder = 7
    Width = 104
  end
  object cbisPayEUR: TcxCheckBox
    Left = 16
    Top = 90
    Caption = #1054#1087#1083#1072#1090#1072' - EUR'
    Properties.ReadOnly = False
    TabOrder = 8
    Width = 104
  end
  object cbisPayCard: TcxCheckBox
    Left = 16
    Top = 130
    Caption = #1054#1087#1083#1072#1090#1072' - '#1075#1088#1085' ('#1082#1072#1088#1090#1086#1095#1082#1072')'
    Properties.ReadOnly = False
    TabOrder = 9
    Width = 148
  end
  object cbisDiscount: TcxCheckBox
    Left = 16
    Top = 170
    Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1087#1088#1080' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1080
    Properties.ReadOnly = False
    TabOrder = 10
    Width = 156
  end
  object cxLabel1: TcxLabel
    Left = 17
    Top = 218
    Caption = #1048#1090#1086#1075#1086', '#1075#1088#1085':'
  end
  object ceAmount: TcxCurrencyEdit
    Left = 83
    Top = 217
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 85
  end
  object cxLabel3: TcxLabel
    Left = 174
    Top = 218
    Caption = #1054#1089#1090#1072#1090#1086#1082', '#1075#1088#1085':'
  end
  object ceAmountRemains: TcxCurrencyEdit
    Left = 249
    Top = 217
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 14
    Width = 85
  end
  object cxLabel4: TcxLabel
    Left = 185
    Top = 253
    Caption = #1057#1076#1072#1095#1072', '#1075#1088#1085':'
  end
  object ceAmountChange: TcxCurrencyEdit
    Left = 249
    Top = 252
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 85
  end
  object ceAmountUSD: TcxCurrencyEdit
    Left = 173
    Top = 50
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 17
    Width = 120
  end
  object ceAmountEUR: TcxCurrencyEdit
    Left = 173
    Top = 90
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 18
    Width = 120
  end
  object ceAmountCARD: TcxCurrencyEdit
    Left = 173
    Top = 130
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 19
    Width = 120
  end
  object ceAmountDiscount: TcxCurrencyEdit
    Left = 173
    Top = 170
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 20
    Width = 120
  end
  object cxLabel2: TcxLabel
    Left = 316
    Top = 74
    Caption = #1050#1091#1088#1089' ('#1075#1088#1085'/1 EUR)'
  end
  object ceCurrencyValue_EUR: TcxCurrencyEdit
    Left = 316
    Top = 90
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 22
    Width = 89
  end
  object ActionList: TActionList
    Left = 16
    Top = 240
    object dsdDataSetRefreshStart: TdsdDataSetRefresh
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
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end
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
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_GoodsAccount_Child'
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
        Name = 'inParentId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPayTotal'
        Value = Null
        Component = cbisPayTotal
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPayGRN'
        Value = Null
        Component = cbisPayGRN
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPayUSD'
        Value = Null
        Component = cbisPayUSD
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPayEUR'
        Value = Null
        Component = cbisPayEUR
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPayCard'
        Value = Null
        Component = cbisPayCard
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDiscount'
        Value = Null
        Component = cbisDiscount
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountGRN'
        Value = Null
        Component = ceAmountGRN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountUSD'
        Value = Null
        Component = ceAmountUSD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountEUR'
        Value = Null
        Component = ceAmountEUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountCARD'
        Value = Null
        Component = ceAmountCARD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountDiscount'
        Value = '2'
        Component = ceAmountDiscount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 348
    Top = 168
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = '0'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPayTotal'
        Value = Null
        Component = cbisPayTotal
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 40
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MI_GoodsAccount_Child'
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
        Name = 'CurrencyValue_USD'
        Value = Null
        Component = ceCurrencyValue_USD
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyValue_EUR'
        Value = Null
        Component = ceCurrencyValue_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountGRN'
        Value = Null
        Component = ceAmountGRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD'
        Value = Null
        Component = ceAmountUSD
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR'
        Value = Null
        Component = ceAmountEUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountCard'
        Value = Null
        Component = ceAmountCARD
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount'
        Value = Null
        Component = ceAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains'
        Value = Null
        Component = ceAmountRemains
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountChange'
        Value = Null
        Component = ceAmountChange
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 232
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
    Left = 320
    Top = 120
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 64
    Top = 288
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = dsdDataSetRefresh
    ComponentList = <
      item
        Component = cbisDiscount
      end
      item
        Component = cbisPayCard
      end
      item
        Component = cbisPayUSD
      end
      item
        Component = cbisPayEUR
      end
      item
        Component = cbisPayGRN
      end
      item
        Component = ceAmountCARD
      end
      item
        Component = ceAmountDiscount
      end
      item
        Component = ceAmountEUR
      end
      item
        Component = ceAmountUSD
      end
      item
        Component = ceAmountGRN
      end>
    Left = 392
    Top = 120
  end
end
