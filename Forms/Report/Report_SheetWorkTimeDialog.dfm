inherited Report_SheetWorkTimeDialogForm: TReport_SheetWorkTimeDialogForm
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' <'#1054#1090#1095#1077#1090#1072' '#1087#1086' '#1090#1072#1073#1077#1083#1102' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080'>'
  ClientHeight = 196
  ClientWidth = 461
  ExplicitWidth = 467
  ExplicitHeight = 224
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 110
    Top = 152
    ExplicitLeft = 110
    ExplicitTop = 152
  end
  inherited bbCancel: TcxButton
    Left = 254
    Top = 152
    ExplicitLeft = 254
    ExplicitTop = 152
  end
  object cxLabel1: TcxLabel [2]
    Left = 21
    Top = 9
    Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object deStart: TcxDateEdit [3]
    Left = 130
    Top = 8
    EditValue = 41395d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 85
  end
  object cxLabel2: TcxLabel [4]
    Left = 227
    Top = 9
    Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object deEnd: TcxDateEdit [5]
    Left = 343
    Top = 8
    EditValue = 41395d
    Properties.ShowTime = False
    TabOrder = 5
    Width = 85
  end
  object cxLabel17: TcxLabel [6]
    Left = 28
    Top = 46
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object edUnit: TcxButtonEdit [7]
    Left = 130
    Top = 45
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 298
  end
  object cxLabel3: TcxLabel [8]
    Left = 52
    Top = 94
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
  end
  object edMember: TcxButtonEdit [9]
    Left = 130
    Top = 93
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 298
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 124
    Top = 144
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 97
    Top = 144
  end
  inherited ActionList: TActionList
    Left = 152
    Top = 143
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
        Name = 'MemberId'
        Value = Null
        Component = GuidesMember
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = Null
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 9
    Top = 128
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_SheetWorkTimeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_SheetWorkTimeForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
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
    Left = 357
    Top = 32
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 220
    Top = 40
  end
  object GuidesMember: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember
    FormNameParam.Value = 'TMember_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 276
    Top = 80
  end
end
