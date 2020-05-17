object Goods_LimitSUN_T_EditForm: TGoods_LimitSUN_T_EditForm
  Left = 0
  Top = 0
  Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
  ClientHeight = 135
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
    Left = 61
    Top = 84
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 219
    Top = 84
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object edLimitSUN_T1: TcxCurrencyEdit
    Left = 17
    Top = 34
    Hint = #1054#1089#1090#1072#1090#1086#1082', '#1087#1088#1080' '#1082#1086#1090#1086#1088#1086#1084' '#1088#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1057#1059#1053'-2 '#1080' '#1057#1059#1053'-2-'#1087#1080' '#1079#1085#1072#1095#1077#1085#1080#1103' '#1058'1'
    ParentShowHint = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    ShowHint = True
    TabOrder = 2
    Width = 238
  end
  object cxLabel7: TcxLabel
    Left = 17
    Top = 15
    Caption = #1054#1089#1090'. '#1076#1083#1103' ('#1057#1059#1053' v2, v2-'#1055#1048')  (T1)'
  end
  object cb_v1: TcxCheckBox
    Left = 261
    Top = 34
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    Width = 73
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 313
    Top = 81
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
        Name = 'inLimitSUN_T1'
        Value = Null
        Component = edLimitSUN_T1
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
      end>
    Left = 159
    Top = 82
  end
end
