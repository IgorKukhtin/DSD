object Report_MotionGoodsAssetDialogForm: TReport_MotionGoodsAssetDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1054#1057'>'
  ClientHeight = 296
  ClientWidth = 453
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 98
    Top = 263
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 272
    Top = 263
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 121
    Top = 27
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object deStart: TcxDateEdit
    Left = 11
    Top = 27
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 90
  end
  object edGoods: TcxButtonEdit
    Left = 240
    Top = 177
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
    Top = 179
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 200
  end
  object edLocation: TcxButtonEdit
    Left = 240
    Top = 127
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 200
  end
  object edUnitGroup: TcxButtonEdit
    Left = 11
    Top = 127
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 200
  end
  object cxLabel3: TcxLabel
    Left = 11
    Top = 107
    Caption = #1043#1088#1091#1087#1087#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081':'
  end
  object cxLabel4: TcxLabel
    Left = 240
    Top = 107
    Caption = #1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072':'
  end
  object cxLabel1: TcxLabel
    Left = 9
    Top = 157
    Caption = #1043#1088#1091#1087#1087#1072' '#1054#1057':'
  end
  object cxLabel2: TcxLabel
    Left = 241
    Top = 157
    Caption = #1054#1057' / '#1058#1086#1074#1072#1088':'
  end
  object ceAccountGroup: TcxButtonEdit
    Left = 11
    Top = 77
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 200
  end
  object cxLabel5: TcxLabel
    Left = 11
    Top = 57
    Caption = #1057#1095#1077#1090' '#1075#1088#1091#1087#1087#1072':'
  end
  object cxLabel6: TcxLabel
    Left = 11
    Top = 7
    Caption = #1044#1072#1090#1072' '#1089' :'
  end
  object cxLabel7: TcxLabel
    Left = 121
    Top = 7
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cbInfoMoney: TcxCheckBox
    Left = 241
    Top = 77
    Caption = #1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1059#1055' '#1089#1090#1072#1090#1100#1103#1084
    Properties.ReadOnly = False
    TabOrder = 16
    Width = 166
  end
  object cxLabel8: TcxLabel
    Left = 11
    Top = 206
    Caption = #1043#1088#1091#1087#1087#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081' ***:'
  end
  object edUnitGroup_by: TcxButtonEdit
    Left = 11
    Top = 224
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 18
    Width = 200
  end
  object cxLabel9: TcxLabel
    Left = 240
    Top = 206
    Caption = #1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072' ***:'
  end
  object edLocation_by: TcxButtonEdit
    Left = 240
    Top = 224
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 20
    Width = 200
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 264
    Top = 8
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 376
    Top = 40
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Left'
          'Top')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 336
    Top = 12
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 41579d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 41608d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupId'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitGroupId'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitGroupName'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'LocationId'
        Value = ''
        Component = GuidesLocation
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'LocationName'
        Value = ''
        Component = GuidesLocation
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountGroupId'
        Value = Null
        Component = GuidesAccountGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountGroupName'
        Value = Null
        Component = GuidesAccountGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isInfoMoney'
        Value = Null
        Component = cbInfoMoney
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitGroupId_by'
        Value = Null
        Component = GuidesUnitGroup_by
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitGroupName_by'
        Value = Null
        Component = GuidesUnitGroup_by
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'LocationId_by'
        Value = Null
        Component = GuidesLocation_by
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'LocationName_by'
        Value = Null
        Component = GuidesLocation_by
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 56
    Top = 216
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TAssetGoodsPlaceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAssetGoodsPlaceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        DataType = ftString
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
      end>
    Left = 352
    Top = 159
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TAssetGroup_GoodsGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAssetGroup_GoodsGroupForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        DataType = ftString
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
      end>
    Left = 144
    Top = 168
  end
  object GuidesLocation: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLocation
    FormNameParam.Value = 'TStoragePlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStoragePlace_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesLocation
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesLocation
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 96
  end
  object GuidesUnitGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitGroup
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 144
    Top = 96
  end
  object GuidesAccountGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceAccountGroup
    FormNameParam.Value = 'TAccountGroup_ObjectDescForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAccountGroup_ObjectDescForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesAccountGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesAccountGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Object_Goods'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 45
  end
  object GuidesUnitGroup_by: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitGroup_by
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitGroup_by
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitGroup_by
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 112
  end
  object GuidesLocation_by: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLocation_by
    FormNameParam.Value = 'TStoragePlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStoragePlace_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesLocation_by
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesLocation_by
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 320
    Top = 216
  end
end
