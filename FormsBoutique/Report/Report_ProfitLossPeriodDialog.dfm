object Report_ProfitLossPeriodDialogForm: TReport_ProfitLossPeriodDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1054' '#1055#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1059#1073#1099#1090#1082#1072#1093'>'
  ClientHeight = 185
  ClientWidth = 301
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
    Left = 18
    Top = 143
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 192
    Top = 143
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd1: TcxDateEdit
    Left = 136
    Top = 42
    EditValue = 43466d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object deStart1: TcxDateEdit
    Left = 11
    Top = 42
    EditValue = 43466d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 90
  end
  object cxLabel9: TcxLabel
    Left = 11
    Top = 77
    Caption = #1055#1077#1088#1080#1086#1076'2 '#1089' :'
  end
  object deStart2: TcxDateEdit
    Left = 11
    Top = 97
    EditValue = 43466d
    Properties.ShowTime = False
    TabOrder = 5
    Width = 90
  end
  object deEnd2: TcxDateEdit
    Left = 136
    Top = 97
    EditValue = 43466d
    Properties.ShowTime = False
    TabOrder = 6
    Width = 90
  end
  object cxLabel10: TcxLabel
    Left = 136
    Top = 77
    Caption = #1055#1077#1088#1080#1086#1076'2 '#1087#1086' :'
  end
  object cxLabel1: TcxLabel
    Left = 11
    Top = 19
    Caption = #1055#1077#1088#1080#1086#1076'1 '#1089' :'
  end
  object cxLabel2: TcxLabel
    Left = 136
    Top = 19
    Caption = #1055#1077#1088#1080#1086#1076'1 '#1087#1086' :'
  end
  object PeriodChoice1: TPeriodChoice
    DateStart = deStart1
    DateEnd = deEnd1
    Left = 112
    Top = 24
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 215
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
    Left = 248
    Top = 12
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate1'
        Value = 41579d
        Component = deStart1
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate1'
        Value = 41608d
        Component = deEnd1
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate2'
        Value = 'NULL'
        Component = deStart2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate2'
        Value = 'NULL'
        Component = deEnd2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 95
    Top = 94
  end
  object PeriodChoice2: TPeriodChoice
    DateStart = deStart2
    DateEnd = deEnd2
    Left = 128
    Top = 120
  end
end
