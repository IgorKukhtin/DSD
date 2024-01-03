object Send_DatePartionDialogForm: TSend_DatePartionDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1044#1072#1090#1099' '#1055#1072#1088#1090#1080#1080
  ClientHeight = 142
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
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 192
    Top = 88
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object dePartionGoodsDate: TcxDateEdit
    Left = 125
    Top = 25
    EditValue = 42705d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object cxLabel6: TcxLabel
    Left = 34
    Top = 26
    Caption = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080':'
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 255
    Top = 54
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
    Top = 20
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inPartionGoodsDate'
        Value = 41579d
        Component = dePartionGoodsDate
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 63
    Top = 99
  end
  object PeriodChoice: TPeriodChoice
    DateStart = dePartionGoodsDate
    Left = 136
    Top = 93
  end
end
