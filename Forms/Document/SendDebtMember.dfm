inherited SendDebtMemberForm: TSendDebtMemberForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1042#1079#1072#1080#1084#1086#1079#1072#1095#1077#1090' ('#1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072')>'
  ClientHeight = 403
  ClientWidth = 594
  ExplicitWidth = 600
  ExplicitHeight = 432
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 184
    Top = 361
    ExplicitLeft = 184
    ExplicitTop = 361
  end
  inherited bbCancel: TcxButton
    Left = 328
    Top = 361
    ExplicitLeft = 328
    ExplicitTop = 361
  end
  object cxLabel1: TcxLabel [2]
    Left = 152
    Top = 4
    Caption = #1044#1072#1090#1072
  end
  object Код: TcxLabel [3]
    Left = 8
    Top = 4
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object ceInvNumber: TcxCurrencyEdit [4]
    Left = 8
    Top = 24
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 2
    Width = 129
  end
  object cxLabel2: TcxLabel [5]
    Left = 8
    Top = 241
    Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100' ('#1050#1088#1077#1076#1080#1090')'
  end
  object cxLabel5: TcxLabel [6]
    Left = 8
    Top = 191
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103' ('#1050#1088#1077#1076#1080#1090')'
  end
  object ceCarFrom: TcxButtonEdit [7]
    Left = 8
    Top = 264
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 273
  end
  object ceInfoMoneyFrom: TcxButtonEdit [8]
    Left = 8
    Top = 211
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 273
  end
  object ceOperDate: TcxDateEdit [9]
    Left = 152
    Top = 24
    EditValue = 43489d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 129
  end
  object ceMemberFrom: TcxButtonEdit [10]
    Left = 8
    Top = 69
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 273
  end
  object cxLabel6: TcxLabel [11]
    Left = 8
    Top = 51
    Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086' ('#1050#1088#1077#1076#1080#1090')'
  end
  object cxLabel10: TcxLabel [12]
    Left = 8
    Top = 299
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [13]
    Left = 8
    Top = 318
    TabOrder = 13
    Width = 576
  end
  object cxLabel4: TcxLabel [14]
    Left = 312
    Top = 4
    Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085
  end
  object ceAmount: TcxCurrencyEdit [15]
    Left = 312
    Top = 24
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 15
    Width = 126
  end
  object cxLabel3: TcxLabel [16]
    Left = 312
    Top = 51
    Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086' ('#1044#1077#1073#1077#1090')'
  end
  object ceMemberTo: TcxButtonEdit [17]
    Left = 313
    Top = 69
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 273
  end
  object cxLabel7: TcxLabel [18]
    Left = 312
    Top = 191
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103' ('#1044#1077#1073#1077#1090')'
  end
  object ceInfoMoneyTo: TcxButtonEdit [19]
    Left = 312
    Top = 211
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 273
  end
  object cxLabel9: TcxLabel [20]
    Left = 312
    Top = 241
    Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100' ('#1044#1077#1073#1077#1090')'
  end
  object ceCarTo: TcxButtonEdit [21]
    Left = 312
    Top = 264
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 273
  end
  object ceJuridicalBasisFrom: TcxButtonEdit [22]
    Left = 8
    Top = 115
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 22
    Width = 273
  end
  object cxLabel12: TcxLabel [23]
    Left = 8
    Top = 96
    Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088'. '#1083#1080#1094#1086' ('#1050#1088#1077#1076#1080#1090')'
  end
  object ceJuridicalBasisTo: TcxButtonEdit [24]
    Left = 313
    Top = 114
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 24
    Width = 273
  end
  object cxLabel13: TcxLabel [25]
    Left = 312
    Top = 96
    Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088'. '#1083#1080#1094#1086' ('#1044#1077#1073#1077#1090')'
  end
  object ceBranchFrom: TcxButtonEdit [26]
    Left = 8
    Top = 164
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 26
    Width = 273
  end
  object cxLabel14: TcxLabel [27]
    Left = 8
    Top = 141
    Caption = #1060#1080#1083#1080#1072#1083' ('#1050#1088#1077#1076#1080#1090')'
  end
  object ceBranchTo: TcxButtonEdit [28]
    Left = 312
    Top = 161
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 28
    Width = 272
  end
  object cxLabel15: TcxLabel [29]
    Left = 312
    Top = 141
    Caption = #1060#1080#1083#1080#1072#1083' ('#1050#1088#1077#1076#1080#1090')'
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 353
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 353
  end
  inherited ActionList: TActionList
    Left = 95
    Top = 352
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides [0]
    end
    object actRefreshAmountCurr: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    inherited actRefresh: TdsdDataSetRefresh [2]
    end
    inherited FormClose: TdsdFormClose [3]
    end
    object actCheckRight: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <>
      Caption = #1087#1088#1086#1074#1077#1088#1082#1072' '#1087#1088#1072#1074' '#1085#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = '0'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 353
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_SendDebtMember'
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
        Name = 'inInvNumber'
        Value = 0.000000000000000000
        Component = ceInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioMasterId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MI_MasterId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioChildId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MI_ChildId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberFromId'
        Value = ''
        Component = GuidesMemberFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalBasisFromId'
        Value = ''
        Component = GuidesJuridicalBasisFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCarFromId'
        Value = ''
        Component = GuidesCarFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyFromId'
        Value = ''
        Component = GuidesInfoMoneyFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchFromId'
        Value = Null
        Component = GuidesBranchFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberToId'
        Value = ''
        Component = GuidesMemberTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalBasisToId'
        Value = ''
        Component = GuidesJuridicalBasisTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCarToId'
        Value = ''
        Component = GuidesCarTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyToId'
        Value = ''
        Component = GuidesInfoMoneyTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchToId'
        Value = Null
        Component = GuidesBranchTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 440
    Top = 345
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_SendDebtMember'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MI_MasterId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MI_MasterId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MI_ChildId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MI_ChildId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Invnumber'
        Value = 0.000000000000000000
        Component = ceInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyFromId'
        Value = ''
        Component = GuidesInfoMoneyFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyFromName'
        Value = ''
        Component = GuidesInfoMoneyFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberFromId'
        Value = ''
        Component = GuidesMemberFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberFromName'
        Value = ''
        Component = GuidesMemberFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarFromId'
        Value = ''
        Component = GuidesCarFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarFromName'
        Value = ''
        Component = GuidesCarFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisFromId'
        Value = ''
        Component = GuidesJuridicalBasisFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisFromName'
        Value = ''
        Component = GuidesJuridicalBasisFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyToId'
        Value = ''
        Component = GuidesInfoMoneyTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyToName'
        Value = ''
        Component = GuidesInfoMoneyTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberToId'
        Value = ''
        Component = GuidesMemberTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberToName'
        Value = ''
        Component = GuidesMemberTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarToId'
        Value = ''
        Component = GuidesCarTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarToName'
        Value = ''
        Component = GuidesCarTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisToId'
        Value = ''
        Component = GuidesJuridicalBasisTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisToName'
        Value = ''
        Component = GuidesJuridicalBasisTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchFromId'
        Value = Null
        Component = GuidesBranchFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchFromName'
        Value = Null
        Component = GuidesBranchFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchToId'
        Value = Null
        Component = GuidesBranchTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchToName'
        Value = Null
        Component = GuidesBranchTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount'
        Value = 0.000000000000000000
        Component = ceAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 496
    Top = 344
  end
  object GuidesCarFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCarFrom
    FormNameParam.Value = 'TCar_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCar_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCarFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCarFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 59
    Top = 251
  end
  object GuidesInfoMoneyFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoneyFrom
    FormNameParam.Value = 'TInfoMoneyForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoneyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoneyFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoneyFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 197
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = GuidesMemberFrom
      end
      item
        Guides = GuidesMemberTo
      end
      item
      end>
    ActionItemList = <>
    Left = 280
    Top = 344
  end
  object GuidesMemberFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMemberFrom
    FormNameParam.Value = 'TMember_ContainerByDebtForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ContainerByDebtForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMemberFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMemberFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisId'
        Value = ''
        Component = GuidesJuridicalBasisFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisName'
        Value = ''
        Component = GuidesJuridicalBasisFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarId'
        Value = ''
        Component = GuidesCarFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarName'
        Value = ''
        Component = GuidesCarFrom
        ComponentItem = 'TextValue'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = GuidesInfoMoneyFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName_all'
        Value = ''
        Component = GuidesInfoMoneyFrom
        ComponentItem = 'TextValue'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchId'
        Value = ''
        Component = GuidesBranchFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchName'
        Value = ''
        Component = GuidesBranchFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterMemberId'
        Value = 0
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterMemberName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount'
        Value = Null
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 145
    Top = 56
  end
  object GuidesInfoMoneyTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoneyTo
    FormNameParam.Value = 'TInfoMoneyForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoneyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoneyTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoneyTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 440
    Top = 197
  end
  object GuidesCarTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCarTo
    FormNameParam.Value = 'TCar_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCar_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCarTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCarTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 347
    Top = 259
  end
  object GuidesMemberTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMemberTo
    FormNameParam.Value = 'TMember_ContainerByDebtForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ContainerByDebtForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMemberTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMemberTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarId'
        Value = ''
        Component = GuidesCarTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarName'
        Value = ''
        Component = GuidesCarTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = GuidesInfoMoneyTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName_all'
        Value = ''
        Component = GuidesInfoMoneyTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisId'
        Value = ''
        Component = GuidesJuridicalBasisTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisName'
        Value = ''
        Component = GuidesJuridicalBasisTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchId'
        Value = ''
        Component = GuidesBranchTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchName'
        Value = ''
        Component = GuidesBranchTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterMemberId'
        Value = 0
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterMemberName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 481
    Top = 42
  end
  object GuidesJuridicalBasisFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridicalBasisFrom
    FormNameParam.Value = 'TJuridical_BasisForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_BasisForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridicalBasisFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridicalBasisFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 104
  end
  object GuidesJuridicalBasisTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridicalBasisTo
    FormNameParam.Value = 'TJuridical_BasisForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_BasisForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridicalBasisTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridicalBasisTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 504
    Top = 104
  end
  object GuidesBranchFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBranchFrom
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBranchFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBranchFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 144
  end
  object GuidesBranchTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBranchTo
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBranchTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBranchTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 528
    Top = 152
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshAmountCurr
    ComponentList = <
      item
        Component = ceAmount
      end>
    Left = 288
    Top = 152
  end
end
