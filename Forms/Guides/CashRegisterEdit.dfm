inherited CashRegisterEditForm: TCashRegisterEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1072#1089#1089#1086#1074#1099#1081' '#1072#1087#1087#1072#1088#1072#1090'>'
  ClientHeight = 310
  ClientWidth = 303
  ExplicitWidth = 309
  ExplicitHeight = 339
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 33
    Top = 265
    TabOrder = 2
    ExplicitLeft = 33
    ExplicitTop = 265
  end
  inherited bbCancel: TcxButton
    Left = 166
    Top = 265
    TabOrder = 3
    ExplicitLeft = 166
    ExplicitTop = 265
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
    Top = 127
    Caption = #1058#1080#1087' '#1082#1072#1089#1089#1086#1074#1086#1075#1086' '#1072#1087#1087#1072#1088#1072#1090#1072
  end
  object ceInfoMoney: TcxButtonEdit [7]
    Left = 6
    Top = 147
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 273
  end
  object edTimePUSHFinal2: TcxDateEdit [8]
    Left = 151
    Top = 199
    EditValue = 43234d
    Properties.ArrowsForYear = False
    Properties.AssignedValues.EditFormat = True
    Properties.DateButtons = [btnNow]
    Properties.DisplayFormat = 'HH:MM'
    Properties.Kind = ckDateTime
    TabOrder = 8
    Width = 100
  end
  object cxLabel21: TcxLabel [9]
    Left = 151
    Top = 176
    Caption = #1042#1077#1095#1077#1088#1085#1077#1077' PUSH 2'
  end
  object edTimePUSHFinal1: TcxDateEdit [10]
    Left = 8
    Top = 199
    EditValue = 43225d
    Properties.ArrowsForYear = False
    Properties.AssignedValues.EditFormat = True
    Properties.DateButtons = [btnNow]
    Properties.DateOnError = deNull
    Properties.DisplayFormat = 'HH:MM'
    Properties.Kind = ckDateTime
    Properties.Nullstring = ' '
    Properties.YearsInMonthList = False
    TabOrder = 10
    Width = 100
  end
  object cxLabel20: TcxLabel [11]
    Left = 8
    Top = 176
    Caption = #1042#1077#1095#1077#1088#1085#1077#1077' PUSH 1'
  end
  object edSerialNumber: TcxTextEdit [12]
    Left = 8
    Top = 106
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 273
  end
  object cxLabel2: TcxLabel [13]
    Left = 8
    Top = 90
    Caption = #1057#1077#1088#1080#1081#1085#1099#1081' '#1085#1086#1084#1077#1088
  end
  object cbGetHardwareData: TcxCheckBox [14]
    Left = 8
    Top = 230
    Hint = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
    Caption = #1055#1086#1083#1091#1095#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1085#1086#1081' '#1095#1072#1089#1090#1080
    ParentShowHint = False
    ShowHint = True
    TabOrder = 14
    Width = 233
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 115
    Top = 136
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 112
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
        Name = 'inName'
        Value = ''
        Component = edMeasureName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashRegisterKindId'
        Value = Null
        Component = CashRegisterKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTimePUSHFinal1'
        Value = 'NULL'
        Component = edTimePUSHFinal1
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTimePUSHFinal2'
        Value = 'NULL'
        Component = edTimePUSHFinal2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGetHardwareData'
        Value = Null
        Component = cbGetHardwareData
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
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
        Component = edMeasureName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashRegisterKindId'
        Value = Null
        Component = CashRegisterKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashRegisterKindName'
        Value = Null
        Component = CashRegisterKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SerialNumber'
        Value = Null
        Component = edSerialNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TimePUSHFinal1'
        Value = 'NULL'
        Component = edTimePUSHFinal1
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'TimePUSHFinal2'
        Value = 'NULL'
        Component = edTimePUSHFinal2
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'GetHardwareData'
        Value = Null
        Component = cbGetHardwareData
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 184
    Top = 88
  end
  object CashRegisterKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormNameParam.Value = 'TCashRegisterKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CashRegisterKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 96
  end
end
