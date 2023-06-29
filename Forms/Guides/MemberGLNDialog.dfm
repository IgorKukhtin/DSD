object MemberGLNDialogForm: TMemberGLNDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
  ClientHeight = 212
  ClientWidth = 269
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
    Left = 32
    Top = 161
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 160
    Top = 161
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel16: TcxLabel
    Left = 32
    Top = 95
    Caption = 'GLN'
  end
  object edGLN: TcxTextEdit
    Left = 32
    Top = 118
    TabOrder = 3
    Width = 203
  end
  object Код: TcxLabel
    Left = 14
    Top = 4
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 14
    Top = 21
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 127
  end
  object cxLabel1: TcxLabel
    Left = 14
    Top = 44
    Caption = #1060#1048#1054
  end
  object edName: TcxTextEdit
    Left = 16
    Top = 62
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 245
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 140
    Top = 135
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
    Left = 197
    Top = 77
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inGLN'
        Value = 'NULL'
        Component = edGLN
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = Null
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 223
    Top = 103
  end
end
