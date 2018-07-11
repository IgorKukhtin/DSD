inherited CashOperationForm: TCashOperationForm
  ActiveControl = ceAmountIn
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076'>'
  ClientHeight = 265
  ClientWidth = 494
  AddOnFormData.isSingle = False
  ExplicitWidth = 500
  ExplicitHeight = 293
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 150
    Top = 225
    ExplicitLeft = 150
    ExplicitTop = 225
  end
  inherited bbCancel: TcxButton
    Left = 294
    Top = 225
    ExplicitLeft = 294
    ExplicitTop = 225
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
    Left = 245
    Top = 5
    Caption = #1050#1072#1089#1089#1072
  end
  object cxLabel4: TcxLabel [5]
    Left = 15
    Top = 159
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object cxLabel5: TcxLabel [6]
    Left = 245
    Top = 105
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object ceCash: TcxButtonEdit [7]
    Left = 245
    Top = 25
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 124
  end
  object ceUnit: TcxButtonEdit [8]
    Left = 15
    Top = 179
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 215
  end
  object ceInfoMoney: TcxButtonEdit [9]
    Left = 245
    Top = 124
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 236
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
    TabOrder = 5
    Width = 100
  end
  object cxLabel7: TcxLabel [12]
    Left = 15
    Top = 52
    Caption = #1055#1088#1080#1093#1086#1076', '#1089#1091#1084#1084#1072
  end
  object ceObject: TcxButtonEdit [13]
    Left = 15
    Top = 124
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 215
  end
  object cxLabel6: TcxLabel [14]
    Left = 15
    Top = 104
    Caption = #1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091
  end
  object cxLabel10: TcxLabel [15]
    Left = 245
    Top = 160
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [16]
    Left = 245
    Top = 179
    TabOrder = 9
    Width = 236
  end
  object cxLabel3: TcxLabel [17]
    Left = 130
    Top = 52
    Caption = #1056#1072#1089#1093#1086#1076', '#1089#1091#1084#1084#1072
  end
  object ceAmountOut: TcxCurrencyEdit [18]
    Left = 130
    Top = 70
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 6
    Width = 100
  end
  object edInvNumber: TcxTextEdit [19]
    Left = 15
    Top = 25
    Properties.ReadOnly = True
    TabOrder = 19
    Text = '0'
    Width = 100
  end
  object cxLabel13: TcxLabel [20]
    Left = 245
    Top = 52
    Caption = #1050#1091#1088#1089
  end
  object ceCurrencyPartnerValue: TcxCurrencyEdit [21]
    Left = 245
    Top = 70
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    TabOrder = 21
    Width = 68
  end
  object cxLabel14: TcxLabel [22]
    Left = 322
    Top = 52
    Caption = #1053#1086#1084#1080#1085#1072#1083
  end
  object ceParPartnerValue: TcxCurrencyEdit [23]
    Left = 322
    Top = 70
    EditValue = 1.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0.'
    Properties.ReadOnly = False
    TabOrder = 23
    Width = 47
  end
  object cxLabel15: TcxLabel [24]
    Left = 389
    Top = 5
    Caption = #1042#1072#1083#1102#1090#1072
  end
  object ceCurrency: TcxButtonEdit [25]
    Left = 389
    Top = 25
    ParentShowHint = False
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    ShowHint = False
    TabOrder = 25
    Width = 92
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 417
    Top = 206
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 14
    Top = 206
  end
  inherited ActionList: TActionList
    Left = 61
    Top = 213
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides [0]
    end
    inherited actRefresh: TdsdDataSetRefresh [1]
    end
    inherited FormClose: TdsdFormClose [2]
    end
  end
  inherited FormParams: TdsdFormParams
    Left = 118
    Top = 222
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
        Name = 'inCashId'
        Value = ''
        Component = CashGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMoneyPlaceId'
        Value = ''
        Component = ObjectlGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
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
        Name = 'inCurrencyId'
        Value = Null
        Component = CurrencyGuides
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
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 456
    Top = 110
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
        Value = 'NULL'
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
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId'
        Value = ''
        Component = FormParams
        ComponentItem = 'inCurrencyId_top'
        ParamType = ptUnknown
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
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceDate'
        Value = 41640d
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
        Component = CashGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashName'
        Value = ''
        Component = CashGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MoneyPlaceId'
        Value = ''
        Component = ObjectlGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MoneyPlaceName'
        Value = ''
        Component = ObjectlGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName'
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
        Name = 'ContractInvNumber'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
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
        Component = CurrencyGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = Null
        Component = CurrencyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyPartnerId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyPartnerName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Partion'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionMovementName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Invoice'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Invoice'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment_Invoice'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 403
    Top = 102
  end
  object CashGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCash
    FormNameParam.Value = 'TCashForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCashForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = CashGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CashGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = Null
        Component = CurrencyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = Null
        Component = CurrencyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 287
    Top = 13
  end
  object UnitGuides: TdsdGuides
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
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 168
  end
  object InfoMoneyGuides: TdsdGuides
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
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 344
    Top = 100
  end
  object ObjectlGuides: TdsdGuides
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
        Component = ObjectlGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ObjectlGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName_all'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
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
        Name = 'PositionId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Partion'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionMovementName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 108
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = CashGuides
      end>
    ActionItemList = <>
    Left = 248
    Top = 214
  end
  object CurrencyGuides: TdsdGuides
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
        Component = CurrencyGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CurrencyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
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
    Left = 340
    Top = 11
  end
end
