object ProdColorItemsEditForm: TProdColorItemsEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090#1099' '#1062#1074#1077#1090#1072' ('#1051#1086#1076#1082#1072')>'
  ClientHeight = 329
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actDataSetRefresh
  AddOnFormData.Params = FormParams
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
    Caption = #1069#1083#1077#1084#1077#1085#1090
  end
  object cxButton1: TcxButton
    Left = 41
    Top = 295
    Width = 75
    Height = 25
    Action = actInsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 185
    Top = 295
    Width = 75
    Height = 25
    Action = actFormClose
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
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 10
    Top = 236
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edComment: TcxTextEdit
    Left = 10
    Top = 256
    TabOrder = 7
    Width = 273
  end
  object cxLabel13: TcxLabel
    Left = 10
    Top = 98
    Caption = #1051#1086#1076#1082#1072
  end
  object edProduct: TcxButtonEdit
    Left = 10
    Top = 117
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 10
    Top = 144
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
  end
  object edProdOptions: TcxButtonEdit
    Left = 10
    Top = 163
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 10
    Top = 189
    Caption = #1062#1074#1077#1090
  end
  object edProdColor: TcxButtonEdit
    Left = 10
    Top = 208
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 273
  end
  object ActionList: TActionList
    Left = 152
    Top = 56
    object actDataSetRefresh: TdsdDataSetRefresh
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
    object actInsertUpdateGuides: TdsdInsertUpdateGuides
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
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ProdColorItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCode'
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
        Name = 'inProductId'
        Value = Null
        Component = GuidesProduct
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdOptionsId'
        Value = Null
        Component = GuidesProdColorGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdColorId'
        Value = Null
        Component = GuidesProdColor
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 96
    Top = 48
  end
  object FormParams: TdsdFormParams
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
    StoredProcName = 'gpGet_Object_ProdColorItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCode
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
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProductId'
        Value = Null
        Component = GuidesProduct
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProductName'
        Value = Null
        Component = GuidesProduct
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdColorGroupId'
        Value = Null
        Component = GuidesProdColorGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdColorGroupName'
        Value = Null
        Component = GuidesProdColorGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdColorId'
        Value = Null
        Component = GuidesProdColor
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdColorName'
        Value = Null
        Component = GuidesProdColor
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 184
    Top = 16
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
    Left = 32
    Top = 228
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 256
    Top = 303
  end
  object GuidesProduct: TdsdGuides
    KeyField = 'Id'
    LookupControl = edProduct
    FormNameParam.Value = 'TProdEngineForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProdEngineForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesProduct
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesProduct
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 94
    Top = 116
  end
  object GuidesProdColorGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edProdOptions
    FormNameParam.Value = 'TProdColorGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProdColorGroupForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesProdColorGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesProdColorGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 126
    Top = 154
  end
  object GuidesProdColor: TdsdGuides
    KeyField = 'Id'
    LookupControl = edProdColor
    FormNameParam.Value = 'TProdColorForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProdColorForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesProdColor
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesProdColor
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 118
    Top = 191
  end
end
