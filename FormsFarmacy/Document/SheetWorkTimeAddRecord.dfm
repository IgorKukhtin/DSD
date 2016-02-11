inherited SheetWorkTimeAddRecordForm: TSheetWorkTimeAddRecordForm
  ActiveControl = cePersonal
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1079#1072#1087#1080#1089#1100' '#1074' '#1090#1072#1073#1077#1083#1100' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
  ClientHeight = 219
  ClientWidth = 358
  ExplicitWidth = 364
  ExplicitHeight = 247
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
  object cePersonal: TcxButtonEdit [2]
    Left = 8
    Top = 31
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 2
    Width = 341
  end
  object cePosition: TcxButtonEdit [3]
    Left = 11
    Top = 81
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 3
    Width = 167
  end
  object ceUnit: TcxButtonEdit [4]
    Left = 182
    Top = 81
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 167
  end
  object cepersonalgroup: TcxButtonEdit [5]
    Left = 11
    Top = 131
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 5
    Width = 158
  end
  object ceOperDate: TcxDateEdit [6]
    Left = 182
    Top = 131
    TabOrder = 6
    Width = 167
  end
  object cxLabel1: TcxLabel [7]
    Left = 11
    Top = 8
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
  end
  object cxLabel2: TcxLabel [8]
    Left = 11
    Top = 58
    Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
  end
  object cxLabel4: TcxLabel [9]
    Left = 182
    Top = 58
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object cxLabel5: TcxLabel [10]
    Left = 11
    Top = 108
    Caption = #1041#1088#1080#1075#1072#1076#1072
  end
  object cxLabel6: TcxLabel [11]
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
        Name = 'PersonalId'
        Value = ''
      end
      item
        Name = 'PositionId'
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
        Value = ''
        ParamType = ptUnknown
      end>
    Left = 48
    Top = 120
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_SheetWorkTimeGroup'
    Params = <
      item
        Name = 'inmemberid'
        Value = ''
        Component = PersonalGuides
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
        Name = 'inoldmemberid'
        Value = ''
        Component = FormParams
        ComponentItem = 'MemberId'
        ParamType = ptInput
      end
      item
        Name = 'inoldpositionid'
        Value = ''
        Component = FormParams
        ComponentItem = 'PositionId'
        ParamType = ptInput
      end
      item
        Name = 'inoldpersonalgroupid'
        Value = Null
        Component = FormParams
        ComponentItem = 'PersonalGroupId'
        ParamType = ptInput
      end
      item
        Name = 'inoperdate'
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
        Name = 'inPersonalid'
        Value = ''
        Component = FormParams
        ComponentItem = 'PersonalId'
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
        Name = 'Personalid'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PersonalName'
        Value = ''
        Component = PersonalGuides
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
  object PersonalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonal
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PersonalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PersonalGuides
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
    Left = 88
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
    Left = 136
    Top = 136
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = ''
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'MemberId'
    GuidesList = <
      item
        Guides = PersonalGuides
      end
      item
        Guides = PositionGuides
      end>
    ActionItemList = <>
    Left = 184
    Top = 112
  end
end
