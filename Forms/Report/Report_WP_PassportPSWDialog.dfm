object Report_WP_PassportPSWDialogForm: TReport_WP_PassportPSWDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1074#1086#1076' '#1087#1072#1088#1086#1083#1103' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1103
  ClientHeight = 167
  ClientWidth = 370
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
    Left = 89
    Top = 124
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 200
    Top = 124
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel1: TcxLabel
    Left = 48
    Top = 57
    Caption = #1055#1072#1088#1086#1083#1100':'
  end
  object edPassword: TcxTextEdit
    Left = 48
    Top = 79
    TabOrder = 3
    Width = 266
  end
  object cxLabel5: TcxLabel
    Left = 48
    Top = 10
    Caption = #1055#1086#1076#1076#1086#1085
  end
  object edBoxName: TcxTextEdit
    Left = 48
    Top = 30
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 266
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 111
    Top = 111
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
    Left = 184
    Top = 109
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inPassword'
        Value = Null
        Component = edPassword
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxName'
        Value = Null
        Component = edBoxName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 279
    Top = 76
  end
end
