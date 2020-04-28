object Unit_T_SUN_EditForm: TUnit_T_SUN_EditForm
  Left = 0
  Top = 0
  Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
  ClientHeight = 229
  ClientWidth = 324
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
    Top = 180
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 203
    Top = 180
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object edT1_SUN_v2: TcxCurrencyEdit
    Left = 17
    Top = 34
    Hint = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1073#1072#1083#1072#1085#1089#1072' '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 2
    Width = 184
  end
  object edT2_SUN_v2: TcxCurrencyEdit
    Left = 17
    Top = 84
    Hint = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1073#1072#1083#1072#1085#1089#1072' '#1088#1072#1089#1093#1086#1076'/'#1087#1088#1080#1093#1086#1076
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 3
    Width = 184
  end
  object cxLabel7: TcxLabel
    Left = 17
    Top = 15
    Caption = #1057#1059#1053'-V2 - '#1087#1088#1086#1076#1072#1078#1080' '#1091' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103' '#1074' '#1088#1072#1079#1088#1077#1079#1077' 60 '#1076#1085#1077#1081
  end
  object cxLabel1: TcxLabel
    Left = 17
    Top = 61
    Caption = #1057#1059#1053'-V2 - '#1087#1088#1086#1076#1072#1078#1080' '#1091' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103' '#1074' '#1088#1072#1079#1088#1077#1079#1077' 45 '#1076#1085#1077#1081
  end
  object cxLabel2: TcxLabel
    Left = 17
    Top = 117
    Caption = #1057#1059#1053'-V2-'#1055#1048' - '#1087#1088#1086#1076#1072#1078#1080' '#1091' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103' '#1074' '#1088#1072#1079#1088#1077#1079#1077' 60 '#1076#1085#1077#1081
  end
  object edT1_SUN_v4: TcxCurrencyEdit
    Left = 17
    Top = 140
    Hint = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1073#1072#1083#1072#1085#1089#1072' '#1088#1072#1089#1093#1086#1076'/'#1087#1088#1080#1093#1086#1076
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 7
    Width = 184
  end
  object cbT1_SUN_v2: TcxCheckBox
    Left = 217
    Top = 34
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    Width = 73
  end
  object cbT2_SUN_v2: TcxCheckBox
    Left = 217
    Top = 84
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    Width = 73
  end
  object cbT1_SUN_v4: TcxCheckBox
    Left = 217
    Top = 140
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    Width = 73
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 289
    Top = 177
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
    Left = 72
    Top = 10
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inT1_SUN_v2'
        Value = Null
        Component = edT1_SUN_v2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inT2_SUN_v2'
        Value = Null
        Component = edT2_SUN_v2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inT1_SUN_v4'
        Value = Null
        Component = edT1_SUN_v4
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisT1_SUN_v2'
        Component = cbT1_SUN_v2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisT2_SUN_v2'
        Value = Null
        Component = cbT2_SUN_v2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisT1_SUN_v4'
        Value = Null
        Component = cbT1_SUN_v4
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 143
    Top = 178
  end
end
