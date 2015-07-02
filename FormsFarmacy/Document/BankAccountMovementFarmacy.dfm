inherited BankAccountMovementFarmacyForm: TBankAccountMovementFarmacyForm
  Caption = #1054#1087#1077#1088#1072#1094#1080#1080' '#1089' '#1088#1072#1089#1095#1077#1090#1085#1099#1084' '#1089#1095#1077#1090#1086#1084
  ClientHeight = 356
  ExplicitHeight = 381
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 170
    Top = 323
    ExplicitLeft = 170
    ExplicitTop = 323
  end
  inherited bbCancel: TcxButton
    Left = 314
    Top = 323
    ExplicitLeft = 314
    ExplicitTop = 323
  end
  inherited cxLabel6: TcxLabel
    Left = 8
    ExplicitLeft = 8
  end
  inherited ceObject: TcxButtonEdit
    Left = 8
    Top = 178
    TabOrder = 8
    ExplicitLeft = 8
    ExplicitTop = 178
  end
  inherited cxLabel5: TcxLabel
    Left = 10
    Top = 252
    Visible = False
    ExplicitLeft = 10
    ExplicitTop = 252
  end
  inherited ceInfoMoney: TcxButtonEdit
    Left = 10
    Top = 272
    TabOrder = 9
    Visible = False
    ExplicitLeft = 10
    ExplicitTop = 272
  end
  inherited ceContract: TcxButtonEdit
    TabOrder = 11
    Visible = False
  end
  inherited cxLabel8: TcxLabel
    Visible = False
  end
  inherited cxLabel10: TcxLabel
    Left = 10
    Top = 205
    ExplicitLeft = 10
    ExplicitTop = 205
  end
  inherited ceComment: TcxTextEdit
    Left = 10
    Top = 225
    TabOrder = 12
    ExplicitLeft = 10
    ExplicitTop = 225
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
    TabOrder = 31
    Visible = False
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
  object cxLabel15: TcxLabel [33]
    Left = 8
    Top = 162
    Caption = #8470' '#1087#1088#1080#1093#1086#1076#1072
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 91
    Top = 200
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 50
    Top = 219
  end
  inherited ActionList: TActionList
    Left = 143
    Top = 191
  end
  inherited FormParams: TdsdFormParams
    Left = 50
    Top = 187
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
    Left = 504
    Top = 268
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
    Left = 464
    Top = 268
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
    Left = 260
    Top = 173
  end
  inherited InfoMoneyGuides: TdsdGuides
    Left = 336
    Top = 266
  end
  inherited ContractGuides: TdsdGuides
    Left = 364
    Top = 123
  end
  inherited BankGuides: TdsdGuides
    Left = 528
    Top = 10
  end
  inherited UnitGuides: TdsdGuides
    Left = 528
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
    Left = 216
    Top = 120
  end
end
