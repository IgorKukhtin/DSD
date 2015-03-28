inherited TransportGoodsForm: TTransportGoodsForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1058#1086#1074#1072#1088#1086'-'#1090#1088#1072#1085#1089#1087#1086#1088#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
  ClientHeight = 204
  ClientWidth = 533
  AddOnFormData.isSingle = False
  ExplicitWidth = 539
  ExplicitHeight = 229
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 42
    Top = 163
    Height = 26
    ExplicitLeft = 42
    ExplicitTop = 163
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 183
    Top = 163
    Height = 26
    ExplicitLeft = 183
    ExplicitTop = 163
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
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 129
  end
  object ceFounder: TcxButtonEdit [5]
    Left = 8
    Top = 80
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 174
  end
  object cxLabel6: TcxLabel [6]
    Left = 8
    Top = 61
    Caption = #1059#1095#1088#1077#1076#1080#1090#1077#1083#1100
  end
  object cxLabel10: TcxLabel [7]
    Left = 8
    Top = 108
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit [8]
    Left = 8
    Top = 127
    TabOrder = 4
    Width = 289
  end
  object edInvNumber: TcxTextEdit [9]
    Left = 8
    Top = 34
    Enabled = False
    Properties.ReadOnly = True
    TabOrder = 9
    Text = '0'
    Width = 118
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 267
    Top = 2
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 152
    Top = 162
  end
  inherited ActionList: TActionList
    Left = 271
    Top = 57
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
      end
      item
        Value = '0'
        ParamType = ptUnknown
      end>
    Left = 96
    Top = 170
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_FounderService'
    Params = <
      item
        Name = 'ioid'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'ininvnumber'
        Value = '0'
        Component = edInvNumber
        DataType = ftString
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
        Name = 'inFounderId'
        Value = ''
        Component = FounderGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptUnknown
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = 0d
        DataType = ftDateTime
        ParamType = ptUnknown
      end>
    Left = 112
    Top = 120
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_FounderService'
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'Id'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
      end
      item
        Name = 'InvNumber'
        Value = '0'
        Component = edInvNumber
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = ceOperDate
        DataType = ftDateTime
      end
      item
        Name = 'Amount'
        Value = 0.000000000000000000
        DataType = ftFloat
      end
      item
        Name = 'FounderId'
        Value = ''
        Component = FounderGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'FounderName'
        Value = ''
        Component = FounderGuides
        ComponentItem = 'TextValue'
      end
      item
        Name = 'Comment'
        Value = ''
        Component = ceComment
        DataType = ftString
      end
      item
        Value = 0d
        DataType = ftDateTime
        ParamType = ptUnknown
      end
      item
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = ''
        ParamType = ptUnknown
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
      end
      item
        Value = '0'
        ParamType = ptUnknown
      end>
    Left = 200
    Top = 112
  end
  object FounderGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceFounder
    FormNameParam.Value = 'TFounderForm'
    FormNameParam.DataType = ftString
    FormName = 'TFounderForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FounderGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FounderGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 136
    Top = 71
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Name = 'Id'
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <
      item
      end
      item
        Guides = FounderGuides
      end
      item
      end
      item
      end>
    ActionItemList = <>
    Left = 200
  end
end
