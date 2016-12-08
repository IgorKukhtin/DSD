object ReestrPrintDialogForm: TReestrPrintDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080' '#1088#1077#1077#1089#1090#1088#1072
  ClientHeight = 156
  ClientWidth = 348
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
    Left = 44
    Top = 123
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 218
    Top = 123
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 115
    Top = 76
    EditValue = 42370d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object deStart: TcxDateEdit
    Left = 115
    Top = 44
    EditValue = 42708d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 90
  end
  object cxLabel6: TcxLabel
    Left = 18
    Top = 45
    Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object cxLabel7: TcxLabel
    Left = -1
    Top = 76
    Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object edIsShowAll: TcxCheckBox
    Left = 220
    Top = 45
    Caption = #1079#1072' '#1042#1077#1089#1100' '#1087#1077#1088#1080#1086#1076
    TabOrder = 6
    Width = 110
  end
  object cxLabel27: TcxLabel
    Left = 25
    Top = 10
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1074#1080#1079#1099':'
  end
  object edReestrKind: TcxButtonEdit
    Left = 115
    Top = 9
    ParentFont = False
    Properties.AutoSelect = False
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ClickKey = 0
    Properties.ReadOnly = True
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    TabOrder = 8
    Text = #1055#1086#1083#1091#1095#1077#1085#1086' '#1086#1090' '#1082#1083#1080#1077#1085#1090#1072
    Width = 214
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 146
    Top = 100
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 162
    Top = 71
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
    Left = 304
    Top = 112
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'IsShowAll'
        Value = Null
        Component = edIsShowAll
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReestrKindName'
        Value = Null
        Component = edReestrKind
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate'
        Value = 'NULL'
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 'NULL'
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 21
    Top = 74
  end
end
