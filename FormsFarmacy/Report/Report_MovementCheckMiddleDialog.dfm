object Report_MovementCheckMiddleDialogForm: TReport_MovementCheckMiddleDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1057#1088#1077#1076#1085#1080#1081' '#1095#1077#1082'>'
  ClientHeight = 327
  ClientWidth = 320
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
    Left = 43
    Top = 291
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 217
    Top = 291
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 121
    Top = 27
    EditValue = 42400d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object deStart: TcxDateEdit
    Left = 10
    Top = 27
    EditValue = 42370d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 90
  end
  object edUnit: TcxButtonEdit
    Left = 10
    Top = 79
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 303
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 59
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object cxLabel6: TcxLabel
    Left = 10
    Top = 7
    Caption = #1044#1072#1090#1072' '#1089' :'
  end
  object cxLabel7: TcxLabel
    Left = 121
    Top = 7
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxLabel8: TcxLabel
    Left = 10
    Top = 193
    Caption = #1055#1088#1077#1076#1077#1083' 1'
  end
  object cxLabel9: TcxLabel
    Left = 10
    Top = 221
    Caption = #1055#1088#1077#1076#1077#1083' 2'
  end
  object ceValue1: TcxCurrencyEdit
    Left = 67
    Top = 192
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 10
    Width = 80
  end
  object ceValue2: TcxCurrencyEdit
    Left = 67
    Top = 220
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 11
    Width = 80
  end
  object cxLabel10: TcxLabel
    Left = 10
    Top = 248
    Caption = #1055#1088#1077#1076#1077#1083' 3'
  end
  object cxLabel11: TcxLabel
    Left = 175
    Top = 193
    Caption = #1055#1088#1077#1076#1077#1083' 4'
  end
  object ceValue3: TcxCurrencyEdit
    Left = 67
    Top = 247
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 14
    Width = 80
  end
  object ceValue4: TcxCurrencyEdit
    Left = 232
    Top = 192
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 15
    Width = 81
  end
  object cxLabel1: TcxLabel
    Left = 175
    Top = 221
    Caption = #1055#1088#1077#1076#1077#1083' 5'
  end
  object cxLabel12: TcxLabel
    Left = 175
    Top = 248
    Caption = #1055#1088#1077#1076#1077#1083' 6'
  end
  object ceValue5: TcxCurrencyEdit
    Left = 232
    Top = 220
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 18
    Width = 81
  end
  object ceValue6: TcxCurrencyEdit
    Left = 232
    Top = 247
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 19
    Width = 81
  end
  object cbisDay: TcxCheckBox
    Left = 234
    Top = 27
    Caption = #1087#1086' '#1044#1085#1103#1084
    TabOrder = 20
    Width = 79
  end
  object cxLabel4: TcxLabel
    Left = 10
    Top = 112
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1076#1080#1085#1072#1084#1080#1082#1072'):'
  end
  object edUnitHistory: TcxButtonEdit
    Left = 10
    Top = 134
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 22
    Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
    Width = 303
  end
  object cxLabel5: TcxLabel
    Left = 10
    Top = 160
    Caption = #1044#1080#1085#1072#1084#1080#1082#1072' '#1079#1072' '
  end
  object ceMonth: TcxCurrencyEdit
    Left = 81
    Top = 159
    EditValue = 5.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Style.Color = clWindow
    TabOrder = 24
    Width = 23
  end
  object cxLabel2: TcxLabel
    Left = 108
    Top = 160
    Caption = #1084#1077#1089#1103#1094#1077#1074
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 170
    Top = 276
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 190
    Top = 57
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
    Left = 250
    Top = 248
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
        Name = 'EndDate'
        Value = 41608d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
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
        Name = 'isDay'
        Value = Null
        Component = cbisDay
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue1'
        Value = Null
        Component = ceValue1
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue2'
        Value = Null
        Component = ceValue2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue3'
        Value = Null
        Component = ceValue3
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue4'
        Value = Null
        Component = ceValue4
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue5'
        Value = Null
        Component = ceValue5
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue6'
        Value = Null
        Component = ceValue6
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitHistoryId'
        Value = Null
        Component = GuidesUnitHistory
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitHistoryName'
        Value = Null
        Component = GuidesUnitHistory
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMonth'
        Value = Null
        Component = ceMonth
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 270
    Top = 9
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
        Name = 'KeyList'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValueList'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 94
    Top = 65
  end
  object ActionList: TActionList
    Left = 155
    Top = 184
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
    Left = 106
    Top = 268
  end
  object GuidesUnitHistory: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitHistory
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitHistory
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitHistory
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 112
  end
end
