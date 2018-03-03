object MovementString_INNEditForm: TMovementString_INNEditForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1048#1053#1053
  ClientHeight = 124
  ClientWidth = 313
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
    Left = 29
    Top = 84
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 190
    Top = 84
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel14: TcxLabel
    Left = 31
    Top = 33
    Caption = #1048#1053#1053
  end
  object edINN: TcxTextEdit
    Left = 73
    Top = 32
    TabOrder = 3
    Width = 160
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 279
    Top = 26
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
    Left = 256
    Top = 21
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inINN'
        Value = Null
        Component = edINN
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 127
    Top = 26
  end
end
