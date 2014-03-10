inherited CashOperationForm: TCashOperationForm
  ActiveControl = ceAmountIn
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076'>'
  ClientHeight = 236
  ClientWidth = 562
  AddOnFormData.isSingle = False
  ExplicitWidth = 568
  ExplicitHeight = 268
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 163
    Top = 196
    ExplicitLeft = 163
    ExplicitTop = 196
  end
  inherited bbCancel: TcxButton
    Left = 307
    Top = 196
    ExplicitLeft = 307
    ExplicitTop = 196
  end
  object cxLabel1: TcxLabel [2]
    Left = 148
    Top = 5
    Caption = #1044#1072#1090#1072
  end
  object Код: TcxLabel [3]
    Left = 8
    Top = 5
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object ceInvNumber: TcxCurrencyEdit [4]
    Left = 8
    Top = 23
    Enabled = False
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 2
    Width = 120
  end
  object cxLabel2: TcxLabel [5]
    Left = 288
    Top = 5
    Caption = #1050#1072#1089#1089#1072
  end
  object cxLabel4: TcxLabel [6]
    Left = 288
    Top = 142
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object cxLabel5: TcxLabel [7]
    Left = 8
    Top = 95
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object ceCash: TcxButtonEdit [8]
    Left = 288
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 4
    Width = 260
  end
  object ceUnit: TcxButtonEdit [9]
    Left = 288
    Top = 158
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 260
  end
  object ceInfoMoney: TcxButtonEdit [10]
    Left = 8
    Top = 113
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 10
    Width = 260
  end
  object ceOperDate: TcxDateEdit [11]
    Left = 148
    Top = 23
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 120
  end
  object ceAmountIn: TcxCurrencyEdit [12]
    Left = 8
    Top = 68
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 7
    Width = 120
  end
  object cxLabel7: TcxLabel [13]
    Left = 8
    Top = 50
    Caption = #1055#1088#1080#1093#1086#1076', '#1089#1091#1084#1084#1072
  end
  object ceObject: TcxButtonEdit [14]
    Left = 288
    Top = 68
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 6
    Width = 260
  end
  object cxLabel6: TcxLabel [15]
    Left = 288
    Top = 50
    Caption = #1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091
  end
  object cxLabel10: TcxLabel [16]
    Left = 10
    Top = 140
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [17]
    Left = 10
    Top = 158
    TabOrder = 11
    Width = 258
  end
  object cxLabel8: TcxLabel [18]
    Left = 288
    Top = 95
    Caption = #1044#1086#1075#1086#1074#1086#1088
  end
  object ceContract: TcxButtonEdit [19]
    Left = 288
    Top = 115
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 5
    Width = 260
  end
  object cxLabel3: TcxLabel [20]
    Left = 148
    Top = 50
    Caption = #1056#1072#1089#1093#1086#1076', '#1089#1091#1084#1084#1072
  end
  object ceAmountOut: TcxCurrencyEdit [21]
    Left = 148
    Top = 68
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 8
    Width = 120
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 192
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 24
    Top = 192
  end
  inherited ActionList: TActionList
    Left = 95
    Top = 191
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
        Name = 'inPaidKindId'
        Value = '4'
        ParamType = ptInput
      end>
    Left = 128
    Top = 192
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
        Name = 'ininvnumber'
        Value = 0.000000000000000000
        Component = ceInvNumber
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
        Name = 'inamountin'
        Value = 0.000000000000000000
        Component = ceAmountIn
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inamountout'
        Value = 0.000000000000000000
        Component = ceAmountOut
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
        Name = 'incontactid'
        Value = ''
        Component = ContractGuides
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
      end>
    Left = 456
    Top = 191
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
        Name = 'invnumber'
        Value = 0.000000000000000000
        Component = ceInvNumber
        DataType = ftString
      end
      item
        Name = 'operdate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
      end
      item
        Name = 'amountin'
        Value = 0.000000000000000000
        Component = ceAmountIn
        DataType = ftFloat
      end
      item
        Name = 'amountout'
        Value = 0.000000000000000000
        Component = ceAmountOut
        DataType = ftFloat
      end
      item
        Name = 'comment'
        Value = ''
        Component = ceComment
        DataType = ftString
      end
      item
        Name = 'cashid'
        Value = ''
        Component = CashGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'cashname'
        Value = ''
        Component = CashGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'moneyplaceid'
        Value = ''
        Component = ObjectlGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'moneyplacename'
        Value = ''
        Component = ObjectlGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'infomoneyid'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'infomoneyname'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'contractid'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'contractinvnumber'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'unitid'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'unitname'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 408
    Top = 191
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
    Left = 416
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
    Left = 480
    Top = 141
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
    Left = 136
    Top = 109
  end
  object ObjectlGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceObject
    FormNameParam.Value = 'TMoneyPlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TMoneyPlace_ObjectForm'
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
        Name = 'InfoMoneyName'
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
      end>
    Left = 408
    Top = 61
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <
      item
        Guides = CashGuides
      end
      item
        Guides = InfoMoneyGuides
      end>
    ActionItemList = <>
    Left = 504
    Top = 191
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
        Name = 'InfoMoneyName'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'inPaidKindId'
        Value = '4'
        Component = FormParams
        ComponentItem = 'inPaidKindId'
      end>
    Left = 408
    Top = 110
  end
end
