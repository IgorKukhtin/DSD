object Goods_Name_BUHDialogForm: TGoods_Name_BUHDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1041#1091#1093#1075#1072#1083#1090#1077#1088#1080#1080
  ClientHeight = 121
  ClientWidth = 390
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
    Left = 113
    Top = 83
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 224
    Top = 83
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel17: TcxLabel
    Left = 16
    Top = 20
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1073#1091#1093#1075'.)'
  end
  object edName_BUH: TcxTextEdit
    Left = 16
    Top = 37
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 260
  end
  object cxLabel18: TcxLabel
    Left = 289
    Top = 20
    Caption = #1044#1072#1090#1072' '#1076#1086' ('#1073#1091#1093#1075'.) :'
  end
  object edDate_BUH: TcxDateEdit
    Left = 287
    Top = 37
    EditValue = 42005d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 5
    Width = 91
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 135
    Top = 86
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
    Left = 248
    Top = 20
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inName_BUH'
        Value = 41579d
        Component = edName_BUH
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDate_BUH'
        Value = Null
        Component = edDate_BUH
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 111
    Top = 46
  end
end
