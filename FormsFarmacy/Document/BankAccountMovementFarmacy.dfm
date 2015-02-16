inherited BankAccountMovementFarmacyForm: TBankAccountMovementFarmacyForm
  Caption = #1054#1087#1077#1088#1072#1094#1080#1080' '#1089' '#1088#1072#1089#1095#1077#1090#1085#1099#1084' '#1089#1095#1077#1090#1086#1084
  ClientHeight = 266
  ExplicitHeight = 291
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Top = 227
    ExplicitTop = 227
  end
  inherited bbCancel: TcxButton
    Top = 227
    ExplicitTop = 227
  end
  inherited cxLabel6: TcxLabel
    Left = 280
    ExplicitLeft = 280
  end
  inherited ceObject: TcxButtonEdit
    Left = 280
    TabOrder = 8
    ExplicitLeft = 280
  end
  inherited cxLabel5: TcxLabel
    Top = 210
    Visible = False
    ExplicitTop = 210
  end
  inherited ceInfoMoney: TcxButtonEdit
    Top = 230
    TabOrder = 9
    Visible = False
    ExplicitTop = 230
  end
  inherited ceContract: TcxButtonEdit
    TabOrder = 11
    Visible = False
  end
  inherited cxLabel8: TcxLabel
    Visible = False
  end
  inherited cxLabel10: TcxLabel
    Top = 162
    ExplicitTop = 162
  end
  inherited ceComment: TcxTextEdit
    Top = 182
    TabOrder = 12
    ExplicitTop = 182
  end
  inherited cxLabel9: TcxLabel
    Visible = False
  end
  inherited ceCurrency: TcxButtonEdit
    TabOrder = 10
    Visible = False
  end
  inherited edInvNumber: TcxTextEdit
    TabOrder = 22
  end
  inherited cxLabel11: TcxLabel
    Visible = False
  end
  inherited ceCurrencyPartnerValue: TcxCurrencyEdit
    TabOrder = 24
    Visible = False
  end
  inherited cxLabel12: TcxLabel
    Visible = False
  end
  inherited ceParPartnerValue: TcxCurrencyEdit
    TabOrder = 26
    Visible = False
  end
  inherited ceBank: TcxButtonEdit
    TabOrder = 27
  end
  inherited cxLabel4: TcxLabel
    Visible = False
  end
  inherited ceAmountSumm: TcxCurrencyEdit
    TabOrder = 30
    Visible = False
  end
  object cxLabel14: TcxLabel [30]
    Left = 8
    Top = 117
    Caption = #8470' '#1087#1088#1080#1093#1086#1076#1072
  end
  object edIncome: TcxButtonEdit [31]
    Left = 8
    Top = 135
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 259
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 91
    Top = 192
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 48
    Top = 192
  end
  inherited ActionList: TActionList
    Left = 143
    Top = 191
  end
  inherited FormParams: TdsdFormParams
    Left = 48
    Top = 160
  end
  inherited spInsertUpdate: TdsdStoredProc
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
        Name = 'inAmountSumm'
        Value = 0.000000000000000000
        Component = ceAmountSumm
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
        Name = 'inIncomeMovementId'
        Value = Null
        Component = GuidesIncome
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
        Name = 'inCurrencyId'
        Value = ''
        Component = CurrencyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inCurrencyPartnerValue'
        Value = 0.000000000000000000
        Component = ceCurrencyPartnerValue
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inParPartnerValue'
        Value = 1.000000000000000000
        Component = ceParPartnerValue
        DataType = ftFloat
        ParamType = ptInput
      end>
    Top = 204
  end
  inherited spGet: TdsdStoredProc
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
        Value = Null
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
        Name = 'AmountSumm'
        Value = 0.000000000000000000
        Component = ceAmountSumm
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
      end
      item
        Name = 'BankId'
        Value = ''
        Component = BankGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'BankName'
        Value = ''
        Component = BankGuides
        ComponentItem = 'TextValue'
      end
      item
        Name = 'CurrencyPartnerValue'
        Value = 0.000000000000000000
        Component = ceCurrencyPartnerValue
        DataType = ftFloat
      end
      item
        Name = 'ParPartnerValue'
        Value = 1.000000000000000000
        Component = ceParPartnerValue
        DataType = ftFloat
      end
      item
        Name = 'IncomeId'
        Value = Null
        Component = GuidesIncome
        ComponentItem = 'Key'
      end
      item
        Name = 'IncomeInvNumber'
        Value = Null
        Component = GuidesIncome
        ComponentItem = 'TextValue'
      end>
    Left = 400
    Top = 196
  end
  inherited ObjectlGuides: TdsdGuides
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
      end>
    Left = 340
    Top = 141
  end
  object GuidesIncome: TdsdGuides
    KeyField = 'Id'
    LookupControl = edIncome
    isShowModal = True
    FormNameParam.Value = 'TIncomeJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormName = 'TIncomeJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesIncome
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesIncome
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'JuridicalId'
        Value = Null
        Component = ObjectlGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = ObjectlGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 192
    Top = 136
  end
end
