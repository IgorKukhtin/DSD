inherited GoodsAdditionalEditForm: TGoodsAdditionalEditForm
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088'>'
  ClientHeight = 392
  ClientWidth = 358
  ExplicitWidth = 364
  ExplicitHeight = 421
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 67
    Top = 353
    TabOrder = 5
    ExplicitLeft = 67
    ExplicitTop = 353
  end
  inherited bbCancel: TcxButton
    Left = 204
    Top = 353
    TabOrder = 6
    ExplicitLeft = 204
    ExplicitTop = 353
  end
  object edName: TcxTextEdit [2]
    Left = 9
    Top = 60
    TabStop = False
    Properties.ReadOnly = True
    TabOrder = 1
    Width = 332
  end
  object cxLabel1: TcxLabel [3]
    Left = 9
    Top = 43
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1085#1072' '#1088#1091#1089'. '#1103#1079#1099#1082#1077')'
  end
  object cxLabel2: TcxLabel [4]
    Left = 9
    Top = 130
    Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
  end
  object ceCode: TcxCurrencyEdit [5]
    Left = 9
    Top = 22
    TabStop = False
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 0
    Width = 162
  end
  object Код: TcxLabel [6]
    Left = 9
    Top = 5
    Caption = #1050#1086#1076
  end
  object edMakerName: TcxButtonEdit [7]
    Left = 9
    Top = 149
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 2
    Width = 332
  end
  object edNumberPlates: TcxCurrencyEdit [8]
    Left = 8
    Top = 291
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 3
    Width = 109
  end
  object cxLabel3: TcxLabel [9]
    Left = 8
    Top = 274
    Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1089#1090#1080#1085' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077':'
  end
  object cxLabel7: TcxLabel [10]
    Left = 176
    Top = 274
    Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077':'
  end
  object ceQtyPackage: TcxCurrencyEdit [11]
    Left = 176
    Top = 291
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 4
    Width = 109
  end
  object cbIsRecipe: TcxCheckBox [12]
    Left = 8
    Top = 318
    Caption = #1056#1077#1094#1077#1087#1090#1091#1088#1072
    TabOrder = 12
    Width = 96
  end
  object edNameUkr: TcxTextEdit [13]
    Left = 9
    Top = 99
    TabStop = False
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 332
  end
  object cxLabel12: TcxLabel [14]
    Left = 9
    Top = 81
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1085#1072' '#1091#1082#1088'. '#1103#1079#1099#1082#1077')'
  end
  object edFormDispensing: TcxButtonEdit [15]
    Left = 9
    Top = 244
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 332
  end
  object cxLabel14: TcxLabel [16]
    Left = 8
    Top = 227
    Caption = #1060#1086#1088#1084#1072' '#1086#1090#1087#1091#1089#1082#1072
  end
  object edMakerNameUkr: TcxTextEdit [17]
    Left = 8
    Top = 199
    TabOrder = 17
    Width = 332
  end
  object cxLabel4: TcxLabel [18]
    Left = 8
    Top = 178
    Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100' '#1059#1082#1088'. '#1085#1072#1079#1074#1072#1085#1080#1077
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 187
    Top = 34
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 104
    Top = 34
  end
  inherited ActionList: TActionList
    Left = 175
    Top = 88
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
        Name = 'GoodsMainId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 97
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsAdditional'
    Params = <
      item
        Name = 'inId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMakerName'
        Value = ''
        Component = edMakerName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMakerNameUkr'
        Value = Null
        Component = edMakerNameUkr
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFormDispensingId'
        Value = Null
        Component = FormDispensingGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumberPlates'
        Value = ''
        Component = edNumberPlates
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inQtyPackage'
        Value = ''
        Component = ceQtyPackage
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsRecipe'
        Value = Null
        Component = cbIsRecipe
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 8
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_GoodsAdditional'
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
        Name = 'GoodsMainId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsMainId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
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
        Name = 'MakerName'
        Value = ''
        Component = edMakerName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MakerNameUkr'
        Value = Null
        Component = edMakerNameUkr
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NameUkr'
        Value = Null
        Component = edNameUkr
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormDispensingId'
        Value = Null
        Component = FormDispensingGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormDispensingName'
        Value = Null
        Component = FormDispensingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NumberPlates'
        Value = Null
        Component = edNumberPlates
        MultiSelectSeparator = ','
      end
      item
        Name = 'QtyPackage'
        Value = Null
        Component = ceQtyPackage
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRecipe'
        Value = Null
        Component = cbIsRecipe
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 64
  end
  object GoodsMakerNameGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMakerName
    FormNameParam.Value = 'TGoodsMakerNameForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsMakerNameForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsMakerNameGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsMakerNameGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsMainId'
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 127
  end
  object FormDispensingGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFormDispensing
    FormNameParam.Value = 'TFormDispensingForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TFormDispensingForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FormDispensingGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FormDispensingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 144
    Top = 231
  end
end
