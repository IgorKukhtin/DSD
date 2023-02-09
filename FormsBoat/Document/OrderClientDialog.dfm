object OrderClientDialogForm: TOrderClientDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
  ClientHeight = 147
  ClientWidth = 329
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
    Left = 64
    Top = 105
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 192
    Top = 105
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object edNPP: TcxCurrencyEdit
    Left = 34
    Top = 46
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.EditFormat = '0'
    TabOrder = 2
    Width = 144
  end
  object cxLabel19: TcxLabel
    Left = 34
    Top = 23
    Caption = #1054#1095#1077#1088#1077#1076#1085#1086#1089#1090#1100
  end
  object edDateBegin: TcxDateEdit
    Left = 210
    Top = 46
    EditValue = 42160d
    ParentShowHint = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    ShowHint = True
    TabOrder = 4
    Width = 82
  end
  object cxLabel4: TcxLabel
    Left = 210
    Top = 23
    Hint = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1072#1103' '#1076#1072#1090#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1089#1073#1086#1088#1082#1080
    Caption = #1044#1072#1090#1072' '#1087#1083#1072#1085
    ParentShowHint = False
    ShowHint = True
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 172
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
    Left = 13
    Top = 77
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'NPP'
        Value = 'NULL'
        Component = edNPP
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateBegin'
        Value = Null
        Component = edDateBegin
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 127
    Top = 23
  end
end
