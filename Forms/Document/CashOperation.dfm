inherited CashOperationForm: TCashOperationForm
  ActiveControl = ceAmountIn
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076'>'
  ClientHeight = 275
  ClientWidth = 569
  AddOnFormData.isSingle = False
  ExplicitWidth = 575
  ExplicitHeight = 300
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 168
    Top = 240
    ExplicitLeft = 168
    ExplicitTop = 240
  end
  inherited bbCancel: TcxButton
    Left = 312
    Top = 240
    ExplicitLeft = 312
    ExplicitTop = 240
  end
  object cxLabel1: TcxLabel [2]
    Left = 130
    Top = 5
    Caption = #1044#1072#1090#1072
  end
  object Код: TcxLabel [3]
    Left = 15
    Top = 5
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object cxLabel2: TcxLabel [4]
    Left = 430
    Top = 5
    Caption = #1050#1072#1089#1089#1072
  end
  object cxLabel4: TcxLabel [5]
    Left = 15
    Top = 140
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object cxLabel5: TcxLabel [6]
    Left = 245
    Top = 140
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object ceCash: TcxButtonEdit [7]
    Left = 430
    Top = 25
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 120
  end
  object ceUnit: TcxButtonEdit [8]
    Left = 15
    Top = 160
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 215
  end
  object ceInfoMoney: TcxButtonEdit [9]
    Left = 245
    Top = 160
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 305
  end
  object ceOperDate: TcxDateEdit [10]
    Left = 130
    Top = 25
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 100
  end
  object ceAmountIn: TcxCurrencyEdit [11]
    Left = 15
    Top = 70
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 6
    Width = 100
  end
  object cxLabel7: TcxLabel [12]
    Left = 15
    Top = 50
    Caption = #1055#1088#1080#1093#1086#1076', '#1089#1091#1084#1084#1072
  end
  object ceObject: TcxButtonEdit [13]
    Left = 245
    Top = 115
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 305
  end
  object cxLabel6: TcxLabel [14]
    Left = 245
    Top = 95
    Caption = #1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091
  end
  object cxLabel10: TcxLabel [15]
    Left = 15
    Top = 185
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [16]
    Left = 15
    Top = 205
    TabOrder = 10
    Width = 535
  end
  object cxLabel8: TcxLabel [17]
    Left = 430
    Top = 50
    Caption = #1044#1086#1075#1086#1074#1086#1088
  end
  object ceContract: TcxButtonEdit [18]
    Left = 430
    Top = 70
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 120
  end
  object cxLabel3: TcxLabel [19]
    Left = 130
    Top = 50
    Caption = #1056#1072#1089#1093#1086#1076', '#1089#1091#1084#1084#1072
  end
  object ceAmountOut: TcxCurrencyEdit [20]
    Left = 130
    Top = 70
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 7
    Width = 100
  end
  object edInvNumber: TcxTextEdit [21]
    Left = 15
    Top = 25
    Enabled = False
    Properties.ReadOnly = True
    TabOrder = 21
    Text = '0'
    Width = 100
  end
  object cxLabel9: TcxLabel [22]
    Left = 245
    Top = 50
    Caption = #1060#1048#1054' ('#1095#1077#1088#1077#1079' '#1082#1086#1075#1086')'
  end
  object ceMember: TcxButtonEdit [23]
    Left = 245
    Top = 70
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 170
  end
  object cxLabel11: TcxLabel [24]
    Left = 15
    Top = 95
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082' '#1079'/'#1087')'
  end
  object cePosition: TcxButtonEdit [25]
    Left = 15
    Top = 115
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 25
    Width = 215
  end
  object cxLabel12: TcxLabel [26]
    Left = 245
    Top = 5
    Caption = #1052#1077#1089#1103#1094' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
  end
  object ceServiceDate: TcxDateEdit [27]
    Left = 245
    Top = 25
    EditValue = 41640d
    Properties.DisplayFormat = 'mmmm yyyy'
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 27
    Width = 170
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 230
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 24
    Top = 230
  end
  inherited ActionList: TActionList
    Left = 95
    Top = 229
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides [0]
    end
    inherited actRefresh: TdsdDataSetRefresh [1]
    end
    inherited FormClose: TdsdFormClose [2]
    end
  end
  inherited FormParams: TdsdFormParams
    Left = 128
    Top = 230
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Cash'
    Params = <
      item
        Name = 'ioid'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inInvNumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inServiceDate'
        Value = 41640d
        Component = ceServiceDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inAmountIn'
        Value = 0.000000000000000000
        Component = ceAmountIn
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inAmountOut'
        Value = 0.000000000000000000
        Component = ceAmountOut
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inCashId'
        Value = ''
        Component = CashGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inMoneyPlaceId'
        Value = ''
        Component = ObjectlGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPositionId'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'PositionId'
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
        Name = 'inContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 456
    Top = 230
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Cash'
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
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
        Name = 'inCashId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inCashId_top'
        ParamType = ptInput
      end
      item
        Name = 'InvNumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
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
        Component = ceAmountIn
        DataType = ftFloat
      end
      item
        Name = 'AmountOut'
        Value = 0.000000000000000000
        Component = ceAmountOut
        DataType = ftFloat
      end
      item
        Name = 'ServiceDate'
        Value = 41640d
        Component = ceServiceDate
        DataType = ftDateTime
      end
      item
        Name = 'Comment'
        Value = ''
        Component = ceComment
        DataType = ftString
      end
      item
        Name = 'CashId'
        Value = ''
        Component = CashGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'CashName'
        Value = ''
        Component = CashGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'MoneyPlaceId'
        Value = ''
        Component = ObjectlGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'MoneyPlaceName'
        Value = ''
        Component = ObjectlGuides
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
        Name = 'PositionId'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'PositionId'
      end
      item
        Name = 'PositionName'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'PositionName'
        DataType = ftString
      end
      item
        Name = 'ContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ContractInvNumber'
        Value = ''
        Component = ContractGuides
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
      end>
    Left = 408
    Top = 230
  end
  object CashGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCash
    FormNameParam.Value = 'TCash_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TCash_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = CashGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CashGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 480
    Top = 5
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
    Left = 104
    Top = 149
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
    Left = 376
    Top = 157
  end
  object ObjectlGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceObject
    FormNameParam.Value = 'TMoneyPlaceCash_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TMoneyPlaceCash_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ObjectlGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ObjectlGuides
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
        Name = 'InfoMoneyName_all'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ContractName'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PositionId'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PositionName'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 368
    Top = 93
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <
      item
        Guides = CashGuides
      end>
    ActionItemList = <>
    Left = 504
    Top = 230
  end
  object ContractGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceContract
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = ObjectlGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = ObjectlGuides
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
        Name = 'InfoMoneyName_all'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 480
    Top = 54
  end
  object PersonalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ObjectlGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ObjectlGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PositionId'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PositionName'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'TextValue'
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
      end
      item
        Name = 'ContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ContractName'
        Value = ''
        Component = ContractGuides
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
        Name = 'InfoMoneyName_all'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 152
    Top = 125
  end
  object MemberGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMember
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 344
    Top = 45
  end
end
