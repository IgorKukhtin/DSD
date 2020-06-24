object PromoManagerDialogForm: TPromoManagerDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
  ClientHeight = 184
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
    Left = 53
    Top = 145
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 208
    Top = 145
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel1: TcxLabel
    Left = 21
    Top = 18
    Caption = #1058#1077#1082#1091#1097#1077#1077' '#1089#1086#1089#1090#1086#1103#1085#1080#1077
  end
  object edComment: TcxTextEdit
    Left = 21
    Top = 101
    TabOrder = 3
    Width = 284
  end
  object cxLabel5: TcxLabel
    Left = 21
    Top = 78
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
  end
  object edPromoStateKindName: TcxTextEdit
    Left = 21
    Top = 37
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 284
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 188
    Top = 55
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
    Left = 85
    Top = 85
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPromoStateKindName'
        Value = Null
        Component = edPromoStateKindName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 263
    Top = 71
  end
end
