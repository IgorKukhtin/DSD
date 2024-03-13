inherited BankSecondNumForm: TBankSecondNumForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103' '#1087#1086' '#1073#1072#1085#1082#1072#1084' '#1047#1055' - '#1060'2>'
  ClientHeight = 317
  ClientWidth = 512
  ExplicitWidth = 518
  ExplicitHeight = 346
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 146
    Top = 280
    ExplicitLeft = 146
    ExplicitTop = 280
  end
  inherited bbCancel: TcxButton
    Left = 290
    Top = 280
    ExplicitLeft = 290
    ExplicitTop = 280
  end
  object Код: TcxLabel [2]
    Left = 8
    Top = 5
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object cxLabel1: TcxLabel [3]
    Left = 147
    Top = 8
    Caption = #1052#1077#1089#1103#1094' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1047#1055
  end
  object ceOperDate: TcxDateEdit [4]
    Left = 147
    Top = 25
    EditValue = 45361d
    Properties.DisplayFormat = 'mmmm yyyy'
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 120
  end
  object ceBankSecondDiff_num: TcxCurrencyEdit [5]
    Left = 289
    Top = 185
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0.'
    TabOrder = 4
    Width = 215
  end
  object cxLabel7: TcxLabel [6]
    Left = 289
    Top = 162
    Caption = #8470' '#1087#1086' '#1087#1088#1080#1086#1088#1080#1090#1077#1090#1091' '#1076#1083#1103' '#1041#1072#1085#1082' - 2'#1092'.('#1083#1080#1095#1085#1099#1081')'
  end
  object ceBankSecondTwo_num: TcxCurrencyEdit [7]
    Left = 289
    Top = 135
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0.'
    TabOrder = 5
    Width = 215
  end
  object cxLabel3: TcxLabel [8]
    Left = 289
    Top = 112
    Caption = #8470' '#1087#1086' '#1087#1088#1080#1086#1088#1080#1090#1077#1090#1091' '#1076#1083#1103' '#1041#1072#1085#1082' - 2'#1092'.('#1054#1058#1055') '
  end
  object cxLabel10: TcxLabel [9]
    Left = 289
    Top = 216
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [10]
    Left = 289
    Top = 237
    TabOrder = 6
    Width = 215
  end
  object edInvNumber: TcxTextEdit [11]
    Left = 8
    Top = 25
    Properties.ReadOnly = True
    TabOrder = 11
    Text = '0'
    Width = 118
  end
  object cxLabel11: TcxLabel [12]
    Left = 289
    Top = 60
    Caption = #8470' '#1087#1086' '#1087#1088#1080#1086#1088#1080#1090#1077#1090#1091' '#1076#1083#1103' '#1041#1072#1085#1082' - 2'#1092'.('#1042#1086#1089#1090#1086#1082')'
  end
  object ceBankSecond_num: TcxCurrencyEdit [13]
    Left = 289
    Top = 83
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0.'
    Properties.ReadOnly = False
    TabOrder = 13
    Width = 215
  end
  object cxLabel13: TcxLabel [14]
    Left = 8
    Top = 60
    Caption = #1041#1072#1085#1082' - 2'#1092'.('#1042#1086#1089#1090#1086#1082')'
  end
  object edBankSecond_num: TcxButtonEdit [15]
    Left = 8
    Top = 83
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 259
  end
  object cxLabel4: TcxLabel [16]
    Left = 8
    Top = 112
    Caption = #1041#1072#1085#1082' - 2'#1092'.('#1054#1058#1055')'
  end
  object edBankSecondTwo_num: TcxButtonEdit [17]
    Left = 8
    Top = 135
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 259
  end
  object cxLabel2: TcxLabel [18]
    Left = 8
    Top = 162
    Caption = #1041#1072#1085#1082' - 2'#1092'.('#1083#1080#1095#1085#1099#1081')'
  end
  object edBankSecondDiff_num: TcxButtonEdit [19]
    Left = 8
    Top = 185
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 259
  end
  object cxLabel30: TcxLabel [20]
    Left = 8
    Top = 216
    Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099
  end
  object edInvNumberPersonalService: TcxButtonEdit [21]
    Left = 8
    Top = 237
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 259
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 131
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 88
  end
  inherited ActionList: TActionList
    Left = 183
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
        Name = 'inMovementId_Value'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_PersonalService'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 248
    Top = 272
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_BankSecondNum'
    Params = <
      item
        Name = 'ioid'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ininvnumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inoperdate'
        Value = 0d
        Component = FormParams
        ComponentItem = 'operdate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_PersonalService'
        Value = Null
        Component = GuidesPersonalService
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankSecondId_num'
        Value = ''
        Component = GuidesBankSecond_num
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankSecondTwoId_num'
        Value = ''
        Component = GuidesBankSecondTwo_num
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankSecondDiffId_num'
        Value = ''
        Component = GuidesBankSecondDiff_num
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankSecond_num'
        Value = Null
        Component = ceBankSecond_num
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankSecondTwo_num'
        Value = 0.000000000000000000
        Component = ceBankSecondTwo_num
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankSecondDiff_num'
        Value = 0.000000000000000000
        Component = ceBankSecondDiff_num
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'incomment'
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 408
    Top = 224
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_BankSecondNum'
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
        Name = 'inMovementId_PersonalService'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId_PersonalService'
        ParamType = ptInput
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
        Name = 'InvNumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = FormParams
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceDate'
        Value = Null
        Component = ceOperDate
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankSecond_num'
        Value = Null
        Component = ceBankSecond_num
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankSecondTwo_num'
        Value = 0.000000000000000000
        Component = ceBankSecondTwo_num
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankSecondDiff_num'
        Value = 0.000000000000000000
        Component = ceBankSecondDiff_num
        DataType = ftFloat
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
        Name = 'BankSecondId_num'
        Value = Null
        Component = GuidesBankSecond_num
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankSecondName_num'
        Value = Null
        Component = GuidesBankSecond_num
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankSecondTwoId_num'
        Value = ''
        Component = GuidesBankSecondTwo_num
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankSecondTwoName_num'
        Value = Null
        Component = GuidesBankSecondTwo_num
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankSecondDiffId_num'
        Value = Null
        Component = GuidesBankSecondDiff_num
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankSecondDiffName_num'
        Value = Null
        Component = GuidesBankSecondDiff_num
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_PersonalService'
        Value = Null
        Component = GuidesPersonalService
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_PersonalService'
        Value = Null
        Component = GuidesPersonalService
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 336
    Top = 228
  end
  object GuidesBankSecond_num: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBankSecond_num
    FormNameParam.Value = 'TBankForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBankSecond_num
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBankSecond_num
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 90
  end
  object GuidesBankSecondTwo_num: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBankSecondTwo_num
    FormNameParam.Value = 'TBankForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBankSecondTwo_num
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBankSecondTwo_num
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 126
  end
  object GuidesBankSecondDiff_num: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBankSecondDiff_num
    FormNameParam.Value = 'TBankForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBankSecondDiff_num
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBankSecondDiff_num
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 120
    Top = 174
  end
  object GuidesPersonalService: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberPersonalService
    Key = '0'
    FormNameParam.Value = 'TPersonalServiceJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalServiceJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesPersonalService
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesPersonalService
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 153
    Top = 214
  end
end
