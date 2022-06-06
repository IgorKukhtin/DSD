inherited CashMovementForm: TCashMovementForm
  BorderStyle = bsSizeable
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1050#1072#1089#1089#1072'>'
  ClientHeight = 427
  ClientWidth = 337
  ExplicitWidth = 353
  ExplicitHeight = 466
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 55
    Top = 390
    ExplicitLeft = 55
    ExplicitTop = 390
  end
  inherited bbCancel: TcxButton
    Left = 199
    Top = 390
    ExplicitLeft = 199
    ExplicitTop = 390
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
    Top = 75
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
    Properties.EditFormat = ',0.00##;-,0.00##; ;'
    TabOrder = 4
    Width = 97
  end
  object cxLabel7: TcxLabel [6]
    Left = 224
    Top = 55
    Caption = #1057#1091#1084#1084#1072
  end
  object cxLabel5: TcxLabel [7]
    Left = 8
    Top = 195
    Caption = #1057#1090#1072#1090#1100#1103' '#1055#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
  end
  object ceInfoMoney: TcxButtonEdit [8]
    Left = 8
    Top = 215
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
    Top = 119
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 313
  end
  object cxLabel14: TcxLabel [11]
    Left = 8
    Top = 99
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
    Top = 301
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1055#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
  end
  object edCommentInfoMoney: TcxButtonEdit [15]
    Left = 8
    Top = 321
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
    Top = 147
    Caption = #1043#1088#1091#1087#1087#1072' '#1057#1090#1072#1090#1100#1080' '#1055#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
  end
  object ceParent_InfoMoney: TcxButtonEdit [17]
    Left = 8
    Top = 166
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
    Top = 353
    Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1087#1088#1086#1074#1077#1076#1077#1085#1072
    Properties.ReadOnly = True
    TabOrder = 18
    Width = 183
  end
  object cxLabel4: TcxLabel [19]
    Left = 8
    Top = 248
    Caption = #1044#1077#1090#1072#1083#1100#1085#1086' '#1055#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
  end
  object edInfoMoneyDetail: TcxButtonEdit [20]
    Left = 8
    Top = 268
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = False
    TabOrder = 20
    Width = 313
  end
  object edKindName_text: TcxTextEdit [21]
    Left = 265
    Top = 54
    Style.BorderStyle = ebsNone
    Style.Color = clBtnFace
    Style.Edges = [bLeft, bTop, bRight, bBottom]
    Style.HotTrack = True
    Style.TransparentBorder = True
    TabOrder = 21
    Width = 61
  end
  object cxLabel6: TcxLabel [22]
    Left = 8
    Top = 55
    Caption = #1050#1072#1089#1089#1072
  end
  object edCash: TcxButtonEdit [23]
    Left = 8
    Top = 75
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 201
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 136
    Top = 382
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 272
    Top = 362
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
      end
      item
        Name = 'inKindName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKindName_text'
        Value = Null
        Component = edKindName_text
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 140
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
        Name = 'inMI_Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMI_Id'
        ParamType = ptInput
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
        Value = Null
        Component = ceServiceDate
        DataType = ftDateTime
        ParamType = ptInput
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
        Name = 'inCashId'
        Value = Null
        Component = GuidesCash
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
        Name = 'inParent_InfoMoneyId'
        Value = Null
        Component = GuidesParent_infomoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyName'
        Value = ''
        Component = ceInfoMoney
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyDetailName'
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
      end
      item
        Name = 'inKindName'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKindName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 272
    Top = 232
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
        Name = 'inMI_Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMI_Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = Null
        Component = FormParams
        ComponentItem = 'InfoMoneyId'
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
        Name = 'isSign'
        Value = Null
        Component = cbSign
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashId'
        Value = Null
        Component = GuidesCash
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashName'
        Value = Null
        Component = GuidesCash
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MI_Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMI_Id'
        MultiSelectSeparator = ','
      end>
    Left = 232
    Top = 96
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
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
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
      end
      item
        Name = 'inKindName'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKindName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsService'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 189
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
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 73
    Top = 101
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
      end
      item
        Name = 'inKindName'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKindName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 311
  end
  object GuidesParent_infomoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParent_InfoMoney
    FormNameParam.Value = 'TInfoMoneyTreeGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoneyTreeGroupForm'
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
    Top = 149
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
        Name = 'inKindName'
        Value = Null
        Component = FormParams
        ComponentItem = 'inKindName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 168
    Top = 250
  end
  object GuidesCash: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCash
    FormNameParam.Value = 'TCash_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCash_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 65
    Top = 49
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = GuidesCash
      end
      item
        Guides = GuidesInfoMoney
      end>
    ActionItemList = <>
    Left = 128
    Top = 40
  end
end
