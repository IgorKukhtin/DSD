inherited SheetWorkTimeAddRecordForm: TSheetWorkTimeAddRecordForm
  ActiveControl = ceMember
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/ '#1080#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
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
    Properties.ReadOnly = True
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
    Properties.ReadOnly = True
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
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 158
  end
  object ceUnit: TcxButtonEdit [5]
    Left = 182
    Top = 81
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
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
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 158
  end
  object ceOperDate: TcxDateEdit [7]
    Left = 182
    Top = 131
    EditValue = 42452d
    Properties.DisplayFormat = 'mmmm yyyy'
    Properties.ReadOnly = True
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
      end
      item
        Name = 'PositionId'
        Value = ''
      end
      item
        Name = 'PositionLevelId'
        Value = ''
      end
      item
        Name = 'PersonalGroupId'
        Value = Null
      end
      item
        Name = 'UnitId'
        Value = Null
      end
      item
        Name = 'OperDate'
        Value = 'NULL'
        DataType = ftDateTime
      end
      item
        Name = 'oldMemberId'
        Value = ''
      end
      item
        Name = 'oldPositionId'
        Value = ''
      end
      item
        Name = 'oldPositionLevelId'
        Value = ''
      end
      item
        Name = 'oldPersonalGroupId'
        Value = Null
      end>
    Top = 136
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_SheetWorkTimeGroup'
    Params = <
      item
        Name = 'inMemberId'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPositionId'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPositionLevelId'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPersonalGroupId'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inOldMemberId'
        Value = ''
        Component = FormParams
        ComponentItem = 'oldMemberId'
        ParamType = ptInput
      end
      item
        Name = 'inOldPositionId'
        Value = ''
        Component = FormParams
        ComponentItem = 'oldPositionId'
        ParamType = ptInput
      end
      item
        Name = 'inOldPositionLevelId'
        Value = ''
        Component = FormParams
        ComponentItem = 'oldPositionLevelId'
        ParamType = ptInput
      end
      item
        Name = 'inOldPersonalGroupId'
        Value = Null
        Component = FormParams
        ComponentItem = 'oldPersonalGroupId'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Top = 152
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MovementItem_SheetWorkTime'
    Params = <
      item
        Name = 'inunitid'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
      end
      item
        Name = 'inmemberid'
        Value = ''
        Component = FormParams
        ComponentItem = 'MemberId'
        ParamType = ptInput
      end
      item
        Name = 'inpositionid'
        Value = ''
        Component = FormParams
        ComponentItem = 'PositionId'
        ParamType = ptInput
      end
      item
        Name = 'inpositionlevelid'
        Value = ''
        Component = FormParams
        ComponentItem = 'PositionLevelId'
        ParamType = ptInput
      end
      item
        Name = 'inPersonalGroupId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalGroupId'
        ParamType = ptInput
      end
      item
        Name = 'inoperdate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'unitid'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'unitname'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'memberid'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'membername'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'positionid'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'positionname'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'positionlevelid'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'positionlevelname'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'operdate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
      end
      item
        Name = 'PersonalGroupId'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PersonalGroupName'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Top = 152
  end
  object MemberGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMember
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TMember_ObjectForm'
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
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
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
    FormNameParam.Value = 'TPositionLevelForm'
    FormNameParam.DataType = ftString
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
    FormNameParam.Value = 'TUnit_SheetWorkTimeForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnit_SheetWorkTimeForm'
    PositionDataSet = 'MasterCDS'
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
    FormNameParam.Value = 'TPersonalGroupForm'
    FormNameParam.DataType = ftString
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
  object GuidesFiller: TGuidesFiller
    IdParam.Value = ''
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'MemberId'
    GuidesList = <
      item
        Guides = MemberGuides
      end
      item
        Guides = PositionGuides
      end>
    ActionItemList = <>
    Left = 160
    Top = 152
  end
end
