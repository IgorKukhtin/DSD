inherited PersonalReportForm: TPersonalReportForm
  ActiveControl = ceAmountDebet
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1056#1072#1089#1093#1086#1076' '#1076#1077#1085#1077#1075' '#1089' '#1087#1086#1076#1086#1090#1095#1077#1090#1072' ('#1072#1074#1072#1085#1089#1086#1074#1099#1081' '#1086#1090#1095#1077#1090')>'
  ClientHeight = 287
  ClientWidth = 605
  AddOnFormData.isSingle = False
  ExplicitWidth = 611
  ExplicitHeight = 319
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 167
    Top = 251
    Height = 26
    ExplicitLeft = 167
    ExplicitTop = 251
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 311
    Top = 251
    Height = 26
    ExplicitLeft = 311
    ExplicitTop = 251
    ExplicitHeight = 26
  end
  object cxLabel1: TcxLabel [2]
    Left = 152
    Top = 11
    Caption = #1044#1072#1090#1072
  end
  object Код: TcxLabel [3]
    Left = 8
    Top = 11
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object cxLabel4: TcxLabel [4]
    Left = 300
    Top = 155
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object cxLabel5: TcxLabel [5]
    Left = 300
    Top = 110
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object ceUnit: TcxButtonEdit [6]
    Left = 300
    Top = 172
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 300
  end
  object ceInfoMoney: TcxButtonEdit [7]
    Left = 300
    Top = 128
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 300
  end
  object ceOperDate: TcxDateEdit [8]
    Left = 152
    Top = 34
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 129
  end
  object ceAmountDebet: TcxCurrencyEdit [9]
    Left = 293
    Top = 34
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 3
    Width = 142
  end
  object cxLabel7: TcxLabel [10]
    Left = 293
    Top = 11
    Caption = #1044#1077#1073#1077#1090', '#1089#1091#1084#1084#1072' ('#1084#1099' '#1086#1082#1072#1079#1072#1083#1080')'
  end
  object cxLabel10: TcxLabel [11]
    Left = 10
    Top = 190
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [12]
    Left = 8
    Top = 213
    TabOrder = 7
    Width = 593
  end
  object ceAmountKredit: TcxCurrencyEdit [13]
    Left = 447
    Top = 34
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 4
    Width = 152
  end
  object cxLabel3: TcxLabel [14]
    Left = 447
    Top = 11
    Caption = #1050#1088#1077#1076#1080#1090', '#1089#1091#1084#1084#1072' ('#1084#1099' '#1087#1086#1083#1091#1095#1080#1083#1080')'
  end
  object edInvNumber: TcxTextEdit [15]
    Left = 8
    Top = 34
    Enabled = False
    Properties.ReadOnly = True
    TabOrder = 15
    Text = '0'
    Width = 118
  end
  object cxLabel6: TcxLabel [16]
    Left = 8
    Top = 67
    Caption = #1060#1048#1054
  end
  object ceMember: TcxButtonEdit [17]
    Left = 8
    Top = 84
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 273
  end
  object edCar: TcxButtonEdit [18]
    Left = 8
    Top = 128
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 18
    Width = 273
  end
  object cxLabel2: TcxLabel [19]
    Left = 8
    Top = 110
    Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100' '
  end
  object ceMoneyPlace: TcxButtonEdit [20]
    Left = 300
    Top = 83
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 20
    Width = 300
  end
  object cxLabel8: TcxLabel [21]
    Left = 300
    Top = 61
    Caption = #1054#1073#1098#1077#1082#1090
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 11
    Top = 242
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 104
    Top = 242
  end
  inherited ActionList: TActionList
    Left = 423
    Top = 217
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
      end
      item
        Name = 'inMovementId_Value'
        Value = '0'
        ParamType = ptInput
      end>
    Left = 56
    Top = 242
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PersonalReport'
    Params = <
      item
        Name = 'ioid'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'ininvnumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inoperdate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inamountIn'
        Value = 0.000000000000000000
        Component = ceAmountDebet
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inamountOut'
        Value = 0.000000000000000000
        Component = ceAmountKredit
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'incomment'
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inMemberId'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'ininfomoneyid'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inunitid'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inMoneyPlaceId'
        Value = ''
        Component = MoneyPlaceGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inCarId'
        Value = ''
        Component = GuidesCar
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = 0d
        DataType = ftDateTime
        ParamType = ptUnknown
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end>
    Left = 488
    Top = 224
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_PersonalReport'
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inMovementId_Value'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inMovementId_Value'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'Id'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
      end
      item
        Name = 'InvNumber'
        Value = '0'
        Component = edInvNumber
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
      end
      item
        Name = 'AmountIn'
        Value = 0.000000000000000000
        Component = ceAmountDebet
        DataType = ftFloat
      end
      item
        Name = 'AmountOut'
        Value = 0.000000000000000000
        Component = ceAmountKredit
        DataType = ftFloat
      end
      item
        Name = 'Comment'
        Value = ''
        Component = ceComment
        DataType = ftString
      end
      item
        Name = 'MemberId'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'MemberName'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'MoneyPlaceId'
        Value = ''
        Component = MoneyPlaceGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'MoneyPlaceName'
        Value = ''
        Component = MoneyPlaceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CarId'
        Value = ''
        Component = GuidesCar
        ComponentItem = 'Key'
      end
      item
        Name = 'CarName'
        Value = ''
        Component = GuidesCar
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = Null
        DataType = ftDateTime
        ParamType = ptUnknown
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end>
    Left = 544
    Top = 216
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 398
    Top = 147
  end
  object InfoMoneyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 470
    Top = 113
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <
      item
        Guides = MemberGuides
      end
      item
        Guides = MoneyPlaceGuides
      end
      item
        Guides = UnitGuides
      end
      item
        Guides = InfoMoneyGuides
      end>
    ActionItemList = <>
    Left = 232
    Top = 40
  end
  object MemberGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMember
    FormNameParam.Value = 'TMemberForm'
    FormNameParam.DataType = ftString
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        ComponentItem = 'Code'
      end>
    Left = 93
    Top = 72
  end
  object GuidesCar: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCar
    FormNameParam.Value = 'TCarForm'
    FormNameParam.DataType = ftString
    FormName = 'TCarForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCar
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCar
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 122
    Top = 123
  end
  object MoneyPlaceGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMoneyPlace
    FormNameParam.Value = 'TMoneyPlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TMoneyPlace_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MoneyPlaceGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MoneyPlaceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 426
    Top = 70
  end
end
