object OrderSheduleEditForm: TOrderSheduleEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1043#1088#1072#1092#1080#1082' '#1079#1072#1082#1072#1079#1072'/'#1076#1086#1089#1090#1072#1074#1082#1080'>'
  ClientHeight = 299
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
  object cxButton1: TcxButton
    Left = 64
    Top = 261
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 216
    Top = 261
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 2
  end
  object Код: TcxLabel
    Left = 40
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 19
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 0
    Width = 292
  end
  object cxLabel2: TcxLabel
    Left = 19
    Top = 145
    Caption = #1055#1086#1085#1077#1076#1077#1083#1100#1085#1080#1082
  end
  object ceValue1: TcxCurrencyEdit
    Left = 98
    Top = 145
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0;-,0; ;'
    TabOrder = 5
    Width = 57
  end
  object cxLabel19: TcxLabel
    Left = 19
    Top = 97
    Caption = #1044#1086#1075#1086#1074#1086#1088
  end
  object edContract: TcxButtonEdit
    Left = 19
    Top = 117
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 292
  end
  object cxLabel1: TcxLabel
    Left = 19
    Top = 52
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object edUnit: TcxButtonEdit
    Left = 19
    Top = 70
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 292
  end
  object cxLabel3: TcxLabel
    Left = 19
    Top = 170
    Caption = #1042#1090#1086#1088#1085#1080#1082
  end
  object ceValue2: TcxCurrencyEdit
    Left = 98
    Top = 170
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0;-,0; ;'
    TabOrder = 11
    Width = 57
  end
  object cxLabel4: TcxLabel
    Left = 19
    Top = 195
    Caption = #1057#1088#1077#1076#1072
  end
  object ceValue3: TcxCurrencyEdit
    Left = 98
    Top = 195
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0;-,0; ;'
    TabOrder = 13
    Width = 57
  end
  object ceValue4: TcxCurrencyEdit
    Left = 98
    Top = 220
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0;-,0; ;'
    TabOrder = 14
    Width = 57
  end
  object cxLabel5: TcxLabel
    Left = 19
    Top = 220
    Caption = #1063#1077#1090#1074#1077#1088#1075
  end
  object ceValue5: TcxCurrencyEdit
    Left = 254
    Top = 144
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0;-,0; ;'
    TabOrder = 16
    Width = 57
  end
  object cxLabel6: TcxLabel
    Left = 182
    Top = 144
    Caption = #1055#1103#1090#1085#1080#1094#1072
  end
  object ceValue6: TcxCurrencyEdit
    Left = 254
    Top = 169
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0;-,0; ;'
    TabOrder = 18
    Width = 57
  end
  object cxLabel7: TcxLabel
    Left = 182
    Top = 169
    Caption = #1057#1091#1073#1073#1086#1090#1072
  end
  object ceValue7: TcxCurrencyEdit
    Left = 254
    Top = 195
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0;-,0; ;'
    TabOrder = 20
    Width = 57
  end
  object cxLabel8: TcxLabel
    Left = 182
    Top = 195
    Caption = #1042#1086#1089#1082#1088#1077#1089#1077#1085#1100#1077
  end
  object ActionList: TActionList
    Left = 299
    Top = 248
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
    object dsdFormClose1: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
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
      Caption = #1054#1082
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_OrderShedule'
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
        Name = 'inValue1'
        Value = ''
        Component = ceValue1
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue2'
        Value = 'False'
        Component = ceValue2
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue3'
        Value = 'False'
        Component = ceValue3
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue4'
        Value = 'False'
        Component = ceValue4
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue5'
        Value = 'False'
        Component = ceValue5
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue6'
        Value = 'False'
        Component = ceValue6
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue7'
        Value = 'False'
        Component = ceValue7
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = 0.000000000000000000
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 307
    Top = 112
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MaskId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 24
    Top = 238
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_OrderShedule'
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
        Name = 'InMaskId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'MaskId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value1'
        Value = ''
        Component = ceValue1
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value2'
        Value = 'False'
        Component = ceValue2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value3'
        Value = 0.000000000000000000
        Component = ceValue3
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value4'
        Value = 0.000000000000000000
        Component = ceValue4
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value5'
        Value = 0.000000000000000000
        Component = ceValue5
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value6'
        Value = 0.000000000000000000
        Component = ceValue6
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value7'
        Value = 0.000000000000000000
        Component = ceValue7
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId'
        Value = Null
        Component = ContractGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = Null
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 307
    Top = 48
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
    Left = 291
    Top = 8
  end
  object dsdUserSettingsStorageAddOn1: TdsdUserSettingsStorageAddOn
    Left = 224
  end
  object ContractGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 124
    Top = 96
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 188
    Top = 56
  end
end
