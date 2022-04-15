object UserByGroupListEditForm: TUserByGroupListEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1042#1080#1076#1099' '#1091#1087#1072#1082#1086#1074#1082#1080' '#1076#1083#1103' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1103'>'
  ClientHeight = 198
  ClientWidth = 352
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
  object cxButton1: TcxButton
    Left = 54
    Top = 154
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 182
    Top = 154
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 1
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 12
    Caption = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103#9
  end
  object edUser: TcxButtonEdit
    Left = 40
    Top = 97
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 273
  end
  object edUserByGroup: TcxButtonEdit
    Left = 40
    Top = 35
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 40
    Top = 74
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
  end
  object ActionList: TActionList
    Left = 304
    Top = 80
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
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
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_UserByGroupList'
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
        Name = 'inUserId'
        Value = ''
        Component = GuidesUser
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserByGroupId'
        Value = ''
        Component = GuidesUserByGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 232
    Top = 48
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 240
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_UserByGroupList'
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
        Name = 'UserByGroupId'
        Value = ''
        Component = GuidesUserByGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserByGroupName'
        Value = ''
        Component = GuidesUserByGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserId'
        Value = ''
        Component = GuidesUser
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = ''
        Component = GuidesUser
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 16
    Top = 130
  end
  object GuidesUserByGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUserByGroup
    FormNameParam.Value = 'TUserByGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserByGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUserByGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUserByGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 34
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
    Left = 270
    Top = 146
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 16
    Top = 8
  end
  object GuidesUser: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUser
    FormNameParam.Value = 'TUser_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUser_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUser
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUser
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 90
  end
end
