inherited GoodsEditForm: TGoodsEditForm
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
  ClientHeight = 254
  ClientWidth = 352
  ExplicitWidth = 360
  ExplicitHeight = 281
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 40
    Top = 71
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 48
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 72
    Top = 216
    Width = 75
    Height = 25
    Action = dsdExecStoredProc
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 216
    Top = 216
    Width = 75
    Height = 25
    Action = dsdFormClose1
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 40
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 40
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 98
    Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074
  end
  object ceParentGroup: TcxLookupComboBox
    Left = 40
    Top = 121
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = GoodslGroupDS
    TabOrder = 7
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 154
    Caption = #1045#1076'. '#1080#1079#1084#1077#1088#1077#1085#1080#1103
  end
  object ceMeasure: TcxLookupComboBox
    Left = 40
    Top = 177
    Properties.KeyFieldNames = 'Id'
    Properties.ListColumns = <
      item
        FieldName = 'Name'
      end>
    Properties.ListSource = MeasureDS
    TabOrder = 9
    Width = 145
  end
  object cxLabel2: TcxLabel
    Left = 191
    Top = 154
    Caption = #1042#1077#1089
  end
  object ceWeight: TcxCurrencyEdit
    Left = 191
    Top = 177
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 11
    Width = 121
  end
  object ActionList: TActionList
    Left = 296
    Top = 72
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
          StoredProc = spGetGoodsGroup
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
      end
      item
        Name = 'inName'
        Component = edName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsGroupId'
        Component = dsdGoodsGroupGuides
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
        Component = ceWeight
        DataType = ftFloat
        ParamType = ptInput
      end>
    Left = 240
    Top = 48
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end>
    Left = 240
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
      end
      item
        Name = 'Code'
        Component = ceCode
        DataType = ftInteger
        ParamType = ptOutput
      end
      item
        Name = 'GoodsGroupId'
        Component = dsdGoodsGroupGuides
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptOutput
        Value = '0'
      end
      item
        Name = 'GoodsGroupName'
        Component = dsdGoodsGroupGuides
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
        Name = 'Weight'
        Component = ceWeight
        DataType = ftCurrency
        ParamType = ptOutput
      end>
    Left = 192
    Top = 88
  end
  object GoodsGroupDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 112
  end
  object spGetGoodsGroup: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsGroup'
    DataSet = GoodsGroupDataSet
    DataSets = <
      item
        DataSet = GoodsGroupDataSet
      end>
    Params = <>
    Left = 216
    Top = 112
  end
  object GoodslGroupDS: TDataSource
    DataSet = GoodsGroupDataSet
    Left = 256
    Top = 112
  end
  object dsdGoodsGroupGuides: TdsdGuides
    LookupControl = ceParentGroup
    Left = 312
    Top = 120
  end
  object MeasureDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 16
    Top = 200
  end
  object spGetMeasure: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Measure'
    DataSet = MeasureDataSet
    DataSets = <
      item
        DataSet = MeasureDataSet
      end>
    Params = <>
    Left = 56
    Top = 200
  end
  object MeasureDS: TDataSource
    DataSet = MeasureDataSet
    Left = 96
    Top = 200
  end
  object dsdMeasureGuides: TdsdGuides
    LookupControl = ceMeasure
    Left = 152
    Top = 208
  end
end
