object Unit_SUN_LockDialogForm: TUnit_SUN_LockDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1074#1086#1076' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 280
  ClientWidth = 277
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
    Left = 22
    Top = 245
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 145
    Top = 245
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object edSUN_v1_Lock: TcxTextEdit
    Left = 8
    Top = 103
    Hint = #1086#1090' 1 '#1076#1086' 7 '#1095#1077#1088#1077#1079' '#1079#1087#1090'.'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Width = 169
  end
  object cxLabel38: TcxLabel
    Left = 8
    Top = 5
    Caption = '1) '#1087#1086#1076#1082#1083#1102#1095#1072#1090#1100' '#1095#1077#1082' "'#1085#1077' '#1076#1083#1103' '#1053#1058#1047'" (0='#1085#1077#1090', 1='#1076#1072')'
  end
  object cxLabel1: TcxLabel
    Left = 8
    Top = 83
    Caption = #1047#1072#1087#1088#1077#1090' '#1074' '#1057#1059#1053'-1'
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 24
    Caption = '2) '#1090#1086#1074#1072#1088#1099' "'#1079#1072#1082#1088#1099#1090' '#1082#1086#1076'" (0='#1085#1077#1090', 1='#1076#1072')'
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 43
    Caption = '3) '#1090#1086#1074#1072#1088#1099' "'#1091#1073#1080#1090' '#1082#1086#1076' (0='#1085#1077#1090', 1='#1076#1072')'
  end
  object cxLabel4: TcxLabel
    Left = 8
    Top = 130
    Caption = #1047#1072#1087#1088#1077#1090' '#1074' '#1057#1059#1053'-2'
  end
  object edSUN_v2_Lock: TcxTextEdit
    Left = 8
    Top = 150
    Hint = #1086#1090' 1 '#1076#1086' 7 '#1095#1077#1088#1077#1079' '#1079#1087#1090'.'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 8
    Width = 169
  end
  object cxLabel5: TcxLabel
    Left = 8
    Top = 177
    Caption = #1047#1072#1087#1088#1077#1090' '#1074' '#1057#1059#1053'-2-'#1055#1048
  end
  object edSUN_v4_Lock: TcxTextEdit
    Left = 8
    Top = 197
    Hint = #1086#1090' 1 '#1076#1086' 7 '#1095#1077#1088#1077#1079' '#1079#1087#1090'.'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 10
    Width = 169
  end
  object cbisV1: TcxCheckBox
    Left = 183
    Top = 103
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 11
    Width = 73
  end
  object cbisV2: TcxCheckBox
    Left = 183
    Top = 150
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 12
    Width = 73
  end
  object cbisV4: TcxCheckBox
    Left = 183
    Top = 197
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    State = cbsChecked
    TabOrder = 13
    Width = 73
  end
  object cxLabel6: TcxLabel
    Left = 8
    Top = 61
    Caption = '4) '#1090#1086#1074#1072#1088#1099' "'#1084#1072#1088#1082#1077#1090#1080#1085#1075' (0='#1085#1077#1090', 1='#1076#1072')'
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 215
    Top = 186
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
    Left = 224
    Top = 237
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inV1_Lock'
        Value = Null
        Component = edSUN_v1_Lock
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inV2_Lock'
        Value = Null
        Component = edSUN_v2_Lock
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inV4_Lock'
        Value = Null
        Component = edSUN_v4_Lock
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisV1'
        Value = Null
        Component = cbisV1
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisV2'
        Value = Null
        Component = cbisV2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisV4'
        Value = Null
        Component = cbisV4
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 37
    Top = 226
  end
  object PeriodChoice: TPeriodChoice
    Left = 128
    Top = 228
  end
end
