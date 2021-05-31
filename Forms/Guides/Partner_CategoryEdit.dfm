inherited Partner_CategoryEditForm: TPartner_CategoryEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072'>'
  ClientHeight = 230
  ClientWidth = 419
  ExplicitWidth = 425
  ExplicitHeight = 258
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 79
    Top = 184
    TabOrder = 2
    ExplicitLeft = 79
    ExplicitTop = 184
  end
  inherited bbCancel: TcxButton
    Left = 230
    Top = 184
    ExplicitLeft = 230
    ExplicitTop = 184
  end
  object edAddress: TcxTextEdit [2]
    Left = 122
    Top = 128
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 231
  end
  object cxLabel1: TcxLabel [3]
    Left = 15
    Top = 129
    Caption = #1040#1076#1088#1077#1089
  end
  object Код: TcxLabel [4]
    Left = 15
    Top = 12
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit [5]
    Left = 48
    Top = 11
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 3
    Width = 102
  end
  object cxLabel3: TcxLabel [6]
    Left = 15
    Top = 65
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object edJuridical: TcxButtonEdit [7]
    Left = 122
    Top = 64
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 231
  end
  object cxLabel5: TcxLabel [8]
    Left = 184
    Top = 12
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
  end
  object ceCategory: TcxCurrencyEdit [9]
    Left = 253
    Top = 11
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.EditFormat = '0'
    TabOrder = 0
    Width = 100
  end
  object cxLabel13: TcxLabel [10]
    Left = 15
    Top = 95
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object edName: TcxTextEdit [11]
    Left = 122
    Top = 94
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 231
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 291
    Top = 67
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 312
    Top = 24
  end
  inherited ActionList: TActionList
    Left = 247
    Top = 71
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'fff'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'fff'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'fff'
        Value = ''
        Component = edAddress
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Category'
        Value = Null
        Component = ceCategory
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 156
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Partner_Category'
    Params = <
      item
        Name = 'inId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCategory'
        Value = Null
        Component = ceCategory
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 168
    Top = 163
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Partner_Category'
    Params = <
      item
        Name = 'inId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
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
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Address'
        Value = ''
        Component = edAddress
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = dsdJuridicalGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = dsdJuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Category'
        Value = 0.000000000000000000
        Component = ceCategory
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 24
    Top = 152
  end
  object dsdJuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    DisableGuidesOpen = True
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdJuridicalGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdJuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 168
    Top = 60
  end
end
