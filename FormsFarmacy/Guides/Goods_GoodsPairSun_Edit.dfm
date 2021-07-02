object Goods_GoodsPairSun_EditForm: TGoods_GoodsPairSun_EditForm
  Left = 0
  Top = 0
  Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
  ClientHeight = 182
  ClientWidth = 347
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
    Top = 129
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 211
    Top = 129
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel5: TcxLabel
    Left = 18
    Top = 30
    Caption = #1058#1086#1074#1072#1088' ('#1087#1072#1088#1072' '#1074' '#1057#1059#1053')'
  end
  object edGoodsPairSun: TcxButtonEdit
    Left = 18
    Top = 55
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 303
  end
  object cePairSunAmount: TcxCurrencyEdit
    Left = 209
    Top = 86
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.000'
    TabOrder = 4
    Width = 112
  end
  object cxLabel1: TcxLabel
    Left = 18
    Top = 87
    Caption = #1050#1086#1083'-'#1074#1086' '#1087#1072#1088#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 297
    Top = 97
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
    Left = 120
    Top = 18
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inGoodsPairSunId'
        Value = Null
        Component = GuidesGoodsPairSun
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsPairSunName'
        Value = Null
        Component = GuidesGoodsPairSun
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsPairSunCode'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsPairSunCode'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPairSunAmount'
        Value = Null
        Component = cePairSunAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 151
    Top = 98
  end
  object GuidesGoodsPairSun: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsPairSun
    FormNameParam.Value = 'TGoodsLiteForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsLiteForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsPairSun
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsPairSun
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsPairSunCode'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 85
    Top = 105
  end
end
