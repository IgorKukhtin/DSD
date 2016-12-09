object CheckPrintDialogForm: TCheckPrintDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1076#1072#1090#1099'  '#1085#1086#1074#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  ClientHeight = 169
  ClientWidth = 342
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
    Left = 50
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 224
    Top = 136
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel2: TcxLabel
    Left = 21
    Top = 75
    Caption = #1044#1072#1085#1085#1099#1077' '#1087#1086#1082#1091#1087#1094#1103
  end
  object edBayer: TcxTextEdit
    Left = 21
    Top = 94
    TabOrder = 3
    Width = 302
  end
  object cxLabel1: TcxLabel
    Left = 21
    Top = 22
    Caption = #8470' '#1092#1080#1089#1082'. '#1095#1077#1082#1072
  end
  object edFiscalCheckNumber: TcxTextEdit
    Left = 21
    Top = 41
    TabOrder = 5
    Width = 302
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 220
    Top = 15
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
    Left = 117
    Top = 65533
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inFiscalCheckNumber'
        Value = Null
        Component = edFiscalCheckNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBayer'
        Value = Null
        Component = edBayer
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 175
    Top = 95
  end
end
