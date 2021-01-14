inherited ClearDefaultUnitForm: TClearDefaultUnitForm
  Caption = #1054#1095#1080#1089#1090#1082#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  ClientHeight = 194
  ClientWidth = 287
  ExplicitWidth = 303
  ExplicitHeight = 233
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton2: TcxButton [0]
    Left = 173
    Top = 155
    Width = 75
    Height = 25
    Action = actFormClose
    Cancel = True
    ModalResult = 8
    TabOrder = 0
  end
  object cxButton1: TcxButton [1]
    Left = 29
    Top = 155
    Width = 75
    Height = 25
    Action = actFormCloseAndClear
    Default = True
    ModalResult = 8
    TabOrder = 1
  end
  object cxLabel1: TcxLabel [2]
    Left = 12
    Top = 32
    Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1074' '#1072#1082#1082#1072#1091#1085#1090#1077
    AutoSize = False
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1074' '#1074#1072#1096#1077#1084' '#1072#1082#1082#1072#1091#1085#1090#1077'?'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -19
    Style.Font.Name = 'Times New Roman'
    Style.Font.Style = []
    Style.TextStyle = []
    Style.IsFontAssigned = True
    Properties.Alignment.Horz = taCenter
    Properties.Alignment.Vert = taVCenter
    Properties.WordWrap = True
    Height = 81
    Width = 267
    AnchorX = 146
    AnchorY = 73
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 51
    Top = 104
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 24
    Top = 104
  end
  inherited ActionList: TActionList
    Left = 79
    Top = 103
    object actFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1054#1090#1084#1077#1085#1072
    end
    object actFormCloseAndClear: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actClearDefaultUnit
      PostDataSetBeforeExecute = False
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    end
    object actClearDefaultUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spClearDefaultUnit
      StoredProcList = <
        item
          StoredProc = spClearDefaultUnit
        end>
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1074' '#1074#1072#1096#1077#1084' '#1072#1082#1082#1072#1091#1085#1090#1077
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1074' '#1074#1072#1096#1077#1084' '#1072#1082#1082#1072#1091#1085#1090#1077
      ImageIndex = 76
      QuestionBeforeExecute = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1074' '#1074#1072#1096#1077#1084' '#1072#1082#1082#1072#1091#1085#1090#1077'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086'.'
    end
  end
  object spClearDefaultUnit: TdsdStoredProc
    StoredProcName = 'gpUpdate_Clear_DefaultUnitUser'
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 192
    Top = 88
  end
end
