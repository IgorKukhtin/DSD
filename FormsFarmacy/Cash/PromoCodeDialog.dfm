inherited PromoCodeDialogForm: TPromoCodeDialogForm
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1074#1086#1076' '#1087#1088#1086#1084#1086#1082#1086#1076#1072
  ClientHeight = 117
  ClientWidth = 283
  Position = poDesktopCenter
  ExplicitWidth = 289
  ExplicitHeight = 146
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel [0]
    Left = 15
    Top = 8
    Width = 50
    Height = 13
    Caption = #1055#1088#1086#1084#1086#1082#1086#1076
  end
  inherited bbOk: TcxButton
    Left = 40
    Top = 75
    ModalResult = 0
    TabOrder = 1
    OnClick = bbOkClick
    ExplicitLeft = 40
    ExplicitTop = 75
  end
  inherited bbCancel: TcxButton
    Left = 161
    Top = 75
    TabOrder = 2
    ExplicitLeft = 161
    ExplicitTop = 75
  end
  object edPromoCode: TcxTextEdit [3]
    Left = 15
    Top = 27
    Properties.MaxLength = 8
    TabOrder = 0
    OnKeyPress = edPromoCodeKeyPress
    Width = 250
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 147
    Top = 8
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 240
    Top = 8
  end
  inherited ActionList: TActionList
    Left = 175
    Top = 7
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'PromoCodeGUID'
        Value = ''
        Component = edPromoCode
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoCodeID'
        Value = 0
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoCodeChangePercent'
        Value = 0c
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 8
  end
  object spGet_PromoCode_by_GUID: TdsdStoredProc
    StoredProcName = 'gpGet_PromoCode_by_GUID'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inPromoGUID'
        Value = Null
        Component = FormParams
        ComponentItem = 'PromoCodeGUID'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPromoCodeID'
        Value = 0
        Component = FormParams
        ComponentItem = 'PromoCodeID'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPromoName'
        Value = ''
        Component = FormParams
        ComponentItem = 'PromoName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPromoCodeChangePercent'
        Value = Null
        Component = FormParams
        ComponentItem = 'PromoCodeChangePercent'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 48
    Top = 24
  end
end
