object InfoMoneyEditForm: TInfoMoneyEditForm
  Left = 0
  Top = 0
  Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1072#1103' '#1089#1090#1072#1090#1100#1103
  ClientHeight = 263
  ClientWidth = 306
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = FormParams
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
    Width = 129
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
  object ceisProfitLoss: TcxCheckBox
    Left = 168
    Top = 26
    Caption = #1047#1072#1090#1088#1072#1090#1099' '#1087#1086' '#1086#1087#1083#1072#1090#1077
    TabOrder = 10
    Width = 121
  end
  object ActionList: TActionList
    Left = 232
    Top = 64
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
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
      RefreshOnTabSetChanges = False
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = #1054#1082
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_InfoMoney'
    DataSets = <>
    OutputType = otResult
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
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyGroupId'
        Value = ''
        Component = GuidesInfoMoneyGroup
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyDestinationId'
        Value = ''
        Component = GuidesInfoMoneyDestination
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisProfitLoss'
        Value = Null
        Component = ceisProfitLoss
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 88
    Top = 96
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 144
    Top = 208
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_InfoMoney'
    DataSets = <>
    OutputType = otResult
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
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyGroupId'
        Value = ''
        Component = GuidesInfoMoneyGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyGroupName'
        Value = ''
        Component = GuidesInfoMoneyGroup
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyDestinationId'
        Value = ''
        Component = GuidesInfoMoneyDestination
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyDestinationName'
        Value = ''
        Component = GuidesInfoMoneyDestination
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'isProfitLoss'
        Value = Null
        Component = ceisProfitLoss
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Top = 120
  end
  object GuidesInfoMoneyGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoneyGroup
    FormNameParam.Value = 'TInfoMoneyGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoneyGroupForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoneyGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoneyGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 117
  end
  object GuidesInfoMoneyDestination: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoneyDestination
    FormNameParam.Value = 'TInfoMoneyDestinationForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoneyDestinationForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoneyDestination
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoneyDestination
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 224
    Top = 181
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
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 88
    Top = 168
  end
end
