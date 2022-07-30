object ProdOptionsEditForm: TProdOptionsEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1054#1087#1094#1080#1080'>'
  ClientHeight = 401
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actDataSetRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 10
    Top = 73
    TabOrder = 0
    Width = 407
  end
  object cxLabel1: TcxLabel
    Left = 10
    Top = 55
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 118
    Top = 361
    Width = 75
    Height = 25
    Action = actInsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 262
    Top = 361
    Width = 75
    Height = 25
    Action = actFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object cxLabel2: TcxLabel
    Left = 10
    Top = 8
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 10
    Top = 30
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = False
    TabOrder = 5
    Width = 128
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 297
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edComment: TcxTextEdit
    Left = 10
    Top = 315
    TabOrder = 7
    Width = 407
  end
  object cxLabel6: TcxLabel
    Left = 10
    Top = 100
    Hint = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1085#1076#1089
    Caption = 'Ladenpreis'
  end
  object edSalePrice: TcxCurrencyEdit
    Left = 10
    Top = 120
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 9
    Width = 256
  end
  object cxLabel12: TcxLabel
    Left = 10
    Top = 199
    Caption = 'Model'
  end
  object edModel: TcxButtonEdit
    Left = 10
    Top = 219
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 183
  end
  object cxLabel11: TcxLabel
    Left = 199
    Top = 199
    Caption = 'Brand'
  end
  object edBrand: TcxButtonEdit
    Left = 199
    Top = 219
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 106
  end
  object cxLabel4: TcxLabel
    Left = 311
    Top = 199
    Caption = 'Engine'
  end
  object edProdEngine: TcxButtonEdit
    Left = 311
    Top = 219
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 106
  end
  object cxLabel5: TcxLabel
    Left = 272
    Top = 100
    Caption = #1058#1080#1087' '#1053#1044#1057
  end
  object edTaxKind: TcxButtonEdit
    Left = 272
    Top = 120
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 145
  end
  object cxLabel7: TcxLabel
    Left = 10
    Top = 148
    Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
  end
  object edGoods: TcxButtonEdit
    Left = 10
    Top = 171
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 407
  end
  object cxLabel8: TcxLabel
    Left = 10
    Top = 247
    Caption = 'MaterialOptions'
  end
  object edMaterialOptions: TcxButtonEdit
    Left = 10
    Top = 267
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 200
  end
  object edCodeVergl: TcxCurrencyEdit
    Left = 154
    Top = 30
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 22
    Width = 120
  end
  object cxLabel9: TcxLabel
    Left = 154
    Top = 10
    Hint = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1085#1076#1089
    Caption = #1040#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074#1085#1099#1081' '#1082#1086#1076
  end
  object cxLabel10: TcxLabel
    Left = 296
    Top = 13
    Caption = 'Id '#1057#1072#1081#1090
  end
  object edId_Site: TcxTextEdit
    Left = 288
    Top = 30
    TabOrder = 25
    Width = 129
  end
  object edProdColorPattern: TcxButtonEdit
    Left = 217
    Top = 267
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 26
    Width = 200
  end
  object cxLabel13: TcxLabel
    Left = 217
    Top = 247
    Caption = #1069#1083#1077#1084#1077#1085#1090' Boat Structure'
  end
  object ActionList: TActionList
    Left = 160
    Top = 121
    object actDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object actFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ProdOptions'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCode'
        Value = 0.000000000000000000
        Component = edCode
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCodeVergl'
        Value = Null
        Component = edCodeVergl
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSalePrice'
        Value = Null
        Component = edSalePrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inId_Site'
        Value = Null
        Component = edId_Site
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inModelId'
        Value = Null
        Component = GuidesModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxKindId'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMaterialOptionsId'
        Value = Null
        Component = GuidesMaterialOptions
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdColorPatternId'
        Value = Null
        Component = GuidesProdColorPattern
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 96
    Top = 89
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdModelId'
        Value = Null
        Component = GuidesModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdModelName'
        Value = Null
        Component = GuidesModel
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 376
    Top = 73
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_ProdOptions'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdModelId'
        Value = Null
        Component = GuidesModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCode
        DataType = ftUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'SalePrice'
        Value = Null
        Component = edSalePrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindId'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindName'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelId'
        Value = Null
        Component = GuidesModel
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelName'
        Value = Null
        Component = GuidesModel
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdEngineId'
        Value = Null
        Component = GuidesProdEngine
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdEngineName'
        Value = Null
        Component = GuidesProdEngine
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id_Site'
        Value = Null
        Component = edId_Site
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CodeVergl'
        Value = Null
        Component = edCodeVergl
        MultiSelectSeparator = ','
      end
      item
        Name = 'MaterialOptionsId'
        Value = Null
        Component = GuidesMaterialOptions
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MaterialOptionsName'
        Value = Null
        Component = GuidesMaterialOptions
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdColorPatternId'
        Value = Null
        Component = GuidesProdColorPattern
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdColorPatternName'
        Value = Null
        Component = GuidesProdColorPattern
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ColorPatternId'
        Value = Null
        Component = FormParams
        ComponentItem = 'ColorPatternId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ColorPatternName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ColorPatternName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 136
    Top = 57
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
    Left = 200
    Top = 309
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 408
    Top = 130
  end
  object GuidesModel: TdsdGuides
    KeyField = 'Id'
    LookupControl = edModel
    FormNameParam.Value = 'TProdModelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProdModelForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesModel
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandId'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandName'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdEngineId'
        Value = ''
        Component = GuidesProdEngine
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdEngineName'
        Value = ''
        Component = GuidesProdEngine
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ColorPatternId'
        Value = Null
        Component = FormParams
        ComponentItem = 'ColorPatternId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ColorPatternName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ColorPatternName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 103
    Top = 209
  end
  object GuidesBrand: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBrand
    DisableGuidesOpen = True
    FormNameParam.Value = 'TBrandForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBrandForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 207
    Top = 185
  end
  object GuidesProdEngine: TdsdGuides
    KeyField = 'Id'
    LookupControl = edProdEngine
    DisableGuidesOpen = True
    FormNameParam.Value = 'TProdEngineForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProdEngineForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesProdEngine
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesProdEngine
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 383
    Top = 216
  end
  object GuidesTaxKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTaxKind
    FormNameParam.Value = 'TTaxKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TTaxKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandId'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandName'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdEngineId'
        Value = ''
        Component = GuidesProdEngine
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdEngineName'
        Value = ''
        Component = GuidesProdEngine
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 87
    Top = 161
  end
  object GuidesGoods: TdsdGuides
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
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandId'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandName'
        Value = ''
        Component = GuidesBrand
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdEngineId'
        Value = ''
        Component = GuidesProdEngine
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdEngineName'
        Value = ''
        Component = GuidesProdEngine
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 270
    Top = 145
  end
  object GuidesMaterialOptions: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMaterialOptions
    FormNameParam.Value = 'TMaterialOptionsChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMaterialOptionsChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMaterialOptions
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMaterialOptions
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdColorPatternId'
        Value = Null
        Component = GuidesProdColorPattern
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdColorPatternName'
        Value = Null
        Component = GuidesProdColorPattern
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ColorPatternId'
        Value = Null
        Component = FormParams
        ComponentItem = 'ColorPatternId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ColorPatternName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ColorPatternName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 111
    Top = 265
  end
  object GuidesProdColorPattern: TdsdGuides
    KeyField = 'Id'
    LookupControl = edProdColorPattern
    FormNameParam.Value = 'TProdColorPatternForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProdColorPatternForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesProdColorPattern
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesProdColorPattern
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ColorPatternId'
        Value = Null
        Component = FormParams
        ComponentItem = 'ColorPatternId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ColorPatternName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ColorPatternName'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 303
    Top = 257
  end
end
