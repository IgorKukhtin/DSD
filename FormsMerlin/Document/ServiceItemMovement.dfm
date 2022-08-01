inherited ServiceItemMovementForm: TServiceItemMovementForm
  BorderStyle = bsSizeable
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1059#1089#1083#1086#1074#1080#1103' '#1072#1088#1077#1085#1076#1099' ('#1080#1089#1090#1086#1088#1080#1103')>'
  ClientHeight = 327
  ClientWidth = 342
  ExplicitWidth = 358
  ExplicitHeight = 366
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 55
    Top = 284
    ExplicitLeft = 55
    ExplicitTop = 284
  end
  inherited bbCancel: TcxButton
    Left = 199
    Top = 284
    ExplicitLeft = 199
    ExplicitTop = 284
  end
  object Код: TcxLabel [2]
    Left = 8
    Top = 5
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object cxLabel1: TcxLabel [3]
    Left = 141
    Top = 5
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object ceOperDate: TcxDateEdit [4]
    Left = 141
    Top = 25
    EditValue = 44575d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 84
  end
  object cxLabel5: TcxLabel [5]
    Left = 8
    Top = 160
    Caption = #1057#1090#1072#1090#1100#1103' '#1055#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
  end
  object ceInfoMoney: TcxButtonEdit [6]
    Left = 8
    Top = 180
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 313
  end
  object edInvNumber: TcxTextEdit [7]
    Left = 8
    Top = 25
    Properties.ReadOnly = True
    TabOrder = 7
    Text = '0'
    Width = 122
  end
  object ceUnit: TcxButtonEdit [8]
    Left = 8
    Top = 77
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 313
  end
  object cxLabel14: TcxLabel [9]
    Left = 8
    Top = 57
    Caption = #1054#1090#1076#1077#1083
  end
  object cxLabel2: TcxLabel [10]
    Left = 8
    Top = 215
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1055#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
  end
  object edCommentInfoMoney: TcxButtonEdit [11]
    Left = 8
    Top = 238
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = False
    TabOrder = 11
    Width = 313
  end
  object cxLabel3: TcxLabel [12]
    Left = 8
    Top = 109
    Caption = #1055#1083#1086#1097#1072#1076#1100' :'
  end
  object ceArea: TcxCurrencyEdit [13]
    Left = 8
    Top = 127
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
    Properties.EditFormat = ',0.00##;-,0.00##; ;'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 13
    Width = 89
  end
  object cxLabel6: TcxLabel [14]
    Left = 111
    Top = 109
    Caption = #1062#1077#1085#1072' '#1079#1072' '#1082#1074'.'#1084'. :'
  end
  object cePrice: TcxCurrencyEdit [15]
    Left = 111
    Top = 127
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
    Properties.EditFormat = ',0.00##;-,0.00##; ;'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 15
    Width = 91
  end
  object cxLabel4: TcxLabel [16]
    Left = 216
    Top = 109
    Caption = #1057#1091#1084#1084#1072' '#1079#1072' '#1087#1083#1086#1097#1072#1076#1100' :'
  end
  object ceAmount: TcxCurrencyEdit [17]
    Left = 216
    Top = 127
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
    Properties.EditFormat = ',0.00##;-,0.00##; ;'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 17
    Width = 105
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 136
    Top = 276
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 8
    Top = 260
  end
  inherited ActionList: TActionList
    Left = 287
    Top = 123
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
    Left = 240
    Top = 12
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_ServiceItem'
    Params = <
      item
        Name = 'ioId'
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
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
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
        Name = 'inAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inArea'
        Value = Null
        Component = ceArea
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = cePrice
        DataType = ftFloat
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
        Name = 'ffff'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 221
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ServiceItem'
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
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
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
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
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
        Name = 'Area'
        Value = Null
        Component = ceArea
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Price'
        Value = Null
        Component = cePrice
        DataType = ftFloat
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
        Name = 'fff'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'fff'
        Value = Null
        Component = FormParams
        ComponentItem = 'InfoMoneyId'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'fff'
        Value = Null
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'fff'
        Value = Null
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 304
    Top = 32
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
      end
      item
        Name = 'ParentId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParentName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsService'
        Value = True
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 154
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
    Left = 121
    Top = 50
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
    Top = 225
  end
end
