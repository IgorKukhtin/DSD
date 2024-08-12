inherited Report_UserProtocolDialogForm: TReport_UserProtocolDialogForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1087#1088#1086#1090#1086#1082#1086#1083#1091' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081'>'
  ClientHeight = 232
  ClientWidth = 376
  ExplicitWidth = 382
  ExplicitHeight = 261
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 92
    Top = 192
    ExplicitLeft = 92
    ExplicitTop = 192
  end
  inherited bbCancel: TcxButton
    Left = 237
    Top = 192
    ExplicitLeft = 237
    ExplicitTop = 192
  end
  object cxLabel1: TcxLabel [2]
    Left = 21
    Top = 9
    Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object deStart: TcxDateEdit [3]
    Left = 116
    Top = 8
    EditValue = 42675d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 80
  end
  object cxLabel2: TcxLabel [4]
    Left = 2
    Top = 35
    Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object deEnd: TcxDateEdit [5]
    Left = 116
    Top = 34
    EditValue = 42675d
    Properties.ShowTime = False
    TabOrder = 5
    Width = 80
  end
  object cbisDay: TcxCheckBox [6]
    Left = 203
    Top = 8
    Caption = #1087#1086' '#1044#1085#1103#1084
    State = cbsChecked
    TabOrder = 6
    Width = 76
  end
  object cxLabel3: TcxLabel [7]
    Left = 64
    Top = 62
    Caption = #1060#1080#1083#1080#1072#1083':'
  end
  object edBranch: TcxButtonEdit [8]
    Left = 116
    Top = 59
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 240
  end
  object cxLabel4: TcxLabel [9]
    Left = 22
    Top = 87
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object edUnit: TcxButtonEdit [10]
    Left = 116
    Top = 86
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 240
  end
  object cxLabel5: TcxLabel [11]
    Left = 30
    Top = 112
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
  end
  object edUser: TcxButtonEdit [12]
    Left = 116
    Top = 111
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 240
  end
  object cbShowAll: TcxCheckBox [13]
    Left = 203
    Top = 34
    Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1042#1089#1077
    State = cbsChecked
    TabOrder = 13
    Width = 93
  end
  object ceDiff: TcxCurrencyEdit [14]
    Left = 297
    Top = 34
    EditValue = 10.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 14
    Width = 59
  end
  object cxLabel6: TcxLabel [15]
    Left = 297
    Top = 15
    Caption = #1054#1090#1082#1083'. '#1084#1080#1085'.'
  end
  object cxLabel7: TcxLabel [16]
    Left = 45
    Top = 140
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100':'
  end
  object edPosition: TcxButtonEdit [17]
    Left = 116
    Top = 139
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 240
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 332
    Top = 176
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = GuidesUser
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = cbisDay
        Properties.Strings = (
          'Checked')
      end
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesBranch
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
    Left = 71
    Top = 160
  end
  inherited ActionList: TActionList
    Left = 348
    Top = 71
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchId'
        Value = Null
        Component = GuidesBranch
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchName'
        Value = Null
        Component = GuidesBranch
        ComponentItem = 'TextValue'
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
      end
      item
        Name = 'UserId'
        Value = Null
        Component = GuidesUser
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        Component = GuidesUser
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDay'
        Value = Null
        Component = cbisDay
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isShowAll'
        Value = Null
        Component = cbShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Diff'
        Value = Null
        Component = ceDiff
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId'
        Value = Null
        Component = GuidesPosition
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName'
        Value = Null
        Component = GuidesPosition
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 39
    Top = 160
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 288
    Top = 112
  end
  object GuidesBranch: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 181
    Top = 56
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
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
    Left = 248
    Top = 80
  end
  object GuidesUser: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUser
    FormNameParam.Value = 'TUser_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUser_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUser
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUser
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Object_Goods'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId'
        Value = Null
        Component = GuidesPosition
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionName'
        Value = Null
        Component = GuidesPosition
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 109
  end
  object GuidesPosition: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPosition
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPosition
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPosition
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 217
    Top = 131
  end
end
