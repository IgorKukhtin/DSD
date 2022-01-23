object Report_RemainsOverGoodsDialogForm: TReport_RemainsOverGoodsDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' < '#1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1081' '#1080#1079#1083#1080#1096#1082#1086#1074' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084'>'
  ClientHeight = 573
  ClientWidth = 355
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 44
    Top = 518
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 218
    Top = 518
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deStart: TcxDateEdit
    Left = 160
    Top = 15
    EditValue = 42370d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 105
  end
  object edUnit: TcxButtonEdit
    Left = 8
    Top = 64
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 305
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 44
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object cxLabel6: TcxLabel
    Left = 10
    Top = 14
    Caption = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1085#1072#1095#1072#1083#1086':'
  end
  object cxLabel1: TcxLabel
    Left = 10
    Top = 112
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1072#1085#1072#1083#1080#1079#1072' '#1053#1058#1047
  end
  object edPeriod: TcxCurrencyEdit
    Left = 217
    Top = 111
    EditValue = 30.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.MinValue = 1.000000000000000000
    TabOrder = 7
    Width = 55
  end
  object cxLabel2: TcxLabel
    Left = 10
    Top = 142
    Caption = #1057#1090#1088#1072#1093#1086#1074#1086#1081' '#1079#1072#1087#1072#1089' '#1053#1058#1047' '#1076#1083#1103' '#1061' '#1076#1085#1077#1081
  end
  object edDay: TcxCurrencyEdit
    Left = 217
    Top = 141
    EditValue = 12.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.MinValue = 1.000000000000000000
    TabOrder = 9
    Width = 55
  end
  object cxLabel4: TcxLabel
    Left = 10
    Top = 174
    Caption = #1048#1079#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1053#1058#1047' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072':'
  end
  object cbOutMCS: TcxCheckBox
    Left = 199
    Top = 174
    Hint = #1076#1083#1103' '#1072#1087#1090#1077#1082'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081' '#1080#1079#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1053#1058#1047' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
    Caption = #1076#1083#1103' '#1072#1087#1090#1077#1082'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081
    TabOrder = 11
    Width = 149
  end
  object cbMCS: TcxCheckBox
    Left = 199
    Top = 201
    Hint = #1076#1083#1103' '#1072#1087#1090#1077#1082'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081' '#1080#1079#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1053#1058#1047' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
    Caption = #1076#1083#1103' '#1072#1087#1090#1077#1082#1080'-'#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
    TabOrder = 12
    Width = 152
  end
  object cbisRecal: TcxCheckBox
    Left = 291
    Top = 15
    Hint = #1076#1083#1103' '#1072#1087#1090#1077#1082'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081' '#1080#1079#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1053#1058#1047' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
    TabOrder = 13
    Width = 22
  end
  object cxLabel7: TcxLabel
    Left = 10
    Top = 239
    Caption = #1054#1089#1090#1072#1074#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1076#1083#1103' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072
  end
  object cbAssortment: TcxCheckBox
    Left = 199
    Top = 238
    Hint = #1076#1083#1103' '#1072#1087#1090#1077#1082'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081' '#1080#1079#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1053#1058#1047' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
    TabOrder = 15
    Width = 21
  end
  object edAssortment: TcxCurrencyEdit
    Left = 226
    Top = 238
    EditValue = 1.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.MinValue = 1.000000000000000000
    TabOrder = 16
    Width = 30
  end
  object cxLabel8: TcxLabel
    Left = 8
    Top = 272
    Caption = #1053#1077' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100' '#1089#1088#1086#1082#1080' '#1084#1077#1085#1077#1077' '#1061#1061#1061' '#1084#1077#1089#1103#1094#1077#1074
  end
  object edTerm: TcxCurrencyEdit
    Left = 267
    Top = 271
    EditValue = 1.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.MinValue = 1.000000000000000000
    TabOrder = 18
    Width = 30
  end
  object cbTerm: TcxCheckBox
    Left = 234
    Top = 271
    Hint = #1076#1083#1103' '#1072#1087#1090#1077#1082'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081' '#1080#1079#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1053#1058#1047' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
    TabOrder = 19
    Width = 22
  end
  object cbReserve: TcxCheckBox
    Left = 8
    Top = 312
    Caption = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1081' '#1090#1086#1074#1072#1088' ('#1044#1072'/'#1053#1077#1090')'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 20
    Width = 248
  end
  object cbIncome: TcxCheckBox
    Left = 8
    Top = 342
    Caption = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1090#1086#1074#1072#1088', '#1087#1088#1080#1096#1077#1076#1096#1080#1081' '#1079#1072' '#1087#1086#1089#1083#1077#1076#1085#1080#1077' '#1061' '#1076#1085#1077#1081
    ParentShowHint = False
    ShowHint = True
    TabOrder = 21
    Width = 305
  end
  object edDayIncome: TcxCurrencyEdit
    Left = 311
    Top = 342
    EditValue = 15.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.MinValue = 1.000000000000000000
    TabOrder = 22
    Width = 26
  end
  object cbSummSend: TcxCheckBox
    Left = 8
    Top = 370
    Hint = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1090#1086#1074#1072#1088', '#1087#1088#1080#1096#1077#1076#1096#1080#1081' '#1079#1072' '#1087#1086#1089#1083#1077#1076#1085#1080#1077' '#1061' '#1076#1085#1077#1081
    Caption = #1053#1077' '#1087#1077#1088#1077#1084#1077#1097#1072#1090#1100' '#1090#1086#1074#1072#1088#1099' '#1085#1072' '#1089#1091#1084#1084#1091' '#1084#1077#1085#1077#1077' '#1061' '#1075#1088#1085
    ParentShowHint = False
    ShowHint = True
    TabOrder = 23
    Width = 253
  end
  object edSummSend: TcxCurrencyEdit
    Left = 263
    Top = 370
    EditValue = 100.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.MinValue = 1.000000000000000000
    TabOrder = 24
    Width = 30
  end
  object cbSendAll: TcxCheckBox
    Left = 8
    Top = 401
    Hint = #1076#1083#1103' '#1072#1087#1090#1077#1082'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081' '#1080#1079#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1053#1058#1047' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
    Caption = #1087#1077#1088#1077#1084#1077#1097#1072#1090#1100' '#1074#1089#1077
    Style.BorderColor = clGray
    Style.Shadow = False
    Style.TextColor = clRed
    TabOrder = 25
    Width = 152
  end
  object cbDayListDiff: TcxCheckBox
    Left = 8
    Top = 428
    Hint = #1076#1083#1103' '#1054#1090#1095#1077#1090#1072' <'#1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1080#1079#1083#1080#1096#1082#1086#1074' '#1085#1072' '#1072#1087#1090#1077#1082#1091'>'
    Caption = #1053#1077' '#1087#1077#1088#1077#1084#1077#1097#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1080#1079' '#1051#1080#1089#1090#1072' '#1054#1090#1082#1072#1079#1072' '#1079#1072' '#1087#1086#1089#1083'. '#1061' '#1076#1085#1077#1081
    ParentShowHint = False
    ShowHint = True
    TabOrder = 26
    Width = 305
  end
  object edDayListDiff: TcxCurrencyEdit
    Left = 311
    Top = 428
    EditValue = 15.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.MinValue = 1.000000000000000000
    TabOrder = 27
    Width = 26
  end
  object cbReserveTo: TcxCheckBox
    Left = 8
    Top = 460
    Hint = #1059#1095#1077#1089#1090#1100' '#1086#1090#1083#1086#1078'. '#1079#1072#1082#1072#1079' '#1076#1083#1103' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103' ('#1044#1072'/'#1053#1077#1090')'
    Caption = #1059#1095#1077#1089#1090#1100' '#1086#1090#1083#1086#1078'. '#1079#1072#1082#1072#1079' '#1076#1083#1103' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103' ('#1088#1072#1089#1087'. '#1080#1079#1083'. '#1085#1072' '#1072#1087#1090#1077#1082#1080')'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 28
    Width = 329
  end
  object cbMCS_0: TcxCheckBox
    Left = 8
    Top = 485
    Hint = #1055#1086#1083#1091#1095#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1089' '#1053#1058#1047' 0'
    Caption = #1055#1086#1083#1091#1095#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1089' '#1053#1058#1047' 0'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 29
    Width = 329
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    Left = 153
    Top = 112
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 212
    Top = 60
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
    Left = 253
    Top = 73
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 41579d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod'
        Value = Null
        Component = edPeriod
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay'
        Value = Null
        Component = edDay
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMCS'
        Value = Null
        Component = cbMCS
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isInMCS'
        Value = Null
        Component = cbOutMCS
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRecal'
        Value = Null
        Component = cbisRecal
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAssortment'
        Value = Null
        Component = cbAssortment
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Assortment'
        Value = Null
        Component = edAssortment
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isTerm'
        Value = Null
        Component = cbTerm
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Term'
        Value = Null
        Component = edTerm
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isReserve'
        Value = Null
        Component = cbReserve
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isIncome'
        Value = Null
        Component = cbIncome
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DayIncome'
        Value = Null
        Component = edDayIncome
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummSend'
        Value = Null
        Component = edSummSend
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSummSend'
        Value = Null
        Component = cbSummSend
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSendAll'
        Value = Null
        Component = cbSendAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DayListDiff'
        Value = Null
        Component = edDayListDiff
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDayListDiff'
        Value = Null
        Component = cbDayListDiff
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisReserveTo'
        Value = Null
        Component = cbReserveTo
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMCS_0'
        Value = Null
        Component = cbMCS_0
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 28
    Top = 107
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    Key = '0'
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 84
    Top = 51
  end
  object ActionList: TActionList
    Left = 153
    Top = 60
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  object spGet_UserUnit: TdsdStoredProc
    StoredProcName = 'gpGet_UserUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'UnitId'
        Value = '0'
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 73
    Top = 128
  end
end
