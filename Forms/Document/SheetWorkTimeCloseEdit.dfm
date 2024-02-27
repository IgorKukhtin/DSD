inherited SheetWorkTimeCloseEditForm: TSheetWorkTimeCloseEditForm
  Caption = 
    #1044#1086#1082#1091#1084#1077#1085#1090' <'#1044#1086#1082#1091#1084#1077#1085#1090' <'#1047#1072#1082#1088#1099#1090#1080#1077' '#1087#1077#1088#1080#1086#1076#1072', '#1058#1072#1073#1077#1083#1100' '#1091#1095#1077#1090#1072' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084 +
    #1077#1085#1080'>>'
  ClientHeight = 287
  ClientWidth = 263
  AddOnFormData.isSingle = False
  ExplicitWidth = 269
  ExplicitHeight = 316
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 31
    Top = 248
    Height = 26
    ExplicitLeft = 31
    ExplicitTop = 248
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 172
    Top = 248
    Height = 26
    ExplicitLeft = 172
    ExplicitTop = 248
    ExplicitHeight = 26
  end
  object cxLabel1: TcxLabel [2]
    Left = 8
    Top = 63
    Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '#1087#1077#1088#1080#1086#1076#1072
  end
  object Код: TcxLabel [3]
    Left = 8
    Top = 11
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object ceOperDate: TcxDateEdit [4]
    Left = 8
    Top = 86
    EditValue = 44419d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 118
  end
  object edInvNumber: TcxTextEdit [5]
    Left = 8
    Top = 34
    Properties.ReadOnly = True
    TabOrder = 5
    Text = '0'
    Width = 118
  end
  object cxLabel5: TcxLabel [6]
    Left = 136
    Top = 63
    Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095'. '#1087#1077#1088#1080#1086#1076#1072
  end
  object edOperDateEnd: TcxDateEdit [7]
    Left = 136
    Top = 86
    EditValue = 42132d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 7
    Width = 113
  end
  object cxLabel6: TcxLabel [8]
    Left = 8
    Top = 126
    Caption = #1042#1088#1077#1084#1103' '#1072#1074#1090#1086' '#1079#1072#1082#1088#1099#1090#1080#1103
  end
  object edTimeClose: TcxDateEdit [9]
    Left = 8
    Top = 145
    EditValue = 42132d
    Properties.Kind = ckDateTime
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 9
    Width = 118
  end
  object ceUnit: TcxButtonEdit [10]
    Left = 8
    Top = 205
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 241
  end
  object cxLabel4: TcxLabel [11]
    Left = 8
    Top = 182
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077')'
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 131
    Top = 154
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 176
    Top = 130
  end
  inherited ActionList: TActionList
    Left = 239
    Top = 113
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides [0]
    end
    inherited actRefresh: TdsdDataSetRefresh [1]
    end
    inherited FormClose: TdsdFormClose [2]
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
        Name = 'OperDate'
        Value = Null
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 118
    Top = 247
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_SheetWorkTimeClose'
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
        Name = 'ininvnumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inoperdate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateEnd'
        Value = Null
        Component = edOperDateEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTimeClose'
        Value = Null
        Component = edTimeClose
        DataType = ftDateTime
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
      end>
    Left = 216
    Top = 24
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_SheetWorkTimeClose'
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
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = '0'
        Component = edInvNumber
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
        Name = 'OperDateEnd'
        Value = Null
        Component = edOperDateEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'TimeClose'
        Value = Null
        Component = edTimeClose
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
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 16
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
      end
      item
      end
      item
      end
      item
      end>
    ActionItemList = <>
    Left = 48
    Top = 136
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
    Left = 96
    Top = 194
  end
end
