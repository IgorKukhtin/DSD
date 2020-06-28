object PromoManagerDialogForm: TPromoManagerDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1089#1086#1089#1090#1086#1103#1085#1080#1077' '#1040#1082#1094#1080#1080
  ClientHeight = 212
  ClientWidth = 357
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
    Left = 61
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 216
    Top = 176
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object cxLabel1: TcxLabel
    Left = 21
    Top = 6
    Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
  end
  object cxLabel5: TcxLabel
    Left = 21
    Top = 44
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edPromoStateKindName: TcxTextEdit
    Left = 21
    Top = 22
    ParentFont = False
    Properties.ReadOnly = True
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    TabOrder = 1
    Width = 311
  end
  object MemoComment: TcxMemo
    Left = 21
    Top = 61
    Lines.Strings = (
      'MemoComment')
    Properties.MaxLength = 255
    TabOrder = 0
    Height = 104
    Width = 311
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
        Name = 'MovementItemId_PromoStateKind_true'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoStateKindId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoStateKindName'
        Value = Null
        Component = edPromoStateKindName
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment_PromoStateKind'
        Value = Null
        Component = MemoComment
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 263
    Top = 71
  end
end
