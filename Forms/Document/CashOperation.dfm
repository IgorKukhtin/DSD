inherited CashOperationForm: TCashOperationForm
  ActiveControl = ceAmountIn
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076'>'
  ClientHeight = 365
  ClientWidth = 563
  PopupMenu = PopupMenu
  ExplicitWidth = 569
  ExplicitHeight = 394
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 168
    Top = 329
    ExplicitLeft = 168
    ExplicitTop = 329
  end
  inherited bbCancel: TcxButton
    Left = 312
    Top = 329
    ExplicitLeft = 312
    ExplicitTop = 329
  end
  object cxLabel1: TcxLabel [2]
    Left = 130
    Top = 5
    Caption = #1044#1072#1090#1072
  end
  object Код: TcxLabel [3]
    Left = 15
    Top = 5
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object cxLabel2: TcxLabel [4]
    Left = 430
    Top = 5
    Caption = #1050#1072#1089#1089#1072
  end
  object cxLabel4: TcxLabel [5]
    Left = 15
    Top = 140
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object cxLabel5: TcxLabel [6]
    Left = 245
    Top = 185
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object ceCash: TcxButtonEdit [7]
    Left = 430
    Top = 25
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 120
  end
  object ceUnit: TcxButtonEdit [8]
    Left = 15
    Top = 160
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 215
  end
  object ceInfoMoney: TcxButtonEdit [9]
    Left = 245
    Top = 204
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 305
  end
  object ceOperDate: TcxDateEdit [10]
    Left = 130
    Top = 25
    EditValue = 42475d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 100
  end
  object ceAmountIn: TcxCurrencyEdit [11]
    Left = 15
    Top = 70
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 6
    Width = 100
  end
  object cxLabel7: TcxLabel [12]
    Left = 15
    Top = 52
    Caption = #1055#1088#1080#1093#1086#1076', '#1089#1091#1084#1084#1072
  end
  object ceObject: TcxButtonEdit [13]
    Left = 245
    Top = 160
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 224
  end
  object cxLabel6: TcxLabel [14]
    Left = 245
    Top = 140
    Caption = #1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091
  end
  object cxLabel10: TcxLabel [15]
    Left = 245
    Top = 277
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [16]
    Left = 245
    Top = 297
    TabOrder = 10
    Width = 305
  end
  object cxLabel8: TcxLabel [17]
    Left = 430
    Top = 95
    Caption = #1044#1086#1075#1086#1074#1086#1088
  end
  object ceContract: TcxButtonEdit [18]
    Left = 430
    Top = 115
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 120
  end
  object cxLabel3: TcxLabel [19]
    Left = 130
    Top = 52
    Caption = #1056#1072#1089#1093#1086#1076', '#1089#1091#1084#1084#1072
  end
  object ceAmountOut: TcxCurrencyEdit [20]
    Left = 130
    Top = 70
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 7
    Width = 100
  end
  object edInvNumber: TcxTextEdit [21]
    Left = 15
    Top = 25
    Properties.ReadOnly = True
    TabOrder = 21
    Text = '0'
    Width = 100
  end
  object cxLabel9: TcxLabel [22]
    Left = 245
    Top = 95
    Caption = #1060#1048#1054' ('#1095#1077#1088#1077#1079' '#1082#1086#1075#1086')'
  end
  object ceMember: TcxButtonEdit [23]
    Left = 245
    Top = 115
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 170
  end
  object cxLabel11: TcxLabel [24]
    Left = 15
    Top = 95
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082' '#1079'/'#1087')'
  end
  object cePosition: TcxButtonEdit [25]
    Left = 15
    Top = 115
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 25
    Width = 215
  end
  object cxLabel12: TcxLabel [26]
    Left = 245
    Top = 5
    Caption = #1052#1077#1089#1103#1094' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
  end
  object ceServiceDate: TcxDateEdit [27]
    Left = 245
    Top = 25
    EditValue = 42005d
    Properties.DisplayFormat = 'mmmm yyyy'
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 27
    Width = 170
  end
  object cxLabel13: TcxLabel [28]
    Left = 245
    Top = 52
    Caption = #1050#1091#1088#1089
  end
  object ceCurrencyPartnerValue: TcxCurrencyEdit [29]
    Left = 245
    Top = 70
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    TabOrder = 29
    Width = 68
  end
  object cxLabel14: TcxLabel [30]
    Left = 322
    Top = 52
    Caption = #1053#1086#1084#1080#1085#1072#1083
  end
  object ceParPartnerValue: TcxCurrencyEdit [31]
    Left = 322
    Top = 70
    EditValue = 1.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0.'
    Properties.ReadOnly = False
    TabOrder = 31
    Width = 47
  end
  object cxLabel15: TcxLabel [32]
    Left = 382
    Top = 50
    Caption = #1042#1072#1083#1102#1090#1072
  end
  object ceCurrency: TcxButtonEdit [33]
    Left = 382
    Top = 70
    ParentShowHint = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    ShowHint = False
    TabOrder = 33
    Width = 63
  end
  object cxLabel16: TcxLabel [34]
    Left = 458
    Top = 52
    Caption = 'C'#1091#1084#1084#1072' '#1075#1088#1085', '#1086#1073#1084#1077#1085
  end
  object ceAmountSumm: TcxCurrencyEdit [35]
    Left = 458
    Top = 70
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 35
    Width = 92
  end
  object cxLabel19: TcxLabel [36]
    Left = 15
    Top = 185
    Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077
  end
  object edInvNumberSale: TcxButtonEdit [37]
    Left = 8
    Top = 204
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 37
    Width = 215
  end
  object cxLabel17: TcxLabel [38]
    Left = 15
    Top = 231
    Caption = #8470' '#1076#1086#1082'. '#1057#1095#1077#1090
  end
  object ceInvoice: TcxButtonEdit [39]
    Left = 15
    Top = 252
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 39
    Width = 215
  end
  object cxLabel18: TcxLabel [40]
    Left = 245
    Top = 231
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1076#1086#1082'. '#1057#1095#1077#1090')'
  end
  object ceComment_Invoice: TcxTextEdit [41]
    Left = 245
    Top = 252
    Properties.ReadOnly = True
    TabOrder = 41
    Width = 305
  end
  object cxLabel20: TcxLabel [42]
    Left = 475
    Top = 140
    Caption = #1042#1072#1083#1102#1090#1072' '#1082#1086#1085#1090#1088'.'
  end
  object ceCurrencyPartner: TcxButtonEdit [43]
    Left = 475
    Top = 160
    ParentShowHint = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    ShowHint = False
    TabOrder = 43
    Width = 75
  end
  object cxLabel21: TcxLabel [44]
    Left = 15
    Top = 277
    Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
  end
  object edCar: TcxButtonEdit [45]
    Left = 15
    Top = 300
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 45
    Width = 215
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 83
    Top = 326
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 24
    Top = 326
  end
  inherited ActionList: TActionList
    Left = 135
    Top = 317
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides [0]
    end
    inherited actRefresh: TdsdDataSetRefresh [1]
    end
    inherited FormClose: TdsdFormClose [2]
    end
    object actOpenPositionForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenPositionForm'
      ImageIndex = 7
      FormName = 'TPositionForm'
      FormNameParam.Value = 'TPositionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = GuidesPersonal
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = GuidesPersonal
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited FormParams: TdsdFormParams
    Left = 160
    Top = 318
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Cash'
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
        Name = 'inOperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inServiceDate'
        Value = 41640d
        Component = ceServiceDate
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
        Name = 'inAmountSumm'
        Value = Null
        Component = ceAmountSumm
        DataType = ftFloat
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
      end
      item
        Name = 'inCarId'
        Value = Null
        Component = GuidesCar
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashId'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMoneyPlaceId'
        Value = ''
        Component = GuidesObjectl
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'PositionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Invoice'
        Value = Null
        Component = GuidesInvoice
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId'
        Value = Null
        Component = GuidesCurrency
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyPartnerId'
        Value = Null
        Component = GuidesCurrencyPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyPartnerValue'
        Value = Null
        Component = ceCurrencyPartnerValue
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParPartnerValue'
        Value = Null
        Component = ceParPartnerValue
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Partion'
        Value = Null
        Component = GuidesSaleChoice
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 464
    Top = 262
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Cash'
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
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inCashId_top'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId'
        Value = ''
        Component = FormParams
        ComponentItem = 'inCurrencyId_top'
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
        Name = 'AmountSumm'
        Value = Null
        Component = ceAmountSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceDate'
        Value = 41640d
        Component = ceServiceDate
        DataType = ftDateTime
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
        Name = 'CashId'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashName'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MoneyPlaceId'
        Value = ''
        Component = GuidesObjectl
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MoneyPlaceName'
        Value = ''
        Component = GuidesObjectl
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
        Name = 'MemberId'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractInvNumber'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyPartnerValue'
        Value = Null
        Component = ceCurrencyPartnerValue
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParPartnerValue'
        Value = Null
        Component = ceParPartnerValue
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = Null
        Component = GuidesCurrency
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = Null
        Component = GuidesCurrency
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyPartnerId'
        Value = Null
        Component = GuidesCurrencyPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyPartnerName'
        Value = Null
        Component = GuidesCurrencyPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Partion'
        Value = Null
        Component = GuidesSaleChoice
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionMovementName'
        Value = Null
        Component = GuidesSaleChoice
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
        Component = ceComment_Invoice
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarId'
        Value = Null
        Component = GuidesCar
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarName'
        Value = Null
        Component = GuidesCar
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 411
    Top = 254
  end
  object GuidesCash: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCash
    FormNameParam.Value = 'TCash_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCash_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = Null
        Component = GuidesCurrency
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = Null
        Component = GuidesCurrency
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 472
    Top = 13
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
    Left = 104
    Top = 149
  end
  object GuidesInfoMoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
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
    Left = 376
    Top = 180
  end
  object GuidesObjectl: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceObject
    FormNameParam.Value = 'TMoneyPlaceCash_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMoneyPlaceCash_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesObjectl
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesObjectl
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
        Name = 'ContractId'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Partion'
        Value = Null
        Component = GuidesSaleChoice
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionMovementName'
        Value = Null
        Component = GuidesSaleChoice
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = Null
        Component = GuidesCurrencyPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = Null
        Component = GuidesCurrencyPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarId'
        Value = Null
        Component = GuidesCar
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarName'
        Value = Null
        Component = GuidesCar
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 156
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = GuidesCash
      end>
    ActionItemList = <>
    Left = 512
    Top = 246
  end
  object GuidesContract: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceContract
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = GuidesObjectl
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesObjectl
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
        Name = 'CurrencyId'
        Value = Null
        Component = GuidesCurrencyPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = Null
        Component = GuidesCurrencyPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 480
    Top = 101
  end
  object GuidesPersonal: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesObjectl
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesObjectl
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = ''
        Component = GuidesContract
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
      end>
    Left = 152
    Top = 109
  end
  object GuidesMember: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMember
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 344
    Top = 92
  end
  object GuidesCurrency: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCurrency
    FormNameParam.Value = 'TCurrencyValue_ForCashForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCurrencyValue_ForCashForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCurrency
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCurrency
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParValue'
        Value = Null
        Component = ceParPartnerValue
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyValue'
        Value = Null
        Component = ceCurrencyPartnerValue
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 389
    Top = 64
  end
  object GuidesSaleChoice: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberSale
    Key = '0'
    FormNameParam.Value = 'TSaleJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSaleJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesSaleChoice
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesSaleChoice
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = ''
        Component = GuidesObjectl
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = GuidesObjectl
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 100
    Top = 200
  end
  object GuidesInvoice: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInvoice
    Key = '0'
    FormNameParam.Value = 'TInvoiceJournalDetailChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInvoiceJournalDetailChoiceForm'
    PositionDataSet = 'ClientDataSet'
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
        Name = 'MasterJuridicalId'
        Value = ''
        Component = GuidesObjectl
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = GuidesObjectl
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = ceComment_Invoice
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 148
    Top = 239
  end
  object GuidesCurrencyPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCurrencyPartner
    FormNameParam.Value = 'TCurrencyValue_ForCashForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCurrencyValue_ForCashForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCurrencyPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCurrencyPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 493
    Top = 160
  end
  object GuidesCar: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCar
    FormNameParam.Value = 'TCar_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCar_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCar
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCar
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 278
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 472
    Top = 304
    object N3: TMenuItem
      Action = actOpenPositionForm
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1076#1086#1083#1078#1085#1086#1089#1090#1100
    end
    object N4: TMenuItem
      Caption = '-'
    end
  end
end
