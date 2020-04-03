object Report_Send_RemainsSun_expressDialogForm: TReport_Send_RemainsSun_expressDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1053#1072' '#1076#1072#1090#1091
  ClientHeight = 119
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
    Left = 18
    Top = 79
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 192
    Top = 79
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deOperDate: TcxDateEdit
    Left = 83
    Top = 29
    EditValue = 42705d
    Properties.Kind = ckDateTime
    Properties.ShowTime = False
    TabOrder = 2
    Width = 142
  end
  object cxLabel6: TcxLabel
    Left = 34
    Top = 30
    Caption = #1044#1072#1090#1072':'
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 207
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
    Left = 216
    Top = 65524
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inOperDate'
        Value = 41579d
        Component = deOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 39
    Top = 54
  end
end
