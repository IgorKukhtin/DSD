inherited SheetWorkTimeAddRecordForm: TSheetWorkTimeAddRecordForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1079#1072#1087#1080#1089#1100' '#1074' '#1090#1072#1073#1077#1083#1100' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
  ClientHeight = 219
  ClientWidth = 358
  ExplicitWidth = 364
  ExplicitHeight = 244
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 66
    Top = 176
    ExplicitLeft = 66
    ExplicitTop = 176
  end
  inherited bbCancel: TcxButton
    Left = 210
    Top = 176
    ExplicitLeft = 210
    ExplicitTop = 176
  end
  object ceMember: TcxButtonEdit [2]
    Left = 11
    Top = 31
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 2
    Width = 158
  end
  object cePosition: TcxButtonEdit [3]
    Left = 182
    Top = 31
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 3
    Width = 167
  end
  object cePositionLevel: TcxButtonEdit [4]
    Left = 11
    Top = 81
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 4
    Width = 158
  end
  object ceUnit: TcxButtonEdit [5]
    Left = 182
    Top = 81
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 5
    Width = 167
  end
  object cepersonalgroup: TcxButtonEdit [6]
    Left = 11
    Top = 131
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 6
    Width = 158
  end
  object ceOperDate: TcxDateEdit [7]
    Left = 182
    Top = 131
    TabOrder = 7
    Width = 167
  end
  object cxLabel1: TcxLabel [8]
    Left = 11
    Top = 8
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
  end
  object cxLabel2: TcxLabel [9]
    Left = 182
    Top = 8
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
  end
  object cxLabel3: TcxLabel [10]
    Left = 11
    Top = 58
    Caption = #1056#1072#1079#1088#1103#1076
  end
  object cxLabel4: TcxLabel [11]
    Left = 182
    Top = 58
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object cxLabel5: TcxLabel [12]
    Left = 11
    Top = 108
    Caption = #1041#1088#1080#1075#1072#1076#1072
  end
  object cxLabel6: TcxLabel [13]
    Left = 184
    Top = 109
    Caption = #1044#1072#1090#1072
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 168
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 168
  end
  inherited ActionList: TActionList
    Top = 167
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = nil
      StoredProcList = <>
      Caption = ''
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = '0'
        ParamType = ptInput
      end
      item
        Name = 'MemberId'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'MemberName'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PositionId'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PositionName'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PositionLevelId'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PositionLevelName'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Top = 136
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_SheetWorkTime'
    Params = <
      item
        Name = 'inMemberid'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inpositionid'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inpositionlevelid'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inunitid'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inpersonalgroupid'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inoperdate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'iovalue'
        Value = Null
        DataType = ftString
        ParamType = ptInputOutput
      end
      item
        Name = 'intypeid'
        Value = Null
        ParamType = ptInput
      end>
    Top = 152
  end
  inherited spGet: TdsdStoredProc
    Top = 152
  end
  object MemberGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMember
    FormName = 'TMemberForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 104
  end
  object PositionGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 272
  end
  object PositionLevelGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePositionLevel
    FormName = 'TPositionLevelForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 104
    Top = 56
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 264
    Top = 64
  end
  object PersonalGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cepersonalgroup
    FormName = 'TPersonalGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 80
    Top = 152
  end
end
