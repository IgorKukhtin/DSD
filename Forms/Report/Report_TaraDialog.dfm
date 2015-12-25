inherited Report_TaraDialogForm: TReport_TaraDialogForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1072#1088#1077' ('#1082#1086#1083'-'#1074#1086')'
  ClientHeight = 193
  ClientWidth = 446
  ExplicitWidth = 452
  ExplicitHeight = 218
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 105
    Top = 160
    ExplicitLeft = 105
    ExplicitTop = 160
  end
  inherited bbCancel: TcxButton
    Left = 250
    Top = 160
    ExplicitLeft = 250
    ExplicitTop = 160
  end
  object cxLabel1: TcxLabel [2]
    Left = 26
    Top = 9
    Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object deStart: TcxDateEdit [3]
    Left = 142
    Top = 8
    EditValue = 41395d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 85
  end
  object cxLabel2: TcxLabel [4]
    Left = 239
    Top = 9
    Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object deEnd: TcxDateEdit [5]
    Left = 355
    Top = 8
    EditValue = 41395d
    Properties.ShowTime = False
    TabOrder = 5
    Width = 85
  end
  object chkWithSupplier: TcxCheckBox [6]
    Left = 5
    Top = 35
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082#1080
    TabOrder = 6
    Width = 97
  end
  object chbWithBayer: TcxCheckBox [7]
    Left = 108
    Top = 35
    Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1080
    TabOrder = 7
    Width = 90
  end
  object chbWithPlace: TcxCheckBox [8]
    Left = 204
    Top = 35
    Caption = #1057#1082#1083#1072#1076#1099
    TabOrder = 8
    Width = 75
  end
  object chbWithBranch: TcxCheckBox [9]
    Left = 274
    Top = 35
    Caption = #1060#1080#1083#1080#1072#1083#1099
    TabOrder = 9
    Width = 84
  end
  object cxLabel3: TcxLabel [10]
    Left = 8
    Top = 62
    Caption = #1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072':'
  end
  object edObject: TcxButtonEdit [11]
    Left = 105
    Top = 62
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 333
  end
  object cxLabel4: TcxLabel [12]
    Left = 8
    Top = 87
    Caption = #1058#1086#1074#1072#1088' / '#1043#1088#1091#1087#1087#1072':'
  end
  object edGoods: TcxButtonEdit [13]
    Left = 105
    Top = 86
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 333
  end
  object chkWithMember: TcxCheckBox [14]
    Left = 364
    Top = 35
    Caption = #1052#1054#1051
    TabOrder = 14
    Width = 53
  end
  object cxLabel5: TcxLabel [15]
    Left = 8
    Top = 112
    Caption = #1057#1095#1077#1090' '#1075#1088#1091#1087#1087#1072':'
  end
  object ceAccountGroup: TcxButtonEdit [16]
    Left = 105
    Top = 111
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 333
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 64
    Top = 120
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = AccountGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = chbWithBayer
        Properties.Strings = (
          'Checked')
      end
      item
        Component = chbWithBranch
        Properties.Strings = (
          'Checked')
      end
      item
        Component = chbWithPlace
        Properties.Strings = (
          'Checked')
      end
      item
        Component = chkWithMember
        Properties.Strings = (
          'Checked')
      end
      item
        Component = chkWithSupplier
        Properties.Strings = (
          'Checked')
      end
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = GoodsGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = ObjectGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
    Left = 37
    Top = 120
  end
  inherited ActionList: TActionList
    Left = 92
    Top = 119
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 'NULL'
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'EndDate'
        Value = 'NULL'
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'ObjectId'
        Value = Null
        Component = ObjectGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'ObjectName'
        Value = Null
        Component = ObjectGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'GoodsId'
        Value = Null
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'GoodsName'
        Value = Null
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'WithSupplier'
        Value = Null
        Component = chkWithSupplier
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'WithBayer'
        Value = Null
        Component = chbWithBayer
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'WithPlace'
        Value = Null
        Component = chbWithPlace
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'WithBranch'
        Value = Null
        Component = chbWithBranch
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'WithMember'
        Value = Null
        Component = chkWithMember
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'AccountGroupId'
        Value = Null
        Component = AccountGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'AccountGroupName'
        Value = Null
        Component = AccountGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 5
    Top = 128
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 184
    Top = 120
  end
  object ObjectGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edObject
    FormNameParam.Value = 'TPartnerAndUnitForm'
    FormNameParam.DataType = ftString
    FormName = 'TPartnerAndUnitForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ObjectGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ObjectGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 232
    Top = 96
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsTree_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsTree_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 328
    Top = 96
  end
  object AccountGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceAccountGroup
    FormNameParam.Value = 'TAccountGroup_ObjectDescForm'
    FormNameParam.DataType = ftString
    FormName = 'TAccountGroup_ObjectDescForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = AccountGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = AccountGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Object_Goods'
        DataType = ftString
      end>
    Left = 384
    Top = 117
  end
end
