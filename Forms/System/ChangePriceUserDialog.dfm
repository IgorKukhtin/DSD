object ChangePriceUserDialogForm: TChangePriceUserDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 167
  ClientWidth = 340
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.Params = FormParams
  DesignSize = (
    340
    167)
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 70
    Top = 121
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 209
    Top = 121
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object edChangePriceUser: TcxCheckBox
    Left = 35
    Top = 27
    Caption = #1056#1091#1095#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1074' '#1094#1077#1085#1077' ('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 2
    Width = 185
  end
  object edChangePrice: TcxCurrencyEdit
    Left = 176
    Top = 69
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    TabOrder = 3
    Width = 135
  end
  object cxLabel11: TcxLabel
    Left = 35
    Top = 70
    Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1094#1077#1085#1077', '#1075#1088#1085' '#1079#1072' 1'#1083'.'
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 294
    Top = 12
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
    Left = 295
    Top = 61
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'isChangePriceUser'
        Value = ''
        Component = edChangePriceUser
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePrice'
        Value = Null
        Component = edChangePrice
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 142
    Top = 19
  end
end
