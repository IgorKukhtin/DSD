object SheetWorkTimeEditForm: TSheetWorkTimeEditForm
  Left = 0
  Top = 0
  Caption = #1053#1086#1074#1099#1081' '#1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099
  ClientHeight = 375
  ClientWidth = 390
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
  object edName: TcxTextEdit
    Left = 24
    Top = 70
    TabOrder = 0
    Width = 312
  end
  object cxLabel1: TcxLabel
    Left = 24
    Top = 50
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 79
    Top = 338
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 229
    Top = 338
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
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
    TabOrder = 5
    Width = 65
  end
  object cxLabel3: TcxLabel
    Left = 24
    Top = 185
    Caption = #1044#1085#1080' '#1085#1077#1076#1077#1083#1080
  end
  object ceDayOffWeek: TcxTextEdit
    Left = 24
    Top = 205
    TabOrder = 7
    Width = 312
  end
  object cxLabel5: TcxLabel
    Left = 24
    Top = 230
    Caption = ' '#9#1042#1088#1077#1084#1103' '#1085#1072#1095#1072#1083#1072
  end
  object edStart: TcxDateEdit
    Left = 24
    Top = 250
    EditValue = 42690d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 9
    Width = 84
  end
  object cxLabel7: TcxLabel
    Left = 24
    Top = 140
    Caption = #1055#1077#1088#1080#1086#1076#1080#1095#1085#1086#1089#1090#1100' '#1074' '#1076#1085#1103#1093
  end
  object ceDayOffPeriod: TcxTextEdit
    Left = 24
    Top = 158
    TabOrder = 11
    Width = 312
  end
  object cxLabel8: TcxLabel
    Left = 24
    Top = 275
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceComment: TcxTextEdit
    Left = 24
    Top = 295
    TabOrder = 13
    Width = 312
  end
  object cxLabel9: TcxLabel
    Left = 24
    Top = 95
    Caption = #1058#1080#1087' '#1076#1085#1103
  end
  object ceDayKind: TcxButtonEdit
    Left = 24
    Top = 115
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 15
    Width = 312
  end
  object cxLabel2: TcxLabel
    Left = 207
    Top = 230
    Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '#1088#1072#1089#1095'. '#1087#1077#1088#1080#1086#1076'.'
  end
  object edDayOffPeriod: TcxDateEdit
    Left = 207
    Top = 250
    EditValue = 42690d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 17
    Width = 129
  end
  object cxLabel4: TcxLabel
    Left = 116
    Top = 230
    Caption = #1050#1086#1083'. '#1088#1072#1073'. '#1095#1072#1089#1086#1074
  end
  object edWork: TcxDateEdit
    Left = 116
    Top = 250
    EditValue = 42690d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 19
    Width = 84
  end
  object ActionList: TActionList
    Left = 352
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
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRelease'
        Value = 0d
        Component = edStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFullName'
        Value = ''
        Component = ceDayOffPeriod
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSerialNumber'
        Value = ''
        Component = ceDayOffWeek
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPassportNumber'
        Value = ''
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
        Name = 'inAssetGroupId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = DayKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMakerId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriodUse'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
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
    Left = 344
    Top = 160
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_SheetWorkTime'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
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
        Name = 'DayOffWeek'
        Value = ''
        Component = ceDayOffWeek
        DataType = ftString
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
    Left = 344
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 344
    Top = 255
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
    Left = 344
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
    Top = 100
  end
end
