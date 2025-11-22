object WeekPeriodDialogForm: TWeekPeriodDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1087#1077#1088#1080#1086#1076#1072' '#1076#1083#1103' '#1087#1086#1083#1091#1095#1077#1085#1080#1103' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 142
  ClientWidth = 397
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 66
    Top = 103
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 240
    Top = 103
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 291
    Top = 17
    EditValue = 43374d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 81
  end
  object deStart: TcxDateEdit
    Left = 177
    Top = 17
    EditValue = 43374d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 82
  end
  object cxLabel6: TcxLabel
    Left = 158
    Top = 18
    Caption = #1089':'
  end
  object cxLabel7: TcxLabel
    Left = 265
    Top = 18
    Caption = #1087#1086':'
  end
  object cxLabel5: TcxLabel
    Left = 158
    Top = 44
    Caption = #1089':'
  end
  object deStart2: TcxDateEdit
    Left = 177
    Top = 44
    EditValue = 41640d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 7
    Width = 82
  end
  object cxLabel1: TcxLabel
    Left = 265
    Top = 44
    Caption = #1087#1086':'
  end
  object deEnd2: TcxDateEdit
    Left = 291
    Top = 43
    EditValue = 41640d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 9
    Width = 81
  end
  object cxLabel4: TcxLabel
    Left = 14
    Top = 18
    Caption = #1053#1077#1076#1077#1083#1103' '#1089':'
  end
  object edWeekNumber1: TcxButtonEdit
    Left = 73
    Top = 17
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 66
  end
  object cxLabel3: TcxLabel
    Left = 7
    Top = 45
    Caption = #1053#1077#1076#1077#1083#1103' '#1087#1086':'
  end
  object edWeekNumber2: TcxButtonEdit
    Left = 73
    Top = 44
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 66
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 192
    Top = 88
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 263
    Top = 70
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
    Left = 200
    Top = 60
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
        Name = 'inStartDate2'
        Value = Null
        Component = deStart2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate2'
        Value = Null
        Component = deEnd2
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
        Component = GuidesWeek_Date2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 151
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
      end>
    Left = 71
    Top = 8
  end
  object GuidesWeek_Date2: TdsdGuides
    KeyField = 'WeekNumber'
    LookupControl = edWeekNumber2
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
        Component = edWeekNumber2
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesWeek_Date2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate_WeekNumber'
        Value = 41640d
        Component = deStart2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate_WeekNumber'
        Value = 41640d
        Component = deEnd2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 111
    Top = 40
  end
end
