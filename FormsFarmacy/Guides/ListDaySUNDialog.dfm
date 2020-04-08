object ListDaySUNDialogForm: TListDaySUNDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1074#1086#1076' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 130
  ClientWidth = 257
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
    Left = 30
    Top = 85
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 153
    Top = 85
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object edListDaySUN: TcxTextEdit
    Left = 16
    Top = 41
    Hint = #1086#1090' 1 '#1076#1086' 7 '#1095#1077#1088#1077#1079' '#1079#1087#1090'.'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Width = 220
  end
  object cxLabel38: TcxLabel
    Left = 16
    Top = 19
    Caption = #1044#1085#1080' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 143
    Top = 2
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
    Top = 45
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ListDaySUN'
        Value = Null
        Component = edListDaySUN
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 45
    Top = 66
  end
  object PeriodChoice: TPeriodChoice
    Left = 136
    Top = 68
  end
end
