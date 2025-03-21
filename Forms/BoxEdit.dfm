object BoxEditForm: TBoxEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1071#1097#1080#1082'>'
  ClientHeight = 340
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 10
    Top = 72
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 10
    Top = 54
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 28
    Top = 300
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 172
    Top = 300
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object cxLabel2: TcxLabel
    Left = 10
    Top = 8
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 10
    Top = 30
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 130
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 104
    Caption = #1054#1073#1098#1077#1084', '#1084'3.'
  end
  object cxLabel4: TcxLabel
    Left = 10
    Top = 150
    Caption = #1042#1077#1089' '#1103#1097#1080#1082#1072
  end
  object ceBoxVolume: TcxCurrencyEdit
    Left = 10
    Top = 124
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 8
    Width = 273
  end
  object ceBoxWeight: TcxCurrencyEdit
    Left = 10
    Top = 167
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 9
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 10
    Top = 196
    Caption = #1042#1099#1089#1086#1090#1072
  end
  object edHeight: TcxCurrencyEdit
    Left = 10
    Top = 215
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 11
    Width = 80
  end
  object cxLabel6: TcxLabel
    Left = 107
    Top = 196
    Caption = #1044#1083#1080#1085#1072
  end
  object edLength: TcxCurrencyEdit
    Left = 107
    Top = 215
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 13
    Width = 80
  end
  object cxLabel7: TcxLabel
    Left = 203
    Top = 196
    Caption = #1064#1080#1088#1080#1085#1072
  end
  object edWidth: TcxCurrencyEdit
    Left = 203
    Top = 215
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 15
    Width = 80
  end
  object edNPP: TcxCurrencyEdit
    Left = 153
    Top = 30
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 16
    Width = 130
  end
  object cxLabel14: TcxLabel
    Left = 153
    Top = 8
    Caption = #8470' '#1087'/'#1087
  end
  object cxLabel8: TcxLabel
    Left = 10
    Top = 242
    Caption = #1058#1086#1074#1072#1088
  end
  object ceGoods: TcxButtonEdit
    Left = 10
    Top = 261
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 273
  end
  object ActionList: TActionList
    Left = 152
    Top = 56
    object dsdDataSetRefresh: TdsdDataSetRefresh
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
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
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
    object dsdFormClose: TdsdFormClose
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Box'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = edCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
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
        Name = 'inBoxVolume'
        Value = Null
        Component = ceBoxVolume
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxWeight'
        Value = Null
        Component = ceBoxWeight
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxHeight'
        Value = Null
        Component = edHeight
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxLength'
        Value = Null
        Component = edLength
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBoxWidth'
        Value = Null
        Component = edWidth
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNPP'
        Value = Null
        Component = edNPP
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 96
    Top = 48
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 8
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Box'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCode
        DataType = ftUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxVolume'
        Value = Null
        Component = ceBoxVolume
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWeight'
        Value = Null
        Component = ceBoxWeight
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxHeight'
        Value = Null
        Component = edHeight
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxLength'
        Value = Null
        Component = edLength
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BoxWidth'
        Value = Null
        Component = edWidth
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'NPP'
        Value = Null
        Component = edNPP
        DataType = ftFloat
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
        Name = 'GoodsName'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 104
    Top = 112
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
    Left = 160
    Top = 104
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 104
    Top = 104
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoods
    FormNameParam.Value = 'TGoods_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoods_ObjectForm'
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
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 139
    Top = 247
  end
end
