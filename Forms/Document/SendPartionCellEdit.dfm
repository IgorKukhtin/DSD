inherited SendPartionCellEditForm: TSendPartionCellEditForm
  ActiveControl = cePartionCell_Amount_1
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1080#1079#1084#1077#1085#1080#1090#1100' <'#1044#1072#1085#1085#1099#1077' '#1071#1095#1077#1077#1082'>'
  ClientHeight = 332
  ClientWidth = 400
  AddOnFormData.isSingle = False
  ExplicitWidth = 406
  ExplicitHeight = 361
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 56
    Top = 285
    Height = 26
    ExplicitLeft = 56
    ExplicitTop = 285
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 192
    Top = 285
    Height = 26
    ExplicitLeft = 192
    ExplicitTop = 285
    ExplicitHeight = 26
  end
  object cePartionCell_Amount_1: TcxCurrencyEdit [2]
    Left = 122
    Top = 93
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 2
    Width = 100
  end
  object cxLabel7: TcxLabel [3]
    Left = 44
    Top = 94
    Caption = '1.3 '#1050#1086#1083'-'#1074#1086
  end
  object ceGooods: TcxButtonEdit [4]
    Left = 8
    Top = 25
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 249
  end
  object cxLabel12: TcxLabel [5]
    Left = 8
    Top = 5
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
  end
  object cxLabel3: TcxLabel [6]
    Left = 44
    Top = 126
    Caption = '2.3 '#1050#1086#1083'-'#1074#1086
  end
  object cePartionCell_Amount_2: TcxCurrencyEdit [7]
    Left = 122
    Top = 125
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 7
    Width = 100
  end
  object cxLabel4: TcxLabel [8]
    Left = 44
    Top = 163
    Caption = '3.3 '#1050#1086#1083'-'#1074#1086
  end
  object cePartionCell_Amount_3: TcxCurrencyEdit [9]
    Left = 122
    Top = 162
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 9
    Width = 100
  end
  object cxLabel11: TcxLabel [10]
    Left = 44
    Top = 237
    Caption = '5.3 '#1050#1086#1083'-'#1074#1086
  end
  object cePartionCell_Amount_5: TcxCurrencyEdit [11]
    Left = 122
    Top = 236
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = False
    TabOrder = 11
    Width = 100
  end
  object cxLabel2: TcxLabel [12]
    Left = 270
    Top = 5
    Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
  end
  object ceGooodsKind: TcxButtonEdit [13]
    Left = 270
    Top = 25
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 80
  end
  object cxLabel9: TcxLabel [14]
    Left = 8
    Top = 61
    Caption = #8470' '#1087#1086#1089#1083'. '#1079#1072#1087#1086#1083#1085'. '#1103#1095'.'
  end
  object cePartionCell_Last: TcxCurrencyEdit [15]
    Left = 122
    Top = 66
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 15
    Width = 100
  end
  object cxLabel15: TcxLabel [16]
    Left = 44
    Top = 201
    Caption = '4.3 '#1050#1086#1083'-'#1074#1086
  end
  object cePartionCell_Amount_4: TcxCurrencyEdit [17]
    Left = 122
    Top = 200
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 17
    Width = 100
  end
  object cbisPartionCell_Close_1: TcxCheckBox [18]
    Left = 249
    Top = 93
    Caption = '1.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 18
    Width = 137
  end
  object cbisPartionCell_Close_3: TcxCheckBox [19]
    Left = 249
    Top = 162
    Caption = '3.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 19
    Width = 137
  end
  object cbisPartionCell_Close_4: TcxCheckBox [20]
    Left = 249
    Top = 200
    Caption = '4.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 20
    Width = 137
  end
  object cbisPartionCell_Close_2: TcxCheckBox [21]
    Left = 249
    Top = 125
    Caption = '2.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 21
    Width = 137
  end
  object cbisPartionCell_Close_5: TcxCheckBox [22]
    Left = 249
    Top = 237
    Caption = '5.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 22
    Width = 137
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 323
    Top = 234
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 144
    Top = 290
  end
  inherited ActionList: TActionList
    Left = 7
    Top = 225
    inherited InsertUpdateGuides: TdsdInsertUpdateGuides [0]
    end
    inherited actRefresh: TdsdDataSetRefresh [1]
    end
    inherited FormClose: TdsdFormClose [2]
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MovementId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 7
    Top = 90
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Send_PartionCell_edit'
    Params = <
      item
        Name = 'inId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = ''
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCell_Last'
        Value = Null
        Component = cePartionCell_Last
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCell_Amount_1'
        Value = ''
        Component = cePartionCell_Amount_1
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCell_Amount_2'
        Value = Null
        Component = cePartionCell_Amount_2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCell_Amount_3'
        Value = 0.000000000000000000
        Component = cePartionCell_Amount_3
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCell_Amount_4'
        Value = 0.000000000000000000
        Component = cePartionCell_Amount_4
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionCell_Amount_5'
        Value = ''
        Component = cePartionCell_Amount_5
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartionCell_Close_1'
        Value = Null
        Component = cbisPartionCell_Close_1
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartionCell_Close_2'
        Value = False
        Component = cbisPartionCell_Close_2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartionCell_Close_3'
        Value = Null
        Component = cbisPartionCell_Close_3
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartionCell_Close_4'
        Value = Null
        Component = cbisPartionCell_Close_4
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartionCell_Close_5'
        Value = ''
        Component = cbisPartionCell_Close_5
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 8
    Top = 136
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Send_PartionCell_edit'
    Params = <
      item
        Name = 'inMovementId'
        Value = ''
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementItemId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindId'
        Value = ''
        Component = GuidesGooodsKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindName'
        Value = ''
        Component = GuidesGooodsKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCell_Last'
        Value = 0.000000000000000000
        Component = cePartionCell_Last
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCell_Amount_1'
        Value = 0d
        Component = cePartionCell_Amount_1
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCell_Amount_2'
        Value = 0.000000000000000000
        Component = cePartionCell_Amount_2
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCell_Amount_3'
        Value = ''
        Component = cePartionCell_Amount_3
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCell_Amount_4'
        Value = 0d
        Component = cePartionCell_Amount_4
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionCell_Amount_5'
        Value = ''
        Component = cePartionCell_Amount_5
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPartionCell_Close_1'
        Value = ''
        Component = cbisPartionCell_Close_1
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPartionCell_Close_2'
        Value = Null
        Component = cbisPartionCell_Close_2
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPartionCell_Close_3'
        Value = ''
        Component = cbisPartionCell_Close_3
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPartionCell_Close_4'
        Value = ''
        Component = cbisPartionCell_Close_4
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPartionCell_Close_5'
        Value = ''
        Component = cbisPartionCell_Close_5
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 25
    Top = 164
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGooods
    DisableGuidesOpen = True
    FormNameParam.Value = 'TGoods_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoods_ObjectForm'
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
        Name = 'GoodsKindId'
        Value = ''
        Component = GuidesGooodsKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindName'
        Value = ''
        Component = GuidesGooodsKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindCompleteId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsKindCompleteName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptCode_user'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 9
  end
  object GuidesGooodsKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGooodsKind
    DisableGuidesOpen = True
    FormNameParam.Value = 'TGoodsKind_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsKind_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGooodsKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGooodsKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 20
  end
end
