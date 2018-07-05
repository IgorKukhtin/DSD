object MemberPersonalServiceListEditForm: TMemberPersonalServiceListEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1089#1090#1091#1087' '#1082' '#1055#1088#1086#1089#1084#1086#1090#1088#1091' '#1042#1077#1076#1086#1084#1086#1089#1090#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'>'
  ClientHeight = 265
  ClientWidth = 344
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
  object edComment: TcxTextEdit
    Left = 21
    Top = 173
    TabOrder = 0
    Width = 284
  end
  object cxLabel1: TcxLabel
    Left = 21
    Top = 156
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 48
    Top = 226
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 208
    Top = 226
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object cxLabel3: TcxLabel
    Left = 21
    Top = 50
    Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
  end
  object edPersonalServiceList: TcxButtonEdit
    Left = 21
    Top = 72
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 284
  end
  object cxLabel4: TcxLabel
    Left = 21
    Top = 97
    Caption = #1060#1080#1079'.'#1083#1080#1094#1086
  end
  object edMember: TcxButtonEdit
    Left = 21
    Top = 119
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 284
  end
  object cbAll: TcxCheckBox
    Left = 22
    Top = 14
    Hint = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
    AutoSize = False
    Caption = #1076#1086#1089#1090#1091#1087' '#1082#1086' '#1074#1089#1077#1084' '#1074#1077#1076#1086#1084#1086#1089#1090#1103#1084' ('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 8
    Height = 21
    Width = 211
  end
  object ActionList: TActionList
    Left = 256
    Top = 67
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
    StoredProcName = 'gpInsertUpdate_Object_MemberPersonalServiceList'
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
        Name = 'inPersonalServiceListId'
        Value = Null
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = Null
        Component = GuidesMember
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioIsAll'
        Value = Null
        Component = cbAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 293
    Top = 104
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 312
    Top = 59
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_MemberPersonalServiceList'
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
        Name = 'PersonalServiceListId'
        Value = Null
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalServiceListName'
        Value = Null
        Component = GuidesPersonalServiceList
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId'
        Value = Null
        Component = GuidesMember
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = Null
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAll'
        Value = Null
        Component = cbAll
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 224
    Top = 141
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
      end
      item
        Properties.Strings = (
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 296
    Top = 176
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 288
    Top = 3
  end
  object GuidesPersonalServiceList: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalServiceList
    FormNameParam.Value = 'TPersonalServiceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalServiceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalServiceList
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 48
  end
  object GuidesMember: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 104
  end
end
