inherited CashRegisterEditForm: TCashRegisterEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1072#1089#1089#1086#1074#1099#1081' '#1072#1087#1087#1072#1088#1072#1090'>'
  ClientHeight = 195
  ClientWidth = 287
  ExplicitWidth = 293
  ExplicitHeight = 220
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 37
    Top = 161
    TabOrder = 2
    ExplicitLeft = 37
    ExplicitTop = 161
  end
  inherited bbCancel: TcxButton
    Left = 169
    Top = 161
    TabOrder = 3
    ExplicitLeft = 169
    ExplicitTop = 161
  end
  object edMeasureName: TcxTextEdit [2]
    Left = 7
    Top = 66
    TabOrder = 1
    Width = 273
  end
  object cxLabel1: TcxLabel [3]
    Left = 7
    Top = 50
    Caption = #1060#1080#1089#1082#1072#1083#1100#1085#1099#1081' '#1085#1086#1084#1077#1088
  end
  object Код: TcxLabel [4]
    Left = 7
    Top = 4
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit [5]
    Left = 7
    Top = 22
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 0
    Width = 273
  end
  object cxLabel7: TcxLabel [6]
    Left = 8
    Top = 98
    Caption = #1058#1080#1087' '#1082#1072#1089#1089#1086#1074#1086#1075#1086' '#1072#1087#1087#1072#1088#1072#1090#1072
  end
  object ceInfoMoney: TcxButtonEdit [7]
    Left = 6
    Top = 118
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 273
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 115
    Top = 136
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 128
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    Left = 239
    Top = 143
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end>
    end
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end
        item
        end>
    end
  end
  inherited FormParams: TdsdFormParams
    Left = 208
    Top = 128
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_CashRegister'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Value = ''
        Component = edMeasureName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inCashRegisterKindId'
        Value = Null
        Component = CashRegisterKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 224
    Top = 48
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_CashRegister'
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
      end
      item
        Name = 'Name'
        Value = ''
        Component = edMeasureName
        DataType = ftString
      end
      item
        Name = 'CashRegisterKindId'
        Value = Null
        Component = CashRegisterKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'CashRegisterKindName'
        Value = Null
        Component = CashRegisterKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 184
    Top = 88
  end
  object CashRegisterKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormNameParam.Value = 'TCashRegisterKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TCashRegisterKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = CashRegisterKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CashRegisterKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 128
    Top = 96
  end
end
