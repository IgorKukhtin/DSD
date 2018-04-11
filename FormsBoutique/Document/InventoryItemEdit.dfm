object InventoryItemEditForm: TInventoryItemEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1058#1086#1074#1072#1088' '#1074' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1102
  ClientHeight = 252
  ClientWidth = 408
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
    Left = 10
    Top = 53
    Caption = #1040#1088#1090#1080#1082#1091#1083
  end
  object cxButton1: TcxButton
    Left = 109
    Top = 211
    Width = 75
    Height = 25
    Action = actInsertUpdate
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 253
    Top = 211
    Width = 75
    Height = 25
    Action = actFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 8
    Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
  end
  object cxLabel5: TcxLabel
    Left = 10
    Top = 139
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
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
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 1
    Width = 110
  end
  object edGoodsName: TcxButtonEdit
    Left = 10
    Top = 70
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 0
    Width = 273
  end
  object edGoodsGroupName: TcxButtonEdit
    Left = 8
    Top = 26
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 391
  end
  object edPartner: TcxButtonEdit
    Left = 10
    Top = 156
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 273
  end
  object cxLabel8: TcxLabel
    Left = 289
    Top = 136
    Caption = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091
  end
  object ceOperPriceList: TcxCurrencyEdit
    Left = 289
    Top = 156
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 110
  end
  object cxLabel11: TcxLabel
    Left = 10
    Top = 96
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object edLabelName: TcxButtonEdit
    Left = 10
    Top = 113
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 273
  end
  object cxLabel13: TcxLabel
    Left = 289
    Top = 53
    Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
  end
  object edGoodsCode: TcxCurrencyEdit
    Left = 289
    Top = 69
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 110
  end
  object ActionList: TActionList
    Left = 32
    Top = 200
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
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Inventory'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
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
        Name = 'inPartionId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = '0'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountSecond'
        Value = '0'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = '0'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 316
    Top = 184
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 200
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MIInventory_Partion_byBarcode'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inBarCode'
        Value = Null
        Component = FormParams
        ComponentItem = 'inBarCode'
        DataType = ftString
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
        Name = 'GoodsGroupNameFull'
        Value = Null
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = Null
        Component = GuidesPartner
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
        Name = 'OperPriceList'
        Value = Null
        Component = ceOperPriceList
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionId'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
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
    Left = 201
    Top = 208
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
    Left = 329
    Top = 77
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CompositionId'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CompositionName'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsInfoId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsInfoName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LineFabricaId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'LineFabricaName'
        Value = Null
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
    Top = 54
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
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    FormNameParam.Value = 'TCompositionForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCompositionForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartner
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
    Left = 97
    Top = 142
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
    Left = 201
    Top = 109
  end
end
