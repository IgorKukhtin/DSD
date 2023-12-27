inherited BankAccountMovementForm: TBankAccountMovementForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076'>'
  ClientHeight = 368
  ClientWidth = 463
  ExplicitWidth = 469
  ExplicitHeight = 397
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 121
    Top = 328
    ExplicitLeft = 121
    ExplicitTop = 328
  end
  inherited bbCancel: TcxButton
    Left = 257
    Top = 328
    ExplicitLeft = 257
    ExplicitTop = 328
  end
  object Код: TcxLabel [2]
    Left = 8
    Top = 5
    Caption = 'Interne Nr'
  end
  object cxLabel1: TcxLabel [3]
    Left = 147
    Top = 5
    Caption = #1044#1072#1090#1072
  end
  object ceOperDate: TcxDateEdit [4]
    Left = 147
    Top = 25
    EditValue = 44231d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 120
  end
  object cxLabel2: TcxLabel [5]
    Left = 287
    Top = 60
    Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
  end
  object ceBankAccount: TcxButtonEdit [6]
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
  object ceAmountIn: TcxCurrencyEdit [7]
    Left = 8
    Top = 80
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 5
    Width = 120
  end
  object cxLabel7: TcxLabel [8]
    Left = 8
    Top = 60
    Caption = #1055#1088#1080#1093#1086#1076', '#1089#1091#1084#1084#1072
  end
  object ceAmountOut: TcxCurrencyEdit [9]
    Left = 147
    Top = 80
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 6
    Width = 120
  end
  object cxLabel3: TcxLabel [10]
    Left = 147
    Top = 60
    Caption = #1056#1072#1089#1093#1086#1076', '#1089#1091#1084#1084#1072
  end
  object cxLabel6: TcxLabel [11]
    Left = 8
    Top = 115
    Caption = 'Lieferanten / Kunden'
  end
  object ceObject: TcxButtonEdit [12]
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
  object cxLabel10: TcxLabel [13]
    Left = 287
    Top = 222
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [14]
    Left = 287
    Top = 241
    TabOrder = 8
    Width = 159
  end
  object edInvNumber: TcxTextEdit [15]
    Left = 8
    Top = 25
    Properties.ReadOnly = True
    TabOrder = 15
    Text = '0'
    Width = 118
  end
  object ceBank: TcxButtonEdit [16]
    Left = 287
    Top = 135
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 159
  end
  object cxLabel13: TcxLabel [17]
    Left = 287
    Top = 115
    Caption = #1041#1072#1085#1082
  end
  object cxLabel15: TcxLabel [18]
    Left = 8
    Top = 168
    Caption = #8470' '#1076#1086#1082'. '#1057#1095#1077#1090
  end
  object ceInvoice: TcxButtonEdit [19]
    Left = 8
    Top = 189
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 259
  end
  object cxLabel18: TcxLabel [20]
    Left = 287
    Top = 5
    Caption = 'External Nr'
  end
  object edInvNumberPartner: TcxTextEdit [21]
    Left = 287
    Top = 25
    Hint = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' ('#1074#1085#1077#1096#1085#1080#1081')'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 21
    Width = 159
  end
  object cxLabel4: TcxLabel [22]
    Left = 287
    Top = 168
    Caption = #8470' '#1076#1086#1082'. '#1047#1072#1082#1072#1079
  end
  object edParent: TcxButtonEdit [23]
    Left = 287
    Top = 189
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 159
  end
  object bbGuidesInvoiceChoiceForm: TcxButton [24]
    Left = 31
    Top = 284
    Width = 180
    Height = 25
    Action = actGuidesInvoiceChoiceForm
    ParentShowHint = False
    ShowHint = True
    TabOrder = 24
  end
  object bbGuidesParentChoiceForm: TcxButton [25]
    Left = 257
    Top = 284
    Width = 180
    Height = 25
    Hint = #1042#1099#1073#1088#1072#1090#1100' '#8470' '#1076#1086#1082'. '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
    Action = actGuidesParentChoiceForm
    ParentShowHint = False
    ShowHint = True
    TabOrder = 25
  end
  object cxLabel9: TcxLabel [26]
    Left = 8
    Top = 221
    Caption = #1058#1080#1087' '#1089#1095#1077#1090#1072
  end
  object edInvoiceKind: TcxButtonEdit [27]
    Left = 8
    Top = 241
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
    TabOrder = 27
    Width = 259
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 116
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 96
    Top = 172
  end
  inherited ActionList: TActionList
    Left = 191
    Top = 195
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
          Name = 'Comment'
          Value = Null
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
          Name = 'AmountOut'
          Value = Null
          Component = ceAmountOut
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AmountIn'
          Value = Null
          Component = ceAmountIn
          DataType = ftFloat
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
        end
        item
          Name = 'MovementId_parent'
          Value = '0'
          Component = GuidesParent
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_parent'
          Value = ''
          Component = GuidesParent
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_Invoice'
          Value = Null
          Component = GuidesInvoice
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_Invoice'
          Value = Null
          Component = GuidesInvoice
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
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
    Left = 32
    Top = 212
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
        Name = 'ininvnumber'
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
        Name = 'inoperdate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inamountin'
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
        Name = 'inMovementId_Parent'
        Value = Null
        Component = GuidesParent
        ComponentItem = 'Key'
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
    Left = 328
    Top = 232
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
        Component = ceComment
        DataType = ftString
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
        Name = 'Comment_Invoice'
        Value = Null
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
      end>
    Left = 232
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
    Left = 330
    Top = 76
  end
  object GuidesObject: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceObject
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
    Left = 132
    Top = 77
  end
  object GuidesBank: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBank
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
    Left = 363
    Top = 128
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
        Name = 'Comment'
        Value = Null
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
        Name = 'AmountOut'
        Value = Null
        Component = ceAmountOut
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn'
        Value = Null
        Component = ceAmountIn
        DataType = ftFloat
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
      end>
    Left = 196
    Top = 151
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
    Left = 216
    Top = 104
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
        Name = 'MovementId_parent'
        Value = '0'
        Component = GuidesParent
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_parent'
        Value = ''
        Component = GuidesParent
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Invoice'
        Value = Null
        Component = GuidesInvoice
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Invoice'
        Value = Null
        Component = GuidesInvoice
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 356
    Top = 183
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
    Left = 136
    Top = 231
  end
end
