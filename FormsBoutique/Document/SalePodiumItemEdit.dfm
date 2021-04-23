object SalePodiumItemEditForm: TSalePodiumItemEditForm
  Left = 0
  Top = 0
  Caption = #1054#1087#1083#1072#1090#1072' '#1074' '#1055#1088#1086#1076#1072#1078#1077
  ClientHeight = 320
  ClientWidth = 439
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
    Top = 279
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 252
    Top = 279
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
    TabOrder = 3
    Width = 100
  end
  object ceAmountGRN: TcxCurrencyEdit
    Left = 173
    Top = 10
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 4
    Width = 120
  end
  object cbisPayTotal: TcxCheckBox
    Left = 316
    Top = 8
    Caption = #1054#1087#1083#1072#1090#1072' '#1048#1058#1054#1043#1054
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 104
  end
  object cxLabel1: TcxLabel
    Left = 31
    Top = 195
    Caption = #1050' '#1086#1087#1083#1072#1090#1077', '#1075#1088#1085':'
  end
  object ceAmountToPay: TcxCurrencyEdit
    Left = 31
    Top = 211
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 100
  end
  object cxLabel3: TcxLabel
    Left = 173
    Top = 195
    Caption = #1054#1089#1090#1072#1090#1086#1082', '#1075#1088#1085':'
  end
  object ceAmountRemains: TcxCurrencyEdit
    Left = 173
    Top = 211
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 100
  end
  object cxLabel4: TcxLabel
    Left = 316
    Top = 195
    Caption = #1057#1076#1072#1095#1072', '#1075#1088#1085':'
  end
  object ceAmountDiff: TcxCurrencyEdit
    Left = 316
    Top = 211
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 100
  end
  object ceAmountUSD: TcxCurrencyEdit
    Left = 173
    Top = 50
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 12
    Width = 120
  end
  object ceAmountEUR: TcxCurrencyEdit
    Left = 173
    Top = 90
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 13
    Width = 120
  end
  object ceAmountCARD: TcxCurrencyEdit
    Left = 173
    Top = 130
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 14
    Width = 120
  end
  object ceAmountDiscount: TcxCurrencyEdit
    Left = 173
    Top = 170
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.#### '#1043#1056#1053
    Properties.ReadOnly = True
    TabOrder = 15
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
    TabOrder = 17
    Width = 100
  end
  object cbisGRN: TcxCheckBox
    Left = 17
    Top = 8
    Action = actRefreshGRN
    Properties.ReadOnly = False
    TabOrder = 18
    Width = 104
  end
  object cbisUSD: TcxCheckBox
    Left = 17
    Top = 50
    Action = actRefreshUSD
    Properties.ReadOnly = False
    TabOrder = 19
    Width = 104
  end
  object cbisEUR: TcxCheckBox
    Left = 17
    Top = 90
    Action = actRefreshEUR
    Properties.ReadOnly = False
    TabOrder = 20
    Width = 104
  end
  object cbisCARD: TcxCheckBox
    Left = 17
    Top = 130
    Action = actRefreshCard
    Properties.ReadOnly = False
    TabOrder = 21
    Width = 147
  end
  object cbisDiscount: TcxCheckBox
    Left = 17
    Top = 170
    Action = actRefreshDiscount
    Properties.ReadOnly = False
    TabOrder = 22
    Width = 156
  end
  object cxLabel5: TcxLabel
    Left = 31
    Top = 234
    Caption = #1050' '#1086#1087#1083#1072#1090#1077', EUR:'
  end
  object ceAmountToPay_curr: TcxCurrencyEdit
    Left = 31
    Top = 250
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 24
    Width = 100
  end
  object cxLabel6: TcxLabel
    Left = 173
    Top = 234
    Caption = #1054#1089#1090#1072#1090#1086#1082', EUR:'
  end
  object ceAmountRemains_curr: TcxCurrencyEdit
    Left = 173
    Top = 250
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 26
    Width = 100
  end
  object ceAmountDiscount_curr: TcxCurrencyEdit
    Left = 316
    Top = 170
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.#### EUR'
    Properties.ReadOnly = True
    TabOrder = 27
    Width = 100
  end
  object cxLabel19: TcxLabel
    Left = 316
    Top = 234
    Caption = #1042#1072#1083#1102#1090#1072' ('#1087#1086#1082'.)'
  end
  object edCurrencyClient: TcxButtonEdit
    Left = 316
    Top = 250
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 29
    Width = 100
  end
  object ceAmountToPay_GRN: TcxCurrencyEdit
    Left = 137
    Top = 211
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 30
    Visible = False
    Width = 30
  end
  object ceAmountToPay_EUR: TcxCurrencyEdit
    Left = 137
    Top = 250
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 31
    Visible = False
    Width = 30
  end
  object ActionList: TActionList
    Left = 16
    Top = 125
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
    object actRefreshTotal: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_Total
      StoredProcList = <
        item
          StoredProc = spGet_Total
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshDiscount: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_isDiscount
      StoredProcList = <
        item
          StoredProc = spGet_isDiscount
        end>
      Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1087#1088#1080' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1080
      Hint = #1057#1087#1080#1089#1072#1085#1080#1077' '#1087#1088#1080' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1080
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshCard: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_isCard
      StoredProcList = <
        item
          StoredProc = spGet_isCard
        end>
      Caption = #1054#1087#1083#1072#1090#1072' - '#1075#1088#1085' ('#1082#1072#1088#1090#1086#1095#1082#1072')'
      Hint = #1054#1087#1083#1072#1090#1072' - '#1075#1088#1085' ('#1082#1072#1088#1090#1086#1095#1082#1072')'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshEUR: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_isEUR
      StoredProcList = <
        item
          StoredProc = spGet_isEUR
        end>
      Caption = #1054#1087#1083#1072#1090#1072' - EUR'
      Hint = #1054#1087#1083#1072#1090#1072' - EUR'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshUSD: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_isUSD
      StoredProcList = <
        item
          StoredProc = spGet_isUSD
        end>
      Caption = #1054#1087#1083#1072#1090#1072' - $'
      Hint = #1054#1087#1083#1072#1090#1072' - $'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshGRN: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_isGRN
      StoredProcList = <
        item
          StoredProc = spGet_isGRN
        end>
      Caption = #1054#1087#1083#1072#1090#1072' - '#1075#1088#1085
      Hint = #1054#1087#1083#1072#1090#1072' - '#1075#1088#1085
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
    StoredProcName = 'gpInsertUpdate_MI_Sale_Child'
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
        Value = 2.000000000000000000
        Component = ceAmountDiscount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueUSD'
        Value = Null
        Component = ceCurrencyValue_USD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParValueUSD'
        Value = 1.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueEUR'
        Value = Null
        Component = ceCurrencyValue_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParValueEUR'
        Value = 1.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 316
    Top = 32
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
      end
      item
        Name = 'CurrencyNum_ToPay'
        Value = 1
        Component = dsdPropertiesСhange_AmountDiscount
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyNum_ToPay_curr'
        Value = 2
        Component = dsdPropertiesСhange_AmountDiscount_curr
        MultiSelectSeparator = ','
      end>
    Left = 128
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Sale_Child'
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
        Name = 'AmountDiscount'
        Value = Null
        Component = ceAmountDiscount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscount_curr'
        Value = Null
        Component = ceAmountDiscount_curr
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay'
        Value = Null
        Component = ceAmountToPay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay_curr'
        Value = Null
        Component = ceAmountToPay_curr
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay_GRN'
        Value = Null
        Component = ceAmountToPay_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay_EUR'
        Value = Null
        Component = ceAmountToPay_EUR
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
        Name = 'AmountRemains_curr'
        Value = Null
        Component = ceAmountRemains_curr
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiff'
        Value = Null
        Component = ceAmountDiff
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPayTotal'
        Value = Null
        Component = cbisPayTotal
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGRN'
        Value = Null
        Component = cbisGRN
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isUSD'
        Value = Null
        Component = cbisUSD
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isEUR'
        Value = Null
        Component = cbisEUR
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCARD'
        Value = Null
        Component = cbisCARD
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDiscount'
        Value = Null
        Component = cbisDiscount
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId_Client'
        Value = Null
        Component = GuidesCurrencyClient
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName_Client'
        Value = Null
        Component = GuidesCurrencyClient
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyNum_ToPay'
        Value = Null
        Component = FormParams
        ComponentItem = 'CurrencyNum_ToPay'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyNum_ToPay_curr'
        Value = Null
        Component = FormParams
        ComponentItem = 'CurrencyNum_ToPay_curr'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 224
    Top = 61
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
    Left = 264
    Top = 24
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 208
    Top = 245
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    ComponentList = <
      item
        Component = ceAmountGRN
      end
      item
        Component = ceAmountUSD
      end
      item
        Component = ceAmountEUR
      end
      item
        Component = ceAmountCARD
      end
      item
        Component = ceAmountDiscount
      end
      item
        Component = ceCurrencyValue_USD
      end
      item
        Component = ceCurrencyValue_EUR
      end>
    Left = 376
    Top = 64
  end
  object spGet_Total: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Sale_Child_Total'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inCurrencyValueUSD'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_USD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueEUR'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountToPay_GRN'
        Value = Null
        Component = ceAmountToPay_GRN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountToPay_EUR'
        Value = Null
        Component = ceAmountToPay_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountGRN'
        Value = 0.000000000000000000
        Component = ceAmountGRN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountUSD'
        Value = 0.000000000000000000
        Component = ceAmountUSD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountEUR'
        Value = 0.000000000000000000
        Component = ceAmountEUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountCard'
        Value = 0.000000000000000000
        Component = ceAmountCARD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountDiscount'
        Value = 0.000000000000000000
        Component = ceAmountDiscount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId_Client'
        Value = Null
        Component = GuidesCurrencyClient
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay'
        Value = Null
        Component = ceAmountToPay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay_curr'
        Value = Null
        Component = ceAmountToPay_curr
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay_GRN'
        Value = Null
        Component = ceAmountToPay_GRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountToPay_EUR'
        Value = Null
        Component = ceAmountToPay_EUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains'
        Value = 0.000000000000000000
        Component = ceAmountRemains
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains_curr'
        Value = Null
        Component = ceAmountRemains_curr
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiff'
        Value = 0.000000000000000000
        Component = ceAmountDiff
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscount'
        Value = Null
        Component = ceAmountDiscount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscount_curr'
        Value = Null
        Component = ceAmountDiscount_curr
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 152
    Top = 53
  end
  object spGet_isGRN: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Sale_Child_isGRN'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inisGRN'
        Value = False
        Component = cbisGRN
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueUSD'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_USD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueEUR'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountToPay'
        Value = Null
        Component = ceAmountToPay_GRN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountToPay_curr'
        Value = Null
        Component = ceAmountToPay_EUR
        DataType = ftFloat
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
        Value = 0.000000000000000000
        Component = ceAmountUSD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountEUR'
        Value = 0.000000000000000000
        Component = ceAmountEUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountCard'
        Value = 0.000000000000000000
        Component = ceAmountCARD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountDiscount'
        Value = 0.000000000000000000
        Component = ceAmountDiscount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId_Client'
        Value = Null
        Component = GuidesCurrencyClient
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains'
        Value = 0.000000000000000000
        Component = ceAmountRemains
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains_curr'
        Value = Null
        Component = ceAmountRemains_curr
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiff'
        Value = 0.000000000000000000
        Component = ceAmountDiff
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountGRN'
        Value = Null
        Component = ceAmountGRN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 72
    Top = 8
  end
  object spGet_isUSD: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Sale_Child_isUSD'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inIsUSD'
        Value = False
        Component = cbisUSD
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueUSD'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_USD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueEUR'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountToPay'
        Value = Null
        Component = ceAmountToPay_GRN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountToPay_curr'
        Value = Null
        Component = ceAmountToPay_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountGRN'
        Value = 0.000000000000000000
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
        Value = 0.000000000000000000
        Component = ceAmountEUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountCard'
        Value = 0.000000000000000000
        Component = ceAmountCARD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountDiscount'
        Value = 0.000000000000000000
        Component = ceAmountDiscount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId_Client'
        Value = Null
        Component = GuidesCurrencyClient
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains'
        Value = 0.000000000000000000
        Component = ceAmountRemains
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains_curr'
        Value = Null
        Component = ceAmountRemains_curr
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiff'
        Value = 0.000000000000000000
        Component = ceAmountDiff
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountUSD'
        Value = 0.000000000000000000
        Component = ceAmountUSD
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 48
    Top = 48
  end
  object spGet_isEUR: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Sale_Child_isEUR'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inIsEUR'
        Value = False
        Component = cbisEUR
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueUSD'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_USD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueEUR'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountToPay'
        Value = Null
        Component = ceAmountToPay_GRN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountToPay_curr'
        Value = Null
        Component = ceAmountToPay_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountGRN'
        Value = 0.000000000000000000
        Component = ceAmountGRN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountUSD'
        Value = 0.000000000000000000
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
        Name = 'inAmountCard'
        Value = 0.000000000000000000
        Component = ceAmountCARD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountDiscount'
        Value = 0.000000000000000000
        Component = ceAmountDiscount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId_Client'
        Value = Null
        Component = GuidesCurrencyClient
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains'
        Value = 0.000000000000000000
        Component = ceAmountRemains
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains_curr'
        Value = Null
        Component = ceAmountRemains_curr
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiff'
        Value = 0.000000000000000000
        Component = ceAmountDiff
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountEUR'
        Value = 0.000000000000000000
        Component = ceAmountEUR
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 112
    Top = 80
  end
  object spGet_isCard: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Sale_Child_isCard'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inisCARD'
        Value = False
        Component = cbisCARD
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueUSD'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_USD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueEUR'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountToPay'
        Value = Null
        Component = ceAmountToPay_GRN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountToPay_curr'
        Value = Null
        Component = ceAmountToPay_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountGRN'
        Value = 0.000000000000000000
        Component = ceAmountGRN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountUSD'
        Value = 0.000000000000000000
        Component = ceAmountUSD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountEUR'
        Value = 0.000000000000000000
        Component = ceAmountEUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountCard'
        Value = Null
        Component = ceAmountCARD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountDiscount'
        Value = 0.000000000000000000
        Component = ceAmountDiscount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId_Client'
        Value = Null
        Component = GuidesCurrencyClient
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains'
        Value = 0.000000000000000000
        Component = ceAmountRemains
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains_curr'
        Value = Null
        Component = ceAmountRemains_curr
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiff'
        Value = 0.000000000000000000
        Component = ceAmountDiff
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountCARD'
        Value = 0.000000000000000000
        Component = ceAmountCARD
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 64
    Top = 124
  end
  object spGet_isDiscount: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Sale_Child_isDiscount'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inIsDiscount'
        Value = False
        Component = cbisDiscount
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueUSD'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_USD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValueEUR'
        Value = 0.000000000000000000
        Component = ceCurrencyValue_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountToPay'
        Value = Null
        Component = ceAmountToPay_GRN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountToPay_curr'
        Value = Null
        Component = ceAmountToPay_EUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountGRN'
        Value = 0.000000000000000000
        Component = ceAmountGRN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountUSD'
        Value = 0.000000000000000000
        Component = ceAmountUSD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountEUR'
        Value = 0.000000000000000000
        Component = ceAmountEUR
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountCard'
        Value = 0.000000000000000000
        Component = ceAmountCARD
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountDiscount'
        Value = Null
        Component = ceAmountDiscount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId_Client'
        Value = Null
        Component = GuidesCurrencyClient
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains'
        Value = 0.000000000000000000
        Component = ceAmountRemains
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains_curr'
        Value = Null
        Component = ceAmountRemains_curr
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiff'
        Value = 0.000000000000000000
        Component = ceAmountDiff
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscount'
        Value = 0.000000000000000000
        Component = ceAmountDiscount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiscount_curr'
        Value = Null
        Component = ceAmountDiscount_curr
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 96
    Top = 176
  end
  object HeaderChanger: THeaderChanger
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    ChangerList = <
      item
        Control = ceAmountGRN
      end
      item
        Control = ceAmountUSD
      end
      item
        Control = ceAmountEUR
      end
      item
        Control = ceAmountCARD
      end
      item
        Control = ceAmountDiscount
      end
      item
        Control = ceCurrencyValue_USD
      end
      item
        Control = ceCurrencyValue_EUR
      end>
    Action = actRefreshTotal
    Left = 280
    Top = 93
  end
  object GuidesCurrencyClient: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCurrencyClient
    FormNameParam.Value = 'test'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'test'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCurrencyClient
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCurrencyClient
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 344
    Top = 248
  end
  object dsdPropertiesСhange_AmountDiscount: TdsdPropertiesСhange
    EditRepository = cxEditRepository_AmountDiscount
    Left = 352
    Top = 120
  end
  object cxEditRepository_AmountDiscount: TcxEditRepository
    Left = 392
    Top = 120
    object cxEditRepositoryCurrency_1GRN: TcxEditRepositoryCurrencyItem
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.#### '#1043#1056#1053
    end
    object cxEditRepositoryCurrency_2EUR: TcxEditRepositoryCurrencyItem
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.#### EUR'
    end
  end
  object dsdPropertiesСhange_AmountDiscount_curr: TdsdPropertiesСhange
    EditRepository = cxEditRepository_AmountDiscount
    Left = 368
    Top = 168
  end
end
