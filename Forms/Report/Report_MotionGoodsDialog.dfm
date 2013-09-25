inherited Report_MotionGoodsDialogForm: TReport_MotionGoodsDialogForm
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' "'#1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1086#1074'"'
  ClientHeight = 206
  ClientWidth = 313
  ExplicitWidth = 319
  ExplicitHeight = 234
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 32
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 200
    Top = 160
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 176
    Top = 24
    EditValue = 41395d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 121
  end
  object deStart: TcxDateEdit
    Left = 16
    Top = 24
    EditValue = 41395d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 121
  end
  object edGoods: TcxButtonEdit
    Left = 176
    Top = 117
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 4
    Width = 121
  end
  object edGoodsGroup: TcxButtonEdit
    Left = 176
    Top = 67
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 5
    Width = 121
  end
  object edLocation: TcxButtonEdit
    Left = 16
    Top = 117
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 6
    Width = 137
  end
  object edUnitGroup: TcxButtonEdit
    Left = 16
    Top = 67
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 137
  end
  object cxLabel3: TcxLabel
    Left = 16
    Top = 44
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
  end
  object cxLabel4: TcxLabel
    Left = 16
    Top = 94
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
  end
  object cxLabel1: TcxLabel
    Left = 177
    Top = 44
    Caption = #1043#1088'.'#1090#1086#1074#1072#1088#1072
  end
  object cxLabel2: TcxLabel
    Left = 177
    Top = 94
    Caption = #1058#1086#1074#1072#1088
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 144
    Top = 8
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 200
    Top = 144
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
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
        Component = Owner
        Properties.Strings = (
          'Left'
          'Top')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 296
    Top = 144
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        Value = 41395d
      end
      item
        Name = 'EndDate'
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        Value = 41395d
      end
      item
        Name = 'GoodsId'
        Component = GoodsGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'GoodsName'
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'GoodsGroupId'
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'GoodsGroupName'
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'UnitGroupId'
        Component = UnitGroupGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'UnitGroupName'
        Component = UnitGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'LocationId'
        Component = LocationGuides
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'LocationName'
        Component = LocationGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptOutput
        Value = ''
      end>
    Left = 32
    Top = 112
  end
  object GoodsGuides: TdsdGuides
    LookupControl = edGoods
    FormName = 'TGoodsForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = GoodsGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'TextValue'
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 280
    Top = 91
  end
  object GoodsGroupGuides: TdsdGuides
    LookupControl = edGoodsGroup
    FormName = 'TGoodsGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'TextValue'
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 240
    Top = 48
  end
  object LocationGuides: TdsdGuides
    LookupControl = edLocation
    FormName = 'TPersonalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Component = LocationGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'TextValue'
        Component = LocationGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 104
    Top = 120
  end
  object UnitGroupGuides: TdsdGuides
    LookupControl = edUnitGroup
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'GridDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Component = UnitGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end
      item
        Name = 'TextValue'
        Component = UnitGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
    Left = 88
    Top = 64
  end
end
