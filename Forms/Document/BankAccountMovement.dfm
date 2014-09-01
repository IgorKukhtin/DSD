inherited BankAccountMovementForm: TBankAccountMovementForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076'>'
  ClientHeight = 270
  ClientWidth = 542
  ExplicitWidth = 548
  ExplicitHeight = 295
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 146
    Top = 235
    ExplicitLeft = 146
    ExplicitTop = 235
  end
  inherited bbCancel: TcxButton
    Left = 290
    Top = 235
    ExplicitLeft = 290
    ExplicitTop = 235
  end
  object Код: TcxLabel [2]
    Left = 8
    Top = 5
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object cxLabel1: TcxLabel [3]
    Left = 148
    Top = 5
    Caption = #1044#1072#1090#1072
  end
  object ceOperDate: TcxDateEdit [4]
    Left = 148
    Top = 23
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 120
  end
  object cxLabel2: TcxLabel [5]
    Left = 288
    Top = 5
    Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
  end
  object ceBankAccount: TcxButtonEdit [6]
    Left = 276
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 260
  end
  object ceAmountIn: TcxCurrencyEdit [7]
    Left = 8
    Top = 68
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 5
    Width = 120
  end
  object cxLabel7: TcxLabel [8]
    Left = 8
    Top = 50
    Caption = #1055#1088#1080#1093#1086#1076', '#1089#1091#1084#1084#1072
  end
  object ceAmountOut: TcxCurrencyEdit [9]
    Left = 148
    Top = 68
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 6
    Width = 120
  end
  object cxLabel3: TcxLabel [10]
    Left = 148
    Top = 50
    Caption = #1056#1072#1089#1093#1086#1076', '#1089#1091#1084#1084#1072
  end
  object cxLabel6: TcxLabel [11]
    Left = 288
    Top = 50
    Caption = #1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091
  end
  object ceObject: TcxButtonEdit [12]
    Left = 276
    Top = 68
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 260
  end
  object cxLabel5: TcxLabel [13]
    Left = 8
    Top = 95
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object ceInfoMoney: TcxButtonEdit [14]
    Left = 8
    Top = 113
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 260
  end
  object ceContract: TcxButtonEdit [15]
    Left = 276
    Top = 115
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 260
  end
  object cxLabel8: TcxLabel [16]
    Left = 288
    Top = 95
    Caption = #1044#1086#1075#1086#1074#1086#1088
  end
  object cxLabel10: TcxLabel [17]
    Left = 8
    Top = 182
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [18]
    Left = 8
    Top = 200
    TabOrder = 12
    Width = 528
  end
  object cxLabel4: TcxLabel [19]
    Left = 288
    Top = 142
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object ceUnit: TcxButtonEdit [20]
    Left = 276
    Top = 158
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 260
  end
  object cxLabel9: TcxLabel [21]
    Left = 8
    Top = 141
    Caption = #1042#1072#1083#1102#1090#1072
  end
  object ceCurrency: TcxButtonEdit [22]
    Left = 8
    Top = 159
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 260
  end
  object edInvNumber: TcxTextEdit [23]
    Left = 8
    Top = 23
    Enabled = False
    Properties.ReadOnly = True
    TabOrder = 23
    Text = '0'
    Width = 118
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 131
    Top = 227
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 88
    Top = 227
  end
  inherited ActionList: TActionList
    Left = 183
    Top = 226
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
        Value = Null
        ParamType = ptInput
      end>
    Left = 88
    Top = 195
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_BankAccount'
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
        Name = 'inBankAccountId'
        Value = ''
        Component = BankAccountGuides
        ComponentItem = 'Key'
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
      end
      item
        Name = 'inCurrencyId'
        Value = ''
        Component = CurrencyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 456
    Top = 191
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_BankAccount'
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
        Value = Null
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
        Name = 'Comment'
        Value = ''
        Component = ceComment
        DataType = ftString
      end
      item
        Name = 'BankAccountId'
        Value = ''
        Component = BankAccountGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'BankAccountName'
        Value = ''
        Component = BankAccountGuides
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
      end
      item
        Name = 'CurrencyId'
        Value = ''
        Component = CurrencyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'CurrencyName'
        Value = ''
        Component = CurrencyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 408
    Top = 191
  end
  object BankAccountGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBankAccount
    FormNameParam.Value = 'TBankAccountForm'
    FormNameParam.DataType = ftString
    FormName = 'TBankAccountForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BankAccountGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BankAccountGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'CurrencyId'
        Value = ''
        Component = CurrencyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'CurrencyName'
        Value = ''
        Component = CurrencyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 428
    Top = 5
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
      end>
    Left = 420
    Top = 61
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
      end
      item
        Name = 'inPaidKindId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inPaidKindId'
      end>
    Left = 420
    Top = 110
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
    Left = 492
    Top = 141
  end
  object CurrencyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCurrency
    FormNameParam.Value = 'TCurrencyForm'
    FormNameParam.DataType = ftString
    FormName = 'TCurrencyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = CurrencyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CurrencyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 176
    Top = 165
  end
end
