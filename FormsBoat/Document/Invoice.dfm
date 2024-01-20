inherited InvoiceForm: TInvoiceForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1057#1095#1077#1090'>'
  ClientHeight = 534
  ClientWidth = 399
  AddOnFormData.isSingle = False
  ExplicitWidth = 405
  ExplicitHeight = 563
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 105
    Top = 499
    ExplicitLeft = 105
    ExplicitTop = 499
  end
  inherited bbCancel: TcxButton
    Left = 208
    Top = 499
    ExplicitLeft = 208
    ExplicitTop = 499
  end
  object Код: TcxLabel [2]
    Left = 15
    Top = 5
    Caption = 'Interne Nr'
  end
  object cxLabel1: TcxLabel [3]
    Left = 178
    Top = 5
    Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object ceOperDate: TcxDateEdit [4]
    Left = 178
    Top = 25
    EditValue = 44230d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 100
  end
  object ceAmountIn: TcxCurrencyEdit [5]
    Left = 15
    Top = 123
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 4
    Width = 84
  end
  object cxLabel7: TcxLabel [6]
    Left = 15
    Top = 103
    Caption = 'Debet'
  end
  object ceAmountOut: TcxCurrencyEdit [7]
    Left = 111
    Top = 123
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 5
    Width = 84
  end
  object cxLabel3: TcxLabel [8]
    Left = 111
    Top = 103
    Caption = 'Kredit'
  end
  object cxLabel6: TcxLabel [9]
    Left = 15
    Top = 150
    Caption = 'Lieferanten / Kunden'
  end
  object ceObject: TcxButtonEdit [10]
    Left = 15
    Top = 170
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 375
  end
  object cxLabel5: TcxLabel [11]
    Left = 15
    Top = 201
    Hint = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object ceInfoMoney: TcxButtonEdit [12]
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
  object cxLabel10: TcxLabel [13]
    Left = 15
    Top = 349
    Caption = #1058#1077#1082#1089#1090
  end
  object cxLabel9: TcxLabel [14]
    Left = 240
    Top = 55
    Caption = #1058#1080#1087' '#1089#1095#1077#1090#1072
  end
  object edPaidKind: TcxButtonEdit [15]
    Left = 317
    Top = 505
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
  object edInvNumber: TcxTextEdit [16]
    Left = 15
    Top = 25
    Properties.ReadOnly = True
    TabOrder = 16
    Text = '0'
    Width = 96
  end
  object ceUnit: TcxButtonEdit [17]
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
  object cxLabel14: TcxLabel [18]
    Left = 205
    Top = 201
    Caption = #1057#1082#1083#1072#1076'/'#1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080
  end
  object cxLabel15: TcxLabel [19]
    Left = 15
    Top = 299
    Caption = 'Boat'
  end
  object ceProduct: TcxButtonEdit [20]
    Left = 15
    Top = 318
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 20
    Width = 375
  end
  object cxLabel17: TcxLabel [21]
    Left = 284
    Top = 5
    Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099' ('#1087#1083#1072#1085')'
  end
  object cePlanDate: TcxDateEdit [22]
    Left = 284
    Top = 25
    EditValue = 42005d
    Properties.AssignedValues.DisplayFormat = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 22
    Width = 96
  end
  object cxLabel18: TcxLabel [23]
    Left = 15
    Top = 55
    Caption = 'Externe Nr'
  end
  object edInvNumberPartner: TcxTextEdit [24]
    Left = 15
    Top = 75
    Hint = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1082#1083#1080#1077#1085#1090#1072
    ParentShowHint = False
    ShowHint = True
    TabOrder = 24
    Width = 130
  end
  object cxLabel19: TcxLabel [25]
    Left = 156
    Top = 55
    Hint = #1054#1092#1080#1094#1080#1072#1083#1100#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090
    Caption = 'Invoice No'
    ParentShowHint = False
    ShowHint = True
  end
  object edReceiptNumber: TcxTextEdit [26]
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
    TabOrder = 26
    Width = 72
  end
  object cxLabel2: TcxLabel [27]
    Left = 211
    Top = 103
    Caption = '% '#1053#1044#1057
  end
  object edVATPercent: TcxCurrencyEdit [28]
    Left = 211
    Top = 123
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    Properties.ReadOnly = True
    TabOrder = 28
    Width = 55
  end
  object cxLabel4: TcxLabel [29]
    Left = 15
    Top = 250
    Caption = #8470' '#1076#1086#1082'. '#1047#1072#1082#1072#1079
  end
  object ceParent: TcxButtonEdit [30]
    Left = 15
    Top = 272
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 30
    Width = 375
  end
  object cxLabel44: TcxLabel [31]
    Left = 273
    Top = 103
    Caption = #1042#1080#1076' '#1053#1044#1057
  end
  object edTaxKind: TcxButtonEdit [32]
    Left = 273
    Top = 123
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 32
    Width = 117
  end
  object btnGoodsChoiceForm: TcxButton [33]
    Left = 22
    Top = 460
    Width = 180
    Height = 25
    Action = actObjectChoiceForm
    ParentShowHint = False
    ShowHint = True
    TabOrder = 33
  end
  object btnGuidesParentChoiceForm: TcxButton [34]
    Left = 208
    Top = 460
    Width = 180
    Height = 25
    Action = mactGuidesParentChoiceForm
    ParentShowHint = False
    ShowHint = True
    TabOrder = 34
  end
  object cbAuto: TcxCheckBox [35]
    Left = 121
    Top = 25
    Caption = 'Auto'
    Properties.ReadOnly = True
    TabOrder = 35
    Width = 49
  end
  object cxLabel8: TcxLabel [36]
    Left = 317
    Top = 491
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
    Visible = False
  end
  object edInvoiceKind: TcxButtonEdit [37]
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
    TabOrder = 37
    Width = 148
  end
  object ceComment: TcxMemo [38]
    Left = 15
    Top = 369
    TabOrder = 38
    Height = 74
    Width = 375
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
    object actObjectChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1042#1099#1073#1086#1088' Lieferanten / Kunden'
      Hint = #1042#1099#1073#1086#1088' Lieferanten / Kunden'
      ImageIndex = 7
      FormName = 'TUnion_ClientPartnerForm'
      FormNameParam.Value = 'TUnion_ClientPartnerForm'
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
        end>
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#8470' '#1076#1086#1082'. '#1047#1072#1082#1072#1079
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#8470' '#1076#1086#1082'. '#1047#1072#1082#1072#1079
      ImageIndex = 7
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
    FormNameParam.Value = 'TUnion_ClientPartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnion_ClientPartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
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
      end>
    Left = 341
    Top = 168
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
    Left = 151
    Top = 221
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
    Top = 508
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
    Left = 307
    Top = 298
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
    Left = 232
    Top = 24
  end
  object GuidesParent: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParent
    Key = '0'
    FormNameParam.Value = 'TUnion_OrderJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnion_OrderJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
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
      end>
    Left = 347
    Top = 274
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
    Left = 341
    Top = 114
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
    Left = 338
    Top = 65
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
end
