object GoodsByGK_VMCDialogForm: TGoodsByGK_VMCDialogForm
  Left = 0
  Top = 0
  Caption = #1042#1099#1073#1086#1088' '#1090#1086#1088#1075#1086#1074#1099#1093' '#1089#1077#1090#1077#1081
  ClientHeight = 361
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isSingle = False
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 37
    Top = 316
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 181
    Top = 316
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxLabel14: TcxLabel
    Left = 19
    Top = 55
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' 2:'
  end
  object edRetail2: TcxButtonEdit
    Left = 19
    Top = 78
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 3
    Width = 267
  end
  object cxLabel11: TcxLabel
    Left = 19
    Top = 113
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' 3:'
  end
  object edRetail3: TcxButtonEdit
    Left = 19
    Top = 133
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 5
    Width = 267
  end
  object cxLabel13: TcxLabel
    Left = 19
    Top = 158
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' 4:'
  end
  object edRetail4: TcxButtonEdit
    Left = 19
    Top = 181
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 267
  end
  object cxLabel15: TcxLabel
    Left = 19
    Top = 208
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' 5:'
  end
  object edRetail5: TcxButtonEdit
    Left = 19
    Top = 228
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 267
  end
  object edRetail1: TcxButtonEdit
    Left = 19
    Top = 30
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = False
    TabOrder = 10
    Width = 267
  end
  object cxLabel9: TcxLabel
    Left = 19
    Top = 255
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' 6:'
  end
  object edRetail6: TcxButtonEdit
    Left = 19
    Top = 272
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 267
  end
  object cxLabel6: TcxLabel
    Left = 19
    Top = 9
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' 1:'
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Retail1Id'
        Value = Null
        Component = GuidesRetail1
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Retail2Id'
        Value = Null
        Component = GuidesRetail2
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Retail3Id'
        Value = Null
        Component = GuidesRetail3
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Retail4Id'
        Value = Null
        Component = GuidesRetail4
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Retail5Id'
        Value = Null
        Component = GuidesRetail5
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Retail6Id'
        Value = Null
        Component = GuidesRetail6
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Retail1Name'
        Value = Null
        Component = GuidesRetail1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Retail2Name'
        Value = Null
        Component = GuidesRetail2
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Retail3Name'
        Value = Null
        Component = GuidesRetail3
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Retail4Name'
        Value = Null
        Component = GuidesRetail4
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Retail5Name'
        Value = Null
        Component = GuidesRetail5
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Retail6Name'
        Value = Null
        Component = GuidesRetail6
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 272
    Top = 40
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
    Left = 60
    Top = 256
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 72
    Top = 72
  end
  object GuidesRetail1: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail1
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail1
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 177
    Top = 19
  end
  object GuidesRetail2: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail2
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail2
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail2
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 168
    Top = 67
  end
  object GuidesRetail3: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail3
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail3
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail3
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 190
    Top = 123
  end
  object GuidesRetail4: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail4
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail4
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail4
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 158
  end
  object GuidesRetail5: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail5
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail5
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail5
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 198
    Top = 197
  end
  object GuidesRetail6: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail6
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail6
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail6
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CarModelName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 144
    Top = 266
  end
end
