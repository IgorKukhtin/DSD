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
  object cxButtonOK: TcxButton
    Left = 88
    Top = 213
    Width = 75
    Height = 25
    Action = actInsertUpdate
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 232
    Top = 213
    Width = 75
    Height = 25
    Action = actFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 45
    Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
  end
  object cxLabel5: TcxLabel
    Left = 8
    Top = 3
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
  end
  object edGoods: TcxButtonEdit
    Left = 86
    Top = 108
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 3
    Width = 313
  end
  object edGoodsGroup: TcxButtonEdit
    Left = 8
    Top = 64
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 269
  end
  object edPartner: TcxButtonEdit
    Left = 8
    Top = 21
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 269
  end
  object cxLabel8: TcxLabel
    Left = 184
    Top = 141
    Caption = #1062#1077#1085#1072' '#1074#1093'.'
  end
  object ceOperPriceList: TcxCurrencyEdit
    Left = 184
    Top = 160
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 85
  end
  object cxLabel13: TcxLabel
    Left = 86
    Top = 91
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object edGoodsCode: TcxCurrencyEdit
    Left = 8
    Top = 108
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 72
  end
  object ceOperCount: TcxCurrencyEdit
    Left = 8
    Top = 160
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 0
    Width = 72
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 141
    Caption = #1050#1086#1083'-'#1074#1086
  end
  object cxLabel4: TcxLabel
    Left = 86
    Top = 141
    Caption = #1048#1058#1054#1043#1054' :'
  end
  object ceTotalCount: TcxCurrencyEdit
    Left = 86
    Top = 160
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 93
  end
  object cxLabel6: TcxLabel
    Left = 8
    Top = 91
    Caption = 'Interne Nr'
  end
  object cxLabel18: TcxLabel
    Left = 288
    Top = 45
    Caption = 'Artikel Nr'
  end
  object edArticle: TcxTextEdit
    Left = 288
    Top = 64
    Properties.ReadOnly = True
    TabOrder = 18
    Width = 111
  end
  object cxLabel1: TcxLabel
    Left = 288
    Top = 3
    Caption = 'S/N'
  end
  object edPartNumber: TcxTextEdit
    Left = 288
    Top = 21
    Properties.ReadOnly = True
    TabOrder = 1
    Width = 111
  end
  object ActionList: TActionList
    Left = 352
    Top = 133
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
      StoredProc = spGet_TotalCount
      StoredProcList = <
        item
          StoredProc = spGet_TotalCount
        end>
      Caption = 'actGet_TotalCount'
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Inventory'
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
        Name = 'inPartionId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        Component = ceOperCount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = 0.000000000000000000
        Component = ceOperPriceList
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartNumber'
        Value = Null
        Component = edPartNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 183
    Top = 199
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
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 275
    Top = 144
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MIInventory_Partion_byBarcode'
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
        Name = 'inBarCode'
        Value = Null
        Component = FormParams
        ComponentItem = 'inBarCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartNumber'
        Value = Null
        Component = FormParams
        ComponentItem = 'inPartNumber'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = FormParams
        ComponentItem = 'inAmount'
        DataType = ftFloat
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
        Name = 'OperCount'
        Value = Null
        Component = ceOperCount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalCount'
        Value = Null
        Component = ceTotalCount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Price'
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
      end
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
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
        Name = 'PartNumber'
        Value = Null
        Component = edPartNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 208
    Top = 4
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
    Top = 196
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 313
    Top = 176
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
        Component = ceOperPriceList
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsInfoName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelName'
        Value = Null
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
    Left = 164
    Top = 96
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
    Left = 233
    Top = 47
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    FormNameParam.Value = 'TPartner-Form'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartner-Form'
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
    Left = 145
    Top = 10
  end
  object EnterMoveNext: TEnterMoveNext
    EnterMoveNextList = <
      item
        Control = ceOperCount
        ExitAction = actGet_TotalCount
      end
      item
        Control = edPartNumber
      end
      item
        Control = cxButtonOK
      end>
    Left = 320
    Top = 80
  end
  object spGet_TotalCount: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Inventory_TotalCount'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = 1.000000000000000000
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
        Name = 'inPartNumber'
        Value = Null
        Component = edPartNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperCount'
        Value = 0.000000000000000000
        Component = ceOperCount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalCount'
        Value = 0.000000000000000000
        Component = ceTotalCount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 64
    Top = 192
  end
end
