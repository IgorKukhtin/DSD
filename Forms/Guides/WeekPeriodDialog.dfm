object WeekPeriodDialogForm: TWeekPeriodDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1087#1077#1088#1080#1086#1076' '#1087#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103
  ClientHeight = 121
  ClientWidth = 391
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 92
    Top = 71
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 240
    Top = 71
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 280
    Top = 17
    EditValue = 45931d
    Properties.ReadOnly = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 81
  end
  object deStart: TcxDateEdit
    Left = 170
    Top = 17
    EditValue = 45931d
    Properties.ReadOnly = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 82
  end
  object cxLabel6: TcxLabel
    Left = 154
    Top = 18
    Caption = #1089':'
  end
  object cxLabel7: TcxLabel
    Left = 254
    Top = 18
    Caption = #1087#1086':'
  end
  object cxLabel4: TcxLabel
    Left = 26
    Top = 18
    Caption = #1053#1077#1076#1077#1083#1103':'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clNavy
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
  end
  object edWeekNumber1: TcxButtonEdit
    Left = 82
    Top = 17
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 66
  end
  object cxLabel3: TcxLabel
    Left = 212
    Top = 45
    Caption = #1053#1077#1076#1077#1083#1103' '#1087#1086':'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clNavy
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    Visible = False
  end
  object edWeekNumber2: TcxCurrencyEdit
    Left = 287
    Top = 44
    ParentFont = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.'
    Properties.EditFormat = ',0.'
    Properties.ReadOnly = True
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.TextColor = clBlue
    Style.IsFontAssigned = True
    TabOrder = 9
    Visible = False
    Width = 60
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 200
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 7
    Top = 46
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Left'
          'Top')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Top = 65532
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inStartDate'
        Value = 41579d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41608d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'WeekNumber1'
        Value = Null
        Component = GuidesWeek_Date1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'WeekNumber2'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 95
    Top = 70
  end
  object GuidesWeek_Date1: TdsdGuides
    KeyField = 'WeekNumber'
    LookupControl = edWeekNumber1
    Key = '0'
    FormNameParam.Value = 'TWeek_DateForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TWeek_DateForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'key'
        Value = ''
        Component = edWeekNumber1
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesWeek_Date1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate_WeekNumber'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate_WeekNumber'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'WeekNumber'
        Value = Null
        Component = edWeekNumber2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 95
    Top = 40
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 48
    Top = 68
    object actRefreshWeek: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetAfterExecute = True
      StoredProc = spGet_Period_byWeekNumber
      StoredProcList = <
        item
          StoredProc = spGet_Period_byWeekNumber
        end>
      Caption = 'actRefresh'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetAfterExecute = True
      StoredProc = spGet_WeekNumber_byPeriod
      StoredProcList = <
        item
          StoredProc = spGet_WeekNumber_byPeriod
        end>
      Caption = 'actRefresh'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsertUpdate: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      ActiveControl = edWeekNumber1
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_WeekNumber_byPeriod
      StoredProcList = <
        item
          StoredProc = spGet_WeekNumber_byPeriod
        end>
      Caption = #1054#1082
      ImageIndex = 80
    end
    object actGet_Period_byWeekNumber: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_Period_byWeekNumber
      StoredProcList = <
        item
          StoredProc = spGet_Period_byWeekNumber
        end>
      Caption = 'actGet_WeekNumber_byPeriod'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actFormClose'
      ImageIndex = 52
    end
    object actGet_WeekNumber_byPeriod: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_WeekNumber_byPeriod
      StoredProcList = <
        item
          StoredProc = spGet_WeekNumber_byPeriod
        end>
      Caption = 'actGet_WeekNumber_byPeriod'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  object spGet_WeekNumber_byPeriod: TdsdStoredProc
    StoredProcName = 'gpGet_WeekNumber_byPeriod'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'WeekNumber1'
        Value = Null
        Component = edWeekNumber1
        MultiSelectSeparator = ','
      end
      item
        Name = 'WeekNumber2'
        Value = Null
        Component = edWeekNumber2
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 184
    Top = 64
  end
  object spGet_Period_byWeekNumber: TdsdStoredProc
    StoredProcName = 'spGet_Period_byWeekNumber'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inWeekNumber1'
        Value = Null
        Component = edWeekNumber1
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'WeekNumber2'
        Value = Null
        Component = edWeekNumber2
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate_WeekNumber'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate_WeekNumber'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 72
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end>
    Left = 264
    Top = 56
  end
  object RefreshDispatcherWeek: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshWeek
    ComponentList = <
      item
        Component = edWeekNumber1
      end>
    Left = 160
    Top = 48
  end
  object HeaderExit: THeaderExit
    ExitList = <
      item
        Control = edWeekNumber1
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Action = actGet_Period_byWeekNumber
    Left = 232
    Top = 76
  end
end
