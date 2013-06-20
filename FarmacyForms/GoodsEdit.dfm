inherited GoodsEditForm: TGoodsEditForm
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
  ClientHeight = 279
  ClientWidth = 354
  ExplicitWidth = 362
  ExplicitHeight = 306
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 65
    Top = 16
    TabOrder = 0
    Width = 281
  end
  object cxLabel1: TcxLabel
    Left = 8
    Top = 16
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
  end
  object cxButton1: TcxButton
    Left = 65
    Top = 229
    Width = 75
    Height = 25
    Action = dsdExecStoredProc
    Default = True
    ModalResult = 8
    TabOrder = 10
  end
  object cxButton2: TcxButton
    Left = 209
    Top = 229
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 11
  end
  object Код: TcxLabel
    Left = 8
    Top = 56
    Caption = #1050#1086#1076':'
  end
  object ceCode: TcxCurrencyEdit
    Left = 38
    Top = 55
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 1
    Width = 65
  end
  object cxLabel3: TcxLabel
    Left = 17
    Top = 151
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1085#1072#1094#1077#1085#1082#1080':'
  end
  object ceExtraChargeCategories: TcxLookupComboBox
    Left = 130
    Top = 150
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = ExtraChargeCategoriesDS
    TabOrder = 7
    Width = 216
  end
  object cxLabel4: TcxLabel
    Left = 135
    Top = 82
    Caption = #1045#1076'. '#1080#1079#1084#1077#1088#1077#1085#1080#1103':'
  end
  object ceMeasure: TcxLookupComboBox
    Left = 222
    Top = 82
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = MeasureDS
    TabOrder = 4
    Width = 124
  end
  object cxLabel2: TcxLabel
    Left = 28
    Top = 187
    Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080':'
  end
  object cePrice: TcxCurrencyEdit
    Left = 130
    Top = 186
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 8
    Width = 65
  end
  object cxLabel5: TcxLabel
    Left = 120
    Top = 56
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1074' '#1082#1072#1089#1089#1077':'
  end
  object edCashName: TcxTextEdit
    Left = 222
    Top = 55
    TabOrder = 2
    Width = 124
  end
  object cxLabel6: TcxLabel
    Left = 6
    Top = 82
    Caption = #1053#1044#1057':'
  end
  object ceNDS: TcxCurrencyEdit
    Left = 38
    Top = 82
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 3
    Width = 65
  end
  object cxLabel7: TcxLabel
    Left = 201
    Top = 187
    Caption = '% '#1085#1072#1094#1077#1085#1082#1080':'
  end
  object cePercentReprice: TcxCurrencyEdit
    Left = 266
    Top = 186
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 9
    Width = 80
  end
  object cxLabel8: TcxLabel
    Left = 8
    Top = 118
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1074' '#1087#1072#1088#1090#1080#1080':'
  end
  object cePartyCount: TcxCurrencyEdit
    Left = 130
    Top = 117
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 65
  end
  object cbisReceiptNeed: TcxCheckBox
    Left = 201
    Top = 117
    Caption = #1057#1087#1077#1094#1082#1086#1085#1090#1088#1086#1083#1100
    TabOrder = 6
    Width = 121
  end
  object ActionList: TActionList
    Left = 312
    Top = 224
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetMeasure
        end
        item
          StoredProc = spGetExtraChargeCategories
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
    end
    object dsdExecStoredProc: TdsdExecStoredProc
      Category = 'DSDLib'
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose1: TdsdFormClose
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Goods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = dsdFormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end
      item
        Name = 'inCode'
        Component = ceCode
        DataType = ftInteger
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inName'
        Component = edName
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'inGoodsGroupId'
        Component = dsdExtraChargeCategoriesGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inMeasureId'
        Component = dsdMeasureGuides
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inWeight'
        Component = cePrice
        DataType = ftFloat
        ParamType = ptInput
        Value = ''
      end>
    Left = 256
    Top = 216
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end>
    Left = 304
    Top = 200
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Goods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Component = dsdFormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'Name'
        Component = edName
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'Code'
        Component = ceCode
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'ExtraChargeCategoriesId'
        Component = dsdExtraChargeCategoriesGuides
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'ExtraChargeCategoriesName'
        Component = dsdExtraChargeCategoriesGuides
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'MeasureId'
        Component = dsdMeasureGuides
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'MeasureName'
        Component = dsdMeasureGuides
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'NDS'
        Component = ceNDS
        DataType = ftCurrency
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'PartyCount'
        Component = cePartyCount
        DataType = ftUnknown
        ParamType = ptOutput
        Value = ''
      end
      item
        DataType = ftInteger
        ParamType = ptOutput
        Value = Null
      end
      item
        DataType = ftInteger
        ParamType = ptOutput
        Value = Null
      end
      item
        Name = 'Price'
        Component = cePrice
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end>
    Left = 224
    Top = 200
  end
  object ExtraChargeCategoriesDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Top = 136
  end
  object spGetExtraChargeCategories: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ExtraChargeCategories'
    DataSet = ExtraChargeCategoriesDataSet
    DataSets = <
      item
        DataSet = ExtraChargeCategoriesDataSet
      end>
    Params = <>
    Left = 65528
    Top = 192
  end
  object ExtraChargeCategoriesDS: TDataSource
    DataSet = ExtraChargeCategoriesDataSet
    Top = 208
  end
  object dsdExtraChargeCategoriesGuides: TdsdGuides
    Key = '0'
    LookupControl = ceExtraChargeCategories
    Left = 65528
    Top = 152
  end
  object MeasureDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 312
    Top = 96
  end
  object spGetMeasure: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Measure'
    DataSet = MeasureDataSet
    DataSets = <
      item
        DataSet = MeasureDataSet
      end>
    Params = <>
    Left = 224
    Top = 112
  end
  object MeasureDS: TDataSource
    DataSet = MeasureDataSet
    Left = 256
    Top = 112
  end
  object dsdMeasureGuides: TdsdGuides
    Key = '0'
    LookupControl = ceMeasure
    Left = 288
    Top = 112
  end
end
