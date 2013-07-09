inherited AccountEditForm: TAccountEditForm
  Caption = #1053#1086#1074#1099#1081' '#1089#1095#1077#1090
  ClientHeight = 396
  ClientWidth = 507
  ExplicitWidth = 515
  ExplicitHeight = 423
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 40
    Top = 76
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 48
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 32
    Top = 353
    Width = 75
    Height = 25
    Action = dsdExecStoredProc
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 238
    Top = 353
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
    Caption = #1043#1088#1091#1087#1087#1099' '#1089#1095#1077#1090#1086#1074
  end
  object ceAccountGroup: TcxLookupComboBox
    Left = 40
    Top = 126
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = AccountGroupDS
    TabOrder = 7
    Width = 273
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 159
    Caption = #1040#1085#1072#1083#1080#1090#1080#1082#1080' '#1089#1095#1077#1090#1086#1074' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103' '
  end
  object ceAccountDirection: TcxLookupComboBox
    Left = 40
    Top = 182
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    TabOrder = 9
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 231
    Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object ceInfoMoneyDestination: TcxLookupComboBox
    Left = 40
    Top = 246
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = InfoMoneyDestinationDS
    TabOrder = 11
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 40
    Top = 287
    Caption = #1057#1090#1072#1090#1100#1080' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object ceInfoMoney: TcxLookupComboBox
    Left = 40
    Top = 302
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = InfoMoneyDS
    TabOrder = 13
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
          StoredProc = spGetAccountGroup
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
        Name = 'inBranchId'
        Component = dsdAccountGroup
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inPaidKindId'
        Component = dsdAccountDirectionnGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inCurrencyId'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
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
        Name = 'BranchId'
        Component = dsdAccountGroup
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'BranchName'
        Component = dsdAccountGroup
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'PaidKindId'
        Component = dsdAccountDirectionnGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'PaidKindName'
        Component = dsdAccountDirectionnGuides
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'CurrencyId'
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = Null
      end
      item
        Name = 'CurrencyName'
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = Null
      end>
    Left = 192
    Top = 88
  end
  object AccountGroupDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 117
  end
  object spGetAccountGroup: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_AccountGroup'
    DataSet = AccountGroupDataSet
    DataSets = <
      item
        DataSet = AccountGroupDataSet
      end>
    Params = <>
    Left = 216
    Top = 117
  end
  object AccountGroupDS: TDataSource
    DataSet = AccountGroupDataSet
    Left = 248
    Top = 117
  end
  object dsdAccountGroup: TdsdGuides
    Key = '0'
    LookupControl = ceAccountGroup
    FormName = 'TInfoMoneyGroupForm'
    PositionDataSet = 'ClientDataSet'
    Left = 328
    Top = 125
  end
  object AccountDirectionDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 160
    Top = 165
  end
  object spGetAccountDirection: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_AccountDirection'
    DataSet = AccountDirectionDataSet
    DataSets = <
      item
        DataSet = AccountDirectionDataSet
      end>
    Params = <>
    Left = 216
    Top = 165
  end
  object AccountDirectionDS: TDataSource
    DataSet = AccountDirectionDataSet
    Left = 256
    Top = 165
  end
  object dsdAccountDirectionnGuides: TdsdGuides
    Key = '0'
    LookupControl = ceAccountDirection
    FormName = 'TAccountDirectionForm'
    PositionDataSet = 'ClientDataSet'
    Left = 328
    Top = 173
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 136
    Top = 40
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 416
    Top = 288
  end
  object InfoMoneyDestinationDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 229
  end
  object spGetInfoMoneyDestination: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_InfoMoneyDestination'
    DataSet = InfoMoneyDestinationDataSet
    DataSets = <
      item
        DataSet = InfoMoneyDestinationDataSet
      end>
    Params = <>
    Left = 216
    Top = 229
  end
  object InfoMoneyDestinationDS: TDataSource
    DataSet = InfoMoneyDestinationDataSet
    Left = 272
    Top = 221
  end
  object dsdInfoMoneyDestinationGuides: TdsdGuides
    Key = '0'
    LookupControl = ceInfoMoneyDestination
    FormName = 'TInfoMoneyDestinationForm'
    PositionDataSet = 'ClientDataSet'
    Left = 368
    Top = 237
  end
  object InfoMoneyDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 168
    Top = 285
  end
  object spGetInfoMoney: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_InfoMoney'
    DataSet = InfoMoneyDataSet
    DataSets = <
      item
        DataSet = InfoMoneyDataSet
      end>
    Params = <>
    Left = 208
    Top = 285
  end
  object InfoMoneyDS: TDataSource
    DataSet = InfoMoneyDataSet
    Left = 248
    Top = 285
  end
  object dsdInfoMoney: TdsdGuides
    Key = '0'
    LookupControl = ceInfoMoney
    FormName = 'TInfoMoneyForm'
    PositionDataSet = 'ClientDataSet'
    Left = 320
    Top = 293
  end
end
