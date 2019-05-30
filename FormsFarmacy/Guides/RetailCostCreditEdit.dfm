inherited RetailCostCreditEditForm: TRetailCostCreditEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1082#1088#1077#1076#1080#1090'. '#1089#1088'-'#1090#1074' '#1087#1086' '#1089#1077#1090#1103#1084'>'
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
    Caption = '% '#1082#1088#1077#1076#1080#1090#1085#1099#1093' '#1089#1088#1077#1076#1089#1090#1074
  end
  object cePercent: TcxCurrencyEdit [3]
    Left = 192
    Top = 82
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 3
    Width = 150
  end
  object cxLabel1: TcxLabel [4]
    Left = 11
    Top = 6
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
  end
  object edRetail: TcxButtonEdit [5]
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
  object edMinPrice: TcxCurrencyEdit [6]
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
    Top = 8
  end
  inherited ActionList: TActionList
    Left = 95
    Top = 41
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
        Name = 'MinPrice'
        Value = Null
        Component = edMinPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Percent'
        Value = Null
        Component = cePercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailName'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 304
    Top = 88
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_RetailCostCredit'
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
        Name = 'inRetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinPrice'
        Value = ''
        Component = edMinPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Percent'
        Value = ''
        Component = cePercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 80
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_RetailCostCredit'
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
        Component = GuidesRetail
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Price'
        Value = ''
        Component = edMinPrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value'
        Value = ''
        Component = cePercent
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 82
  end
  object GuidesRetail: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 169
    Top = 110
  end
end
