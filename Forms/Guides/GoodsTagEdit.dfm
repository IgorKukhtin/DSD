object GoodsTagEditForm: TGoodsTagEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072'>'
  ClientHeight = 237
  ClientWidth = 299
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
    Left = 8
    Top = 70
    TabOrder = 0
    Width = 273
  end
  object cxLabel1: TcxLabel
    Left = 8
    Top = 52
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 35
    Top = 204
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 179
    Top = 204
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 10
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 8
    Top = 30
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 273
  end
  object cxLabel11: TcxLabel
    Left = 8
    Top = 97
    Caption = #1043#1088#1091#1087#1087#1072' '#1072#1085#1072#1083#1080#1090#1080#1082#1080
  end
  object ceGoodsGroupAnalyst: TcxButtonEdit
    Left = 8
    Top = 116
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 273
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 145
    Hint = #1062#1074#1077#1090' '#1090#1077#1082#1089#1090#1072' '#1074' '#1086#1090#1095#1077#1090' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077
    Caption = #1062#1074#1077#1090' '#1090#1077#1082#1089#1090#1072' '#1074' '#1086#1090#1095#1077#1090#1077
  end
  object edColorReport: TcxButtonEdit
    Left = 8
    Top = 164
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 130
  end
  object cxLabel4: TcxLabel
    Left = 151
    Top = 145
    Hint = #1062#1074#1077#1090' '#1092#1086#1085#1072' '#1074' '#1086#1090#1095#1077#1090#1077
    Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072' '#1074' '#1086#1090#1095#1077#1090#1077
  end
  object edColorBgReport: TcxButtonEdit
    Left = 151
    Top = 164
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 130
  end
  object ActionList: TActionList
    Left = 240
    Top = 48
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
    StoredProcName = 'gpInsertUpdate_Object_GoodsTag'
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
        Name = 'inGoodsGroupAnalystId'
        Value = Null
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'GoodsGroupAnalystId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inColorReport'
        Value = 0.000000000000000000
        Component = ColorReportGuides
        ComponentItem = 'Key'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inColorBgReport'
        Value = Null
        Component = ColorBgReportGuides
        ComponentItem = 'Key'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 250
    Top = 178
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
    StoredProcName = 'gpGet_Object_GoodsTag'
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
        Name = 'GoodsGroupAnalystId'
        Value = Null
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupAnalystName'
        Value = Null
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ColorReportId'
        Value = 0
        Component = ColorReportGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'text1'
        Value = Null
        Component = ColorReportGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ColorBgReportId'
        Value = Null
        Component = ColorBgReportGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'text2'
        Value = 0
        Component = ColorBgReportGuides
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
    Left = 138
    Top = 192
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 96
    Top = 56
  end
  object GoodsGroupAnalystGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsGroupAnalyst
    FormNameParam.Value = 'TGoodsGroupAnalystForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroupAnalystForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupAnalystGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 120
    Top = 104
  end
  object ColorReportGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edColorReport
    Key = '0'
    FormNameParam.Value = 'TColorForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TColorForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = 0
        Component = ColorReportGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ColorReportGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 56
    Top = 160
  end
  object ColorBgReportGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edColorBgReport
    Key = '0'
    FormNameParam.Value = 'TColorForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TColorForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ColorBgReportGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ColorBgReportGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 160
  end
end
