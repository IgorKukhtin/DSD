inherited JuridicalEditForm: TJuridicalEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1080#1079#1084#1077#1085#1080#1090#1100' '#1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  ClientHeight = 228
  ClientWidth = 359
  ExplicitWidth = 365
  ExplicitHeight = 260
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 82
    Top = 184
    ExplicitLeft = 82
    ExplicitTop = 184
  end
  inherited bbCancel: TcxButton
    Left = 226
    Top = 184
    ExplicitLeft = 226
    ExplicitTop = 184
  end
  object cxLabel2: TcxLabel [2]
    Left = 10
    Top = 8
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit [3]
    Left = 10
    Top = 26
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 3
    Width = 139
  end
  object cxLabel1: TcxLabel [4]
    Left = 10
    Top = 51
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object edName: TcxTextEdit [5]
    Left = 10
    Top = 72
    TabOrder = 5
    Width = 335
  end
  object cxLabel4: TcxLabel [6]
    Left = 10
    Top = 101
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
  end
  object ceRetail: TcxButtonEdit [7]
    Left = 12
    Top = 121
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 333
  end
  object cbisCorporate: TcxCheckBox [8]
    Left = 234
    Top = 26
    Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088'.'#1083'.'
    TabOrder = 8
    Width = 111
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 51
    Top = 176
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 24
    Top = 176
  end
  inherited ActionList: TActionList
    Left = 79
    Top = 175
  end
  inherited FormParams: TdsdFormParams
    Left = 24
    Top = 144
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Juridical'
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
        Name = 'inRetailId'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inisCorporate'
        Value = 'False'
        Component = cbisCorporate
        DataType = ftBoolean
        ParamType = ptInput
      end>
    Left = 296
    Top = 144
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Juridical'
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
        Name = 'RetailId'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'RetailName'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'isCorporate'
        Value = 'False'
        Component = cbisCorporate
      end>
    Left = 208
    Top = 152
  end
  object RetailGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceRetail
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 160
    Top = 108
  end
end
