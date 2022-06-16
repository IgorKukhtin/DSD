object InventoryItemEdit_limitForm: TInventoryItemEdit_limitForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100' ***'#1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1102
  ClientHeight = 252
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
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButtonOK: TcxButton
    Left = 113
    Top = 213
    Width = 75
    Height = 25
    Action = actInsertUpdate
    TabOrder = 3
  end
  object cxButton2: TcxButton
    Left = 258
    Top = 213
    Width = 75
    Height = 25
    Action = actFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 5
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 2
    Caption = #1043#1088#1091#1087#1087#1072
  end
  object cxLabel5: TcxLabel
    Left = 215
    Top = 2
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
  end
  object edGoods: TcxButtonEdit
    Left = 8
    Top = 122
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 200
  end
  object edGoodsGroup: TcxButtonEdit
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
  object edPartner: TcxButtonEdit
    Left = 215
    Top = 22
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 200
  end
  object cxLabel8: TcxLabel
    Left = 320
    Top = 52
    Caption = #1062#1077#1085#1072' '#1074#1093'.'
  end
  object ceOperPriceList: TcxCurrencyEdit
    Left = 320
    Top = 72
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 95
  end
  object cxLabel13: TcxLabel
    Left = 8
    Top = 102
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object edGoodsCode: TcxCurrencyEdit
    Left = 113
    Top = 72
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 95
  end
  object ceOperCount: TcxCurrencyEdit
    Left = 8
    Top = 172
    EditValue = 1.000000000000000000
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 0
    Width = 95
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 152
    Caption = #1050#1086#1083'-'#1074#1086
  end
  object cxLabel4: TcxLabel
    Left = 320
    Top = 152
    Caption = #1048#1058#1054#1043#1054
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
  end
  object ceTotalCount: TcxCurrencyEdit
    Left = 320
    Top = 172
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
    TabOrder = 16
    Width = 95
  end
  object cxLabel6: TcxLabel
    Left = 113
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
    TabOrder = 19
    Width = 95
  end
  object cxLabel1: TcxLabel
    Left = 114
    Top = 152
    Caption = 'S/N'
  end
  object edPartNumber: TcxTextEdit
    Left = 113
    Top = 172
    TabOrder = 1
    Width = 95
  end
  object cxLabel7: TcxLabel
    Left = 215
    Top = 152
    Caption = #1048#1058#1054#1043#1054' ('#1074#1074#1086#1076')'
  end
  object ceTotalCountEnter: TcxCurrencyEdit
    Left = 215
    Top = 172
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 2
    Width = 95
  end
  object cxLabel9: TcxLabel
    Left = 215
    Top = 102
    Caption = #1054#1089#1090#1072#1090#1086#1082' ('#1088#1072#1089#1095'.)'
  end
  object ceAmountRemains: TcxCurrencyEdit
    Left = 215
    Top = 122
    ParentFont = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    TabOrder = 23
    Width = 95
  end
  object cxLabel10: TcxLabel
    Left = 320
    Top = 102
    Caption = #1054#1089#1090#1072#1090#1086#1082' ('#1088#1072#1079#1085#1080#1094#1072')'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlack
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = []
    Style.IsFontAssigned = True
  end
  object ceAmountDiff: TcxCurrencyEdit
    Left = 320
    Top = 122
    ParentFont = False
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clRed
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    TabOrder = 25
    Width = 95
  end
  object ActionList: TActionList
    Left = 384
    Top = 125
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
        Name = 'inTotalCount'
        Value = Null
        Component = ceTotalCountEnter
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTotalCount_old'
        Value = Null
        Component = ceTotalCount
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
    Left = 227
    Top = 48
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Inventory'
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
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
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
        Name = 'PartNumber'
        Value = Null
        Component = edPartNumber
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
        Name = 'Price'
        Value = Null
        Component = ceOperPriceList
        DataType = ftFloat
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
        Component = ceTotalCountEnter
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
        Name = 'AmountRemains'
        Value = Null
        Component = ceAmountRemains
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountDiff'
        Value = Null
        Component = ceAmountDiff
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 52
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
    Left = 352
    Top = 92
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 345
    Top = 200
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoods_limitForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoods_limitForm'
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
      end>
    Left = 140
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
    Left = 105
    Top = 7
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
    Left = 297
    Top = 2
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
    Left = 360
    Top = 48
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
        Value = Null
        Component = ceTotalCountEnter
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTotalCount'
        Value = 0.000000000000000000
        Component = ceTotalCount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountRemains'
        Value = Null
        Component = ceAmountRemains
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountDiff'
        Value = Null
        Component = ceAmountDiff
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 40
    Top = 200
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = '0'
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'GoodsId'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
        Guides = GuidesGoods
      end>
    ActionItemList = <
      item
      end>
    Left = 40
    Top = 88
  end
end
