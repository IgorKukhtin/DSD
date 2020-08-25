object BarCodeBoxPrintDialogForm: TBarCodeBoxPrintDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1053#1072#1087#1077#1095#1072#1090#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1096'/'#1082
  ClientHeight = 150
  ClientWidth = 268
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 34
    Top = 107
    Width = 75
    Height = 23
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 161
    Top = 105
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel2: TcxLabel
    Left = 25
    Top = 18
    Caption = #1053#1072#1095'. '#1079#1085#1072#1095#1077#1085#1080#1077
  end
  object cxLabel3: TcxLabel
    Left = 149
    Top = 18
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
  end
  object edBarCode1: TcxCurrencyEdit
    Left = 25
    Top = 41
    EditValue = '0'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 4
    Width = 100
  end
  object edAmount: TcxCurrencyEdit
    Left = 149
    Top = 41
    EditValue = '0'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 5
    Width = 100
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 180
    Top = 95
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
    Left = 253
    Top = 77
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inBarCode1'
        Value = Null
        Component = edBarCode1
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = edAmount
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 71
    Top = 39
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Onject_BarCodeBox_ValueData'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BarCode'
        Value = ''
        Component = edBarCode1
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 115
    Top = 70
  end
  object ActionList: TActionList
    Left = 65535
    Top = 71
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
end
