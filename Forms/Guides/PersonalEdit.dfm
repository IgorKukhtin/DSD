object PersonalEditForm: TPersonalEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <C'#1086#1090#1088#1091#1076#1085#1080#1082'>'
  ClientHeight = 600
  ClientWidth = 363
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
    Left = 82
    Top = 564
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 186
    Top = 564
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 2
  end
  object cxPageControl1: TcxPageControl
    Left = 8
    Top = 8
    Width = 349
    Height = 537
    TabOrder = 0
    Properties.ActivePage = cxTabSheet1
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 537
    ClientRectRight = 349
    ClientRectTop = 24
    object cxTabSheet1: TcxTabSheet
      Caption = #1054#1073#1097#1072#1103
      ImageIndex = 0
      object Код: TcxLabel
        Left = 16
        Top = 3
        Caption = #1050#1086#1076
      end
      object ceMemberCode: TcxCurrencyEdit
        Left = 16
        Top = 20
        Enabled = False
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        TabOrder = 0
        Width = 73
      end
      object cxLabel3: TcxLabel
        Left = 16
        Top = 207
        Caption = #1044#1072#1090#1072' '#1087#1088#1080#1077#1084#1072
      end
      object cxLabel2: TcxLabel
        Left = 124
        Top = 207
        Caption = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
      end
      object cxLabel5: TcxLabel
        Left = 16
        Top = 128
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
      end
      object cxLabel6: TcxLabel
        Left = 95
        Top = 3
        Caption = #1060#1048#1054
      end
      object cxLabel7: TcxLabel
        Left = 16
        Top = 46
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      end
      object cePosition: TcxButtonEdit
        Left = 16
        Top = 144
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 2
        Width = 305
      end
      object ceUnit: TcxButtonEdit
        Left = 16
        Top = 63
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 3
        Width = 305
      end
      object ceMember: TcxButtonEdit
        Left = 95
        Top = 20
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 1
        Width = 226
      end
      object edDateIn: TcxDateEdit
        Left = 16
        Top = 231
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 12
        Width = 92
      end
      object edDateOut: TcxDateEdit
        Left = 124
        Top = 226
        EditValue = 42929d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 14
        Width = 92
      end
      object cePersonalGroup: TcxButtonEdit
        Left = 16
        Top = 106
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 13
        Width = 305
      end
      object cxLabel1: TcxLabel
        Left = 16
        Top = 89
        Caption = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1080' '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' '
      end
      object cxLabel4: TcxLabel
        Left = 16
        Top = 166
        Caption = #1056#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
      end
      object cePositionLevel: TcxButtonEdit
        Left = 16
        Top = 183
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 15
        Width = 305
      end
      object cbDateOut: TcxCheckBox
        Left = 161
        Top = 253
        Hint = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
        Caption = #1059#1074#1086#1083#1077#1085
        TabOrder = 16
        Width = 62
      end
      object cxLabel17: TcxLabel
        Left = 237
        Top = 207
        Caption = #1044#1072#1090#1072' '#1087#1077#1088#1077#1074#1086#1076#1072
      end
      object edDateSend: TcxDateEdit
        Left = 237
        Top = 226
        EditValue = 42929d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 4
        Width = 92
      end
      object cbDateSend: TcxCheckBox
        Left = 249
        Top = 253
        Caption = #1055#1077#1088#1077#1074#1077#1076#1077#1085
        TabOrder = 5
        Width = 80
      end
      object cbMain: TcxCheckBox
        Left = 3
        Top = 253
        Hint = #1054#1092#1086#1088#1084#1083#1077#1085' '#1086#1092#1080#1094#1080#1072#1083#1100#1085#1086
        Caption = #1054#1089#1085#1086#1074#1085#1086#1077' '#1084#1077#1089#1090#1086' '#1088#1072#1073#1086#1090#1099
        TabOrder = 18
        Width = 146
      end
      object cxLabel8: TcxLabel
        Left = 16
        Top = 278
        Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'('#1075#1083#1072#1074#1085#1072#1103')'
      end
      object cePersonalServiceList: TcxButtonEdit
        Left = 16
        Top = 296
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 20
        Width = 305
      end
      object cxLabel9: TcxLabel
        Left = 16
        Top = 318
        Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'('#1041#1053')'
      end
      object cePersonalServiceListOfficial: TcxButtonEdit
        Left = 16
        Top = 335
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 22
        Width = 305
      end
      object cxLabel10: TcxLabel
        Left = 16
        Top = 433
        Caption = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099' ('#1064#1072#1073#1083#1086#1085' '#1090#1072#1073#1077#1083#1103' '#1088'.'#1074#1088'.)'
      end
      object ceSheetWorkTime: TcxButtonEdit
        Left = 16
        Top = 450
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 24
        Width = 305
      end
      object cxLabel11: TcxLabel
        Left = 16
        Top = 475
        Caption = #1051#1080#1085#1080#1103' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
      end
      object ceStorageLine: TcxButtonEdit
        Left = 16
        Top = 492
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 26
        Width = 305
      end
      object cxLabel12: TcxLabel
        Left = 16
        Top = 359
        Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'('#1050#1072#1088#1090#1072' '#1060'2)'
      end
      object cePersonalServiceListCardSecond: TcxButtonEdit
        Left = 16
        Top = 373
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 27
        Width = 305
      end
      object cePersonalServiceListAvanceF2: TcxButtonEdit
        Left = 16
        Top = 411
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 31
        Width = 305
      end
      object cxLabel18: TcxLabel
        Left = 16
        Top = 395
        Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'('#1072#1074#1072#1085#1089' '#1050#1072#1088#1090#1072' '#1060'2)'
      end
    end
    object cxTabSheet2: TcxTabSheet
      Caption = #1055#1088#1086#1095#1077#1077
      ImageIndex = 1
      object cxLabel14: TcxLabel
        Left = 8
        Top = 62
        Caption = #1060#1072#1084#1080#1083#1080#1103' '#1085#1072#1089#1090#1072#1074#1085#1080#1082#1072
      end
      object edMember_Mentor: TcxButtonEdit
        Left = 8
        Top = 79
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 1
        Width = 318
      end
      object cxLabel15: TcxLabel
        Left = 8
        Top = 114
        Caption = #1055#1088#1080#1095#1080#1085#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
      end
      object edReasonOut: TcxButtonEdit
        Left = 8
        Top = 131
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 3
        Width = 318
      end
      object cxLabel13: TcxLabel
        Left = 8
        Top = 15
        Caption = #1060#1072#1084#1080#1083#1080#1103' '#1088#1077#1082#1086#1084#1077#1085#1076#1072#1090#1077#1083#1103
      end
      object edMember_Refer: TcxButtonEdit
        Left = 8
        Top = 32
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 5
        Width = 318
      end
      object edComment: TcxTextEdit
        Left = 8
        Top = 181
        TabOrder = 6
        Width = 318
      end
      object cxLabel16: TcxLabel
        Left = 8
        Top = 163
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
      end
    end
  end
  object ActionList: TActionList
    Left = 184
    Top = 16
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
    object dsdFormClose1: TdsdFormClose
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
    StoredProcName = 'gpInsertUpdate_Object_Personal'
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
        Name = 'inMemberId '
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionLevelId'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalGroupId'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalServiceListId'
        Value = Null
        Component = PersonalServiceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalServiceListOfficialId'
        Value = Null
        Component = PersonalServiceListOfficialGuides
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
        Component = SheetWorkTimeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageLineId'
        Value = Null
        Component = StorageLineGuides
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
        Name = 'inMember_MentorId'
        Value = Null
        Component = GuidesMember_Mentor
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
        Name = 'inDateIn'
        Value = 0d
        Component = edDateIn
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateOut'
        Value = 0d
        Component = edDateOut
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateSend'
        Value = Null
        Component = edDateSend
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDateOut'
        Value = False
        Component = cbDateOut
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDateSend'
        Value = Null
        Component = cbDateSend
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsMain'
        Value = False
        Component = cbMain
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 115
    Top = 166
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MaskId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 96
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Personal'
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
        Name = 'MaskId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'MaskId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberCode'
        Value = 0.000000000000000000
        Component = ceMemberCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionLevelId'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionLevelName'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupId'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupName'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateIn'
        Value = 0d
        Component = edDateIn
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateOut'
        Value = 0d
        Component = edDateOut
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsDateOut'
        Value = False
        Component = cbDateOut
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsMain'
        Value = False
        Component = cbMain
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalServiceListId'
        Value = Null
        Component = PersonalServiceListGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalServiceListName'
        Value = Null
        Component = PersonalServiceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalServiceListOfficialId'
        Value = Null
        Component = PersonalServiceListOfficialGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalServiceListOfficialName'
        Value = Null
        Component = PersonalServiceListOfficialGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SheetWorkTimeId'
        Value = Null
        Component = SheetWorkTimeGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'SheetWorkTimeName'
        Value = Null
        Component = SheetWorkTimeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StorageLineId'
        Value = Null
        Component = StorageLineGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StorageLineName'
        Value = Null
        Component = StorageLineGuides
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
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateSend'
        Value = Null
        Component = edDateSend
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDateSend'
        Value = Null
        Component = cbDateSend
        DataType = ftBoolean
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
      end>
    PackSize = 1
    Left = 184
    Top = 182
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
    Left = 256
    Top = 192
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 216
    Top = 72
  end
  object UnitGuides: TdsdGuides
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
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 55
  end
  object MemberGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMember
    FormNameParam.Value = 'TMemberForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceMemberCode
        ComponentItem = 'Code'
        MultiSelectSeparator = ','
      end>
    Left = 277
    Top = 8
  end
  object PersonalGroupGuides: TdsdGuides
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
        Component = PersonalGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 279
    Top = 96
  end
  object PositionGuides: TdsdGuides
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
        Component = PositionGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 279
    Top = 144
  end
  object PositionLevelGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePositionLevel
    FormNameParam.Value = 'TPositionLevelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionLevelForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 335
    Top = 161
  end
  object PersonalServiceListGuides: TdsdGuides
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
        Component = PersonalServiceListGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalServiceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 279
    Top = 369
  end
  object PersonalServiceListOfficialGuides: TdsdGuides
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
        Component = PersonalServiceListOfficialGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalServiceListOfficialGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 151
    Top = 345
  end
  object SheetWorkTimeGuides: TdsdGuides
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
        Component = SheetWorkTimeGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = SheetWorkTimeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 95
    Top = 323
  end
  object StorageLineGuides: TdsdGuides
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
        Component = StorageLineGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = StorageLineGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 311
    Top = 419
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
    Left = 287
    Top = 313
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
        Component = ceMemberCode
        ComponentItem = 'Code'
        MultiSelectSeparator = ','
      end>
    Left = 133
    Top = 48
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
        Component = ceMemberCode
        ComponentItem = 'Code'
        MultiSelectSeparator = ','
      end>
    Left = 157
    Top = 88
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
        DataType = ftString
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
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceMemberCode
        ComponentItem = 'Code'
        MultiSelectSeparator = ','
      end>
    Left = 181
    Top = 136
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
    Left = 223
    Top = 451
  end
end
