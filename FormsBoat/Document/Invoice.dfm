inherited InvoiceForm: TInvoiceForm
  BorderStyle = bsSizeable
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1057#1095#1077#1090'>'
  ClientHeight = 566
  ClientWidth = 459
  AddOnFormData.isSingle = False
  ExplicitWidth = 475
  ExplicitHeight = 605
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 8
    Top = 552
    Visible = False
    ExplicitLeft = 8
    ExplicitTop = 552
  end
  inherited bbCancel: TcxButton
    Left = 176
    Top = 552
    Visible = False
    ExplicitLeft = 176
    ExplicitTop = 552
  end
  object cxPageControl1: TcxPageControl [2]
    Left = 0
    Top = 0
    Width = 459
    Height = 566
    Align = alClient
    TabOrder = 2
    Properties.ActivePage = Main
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 566
    ClientRectRight = 459
    ClientRectTop = 24
    object Main: TcxTabSheet
      Caption = 'Main'
      ImageIndex = 0
      object Код: TcxLabel
        Left = 15
        Top = 5
        Caption = 'Interne Nr'
      end
      object cxLabel1: TcxLabel
        Left = 178
        Top = 5
        Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      end
      object ceOperDate: TcxDateEdit
        Left = 178
        Top = 25
        EditValue = 44230d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 2
        Width = 100
      end
      object ceAmountIn: TcxCurrencyEdit
        Left = 15
        Top = 123
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        TabOrder = 4
        Width = 84
      end
      object cxLabel7: TcxLabel
        Left = 15
        Top = 103
        Caption = 'Debet'
      end
      object ceAmountOut: TcxCurrencyEdit
        Left = 111
        Top = 123
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        TabOrder = 5
        Width = 84
      end
      object cxLabel3: TcxLabel
        Left = 111
        Top = 103
        Caption = 'Kredit'
      end
      object cxLabel6: TcxLabel
        Left = 15
        Top = 150
        Caption = 'Lieferanten / Kunden'
      end
      object ceObject: TcxButtonEdit
        Left = 15
        Top = 170
        Properties.Buttons = <
          item
            Action = actGuidesObjectChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 6
        Width = 375
      end
      object cxLabel5: TcxLabel
        Left = 15
        Top = 201
        Hint = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      end
      object ceInfoMoney: TcxButtonEdit
        Left = 15
        Top = 222
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 7
        Width = 185
      end
      object cxLabel10: TcxLabel
        Left = 15
        Top = 349
        Caption = #1058#1077#1082#1089#1090
      end
      object cxLabel9: TcxLabel
        Left = 240
        Top = 55
        Caption = #1058#1080#1087' '#1089#1095#1077#1090#1072
      end
      object edPaidKind: TcxButtonEdit
        Left = 317
        Top = 513
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 8
        Visible = False
        Width = 100
      end
      object edInvNumber: TcxTextEdit
        Left = 15
        Top = 25
        Properties.ReadOnly = True
        TabOrder = 14
        Text = '0'
        Width = 96
      end
      object ceUnit: TcxButtonEdit
        Left = 205
        Top = 222
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 17
        Width = 185
      end
      object cxLabel14: TcxLabel
        Left = 205
        Top = 201
        Caption = #1057#1082#1083#1072#1076'/'#1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080
      end
      object cxLabel15: TcxLabel
        Left = 15
        Top = 299
        Caption = 'Boat'
      end
      object ceProduct: TcxButtonEdit
        Left = 15
        Top = 318
        Properties.Buttons = <
          item
            Default = True
            Enabled = False
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 19
        Width = 375
      end
      object cxLabel17: TcxLabel
        Left = 284
        Top = 5
        Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099' ('#1087#1083#1072#1085')'
      end
      object cePlanDate: TcxDateEdit
        Left = 284
        Top = 25
        EditValue = 42005d
        Properties.AssignedValues.DisplayFormat = True
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 21
        Width = 96
      end
      object cxLabel18: TcxLabel
        Left = 15
        Top = 55
        Caption = 'Externe Nr'
      end
      object edInvNumberPartner: TcxTextEdit
        Left = 15
        Top = 75
        Hint = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1082#1083#1080#1077#1085#1090#1072
        ParentShowHint = False
        ShowHint = True
        TabOrder = 23
        Width = 130
      end
      object cxLabel19: TcxLabel
        Left = 156
        Top = 55
        Hint = #1054#1092#1080#1094#1080#1072#1083#1100#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090
        Caption = 'Invoice No'
        ParentShowHint = False
        ShowHint = True
      end
      object edReceiptNumber: TcxTextEdit
        Left = 156
        Top = 75
        Hint = #1054#1092#1080#1094#1080#1072#1083#1100#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090
        ParentFont = False
        ParentShowHint = False
        Properties.ReadOnly = False
        ShowHint = True
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clBlue
        Style.Font.Height = -11
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 25
        Width = 72
      end
      object cxLabel2: TcxLabel
        Left = 211
        Top = 103
        Caption = '% '#1053#1044#1057
      end
      object edVATPercent: TcxCurrencyEdit
        Left = 211
        Top = 123
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00'
        Properties.ReadOnly = True
        TabOrder = 27
        Width = 55
      end
      object cxLabel4: TcxLabel
        Left = 15
        Top = 250
        Caption = #8470' '#1076#1086#1082'. '#1047#1072#1082#1072#1079
      end
      object ceParent: TcxButtonEdit
        Left = 15
        Top = 272
        Properties.Buttons = <
          item
            Action = mactGuidesParentChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 29
        Width = 375
      end
      object cxLabel44: TcxLabel
        Left = 273
        Top = 103
        Caption = #1042#1080#1076' '#1053#1044#1057
      end
      object edTaxKind: TcxButtonEdit
        Left = 273
        Top = 123
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 30
        Width = 117
      end
      object btnGoodsChoiceForm: TcxButton
        Left = 22
        Top = 460
        Width = 180
        Height = 25
        Action = actGuidesObjectChoiceForm
        ParentShowHint = False
        ShowHint = True
        TabOrder = 31
      end
      object btnGuidesParentChoiceForm: TcxButton
        Left = 208
        Top = 460
        Width = 180
        Height = 25
        Action = mactGuidesParentChoiceForm
        ParentShowHint = False
        ShowHint = True
        TabOrder = 32
      end
      object cbAuto: TcxCheckBox
        Left = 121
        Top = 25
        Caption = 'Auto'
        Properties.ReadOnly = True
        TabOrder = 35
        Width = 49
      end
      object cxLabel8: TcxLabel
        Left = 317
        Top = 491
        Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
        Visible = False
      end
      object edInvoiceKind: TcxButtonEdit
        Left = 242
        Top = 75
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
        TabOrder = 33
        Width = 148
      end
      object ceComment: TcxMemo
        Left = 15
        Top = 369
        TabOrder = 36
        Height = 74
        Width = 375
      end
      object cxButton1: TcxButton
        Left = 55
        Top = 505
        Width = 90
        Height = 25
        Action = actInsertUpdateGuides
        ParentShowHint = False
        ShowHint = True
        TabOrder = 37
      end
      object cxButton2: TcxButton
        Left = 242
        Top = 505
        Width = 90
        Height = 25
        Action = actFormClose
        ParentShowHint = False
        ShowHint = True
        TabOrder = 38
      end
    end
    object cxTabSheet2: TcxTabSheet
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
        Left = 3
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
      object cxLabel_19: TcxLabel
        Left = 287
        Top = 53
        Caption = #1058#1080#1087' '#1053#1044#1057
      end
      object edTaxKind_add: TcxButtonEdit
        Left = 287
        Top = 71
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
      object cxLabel_17: TcxLabel
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
        Top = 499
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
        Width = 273
      end
      object cxButton4: TcxButton
        Left = 154
        Top = 499
        Width = 125
        Height = 25
        Action = actInsertUpdate_MoneyPlace
        ParentShowHint = False
        ShowHint = True
        TabOrder = 21
      end
      object cxButton5: TcxButton
        Left = 300
        Top = 499
        Width = 125
        Height = 25
        Action = actClear_MoneyPlace
        ParentShowHint = False
        ShowHint = True
        TabOrder = 22
      end
      object edInfoMoney_moneyplace: TcxButtonEdit
        Left = 3
        Top = 262
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 23
        Width = 273
      end
      object cxLabel24: TcxLabel
        Left = 2
        Top = 239
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 242
    Top = 319
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 335
    Top = 375
  end
  inherited ActionList: TActionList
    Left = 269
    Top = 374
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGet_MoneyPlace
        end>
    end
    object actGetPrepay: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      StoredProc = spGetPrepay
      StoredProcList = <
        item
          StoredProc = spGetPrepay
        end>
      Caption = #1056#1072#1089#1095#1077#1090' '#1087#1088#1077#1076#1086#1087#1083#1072#1090#1099
      Hint = #1056#1072#1089#1095#1077#1090' '#1087#1088#1077#1076#1086#1087#1083#1072#1090#1099
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGetPlanDate: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      StoredProc = spGetPlanDate
      StoredProcList = <
        item
          StoredProc = spGetPlanDate
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
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
          Name = 'DayCalendar'
          Value = ''
          Component = FormParams
          ComponentItem = 'DayCalendar'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
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
          Name = 'TaxKind_Value'
          Value = Null
          Component = edVATPercent
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindId'
          Value = Null
          Component = GuidesPaidKind
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = Null
          Component = GuidesPaidKind
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TaxKindId'
          Value = Null
          Component = GuidesTaxKind
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TaxKindName'
          Value = Null
          Component = GuidesTaxKind
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProductId'
          Value = Null
          Component = GuidesProduct
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProductName'
          Value = Null
          Component = GuidesProduct
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
          Name = 'TaxKindId'
          Value = Null
          Component = GuidesTaxKind_add
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TaxKindName'
          Value = Null
          Component = GuidesTaxKind_add
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = GuidesInfoMoney_moneyplace
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName_all'
          Value = Null
          Component = GuidesInfoMoney_moneyplace
          ComponentItem = 'Key'
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
      FormName = 'TUnion_OrderJournalChoiceForm'
      FormNameParam.Value = 'TUnion_OrderJournalChoiceForm'
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
          Name = 'MasterObjectId'
          Value = Null
          Component = GuidesObject
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterObjectName'
          Value = Null
          Component = GuidesObject
          ComponentItem = 'TextValue'
          DataType = ftString
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
          Name = 'TotalSumm_debet'
          Value = Null
          Component = ceAmountIn
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TotalSumm_credit'
          Value = Null
          Component = ceAmountOut
          DataType = ftFloat
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
          Name = 'TaxKindId'
          Value = Null
          Component = GuidesTaxKind
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TaxKindName'
          Value = Null
          Component = GuidesTaxKind
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindId'
          Value = Null
          Component = GuidesPaidKind
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = Null
          Component = GuidesPaidKind
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProductId'
          Value = Null
          Component = GuidesProduct
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProductName'
          Value = Null
          Component = GuidesProduct
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'VATPercent'
          Value = Null
          Component = edVATPercent
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object mactGuidesParentChoiceForm: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGuidesParentChoiceForm
        end
        item
          Action = actGetPrepay
        end
        item
          Action = actGet_MoneyPlace
        end>
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#8470' '#1076#1086#1082'. '#1047#1072#1082#1072#1079
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#8470' '#1076#1086#1082'. '#1047#1072#1082#1072#1079
      ImageIndex = 7
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
        Name = 'inOperDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_OrderClient'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_OrderClient'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProductId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProductName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ClientId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ClientName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvoiceKindDesc'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 47
    Top = 359
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Invoice'
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
        Name = 'inParentId'
        Value = Null
        Component = GuidesParent
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ininvnumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inoperdate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPlanDate'
        Value = Null
        Component = cePlanDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inVATPercent'
        Value = Null
        Component = edVATPercent
        DataType = ftFloat
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
        Name = 'inamountout'
        Value = 0.000000000000000000
        Component = ceAmountOut
        DataType = ftFloat
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
        Name = 'inReceiptNumber'
        Value = Null
        Component = edReceiptNumber
        DataType = ftString
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
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ininfomoneyid'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = GuidesPaidKind
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
      end>
    Left = 207
    Top = 363
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Invoice'
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
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProductId'
        Value = Null
        Component = FormParams
        ComponentItem = 'ProductId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inClientId'
        Value = Null
        Component = FormParams
        ComponentItem = 'ClientId'
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
        Name = 'inInvoiceKindDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'InvoiceKindDesc'
        DataType = ftString
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
        Name = 'OperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'PlanDate'
        Value = Null
        Component = cePlanDate
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
        Name = 'infomoneyid'
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
        Name = 'ProductId'
        Value = Null
        Component = GuidesProduct
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProductName'
        Value = Null
        Component = GuidesProduct
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
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
        Name = 'ReceiptNumber'
        Value = ''
        Component = edReceiptNumber
        DataType = ftString
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
        Name = 'VATPercent'
        Value = Null
        Component = edVATPercent
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
        Name = 'InvNumber_parent'
        Value = Null
        Component = GuidesParent
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindId'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindName'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAuto'
        Value = Null
        Component = cbAuto
        DataType = ftBoolean
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
    Left = 152
    Top = 360
  end
  object GuidesObject: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceObject
    FormNameParam.Value = 'del_TUnion_ClientPartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'del_TUnion_ClientPartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <>
    Left = 165
    Top = 184
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
    Left = 71
    Top = 213
  end
  object GuidesPaidKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 354
    Top = 468
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 343
    Top = 218
  end
  object GuidesProduct: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceProduct
    DisableGuidesOpen = True
    Key = '0'
    FormNameParam.Value = 'TProductForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProductForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesProduct
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesProduct
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ClientId'
        Value = Null
        Component = GuidesObject
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ClientName'
        Value = Null
        Component = GuidesObject
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = Null
        Component = GuidesInfoMoney
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
        Name = 'TaxKind_Value'
        Value = Null
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 339
    Top = 314
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actGetPlanDate
    ComponentList = <
      item
        Component = GuidesObject
      end>
    Left = 112
    Top = 344
  end
  object spGetPlanDate: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Invoice_PlanDate'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = 42160d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPlanDate'
        Value = Null
        Component = cePlanDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'inObjectId'
        Value = Null
        Component = GuidesObject
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 192
    Top = 8
  end
  object GuidesParent: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParent
    Key = '0'
    FormNameParam.Value = 'del_TUnion_OrderJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'del_TUnion_OrderJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <>
    Left = 339
    Top = 266
  end
  object GuidesTaxKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTaxKind
    DisableGuidesOpen = True
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
    Left = 309
    Top = 130
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
    Left = 386
    Top = 33
  end
  object spGetPrepay: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Invoice_Prepay'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId_order'
        Value = 44230d
        Component = GuidesParent
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
        Name = 'inTotalSumm_debet'
        Value = Null
        Component = ceAmountIn
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountIn'
        Value = 42005d
        Component = ceAmountIn
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 104
    Top = 392
  end
  object spGet_MoneyPlace_Clear: TdsdStoredProc
    StoredProcName = 'gpGet_Object_MoneyPlace_Clear'
    DataSets = <>
    OutputType = otResult
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
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInfoMoneyId'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInfoMoneyName'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInfoMoneyId'
        Value = ''
        Component = GuidesInfoMoney_moneyplace
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInfoMoneyName'
        Value = ''
        Component = GuidesInfoMoney_moneyplace
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 424
    Top = 232
  end
  object spGet_MoneyPlace: TdsdStoredProc
    StoredProcName = 'gpGet_Object_MoneyPlace'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inId'
        Value = ''
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
        Value = ''
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
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = GuidesInfoMoney_moneyplace
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = GuidesInfoMoney_moneyplace
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindId'
        Value = Null
        Component = GuidesTaxKind_add
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindName'
        Value = Null
        Component = GuidesTaxKind_add
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 421
    Top = 274
  end
  object spInsert_MoneyPlace: TdsdStoredProc
    StoredProcName = 'gpInsert_Object_MoneyPlace'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioid'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCode'
        Value = 0.000000000000000000
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
        Value = ''
        Component = edIBAN
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioStreet'
        Value = ''
        Component = edStreet
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioStreet_add'
        Value = ''
        Component = edStreet_add
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioTaxNumber'
        Value = ''
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
        Value = ''
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
        Name = 'ioInfoMoneyId'
        Value = ''
        Component = GuidesInfoMoney_moneyplace
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInfoMoneyName'
        Value = ''
        Component = GuidesInfoMoney_moneyplace
        ComponentItem = 'TextValue'
        DataType = ftString
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
        Name = 'ioName'
        Value = ''
        Component = GuidesObject
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioInfoMoneyId'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInfoMoneyName'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 424
    Top = 336
  end
  object spUpdate_MoneyPlace: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_MoneyPlace'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = ''
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
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = GuidesInfoMoney_moneyplace
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 384
  end
  object GuidesInfoMoney_moneyplace: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInfoMoney_moneyplace
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoney_moneyplace
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoney_moneyplace
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 69
    Top = 292
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
  object GuidesTaxKind_add: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTaxKind_add
    DisableGuidesOpen = True
    FormNameParam.Value = 'TTaxKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TTaxKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTaxKind_add
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTaxKind_add
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 381
    Top = 146
  end
end
