object Report_PharmacyPerformanceDialogForm: TReport_PharmacyPerformanceDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1054#1090#1095#1077#1090' '#1101#1092#1092#1077#1082#1090#1080#1074#1085#1086#1089#1090#1080' '#1072#1087#1090#1077#1082'>'
  ClientHeight = 149
  ClientWidth = 392
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
    Left = 70
    Top = 109
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 241
    Top = 109
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 70
    Top = 55
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object deStart: TcxDateEdit
    Left = 70
    Top = 28
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 90
  end
  object cxLabel6: TcxLabel
    Left = 8
    Top = 29
    Caption = #1053#1072#1095'.'#1076#1072#1090#1072':'
  end
  object cxLabel7: TcxLabel
    Left = 8
    Top = 56
    Caption = #1050#1086#1085'.'#1076#1072#1090#1072':'
  end
  object cbSeasonalityCoefficient: TcxCheckBox
    Left = 8
    Top = 82
    Hint = #1057' '#1091#1095#1077#1090#1086#1084' '#1082#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1072' '#1089#1077#1079#1086#1085#1085#1086#1089#1090#1080
    Caption = #1057' '#1091#1095#1077#1090#1086#1084' '#1082#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1072' '#1089#1077#1079#1086#1085#1085#1086#1089#1090#1080
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    Width = 227
  end
  object deEnd2: TcxDateEdit
    Left = 283
    Top = 55
    EditValue = 42371d
    Properties.ShowTime = False
    TabOrder = 7
    Width = 90
  end
  object deStart2: TcxDateEdit
    Left = 283
    Top = 28
    EditValue = 42370d
    Properties.ShowTime = False
    TabOrder = 8
    Width = 90
  end
  object cxLabel3: TcxLabel
    Left = 166
    Top = 56
    Caption = #1050#1086#1085'.'#1076#1072#1090#1072'  '#1087#1077#1088#1080#1086#1076#1072' 2:'
  end
  object cxLabel5: TcxLabel
    Left = 166
    Top = 29
    Caption = #1053#1072#1095'.'#1076#1072#1090#1072' '#1087#1077#1088#1080#1086#1076#1072' 2:'
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 320
    Top = 112
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 79
    Top = 118
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
    Left = 96
    Top = 60
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
        Name = 'StartDateSecond'
        Value = ''
        Component = deStart2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDateSecond'
        Value = ''
        Component = deEnd2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSeasonalityCoefficient'
        Value = Null
        Component = cbSeasonalityCoefficient
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 343
    Top = 30
  end
  object PeriodChoice2: TPeriodChoice
    DateStart = deStart2
    DateEnd = deEnd2
    Left = 336
    Top = 72
  end
end
