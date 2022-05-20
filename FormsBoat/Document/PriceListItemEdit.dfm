object PriceListItemEditForm: TPriceListItemEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1090#1088#1086#1082#1091' <'#1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072'>'
  ClientHeight = 304
  ClientWidth = 424
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
  object cxButtonOK: TcxButton
    Left = 90
    Top = 269
    Width = 75
    Height = 25
    Action = actInsertUpdate
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 235
    Top = 269
    Width = 75
    Height = 25
    Action = actFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
  end
  object cxLabel3: TcxLabel
    Left = 215
    Top = 2
    Caption = #1043#1088#1091#1087#1087#1072
  end
  object cxLabel5: TcxLabel
    Left = 8
    Top = 2
    Caption = #1043#1088#1091#1087#1087#1072' '#1089#1082'. '#1091' '#1087#1086#1089#1090'.'
  end
  object edGoods: TcxButtonEdit
    Left = 215
    Top = 72
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 200
  end
  object edGoodsGroup: TcxButtonEdit
    Left = 215
    Top = 22
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 200
  end
  object edDiscountPartner: TcxButtonEdit
    Left = 8
    Top = 22
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 200
  end
  object cxLabel8: TcxLabel
    Left = 215
    Top = 151
    Hint = #1056#1077#1082#1086#1084#1077#1085'. '#1094#1077#1085#1072' '#1073#1077#1079' '#1085#1076#1089' ('#1091#1087'.)'
    Caption = #1056#1077#1082#1086#1084#1077#1085'. '#1094#1077#1085#1072' '#1073#1077#1079' '#1085#1076#1089' ('#1091#1087'.)'
    ParentShowHint = False
    ShowHint = True
  end
  object ceEmpfPriceParent: TcxCurrencyEdit
    Left = 215
    Top = 171
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 200
  end
  object cxLabel13: TcxLabel
    Left = 215
    Top = 52
    Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
  end
  object edGoodsCode: TcxCurrencyEdit
    Left = 113
    Top = 72
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 95
  end
  object ceAmount: TcxCurrencyEdit
    Left = 8
    Top = 171
    EditValue = 1.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 0
    Width = 95
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 152
    Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1085#1076#1089
  end
  object cxLabel4: TcxLabel
    Left = 215
    Top = 199
    Caption = 'WeightParent'
  end
  object ceWeightParent: TcxCurrencyEdit
    Left = 215
    Top = 218
    ParentFont = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    TabOrder = 15
    Width = 95
  end
  object cxLabel6: TcxLabel
    Left = 112
    Top = 52
    Caption = 'Interne Nr'
  end
  object cxLabel18: TcxLabel
    Left = 8
    Top = 52
    Caption = 'Artikel Nr'
  end
  object edArticle: TcxTextEdit
    Left = 8
    Top = 72
    Properties.ReadOnly = True
    TabOrder = 18
    Width = 95
  end
  object cxLabel7: TcxLabel
    Left = 113
    Top = 152
    Hint = #1062#1077#1085#1072' '#1073#1077#1079' '#1085#1076#1089' ('#1091#1087#1072#1082#1086#1074#1082#1080')'
    Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1085#1076#1089' ('#1091#1087'.)'
    ParentShowHint = False
    ShowHint = True
  end
  object cePriceParent: TcxCurrencyEdit
    Left = 113
    Top = 171
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 1
    Width = 95
  end
  object ceMeasureMult: TcxCurrencyEdit
    Left = 215
    Top = 122
    ParentFont = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clRed
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.TextColor = clWindowText
    Style.IsFontAssigned = True
    TabOrder = 22
    Width = 95
  end
  object cxLabel10: TcxLabel
    Left = 215
    Top = 102
    Caption = #1042#1083#1086#1078#1077#1085#1085#1086#1089#1090#1100
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlack
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object cxLabel9: TcxLabel
    Left = 8
    Top = 198
    Caption = #1052#1080#1085' '#1082#1086#1083'. '#1079#1072#1082#1091#1087#1082#1080
  end
  object ceMinCount: TcxCurrencyEdit
    Left = 8
    Top = 218
    ParentFont = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    TabOrder = 24
    Width = 95
  end
  object cxLabel11: TcxLabel
    Left = 8
    Top = 102
    Caption = #1045#1076'. '#1080#1079#1084'.'
  end
  object ceMeasure: TcxButtonEdit
    Left = 8
    Top = 122
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 26
    Width = 95
  end
  object cxLabel12: TcxLabel
    Left = 113
    Top = 102
    Caption = #1045#1076'.'#1080#1079#1084' ('#1091#1087#1072#1082#1086#1074#1082#1080')'
  end
  object edMeasureParent: TcxButtonEdit
    Left = 113
    Top = 122
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 27
    Width = 95
  end
  object ceMinCountMult: TcxCurrencyEdit
    Left = 113
    Top = 218
    ParentFont = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    TabOrder = 29
    Width = 95
  end
  object cxLabel14: TcxLabel
    Left = 113
    Top = 198
    Caption = #1056#1077#1082#1086#1084'. '#1082#1086#1083'. '#1079#1072#1082#1091#1087'.'
  end
  object edCatalogPage: TcxTextEdit
    Left = 320
    Top = 218
    TabOrder = 32
    Width = 95
  end
  object cxLabel15: TcxLabel
    Left = 320
    Top = 198
    Caption = 'CatalogPage'
  end
  object cbOutlet: TcxCheckBox
    Left = 354
    Top = 122
    Caption = 'Outlet'
    TabOrder = 30
    Width = 61
  end
  object ActionList: TActionList
    Left = 16
    Top = 221
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
      StoredProcList = <
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGet_TotalCount: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGet_TotalCount'
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PriceList'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = -1
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId'
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
        Name = 'inDiscountPartnerId'
        Value = Null
        Component = GuidesDiscountPartner
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
        Name = 'inMeasureParentId'
        Value = Null
        Component = GuidesMeasureParent
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        Component = ceAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMeasureMult'
        Value = Null
        Component = ceMeasureMult
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceParent'
        Value = Null
        Component = cePriceParent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmpfPriceParent'
        Value = 0.000000000000000000
        Component = ceEmpfPriceParent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinCount'
        Value = Null
        Component = ceMinCount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinCountMult'
        Value = Null
        Component = ceMinCountMult
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeightParent'
        Value = Null
        Component = ceWeightParent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCatalogPage'
        Value = Null
        Component = edCatalogPage
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOutlet'
        Value = Null
        Component = cbOutlet
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 175
    Top = 223
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 83
    Top = 200
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MI_PriceList'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId'
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
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
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
        Name = 'Article'
        Value = Null
        Component = edArticle
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
        Name = 'GoodsGroupNameFull'
        Value = Null
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountPartnerId'
        Value = Null
        Component = GuidesDiscountPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountPartnerName'
        Value = Null
        Component = GuidesDiscountPartner
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
        Name = 'MeasureParentId'
        Value = Null
        Component = GuidesMeasureParent
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureParentName'
        Value = Null
        Component = GuidesMeasureParent
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
        Name = 'MeasureMult'
        Value = Null
        Component = ceMeasureMult
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceParent'
        Value = Null
        Component = cePriceParent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'EmpfPriceParent'
        Value = Null
        Component = ceEmpfPriceParent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MinCount'
        Value = Null
        Component = ceMinCount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MinCountMult'
        Value = Null
        Component = ceMinCountMult
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'WeightParent'
        Value = Null
        Component = ceWeightParent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CatalogPage'
        Value = Null
        Component = edCatalogPage
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isOutlet'
        Value = Null
        Component = cbOutlet
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 12
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
    Left = 376
    Top = 60
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 353
    Top = 152
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
        Name = 'Code'
        Value = Null
        Component = edGoodsCode
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
        Name = 'Article'
        Value = Null
        Component = edArticle
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
        Name = 'EKPrice'
        Value = Null
        Component = ceEmpfPriceParent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 268
    Top = 56
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroup-Form'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroup-Form'
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
    Left = 281
    Top = 7
  end
  object GuidesDiscountPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edDiscountPartner
    FormNameParam.Value = 'TDiscountPartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDiscountPartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesDiscountPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesDiscountPartner
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
    Left = 113
    Top = 2
  end
  object EnterMoveNext: TEnterMoveNext
    EnterMoveNextList = <
      item
        Control = edGoods
      end
      item
        Control = edDiscountPartner
      end
      item
        Control = ceMeasure
      end
      item
        Control = edMeasureParent
      end
      item
        Control = ceMeasureMult
      end
      item
        Control = ceAmount
        ExitAction = actGet_TotalCount
      end
      item
        Control = cePriceParent
      end
      item
        Control = ceEmpfPriceParent
      end
      item
        Control = ceMinCount
      end
      item
        Control = ceMinCountMult
      end
      item
        Control = ceWeightParent
      end
      item
        Control = edCatalogPage
      end
      item
        Control = cbOutlet
      end
      item
        Control = cxButtonOK
      end>
    Left = 352
    Top = 224
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'GoodsId'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = GuidesGoods
      end
      item
        Guides = GuidesDiscountPartner
      end
      item
        Guides = GuidesMeasure
      end
      item
        Guides = GuidesMeasureParent
      end>
    ActionItemList = <
      item
      end>
    Left = 280
    Top = 208
  end
  object GuidesMeasure: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMeasure
    FormNameParam.Value = 'TMeasureForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMeasureForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMeasure
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMeasure
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 56
    Top = 93
  end
  object GuidesMeasureParent: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMeasureParent
    FormNameParam.Value = 'TMeasureForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMeasureForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMeasureParent
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMeasureParent
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 177
    Top = 93
  end
end
