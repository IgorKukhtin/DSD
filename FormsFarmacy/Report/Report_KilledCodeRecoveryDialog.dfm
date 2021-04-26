object Report_KilledCodeRecoveryDialogForm: TReport_KilledCodeRecoveryDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <C'#1080#1089#1090#1077#1084#1072' '#1074#1086#1089#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1103' '#1091#1073#1080#1090#1086#1075#1086' '#1082#1086#1076#1072'>'
  ClientHeight = 169
  ClientWidth = 354
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 42
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 208
    Top = 128
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel4: TcxLabel
    Left = 27
    Top = 17
    Hint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1086' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080
    Caption = #1044#1080#1072#1087#1072#1079#1086#1085' '#1088#1072#1089#1089#1084#1086#1090#1088#1077#1085#1080#1103' '#1076#1085#1077#1081
  end
  object edRangeOfDays: TcxCurrencyEdit
    Left = 208
    Top = 16
    EditValue = 200.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 3
    Width = 90
  end
  object edPercePharmaciesd: TcxCurrencyEdit
    Left = 208
    Top = 43
    EditValue = 60.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 4
    Width = 90
  end
  object cxLabel1: TcxLabel
    Left = 27
    Top = 44
    Hint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1086' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080
    Caption = #1055#1088#1086#1094#1077#1085#1090' '#1088#1072#1089#1089#1084#1086#1090#1088#1077#1085#1080#1103' '#1072#1087#1090#1077#1082
  end
  object edSalesThreshold: TcxCurrencyEdit
    Left = 208
    Top = 70
    EditValue = 1.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0'
    TabOrder = 6
    Width = 90
  end
  object cxLabel3: TcxLabel
    Left = 27
    Top = 71
    Hint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1086' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080
    Caption = #1055#1086#1088#1086#1075' '#1087#1088#1086#1076#1072#1078' '
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 134
    Top = 69
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
    Left = 135
    Top = 14
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'RangeOfDays'
        Value = 200.000000000000000000
        Component = edRangeOfDays
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercePharmaciesd'
        Value = 60.000000000000000000
        Component = edPercePharmaciesd
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'SalesThreshold'
        Value = 1.000000000000000000
        Component = edSalesThreshold
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 222
    Top = 68
  end
end
