inherited TaxUnitEditForm: TTaxUnitEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1053#1072#1094#1077#1085#1082#1072' '#1076#1083#1103' '#1085#1086#1095#1085#1099#1093' '#1094#1077#1085'>'
  ClientHeight = 166
  ClientWidth = 350
  AddOnFormData.RefreshAction = nil
  ExplicitWidth = 356
  ExplicitHeight = 194
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Top = 124
    ExplicitTop = 124
  end
  inherited bbCancel: TcxButton
    Top = 124
    ExplicitTop = 124
  end
  object cxLabel18: TcxLabel [2]
    Left = 192
    Top = 63
    Caption = '% '#1085#1072#1094#1077#1085#1082#1080
  end
  object ceValue: TcxCurrencyEdit [3]
    Left = 192
    Top = 82
    Properties.DisplayFormat = ',0.##'
    TabOrder = 3
    Width = 150
  end
  object cxLabel1: TcxLabel [4]
    Left = 11
    Top = 6
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object edUnit: TcxButtonEdit [5]
    Left = 11
    Top = 27
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 331
  end
  object edPrice: TcxCurrencyEdit [6]
    Left = 11
    Top = 82
    Properties.DisplayFormat = ',0.##'
    TabOrder = 6
    Width = 150
  end
  object cxLabel2: TcxLabel [7]
    Left = 11
    Top = 63
    Caption = #1062#1077#1085#1072' '#1089'...'
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 187
    Top = 16
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 280
    Top = 64
  end
  inherited ActionList: TActionList
    Left = 183
    Top = 73
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = nil
      StoredProcList = <>
      ShortCut = 0
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Price'
        Value = Null
        Component = edPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value'
        Value = Null
        Component = ceValue
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 312
    Top = 56
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_TaxUnit'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = ''
        Component = edPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue'
        Value = ''
        Component = ceValue
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 80
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_TaxUnit'
    Params = <
      item
        Name = 'Id'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Price'
        Value = ''
        Component = edPrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value'
        Value = ''
        Component = ceValue
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 82
  end
  object GuidesUnit: TdsdGuides
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
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 233
    Top = 22
  end
end
