inherited Report_MovementProtocolGroupDialogForm: TReport_MovementProtocolGroupDialogForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1080#1079#1084#1077#1085#1077#1085#1080#1081'>'
  ClientHeight = 176
  ClientWidth = 398
  ExplicitWidth = 404
  ExplicitHeight = 204
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 82
    Top = 132
    Height = 26
    ExplicitLeft = 82
    ExplicitTop = 132
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 227
    Top = 132
    Height = 26
    ExplicitLeft = 227
    ExplicitTop = 132
    ExplicitHeight = 26
  end
  object cxLabel1: TcxLabel [2]
    Left = 9
    Top = 9
    Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object deStart: TcxDateEdit [3]
    Left = 100
    Top = 8
    EditValue = 42675d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 80
  end
  object cxLabel2: TcxLabel [4]
    Left = 192
    Top = 9
    Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object deEnd: TcxDateEdit [5]
    Left = 302
    Top = 8
    EditValue = 42675d
    Properties.ShowTime = False
    TabOrder = 5
    Width = 80
  end
  object cbisMovement: TcxCheckBox [6]
    Left = 93
    Top = 32
    Caption = #1087#1077#1088#1080#1086#1076' '#1076#1083#1103' '#1076#1072#1090#1099' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    State = cbsChecked
    TabOrder = 6
    Width = 171
  end
  object cxLabel5: TcxLabel [7]
    Left = 30
    Top = 71
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
  end
  object edUser: TcxButtonEdit [8]
    Left = 116
    Top = 70
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 240
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 296
    Top = 95
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = UserGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = cbisMovement
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
        Component = UnitGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
    Left = 61
    Top = 100
  end
  inherited ActionList: TActionList
    Left = 348
    Top = 134
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
        Name = 'UnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserId'
        Value = Null
        Component = UserGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        Component = UserGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMovement'
        Value = Null
        Component = cbisMovement
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 29
    Top = 100
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 304
    Top = 39
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
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
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 248
    Top = 71
  end
  object UserGuides: TdsdGuides
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
        Component = UserGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UserGuides
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
      end>
    Left = 152
    Top = 68
  end
end
