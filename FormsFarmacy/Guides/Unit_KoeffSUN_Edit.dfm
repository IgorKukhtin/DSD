object Unit_KoeffSUN_EditForm: TUnit_KoeffSUN_EditForm
  Left = 0
  Top = 0
  Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
  ClientHeight = 156
  ClientWidth = 296
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
    Left = 37
    Top = 124
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 187
    Top = 124
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object edKoeffInSUN: TcxCurrencyEdit
    Left = 133
    Top = 38
    Hint = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1073#1072#1083#1072#1085#1089#1072' '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 2
    Width = 100
  end
  object edKoeffOutSUN: TcxCurrencyEdit
    Left = 133
    Top = 81
    Hint = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1073#1072#1083#1072#1085#1089#1072' '#1088#1072#1089#1093#1086#1076'/'#1087#1088#1080#1093#1086#1076
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 3
    Width = 100
  end
  object edFormName: TcxTextEdit
    Left = 37
    Top = 8
    Enabled = False
    Properties.ReadOnly = True
    StyleDisabled.TextColor = clBackground
    TabOrder = 4
    Width = 242
  end
  object edKoeffInSUNText: TcxTextEdit
    Left = 23
    Top = 38
    Enabled = False
    Properties.ReadOnly = True
    Style.BorderColor = clHighlightText
    Style.Edges = []
    StyleDisabled.TextColor = clBackground
    TabOrder = 5
    Width = 104
  end
  object edKoeffOutSUNText: TcxTextEdit
    Left = 23
    Top = 81
    Enabled = False
    Properties.ReadOnly = True
    Style.BorderColor = clHighlightText
    Style.Edges = []
    Style.TextStyle = []
    Style.TransparentBorder = True
    StyleDisabled.Color = clBtnFace
    StyleDisabled.TextColor = clBackground
    TabOrder = 6
    Width = 104
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 217
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
    Left = 200
    Top = 10
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inKoeffInSUN'
        Value = Null
        Component = edKoeffInSUN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffOutSUN'
        Value = Null
        Component = edKoeffOutSUN
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        Component = edFormName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'KoeffInSUNText'
        Value = Null
        Component = edKoeffInSUNText
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'KoeffOutSUNText'
        Value = Null
        Component = edKoeffOutSUNText
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 135
    Top = 98
  end
end
