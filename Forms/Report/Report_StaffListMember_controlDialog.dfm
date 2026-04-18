inherited Report_StaffListMember_controlDialogForm: TReport_StaffListMember_controlDialogForm
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' <'#1054#1090#1095#1077#1090#1072' '#1055#1088#1086#1074#1077#1088#1082#1072' <'#1064#1090#1072#1090#1085#1086#1077' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082#1080')>'
  ClientHeight = 196
  ClientWidth = 461
  ExplicitWidth = 467
  ExplicitHeight = 225
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
  object cxLabel17: TcxLabel [2]
    Left = 36
    Top = 15
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object edUnit: TcxButtonEdit [3]
    Left = 130
    Top = 14
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 298
  end
  object cxLabel3: TcxLabel [4]
    Left = 52
    Top = 63
    Caption = #1060#1080#1079'.'#1051#1080#1094#1086':'
  end
  object edMember: TcxButtonEdit [5]
    Left = 130
    Top = 62
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 298
  end
  object cbErased: TcxCheckBox [6]
    Left = 130
    Top = 104
    Caption = #1059#1095#1080#1090#1099#1074#1072#1090#1100' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
    ParentShowHint = False
    ShowHint = False
    TabOrder = 6
    Visible = False
    Width = 140
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
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'isErased'
        Value = Null
        Component = cbErased
        DataType = ftBoolean
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
