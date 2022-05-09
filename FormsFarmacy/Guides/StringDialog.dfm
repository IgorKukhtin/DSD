object StringDialogForm: TStringDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1074#1086#1076
  ClientHeight = 186
  ClientWidth = 502
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 81
    Top = 130
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object cxButton2: TcxButton
    Left = 334
    Top = 129
    Width = 75
    Height = 28
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object cxLabem: TcxMemo
    AlignWithMargins = True
    Left = 41
    Top = 24
    TabStop = False
    Enabled = False
    Lines.Strings = (
      #1042#1074#1077#1076#1080#1090#1077' '#1090#1077#1082#1089#1090)
    Properties.ReadOnly = True
    Style.BorderStyle = ebsNone
    Style.Color = clBtnFace
    Style.Edges = [bLeft, bTop, bRight, bBottom]
    Style.Shadow = False
    StyleDisabled.BorderStyle = ebsNone
    StyleDisabled.TextColor = clWindowText
    TabOrder = 3
    Height = 47
    Width = 416
  end
  object cxTextEdit1: TcxTextEdit
    Left = 40
    Top = 80
    TabOrder = 0
    Width = 417
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 158
    Top = 22
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
    Left = 231
    Top = 100
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Text'
        Value = 100.000000000000000000
        Component = cxTextEdit1
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Label'
        Value = Null
        Component = cxLabem
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 38
    Top = 94
  end
  object ActionList: TActionList
    Left = 267
    Top = 23
  end
end
