object ActNumberAndAmountDialogForm: TActNumberAndAmountDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1074#1086#1076' '#1085#1086#1084#1077#1088#1072' '#1072#1082#1090#1072' '#1080' '#1089#1091#1084#1084#1099
  ClientHeight = 162
  ClientWidth = 325
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
    Left = 33
    Top = 115
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 192
    Top = 115
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel1: TcxLabel
    Left = 32
    Top = 32
    Caption = #1053#1086#1084#1077#1088' '#1072#1082#1090#1072
  end
  object cxLabel2: TcxLabel
    Left = 33
    Top = 72
    Caption = #1057#1091#1084#1084#1072' '#1072#1082#1090#1072', '#1075#1088#1085'.'
  end
  object edActNumber: TcxTextEdit
    Left = 160
    Top = 31
    TabOrder = 4
    Text = 'edActNumber'
    Width = 121
  end
  object edAmountAct: TcxCurrencyEdit
    Left = 160
    Top = 71
    Properties.DisplayFormat = ',0.00;-,0.00; ;'
    TabOrder = 5
    Width = 121
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 55
    Top = 9
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
    Left = 56
    Top = 71
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ActNumber'
        Value = 41579d
        Component = edActNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountAct'
        Value = Null
        Component = edAmountAct
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 151
    Top = 113
  end
end
