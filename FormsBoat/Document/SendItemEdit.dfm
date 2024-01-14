object SendItemEditForm: TSendItemEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'-1'
  ClientHeight = 296
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
    Left = 94
    Top = 260
    Width = 73
    Height = 25
    Action = actInsertUpdate
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 240
    Top = 260
    Width = 75
    Height = 25
    Action = actFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 2
    Caption = #1043#1088#1091#1087#1087#1072
  end
  object cxLabel5: TcxLabel
    Left = 218
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
    TabOrder = 3
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
    TabOrder = 7
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
    TabOrder = 8
    Width = 200
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
    TabOrder = 12
    Width = 95
  end
  object edAmount: TcxCurrencyEdit
    Left = 8
    Top = 172
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
    Left = 290
    Top = 152
    Caption = #1048#1058#1054#1043#1054' '#1056#1072#1089#1093#1086#1076':'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
  end
  object ceTotalCount: TcxCurrencyEdit
    Left = 290
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
    TabOrder = 15
    Width = 125
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
    TabOrder = 18
    Width = 95
  end
  object cxLabel1: TcxLabel
    Left = 113
    Top = 152
    Caption = 'S/N'
  end
  object edPartNumber: TcxTextEdit
    Left = 113
    Top = 172
    TabOrder = 1
    Width = 95
  end
  object edComment: TcxTextEdit
    Left = 113
    Top = 222
    TabOrder = 16
    Width = 302
  end
  object cxLabel9: TcxLabel
    Left = 113
    Top = 202
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object ceAmountRemainsFrom: TcxCurrencyEdit
    Left = 290
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
    TabOrder = 20
    Width = 125
  end
  object cxLabel7: TcxLabel
    Left = 290
    Top = 102
    Caption = #1054#1089#1090#1072#1090#1086#1082' '#1057#1082#1083#1072#1076':'
  end
  object cxLabel15: TcxLabel
    Left = 218
    Top = 52
    Caption = #8470' '#1076#1086#1082'. '#1047#1072#1082#1072#1079' '#1050#1083#1080#1077#1085#1090#1072
  end
  object edOrderClient: TcxButtonEdit
    Left = 215
    Top = 72
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 200
  end
  object cxLabel12: TcxLabel
    Left = 8
    Top = 202
    Caption = #1071#1095#1077#1081#1082#1072' '#1093#1088#1072#1085#1077#1085#1080#1103
  end
  object edPartionCell: TcxButtonEdit
    Left = 8
    Top = 222
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 25
    Width = 92
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 24
    Top = 67
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
      ImageIndex = 80
    end
    object actFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
      ImageIndex = 52
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
    StoredProcName = 'gpInsertUpdate_MovementItem_Send'
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
        Name = 'inMovementId_OrderClient'
        Value = '0'
        Component = GuidesOrderClient
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_OrderTop'
        Value = Null
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
        Name = 'ioAmount'
        Value = 0.000000000000000000
        Component = edAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperPrice'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountForPrice'
        Value = 1.000000000000000000
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
        Name = 'ioPartionCellName'
        Value = Null
        Component = edPartionCell
        DataType = ftString
        ParamType = ptInputOutput
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
        Name = 'inisOn'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 215
    Top = 159
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
      end
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = GuidesOrderClient
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 227
    Top = 102
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Send'
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
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId_OrderClient'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
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
        Name = 'Amount'
        Value = Null
        Component = edAmount
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
        Name = 'AmountRemainsFrom'
        Value = Null
        Component = ceAmountRemainsFrom
        DataType = ftFloat
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
        Name = 'MovementId_OrderClient'
        Value = Null
        Component = GuidesOrderClient
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberFull_OrderClient'
        Value = Null
        Component = GuidesOrderClient
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellId'
        Value = Null
        Component = GuidesPartionCell
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCellName'
        Value = Null
        Component = GuidesPartionCell
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 48
    Top = 234
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
    Top = 114
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 385
    Top = 246
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
    Left = 68
    Top = 94
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
    Left = 73
    Top = 13
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
    Left = 257
    Top = 8
  end
  object EnterMoveNext: TEnterMoveNext
    EnterMoveNextList = <
      item
        Control = edAmount
        ExitAction = actGet_TotalCount
      end
      item
        Control = edPartNumber
      end
      item
        Control = edPartionCell
      end
      item
        Control = cxButtonOK
      end>
    Left = 296
    Top = 182
  end
  object spGet_TotalCount: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Send_TotalCount'
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
        Name = 'inMovementItemId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
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
        Component = edAmount
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
      end
      item
        Name = 'outAmountRemains'
        Value = Null
        Component = ceAmountRemainsFrom
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 128
    Top = 120
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
    Left = 216
    Top = 206
  end
  object GuidesOrderClient: TdsdGuides
    KeyField = 'Id'
    LookupControl = edOrderClient
    Key = '0'
    FormNameParam.Value = 'TOrderClientJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderClientJournalChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesOrderClient
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesOrderClient
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectId'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptResult
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectName'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptResult
        MultiSelectSeparator = ','
      end
      item
        Name = 'Article_Object'
        Value = Null
        Component = edArticle
        DataType = ftString
        ParamType = ptResult
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectCode'
        Value = Null
        Component = edGoodsCode
        ParamType = ptResult
        MultiSelectSeparator = ','
      end>
    Left = 288
    Top = 56
  end
  object GuidesPartionCell: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartionCell
    FormNameParam.Value = 'TPartionCellForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartionCellForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartionCell
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartionCell
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 27
    Top = 200
  end
end
