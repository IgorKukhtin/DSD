inherited AddressEditForm: TAddressEditForm
  ActiveControl = edName
  Caption = #1040#1076#1088#1077#1089
  ClientHeight = 124
  ClientWidth = 360
  ExplicitWidth = 366
  ExplicitHeight = 153
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Top = 80
    TabOrder = 2
    ExplicitTop = 80
  end
  inherited bbCancel: TcxButton
    Top = 80
    TabOrder = 3
    ExplicitTop = 80
  end
  object Код: TcxLabel [2]
    Left = 7
    Top = 4
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit [3]
    Left = 7
    Top = 27
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 0
    Width = 66
  end
  object cxLabel1: TcxLabel [4]
    Left = 79
    Top = 4
    Caption = #1040#1076#1088#1077#1089
  end
  object edName: TcxTextEdit [5]
    Left = 79
    Top = 27
    TabOrder = 1
    Width = 273
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 72
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 72
  end
  inherited ActionList: TActionList
    Top = 71
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 40
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Address'
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
        Name = 'inCode'
        Value = Null
        Component = ceCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = Null
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 56
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Address'
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
        Name = 'Code'
        Value = Null
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = Null
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Top = 56
  end
end
