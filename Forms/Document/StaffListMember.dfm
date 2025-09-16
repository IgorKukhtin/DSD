inherited StaffListMemberForm: TStaffListMemberForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1080#1082#1072#1079' '#1087#1086' '#1086#1090#1087#1091#1089#1082#1072#1084'>'
  ClientHeight = 352
  ClientWidth = 716
  AddOnFormData.isSingle = False
  ExplicitWidth = 722
  ExplicitHeight = 381
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 409
    Top = 314
    Height = 26
    ExplicitLeft = 409
    ExplicitTop = 314
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 548
    Top = 314
    Height = 26
    ExplicitLeft = 548
    ExplicitTop = 314
    ExplicitHeight = 26
  end
  object cxLabel1: TcxLabel [2]
    Left = 94
    Top = 7
    Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object lbInvNumber: TcxLabel [3]
    Left = 8
    Top = 7
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object edOperDate: TcxDateEdit [4]
    Left = 94
    Top = 27
    EditValue = 42092d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 88
  end
  object cxLabel6: TcxLabel [5]
    Left = 369
    Top = 7
    Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
  end
  object edInvNumber: TcxTextEdit [6]
    Left = 8
    Top = 27
    Properties.ReadOnly = True
    TabOrder = 6
    Text = '0'
    Width = 75
  end
  object edUpdateDate: TcxDateEdit [7]
    Left = 368
    Top = 70
    EditValue = 42092d
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 7
    Width = 130
  end
  object cxLabel2: TcxLabel [8]
    Left = 368
    Top = 52
    Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
  end
  object cxLabel9: TcxLabel [9]
    Left = 508
    Top = 7
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
  end
  object edInsert: TcxButtonEdit [10]
    Left = 508
    Top = 27
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 191
  end
  object cxLabel8: TcxLabel [11]
    Left = 508
    Top = 52
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
  end
  object edUpdate: TcxButtonEdit [12]
    Left = 508
    Top = 70
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 191
  end
  object cxLabel11: TcxLabel [13]
    Left = 8
    Top = 85
    Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
  end
  object edMember: TcxButtonEdit [14]
    Left = 8
    Top = 102
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 14
    Width = 331
  end
  object edInsertDate: TcxDateEdit [15]
    Left = 368
    Top = 27
    EditValue = 42092d
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 15
    Width = 130
  end
  object cxLabel10: TcxLabel [16]
    Left = 8
    Top = 298
    Caption = #1055#1088#1080#1095#1080#1085#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
  end
  object edReasonOut: TcxButtonEdit [17]
    Left = 8
    Top = 316
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 331
  end
  object cbMain: TcxCheckBox [18]
    Left = 8
    Top = 60
    Hint = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
    Caption = #1054#1089#1085#1086#1074#1085#1086#1077' '#1084#1077#1089#1090#1086' '#1088#1072#1073#1086#1090#1099
    TabOrder = 18
    Width = 146
  end
  object cbOfficial: TcxCheckBox [19]
    Left = 184
    Top = 60
    Hint = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
    Caption = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
    TabOrder = 19
    Width = 146
  end
  object cxLabel7: TcxLabel [20]
    Left = 8
    Top = 128
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object ceUnit: TcxButtonEdit [21]
    Left = 8
    Top = 144
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 331
  end
  object cxLabel5: TcxLabel [22]
    Left = 8
    Top = 169
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
  end
  object cePosition: TcxButtonEdit [23]
    Left = 8
    Top = 184
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 331
  end
  object cxLabel4: TcxLabel [24]
    Left = 8
    Top = 211
    Caption = #1056#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
  end
  object cePositionLevel: TcxButtonEdit [25]
    Left = 8
    Top = 228
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 25
    Width = 331
  end
  object cePositionLevel_old: TcxButtonEdit [26]
    Left = 368
    Top = 228
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 26
    Width = 331
  end
  object cxLabel3: TcxLabel [27]
    Left = 368
    Top = 211
    Caption = #1056#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080' ('#1076#1086' '#1087#1077#1088#1077#1074#1086#1076#1072')'
  end
  object cePosition_old: TcxButtonEdit [28]
    Left = 368
    Top = 184
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 28
    Width = 331
  end
  object cxLabel12: TcxLabel [29]
    Left = 368
    Top = 169
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1076#1086' '#1087#1077#1088#1077#1074#1086#1076#1072')'
  end
  object ceUnit_old: TcxButtonEdit [30]
    Left = 369
    Top = 144
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 30
    Width = 331
  end
  object cxLabel13: TcxLabel [31]
    Left = 369
    Top = 128
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1076#1086' '#1087#1077#1088#1077#1074#1086#1076#1072')'
  end
  object edStaffListKind: TcxButtonEdit [32]
    Left = 8
    Top = 273
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 32
    Width = 331
  end
  object cxLabel14: TcxLabel [33]
    Left = 8
    Top = 254
    Caption = #1042#1080#1076' '#1086#1092#1086#1088#1084#1083#1077#1085#1080#1103' '#1074' '#1096#1090#1072#1090
  end
  object cxLabel15: TcxLabel [34]
    Left = 368
    Top = 254
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [35]
    Left = 368
    Top = 273
    TabOrder = 35
    Width = 331
  end
  object cxButton1: TcxButton [36]
    Left = 547
    Top = 101
    Width = 152
    Height = 26
    Action = actOpenChoiceFormMember
    Default = True
    ModalResult = 1
    TabOrder = 36
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 299
    Top = 65534
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 232
    Top = 1
  end
  inherited ActionList: TActionList
    Left = 511
    Top = 262
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides [0]
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1076#1083#1103' '#1087#1077#1088#1077#1074#1086#1076#1072
    end
    inherited actRefresh: TdsdDataSetRefresh [1]
    end
    inherited FormClose: TdsdFormClose [2]
    end
    object actOpenChoiceFormMember: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1042#1067#1073#1088#1072#1090#1100' '#1076#1083#1103' '#1087#1077#1088#1077#1074#1086#1076#1072
      FormName = 'TMember_ChoiceForm'
      FormNameParam.Value = 'TMember_ChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = Null
          Component = GuidesUnit_old
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit_old
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionId'
          Value = Null
          Component = GuidesPosition_old
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionName'
          Value = Null
          Component = GuidesPosition_old
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionLevelId'
          Value = Null
          Component = GuidesPositionLevel_old
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionLevelName'
          Value = Null
          Component = GuidesPositionLevel_old
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalId'
          Value = Null
          Component = FormParams
          ComponentItem = 'PersonalId_send'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          Component = GuideMember
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = GuideMember
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 580
    Top = 262
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_StaffListMember'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = ''
        Component = GuideMember
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
        Name = 'inPositionLevelId'
        Value = Null
        Component = GuidesPositionLevel
        ComponentItem = 'Key'
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
        Name = 'inPositionId_old'
        Value = Null
        Component = GuidesPosition_old
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionLevelId_old'
        Value = ''
        Component = GuidesPositionLevel_old
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId_old'
        Value = Null
        Component = GuidesUnit_old
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReasonOutId'
        Value = Null
        Component = GuidesReasonOut
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStaffListKindId'
        Value = Null
        Component = GuidesStaffListKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOfficial'
        Value = Null
        Component = cbOfficial
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMain'
        Value = Null
        Component = cbMain
        DataType = ftBoolean
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
    Left = 672
    Top = 290
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_StaffListMember'
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId'
        Value = 0.000000000000000000
        Component = GuideMember
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = ''
        Component = GuideMember
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId'
        Value = ''
        Component = GuidesPosition
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName'
        Value = ''
        Component = GuidesPosition
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionLevelId'
        Value = Null
        Component = GuidesPositionLevel
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionLevelName'
        Value = 0d
        Component = GuidesPositionLevel
        ComponentItem = 'TextValue'
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
        Name = 'PositionId_old'
        Value = Null
        Component = GuidesPosition_old
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName_old'
        Value = Null
        Component = GuidesPosition_old
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionLevelId_old'
        Value = Null
        Component = GuidesPositionLevel_old
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionLevelName_old'
        Value = Null
        Component = GuidesPositionLevel_old
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId_old'
        Value = Null
        Component = GuidesUnit_old
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName_old'
        Value = Null
        Component = GuidesUnit_old
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReasonOutId'
        Value = Null
        Component = GuidesReasonOut
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReasonOutName'
        Value = Null
        Component = GuidesReasonOut
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StaffListKindId'
        Value = Null
        Component = GuidesStaffListKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StaffListKindName'
        Value = Null
        Component = GuidesStaffListKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMain'
        Value = Null
        Component = cbMain
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOfficial'
        Value = Null
        Component = cbOfficial
        DataType = ftBoolean
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
        Name = 'InsertId'
        Value = ''
        Component = GuideInsert
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertName'
        Value = ''
        Component = GuideInsert
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateId'
        Value = ''
        Component = GuideUpdate
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateName'
        Value = ''
        Component = GuideUpdate
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertDate'
        Value = Null
        Component = edInsertDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateDate'
        Value = Null
        Component = edUpdateDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 640
    Top = 289
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
      end
      item
        Guides = GuideInsert
      end
      item
      end
      item
      end>
    ActionItemList = <>
    Left = 104
    Top = 240
  end
  object GuideInsert: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInsert
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideInsert
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideInsert
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarModelId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarModelName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 161
    Top = 248
  end
  object GuideMember: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember
    FormNameParam.Value = 'TMember_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideMember
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideMember
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMain'
        Value = Null
        Component = cbMain
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOfficial'
        Value = Null
        Component = cbOfficial
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId'
        Value = Null
        Component = GuidesPosition
        ComponentItem = 'Key'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName'
        Value = Null
        Component = GuidesPosition
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionLevelId'
        Value = Null
        Component = GuidesPositionLevel
        ComponentItem = 'Key'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionLevelName'
        Value = Null
        Component = GuidesPositionLevel
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 150
    Top = 86
  end
  object GuideUpdate: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUpdate
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarModelName'
        Value = Null
        Component = GuideUpdate
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 48
    Top = 248
  end
  object GuidesReasonOut: TdsdGuides
    KeyField = 'Id'
    LookupControl = edReasonOut
    FormNameParam.Value = 'TReasonOutForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TReasonOutForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesReasonOut
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesReasonOut
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 166
    Top = 288
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'UnitId'
    LookupControl = ceUnit
    FormNameParam.Value = 'TStaffListItemChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStaffListItemChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
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
        Name = 'PositionLevelId'
        Value = Null
        Component = GuidesPositionLevel
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionLevelName'
        Value = Null
        Component = GuidesPositionLevel
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 135
  end
  object GuidesPosition: TdsdGuides
    KeyField = 'PositionId'
    LookupControl = cePosition
    FormNameParam.Value = 'TStaffListItemChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStaffListItemChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
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
        Name = 'PositionLevelId'
        Value = Null
        Component = GuidesPositionLevel
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionLevelName'
        Value = Null
        Component = GuidesPositionLevel
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 135
    Top = 176
  end
  object GuidesPositionLevel: TdsdGuides
    KeyField = 'PositionLevelId'
    LookupControl = cePositionLevel
    FormNameParam.Value = 'TStaffListItemChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStaffListItemChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
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
        Name = 'PositionLevelId'
        Value = Null
        Component = GuidesPositionLevel
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionLevelName'
        Value = Null
        Component = GuidesPositionLevel
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 223
    Top = 209
  end
  object GuidesPositionLevel_old: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePositionLevel_old
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPositionLevelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionLevelForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPositionLevel_old
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPositionLevel_old
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 575
    Top = 202
  end
  object GuidesPosition_old: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition_old
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPosition_old
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPosition_old
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 487
    Top = 169
  end
  object GuidesUnit_old: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit_old
    DisableGuidesOpen = True
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit_old
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit_old
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 552
    Top = 128
  end
  object GuidesStaffListKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edStaffListKind
    FormNameParam.Value = 'TStaffListKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStaffListKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesStaffListKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesStaffListKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 174
    Top = 246
  end
end
