object GoodsByGoodsKind_VMCDialogForm: TGoodsByGoodsKind_VMCDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074
  ClientHeight = 266
  ClientWidth = 295
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
    Left = 33
    Top = 229
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 192
    Top = 229
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel6: TcxLabel
    Left = 34
    Top = 30
    Caption = #1052#1080#1085'. '#1074#1077#1089':'
  end
  object edWeightMin: TcxCurrencyEdit
    Left = 114
    Top = 29
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 3
    Width = 135
  end
  object cxLabel1: TcxLabel
    Left = 34
    Top = 70
    Caption = #1052#1072#1082#1089'. '#1074#1077#1089':'
  end
  object edWeightMax: TcxCurrencyEdit
    Left = 114
    Top = 69
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 5
    Width = 135
  end
  object cxLabel2: TcxLabel
    Left = 34
    Top = 110
    Caption = #1042#1099#1089#1086#1090#1072':'
  end
  object edHeight: TcxCurrencyEdit
    Left = 114
    Top = 109
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 7
    Width = 135
  end
  object cxLabel3: TcxLabel
    Left = 34
    Top = 150
    Caption = #1044#1083#1080#1085#1072':'
  end
  object edLength: TcxCurrencyEdit
    Left = 114
    Top = 149
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 9
    Width = 135
  end
  object cxLabel4: TcxLabel
    Left = 34
    Top = 190
    Caption = #1064#1080#1088#1080#1085#1072':'
  end
  object edWidth: TcxCurrencyEdit
    Left = 114
    Top = 189
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 11
    Width = 135
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 247
    Top = 132
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
    Left = 224
    Top = 50
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inWeightMax'
        Value = 43435d
        Component = edWeightMax
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeightMin'
        Value = Null
        Component = edWeightMin
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHeight'
        Value = Null
        Component = edHeight
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLength'
        Value = Null
        Component = edLength
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWidth'
        Value = Null
        Component = edWidth
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 79
    Top = 132
  end
  object PeriodChoice: TPeriodChoice
    Left = 144
    Top = 214
  end
end
