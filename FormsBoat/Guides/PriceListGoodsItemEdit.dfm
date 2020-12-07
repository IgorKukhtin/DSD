object PriceListGoodsItemEditForm: TPriceListGoodsItemEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1062#1077#1085#1091'>'
  ClientHeight = 252
  ClientWidth = 328
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 69
    Top = 213
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 177
    Top = 213
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object cxLabel3: TcxLabel
    Left = 24
    Top = 94
    Caption = #1044#1072#1090#1072' '#1089' :'
  end
  object cxLabel2: TcxLabel
    Left = 138
    Top = 94
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object edStartDate: TcxDateEdit
    Left = 24
    Top = 114
    EditValue = 42236d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 0
    Width = 92
  end
  object edEndDate: TcxDateEdit
    Left = 138
    Top = 114
    EditValue = 42236d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 1
    Width = 92
  end
  object Код: TcxLabel
    Left = 24
    Top = 3
    Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077':'
  end
  object edGoods: TcxButtonEdit
    Left = 24
    Top = 22
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = False
    TabOrder = 7
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 24
    Top = 144
    Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1053#1044#1057':'
  end
  object cePriceNoVAT: TcxCurrencyEdit
    Left = 24
    Top = 168
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 9
    Width = 120
  end
  object cxLabel4: TcxLabel
    Left = 177
    Top = 144
    Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057':'
  end
  object cePriceWVAT: TcxCurrencyEdit
    Left = 177
    Top = 168
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 11
    Width = 120
  end
  object cxLabel18: TcxLabel
    Left = 25
    Top = 49
    Caption = 'Artikel Nr'
  end
  object edArticle: TcxTextEdit
    Left = 24
    Top = 67
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 90
  end
  object ceCode: TcxCurrencyEdit
    Left = 138
    Top = 67
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 14
    Width = 90
  end
  object cxLabel6: TcxLabel
    Left = 138
    Top = 49
    Caption = 'Interne Nr'
  end
  object ActionList: TActionList
    Left = 288
    Top = 16
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdFormClose1: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = #1054#1082
    end
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId'
        Value = ''
        Component = dsdFormParams
        ComponentItem = 'PriceListId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = dsdFormParams
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = ''
        Component = edStartDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStartDate'
        Value = ''
        Component = edStartDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEndDate'
        Value = ''
        Component = edEndDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPriceNoVAT'
        Value = Null
        Component = cePriceNoVAT
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPriceWVAT'
        Value = Null
        Component = cePriceWVAT
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsLast'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 243
    Top = 62
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'GoodsId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = Null
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate'
        Value = 'NULL'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 248
    Top = 48
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_ObjectHistory_PriceListItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = dsdFormParams
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'PriceListId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = 0.000000000000000000
        Component = dsdFormParams
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsCode'
        Value = Null
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Article'
        Value = Null
        Component = edArticle
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate'
        Value = ''
        Component = edStartDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = ''
        Component = edEndDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceNoVAT'
        Value = ''
        Component = cePriceNoVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWVAT'
        Value = Null
        Component = cePriceWVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 88
    Top = 145
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
    Left = 168
    Top = 99
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 272
    Top = 104
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        ComponentItem = 'GoodsName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = ceCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Article'
        Value = Null
        Component = edArticle
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 16
  end
end
