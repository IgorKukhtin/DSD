object Report_ProductionUnion_OlapDialogForm: TReport_ProductionUnion_OlapDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1055#1086' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1091' ('#1054#1051#1040#1055')>'
  ClientHeight = 326
  ClientWidth = 460
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
    Top = 258
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 272
    Top = 258
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
  object cxLabel6: TcxLabel
    Left = 11
    Top = 7
    Caption = #1055#1077#1088#1080#1086#1076'1 '#1089' :'
  end
  object cxLabel7: TcxLabel
    Left = 121
    Top = 7
    Caption = #1055#1077#1088#1080#1086#1076'1 '#1087#1086' :'
  end
  object cbGroupMovement: TcxCheckBox
    Left = 241
    Top = 27
    Caption = #1055#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
    Properties.ReadOnly = False
    TabOrder = 6
    Width = 184
  end
  object cxLabel5: TcxLabel
    Left = 11
    Top = 104
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1086#1090' '#1082#1086#1075#1086'):'
  end
  object edFromGroup: TcxButtonEdit
    Left = 11
    Top = 122
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 200
  end
  object cxLabel8: TcxLabel
    Left = 241
    Top = 105
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1082#1086#1084#1091'):'
  end
  object edToGroup: TcxButtonEdit
    Left = 241
    Top = 122
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 200
  end
  object cxLabel4: TcxLabel
    Left = 11
    Top = 154
    Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074'.'#1088#1072#1089#1093'.:'
  end
  object edGoodsGroup: TcxButtonEdit
    Left = 11
    Top = 172
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 12
    Width = 200
  end
  object cxLabel1: TcxLabel
    Left = 241
    Top = 154
    Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074'.'#1087#1088#1080#1093':'
  end
  object edChildGoodsGroup: TcxButtonEdit
    Left = 241
    Top = 172
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 14
    Width = 200
  end
  object cxLabel2: TcxLabel
    Left = 11
    Top = 202
    Caption = #1058#1086#1074#1072#1088' '#1088#1072#1089#1093':'
  end
  object edGoods: TcxButtonEdit
    Left = 11
    Top = 222
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 200
  end
  object edChildGoods: TcxButtonEdit
    Left = 241
    Top = 222
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 200
  end
  object cxLabel3: TcxLabel
    Left = 241
    Top = 202
    Caption = #1058#1086#1074#1072#1088' '#1087#1088#1080#1093':'
  end
  object cxLabel9: TcxLabel
    Left = 11
    Top = 55
    Caption = #1055#1077#1088#1080#1086#1076'2 '#1089' :'
  end
  object deStart2: TcxDateEdit
    Left = 11
    Top = 75
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 20
    Width = 90
  end
  object cxLabel10: TcxLabel
    Left = 121
    Top = 55
    Caption = #1055#1077#1088#1080#1086#1076'2 '#1087#1086' :'
  end
  object deEnd2: TcxDateEdit
    Left = 121
    Top = 75
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 22
    Width = 90
  end
  object cbisPartion: TcxCheckBox
    Left = 241
    Top = 54
    Caption = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
    Properties.ReadOnly = False
    TabOrder = 23
    Width = 184
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 136
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 408
    Top = 243
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
    Left = 208
    Top = 255
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
        Name = 'StartDate2'
        Value = 'NULL'
        Component = deStart2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate2'
        Value = 'NULL'
        Component = deEnd2
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChildGoodsId'
        Value = Null
        Component = ChildGoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChildGoodsName'
        Value = Null
        Component = ChildGoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChildGoodsGroupId'
        Value = Null
        Component = ChildGoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChildGoodsGroupName'
        Value = Null
        Component = ChildGoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromGroupId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromGroupName'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToGroupId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToGroupName'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMovement'
        Value = Null
        Component = cbGroupMovement
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPartion'
        Value = Null
        Component = cbisPartion
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGroupInfoMoney'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 251
  end
  object FromGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFromGroup
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
        Component = FromGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 64
    Top = 107
  end
  object ToGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edToGroup
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
        Component = ToGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 286
    Top = 106
  end
  object GoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 122
    Top = 148
  end
  object ChildGoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edChildGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ChildGoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ChildGoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 147
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 198
  end
  object ChildGoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edChildGoods
    FormNameParam.Value = 'TGoodsFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ChildGoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ChildGoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 206
  end
  object PeriodChoice1: TPeriodChoice
    DateStart = deStart2
    DateEnd = deEnd2
    Left = 144
    Top = 80
  end
end
