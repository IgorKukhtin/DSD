inherited SheetWorkTimeAddRecordForm: TSheetWorkTimeAddRecordForm
  ActiveControl = ceMember
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/ '#1080#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
  ClientHeight = 247
  ClientWidth = 358
  ExplicitWidth = 364
  ExplicitHeight = 275
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 66
    Top = 213
    ExplicitLeft = 66
    ExplicitTop = 213
  end
  inherited bbCancel: TcxButton
    Left = 210
    Top = 213
    ExplicitLeft = 210
    ExplicitTop = 213
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
    Width = 338
  end
  object cePosition: TcxButtonEdit [3]
    Left = 182
    Top = 81
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
    Top = 131
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
    Top = 181
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
    Top = 58
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
  end
  object cxLabel3: TcxLabel [10]
    Left = 11
    Top = 58
    Caption = #1056#1072#1079#1088#1103#1076
  end
  object cxLabel4: TcxLabel [11]
    Left = 182
    Top = 108
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object cxLabel5: TcxLabel [12]
    Left = 11
    Top = 108
    Caption = #1041#1088#1080#1075#1072#1076#1072
  end
  object cxLabel6: TcxLabel [13]
    Left = 184
    Top = 159
    Caption = #1044#1072#1090#1072
  end
  object cxLabel7: TcxLabel [14]
    Left = 11
    Top = 158
    Caption = #1051#1080#1085#1080#1103' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
  end
  object ceStorageLine: TcxButtonEdit [15]
    Left = 11
    Top = 181
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 158
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 315
    Top = 160
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
    Top = 208
  end
  inherited ActionList: TActionList
    Left = 39
    Top = 95
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'PositionLevelId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'StorageLineId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 'NULL'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'oldMemberId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'oldPositionId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'oldPositionLevelId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'oldPersonalGroupId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'oldStorageLineId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 8
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionLevelId'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalGroupId'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageLineId'
        Value = Null
        Component = StorageLineGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOldMemberId'
        Value = ''
        Component = FormParams
        ComponentItem = 'oldMemberId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOldPositionId'
        Value = ''
        Component = FormParams
        ComponentItem = 'oldPositionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOldPositionLevelId'
        Value = ''
        Component = FormParams
        ComponentItem = 'oldPositionLevelId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOldPersonalGroupId'
        Value = Null
        Component = FormParams
        ComponentItem = 'oldPersonalGroupId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inoldStorageLineId'
        Value = Null
        Component = FormParams
        ComponentItem = 'oldStorageLineId'
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'inmemberid'
        Value = ''
        Component = FormParams
        ComponentItem = 'MemberId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inpositionid'
        Value = ''
        Component = FormParams
        ComponentItem = 'PositionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inpositionlevelid'
        Value = ''
        Component = FormParams
        ComponentItem = 'PositionLevelId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalGroupId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalGroupId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageLineId'
        Value = Null
        Component = FormParams
        ComponentItem = 'StorageLineId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inoperdate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'unitid'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'unitname'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'memberid'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'membername'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'positionid'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'positionname'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'positionlevelid'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'positionlevelname'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'operdate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupId'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupName'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StorageLineId'
        Value = Null
        Component = StorageLineGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StorageLineName'
        Value = Null
        Component = StorageLineGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 104
  end
  object MemberGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMember
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 104
  end
  object PositionGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePosition
    FormNameParam.Value = 'TPositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PositionGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 272
  end
  object PositionLevelGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePositionLevel
    FormNameParam.Value = 'TPositionLevelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPositionLevelForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PositionLevelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 56
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 264
    Top = 64
  end
  object PersonalGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cepersonalgroup
    FormNameParam.Value = 'TPersonalGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 112
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = ''
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'MemberId'
    IdParam.MultiSelectSeparator = ','
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
  object StorageLineGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStorageLine
    FormNameParam.Value = 'TStorageLineForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStorageLineForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = StorageLineGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = StorageLineGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 63
    Top = 163
  end
end
