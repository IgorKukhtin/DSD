object Report_GoodsOnJuridicalRemainsDialogForm: TReport_GoodsOnJuridicalRemainsDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1054#1089#1090#1072#1090#1086#1082' '#1087#1086' '#1102#1088' '#1083#1080#1094#1072#1084'>'
  ClientHeight = 129
  ClientWidth = 430
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
    Left = 76
    Top = 79
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 250
    Top = 79
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deStart: TcxDateEdit
    Left = 10
    Top = 27
    EditValue = 42370d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object cxLabel6: TcxLabel
    Left = 10
    Top = 7
    Caption = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1085#1072#1095#1072#1083#1086':'
  end
  object сbIsDeferredSend: TcxCheckBox
    Left = 128
    Top = 8
    Hint = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1080#1079' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1093' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1080#1079' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1093' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081
    TabOrder = 4
    Width = 289
  end
  object cbIsDeferredReturnOut: TcxCheckBox
    Left = 128
    Top = 34
    Hint = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1080#1079' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1093' '#1074#1086#1079#1074#1088#1072#1090#1086#1074
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1080#1079' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1093' '#1074#1086#1079#1074#1088#1072#1090#1086#1074
    TabOrder = 5
    Width = 265
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    Left = 103
    Top = 74
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 182
    Top = 73
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
    Left = 271
    Top = 78
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 41579d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsDeferredSend'
        Value = Null
        Component = сbIsDeferredSend
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsDeferredReturnOut'
        Value = Null
        Component = cbIsDeferredReturnOut
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 22
    Top = 72
  end
end
