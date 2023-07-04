inherited MemberHolidayEditForm: TMemberHolidayEditForm
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' <'#1055#1088#1080#1082#1072#1079#1072' '#1087#1086' '#1086#1090#1087#1091#1089#1082#1072#1084'> '#1076#1083#1103' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081
  ClientHeight = 392
  ClientWidth = 356
  AddOnFormData.isSingle = False
  ExplicitWidth = 362
  ExplicitHeight = 421
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 54
    Top = 353
    Height = 26
    ExplicitLeft = 54
    ExplicitTop = 353
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 194
    Top = 353
    Height = 26
    ExplicitLeft = 194
    ExplicitTop = 353
    ExplicitHeight = 26
  end
  object cxLabel1: TcxLabel [2]
    Left = 94
    Top = 7
    Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object Код: TcxLabel [3]
    Left = 8
    Top = 7
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object edOperDate: TcxDateEdit [4]
    Left = 94
    Top = 27
    EditValue = 42092d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 88
  end
  object edInvNumber: TcxTextEdit [5]
    Left = 8
    Top = 27
    Properties.ReadOnly = True
    TabOrder = 5
    Text = '0'
    Width = 75
  end
  object cxLabel11: TcxLabel [6]
    Left = 8
    Top = 58
    Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
  end
  object edMember: TcxButtonEdit [7]
    Left = 8
    Top = 78
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 331
  end
  object edSummHoliday1_calc: TcxCurrencyEdit [8]
    Left = 8
    Top = 173
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 157
  end
  object cxLabel24: TcxLabel [9]
    Left = 8
    Top = 108
    Hint = '(-)% '#1057#1082#1080#1076#1082#1080' (+)% '#1053#1072#1094#1077#1085#1082#1080' '#1044#1086#1075'.'
    Caption = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1086#1090#1087#1091#1089#1082#1072
    ParentShowHint = False
    ShowHint = True
  end
  object cxLabel12: TcxLabel [10]
    Left = 8
    Top = 155
    Hint = '(-)% '#1057#1082#1080#1076#1082#1080' (+)% '#1053#1072#1094#1077#1085#1082#1080' '#1044#1086#1075'.'
    Caption = #1057#1091#1084#1084#1072' 1'
    ParentShowHint = False
    ShowHint = True
  end
  object edDay_holiday: TcxCurrencyEdit [11]
    Left = 8
    Top = 128
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 157
  end
  object cxLabel13: TcxLabel [12]
    Left = 182
    Top = 155
    Hint = '(-)% '#1057#1082#1080#1076#1082#1080' (+)% '#1053#1072#1094#1077#1085#1082#1080' '#1044#1086#1075'.'
    Caption = #1057#1091#1084#1084#1072' 2'
    ParentShowHint = False
    ShowHint = True
  end
  object edSummHoliday2_calc: TcxCurrencyEdit [13]
    Left = 181
    Top = 173
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 157
  end
  object cxLabel2: TcxLabel [14]
    Left = 181
    Top = 108
    Hint = '(-)% '#1057#1082#1080#1076#1082#1080' (+)% '#1053#1072#1094#1077#1085#1082#1080' '#1044#1086#1075'.'
    Caption = #1057#1088'.'#1047#1055' '#1079#1072' '#1076#1077#1085#1100
    ParentShowHint = False
    ShowHint = True
  end
  object edAmountCompensation: TcxCurrencyEdit [15]
    Left = 182
    Top = 128
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 157
  end
  object cxLabel3: TcxLabel [16]
    Left = 8
    Top = 200
    Caption = #8470' '#1076#1086#1082'. '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' 1'
  end
  object cxButtonEdit1: TcxButtonEdit [17]
    Left = 8
    Top = 220
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 331
  end
  object cxLabel4: TcxLabel [18]
    Left = 8
    Top = 247
    Caption = #8470' '#1076#1086#1082'. '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' 2'
  end
  object cxButtonEdit2: TcxButtonEdit [19]
    Left = 8
    Top = 263
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 331
  end
  object cxLabel5: TcxLabel [20]
    Left = 8
    Top = 292
    Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100
  end
  object edPersonalServiceList: TcxButtonEdit [21]
    Left = 8
    Top = 311
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 331
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 315
    Top = 95
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 320
    Top = 41
  end
  inherited ActionList: TActionList
    Left = 255
    Top = 207
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
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = Null
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 36
    Top = 300
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PersonalServiceByHoliday'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = Null
        Component = GuideMemberHoliday
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = 0d
        Component = FormParams
        ComponentItem = 'PersonalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalServiceListId'
        Value = ''
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_1'
        Value = '0'
        Component = GuidesPS1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_2'
        Value = '0'
        Component = GuidesPS2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummHoliday1'
        Value = Null
        Component = edSummHoliday1_calc
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummHoliday2'
        Value = Null
        Component = edSummHoliday2_calc
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountCompensation'
        Value = Null
        Component = edAmountCompensation
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inServiceDate1'
        Value = Null
        Component = FormParams
        ComponentItem = 'ServiceDate1'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inServiceDate2'
        Value = Null
        Component = FormParams
        ComponentItem = 'ServiceDate2'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMain'
        Value = Null
        Component = FormParams
        ComponentItem = 'isMain'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 224
    Top = 12
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_MemberHolidayForPersonalService'
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
        Name = 'Day_holiday'
        Value = Null
        Component = edDay_holiday
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountCompensation'
        Value = ''
        Component = edAmountCompensation
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummHoliday1_calc'
        Value = ''
        Component = edSummHoliday1_calc
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummHoliday2_calc'
        Value = ''
        Component = edSummHoliday2_calc
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalServiceListId'
        Value = ''
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        DataType = ftString
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
        Name = 'MovementId_PersonalService1'
        Value = Null
        Component = GuidesPS1
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full1'
        Value = ''
        Component = GuidesPS1
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_PersonalService2'
        Value = Null
        Component = GuidesPS2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full2'
        Value = Null
        Component = GuidesPS2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Color_SummHoliday1'
        Value = Null
        Component = FormParams
        ComponentItem = 'Color_SummHoliday1'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Color_SummHoliday2'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Color_SummHoliday2'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PositionId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceDateStart'
        Value = Null
        Component = FormParams
        ComponentItem = 'ServiceDate1'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceDateEnd'
        Value = Null
        Component = FormParams
        ComponentItem = 'ServiceDate2'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMain'
        Value = Null
        Component = FormParams
        ComponentItem = 'isMain'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 288
    Top = 12
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
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateOut_Holiday'
        Value = Null
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
    Left = 190
    Top = 53
  end
  object GuidesPS1: TdsdGuides
    KeyField = 'Id'
    LookupControl = cxButtonEdit1
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPersonalServiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalServiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPS1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPS1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 158
    Top = 200
  end
  object GuidesPS2: TdsdGuides
    KeyField = 'Id'
    LookupControl = cxButtonEdit2
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPersonalServiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalServiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPS2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPS2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 126
    Top = 248
  end
  object GuidesPersonalServiceList: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalServiceList
    isShowModal = True
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
      end
      item
        Name = 'JuridicalId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 168
    Top = 285
  end
end
