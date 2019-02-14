inherited GoodsCategoryEditForm: TGoodsCategoryEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1085#1072#1103' '#1084#1072#1090#1088#1080#1094#1072'('#1050#1072#1090#1077#1075#1086#1088#1080#1080')>'
  ClientHeight = 293
  ClientWidth = 350
  AddOnFormData.RefreshAction = nil
  ExplicitWidth = 356
  ExplicitHeight = 321
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Top = 236
    TabOrder = 2
    ExplicitTop = 236
  end
  inherited bbCancel: TcxButton
    Top = 236
    TabOrder = 3
    ExplicitTop = 236
  end
  object cxLabel2: TcxLabel [2]
    Left = 10
    Top = 14
    Caption = #1058#1086#1074#1072#1088
  end
  object edGoods: TcxButtonEdit [3]
    Left = 10
    Top = 35
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 0
    Width = 331
  end
  object cxLabel6: TcxLabel [4]
    Left = 10
    Top = 66
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103'(A-B-C)'
  end
  object edUnitCategory: TcxButtonEdit [5]
    Left = 10
    Top = 87
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 1
    Width = 331
  end
  object cxLabel18: TcxLabel [6]
    Left = 10
    Top = 175
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object ceValue: TcxCurrencyEdit [7]
    Left = 10
    Top = 194
    Properties.DisplayFormat = ',0.##'
    TabOrder = 7
    Width = 166
  end
  object cxLabel1: TcxLabel [8]
    Left = 11
    Top = 120
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object edUnit: TcxButtonEdit [9]
    Left = 11
    Top = 141
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 331
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
    Top = 185
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
        Name = 'GoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitCategoryId'
        Value = Null
        Component = GuidesUnitCategory
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitCategoryName'
        Value = Null
        Component = GuidesUnitCategory
        ComponentItem = 'TextValue'
        DataType = ftString
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
    Left = 304
    Top = 0
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsCategory'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsCategoryId'
        Value = ''
        Component = GuidesUnitCategory
        ComponentItem = 'Key'
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
        Name = 'inValue'
        Value = ''
        Component = ceValue
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 248
    Top = 192
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_GoodsCategory'
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
        Name = 'GoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitCategoryId'
        Value = ''
        Component = GuidesUnitCategory
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitCategoryName'
        Value = ''
        Component = GuidesUnitCategory
        ComponentItem = 'TextValue'
        DataType = ftString
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
        Name = 'Value'
        Value = ''
        Component = ceValue
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 288
    Top = 178
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsMainForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsMainForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 24
  end
  object GuidesUnitCategory: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitCategory
    FormNameParam.Value = 'TUnitCategoryForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitCategoryForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitCategory
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitCategory
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 88
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
    Top = 136
  end
end
