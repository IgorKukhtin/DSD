object IncomeItemEditForm: TIncomeItemEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1058#1086#1074#1072#1088' '#1087#1088#1080#1093#1086#1076#1072'>'
  ClientHeight = 377
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxLabel1: TcxLabel
    Left = 8
    Top = 96
    Caption = #1040#1088#1090#1080#1082#1091#1083
  end
  object cxButton1: TcxButton
    Left = 172
    Top = 339
    Width = 75
    Height = 25
    Action = actInsertUpdate
    Default = True
    TabOrder = 11
  end
  object cxButton2: TcxButton
    Left = 316
    Top = 339
    Width = 75
    Height = 25
    Action = actFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 12
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 8
    Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
  end
  object cxLabel4: TcxLabel
    Left = 444
    Top = 96
    Caption = #1045#1076'.'#1080#1079#1084'.'
  end
  object cxLabel5: TcxLabel
    Left = 8
    Top = 139
    Caption = #1057#1086#1089#1090#1072#1074
  end
  object cxLabel6: TcxLabel
    Left = 8
    Top = 183
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077
  end
  object cxLabel7: TcxLabel
    Left = 8
    Top = 228
    Caption = #1051#1080#1085#1080#1103
  end
  object cxLabel9: TcxLabel
    Left = 289
    Top = 97
    Caption = #1056#1072#1079#1084#1077#1088
  end
  object ceGoodsSize: TcxButtonEdit
    Left = 289
    Top = 113
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 91
  end
  object edGoodsName: TcxButtonEdit
    Left = 8
    Top = 113
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 2
    Width = 273
  end
  object edGoodsGroupName: TcxButtonEdit
    Left = 8
    Top = 26
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 0
    Width = 275
  end
  object edCompositionName: TcxButtonEdit
    Left = 8
    Top = 156
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 3
    Width = 273
  end
  object edGoodsInfoName: TcxButtonEdit
    Left = 8
    Top = 200
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 4
    Width = 273
  end
  object edLineFabricaName: TcxButtonEdit
    Left = 8
    Top = 246
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 5
    Width = 273
  end
  object edMeasure: TcxButtonEdit
    Left = 444
    Top = 113
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 20
    Width = 55
  end
  object cxLabel18: TcxLabel
    Left = 388
    Top = 96
    Caption = #1050#1086#1083'-'#1074#1086
  end
  object ceAmount: TcxCurrencyEdit
    Left = 388
    Top = 113
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 8
    Width = 49
  end
  object cxLabel2: TcxLabel
    Left = 289
    Top = 229
    Caption = #1042#1093'. '#1094#1077#1085#1072
  end
  object cePriceJur: TcxCurrencyEdit
    Left = 289
    Top = 246
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####; -,0.####; '
    Properties.EditFormat = ',0.####; -,0.####; '
    TabOrder = 9
    Width = 91
  end
  object cxLabel8: TcxLabel
    Left = 289
    Top = 273
    Caption = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091
  end
  object ceOperPriceList: TcxCurrencyEdit
    Left = 289
    Top = 293
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####; -,0.####; '
    Properties.EditFormat = ',0.####; -,0.####; '
    TabOrder = 10
    Width = 91
  end
  object cxLabel10: TcxLabel
    Left = 394
    Top = 229
    Caption = #1050#1086#1083'. '#1074' '#1094#1077#1085#1077
    Visible = False
  end
  object ceCountForPrice: TcxCurrencyEdit
    Left = 395
    Top = 246
    EditValue = 1.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 25
    Visible = False
    Width = 104
  end
  object cxLabel11: TcxLabel
    Left = 10
    Top = 52
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object edLabelName: TcxButtonEdit
    Left = 10
    Top = 69
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 1
    Width = 273
  end
  object cxLabel12: TcxLabel
    Left = 10
    Top = 273
    Caption = #1060#1080#1088#1084#1072
  end
  object edJuridicalBasis: TcxButtonEdit
    Left = 10
    Top = 293
    Enabled = False
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 273
  end
  object cxLabel13: TcxLabel
    Left = 289
    Top = 52
    Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
  end
  object edGoodsCode: TcxCurrencyEdit
    Left = 289
    Top = 69
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 29
    Width = 210
  end
  object cbisCode: TcxCheckBox
    Left = 289
    Top = 26
    Caption = #1053#1077' '#1080#1079#1084#1077#1085#1103#1090#1100' '#1082#1086#1076' '#1090#1086#1074#1072#1088#1072
    Properties.ReadOnly = True
    TabOrder = 30
    Width = 168
  end
  object ActionList: TActionList
    Left = 24
    Top = 328
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
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsertUpdate: TdsdInsertUpdateGuides
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
    object actRefreshOperPriceList: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_PriceWithoutPersent
      StoredProcList = <
        item
          StoredProc = spUpdate_PriceWithoutPersent
        end
        item
          StoredProc = spGet_OperPriceList
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actUpdate_PriceWithoutPersent: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_PriceWithoutPersent
      StoredProcList = <
        item
          StoredProc = spUpdate_PriceWithoutPersent
        end>
      Caption = #1088#1072#1089#1095#1077#1090' '#1074#1093'. '#1094#1077#1085#1099' '#1073#1077#1079' '#1087#1088#1086#1094#1077#1085#1090#1072
      Hint = #1088#1072#1089#1095#1077#1090' '#1074#1093'. '#1094#1077#1085#1099' '#1073#1077#1079' '#1087#1088#1086#1094#1077#1085#1090#1072
      ImageIndex = 56
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MIEdit_Income'
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
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = Null
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMeasureId'
        Value = Null
        Component = GuidesMeasure
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = GuidesJuridicalBasis
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioGoodsCode'
        Value = Null
        Component = edGoodsCode
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsName'
        Value = Null
        Component = edGoodsName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsInfoName'
        Value = Null
        Component = edGoodsInfoName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsSizeName'
        Value = Null
        Component = ceGoodsSize
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCompositionName'
        Value = Null
        Component = edCompositionName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLineFabricaName'
        Value = Null
        Component = edLineFabricaName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLabelName'
        Value = Null
        Component = edLabelName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = '2'
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceJur'
        Value = '45'
        Component = cePriceJur
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountForPrice'
        Value = '1'
        Component = ceCountForPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPriceList'
        Value = '55'
        Component = ceOperPriceList
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCode'
        Value = Null
        Component = cbisCode
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 452
    Top = 320
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
        Name = 'GoodsGroupId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMask'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCode'
        Value = Null
        Component = cbisCode
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 328
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MovementItem_Income'
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
        Name = 'inGoodsGroupId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsGroupId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMask'
        Value = Null
        Component = FormParams
        ComponentItem = 'isMask'
        DataType = ftBoolean
        ParamType = ptInput
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
        Name = 'GoodsCode'
        Value = Null
        Component = edGoodsCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupId'
        Value = Null
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = Null
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureId'
        Value = Null
        Component = GuidesMeasure
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureName'
        Value = Null
        Component = GuidesMeasure
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = Null
        Component = GuidesJuridicalBasis
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = GuidesJuridicalBasis
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CompositionId'
        Value = Null
        Component = GuidesComposition
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CompositionName'
        Value = Null
        Component = GuidesComposition
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsInfoId'
        Value = Null
        Component = GuidesGoodsInfo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsInfoName'
        Value = Null
        Component = GuidesGoodsInfo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LineFabricaId'
        Value = Null
        Component = GuidesLineFabrica
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'LineFabricaName'
        Value = Null
        Component = GuidesLineFabrica
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelId'
        Value = Null
        Component = GuidesLabel
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelName'
        Value = Null
        Component = GuidesLabel
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsSizeId'
        Value = Null
        Component = GuidesGoodsSize
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsSizeName'
        Value = Null
        Component = GuidesGoodsSize
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount'
        Value = Null
        Component = ceAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceJur'
        Value = Null
        Component = cePriceJur
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CountForPrice'
        Value = Null
        Component = ceCountForPrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperPriceList'
        Value = Null
        Component = ceOperPriceList
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 400
    Top = 288
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
    Left = 176
    Top = 56
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 272
    Top = 320
  end
  object GuidesGoodsSize: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsSize
    FormNameParam.Value = 'TGoodsSizeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsSizeForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsSize
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsSize
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 313
    Top = 149
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsName
    FormNameParam.Value = 'TGoodsForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsForm'
    PositionDataSet = 'MasterCDS'
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
        Name = 'GoodsGroupId'
        Value = Null
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = Null
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureId'
        Value = Null
        Component = GuidesMeasure
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureName'
        Value = Null
        Component = GuidesMeasure
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CompositionId'
        Value = Null
        Component = GuidesComposition
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CompositionName'
        Value = Null
        Component = GuidesComposition
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsInfoId'
        Value = Null
        Component = GuidesGoodsInfo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsInfoName'
        Value = Null
        Component = GuidesGoodsInfo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LineFabricaId'
        Value = Null
        Component = GuidesLineFabrica
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'LineFabricaName'
        Value = Null
        Component = GuidesLineFabrica
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelId'
        Value = Null
        Component = GuidesLabel
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelName'
        Value = Null
        Component = GuidesLabel
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CompositionGroupId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'CompositionGroupName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 81
    Top = 102
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroupName
    FormNameParam.Value = 'TGoodsGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroupForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CompositionName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsInfoName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LineFabricaName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 209
    Top = 9
  end
  object GuidesComposition: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCompositionName
    FormNameParam.Value = 'TCompositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCompositionForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesComposition
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesComposition
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CompositionGroupId'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CompositionGroupName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 129
    Top = 134
  end
  object GuidesGoodsInfo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsInfoName
    FormNameParam.Value = 'TGoodsInfoForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsInfoForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsInfo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsInfo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CompositionName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsInfoName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LineFabricaName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 185
    Top = 181
  end
  object GuidesLineFabrica: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLineFabricaName
    FormNameParam.Value = 'TLineFabricaForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TLineFabricaForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesLineFabrica
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesLineFabrica
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CompositionName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsInfoName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LineFabricaName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 129
    Top = 229
  end
  object GuidesMeasure: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMeasure
    FormNameParam.Value = 'TMeasureForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMeasureForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMeasure
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMeasure
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CompositionName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsInfoName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LineFabricaName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 441
    Top = 110
  end
  object GuidesLabel: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLabelName
    FormNameParam.Value = 'TLabelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TLabelForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesLabel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesLabel
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CompositionName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsInfoName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LineFabricaName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 65
    Top = 61
  end
  object GuidesJuridicalBasis: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridicalBasis
    FormNameParam.Value = 'TJuridicalBasisForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalBasisForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridicalBasis
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridicalBasis
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 79
    Top = 270
  end
  object spGet_OperPriceList: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Income_OperPriceList'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsName'
        Value = Null
        Component = edGoodsName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPrice'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'OperPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountForPrice'
        Value = 0.000000000000000000
        Component = ceCountForPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperPriceList'
        Value = 0.000000000000000000
        Component = ceOperPriceList
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 192
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshOperPriceList
    ComponentList = <
      item
        Component = cePriceJur
      end
      item
        Component = ceCountForPrice
      end>
    Left = 448
    Top = 160
  end
  object spUpdate_PriceWithoutPersent: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_Income_PricebyPersent'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inPersent'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'inChangePercent'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceJur'
        Value = Null
        Component = cePriceJur
        ComponentItem = 'PriceJur'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outOperPrice'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperPrice'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 464
    Top = 208
  end
end
