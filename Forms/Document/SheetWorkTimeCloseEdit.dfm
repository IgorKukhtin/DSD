inherited SheetWorkTimeCloseEditForm: TSheetWorkTimeCloseEditForm
  Caption = 
    #1044#1086#1082#1091#1084#1077#1085#1090' <'#1044#1086#1082#1091#1084#1077#1085#1090' <'#1047#1072#1082#1088#1099#1090#1080#1077' '#1087#1077#1088#1080#1086#1076#1072', '#1058#1072#1073#1077#1083#1100' '#1091#1095#1077#1090#1072' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084 +
    #1077#1085#1080'>>'
  ClientHeight = 257
  ClientWidth = 284
  AddOnFormData.isSingle = False
  ExplicitWidth = 290
  ExplicitHeight = 285
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 33
    Top = 203
    Height = 26
    ExplicitLeft = 33
    ExplicitTop = 203
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 174
    Top = 203
    Height = 26
    ExplicitLeft = 174
    ExplicitTop = 203
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
    Left = 120
    Top = 202
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
end
