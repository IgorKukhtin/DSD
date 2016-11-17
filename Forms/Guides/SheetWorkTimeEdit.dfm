object SheetWorkTimeEditForm: TSheetWorkTimeEditForm
  Left = 0
  Top = 0
  Caption = #1053#1086#1074#1099#1081' '#1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099
  ClientHeight = 291
  ClientWidth = 345
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 50
    Top = 251
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 200
    Top = 251
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 1
  end
  object Код: TcxLabel
    Left = 24
    Top = 5
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 24
    Top = 25
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 3
    Width = 65
  end
  object cxLabel3: TcxLabel
    Left = 24
    Top = 98
    Caption = #1044#1085#1080' '#1085#1077#1076#1077#1083#1080' ('#1074#1099#1093#1086#1076#1085#1099#1077')'
  end
  object cxLabel5: TcxLabel
    Left = 24
    Top = 143
    Caption = ' '#9#1042#1088#1077#1084#1103' '#1085#1072#1095#1072#1083#1072
  end
  object cxLabel7: TcxLabel
    Left = 160
    Top = 50
    Caption = #1055#1086#1089#1084#1077#1085#1085#1086' ('#1088#1072#1073'./'#1074#1099#1093'. '#1076#1085')'
  end
  object ceDayOffPeriod: TcxTextEdit
    Left = 160
    Top = 70
    TabOrder = 7
    Width = 144
  end
  object cxLabel8: TcxLabel
    Left = 24
    Top = 190
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit
    Left = 24
    Top = 213
    TabOrder = 9
    Width = 280
  end
  object cxLabel9: TcxLabel
    Left = 98
    Top = 5
    Caption = #1058#1080#1087' '#1076#1085#1103
  end
  object ceDayKind: TcxButtonEdit
    Left = 98
    Top = 25
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 206
  end
  object cxLabel2: TcxLabel
    Left = 24
    Top = 50
    Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '#1088#1072#1089#1095'. '#1087#1077#1088#1080#1086#1076'.'
  end
  object edDayOffPeriod: TcxDateEdit
    Left = 24
    Top = 70
    EditValue = 42690d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 13
    Width = 129
  end
  object cxLabel4: TcxLabel
    Left = 116
    Top = 143
    Caption = #1050#1086#1083'. '#1088#1072#1073'. '#1095#1072#1089#1086#1074
  end
  object cbValue1: TcxCheckBox
    Left = 24
    Top = 116
    Caption = #1055#1085'.'
    TabOrder = 15
    Width = 40
  end
  object cbValue2: TcxCheckBox
    Left = 64
    Top = 116
    Caption = #1042#1090'.'
    TabOrder = 16
    Width = 40
  end
  object cbValue3: TcxCheckBox
    Left = 104
    Top = 116
    Caption = #1057#1088'.'
    TabOrder = 17
    Width = 40
  end
  object cbValue4: TcxCheckBox
    Left = 144
    Top = 116
    Caption = #1063#1090'.'
    TabOrder = 18
    Width = 40
  end
  object cbValue5: TcxCheckBox
    Left = 184
    Top = 116
    Caption = #1055#1090'.'
    TabOrder = 19
    Width = 40
  end
  object cbValue6: TcxCheckBox
    Left = 224
    Top = 116
    Caption = #1057#1073'.'
    TabOrder = 20
    Width = 40
  end
  object cbValue7: TcxCheckBox
    Left = 264
    Top = 116
    Caption = #1042#1089'.'
    TabOrder = 21
    Width = 40
  end
  object edStart: TcxDateEdit
    Left = 24
    Top = 165
    EditValue = 42690d
    Properties.DisplayFormat = 'HH:MM'
    Properties.EditFormat = 'HH:MM'
    Properties.Kind = ckDateTime
    TabOrder = 22
    Width = 80
  end
  object edWork: TcxDateEdit
    Left = 116
    Top = 165
    EditValue = 42690d
    Properties.DisplayFormat = 'HH:MM'
    Properties.EditFormat = 'HH:MM'
    Properties.Kind = ckDateTime
    TabOrder = 23
    Width = 80
  end
  object ActionList: TActionList
    Left = 323
    Top = 180
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_SheetWorkTime'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartTime'
        Value = 0d
        Component = edStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWorkTime'
        Value = ''
        Component = edWork
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDayOffPeriodDate'
        Value = ''
        Component = edDayOffPeriod
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDayOffPeriod'
        Value = ''
        Component = ceDayOffPeriod
        DataType = ftString
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
      end
      item
        Name = 'inValue1'
        Value = ''
        Component = cbValue1
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue2'
        Value = ''
        Component = cbValue2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue3'
        Value = ''
        Component = cbValue3
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue4'
        Value = Null
        Component = cbValue4
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue5'
        Value = Null
        Component = cbValue5
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue6'
        Value = Null
        Component = cbValue6
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue7'
        Value = Null
        Component = cbValue7
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDayKindId'
        Value = ''
        Component = DayKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 315
    Top = 112
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 315
    Top = 160
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_SheetWorkTime'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartTime'
        Value = 0d
        Component = edStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'WorkTime'
        Value = 'NULL'
        Component = edWork
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DayOffPeriodDate'
        Value = 'NULL'
        Component = edDayOffPeriod
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DayOffPeriod'
        Value = ''
        Component = ceDayOffPeriod
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value1'
        Value = ''
        Component = cbValue1
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value2'
        Value = ''
        Component = cbValue2
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value3'
        Value = ''
        Component = cbValue3
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value4'
        Value = ''
        Component = cbValue4
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value5'
        Value = ''
        Component = cbValue5
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value6'
        Value = ''
        Component = cbValue6
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Value7'
        Value = ''
        Component = cbValue7
        DataType = ftBoolean
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
        Name = 'DayKindId'
        Value = ''
        Component = DayKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DayKindName'
        Value = ''
        Component = DayKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 315
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 315
    Top = 231
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 315
    Top = 64
  end
  object DayKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceDayKind
    FormNameParam.Value = 'TDayKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDayKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = DayKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = DayKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 10
  end
end
