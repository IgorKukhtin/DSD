object ChoiceCellMobileDialogForm: TChoiceCellMobileDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' <'#1057#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077' '#1084#1077#1089#1090#1072' '#1086#1090#1073#1086#1088#1072'>'
  ClientHeight = 129
  ClientWidth = 404
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  ShowHint = True
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 78
    Top = 89
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 206
    Top = 89
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 9
    Caption = #1051#1080#1084#1080#1090':'
  end
  object ceLimit: TcxCurrencyEdit
    Left = 55
    Top = 8
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0.'
    TabOrder = 3
    Width = 81
  end
  object cxLabel16: TcxLabel
    Left = 8
    Top = 40
    Caption = #1060#1080#1083#1100#1090#1088':'
  end
  object edFilter: TcxTextEdit
    Left = 55
    Top = 39
    TabOrder = 5
    Width = 81
  end
  object cbIsOrderBy: TcxCheckBox
    Left = 149
    Top = 8
    Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' ('#1055#1086' '#1090#1086#1074#1072#1088#1091' - '#1076#1072'/ '#1055#1086' '#1076#1072#1090#1077' - '#1085#1077#1090')'
    TabOrder = 6
    Width = 256
  end
  object cbIsAllUser: TcxCheckBox
    Left = 149
    Top = 39
    Caption = #1055#1086' '#1074#1089#1077#1084' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103#1084' ('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 7
    Width = 200
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 148
    Top = 79
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
    Left = 213
    Top = 37
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Filter'
        Value = 'NULL'
        Component = edFilter
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Limit'
        Value = Null
        Component = ceLimit
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsAllUser'
        Value = Null
        Component = cbIsAllUser
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsOrderBy'
        Value = Null
        Component = cbIsOrderBy
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 287
    Top = 55
  end
end
