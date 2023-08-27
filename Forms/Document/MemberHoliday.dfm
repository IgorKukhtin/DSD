inherited MemberHolidayForm: TMemberHolidayForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1080#1082#1072#1079' '#1087#1086' '#1086#1090#1087#1091#1089#1082#1072#1084'>'
  ClientHeight = 449
  ClientWidth = 366
  AddOnFormData.isSingle = False
  ExplicitWidth = 372
  ExplicitHeight = 478
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 61
    Top = 409
    Height = 26
    ExplicitLeft = 61
    ExplicitTop = 409
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 202
    Top = 409
    Height = 26
    ExplicitLeft = 202
    ExplicitTop = 409
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
    Left = 8
    Top = 305
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
    Left = 8
    Top = 372
    EditValue = 42092d
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 7
    Width = 130
  end
  object cxLabel2: TcxLabel [8]
    Left = 8
    Top = 352
    Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
  end
  object cxLabel9: TcxLabel [9]
    Left = 148
    Top = 304
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
  end
  object edInsert: TcxButtonEdit [10]
    Left = 148
    Top = 325
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
    Left = 148
    Top = 352
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
  end
  object edUpdate: TcxButtonEdit [12]
    Left = 148
    Top = 372
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
    Top = 58
    Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
  end
  object edMember: TcxButtonEdit [14]
    Left = 8
    Top = 78
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 14
    Width = 331
  end
  object edMemberMain: TcxButtonEdit [15]
    Left = 8
    Top = 126
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 331
  end
  object cxLabel15: TcxLabel [16]
    Left = 8
    Top = 106
    Caption = #1060#1048#1054' '#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1103
  end
  object edInsertDate: TcxDateEdit [17]
    Left = 8
    Top = 325
    EditValue = 42092d
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 17
    Width = 130
  end
  object cxLabel3: TcxLabel [18]
    Left = 33
    Top = 162
    Caption = #1053#1072#1095'. '#1076#1072#1090#1072' '#1088#1072#1073'. '#1087#1077#1088#1080#1086#1076#1072
  end
  object edOperDateStart: TcxDateEdit [19]
    Left = 33
    Top = 182
    EditValue = 42092d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 19
    Width = 130
  end
  object cxLabel4: TcxLabel [20]
    Left = 178
    Top = 162
    Caption = #1050#1086#1085'. '#1076#1072#1090#1072' '#1088#1072#1073'. '#1087#1077#1088#1080#1086#1076#1072
  end
  object edOperDateEnd: TcxDateEdit [21]
    Left = 178
    Top = 182
    EditValue = 42092d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 21
    Width = 130
  end
  object cxLabel5: TcxLabel [22]
    Left = 35
    Top = 210
    Caption = #1053#1072#1095'. '#1076#1072#1090#1072' '#1086#1090#1087#1091#1089#1082#1072
  end
  object edBeginDateStart: TcxDateEdit [23]
    Left = 35
    Top = 230
    EditValue = 42092d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 23
    Width = 130
  end
  object cxLabel7: TcxLabel [24]
    Left = 178
    Top = 210
    Caption = #1050#1086#1085'. '#1076#1072#1090#1072' '#1086#1090#1087#1091#1089#1082#1072
  end
  object edBeginDateEnd: TcxDateEdit [25]
    Left = 178
    Top = 230
    EditValue = 42092d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 25
    Width = 130
  end
  object cxLabel10: TcxLabel [26]
    Left = 8
    Top = 259
    Caption = #1058#1080#1087' '#1086#1090#1087#1091#1089#1082#1072
  end
  object edWorkTimeKind: TcxButtonEdit [27]
    Left = 8
    Top = 279
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 27
    Width = 331
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 75
    Top = 69
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 232
    Top = 25
  end
  inherited ActionList: TActionList
    Left = 271
    Top = 141
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides [0]
    end
    inherited actRefresh: TdsdDataSetRefresh [1]
    end
    inherited FormClose: TdsdFormClose [2]
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
    Left = 44
    Top = 100
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_MemberHoliday'
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
        Name = 'inOperDateStart'
        Value = Null
        Component = edOperDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateEnd'
        Value = Null
        Component = edOperDateEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBeginDateStart'
        Value = Null
        Component = edBeginDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBeginDateEnd'
        Value = Null
        Component = edBeginDateEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = ''
        Component = GuideMemberHoliday
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberMainId'
        Value = ''
        Component = GuideMemberMain
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWorkTimeKindId'
        Value = Null
        Component = GuidesWorkTimeKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 20
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_MemberHoliday'
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
        Name = 'OperDateStart'
        Value = Null
        Component = edOperDateStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateEnd'
        Value = 0d
        Component = edOperDateEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'BeginDateStart'
        Value = Null
        Component = edBeginDateStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'BeginDateEnd'
        Value = Null
        Component = edBeginDateEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId'
        Value = 0.000000000000000000
        Component = GuideMemberHoliday
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = ''
        Component = GuideMemberHoliday
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberMainId'
        Value = ''
        Component = GuideMemberMain
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberMainName'
        Value = ''
        Component = GuideMemberMain
        ComponentItem = 'TextValue'
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
      end
      item
        Name = 'WorkTimeKindId'
        Value = Null
        Component = GuidesWorkTimeKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'WorkTimeKindName'
        Value = Null
        Component = GuidesWorkTimeKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 76
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
    Top = 290
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
    Top = 298
  end
  object GuideMemberHoliday: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember
    FormNameParam.Value = 'TMemberHoliday_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberHoliday_ChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideMemberHoliday
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideMemberHoliday
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateIn_Holiday'
        Value = Null
        Component = edOperDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateOut_Holiday'
        Value = Null
        Component = edOperDateEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 182
    Top = 69
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
    Top = 298
  end
  object GuideMemberMain: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMemberMain
    FormNameParam.Value = 'TMember_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuideMemberMain
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuideMemberMain
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 142
    Top = 103
  end
  object PeriodChoiceOperDate: TPeriodChoice
    DateStart = edOperDateStart
    DateEnd = edOperDateEnd
    Left = 272
    Top = 136
  end
  object PeriodChoiceBeginDate: TPeriodChoice
    DateStart = edBeginDateStart
    DateEnd = edBeginDateEnd
    Left = 320
    Top = 200
  end
  object GuidesWorkTimeKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edWorkTimeKind
    FormNameParam.Value = 'TWorkTimeKind_HolidayForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TWorkTimeKind_HolidayForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesWorkTimeKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesWorkTimeKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 134
    Top = 248
  end
end
