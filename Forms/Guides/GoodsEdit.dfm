object GoodsEditForm: TGoodsEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
  ClientHeight = 361
  ClientWidth = 352
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
  object edName: TcxTextEdit
    Left = 40
    Top = 63
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 46
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 64
    Top = 331
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 192
    Top = 331
    Width = 75
    Height = 25
    Action = dsdFormClose
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
    Top = 21
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 89
    Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 229
    Caption = #1045#1076'. '#1080#1079#1084#1077#1088#1077#1085#1080#1103
  end
  object cxLabel2: TcxLabel
    Left = 264
    Top = 274
    Caption = #1042#1077#1089
  end
  object ceWeight: TcxCurrencyEdit
    Left = 264
    Top = 292
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 9
    Width = 49
  end
  object ceParentGroup: TcxButtonEdit
    Left = 40
    Top = 109
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 273
  end
  object ceMeasure: TcxButtonEdit
    Left = 40
    Top = 249
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 113
  end
  object сеTradeMark: TcxButtonEdit
    Left = 40
    Top = 202
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 113
  end
  object cxLabel5: TcxLabel
    Left = 40
    Top = 182
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
  end
  object ceInfoMoney: TcxButtonEdit
    Left = 159
    Top = 202
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 14
    Width = 154
  end
  object cxLabel6: TcxLabel
    Left = 159
    Top = 182
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object cxLabel7: TcxLabel
    Left = 159
    Top = 229
    Caption = #1041#1080#1079#1085#1077#1089
  end
  object ceBusiness: TcxButtonEdit
    Left = 159
    Top = 249
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 154
  end
  object cxLabel8: TcxLabel
    Left = 39
    Top = 274
    Caption = #1042#1080#1076' '#1090#1086#1087#1083#1080#1074#1072
  end
  object edFuel: TcxButtonEdit
    Left = 39
    Top = 292
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 210
  end
  object cxLabel9: TcxLabel
    Left = 40
    Top = 136
    Caption = #1043#1088#1091#1087#1087#1072' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080
  end
  object ceGroupStat: TcxButtonEdit
    Left = 40
    Top = 155
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 273
  end
  object ActionList: TActionList
    Left = 304
    Top = 80
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = #1054#1082
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Goods'
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
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inWeight'
        Value = 0.000000000000000000
        Component = ceWeight
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inGroupStatId'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inMeasureId'
        Value = ''
        Component = dsdMeasureGuides
        ParamType = ptInput
      end
      item
        Name = 'inTradeMarkId'
        Value = ''
        Component = TradeMarkGuides
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = dsdInfoMoneyGuides
        ParamType = ptInput
      end
      item
        Name = 'inBusinessId'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inFuelId'
        Value = ''
        Component = FuelGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 232
    Top = 48
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
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
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
      end
      item
        Name = 'GoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsGroupName'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'GroupStatId'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GroupStatName'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'MeasureId'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'MeasureName'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'TradeMarkId'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TradeMarkName'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = dsdInfoMoneyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = dsdInfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'Weight'
        Value = 0.000000000000000000
        Component = ceWeight
        DataType = ftCurrency
      end
      item
        Name = 'FuelId'
        Value = ''
        Component = FuelGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'FuelName'
        Value = ''
        Component = FuelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'BusinessId'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'BusinessName'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 8
    Top = 64
  end
  object dsdMeasureGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMeasure
    FormNameParam.Value = 'TMeasureForm'
    FormNameParam.DataType = ftString
    FormName = 'TMeasureForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 104
    Top = 240
  end
  object TradeMarkGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = сеTradeMark
    FormNameParam.Value = 'TTradeMarkForm'
    FormNameParam.DataType = ftString
    FormName = 'TTradeMarkForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = TradeMarkGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 88
    Top = 194
  end
  object dsdInfoMoneyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdInfoMoneyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdInfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 224
    Top = 171
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
    Left = 280
    Top = 323
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 8
  end
  object BusinessGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBusiness
    FormNameParam.Value = 'TBusiness_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TBusiness_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 192
    Top = 232
  end
  object FuelGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFuel
    FormNameParam.Value = 'TFuelForm'
    FormNameParam.DataType = ftString
    FormName = 'TFuelForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FuelGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FuelGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 128
    Top = 280
  end
  object GoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParentGroup
    FormNameParam.Value = 'TGoodsGroupForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 208
    Top = 112
  end
  object GoodsGroupStatGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGroupStat
    FormNameParam.Value = 'TGoodsGroupStatForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsGroupStatForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupStatGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 112
    Top = 144
  end
end
