inherited CashSendMovementForm: TCashSendMovementForm
  BorderStyle = bsSizeable
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1050#1072#1089#1089#1072', '#1076#1074#1080#1078#1077#1085#1080#1077' '#1076#1077#1085#1077#1075'>'
  ClientHeight = 312
  ClientWidth = 292
  ExplicitWidth = 308
  ExplicitHeight = 351
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 31
    Top = 270
    ExplicitLeft = 31
    ExplicitTop = 270
  end
  inherited bbCancel: TcxButton
    Left = 175
    Top = 270
    ExplicitLeft = 175
    ExplicitTop = 270
  end
  object Код: TcxLabel [2]
    Left = 120
    Top = 28
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object cxLabel1: TcxLabel [3]
    Left = 188
    Top = 5
    Caption = #1044#1072#1090#1072
  end
  object ceOperDate: TcxDateEdit [4]
    Left = 188
    Top = 25
    EditValue = 44575d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 84
  end
  object ceAmountOut: TcxCurrencyEdit [5]
    Left = 8
    Top = 176
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
    Properties.EditFormat = ',0.00##;-,0.00##; ;'
    TabOrder = 4
    Width = 84
  end
  object cxLabel7: TcxLabel [6]
    Left = 8
    Top = 156
    Caption = #1057#1091#1084#1084#1072' '#1088#1072#1089#1093#1086#1076
  end
  object edInvNumber: TcxTextEdit [7]
    Left = 8
    Top = 25
    Properties.ReadOnly = True
    TabOrder = 7
    Text = '0'
    Width = 164
  end
  object edCash_to: TcxButtonEdit [8]
    Left = 8
    Top = 124
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 264
  end
  object cxLabel14: TcxLabel [9]
    Left = 8
    Top = 104
    Caption = #1050#1072#1089#1089#1072' '#1055#1088#1080#1093#1086#1076
  end
  object cxLabel2: TcxLabel [10]
    Left = 8
    Top = 203
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1044#1074#1080#1078#1077#1085#1080#1077' '#1076#1077#1085#1077#1075
  end
  object edCommentMoveMoney: TcxButtonEdit [11]
    Left = 8
    Top = 223
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = False
    TabOrder = 11
    Width = 264
  end
  object cxLabel6: TcxLabel [12]
    Left = 8
    Top = 55
    Caption = #1050#1072#1089#1089#1072' '#1056#1072#1089#1093#1086#1076
  end
  object edCash_from: TcxButtonEdit [13]
    Left = 8
    Top = 75
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 264
  end
  object edCurrencyValue: TcxCurrencyEdit [14]
    Left = 190
    Top = 176
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
    Properties.EditFormat = ',0.00##;-,0.00##; ;'
    TabOrder = 14
    Width = 28
  end
  object cxLabel3: TcxLabel [15]
    Left = 190
    Top = 156
    Caption = #1050#1091#1088#1089
  end
  object edParValue: TcxCurrencyEdit [16]
    Left = 224
    Top = 176
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
    Properties.EditFormat = ',0.00##;-,0.00##; ;'
    TabOrder = 16
    Width = 47
  end
  object cxLabel4: TcxLabel [17]
    Left = 224
    Top = 156
    Caption = #1053#1086#1084#1080#1085#1072#1083
  end
  object cxLabel5: TcxLabel [18]
    Left = 98
    Top = 156
    Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1093#1086#1076
  end
  object ceAmountIn: TcxCurrencyEdit [19]
    Left = 100
    Top = 176
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
    Properties.EditFormat = ',0.00##;-,0.00##; ;'
    TabOrder = 19
    Width = 84
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 112
    Top = 262
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 200
    Top = 250
  end
  inherited ActionList: TActionList
    Left = 279
    Top = 19
    object actRefresh_Amount: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_exit
      StoredProcList = <
        item
          StoredProc = spGet_exit
        end>
      Caption = 'actRefresh_Price'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
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
        Value = Null
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 191
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_CashSend'
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
        Name = 'inoperdate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValue'
        Value = Null
        Component = edCurrencyValue
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParValue'
        Value = Null
        Component = edParValue
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
        Name = 'inAmountIn'
        Value = Null
        Component = ceAmountIn
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashId_from'
        Value = Null
        Component = GuidesCash_from
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashId_to'
        Value = Null
        Component = GuidesCash_to
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCommentMoveMoney'
        Value = 0
        Component = edCommentMoveMoney
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 272
    Top = 75
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_CashSend'
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
        Name = 'OperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyValue'
        Value = Null
        Component = edCurrencyValue
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParValue'
        Value = Null
        Component = edParValue
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
        Name = 'AmountIn'
        Value = Null
        Component = ceAmountIn
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashId_from'
        Value = Null
        Component = GuidesCash_from
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashName_from'
        Value = Null
        Component = GuidesCash_from
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashId_to'
        Value = Null
        Component = GuidesCash_to
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashName_to'
        Value = Null
        Component = GuidesCash_to
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CommentMoveMoneyId'
        Value = ''
        Component = GuidesCommentMoveMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CommentMoveMoneyName'
        Value = ''
        Component = GuidesCommentMoveMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 272
    Top = 139
  end
  object GuidesCash_to: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCash_to
    FormNameParam.Value = 'TCash_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCash_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCash_to
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCash_to
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 81
    Top = 109
  end
  object GuidesCommentMoveMoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCommentMoveMoney
    FormNameParam.Value = 'TCommentInfoMoneyForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCommentInfoMoneyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCommentMoveMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCommentMoveMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKindName'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKindName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 207
  end
  object GuidesCash_from: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCash_from
    FormNameParam.Value = 'TCash_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCash_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCash_from
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCash_from
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 65
    Top = 49
  end
  object HeaderExit: THeaderExit
    ExitList = <
      item
        Control = ceAmountOut
      end>
    Action = actRefresh_Amount
    Left = 176
    Top = 108
  end
  object spGet_exit: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_CashSend_exit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashId_from'
        Value = 0.000000000000000000
        Component = GuidesCash_from
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashId_to'
        Value = 1.000000000000000000
        Component = GuidesCash_to
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyValue'
        Value = 0.000000000000000000
        Component = edCurrencyValue
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParValue'
        Value = 0.000000000000000000
        Component = edParValue
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
        Name = 'inAmountIn'
        Value = Null
        Component = ceAmountIn
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountIn'
        Value = Null
        Component = ceAmountIn
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 184
    Top = 64
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = GuidesCash_from
      end
      item
        Guides = GuidesCash_to
      end>
    ActionItemList = <>
    Left = 128
    Top = 40
  end
end
