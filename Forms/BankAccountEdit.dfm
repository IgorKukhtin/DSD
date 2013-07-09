inherited BankAccountEditForm: TBankAccountEditForm
  Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
  ClientHeight = 307
  ClientWidth = 348
  ExplicitWidth = 356
  ExplicitHeight = 334
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 40
    Top = 71
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 48
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 72
    Top = 273
    Width = 75
    Height = 25
    Action = dsdExecStoredProc
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 216
    Top = 273
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 40
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 40
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 103
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object ceJuridical: TcxLookupComboBox
    Left = 40
    Top = 126
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = JuridicalDS
    TabOrder = 7
    Width = 273
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 159
    Caption = #1041#1072#1085#1082#1080
  end
  object ceBank: TcxLookupComboBox
    Left = 40
    Top = 182
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = BankDS
    TabOrder = 9
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 215
    Caption = #1042#1072#1083#1102#1090#1099
  end
  object ceCurrency: TcxLookupComboBox
    Left = 40
    Top = 238
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = CurrencyDS
    TabOrder = 11
    Width = 273
  end
  object ActionList: TActionList
    Left = 296
    Top = 72
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetJuridical
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
    end
    object dsdExecStoredProc: TdsdExecStoredProc
      Category = 'DSDLib'
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose1: TdsdFormClose
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Bank'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = dsdFormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end
      item
        Name = 'inCode'
        Component = ceCode
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inName'
        Component = edName
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inJuridicalId'
        Component = dsdJuridicalGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inBankId'
        Component = dsdBankGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inCurrencyId'
        Component = dsdCurrencyGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end>
    Left = 240
    Top = 48
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end>
    Left = 240
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_BankAccount'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Component = dsdFormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'Name'
        Component = edName
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'Code'
        Component = ceCode
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'JuridicalId'
        Component = dsdJuridicalGuides
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'JuridicalName'
        Component = dsdJuridicalGuides
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'BankId'
        Component = dsdBankGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'BankName'
        Component = dsdBankGuides
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'CurrencyId'
        Component = dsdCurrencyGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'CurrencyName'
        Component = dsdCurrencyGuides
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end>
    Left = 192
    Top = 88
  end
  object JuridicalDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 117
  end
  object spGetJuridical: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Juridical'
    DataSet = JuridicalDataSet
    DataSets = <
      item
        DataSet = JuridicalDataSet
      end>
    Params = <>
    Left = 216
    Top = 117
  end
  object JuridicalDS: TDataSource
    DataSet = JuridicalDataSet
    Left = 256
    Top = 117
  end
  object dsdJuridicalGuides: TdsdGuides
    Key = '0'
    LookupControl = ceJuridical
    PositionDataSet = 'ClientDataSet'
    Left = 312
    Top = 125
  end
  object BankDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 165
  end
  object spGetBank: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Bank'
    DataSet = BankDataSet
    DataSets = <
      item
        DataSet = BankDataSet
      end>
    Params = <>
    Left = 216
    Top = 165
  end
  object BankDS: TDataSource
    DataSet = BankDataSet
    Left = 256
    Top = 165
  end
  object dsdBankGuides: TdsdGuides
    Key = '0'
    LookupControl = ceBank
    PositionDataSet = 'ClientDataSet'
    Left = 312
    Top = 173
  end
  object CurrencyDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 221
  end
  object spGetCurrency: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Juridical'
    DataSet = CurrencyDataSet
    DataSets = <
      item
        DataSet = CurrencyDataSet
      end>
    Params = <>
    Left = 216
    Top = 221
  end
  object CurrencyDS: TDataSource
    DataSet = CurrencyDataSet
    Left = 256
    Top = 221
  end
  object dsdCurrencyGuides: TdsdGuides
    Key = '0'
    LookupControl = ceCurrency
    PositionDataSet = 'ClientDataSet'
    Left = 312
    Top = 229
  end
end
