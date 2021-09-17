inherited SendDebtForm: TSendDebtForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1042#1079#1072#1080#1084#1086#1079#1072#1095#1077#1090' ('#1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072')>'
  ClientHeight = 438
  ClientWidth = 594
  ExplicitWidth = 600
  ExplicitHeight = 463
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 184
    Top = 398
    ExplicitLeft = 184
    ExplicitTop = 398
  end
  inherited bbCancel: TcxButton
    Left = 328
    Top = 398
    ExplicitLeft = 328
    ExplicitTop = 398
  end
  object cxLabel1: TcxLabel [2]
    Left = 152
    Top = 4
    Caption = #1044#1072#1090#1072
  end
  object Код: TcxLabel [3]
    Left = 8
    Top = 4
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object ceInvNumber: TcxCurrencyEdit [4]
    Left = 8
    Top = 24
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 2
    Width = 129
  end
  object cxLabel2: TcxLabel [5]
    Left = 8
    Top = 241
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099' ('#1044#1077#1073#1077#1090')'
  end
  object cxLabel5: TcxLabel [6]
    Left = 8
    Top = 191
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103' ('#1044#1077#1073#1077#1090')'
  end
  object cePaidKindFrom: TcxButtonEdit [7]
    Left = 8
    Top = 262
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 128
  end
  object ceInfoMoneyFrom: TcxButtonEdit [8]
    Left = 8
    Top = 211
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 273
  end
  object ceOperDate: TcxDateEdit [9]
    Left = 152
    Top = 24
    EditValue = 43489d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 129
  end
  object ceJuridicalFrom: TcxButtonEdit [10]
    Left = 8
    Top = 69
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 273
  end
  object cxLabel6: TcxLabel [11]
    Left = 8
    Top = 51
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086' ('#1044#1077#1073#1077#1090')'
  end
  object ceContractFrom: TcxButtonEdit [12]
    Left = 153
    Top = 262
    Properties.Buttons = <
      item
        Action = macCheckRight_From
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 128
  end
  object cxLabel8: TcxLabel [13]
    Left = 153
    Top = 241
    Caption = #1044#1086#1075#1086#1074#1086#1088' ('#1044#1077#1073#1077#1090')'
  end
  object cxLabel10: TcxLabel [14]
    Left = 8
    Top = 349
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [15]
    Left = 8
    Top = 368
    TabOrder = 15
    Width = 576
  end
  object cxLabel4: TcxLabel [16]
    Left = 312
    Top = 4
    Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085
  end
  object ceAmount: TcxCurrencyEdit [17]
    Left = 312
    Top = 24
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 17
    Width = 126
  end
  object cxLabel3: TcxLabel [18]
    Left = 312
    Top = 51
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086' ('#1050#1088#1077#1076#1080#1090')'
  end
  object ceJuridicalTo: TcxButtonEdit [19]
    Left = 312
    Top = 69
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 273
  end
  object cxLabel7: TcxLabel [20]
    Left = 312
    Top = 191
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103' ('#1050#1088#1077#1076#1080#1090')'
  end
  object ceInfoMoneyTo: TcxButtonEdit [21]
    Left = 312
    Top = 211
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 273
  end
  object cxLabel9: TcxLabel [22]
    Left = 312
    Top = 241
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099' ('#1050#1088#1077#1076#1080#1090')'
  end
  object cxLabel11: TcxLabel [23]
    Left = 456
    Top = 241
    Caption = #1044#1086#1075#1086#1074#1086#1088' ('#1050#1088#1077#1076#1080#1090')'
  end
  object cePaidKindTo: TcxButtonEdit [24]
    Left = 312
    Top = 262
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 24
    Width = 128
  end
  object ceContractTo: TcxButtonEdit [25]
    Left = 456
    Top = 262
    Properties.Buttons = <
      item
        Action = macCheckRight_To
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 25
    Width = 128
  end
  object cePartnerFrom: TcxButtonEdit [26]
    Left = 8
    Top = 115
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 26
    Width = 273
  end
  object cxLabel12: TcxLabel [27]
    Left = 8
    Top = 96
    Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1044#1077#1073#1077#1090')'
  end
  object cePartnerTo: TcxButtonEdit [28]
    Left = 312
    Top = 115
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 28
    Width = 273
  end
  object cxLabel13: TcxLabel [29]
    Left = 312
    Top = 96
    Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1050#1088#1077#1076#1080#1090')'
  end
  object ceBranchFrom: TcxButtonEdit [30]
    Left = 8
    Top = 161
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 30
    Width = 273
  end
  object cxLabel14: TcxLabel [31]
    Left = 8
    Top = 141
    Caption = #1060#1080#1083#1080#1072#1083' ('#1044#1077#1073#1077#1090')'
  end
  object ceBranchTo: TcxButtonEdit [32]
    Left = 312
    Top = 161
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 32
    Width = 272
  end
  object cxLabel15: TcxLabel [33]
    Left = 312
    Top = 141
    Caption = #1060#1080#1083#1080#1072#1083' ('#1050#1088#1077#1076#1080#1090')'
  end
  object cxLabel16: TcxLabel [34]
    Left = 8
    Top = 300
    Hint = #1050#1091#1088#1089' ('#1076#1077#1073#1077#1090')'
    Caption = #1050#1091#1088#1089
    ParentShowHint = False
    ShowHint = True
  end
  object ceCurrencyValueFrom: TcxCurrencyEdit [35]
    Left = 8
    Top = 320
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    ShowHint = True
    TabOrder = 35
    Width = 54
  end
  object ceParValueFrom: TcxCurrencyEdit [36]
    Left = 71
    Top = 320
    EditValue = 1.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0.'
    Properties.ReadOnly = False
    TabOrder = 36
    Width = 47
  end
  object cxLabel17: TcxLabel [37]
    Left = 72
    Top = 300
    Hint = #1053#1086#1084#1080#1085#1072#1083' ('#1076#1077#1073#1077#1090')'
    Caption = #1053#1086#1084#1080#1085#1072#1083
    ParentShowHint = False
    ShowHint = True
  end
  object ceCurrencyFrom: TcxButtonEdit [38]
    Left = 127
    Top = 320
    ParentShowHint = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    ShowHint = False
    TabOrder = 38
    Width = 63
  end
  object cxLabel18: TcxLabel [39]
    Left = 127
    Top = 300
    Hint = #1042#1072#1083#1102#1090#1072' ('#1076#1077#1073#1077#1090')'
    Caption = #1042#1072#1083#1102#1090#1072
    ParentShowHint = False
    ShowHint = True
  end
  object cxLabel19: TcxLabel [40]
    Left = 200
    Top = 300
    Caption = #1057#1091#1084#1084#1072' ('#1076#1077#1073#1077#1090')'
  end
  object ceAmountCurrencyFrom: TcxCurrencyEdit [41]
    Left = 200
    Top = 320
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = True
    TabOrder = 41
    Width = 81
  end
  object cxLabel20: TcxLabel [42]
    Left = 312
    Top = 300
    Hint = #1050#1091#1088#1089' ('#1082#1088#1077#1076#1080#1090')'
    Caption = #1050#1091#1088#1089
    ParentShowHint = False
    ShowHint = True
  end
  object ceCurrencyValueTo: TcxCurrencyEdit [43]
    Left = 312
    Top = 320
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    TabOrder = 43
    Width = 54
  end
  object ceParValueTo: TcxCurrencyEdit [44]
    Left = 375
    Top = 320
    EditValue = 1.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0.'
    Properties.ReadOnly = False
    TabOrder = 44
    Width = 47
  end
  object cxLabel21: TcxLabel [45]
    Left = 376
    Top = 300
    Hint = #1053#1086#1084#1080#1085#1072#1083' ('#1082#1088#1077#1076#1080#1090')'
    Caption = #1053#1086#1084#1080#1085#1072#1083
    ParentShowHint = False
    ShowHint = True
  end
  object cxLabel22: TcxLabel [46]
    Left = 431
    Top = 300
    Hint = #1042#1072#1083#1102#1090#1072' ('#1082#1088#1077#1076#1080#1090')'
    Caption = #1042#1072#1083#1102#1090#1072
    ParentShowHint = False
    ShowHint = True
  end
  object ceCurrencyTo: TcxButtonEdit [47]
    Left = 431
    Top = 320
    ParentShowHint = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    ShowHint = False
    TabOrder = 47
    Width = 63
  end
  object ceAmountCurrencyTo: TcxCurrencyEdit [48]
    Left = 503
    Top = 320
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = True
    TabOrder = 48
    Width = 81
  end
  object cxLabel23: TcxLabel [49]
    Left = 503
    Top = 300
    Caption = #1057#1091#1084#1084#1072' ('#1050#1088#1077#1076#1080#1090')'
  end
  object cbisCopy: TcxCheckBox [50]
    Left = 453
    Top = 24
    Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1073#1086#1085#1091#1089#1086#1074
    Properties.ReadOnly = True
    TabOrder = 50
    Width = 131
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 390
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 390
  end
  inherited ActionList: TActionList
    Left = 95
    Top = 389
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides [0]
    end
    object actRefreshAmountCurr: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_AmountCurr
      StoredProcList = <
        item
          StoredProc = spGet_AmountCurr
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    inherited actRefresh: TdsdDataSetRefresh [2]
    end
    inherited FormClose: TdsdFormClose [3]
    end
    object actCheckRight: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spCheckRight
      StoredProcList = <
        item
          StoredProc = spCheckRight
        end>
      Caption = #1087#1088#1086#1074#1077#1088#1082#1072' '#1087#1088#1072#1074' '#1085#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
    end
    object OpenChoiceFormContractTo: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'OpenChoiceFormContractFrom'
      FormName = 'TContractChoiceForm'
      FormNameParam.Value = 'TContractChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = ''
          Component = ContractToGuides
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = ''
          Component = ContractToGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = ContractJuridicalToGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = ContractJuridicalToGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object OpenChoiceFormContractFrom: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'OpenChoiceFormContractFrom'
      FormName = 'TContractChoiceForm'
      FormNameParam.Value = 'TContractChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ContractFromGuides
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ContractFromGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = ContractJuridicalFromGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = ContractJuridicalFromGuides
          ComponentItem = 'TextValue'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macCheckRight_To: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actCheckRight
        end
        item
          Action = OpenChoiceFormContractTo
        end>
      Caption = 'macCheckRight_To'
    end
    object macCheckRight_From: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actCheckRight
        end
        item
          Action = OpenChoiceFormContractFrom
        end>
      Caption = 'macCheckRight_From'
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
        Name = 'inPaidKindId'
        Value = '0'
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 390
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_SendDebt'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = 0.000000000000000000
        Component = ceInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioMasterId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MI_MasterId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioChildId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MI_ChildId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValue_From'
        Value = Null
        Component = ceCurrencyValueFrom
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParValue_From'
        Value = Null
        Component = ceParValueFrom
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValue_To'
        Value = Null
        Component = ceCurrencyValueTo
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParValue_To'
        Value = Null
        Component = ceParValueTo
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalFromId'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerFromId'
        Value = ''
        Component = PartnerFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractfromId'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindFromId'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyFromId'
        Value = ''
        Component = InfoMoneyFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchFromId'
        Value = Null
        Component = BranchFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId_From'
        Value = Null
        Component = GuidesCurrencyFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalToId'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerToId'
        Value = ''
        Component = PartnerToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractToId'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindToId'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyToId'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchToId'
        Value = Null
        Component = BranchToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId_To'
        Value = Null
        Component = GuidesCurrencyTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 22
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_SendDebt'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
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
        Name = 'MI_MasterId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MI_MasterId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MI_ChildId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MI_ChildId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Invnumber'
        Value = 0.000000000000000000
        Component = ceInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Statuscode'
        Value = '0'
        Component = FormParams
        MultiSelectSeparator = ','
      end
      item
        Name = 'statusname'
        Value = Null
        Component = FormParams
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyGroupFromName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyFromId'
        Value = ''
        Component = InfoMoneyFromGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyFromName'
        Value = ''
        Component = InfoMoneyFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractFromId'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractFromName'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalFromId'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalFromName'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromOKPO'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindFromId'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindFromName'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyGroupToName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyToId'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyToName'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractToId'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractToName'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalToId'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalToName'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToOKPO'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindToId'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindToName'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount'
        Value = 0.000000000000000000
        Component = ceAmount
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
        Name = 'PartnerFromId'
        Value = ''
        Component = PartnerFromGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerFromName'
        Value = ''
        Component = PartnerFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerToId'
        Value = ''
        Component = PartnerToGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerToName'
        Value = ''
        Component = PartnerToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchFromId'
        Value = Null
        Component = BranchFromGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchFromName'
        Value = Null
        Component = BranchFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchToId'
        Value = Null
        Component = BranchToGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchToName'
        Value = Null
        Component = BranchToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId_From'
        Value = Null
        Component = GuidesCurrencyFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName_From'
        Value = Null
        Component = GuidesCurrencyFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyValue_From'
        Value = Null
        Component = ceCurrencyValueFrom
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParValue_From'
        Value = Null
        Component = ceParValueFrom
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId_To'
        Value = Null
        Component = GuidesCurrencyTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName_To'
        Value = Null
        Component = GuidesCurrencyTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyValue_To'
        Value = Null
        Component = ceCurrencyValueTo
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParValue_To'
        Value = Null
        Component = ceParValueTo
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountCurrencyFrom'
        Value = Null
        Component = ceAmountCurrencyFrom
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountCurrencyTo'
        Value = Null
        Component = ceAmountCurrencyTo
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCopy'
        Value = Null
        Component = cbisCopy
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 528
    Top = 53
  end
  object PaidKindFromGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePaidKindFrom
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 59
    Top = 251
  end
  object InfoMoneyFromGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoneyFrom
    FormNameParam.Value = 'TInfoMoneyForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoneyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = InfoMoneyFromGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 197
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = ContractJuridicalFromGuides
      end
      item
        Guides = ContractJuridicalToGuides
      end
      item
      end>
    ActionItemList = <>
    Left = 280
    Top = 381
  end
  object ContractFromGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceContractFrom
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = Null
        Component = ContractFromGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = Null
        Component = ContractFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 256
  end
  object ContractJuridicalFromGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridicalFrom
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindFromGuides
        ComponentItem = 'TextValue'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = InfoMoneyFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName_all'
        Value = ''
        Component = InfoMoneyFromGuides
        ComponentItem = 'TextValue'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = ''
        Component = PartnerFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = PartnerFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = 0
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 145
    Top = 56
  end
  object ContractToGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceContractTo
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 504
    Top = 256
  end
  object InfoMoneyToGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoneyTo
    FormNameParam.Value = 'TInfoMoneyForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoneyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 440
    Top = 197
  end
  object PaidKindToGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePaidKindTo
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 347
    Top = 259
  end
  object ContractJuridicalToGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridicalTo
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName_all'
        Value = ''
        Component = InfoMoneyToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = ''
        Component = PartnerToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = PartnerToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = 0
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 481
    Top = 42
  end
  object PartnerFromGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePartnerFrom
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PartnerFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PartnerFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = ContractJuridicalFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 112
  end
  object PartnerToGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePartnerTo
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PartnerToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PartnerToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = ContractJuridicalToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 504
    Top = 104
  end
  object BranchFromGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBranchFrom
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BranchFromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BranchFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 144
  end
  object BranchToGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBranchTo
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BranchToGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BranchToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 528
    Top = 152
  end
  object GuidesCurrencyFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCurrencyFrom
    FormNameParam.Value = 'TCurrencyValue_ForCashForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCurrencyValue_ForCashForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCurrencyFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCurrencyFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42475d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParValue'
        Value = 1.000000000000000000
        Component = ceParValueFrom
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyValue'
        Value = 0.000000000000000000
        Component = ceCurrencyValueFrom
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 154
    Top = 304
  end
  object GuidesCurrencyTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCurrencyTo
    FormNameParam.Value = 'TCurrencyValue_ForCashForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCurrencyValue_ForCashForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCurrencyTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCurrencyTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 43489d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParValue'
        Value = 1.000000000000000000
        Component = ceParValueTo
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyValue'
        Value = 0.000000000000000000
        Component = ceCurrencyValueTo
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 448
    Top = 320
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshAmountCurr
    ComponentList = <
      item
        Component = ceAmount
      end
      item
        Component = GuidesCurrencyFrom
      end
      item
        Component = GuidesCurrencyTo
      end
      item
        Component = ceCurrencyValueFrom
      end
      item
        Component = ceCurrencyValueTo
      end
      item
        Component = ceParValueFrom
      end
      item
        Component = ceParValueTo
      end>
    Left = 288
    Top = 152
  end
  object spGet_AmountCurr: TdsdStoredProc
    StoredProcName = 'gpGet_MI_SendDebt_AmountCurrency'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inCurrencyId_From'
        Value = Null
        Component = GuidesCurrencyFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId_To'
        Value = Null
        Component = GuidesCurrencyTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = ''
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValue_From'
        Value = Null
        Component = ceCurrencyValueFrom
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParValue_From'
        Value = 1.000000000000000000
        Component = ceParValueFrom
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValue_To'
        Value = 0.000000000000000000
        Component = ceCurrencyValueTo
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParValue_To'
        Value = Null
        Component = ceParValueTo
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountCurrencyFrom'
        Value = Null
        Component = ceAmountCurrencyFrom
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountCurrencyTo'
        Value = Null
        Component = ceAmountCurrencyTo
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 288
    Top = 96
  end
  object spCheckRight: TdsdStoredProc
    StoredProcName = 'gpCheckRight_Movement_SendDebt_Contract'
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 432
    Top = 93
  end
end
