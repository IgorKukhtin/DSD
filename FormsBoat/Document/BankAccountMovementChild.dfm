inherited BankAccountMovementChildForm: TBankAccountMovementChildForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076'> - '#1076#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1057#1095#1077#1090#1072#1084
  ClientHeight = 524
  ClientWidth = 463
  ExplicitWidth = 469
  ExplicitHeight = 553
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 243
    Top = 481
    ExplicitLeft = 243
    ExplicitTop = 481
  end
  inherited bbCancel: TcxButton
    Left = 348
    Top = 481
    ExplicitLeft = 348
    ExplicitTop = 481
  end
  object Код: TcxLabel [2]
    Left = 8
    Top = 5
    Caption = 'Interne Nr'
  end
  object cxLabel1: TcxLabel [3]
    Left = 147
    Top = 8
    Caption = #1044#1072#1090#1072
  end
  object ceOperDate: TcxDateEdit [4]
    Left = 147
    Top = 25
    EditValue = 44231d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 120
  end
  object ceAmount: TcxCurrencyEdit [5]
    Left = 287
    Top = 74
    ParentFont = False
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    TabOrder = 4
    Width = 159
  end
  object cxLabel7: TcxLabel [6]
    Left = 287
    Top = 54
    Caption = #1057#1091#1084#1084#1072' '#1086#1087#1083#1072#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091
  end
  object cxLabel6: TcxLabel [7]
    Left = 10
    Top = 54
    Caption = 'Lieferanten / Kunden'
  end
  object ceObject: TcxButtonEdit [8]
    Left = 8
    Top = 74
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 259
  end
  object cxLabel10: TcxLabel [9]
    Left = 8
    Top = 244
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [10]
    Left = 8
    Top = 263
    TabOrder = 6
    Width = 438
  end
  object edInvNumber: TcxTextEdit [11]
    Left = 8
    Top = 25
    Properties.ReadOnly = True
    TabOrder = 11
    Text = '0'
    Width = 118
  end
  object cxLabel15: TcxLabel [12]
    Left = 8
    Top = 104
    Caption = #8470' '#1076#1086#1082'. '#1057#1095#1077#1090
  end
  object ceInvoice: TcxButtonEdit [13]
    Left = 8
    Top = 124
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 259
  end
  object cxLabel18: TcxLabel [14]
    Left = 287
    Top = 5
    Caption = 'External Nr'
  end
  object edInvNumberPartner: TcxTextEdit [15]
    Left = 287
    Top = 25
    Hint = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' ('#1074#1085#1077#1096#1085#1080#1081')'
    ParentShowHint = False
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 15
    Width = 159
  end
  object bbGuidesInvoiceChoiceForm: TcxButton [16]
    Left = 23
    Top = 399
    Width = 180
    Height = 25
    Action = actGuidesInvoiceChoiceForm
    ParentShowHint = False
    ShowHint = True
    TabOrder = 16
  end
  object cxLabel9: TcxLabel [17]
    Left = 287
    Top = 153
    Caption = #1058#1080#1087' '#1089#1095#1077#1090#1072
  end
  object edInvoiceKind: TcxButtonEdit [18]
    Left = 287
    Top = 173
    ParentFont = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    TabOrder = 18
    Width = 159
  end
  object cxLabel4: TcxLabel [19]
    Left = 8
    Top = 199
    Caption = #8470' '#1076#1086#1082'. '#1047#1072#1082#1072#1079
  end
  object edParent: TcxButtonEdit [20]
    Left = 8
    Top = 219
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 20
    Width = 259
  end
  object cxLabel2: TcxLabel [21]
    Left = 287
    Top = 199
    Caption = #1057#1091#1084#1084#1072' '#1089#1095#1077#1090#1072
  end
  object edAmount_invoice: TcxCurrencyEdit [22]
    Left = 287
    Top = 219
    EditValue = 0.000000000000000000
    ParentFont = False
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    TabOrder = 22
    Width = 159
  end
  object bbGuidesParentChoiceForm: TcxButton [23]
    Left = 23
    Top = 437
    Width = 180
    Height = 25
    Action = actGuidesParentChoiceForm
    ParentShowHint = False
    ShowHint = True
    TabOrder = 23
  end
  object btnGet_PrePay: TcxButton [24]
    Left = 243
    Top = 399
    Width = 90
    Height = 25
    Action = actGet_PrePay
    ParentShowHint = False
    ShowHint = True
    TabOrder = 24
  end
  object btnGet_Pay: TcxButton [25]
    Left = 348
    Top = 399
    Width = 90
    Height = 25
    Action = actGet_Pay
    ParentShowHint = False
    ShowHint = True
    TabOrder = 25
  end
  object btnGet_Proforma: TcxButton [26]
    Left = 243
    Top = 437
    Width = 90
    Height = 25
    Action = actGet_Proforma
    ParentShowHint = False
    ShowHint = True
    TabOrder = 26
  end
  object btnGet_Service: TcxButton [27]
    Left = 348
    Top = 437
    Width = 90
    Height = 25
    Action = actGet_Service
    ParentShowHint = False
    ShowHint = True
    TabOrder = 27
  end
  object cxLabel5: TcxLabel [28]
    Left = 8
    Top = 288
    Caption = #1058#1077#1082#1089#1090
  end
  object cmText: TcxMemo [29]
    Left = 8
    Top = 308
    Touch.ParentTabletOptions = False
    Touch.TabletOptions = [toPressAndHold, toPenTapFeedback, toTouchUIForceOn, toTouchUIForceOff, toTouchSwitch, toFlicks]
    Properties.ReadOnly = True
    TabOrder = 29
    Height = 76
    Width = 438
  end
  object cxLabel3: TcxLabel [30]
    Left = 8
    Top = 153
    Hint = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object ceInfoMoney: TcxButtonEdit [31]
    Left = 8
    Top = 173
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 31
    Width = 259
  end
  object ceAmount_pay: TcxCurrencyEdit [32]
    Left = 287
    Top = 124
    ParentFont = False
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = True
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.TextColor = clBlack
    Style.IsFontAssigned = True
    TabOrder = 32
    Width = 159
  end
  object cxLabel8: TcxLabel [33]
    Left = 287
    Top = 104
    Caption = #1057#1091#1084#1084#1072' '#1086#1087#1083#1072#1090#1099' '#1074' '#1074#1099#1087#1080#1089#1082#1077
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 113
    Top = 285
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 190
    Top = 309
  end
  inherited ActionList: TActionList
    Left = 277
    Top = 308
    object actGuidesInvoiceChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#8470' '#1076#1086#1082'. '#1057#1095#1077#1090
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#8470' '#1076#1086#1082'. '#1057#1095#1077#1090
      ImageIndex = 7
      FormName = 'TInvoiceJournalChoiceForm'
      FormNameParam.Value = 'TInvoiceJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = GuidesInvoice
          ComponentItem = 'Key'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_Full'
          Value = ''
          Component = GuidesInvoice
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectId'
          Value = Null
          Component = GuidesObject
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ObjectName'
          Value = Null
          Component = GuidesObject
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Amount_Invoice'
          Value = Null
          Component = edAmount_invoice
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_parent'
          Value = Null
          Component = GuidesParent
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberFull_parent'
          Value = Null
          Component = GuidesParent
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvoiceKindId'
          Value = Null
          Component = GuidesInvoiceKind
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvoiceKindName'
          Value = Null
          Component = GuidesInvoiceKind
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterClientId'
          Value = Null
          Component = GuidesObject
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterClientName'
          Value = Null
          Component = GuidesObject
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGuidesParentChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#8470' '#1076#1086#1082'. '#1047#1072#1082#1072#1079
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#8470' '#1076#1086#1082'. '#1047#1072#1082#1072#1079
      ImageIndex = 7
      FormName = 'TOrderClientJournalChoiceForm'
      FormNameParam.Value = 'TOrderClientJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = GuidesParent
          ComponentItem = 'Key'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_Full'
          Value = ''
          Component = GuidesParent
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ClientId'
          Value = ''
          Component = GuidesObject
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ClientName'
          Value = ''
          Component = GuidesObject
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterClientId'
          Value = ''
          Component = GuidesObject
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterClientName'
          Value = ''
          Component = GuidesObject
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGet_Pay: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Pay
      StoredProcList = <
        item
          StoredProc = spGet_Pay
        end>
      Caption = #1057#1095#1077#1090
      ImageIndex = 79
    end
    object actGet_Proforma: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Proforma
      StoredProcList = <
        item
          StoredProc = spGet_Proforma
        end>
      Caption = #1055#1088#1086#1092#1086#1088#1084#1072
      ImageIndex = 79
    end
    object actGet_Service: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Service
      StoredProcList = <
        item
          StoredProc = spGet_Service
        end>
      Caption = #1059#1089#1083#1091#1075#1080
      ImageIndex = 79
    end
    object actGet_PrePay: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_PrePay
      StoredProcList = <
        item
          StoredProc = spGet_PrePay
        end>
      Caption = #1055#1088#1077#1076#1086#1087#1083#1072#1090#1072
      ImageIndex = 79
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountChild_diff'
        Value = Null
        Component = ceAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 366
    Top = 293
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_BankAccount_Child'
    Params = <
      item
        Name = 'ioid'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inMovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inParentId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inMovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = GuidesParent
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_invoice'
        Value = Null
        Component = GuidesInvoice
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvoiceKindId'
        Value = Null
        Component = GuidesInvoiceKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inamount'
        Value = 0.000000000000000000
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount_invoice'
        Value = Null
        Component = edAmount_invoice
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
    Left = 112
    Top = 328
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MI_BankAccount_Child'
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inMovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = FormParams
        ComponentItem = 'AmountChild_diff'
        DataType = ftFloat
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
        Name = 'InvNumberPartner'
        Value = Null
        Component = edInvNumberPartner
        DataType = ftString
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
        Name = 'Amount'
        Value = 0.000000000000000000
        Component = ceAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount_pay'
        Value = Null
        Component = ceAmount_pay
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
        Name = 'Comment_master'
        Value = Null
        Component = cmText
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Objectid'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Objectname'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Invoice'
        Value = Null
        Component = GuidesInvoice
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Invoice_Full'
        Value = Null
        Component = GuidesInvoice
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindId'
        Value = Null
        Component = GuidesInvoiceKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindName'
        Value = Null
        Component = GuidesInvoiceKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName_all'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount_invoice'
        Value = Null
        Component = edAmount_invoice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_parent'
        Value = Null
        Component = GuidesParent
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberFull_parent'
        Value = Null
        Component = GuidesParent
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 352
    Top = 336
  end
  object GuidesObject: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceObject
    DisableGuidesOpen = True
    FormNameParam.Value = 'TMoneyPlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMoneyPlace_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName_all'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_order'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_order'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_invoice'
        Value = Null
        Component = GuidesInvoice
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_invoice'
        Value = Null
        Component = GuidesInvoice
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindId'
        Value = Null
        Component = GuidesInvoiceKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindName'
        Value = Null
        Component = GuidesInvoiceKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 220
    Top = 61
  end
  object GuidesInvoice: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInvoice
    Key = '0'
    FormNameParam.Value = 'TInvoiceJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInvoiceJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesInvoice
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesInvoice
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectId'
        Value = Null
        Component = GuidesObject
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectName'
        Value = Null
        Component = GuidesObject
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount_Invoice'
        Value = 0.000000000000000000
        Component = edAmount_invoice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_parent'
        Value = Null
        Component = GuidesParent
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberFull_parent'
        Value = Null
        Component = GuidesParent
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindId'
        Value = Null
        Component = GuidesInvoiceKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindName'
        Value = Null
        Component = GuidesInvoiceKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName_all'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterClientId'
        Value = Null
        Component = GuidesObject
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterClientName'
        Value = Null
        Component = GuidesObject
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 220
    Top = 119
  end
  object GuidesInvoiceKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvoiceKind
    DisableGuidesOpen = True
    FormNameParam.Value = 'TInvoiceKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInvoiceKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInvoiceKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInvoiceKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 400
    Top = 119
  end
  object GuidesParent: TdsdGuides
    KeyField = 'Id'
    LookupControl = edParent
    Key = '0'
    FormNameParam.Value = 'TOrderClientJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderClientJournalChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesParent
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesParent
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ClientId'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ClientName'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName_all'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Invoice_find'
        Value = '0'
        Component = GuidesInvoice
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberFull_Invoice_find'
        Value = ''
        Component = GuidesInvoice
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindId_find'
        Value = ''
        Component = GuidesInvoiceKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindName_find'
        Value = ''
        Component = GuidesInvoiceKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount_Invoice_find'
        Value = Null
        Component = edAmount_invoice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterClientId'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterClientName'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterSummDebet'
        Value = 0.000000000000000000
        Component = ceAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 221
    Top = 210
  end
  object spGet_PrePay: TdsdStoredProc
    StoredProcName = 'gpGet_Object_InvoiceKind_byDesc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inInvoiceKindDesc'
        Value = 'zc_Enum_InvoiceKind_PrePay'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindId'
        Value = ''
        Component = GuidesInvoiceKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindName'
        Value = ''
        Component = GuidesInvoiceKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 32
    Top = 480
  end
  object spGet_Pay: TdsdStoredProc
    StoredProcName = 'gpGet_Object_InvoiceKind_byDesc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inInvoiceKindDesc'
        Value = 'zc_Enum_InvoiceKind_Pay'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindId'
        Value = ''
        Component = GuidesInvoiceKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindName'
        Value = ''
        Component = GuidesInvoiceKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 80
    Top = 465
  end
  object spGet_Proforma: TdsdStoredProc
    StoredProcName = 'gpGet_Object_InvoiceKind_byDesc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inInvoiceKindDesc'
        Value = 'zc_Enum_InvoiceKind_Proforma'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindId'
        Value = ''
        Component = GuidesInvoiceKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindName'
        Value = ''
        Component = GuidesInvoiceKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 128
    Top = 481
  end
  object spGet_Service: TdsdStoredProc
    StoredProcName = 'gpGet_Object_InvoiceKind_byDesc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inInvoiceKindDesc'
        Value = 'zc_Enum_InvoiceKind_Service'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindId'
        Value = ''
        Component = GuidesInvoiceKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindName'
        Value = ''
        Component = GuidesInvoiceKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 176
    Top = 465
  end
  object GuidesInfoMoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 223
    Top = 165
  end
end
