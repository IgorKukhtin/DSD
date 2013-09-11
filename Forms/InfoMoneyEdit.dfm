inherited InfoMoneyEditForm: TInfoMoneyEditForm
  Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1072#1103' '#1089#1090#1072#1090#1100#1103
  ClientHeight = 269
  ClientWidth = 303
  ExplicitWidth = 311
  ExplicitHeight = 296
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 16
    Top = 71
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 16
    Top = 48
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 40
    Top = 224
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 3
  end
  object cxButton2: TcxButton
    Left = 198
    Top = 224
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
  end
  object Код: TcxLabel
    Left = 16
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 16
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 16
    Top = 103
    Caption = #1043#1088#1091#1087#1087#1099' '#1091#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1093' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1081
  end
  object cxLabel2: TcxLabel
    Left = 16
    Top = 159
    Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object ceInfoMoneyGroup: TcxButtonEdit
    Left = 16
    Top = 128
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 1
    Width = 273
  end
  object ceInfoMoneyDestination: TcxButtonEdit
    Left = 16
    Top = 182
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 2
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
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = #1054#1082
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_InfoMoney'
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
        Value = 0.000000000000000000
      end
      item
        Name = 'inName'
        Component = edName
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inInfoMoneyGroupId'
        Component = dsdInfoMoneyGroupGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inInfoMoneyDestinationId'
        Component = dsdInfoMoneyDestinationGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end>
    Left = 32
    Top = 120
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
    StoredProcName = 'gpGet_Object_InfoMoney'
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
        Value = 0.000000000000000000
      end
      item
        Name = 'InfoMoneyGroupId'
        Component = dsdInfoMoneyGroupGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'InfoMoneyGroupName'
        Component = dsdInfoMoneyGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'InfoMoneyDestinationId'
        Component = dsdInfoMoneyDestinationGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'InfoMoneyDestinationName'
        Component = dsdInfoMoneyDestinationGuides
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end>
    Top = 120
  end
  object dsdInfoMoneyGroupGuides: TdsdGuides
    LookupControl = ceInfoMoneyGroup
    FormName = 'TInfoMoneyGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 328
    Top = 125
  end
  object dsdInfoMoneyDestinationGuides: TdsdGuides
    LookupControl = ceInfoMoneyDestination
    FormName = 'TInfoMoneyDestinationForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
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
