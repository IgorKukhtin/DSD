inherited BankAccountMovementFarmacyForm: TBankAccountMovementFarmacyForm
  Caption = #1054#1087#1077#1088#1072#1094#1080#1080' '#1089' '#1088#1072#1089#1095#1077#1090#1085#1099#1084' '#1089#1095#1077#1090#1086#1084
  ClientHeight = 447
  ExplicitHeight = 475
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 170
    Top = 403
    TabOrder = 17
    ExplicitLeft = 170
    ExplicitTop = 403
  end
  inherited bbCancel: TcxButton
    Left = 314
    Top = 403
    TabOrder = 18
    ExplicitLeft = 314
    ExplicitTop = 403
  end
  inherited ceOperDate: TcxDateEdit
    TabOrder = 1
  end
  inherited ceBankAccount: TcxButtonEdit
    TabOrder = 2
  end
  inherited ceAmountIn: TcxCurrencyEdit
    TabOrder = 4
    Visible = False
  end
  inherited cxLabel7: TcxLabel
    Visible = False
  end
  inherited ceAmountOut: TcxCurrencyEdit
    TabOrder = 5
  end
  inherited cxLabel6: TcxLabel
    Left = 10
    Top = 242
    ExplicitLeft = 10
    ExplicitTop = 242
  end
  inherited ceObject: TcxButtonEdit
    Left = 10
    Top = 262
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    TabOrder = 14
    ExplicitLeft = 10
    ExplicitTop = 262
  end
  inherited cxLabel5: TcxLabel
    Left = 10
    Top = 332
    Visible = False
    ExplicitLeft = 10
    ExplicitTop = 332
  end
  inherited ceInfoMoney: TcxButtonEdit
    Left = 10
    Top = 352
    TabOrder = 16
    Visible = False
    ExplicitLeft = 10
    ExplicitTop = 352
  end
  inherited ceContract: TcxButtonEdit
    Top = 215
    TabOrder = 12
    Visible = False
    ExplicitTop = 215
  end
  inherited cxLabel8: TcxLabel
    Top = 195
    Visible = False
    ExplicitTop = 195
  end
  inherited cxLabel10: TcxLabel
    Left = 10
    Top = 285
    ExplicitLeft = 10
    ExplicitTop = 285
  end
  inherited ceComment: TcxTextEdit
    Left = 10
    Top = 305
    TabOrder = 15
    ExplicitLeft = 10
    ExplicitTop = 305
  end
  inherited cxLabel9: TcxLabel
    Visible = False
  end
  inherited ceCurrency: TcxButtonEdit
    TabOrder = 8
    Visible = False
  end
  inherited edInvNumber: TcxTextEdit
    TabOrder = 0
  end
  inherited cxLabel11: TcxLabel
    Visible = False
  end
  inherited ceCurrencyPartnerValue: TcxCurrencyEdit
    TabOrder = 6
    Visible = False
  end
  inherited cxLabel12: TcxLabel
    Visible = False
  end
  inherited ceParPartnerValue: TcxCurrencyEdit
    TabOrder = 7
    Visible = False
  end
  inherited ceBank: TcxButtonEdit
    TabOrder = 3
  end
  inherited cxLabel4: TcxLabel
    Visible = False
  end
  inherited ceAmountSumm: TcxCurrencyEdit
    TabOrder = 9
    Visible = False
  end
  inherited ceUnit: TcxButtonEdit
    Top = 215
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    TabOrder = 13
    ExplicitTop = 215
  end
  object edIncome: TcxButtonEdit [31]
    Left = 8
    Top = 215
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 259
  end
  inherited cxLabel14: TcxLabel
    Top = 195
    ExplicitTop = 195
  end
  object cxLabel15: TcxLabel [33]
    Left = 8
    Top = 195
    Caption = #8470' '#1087#1088#1080#1093#1086#1076#1072
  end
  object grIncome: TcxGrid [34]
    Left = 8
    Top = 112
    Width = 561
    Height = 77
    TabOrder = 10
    object grtvIncome: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = IncomeDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.GroupByBox = False
      object colInvNumber: TcxGridDBColumn
        Caption = #8470' '#1055#1053
        DataBinding.FieldName = 'InvNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 94
      end
      object colOperDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1055#1053
        DataBinding.FieldName = 'OperDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 92
      end
      object colFromName: TcxGridDBColumn
        Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
        DataBinding.FieldName = 'FromName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 160
      end
      object colJuridicalName: TcxGridDBColumn
        Caption = #1053#1072#1096#1077' '#1070#1088#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 200
      end
    end
    object grlIncome: TcxGridLevel
      GridView = grtvIncome
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 91
    Top = 280
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 98
    Top = 323
  end
  inherited ActionList: TActionList
    Left = 143
    Top = 271
    object actSelectIncomeBySumm: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectIncomeBySumm
      StoredProcList = <
        item
          StoredProc = spSelectIncomeBySumm
        end>
      Caption = #1053#1072#1081#1090#1080' '#1087#1088#1080#1093#1086#1076#1099
      Hint = #1053#1072#1081#1090#1080' '#1087#1088#1080#1093#1086#1076#1099
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object UpdateRecord1: TUpdateRecord
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.Component = IncomeCDS
          FromParam.ComponentItem = 'Id'
          ToParam.Value = Null
          ToParam.Component = GuidesIncome
          ToParam.ComponentItem = 'Key'
        end
        item
          FromParam.Value = Null
          FromParam.Component = IncomeCDS
          FromParam.ComponentItem = 'InvNumber'
          FromParam.DataType = ftString
          ToParam.Value = Null
          ToParam.Component = GuidesIncome
          ToParam.ComponentItem = 'TextValue'
          ToParam.DataType = ftString
        end
        item
          FromParam.Value = Null
          FromParam.Component = IncomeCDS
          FromParam.ComponentItem = 'FromId'
          ToParam.Value = Null
          ToParam.Component = ObjectlGuides
          ToParam.ComponentItem = 'Key'
        end
        item
          FromParam.Value = Null
          FromParam.Component = IncomeCDS
          FromParam.ComponentItem = 'FromName'
          FromParam.DataType = ftString
          ToParam.Value = Null
          ToParam.Component = ObjectlGuides
          ToParam.ComponentItem = 'TextValue'
          ToParam.DataType = ftString
        end
        item
          FromParam.Value = Null
          FromParam.Component = IncomeCDS
          FromParam.ComponentItem = 'UnitId'
          ToParam.Value = Null
          ToParam.Component = UnitGuides
          ToParam.ComponentItem = 'Key'
        end
        item
          FromParam.Value = Null
          FromParam.Component = IncomeCDS
          FromParam.ComponentItem = 'UnitName'
          FromParam.DataType = ftString
          ToParam.Value = Null
          ToParam.Component = UnitGuides
          ToParam.ComponentItem = 'TextValue'
          ToParam.DataType = ftString
        end>
      PostDataSetBeforeExecute = False
      Params = <>
      Caption = 'UpdateRecord1'
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
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'JuridicalId'
        Value = Null
      end>
    Left = 50
    Top = 267
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
    Top = 348
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
        Value = 'NULL'
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
    Top = 348
  end
  inherited BankAccountGuides: TdsdGuides
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BankAccountGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BankAccountGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'CurrencyId'
        Value = ''
        Component = CurrencyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'CurrencyName'
        Value = ''
        Component = CurrencyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'BankId'
        Value = Null
        Component = BankGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'BankName'
        Value = Null
        Component = BankGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'CurrencyValue'
        Value = Null
        Component = ceCurrencyPartnerValue
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'ParValue'
        Value = Null
        Component = ceParPartnerValue
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = ceOperDate
        DataType = ftDateTime
      end
      item
        Name = 'JuridicalId'
        Value = Null
        Component = FormParams
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
      end>
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
    Left = 222
    Top = 252
  end
  inherited InfoMoneyGuides: TdsdGuides
    Left = 336
    Top = 346
  end
  inherited ContractGuides: TdsdGuides
    Left = 364
    Top = 203
  end
  inherited BankGuides: TdsdGuides
    Left = 528
    Top = 10
  end
  inherited UnitGuides: TdsdGuides
    Left = 528
    Top = 197
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
        ParamType = ptInput
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = ObjectlGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 216
    Top = 209
  end
  object rdAmountOut: TRefreshDispatcher
    IdParam.Value = Null
    RefreshAction = actSelectIncomeBySumm
    ComponentList = <
      item
        Component = ceAmountOut
      end>
    Left = 120
    Top = 136
  end
  object IncomeCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 16
    Top = 139
  end
  object IncomeDS: TDataSource
    DataSet = IncomeCDS
    Left = 48
    Top = 139
  end
  object spSelectIncomeBySumm: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_IncomeBySumm'
    DataSet = IncomeCDS
    DataSets = <
      item
        DataSet = IncomeCDS
      end>
    Params = <
      item
        Name = 'inSumm'
        Value = Null
        Component = ceAmountOut
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inIncome'
        Value = Null
        Component = GuidesIncome
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 80
    Top = 139
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = grtvIncome
    OnDblClickActionList = <
      item
        Action = UpdateRecord1
      end>
    ActionItemList = <
      item
        Action = UpdateRecord1
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 360
    Top = 136
  end
end
