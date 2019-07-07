object OverdueChangeDialogForm: TOverdueChangeDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080
  ClientHeight = 141
  ClientWidth = 285
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
    Left = 27
    Top = 100
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 192
    Top = 100
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel6: TcxLabel
    Left = 34
    Top = 30
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086':'
  end
  object ceAmount: TcxCurrencyEdit
    Left = 132
    Top = 29
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.000'
    TabOrder = 3
    Width = 90
  end
  object deOperDate: TcxDateEdit
    Left = 132
    Top = 65
    EditValue = 42705d
    Properties.ShowTime = False
    TabOrder = 4
    Width = 90
  end
  object cxLabel1: TcxLabel
    Left = 34
    Top = 66
    Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 215
    Top = 30
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
    Left = 128
    Top = 92
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Amount'
        Value = 41579d
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 'NULL'
        Component = deOperDate
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 39
    Top = 75
  end
  object PeriodChoice: TPeriodChoice
    Left = 144
    Top = 64
  end
end
