object PriceListGoodsItemEditForm: TPriceListGoodsItemEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1062#1077#1085#1091'>'
  ClientHeight = 223
  ClientWidth = 356
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 64
    Top = 178
    Width = 75
    Height = 25
    Caption = #1054#1082
    Default = True
    ModalResult = 8
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 216
    Top = 178
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 1
  end
  object Код: TcxLabel
    Left = 40
    Top = 3
    Caption = #1058#1086#1074#1072#1088
  end
  object edGoods: TcxButtonEdit
    Left = 40
    Top = 22
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = False
    TabOrder = 3
    Width = 273
  end
  object cxLabel11: TcxLabel
    Left = 40
    Top = 54
    Caption = #1044#1072#1090#1072' '#1089' :'
  end
  object edStartDate: TcxDateEdit
    Left = 40
    Top = 77
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    Properties.ValidateOnEnter = False
    TabOrder = 5
    Width = 120
  end
  object cxLabel1: TcxLabel
    Left = 193
    Top = 54
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object edEndDate: TcxDateEdit
    Left = 193
    Top = 77
    EditValue = 0d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    Properties.ValidateOnEnter = False
    TabOrder = 7
    Width = 120
  end
  object cePrice: TcxCurrencyEdit
    Left = 40
    Top = 133
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 8
    Width = 120
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 110
    Caption = #1062#1077#1085#1072' :'
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_ObjectHistory_PriceListItemLast'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inPriceListId'
        Value = 0.000000000000000000
        Component = dsdFormParams
        ComponentItem = 'inPriceListId'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 'False'
        Component = edStartDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'outStartDate'
        Value = 0.000000000000000000
        Component = edStartDate
        DataType = ftDateTime
      end
      item
        Name = 'outEndDate'
        Value = Null
        Component = edEndDate
        DataType = ftDateTime
      end
      item
        Name = 'inValue'
        Value = Null
        Component = cePrice
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inIsLast'
        Value = 'False'
        DataType = ftFloat
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 288
    Top = 128
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end
      item
        Name = 'PriceListId'
        Value = Null
        ParamType = ptInputOutput
      end
      item
        Name = 'GoodsId'
        Value = Null
        ParamType = ptInputOutput
      end>
    Left = 168
    Top = 104
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_ObjectHistory_PriceListItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inPriceListId'
        Value = 0.000000000000000000
        Component = dsdFormParams
        ComponentItem = 'inPriceListId'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsName'
        Value = 'False'
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'StartDate'
        Value = 0.000000000000000000
        Component = edStartDate
        DataType = ftDateTime
      end
      item
        Name = 'EndDate'
        Value = Null
        Component = edEndDate
        DataType = ftDateTime
      end
      item
        Name = 'ValuePrice'
        Value = Null
        Component = cePrice
        DataType = ftFloat
      end>
    PackSize = 1
    Left = 232
    Top = 112
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 8
    Top = 32
  end
  object dsdUserSettingsStorageAddOn1: TdsdUserSettingsStorageAddOn
    Left = 304
    Top = 48
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoods_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoods_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        ComponentItem = 'GoodsName'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 160
    Top = 8
  end
end
