inherited CashEditForm: TCashEditForm
  Caption = #1050#1072#1089#1089#1072
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
    Caption = #1060#1080#1083#1080#1072#1083
  end
  object ceBranch: TcxLookupComboBox
    Left = 40
    Top = 126
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = BranchDS
    TabOrder = 7
    Width = 273
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 159
    Caption = #1042#1080#1076' '#1086#1087#1083#1072#1090#1099
  end
  object cePaidKind: TcxLookupComboBox
    Left = 40
    Top = 182
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = PaidKindDS
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
          StoredProc = spGetBranch
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
    StoredProcName = 'gpInsertUpdate_Object_Cash'
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
      end
      item
        Name = 'inName'
        Component = edName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inBranchId'
        Component = dsdBranchGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inPaidKindId'
        Component = dsdPaidKindGuides
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
    StoredProcName = 'gpGet_Object_Cash'
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
      end
      item
        Name = 'Code'
        Component = ceCode
        DataType = ftInteger
        ParamType = ptOutput
      end
      item
        Name = 'BranchId'
        Component = dsdBranchGuides
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'BranchName'
        Component = dsdBranchGuides
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'PaidKindId'
        Component = dsdPaidKindGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'PaidKindName'
        Component = dsdPaidKindGuides
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
  object BranchDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 117
  end
  object spGetBranch: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Branch'
    DataSet = BranchDataSet
    DataSets = <
      item
        DataSet = BranchDataSet
      end>
    Params = <>
    Left = 216
    Top = 117
  end
  object BranchDS: TDataSource
    DataSet = BranchDataSet
    Left = 256
    Top = 117
  end
  object dsdBranchGuides: TdsdGuides
    LookupControl = ceBranch
    Left = 312
    Top = 125
  end
  object PaidKindDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 165
  end
  object spGetPaidKind: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_PaidKind'
    DataSet = PaidKindDataSet
    DataSets = <
      item
        DataSet = PaidKindDataSet
      end>
    Params = <>
    Left = 216
    Top = 165
  end
  object PaidKindDS: TDataSource
    DataSet = PaidKindDataSet
    Left = 256
    Top = 165
  end
  object dsdPaidKindGuides: TdsdGuides
    LookupControl = cePaidKind
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
    StoredProcName = 'gpSelect_Object_Branch'
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
    LookupControl = ceCurrency
    Left = 312
    Top = 229
  end
end
