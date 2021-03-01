inherited IncomeCostForm: TIncomeCostForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1047#1072#1090#1088#1072#1090'>'
  ClientHeight = 269
  ClientWidth = 322
  AddOnFormData.isSingle = False
  ExplicitWidth = 328
  ExplicitHeight = 297
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 43
    Top = 227
    Height = 26
    ExplicitLeft = 43
    ExplicitTop = 227
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 184
    Top = 227
    Height = 26
    ExplicitLeft = 184
    ExplicitTop = 227
    ExplicitHeight = 26
  end
  object cxLabel1: TcxLabel [2]
    Left = 168
    Top = 11
    Caption = #1044#1072#1090#1072
  end
  object Код: TcxLabel [3]
    Left = 8
    Top = 11
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object ceOperDate: TcxDateEdit [4]
    Left = 168
    Top = 34
    EditValue = 43500d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 129
  end
  object cxLabel10: TcxLabel [5]
    Left = 8
    Top = 60
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [6]
    Left = 8
    Top = 80
    TabOrder = 3
    Width = 289
  end
  object edInvNumber: TcxTextEdit [7]
    Left = 8
    Top = 34
    Properties.ReadOnly = True
    TabOrder = 7
    Text = '0'
    Width = 153
  end
  object edMaster: TcxButtonEdit [8]
    Left = 8
    Top = 179
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 289
  end
  object edItemName: TcxTextEdit [9]
    AlignWithMargins = True
    Left = 8
    Top = 157
    ParentCustomHint = False
    BeepOnEnter = False
    Enabled = False
    ParentFont = False
    Properties.HideSelection = False
    Properties.ReadOnly = True
    Style.Edges = []
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.Shadow = False
    Style.TextColor = clNone
    Style.TextStyle = []
    Style.IsFontAssigned = True
    StyleDisabled.BorderColor = clNone
    StyleDisabled.TextColor = clNone
    StyleFocused.BorderColor = clLime
    StyleHot.BorderColor = clSilver
    StyleHot.TextStyle = [fsBold]
    TabOrder = 9
    Text = #1085#1072#1082#1083#1072#1076#1085#1072#1103
    Width = 290
  end
  object cxLabel2: TcxLabel [10]
    Left = 8
    Top = 107
    Caption = #1055#1088#1080#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
  end
  object edIncome: TcxButtonEdit [11]
    Left = 8
    Top = 128
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 289
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 267
    Top = 2
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 153
    Top = 226
  end
  inherited ActionList: TActionList
    Left = 247
    Top = 65
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
        Name = 'inOperDate'
        Value = '0'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 265
    Top = 210
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_IncomeCost'
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
        Name = 'inParentId'
        Value = ''
        Component = GuidesIncome
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        Component = GuidesMaster
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 184
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_IncomeCost'
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
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'inOperDate'
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
        Name = 'Comment'
        Value = ''
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Master'
        Value = Null
        Component = GuidesMaster
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Master_Full'
        Value = Null
        Component = GuidesMaster
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ItemName_Master'
        Value = Null
        Component = edItemName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Income'
        Value = ''
        Component = GuidesIncome
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Income_Full'
        Value = ''
        Component = GuidesIncome
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId_Income'
        Value = Null
        Component = FormParams
        ComponentItem = 'MasterUnitId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName_Income'
        Value = Null
        Component = FormParams
        ComponentItem = 'MasterUnitName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 176
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <>
    ActionItemList = <>
    Left = 216
    Top = 112
  end
  object GuidesMaster: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMaster
    FormNameParam.Value = 'TCostJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCostJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMaster
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMaster
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MasterUnitId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitName'
        Value = Null
        Component = FormParams
        ComponentItem = 'MasterUnitName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOnlyService'
        Value = 'FALSE'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 120
    Top = 167
  end
  object GuidesIncome: TdsdGuides
    KeyField = 'Id'
    LookupControl = edIncome
    FormNameParam.Value = 'TIncomeJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TIncomeJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesIncome
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesIncome
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = FormParams
        ComponentItem = 'MasterUnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = FormParams
        ComponentItem = 'MasterUnitName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 108
  end
end
