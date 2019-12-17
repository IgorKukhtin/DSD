object RetailEditForm: TRetailEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100'>'
  ClientHeight = 374
  ClientWidth = 347
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
    Left = 10
    Top = 72
    TabOrder = 0
    Width = 311
  end
  object cxLabel1: TcxLabel
    Left = 10
    Top = 53
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 55
    Top = 338
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 207
    Top = 338
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object cxLabel2: TcxLabel
    Left = 10
    Top = 8
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 10
    Top = 30
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 309
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 100
    Caption = '% '#1085#1072#1094#1077#1085#1082#1080' '#1076#1083#1103' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080' < 6 '#1084#1077#1089'.'
  end
  object edMarginPercent: TcxCurrencyEdit
    Left = 10
    Top = 121
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 7
    Width = 309
  end
  object cxLabel4: TcxLabel
    Left = 10
    Top = 147
    Caption = 'C'#1091#1084#1084#1072', '#1087#1088#1080' '#1082#1086#1090#1086#1088#1086#1081' '#1074#1082#1083#1102#1095#1072#1077#1090#1089#1103' '#1057#1059#1053
  end
  object edSummSUN: TcxCurrencyEdit
    Left = 10
    Top = 168
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 9
    Width = 309
  end
  object edShareFromPrice: TcxCurrencyEdit
    Left = 10
    Top = 266
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.##'
    TabOrder = 10
    Width = 309
  end
  object cxLabel5: TcxLabel
    Left = 10
    Top = 245
    Caption = #1062#1077#1085#1072', '#1087#1088#1080' '#1082#1086#1090#1086#1088#1086#1081' '#1088#1072#1079#1088#1077#1096#1077#1085#1086' '#1076#1077#1083#1077#1085#1080#1077' '#1085#1072' '#1082#1072#1089#1089#1072#1093
  end
  object edLimitSUN: TcxCurrencyEdit
    Left = 10
    Top = 216
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 12
    Width = 309
  end
  object cxLabel6: TcxLabel
    Left = 10
    Top = 195
    Caption = #1051#1080#1084#1080#1090' '#1076#1083#1103' '#1054#1090#1083#1086#1078#1077#1085' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1057#1059#1053')'
  end
  object cbGoodsReprice: TcxCheckBox
    Left = 10
    Top = 295
    Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053
    Caption = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1084#1086#1076#1077#1083#1080' "'#1055#1077#1088#1077#1086#1094#1077#1085#1082#1072' '#1074' '#1084#1080#1085#1091#1089'"'
    TabOrder = 14
    Width = 239
  end
  object ActionList: TActionList
    Left = 296
    Top = 16
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
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Retail'
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
        Name = 'inMarginPercent'
        Value = Null
        Component = edMarginPercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummSUN'
        Value = Null
        Component = edSummSUN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLimitSUN'
        Value = Null
        Component = edLimitSUN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShareFromPrice'
        Value = Null
        Component = edShareFromPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsReprice'
        Value = Null
        Component = cbGoodsReprice
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 112
    Top = 48
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Retail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCode
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
        Name = 'MarginPercent'
        Value = Null
        Component = edMarginPercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummSUN'
        Value = Null
        Component = edSummSUN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LimitSUN'
        Value = Null
        Component = edLimitSUN
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShareFromPrice'
        Value = Null
        Component = edShareFromPrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGoodsReprice'
        Value = Null
        Component = cbGoodsReprice
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 136
    Top = 208
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
    Left = 200
    Top = 72
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 312
    Top = 120
  end
end
