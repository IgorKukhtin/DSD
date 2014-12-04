inherited OrderKindEditForm: TOrderKindEditForm
  ActiveControl = edName
  Caption = #1042#1080#1076' '#1076#1086#1075#1086#1074#1086#1088#1072
  ClientHeight = 124
  ClientWidth = 360
  ExplicitWidth = 366
  ExplicitHeight = 149
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
    Caption = #1042#1080#1076' '#1076#1086#1075#1086#1074#1086#1088#1072
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
    Top = 40
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_OrderKind'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inCode'
        Value = Null
        Component = ceCode
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Value = Null
        Component = edName
        DataType = ftString
        ParamType = ptInput
      end>
    Top = 56
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_OrderKind'
    Params = <
      item
        Name = 'Id'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'Code'
        Value = Null
        Component = ceCode
      end
      item
        Name = 'Name'
        Value = Null
        Component = edName
        DataType = ftString
      end>
    Top = 56
  end
end
