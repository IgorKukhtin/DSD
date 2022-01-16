inherited CashMovementForm: TCashMovementForm
  BorderStyle = bsSizeable
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076'>'
  ClientHeight = 406
  ClientWidth = 341
  ExplicitWidth = 357
  ExplicitHeight = 444
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 55
    Top = 364
    ExplicitLeft = 55
    ExplicitTop = 364
  end
  inherited bbCancel: TcxButton
    Left = 199
    Top = 364
    ExplicitLeft = 199
    ExplicitTop = 364
  end
  object Код: TcxLabel [2]
    Left = 8
    Top = 5
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object cxLabel1: TcxLabel [3]
    Left = 125
    Top = 5
    Caption = #1044#1072#1090#1072
  end
  object ceOperDate: TcxDateEdit [4]
    Left = 125
    Top = 25
    EditValue = 44575d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 84
  end
  object ceAmount: TcxCurrencyEdit [5]
    Left = 224
    Top = 71
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 4
    Width = 97
  end
  object cxLabel7: TcxLabel [6]
    Left = 224
    Top = 51
    Caption = #1057#1091#1084#1084#1072
  end
  object cxLabel5: TcxLabel [7]
    Left = 8
    Top = 147
    Caption = #1057#1090#1072#1090#1100#1103' '#1055#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
  end
  object ceInfoMoney: TcxButtonEdit [8]
    Left = 8
    Top = 167
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = False
    TabOrder = 5
    Width = 313
  end
  object edInvNumber: TcxTextEdit [9]
    Left = 8
    Top = 25
    Properties.ReadOnly = True
    TabOrder = 9
    Text = '0'
    Width = 101
  end
  object ceUnit: TcxButtonEdit [10]
    Left = 8
    Top = 71
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 201
  end
  object cxLabel14: TcxLabel [11]
    Left = 8
    Top = 51
    Caption = #1054#1090#1076#1077#1083
  end
  object cxLabel17: TcxLabel [12]
    Left = 224
    Top = 5
    Caption = #1052#1077#1089#1103#1094' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
  end
  object ceServiceDate: TcxDateEdit [13]
    Left = 224
    Top = 25
    EditValue = 42005d
    Properties.DisplayFormat = 'mmmm yyyy'
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 13
    Width = 97
  end
  object cxLabel2: TcxLabel [14]
    Left = 8
    Top = 253
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1055#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
  end
  object edCommentInfoMoney: TcxButtonEdit [15]
    Left = 8
    Top = 273
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = False
    TabOrder = 15
    Width = 313
  end
  object cxLabel3: TcxLabel [16]
    Left = 8
    Top = 99
    Caption = #1043#1088#1091#1087#1087#1072' '#1057#1090#1072#1090#1100#1080' '#1055#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
  end
  object ceParent_infomoney: TcxButtonEdit [17]
    Left = 8
    Top = 119
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 313
  end
  object cbSign: TcxCheckBox [18]
    Left = 8
    Top = 305
    Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1072
    TabOrder = 18
    Width = 183
  end
  object cbChild: TcxCheckBox [19]
    Left = 8
    Top = 331
    Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1087#1088#1086#1096#1083#1072', '#1076#1072#1085#1085#1099#1077' '#1087#1077#1088#1077#1085#1077#1089#1077#1085#1099' '#1080#1079' Child'
    Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1087#1088#1086#1096#1083#1072
    ParentShowHint = False
    ShowHint = True
    TabOrder = 19
    Width = 146
  end
  object cxLabel4: TcxLabel [20]
    Left = 8
    Top = 200
    Caption = #1057#1090#1072#1090#1100#1103' '#1055#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
  end
  object edInfoMoneyDetail: TcxButtonEdit [21]
    Left = 8
    Top = 220
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = False
    TabOrder = 21
    Width = 313
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 136
    Top = 356
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 272
    Top = 314
  end
  inherited ActionList: TActionList
    Left = 327
    Top = 11
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
      end>
    Left = 272
    Top = 36
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
        Name = 'inServiceDate'
        Value = Null
        Component = ceServiceDate
        DataType = ftDateTime
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
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParent_infomoney'
        Value = Null
        Component = GuidesParent_infomoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ininfomoney'
        Value = ''
        Component = ceInfoMoney
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyDetail'
        Value = Null
        Component = edInfoMoneyDetail
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCommentInfoMoney'
        Value = 0
        Component = edCommentInfoMoney
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 320
    Top = 168
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
        Name = 'inKindName'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKindName'
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
        Name = 'ServiceDate'
        Value = Null
        Component = ceServiceDate
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
        Name = 'infomoneyid'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'infomoneyname'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CommentInfoMoneyId'
        Value = ''
        Component = GuidesCommentInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CommentInfoMoneyName'
        Value = ''
        Component = GuidesCommentInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParentId_InfoMoney'
        Value = Null
        Component = GuidesParent_infomoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParentName_InfoMoney'
        Value = Null
        Component = GuidesParent_infomoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyDetailId'
        Value = Null
        Component = GuidesInfoMoneyDetail
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyDetailName'
        Value = Null
        Component = GuidesInfoMoneyDetail
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isChild'
        Value = Null
        Component = cbSign
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isChild'
        Value = Null
        Component = cbChild
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 320
    Top = 40
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
        Name = 'iniService'
        Value = True
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
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
      end
      item
        Name = 'ParentId'
        Value = Null
        Component = GuidesParent_infomoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParentName'
        Value = Null
        Component = GuidesParent_infomoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 141
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
    Left = 73
    Top = 53
  end
  object GuidesCommentInfoMoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCommentInfoMoney
    FormNameParam.Value = 'TCommentInfoMoneyForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCommentInfoMoneyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCommentInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCommentInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 263
  end
  object GuidesParent_infomoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParent_infomoney
    FormNameParam.Value = 'TInfoMoneyTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoneyTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesParent_infomoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesParent_infomoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'iniService'
        Value = True
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 168
    Top = 101
  end
  object GuidesInfoMoneyDetail: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInfoMoneyDetail
    FormNameParam.Value = 'TInfoMoneyDetail_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoneyDetail_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'iniService'
        Value = True
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoneyDetail
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoneyDetail
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParentId'
        Value = ''
        Component = GuidesParent_infomoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParentName'
        Value = ''
        Component = GuidesParent_infomoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 168
    Top = 202
  end
end
