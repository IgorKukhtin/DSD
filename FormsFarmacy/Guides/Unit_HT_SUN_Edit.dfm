object Unit_HT_SUN_EditForm: TUnit_HT_SUN_EditForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
  ClientHeight = 274
  ClientWidth = 347
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
    Left = 45
    Top = 225
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 203
    Top = 225
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object edHT_SUN_v1: TcxCurrencyEdit
    Left = 17
    Top = 34
    Hint = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1073#1072#1083#1072#1085#1089#1072' '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 2
    Width = 238
  end
  object edHT_SUN_v2: TcxCurrencyEdit
    Left = 17
    Top = 84
    Hint = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1073#1072#1083#1072#1085#1089#1072' '#1088#1072#1089#1093#1086#1076'/'#1087#1088#1080#1093#1086#1076
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 3
    Width = 238
  end
  object cxLabel7: TcxLabel
    Left = 17
    Top = 15
    Caption = #1050#1086#1083'. '#1076#1085#1077#1081' '#1076#1083#1103' HammerTime ('#1057#1059#1053')'
  end
  object cxLabel1: TcxLabel
    Left = 17
    Top = 61
    Caption = #1050#1086#1083'. '#1076#1085#1077#1081' '#1076#1083#1103' HammerTime('#1057#1059#1053'-2)'
  end
  object cxLabel2: TcxLabel
    Left = 17
    Top = 117
    Caption = #1050#1086#1083'. '#1076#1085#1077#1081' '#1076#1083#1103' HammerTime('#1057#1059#1053'-2-'#1055#1048')'
  end
  object edHT_SUN_v4: TcxCurrencyEdit
    Left = 17
    Top = 140
    Hint = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1073#1072#1083#1072#1085#1089#1072' '#1088#1072#1089#1093#1086#1076'/'#1087#1088#1080#1093#1086#1076
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 7
    Width = 238
  end
  object cb_v1: TcxCheckBox
    Left = 261
    Top = 34
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    Width = 73
  end
  object cb_v2: TcxCheckBox
    Left = 261
    Top = 84
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    Width = 73
  end
  object cb_v4: TcxCheckBox
    Left = 261
    Top = 140
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    Width = 73
  end
  object cb_All: TcxCheckBox
    Left = 261
    Top = 193
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
    Width = 73
  end
  object edHT_SUN_All: TcxCurrencyEdit
    Left = 17
    Top = 193
    Hint = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1073#1072#1083#1072#1085#1089#1072' '#1088#1072#1089#1093#1086#1076'/'#1087#1088#1080#1093#1086#1076
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 12
    Width = 238
  end
  object cxLabel3: TcxLabel
    Left = 17
    Top = 170
    Caption = #1050#1086#1083'. '#1076#1085'. '#1076#1083#1103' HT ('#1057#1059#1053') ('#1087#1086' '#1074#1089#1077#1084' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103#1084')'
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 289
    Top = 222
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
    Left = 104
    Top = 34
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inHT_SUN_v1'
        Value = Null
        Component = edHT_SUN_v1
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHT_SUN_v2'
        Value = Null
        Component = edHT_SUN_v2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHT_SUN_v4'
        Value = Null
        Component = edHT_SUN_v4
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHT_SUN_All'
        Value = Null
        Component = edHT_SUN_All
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_v1'
        Value = Null
        Component = cb_v1
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_v2'
        Value = Null
        Component = cb_v2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_v4'
        Value = Null
        Component = cb_v4
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_All'
        Value = Null
        Component = cb_All
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 143
    Top = 223
  end
end
