inherited InfoMoneyEditForm: TInfoMoneyEditForm
  Caption = #1053#1086#1074#1072#1103' '#1089#1090#1072#1090#1100#1103
  ClientHeight = 298
  ClientWidth = 362
  ExplicitWidth = 378
  ExplicitHeight = 336
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
    Left = 64
    Top = 249
    Width = 75
    Height = 25
    Action = dsdExecStoredProc
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 222
    Top = 249
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
    Caption = #1043#1088#1091#1087#1087#1099' '#1091#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1093' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1081
  end
  object ceInfoMoneyGroup: TcxLookupComboBox
    Left = 40
    Top = 126
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = InfoMoneyGroupDS
    TabOrder = 7
    Width = 273
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 159
    Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object ceInfoMoneyDestination: TcxLookupComboBox
    Left = 40
    Top = 182
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = InfoMoney_DestinationDS
    TabOrder = 9
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
          StoredProc = spGetInfoMoneyGroup
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
        Component = dsdInfoMoneyGroupGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inPaidKindId'
        Component = dsdInfoMoney_DestinationGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inCurrencyId'
        DataType = ftInteger
        ParamType = ptInput
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
        Component = dsdInfoMoneyGroupGuides
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'BranchName'
        Component = dsdInfoMoneyGroupGuides
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'PaidKindId'
        Component = dsdInfoMoney_DestinationGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'PaidKindName'
        Component = dsdInfoMoney_DestinationGuides
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
      end
      item
        Name = 'CurrencyName'
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
      end>
    Left = 192
    Top = 88
  end
  object InfoMoneyGroupDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 117
  end
  object spGetInfoMoneyGroup: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_InfoMoneyGroup'
    DataSet = InfoMoneyGroupDataSet
    DataSets = <
      item
        DataSet = InfoMoneyGroupDataSet
      end>
    Params = <>
    Left = 216
    Top = 117
  end
  object InfoMoneyGroupDS: TDataSource
    DataSet = InfoMoneyGroupDataSet
    Left = 248
    Top = 117
  end
  object dsdInfoMoneyGroupGuides: TdsdGuides
    Key = '0'
    LookupControl = ceInfoMoneyGroup
    FormName = 'TInfoMoneyGroupForm'
    PositionDataSet = 'ClientDataSet'
    Left = 328
    Top = 125
  end
  object InfoMoney_DestinationDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 165
  end
  object spGetInfoMoney_Destination: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_InfoMoney_Destination'
    DataSet = InfoMoney_DestinationDataSet
    DataSets = <
      item
        DataSet = InfoMoney_DestinationDataSet
      end>
    Params = <>
    Left = 216
    Top = 165
  end
  object InfoMoney_DestinationDS: TDataSource
    DataSet = InfoMoney_DestinationDataSet
    Left = 256
    Top = 165
  end
  object dsdInfoMoney_DestinationGuides: TdsdGuides
    Key = '0'
    LookupControl = ceInfoMoneyDestination
    FormName = 'TInfoMoney_DestinationForm'
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
    Left = 96
    Top = 184
  end
end
