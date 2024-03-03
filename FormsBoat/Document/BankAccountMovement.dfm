inherited BankAccountMovementForm: TBankAccountMovementForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076'>'
  ClientHeight = 583
  ClientWidth = 478
  ExplicitWidth = 484
  ExplicitHeight = 612
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 197
    Top = 567
    Visible = False
    ExplicitLeft = 197
    ExplicitTop = 567
  end
  inherited bbCancel: TcxButton
    Left = 325
    Top = 567
    Visible = False
    ExplicitLeft = 325
    ExplicitTop = 567
  end
  object cxPageControl1: TcxPageControl [2]
    Left = 0
    Top = 0
    Width = 473
    Height = 577
    TabOrder = 2
    Properties.ActivePage = Main
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 577
    ClientRectRight = 473
    ClientRectTop = 24
    object Main: TcxTabSheet
      Caption = 'Main'
      ImageIndex = 0
      object Код: TcxLabel
        Left = 8
        Top = 5
        Caption = 'Interne Nr'
      end
      object cxLabel1: TcxLabel
        Left = 147
        Top = 5
        Caption = #1044#1072#1090#1072
      end
      object ceOperDate: TcxDateEdit
        Left = 147
        Top = 25
        EditValue = 44231d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 3
        Width = 120
      end
      object cxLabel2: TcxLabel
        Left = 287
        Top = 60
        Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
      end
      object ceBankAccount: TcxButtonEdit
        Left = 287
        Top = 80
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 4
        Width = 159
      end
      object ceAmountIn: TcxCurrencyEdit
        Left = 8
        Top = 80
        ParentFont = False
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clBlue
        Style.Font.Height = -11
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 5
        Width = 120
      end
      object cxLabel7: TcxLabel
        Left = 8
        Top = 60
        Caption = #1055#1088#1080#1093#1086#1076', '#1089#1091#1084#1084#1072
      end
      object ceAmountOut: TcxCurrencyEdit
        Left = 147
        Top = 80
        ParentFont = False
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clBlue
        Style.Font.Height = -11
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 6
        Width = 120
      end
      object cxLabel3: TcxLabel
        Left = 147
        Top = 60
        Caption = #1056#1072#1089#1093#1086#1076', '#1089#1091#1084#1084#1072
      end
      object cxLabel6: TcxLabel
        Left = 8
        Top = 115
        Caption = 'Lieferanten / Kunden'
      end
      object ceObject: TcxButtonEdit
        Left = 8
        Top = 135
        Properties.Buttons = <
          item
            Action = actGuidesObjectChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 7
        Width = 259
      end
      object edInvNumber: TcxTextEdit
        Left = 8
        Top = 25
        Properties.ReadOnly = True
        TabOrder = 11
        Text = '0'
        Width = 118
      end
      object ceBank: TcxButtonEdit
        Left = 287
        Top = 135
        Properties.Buttons = <
          item
            Default = True
            Enabled = False
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 14
        Width = 159
      end
      object cxLabel13: TcxLabel
        Left = 287
        Top = 115
        Caption = #1041#1072#1085#1082
      end
      object cxLabel15: TcxLabel
        Left = 8
        Top = 168
        Caption = #8470' '#1076#1086#1082'. '#1057#1095#1077#1090
      end
      object ceInvoice: TcxButtonEdit
        Left = 8
        Top = 189
        Properties.Buttons = <
          item
            Action = actGuidesInvoiceChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 16
        Width = 259
      end
      object cxLabel18: TcxLabel
        Left = 287
        Top = 5
        Caption = 'External Nr'
      end
      object edInvNumberPartner: TcxTextEdit
        Left = 287
        Top = 25
        Hint = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' ('#1074#1085#1077#1096#1085#1080#1081')'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 18
        Width = 159
      end
      object cxLabel4: TcxLabel
        Left = 8
        Top = 263
        Caption = #8470' '#1076#1086#1082'. '#1047#1072#1082#1072#1079
      end
      object bbGuidesInvoiceChoiceForm: TcxButton
        Left = 22
        Top = 487
        Width = 180
        Height = 25
        Action = actGuidesInvoiceChoiceForm
        ParentShowHint = False
        ShowHint = True
        TabOrder = 19
      end
      object bbGuidesParentChoiceForm: TcxButton
        Left = 22
        Top = 521
        Width = 180
        Height = 25
        Hint = #1042#1099#1073#1088#1072#1090#1100' '#8470' '#1076#1086#1082'. '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
        Action = actGuidesParentChoiceForm
        ParentShowHint = False
        ShowHint = True
        TabOrder = 21
      end
      object cxLabel9: TcxLabel
        Left = 287
        Top = 168
        Caption = #1058#1080#1087' '#1089#1095#1077#1090#1072
      end
      object edInvoiceKind: TcxButtonEdit
        Left = 287
        Top = 189
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
        TabOrder = 23
        Width = 159
      end
      object cxLabel5: TcxLabel
        Left = 8
        Top = 350
        Caption = #1058#1077#1082#1089#1090
      end
      object cmText: TcxMemo
        Left = 8
        Top = 370
        TabOrder = 24
        Height = 76
        Width = 438
      end
      object edParent: TcxButtonEdit
        Left = 8
        Top = 282
        Properties.Buttons = <
          item
            Action = actGuidesParentChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 26
        Width = 259
      end
      object cxLabel8: TcxLabel
        Left = 287
        Top = 217
        Caption = #1057#1091#1084#1084#1072' '#1089#1095#1077#1090#1072
      end
      object edAmount_invoice: TcxCurrencyEdit
        Left = 287
        Top = 237
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
        TabOrder = 28
        Width = 159
      end
      object cxLabel10: TcxLabel
        Left = 8
        Top = 217
        Hint = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      end
      object ceInfoMoney: TcxButtonEdit
        Left = 8
        Top = 237
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 29
        Width = 259
      end
      object btnGuidesObjectChoiceForm: TcxButton
        Left = 22
        Top = 455
        Width = 180
        Height = 25
        Action = actGuidesObjectChoiceForm
        ParentShowHint = False
        ShowHint = True
        TabOrder = 30
      end
      object btnGet_PrePay: TcxButton
        Left = 225
        Top = 455
        Width = 90
        Height = 25
        Action = actGet_PrePay
        ParentShowHint = False
        ShowHint = True
        TabOrder = 31
      end
      object btnGet_Pay: TcxButton
        Left = 345
        Top = 455
        Width = 90
        Height = 25
        Action = actGet_Pay
        ParentShowHint = False
        ShowHint = True
        TabOrder = 32
      end
      object btnGet_Proforma: TcxButton
        Left = 225
        Top = 487
        Width = 90
        Height = 25
        Action = actGet_Proforma
        ParentShowHint = False
        ShowHint = True
        TabOrder = 34
      end
      object btnGet_Service: TcxButton
        Left = 345
        Top = 487
        Width = 90
        Height = 25
        Action = actGet_Service
        ParentShowHint = False
        ShowHint = True
        TabOrder = 36
      end
      object edString_7: TcxTextEdit
        Left = 8
        Top = 327
        Properties.ReadOnly = True
        TabOrder = 33
        Width = 259
      end
      object cxLabel14: TcxLabel
        Left = 8
        Top = 308
        Caption = '7. Name Zahlungsbeteiligter'
      end
      object cxButton1: TcxButton
        Left = 225
        Top = 521
        Width = 90
        Height = 25
        Action = actInsertUpdateGuides
        ParentShowHint = False
        ShowHint = True
        TabOrder = 37
      end
      object cxButton2: TcxButton
        Left = 345
        Top = 521
        Width = 90
        Height = 25
        Action = actFormClose
        ParentShowHint = False
        ShowHint = True
        TabOrder = 38
      end
    end
    object cxTabSheet1: TcxTabSheet
      Caption = 'Lieferanten / Kunden'
      ImageIndex = 1
      object cxLabel11: TcxLabel
        Left = 2
        Top = 191
        Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
      end
      object cxLabel20: TcxLabel
        Left = 287
        Top = 8
        Caption = 'Tax Number'
      end
      object cxLabel12: TcxLabel
        Left = 2
        Top = 8
        Caption = #1050#1086#1076
      end
      object edCode: TcxCurrencyEdit
        Left = 2
        Top = 26
        EditValue = 0.000000000000000000
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        Properties.ReadOnly = True
        TabOrder = 2
        Width = 130
      end
      object edTaxNumber: TcxTextEdit
        Left = 287
        Top = 26
        TabOrder = 3
        Width = 160
      end
      object cxLabel19: TcxLabel
        Left = 287
        Top = 53
        Caption = #1058#1080#1087' '#1053#1044#1057
      end
      object edTaxKind: TcxButtonEdit
        Left = 287
        Top = 70
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 5
        Width = 160
      end
      object edName: TcxTextEdit
        Left = 2
        Top = 71
        TabOrder = 6
        Width = 273
      end
      object cxLabel16: TcxLabel
        Left = 2
        Top = 53
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
      end
      object cxLabel17: TcxLabel
        Left = 2
        Top = 97
        Caption = 'PLZ'
      end
      object edPLZ: TcxButtonEdit
        Left = 2
        Top = 116
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 9
        Width = 130
      end
      object cxLabel21: TcxLabel
        Left = 2
        Top = 144
        Caption = #1059#1083#1080#1094#1072
      end
      object edStreet: TcxTextEdit
        Left = 2
        Top = 163
        TabOrder = 11
        Width = 273
      end
      object edCountry: TcxButtonEdit
        Left = 145
        Top = 117
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 12
        Width = 130
      end
      object cxLabel23: TcxLabel
        Left = 145
        Top = 97
        Caption = #1057#1090#1088#1072#1085#1072' '
      end
      object cxLabel22: TcxLabel
        Left = 287
        Top = 97
        Caption = #1043#1086#1088#1086#1076
      end
      object edCity: TcxButtonEdit
        Left = 287
        Top = 117
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 15
        Width = 160
      end
      object edStreet_add: TcxTextEdit
        Left = 287
        Top = 163
        TabOrder = 16
        Width = 160
      end
      object cxLabel25: TcxLabel
        Left = 287
        Top = 144
        Caption = #1059#1083#1080#1094#1072' ('#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086')'
      end
      object cxButton3: TcxButton
        Left = 7
        Top = 521
        Width = 125
        Height = 25
        Action = actInsert_MoneyPlace
        ParentShowHint = False
        ShowHint = True
        TabOrder = 18
      end
      object edIBAN: TcxTextEdit
        Left = 2
        Top = 211
        TabOrder = 20
        Width = 271
      end
      object cxButton4: TcxButton
        Left = 154
        Top = 521
        Width = 125
        Height = 25
        Action = actInsertUpdate_MoneyPlace
        ParentShowHint = False
        ShowHint = True
        TabOrder = 21
      end
      object cxButton5: TcxButton
        Left = 300
        Top = 521
        Width = 125
        Height = 25
        Action = actClear_MoneyPlace
        ParentShowHint = False
        ShowHint = True
        TabOrder = 22
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 404
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 160
    Top = 380
  end
  inherited ActionList: TActionList
    Left = 111
    Top = 371
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGet_MoneyPlace
        end>
    end
    inherited actFormClose: TdsdFormClose
      Category = ''
    end
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
          Value = Null
          Component = GuidesInvoice
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberFull_Invoice_find'
          Value = Null
          Component = GuidesInvoice
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvoiceKindId_find'
          Value = Null
          Component = GuidesInvoiceKind
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvoiceKindName_find'
          Value = Null
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
          Value = Null
          Component = ceAmountIn
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGuidesObjectChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actGet_MoneyPlace
      PostDataSetBeforeExecute = False
      Caption = #1042#1099#1073#1086#1088' Lieferanten / Kunden'
      Hint = #1042#1099#1073#1086#1088' Lieferanten / Kunden'
      ImageIndex = 7
      FormName = 'TMoneyPlace_ObjectForm'
      FormNameParam.Value = 'TMoneyPlace_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
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
          Component = GuidesInfoMoney
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName_all'
          Value = ''
          Component = GuidesInfoMoney
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_order'
          Value = Null
          Component = GuidesParent
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_order'
          Value = Null
          Component = GuidesParent
          ComponentItem = 'TextValue'
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
          Name = 'Amount_Invoice'
          Value = Null
          Component = edAmount_invoice
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'TaxNumber'
          Value = Null
          Component = edTaxNumber
          DataType = ftString
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
    object actClear_MoneyPlace: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_MoneyPlace_Clear
      StoredProcList = <
        item
          StoredProc = spGet_MoneyPlace_Clear
        end>
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      ImageIndex = 2
    end
    object actInsert_MoneyPlace: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_MoneyPlace
      StoredProcList = <
        item
          StoredProc = spInsert_MoneyPlace
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ImageIndex = 0
    end
    object actInsertUpdate_MoneyPlace: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MoneyPlace
      StoredProcList = <
        item
          StoredProc = spUpdate_MoneyPlace
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ImageIndex = 1
    end
    object actGet_MoneyPlace: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_MoneyPlace
      StoredProcList = <
        item
          StoredProc = spGet_MoneyPlace
        end>
      Caption = 'Get_MoneyPlace'
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Value'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Invoice'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMoneyPlaceId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_parent'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 364
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberPartner'
        Value = Null
        Component = edInvNumberPartner
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
        Name = 'inAmountIn'
        Value = 0.000000000000000000
        Component = ceAmountIn
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountOut'
        Value = 0.000000000000000000
        Component = ceAmountOut
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount_Invoice'
        Value = Null
        Component = edAmount_invoice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountId'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMoneyPlaceId'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Invoice'
        Value = 0
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
        Name = 'inInfoMoneyId'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Parent'
        Value = Null
        Component = GuidesParent
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = cmText
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 392
    Top = 344
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Value'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId_Value'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Invoice'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId_Invoice'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_parent'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId_parent'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMoneyPlaceId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMoneyPlaceId'
        ParamType = ptInput
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
        Name = 'AmountIn'
        Value = 0.000000000000000000
        Component = ceAmountIn
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountOut'
        Value = 0.000000000000000000
        Component = ceAmountOut
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = cmText
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountId'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountName'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankId'
        Value = Null
        Component = GuidesBank
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankName'
        Value = Null
        Component = GuidesBank
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'moneyplaceid'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'moneyplacename'
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
        Name = 'InvNumber_Invoice'
        Value = Null
        Component = GuidesInvoice
        ComponentItem = 'TextValue'
        DataType = ftString
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
        Name = 'InvNumber_parent'
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
        Name = 'Amount_Invoice'
        Value = Null
        Component = edAmount_invoice
        DataType = ftFloat
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
        Name = 'String_7'
        Value = Null
        Component = edString_7
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 304
    Top = 360
  end
  object GuidesBankAccount: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBankAccount
    FormNameParam.Value = 'TBankAccountForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankAccountForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankId'
        Value = Null
        Component = GuidesBank
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankName'
        Value = Null
        Component = GuidesBank
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = ceOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 370
    Top = 268
  end
  object GuidesObject: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceObject
    FormNameParam.Value = 'TMoneyPlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMoneyPlace_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <>
    Left = 92
    Top = 141
  end
  object GuidesBank: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBank
    DisableGuidesOpen = True
    FormNameParam.Value = 'TBankForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBank
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBank
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 419
    Top = 240
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
    Params = <>
    Left = 220
    Top = 183
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = GuidesBankAccount
      end>
    ActionItemList = <
      item
      end>
    Left = 40
    Top = 368
  end
  object GuidesParent: TdsdGuides
    KeyField = 'Id'
    LookupControl = edParent
    FormNameParam.Value = 'TOrderClientJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderClientJournalChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 216
    Top = 279
  end
  object GuidesInvoiceKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvoiceKind
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
    Left = 344
    Top = 231
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
    Top = 229
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
    Left = 224
    Top = 416
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
    Left = 272
    Top = 408
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
    Left = 336
    Top = 416
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
    Left = 392
    Top = 416
  end
  object GuidesBankAccount_p2: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBankAccount
    FormNameParam.Value = 'TBankAccountForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankAccountForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBankAccount_p2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBankAccount_p2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankId'
        Value = ''
        Component = GuidesBank
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankName'
        Value = ''
        Component = GuidesBank
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 44231d
        Component = ceOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 346
    Top = 476
  end
  object spInsert_MoneyPlace: TdsdStoredProc
    StoredProcName = 'gpInsert_Object_MoneyPlace'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioid'
        Value = '0'
        Component = GuidesObject
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCode'
        Value = '0'
        Component = edCode
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioIBAN'
        Value = 44231d
        Component = edIBAN
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioStreet'
        Value = 0.000000000000000000
        Component = edStreet
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioStreet_add'
        Value = 0.000000000000000000
        Component = edStreet_add
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioTaxNumber'
        Value = 0.000000000000000000
        Component = edTaxNumber
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPLZ'
        Value = ''
        Component = edPLZ
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCityName'
        Value = ''
        Component = edCity
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountryName'
        Value = '0'
        Component = edCountry
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioTaxKindId'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountIn'
        Value = Null
        Component = ceAmountIn
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountOut'
        Value = Null
        Component = ceAmountOut
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioName'
        Value = Null
        Component = GuidesObject
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 456
    Top = 128
  end
  object GuidesTaxKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTaxKind
    FormNameParam.Value = 'TTaxKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TTaxKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 350
    Top = 85
  end
  object GuidesCountry: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCountry
    FormNameParam.Value = 'TCountryForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCountryForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCountry
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCountry
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 177
    Top = 123
  end
  object GuidesPLZ: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPLZ
    FormNameParam.Value = 'TPLZForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPLZForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPLZ
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPLZ
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CityName'
        Value = ''
        Component = edCity
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountryName'
        Value = ''
        Component = edCountry
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 241
    Top = 243
  end
  object spUpdate_MoneyPlace: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_MoneyPlace'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = GuidesObject
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = edCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIBAN'
        Value = ''
        Component = edIBAN
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStreet'
        Value = ''
        Component = edStreet
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStreet_add'
        Value = ''
        Component = edStreet_add
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxNumber'
        Value = ''
        Component = edTaxNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPLZ'
        Value = ''
        Component = edPLZ
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCityName'
        Value = ''
        Component = edCity
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountryName'
        Value = ''
        Component = edCountry
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxKindId'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 448
    Top = 176
  end
  object spGet_MoneyPlace_Clear: TdsdStoredProc
    StoredProcName = 'gpGet_Object_MoneyPlace_Clear'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outId'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCode'
        Value = 0.000000000000000000
        Component = edCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'outName'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIBAN'
        Value = ''
        Component = edIBAN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStreet'
        Value = ''
        Component = edStreet
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStreet_add'
        Value = ''
        Component = edStreet_add
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTaxNumber'
        Value = ''
        Component = edTaxNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPLZ'
        Value = ''
        Component = edPLZ
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCityName'
        Value = ''
        Component = edCity
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountryName'
        Value = ''
        Component = edCountry
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTaxKindId'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTaxKindName'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInfoMoneyId'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInfoMoneyName'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 456
    Top = 24
  end
  object spGet_MoneyPlace: TdsdStoredProc
    StoredProcName = 'gpGet_Object_MoneyPlace'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inId'
        Value = Null
        Component = GuidesObject
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCode
        DataType = ftUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'IBAN'
        Value = ''
        Component = edIBAN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Phone'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Street'
        Value = ''
        Component = edStreet
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Street_add'
        Value = ''
        Component = edStreet_add
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PLZId'
        Value = 0.000000000000000000
        Component = GuidesPLZ
        ComponentItem = 'Key'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PLZName'
        Value = ''
        Component = GuidesPLZ
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CityName'
        Value = ''
        Component = edCity
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindId'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindName'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxNumber'
        Value = ''
        Component = edTaxNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountryId'
        Value = ''
        Component = GuidesCountry
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountryName'
        Value = ''
        Component = GuidesCountry
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
        Name = 'InfoMoneyName'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 453
    Top = 66
  end
end
