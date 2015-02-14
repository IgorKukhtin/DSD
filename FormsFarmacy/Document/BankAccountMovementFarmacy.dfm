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
  inherited cxLabel5: TcxLabel
    Top = 210
    Visible = False
    ExplicitTop = 210
  end
  inherited ceInfoMoney: TcxButtonEdit
    Top = 230
    Visible = False
    ExplicitTop = 230
  end
  inherited ceContract: TcxButtonEdit
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
    ExplicitTop = 182
  end
  inherited cxLabel9: TcxLabel
    Visible = False
  end
  inherited ceCurrency: TcxButtonEdit
    Visible = False
  end
  inherited cxLabel11: TcxLabel
    Visible = False
  end
  inherited ceCurrencyPartnerValue: TcxCurrencyEdit
    Visible = False
  end
  inherited cxLabel12: TcxLabel
    Visible = False
  end
  inherited ceParPartnerValue: TcxCurrencyEdit
    Visible = False
  end
  inherited cxLabel4: TcxLabel
    Visible = False
  end
  inherited ceAmountSumm: TcxCurrencyEdit
    Visible = False
  end
  object cxLabel14: TcxLabel [30]
    Left = 280
    Top = 117
    Caption = #8470' '#1087#1088#1080#1093#1086#1076#1072
  end
  object edIncome: TcxButtonEdit [31]
    Left = 280
    Top = 135
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 31
    Width = 291
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
  object GuidesIncome: TdsdGuides
    KeyField = 'Id'
    LookupControl = edIncome
    isShowModal = True
    FormNameParam.Value = 'TIncomeJournalForm'
    FormNameParam.DataType = ftString
    FormName = 'TIncomeJournalForm'
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
      end>
    Left = 296
    Top = 144
  end
end
