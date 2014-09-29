inherited ContractEditForm: TContractEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1080#1079#1084#1077#1085#1080#1090#1100' '#1044#1086#1075#1086#1074#1086#1088
  ClientHeight = 216
  ClientWidth = 353
  ExplicitWidth = 359
  ExplicitHeight = 241
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Top = 176
    ExplicitTop = 176
  end
  inherited bbCancel: TcxButton
    Top = 176
    ExplicitTop = 176
  end
  object cxLabel2: TcxLabel [2]
    Left = 8
    Top = 142
    Caption = #1050#1086#1076
    Visible = False
  end
  object edCode: TcxCurrencyEdit [3]
    Left = 8
    Top = 160
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 2
    Visible = False
    Width = 95
  end
  object cxLabel1: TcxLabel [4]
    Left = 8
    Top = 11
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object edName: TcxTextEdit [5]
    Left = 8
    Top = 32
    TabOrder = 3
    Width = 335
  end
  object cxLabel4: TcxLabel [6]
    Left = 8
    Top = 61
    Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088'. '#1083#1080#1094#1086
  end
  object ceJuridicalBasis: TcxButtonEdit [7]
    Left = 8
    Top = 81
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 4
    Width = 168
  end
  object cxLabel3: TcxLabel [8]
    Left = 111
    Top = 115
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edComment: TcxTextEdit [9]
    Left = 109
    Top = 133
    TabOrder = 7
    Width = 234
  end
  object cxLabel5: TcxLabel [10]
    Left = 178
    Top = 59
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object ceJuridical: TcxButtonEdit [11]
    Left = 178
    Top = 81
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 5
    Width = 165
  end
  object cxLabel6: TcxLabel [12]
    Left = 10
    Top = 115
    Caption = #1044#1085#1077#1081' '#1086#1090#1089#1088#1086#1095#1082#1080
  end
  object ceDeferment: TcxCurrencyEdit [13]
    Left = 10
    Top = 133
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 6
    Width = 95
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 315
    Top = 9
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 256
    Top = 45
  end
  inherited ActionList: TActionList
    Left = 159
    Top = 48
  end
  inherited FormParams: TdsdFormParams
    Left = 24
    Top = 165
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Contract'
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
        Value = 0.000000000000000000
        Component = edCode
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalBasisId'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inDeferment'
        Value = 0.000000000000000000
        Component = ceDeferment
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = ''
        Component = edComment
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 288
    Top = 145
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Contract'
    Params = <
      item
        Name = 'Id'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCode
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
      end
      item
        Name = 'JuridicalBasisId'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalBasisName'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'Comment'
        Value = ''
        Component = edComment
        DataType = ftString
      end
      item
        Name = 'Deferment'
        Value = 0.000000000000000000
        Component = ceDeferment
      end>
    Left = 192
    Top = 153
  end
  object JuridicalBasisGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridicalBasis
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 160
    Top = 108
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 160
    Top = 164
  end
end
