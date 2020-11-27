object Report_SaleExternalDialogForm: TReport_SaleExternalDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1042#1085#1077#1096#1085#1080#1077' '#1055#1088#1086#1076#1072#1078#1080'>'
  ClientHeight = 198
  ClientWidth = 336
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
    Left = 62
    Top = 154
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 203
    Top = 154
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 216
    Top = 21
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 85
  end
  object deStart: TcxDateEdit
    Left = 66
    Top = 21
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 90
  end
  object cxLabel6: TcxLabel
    Left = 18
    Top = 22
    Caption = #1044#1072#1090#1072' '#1089' :'
  end
  object cxLabel7: TcxLabel
    Left = 164
    Top = 22
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxLabel13: TcxLabel
    Left = 11
    Top = 68
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
  end
  object edRetail: TcxButtonEdit
    Left = 89
    Top = 67
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 224
  end
  object cxLabel1: TcxLabel
    Left = 3
    Top = 109
    Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074
  end
  object edGoodsGroup: TcxButtonEdit
    Left = 89
    Top = 108
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 224
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 256
    Top = 28
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 152
    Top = 4
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
    Left = 16
    Top = 8
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
        Name = 'RetailId'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailName'
        Value = ''
        Component = GuidesRetail
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
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = Null
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 245
    Top = 120
  end
  object GuidesRetail: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 56
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroupForm'
    PositionDataSet = 'ClientDataSet'
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
    Left = 160
    Top = 119
  end
end
