object DiffKindEditForm: TDiffKindEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1080#1079#1084#1077#1085#1080#1090#1100' '#1042#1080#1076' '#1086#1090#1082#1072#1079#1072
  ClientHeight = 293
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 21
    Top = 71
    TabOrder = 0
    Width = 296
  end
  object cxLabel1: TcxLabel
    Left = 21
    Top = 48
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 63
    Top = 252
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 213
    Top = 252
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 21
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 21
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 121
  end
  object cbIsClose: TcxCheckBox
    Left = 161
    Top = 26
    Caption = #1047#1072#1082#1088#1099#1090' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072
    TabOrder = 6
    Width = 156
  end
  object ceMaxOrderAmount: TcxCurrencyEdit
    Left = 21
    Top = 121
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.##'
    TabOrder = 7
    Width = 90
  end
  object cxLabel4: TcxLabel
    Left = 21
    Top = 98
    Caption = ' '#1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1072#1103' '#1089#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1072' '
  end
  object ceMaxOrderAmountSecond: TcxCurrencyEdit
    Left = 21
    Top = 166
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.##'
    TabOrder = 9
    Width = 90
  end
  object cxLabel2: TcxLabel
    Left = 21
    Top = 143
    Caption = ' '#1052#1072#1082#1089#1080#1084#1072#1083#1100#1085#1072#1103' '#1089#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1072'  '#1074#1090#1086#1088#1072#1103' '#1096#1082#1072#1083#1072
  end
  object ceDaysForSale: TcxCurrencyEdit
    Left = 21
    Top = 216
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.##'
    TabOrder = 11
    Width = 90
  end
  object cxLabel3: TcxLabel
    Left = 21
    Top = 193
    Caption = #1044#1085#1077#1081' '#1076#1083#1103' '#1087#1088#1086#1076#1072#1078#1099
  end
  object cbisLessYear: TcxCheckBox
    Left = 161
    Top = 44
    Hint = #1056#1072#1079#1088#1077#1096#1077#1085' '#1079#1072#1082#1072#1079' '#1090#1086#1074#1072#1088#1072' '#1089#1086' '#1089#1088#1086#1082#1086#1084' '#1084#1077#1085#1077#1077' '#1075#1086#1076#1072
    Caption = #1047#1072#1082#1072#1079' '#1089#1088#1086#1082#1072' '#1084#1077#1085#1077#1077' '#1075#1086#1076#1072
    ParentShowHint = False
    ShowHint = True
    TabOrder = 13
    Width = 156
  end
  object ActionList: TActionList
    Left = 120
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
    StoredProcName = 'gpInsertUpdate_Object_DiffKind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
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
        Name = 'inIsClose'
        Value = Null
        Component = cbIsClose
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMaxOrderAmount'
        Value = Null
        Component = ceMaxOrderAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMaxOrderAmountSecond'
        Value = Null
        Component = ceMaxOrderAmountSecond
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDaysForSale'
        Value = Null
        Component = ceDaysForSale
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isLessYear'
        Value = Null
        Component = cbisLessYear
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 152
    Top = 40
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 272
    Top = 72
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_DiffKind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
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
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsClose'
        Value = Null
        Component = cbIsClose
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'MaxOrderAmount'
        Value = Null
        Component = ceMaxOrderAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MaxOrderAmountSecond'
        Value = Null
        Component = ceMaxOrderAmountSecond
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DaysForSale'
        Value = Null
        Component = ceDaysForSale
        MultiSelectSeparator = ','
      end
      item
        Name = 'isLessYear'
        Value = Null
        Component = cbisLessYear
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 232
    Top = 32
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 184
    Top = 87
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
    Left = 40
    Top = 64
  end
end
