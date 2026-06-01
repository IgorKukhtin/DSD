object RouteTTEditForm: TRouteTTEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1052#1072#1088#1096#1088#1091#1090#1099' '#1058#1058'>'
  ClientHeight = 373
  ClientWidth = 299
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 10
    Top = 72
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 10
    Top = 53
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 38
    Top = 339
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 182
    Top = 339
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object cxLabel2: TcxLabel
    Left = 10
    Top = 8
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 10
    Top = 30
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 10
    Top = 280
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit
    Left = 10
    Top = 299
    TabOrder = 7
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 10
    Top = 186
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
  end
  object cePosition: TcxButtonEdit
    Left = 10
    Top = 205
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 273
  end
  object cePersonalGroup: TcxButtonEdit
    Left = 10
    Top = 253
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 231
    Caption = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1080' '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' '
  end
  object cxLabel7: TcxLabel
    Left = 10
    Top = 99
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object ceUnit: TcxButtonEdit
    Left = 10
    Top = 117
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 273
  end
  object edPersonal: TcxButtonEdit
    Left = 10
    Top = 160
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 14
    Width = 273
  end
  object cxLabel6: TcxLabel
    Left = 10
    Top = 143
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
  end
  object ActionList: TActionList
    Left = 152
    Top = 56
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
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
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_RouteTT'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = edCode
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
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = Null
        Component = GuidesPersonal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = GuidesPosition
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalGroupId'
        Value = Null
        Component = GuidesPersonalGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 104
    Top = 66
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_RouteTT'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCode
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
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId'
        Value = Null
        Component = GuidesPersonal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName'
        Value = Null
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId'
        Value = Null
        Component = GuidesPosition
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName'
        Value = Null
        Component = GuidesPosition
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupId'
        Value = Null
        Component = GuidesPersonalGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupName'
        Value = Null
        Component = GuidesPersonalGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 184
    Top = 16
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
    Left = 232
    Top = 306
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 224
    Top = 56
  end
  object GuidesPosition: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPosition
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPosition
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 199
    Top = 168
  end
  object GuidesPersonalGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonalGroup
    FormNameParam.Value = 'TPersonalGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 159
    Top = 232
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 103
  end
  object GuidesPersonal: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal
    FormNameParam.Value = 'TPersonal_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId'
        Value = Null
        Component = GuidesPosition
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName'
        Value = Null
        Component = GuidesPosition
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupId'
        Value = Null
        Component = GuidesPersonalGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupName'
        Value = Null
        Component = GuidesPersonalGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 151
    Top = 136
  end
end
