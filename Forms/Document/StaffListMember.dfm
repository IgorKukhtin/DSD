inherited StaffListMemberForm: TStaffListMemberForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1064#1090#1072#1090#1085#1086#1077' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082#1080')>'
  ClientHeight = 527
  ClientWidth = 718
  AddOnFormData.isSingle = False
  ExplicitWidth = 724
  ExplicitHeight = 556
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 486
    Top = 493
    Height = 26
    ExplicitLeft = 486
    ExplicitTop = 493
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 608
    Top = 493
    Height = 26
    ExplicitLeft = 608
    ExplicitTop = 493
    ExplicitHeight = 26
  end
  object cxLabel1: TcxLabel [2]
    Left = 94
    Top = 1
    Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object lbInvNumber: TcxLabel [3]
    Left = 8
    Top = 1
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object edOperDate: TcxDateEdit [4]
    Left = 94
    Top = 21
    EditValue = 42092d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 88
  end
  object cxLabel6: TcxLabel [5]
    Left = 369
    Top = 1
    Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
  end
  object edInvNumber: TcxTextEdit [6]
    Left = 8
    Top = 21
    Properties.ReadOnly = True
    TabOrder = 6
    Text = '0'
    Width = 75
  end
  object edUpdateDate: TcxDateEdit [7]
    Left = 368
    Top = 59
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
    Top = 43
    Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
  end
  object cxLabel9: TcxLabel [9]
    Left = 508
    Top = 1
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
  end
  object edInsert: TcxButtonEdit [10]
    Left = 508
    Top = 21
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
    Top = 43
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
  end
  object edUpdate: TcxButtonEdit [12]
    Left = 508
    Top = 59
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
    Top = 21
    EditValue = 42092d
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 15
    Width = 130
  end
  object cxLabel10: TcxLabel [16]
    Left = 368
    Top = 122
    Caption = #1055#1088#1080#1095#1080#1085#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
  end
  object edReasonOut: TcxButtonEdit [17]
    Left = 368
    Top = 138
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
    Top = 58
    Hint = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
    Caption = #1054#1089#1085#1086#1074#1085#1086#1077' '#1084#1077#1089#1090#1086' '#1088#1072#1073#1086#1090#1099
    TabOrder = 18
    Width = 146
  end
  object cbOfficial: TcxCheckBox [19]
    Left = 184
    Top = 59
    Hint = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
    Caption = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
    TabOrder = 19
    Width = 146
  end
  object cxLabel7: TcxLabel [20]
    Left = 8
    Top = 159
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object ceUnit: TcxButtonEdit [21]
    Left = 8
    Top = 175
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
    Top = 196
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
  end
  object cePosition: TcxButtonEdit [23]
    Left = 8
    Top = 212
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
    Top = 233
    Caption = #1056#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
  end
  object cePositionLevel: TcxButtonEdit [25]
    Left = 8
    Top = 250
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
    Left = 367
    Top = 250
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
    Left = 367
    Top = 233
    Caption = #1056#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080' ('#1076#1086' '#1087#1077#1088#1077#1074#1086#1076#1072')'
  end
  object cePosition_old: TcxButtonEdit [28]
    Left = 367
    Top = 212
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
    Left = 367
    Top = 196
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1076#1086' '#1087#1077#1088#1077#1074#1086#1076#1072')'
  end
  object ceUnit_old: TcxButtonEdit [30]
    Left = 368
    Top = 175
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
    Left = 368
    Top = 159
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1076#1086' '#1087#1077#1088#1077#1074#1086#1076#1072')'
  end
  object edStaffListKind: TcxButtonEdit [32]
    Left = 8
    Top = 138
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
    Left = 9
    Top = 121
    Caption = #1042#1080#1076' '#1086#1092#1086#1088#1084#1083#1077#1085#1080#1103' '#1074' '#1096#1090#1072#1090
  end
  object cxLabel15: TcxLabel [34]
    Left = 368
    Top = 86
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [35]
    Left = 368
    Top = 102
    TabOrder = 35
    Width = 331
  end
  object cxButton1: TcxButton [36]
    Left = 369
    Top = 444
    Width = 150
    Height = 26
    Action = actOpenChoiceFormMember
    Default = True
    ModalResult = 1
    TabOrder = 36
  end
  object cxLabel16: TcxLabel [37]
    Left = 8
    Top = 275
    Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'('#1075#1083#1072#1074#1085#1072#1103')'
  end
  object cePersonalServiceList: TcxButtonEdit [38]
    Left = 8
    Top = 292
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 38
    Width = 331
  end
  object cxLabel17: TcxLabel [39]
    Left = 8
    Top = 314
    Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'('#1041#1053')'
  end
  object cePersonalServiceListOfficial: TcxButtonEdit [40]
    Left = 8
    Top = 329
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 40
    Width = 331
  end
  object cxLabel18: TcxLabel [41]
    Left = 8
    Top = 354
    Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'('#1050#1072#1088#1090#1072' '#1060'2)'
  end
  object cePersonalServiceListCardSecond: TcxButtonEdit [42]
    Left = 8
    Top = 369
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 42
    Width = 331
  end
  object ceSheetWorkTime: TcxButtonEdit [43]
    Left = 8
    Top = 446
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 43
    Width = 331
  end
  object cxLabel19: TcxLabel [44]
    Left = 8
    Top = 431
    Caption = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099' ('#1064#1072#1073#1083#1086#1085' '#1090#1072#1073#1077#1083#1103' '#1088'.'#1074#1088'.)'
  end
  object cePersonalGroup: TcxButtonEdit [45]
    Left = 367
    Top = 331
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 45
    Width = 331
  end
  object cxLabel20: TcxLabel [46]
    Left = 367
    Top = 314
    Caption = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1080' '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' '
  end
  object cxLabel21: TcxLabel [47]
    Left = 8
    Top = 468
    Caption = #1051#1080#1085#1080#1103' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
  end
  object ceStorageLine: TcxButtonEdit [48]
    Left = 8
    Top = 484
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 48
    Width = 331
  end
  object cxLabel22: TcxLabel [49]
    Left = 8
    Top = 392
    Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'('#1072#1074#1072#1085#1089' '#1050#1072#1088#1090#1072' '#1060'2)'
  end
  object cePersonalServiceListAvanceF2: TcxButtonEdit [50]
    Left = 8
    Top = 408
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 50
    Width = 331
  end
  object cxLabel23: TcxLabel [51]
    Left = 368
    Top = 354
    Caption = #1060#1072#1084#1080#1083#1080#1103' '#1088#1077#1082#1086#1084#1077#1085#1076#1072#1090#1077#1083#1103
  end
  object edMember_Refer: TcxButtonEdit [52]
    Left = 368
    Top = 369
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 52
    Width = 331
  end
  object cxLabel24: TcxLabel [53]
    Left = 368
    Top = 393
    Caption = #1060#1072#1084#1080#1083#1080#1103' '#1085#1072#1089#1090#1072#1074#1085#1080#1082#1072
  end
  object edMember_Mentor: TcxButtonEdit [54]
    Left = 368
    Top = 408
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 54
    Width = 331
  end
  object cxButton2: TcxButton [55]
    Left = 548
    Top = 444
    Width = 150
    Height = 26
    Action = actOpenChoiceMemberDel
    Default = True
    ModalResult = 1
    TabOrder = 55
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 299
    Top = 65528
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 232
    Top = 65531
  end
  inherited ActionList: TActionList
    Left = 663
    Top = 278
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides [0]
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1076#1083#1103' '#1087#1077#1088#1077#1074#1086#1076#1072
    end
    inherited actRefresh: TdsdDataSetRefresh [1]
    end
    inherited FormClose: TdsdFormClose [2]
    end
    object actOpenChoiceMemberDel: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1042#1067#1073#1088#1072#1090#1100' '#1076#1083#1103' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
      FormName = 'TPersonalForm'
      FormNameParam.Value = 'TPersonalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MemberId'
          Value = ''
          Component = GuideMember
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = ''
          Component = GuideMember
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'PersonalId_old'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
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
          ComponentItem = 'Key'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionLevelId'
          Value = ''
          Component = GuidesPositionLevel
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PositionLevelName'
          Value = ''
          Component = GuidesPositionLevel
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalGroupId'
          Value = ''
          Component = GuidesPersonalGroup
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalGroupName'
          Value = ''
          Component = GuidesPersonalGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalServiceListId'
          Value = ''
          Component = GuidesPersonalServiceList
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalServiceListName'
          Value = ''
          Component = GuidesPersonalServiceList
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ServiceListId_AvanceF2'
          Value = ''
          Component = GuidesPersonalServiceListAvanceF2
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ServiceListName_AvanceF2'
          Value = ''
          Component = GuidesPersonalServiceListAvanceF2
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ServiceListCardSecondId'
          Value = ''
          Component = cePersonalServiceListCardSecond
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ServiceListCardSecondName'
          Value = ''
          Component = cePersonalServiceListCardSecond
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalServiceListOfficialId'
          Value = ''
          Component = cePersonalServiceListOfficial
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalServiceListOfficialName'
          Value = ''
          Component = cePersonalServiceListOfficial
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'SheetWorkTimeId'
          Value = ''
          Component = GuidesSheetWorkTime
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'SheetWorkTimeName'
          Value = ''
          Component = GuidesSheetWorkTime
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StorageLineId'
          Value = ''
          Component = GuidesStorageLine
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'StorageLineName'
          Value = ''
          Component = GuidesStorageLine
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Member_MentorId'
          Value = ''
          Component = GuidesMember_Mentor
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Member_MentorName'
          Value = ''
          Component = GuidesMember_Mentor
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Member_ReferId'
          Value = ''
          Component = GuidesMember_Refer
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Member_ReferName'
          Value = ''
          Component = GuidesMember_Refer
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenChoiceFormMember: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1042#1067#1073#1088#1072#1090#1100' '#1076#1083#1103' '#1087#1077#1088#1077#1074#1086#1076#1072
      FormName = 'TPersonalForm'
      FormNameParam.Value = 'TPersonalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MemberId'
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
        end
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'PersonalId_old'
          MultiSelectSeparator = ','
        end
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
          Name = 'ServiceListId_AvanceF2'
          Value = Null
          Component = GuidesPersonalServiceListAvanceF2
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ServiceListName_AvanceF2'
          Value = Null
          Component = GuidesPersonalServiceListAvanceF2
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ServiceListCardSecondId'
          Value = Null
          Component = cePersonalServiceListCardSecond
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ServiceListCardSecondName'
          Value = Null
          Component = cePersonalServiceListCardSecond
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalServiceListOfficialId'
          Value = Null
          Component = cePersonalServiceListOfficial
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalServiceListOfficialName'
          Value = Null
          Component = cePersonalServiceListOfficial
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'SheetWorkTimeId'
          Value = Null
          Component = GuidesSheetWorkTime
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'SheetWorkTimeName'
          Value = Null
          Component = GuidesSheetWorkTime
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StorageLineId'
          Value = Null
          Component = GuidesStorageLine
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'StorageLineName'
          Value = Null
          Component = GuidesStorageLine
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Member_MentorId'
          Value = Null
          Component = GuidesMember_Mentor
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Member_MentorName'
          Value = Null
          Component = GuidesMember_Mentor
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Member_ReferId'
          Value = Null
          Component = GuidesMember_Refer
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Member_ReferName'
          Value = Null
          Component = GuidesMember_Refer
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
        Name = 'inPersonalId_old'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalId_old'
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
        Name = 'inPersonalGroupId'
        Value = Null
        Component = GuidesPersonalGroup
        ComponentItem = 'Key'
        ParamType = ptInput
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
        Name = 'inPersonalServiceListOfficialId'
        Value = Null
        Component = GuidesPersonalServiceListOfficial
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalServiceListCardSecondId'
        Value = Null
        Component = GuidesPersonalServiceListCardSecond
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalServiceListId_AvanceF2'
        Value = Null
        Component = GuidesPersonalServiceListAvanceF2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSheetWorkTimeId'
        Value = Null
        Component = GuidesSheetWorkTime
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageLineId'
        Value = Null
        Component = GuidesStorageLine
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMember_ReferId'
        Value = Null
        Component = GuidesMember_Refer
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMember_ReferId'
        Value = Null
        Component = GuidesMember_Mentor
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
    Left = 663
    Top = 443
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
        Name = 'PersonalServiceListAvanceF2Id'
        Value = Null
        Component = GuidesPersonalServiceListAvanceF2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalServiceListAvanceF2Name'
        Value = Null
        Component = GuidesPersonalServiceListAvanceF2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalServiceListCardSecondId'
        Value = Null
        Component = GuidesPersonalServiceListCardSecond
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalServiceListCardSecondName'
        Value = Null
        Component = GuidesPersonalServiceListCardSecond
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalServiceListOfficialId'
        Value = Null
        Component = GuidesPersonalServiceListOfficial
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalServiceListOfficialName'
        Value = Null
        Component = GuidesPersonalServiceListOfficial
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SheetWorkTimeId'
        Value = Null
        Component = GuidesSheetWorkTime
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'SheetWorkTimeName'
        Value = Null
        Component = GuidesSheetWorkTime
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StorageLineId'
        Value = Null
        Component = GuidesStorageLine
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StorageLineName'
        Value = Null
        Component = GuidesStorageLine
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Member_MentorId'
        Value = Null
        Component = GuidesMember_Mentor
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Member_MentorName'
        Value = Null
        Component = GuidesMember_Mentor
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Member_ReferId'
        Value = Null
        Component = GuidesMember_Refer
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Member_ReferName'
        Value = Null
        Component = GuidesMember_Refer
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalId'
        MultiSelectSeparator = ','
      end>
    Left = 583
    Top = 490
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
    Left = 624
    Top = 228
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
    Left = 522
    Top = 247
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
    Left = 118
    Top = 102
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
    Left = 416
    Top = 220
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
    Left = 422
    Top = 107
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
    Top = 177
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
    Top = 213
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
    Top = 246
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
    Left = 574
    Top = 239
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
    Left = 486
    Top = 206
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
    Left = 551
    Top = 165
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
      end
      item
        Name = 'isMain'
        Value = Null
        Component = cbMain
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 214
    Top = 106
  end
  object GuidesPersonalServiceListOfficial: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonalServiceListOfficial
    FormNameParam.Value = 'TPersonalServiceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalServiceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalServiceListOfficial
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalServiceListOfficial
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 215
    Top = 301
  end
  object GuidesPersonalServiceList: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonalServiceList
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
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalServiceList
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 199
    Top = 272
  end
  object GuidesSheetWorkTime: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceSheetWorkTime
    FormNameParam.Value = 'TSheetWorkTime_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSheetWorkTime_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesSheetWorkTime
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesSheetWorkTime
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 215
    Top = 423
  end
  object GuidesPersonalServiceListCardSecond: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonalServiceListCardSecond
    FormNameParam.Value = 'TPersonalServiceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalServiceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalServiceListCardSecond
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalServiceListCardSecond
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 199
    Top = 333
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
    Left = 542
    Top = 336
  end
  object GuidesStorageLine: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStorageLine
    FormNameParam.Value = 'TStorageLineForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStorageLineForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesStorageLine
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesStorageLine
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 207
    Top = 479
  end
  object GuidesPersonalServiceListAvanceF2: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonalServiceListAvanceF2
    FormNameParam.Value = 'TPersonalServiceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalServiceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalServiceListAvanceF2
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalServiceListAvanceF2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 183
    Top = 384
  end
  object GuidesMember_Refer: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember_Refer
    FormNameParam.Value = 'TMemberForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMember_Refer
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMember_Refer
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        ComponentItem = 'Code'
        MultiSelectSeparator = ','
      end>
    Left = 476
    Top = 365
  end
  object GuidesMember_Mentor: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember_Mentor
    FormNameParam.Value = 'TMemberForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMember_Mentor
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMember_Mentor
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        ComponentItem = 'Code'
        MultiSelectSeparator = ','
      end>
    Left = 500
    Top = 405
  end
end
