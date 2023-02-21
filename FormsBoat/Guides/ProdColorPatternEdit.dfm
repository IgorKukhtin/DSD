object ProdColorPatternEditForm: TProdColorPatternEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1064#1072#1073#1083#1086#1085' '#1076#1083#1103' '#1084#1086#1076#1077#1083#1080'>'
  ClientHeight = 381
  ClientWidth = 829
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
    Left = 164
    Top = 128
    TabOrder = 0
    Width = 120
  end
  object cxLabel1: TcxLabel
    Left = 164
    Top = 108
    Caption = #1069#1083#1077#1084#1077#1085#1090
  end
  object cxButton1: TcxButton
    Left = 33
    Top = 332
    Width = 75
    Height = 25
    Action = actInsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 177
    Top = 331
    Width = 75
    Height = 25
    Action = actFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object cxLabel2: TcxLabel
    Left = 11
    Top = 108
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 11
    Top = 128
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = False
    TabOrder = 5
    Width = 120
  end
  object cxLabel3: TcxLabel
    Left = 11
    Top = 264
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edComment: TcxTextEdit
    Left = 11
    Top = 284
    TabOrder = 7
    Width = 273
  end
  object cxLabel4: TcxLabel
    Left = 11
    Top = 58
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
  end
  object edProdOptions: TcxButtonEdit
    Left = 11
    Top = 78
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 273
  end
  object cxLabel5: TcxLabel
    Left = 11
    Top = 158
    Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
  end
  object edGoods: TcxButtonEdit
    Left = 11
    Top = 178
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 273
  end
  object edColorPattern: TcxButtonEdit
    Left = 11
    Top = 26
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 273
  end
  object cxLabel6: TcxLabel
    Left = 11
    Top = 5
    Caption = #1053#1072#1079#1074#1072#1085#1080#1103' '#1096#1072#1073#1083#1086#1085#1072
  end
  object cxLabel7: TcxLabel
    Left = 11
    Top = 208
    Caption = 'Options'
  end
  object cxButtonEdit1: TcxButtonEdit
    Left = 11
    Top = 228
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 273
  end
  object Panel: TPanel
    Left = 310
    Top = 0
    Width = 519
    Height = 381
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 16
    object cxDBVerticalGrid: TcxDBVerticalGrid
      Left = 0
      Top = 26
      Width = 519
      Height = 173
      Align = alClient
      Images = dmMain.ImageList
      LayoutStyle = lsMultiRecordView
      OptionsView.RowHeaderWidth = 109
      OptionsView.RowHeight = 60
      OptionsView.ValueWidth = 104
      OptionsData.Editing = False
      OptionsData.Appending = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      Navigator.Buttons.CustomButtons = <>
      Styles.Header = dmMain.cxHeaderStyle
      TabOrder = 0
      DataController.DataSource = PhotoDS
      Version = 1
      object colFileName: TcxDBEditorRow
        Options.CanAutoHeight = False
        Height = 142
        Properties.Caption = #1060#1086#1090#1086
        Properties.HeaderAlignmentHorz = taCenter
        Properties.HeaderAlignmentVert = vaCenter
        Properties.ImageIndex = 28
        Properties.EditPropertiesClassName = 'TcxLabelProperties'
        Properties.EditProperties.Alignment.Horz = taCenter
        Properties.EditProperties.Alignment.Vert = taVCenter
        Properties.EditProperties.WordWrap = True
        Properties.DataBinding.FieldName = 'FileName'
        Properties.Options.Editing = False
        ID = 0
        ParentID = -1
        Index = 0
        Version = 1
      end
    end
    object dxBarDockControl3: TdxBarDockControl
      Left = 0
      Top = 0
      Width = 519
      Height = 26
      Align = dalTop
      BarManager = BarManager
    end
    object PanelPhoto: TPanel
      Left = 0
      Top = 199
      Width = 519
      Height = 182
      Align = alBottom
      Caption = 'PanelPhoto'
      ShowCaption = False
      TabOrder = 2
      object Image3: TcxImage
        Left = 341
        Top = 1
        Align = alLeft
        Properties.ReadOnly = True
        TabOrder = 0
        Height = 180
        Width = 170
      end
      object Image2: TcxImage
        Left = 171
        Top = 1
        Align = alLeft
        Properties.ReadOnly = True
        TabOrder = 1
        Height = 180
        Width = 170
      end
      object Image1: TcxImage
        Left = 1
        Top = 1
        Align = alLeft
        Properties.ReadOnly = True
        TabOrder = 2
        Height = 180
        Width = 170
      end
      object cxGrid1: TcxGrid
        Left = 224
        Top = 86
        Width = 317
        Height = 107
        TabOrder = 3
        Visible = False
        object cxGrid1DBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DataSource
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          object cxGrid1DBTableView1Column1: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            Width = 60
          end
        end
        object cxGrid1Level1: TcxGridLevel
          GridView = cxGrid1DBTableView1
        end
      end
    end
  end
  object ActionList: TActionList
    Left = 136
    Top = 43
    object actDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spPhotoSelect
        end
        item
          StoredProc = spGetPhoto_panel
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
    StoredProcName = 'gpInsertUpdate_Object_ProdColorPattern'
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
        Name = 'inColorPatternId'
        Value = Null
        Component = GuidesColorPattern
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdColorGroupId'
        Value = Null
        Component = GuidesProdColorGroup
        ComponentItem = 'Key'
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
        Name = 'inProdOptionsId'
        Value = Null
        Component = GuidesProdOptions
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
      end
      item
        Name = 'ioProdColorName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 96
    Top = 91
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ColorPatternId'
        Value = Null
        Component = GuidesColorPattern
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ColorPatternName'
        Value = Null
        Component = GuidesColorPattern
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 43
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_ProdColorPattern'
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
        Name = 'inColorPatternId'
        Value = Null
        Component = GuidesColorPattern
        ComponentItem = 'Key'
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
        Name = 'Comment'
        Value = Null
        Component = edComment
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
      end
      item
        Name = 'ColorPatternId'
        Value = Null
        Component = GuidesColorPattern
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ColorPatternName'
        Value = Null
        Component = GuidesColorPattern
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdOptionsId'
        Value = Null
        Component = GuidesProdOptions
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdOptionsName'
        Value = Null
        Component = GuidesProdOptions
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 80
    Top = 171
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
    Left = 224
    Top = 43
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 128
    Top = 331
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
    Left = 206
    Top = 107
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsForm'
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
    Left = 214
    Top = 155
  end
  object GuidesColorPattern: TdsdGuides
    KeyField = 'Id'
    LookupControl = edColorPattern
    FormNameParam.Value = 'TColorPatternForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TColorPatternForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesColorPattern
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesColorPattern
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 174
    Top = 7
  end
  object GuidesProdOptions: TdsdGuides
    KeyField = 'Id'
    LookupControl = cxButtonEdit1
    FormNameParam.Value = 'TProdOptionsForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProdOptionsForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesProdOptions
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesProdOptions
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 174
    Top = 221
  end
  object PhotoCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 528
    Top = 160
  end
  object PhotoDS: TDataSource
    DataSet = PhotoCDS
    Left = 536
    Top = 96
  end
  object Photo: TDocument
    GetBlobProcedure = spGetPhoto
    Left = 752
    Top = 144
  end
  object spGetPhoto: TdsdStoredProc
    StoredProcName = 'gpGet_Object_ProdColorPatternPhoto'
    DataSets = <>
    OutputType = otBlob
    Params = <
      item
        Name = 'inProdColorPatternPhotoId'
        Value = Null
        Component = PhotoCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 784
    Top = 72
  end
  object spDeletePhoto: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_ProdColorPatternPhoto'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = PhotoCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 696
    Top = 160
  end
  object spPhotoSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ProdColorPatternPhoto'
    DataSet = PhotoCDS
    DataSets = <
      item
        DataSet = PhotoCDS
      end>
    Params = <
      item
        Name = 'inProdColorPatternId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 616
    Top = 200
  end
  object spInsertPhoto: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ProdColorPatternPhoto'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioid'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhotoname'
        Value = ''
        Component = Photo
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdColorPatternId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdColorPatternPhotodata'
        Value = '789C535018D10000F1E01FE1'
        Component = Photo
        ComponentItem = 'Data'
        DataType = ftBlob
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 600
    Top = 72
  end
  object ActionList1: TActionList
    Left = 453
    Top = 101
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spPhotoSelect
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object FormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'FormClose'
    end
    object InsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = #1054#1082
    end
    object actInsertPhoto: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertPhoto
      StoredProcList = <
        item
          StoredProc = spInsertPhoto
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1060#1086#1090#1086
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1060#1086#1090#1086
      ImageIndex = 0
    end
    object PhotoRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPhotoSelect
      StoredProcList = <
        item
          StoredProc = spPhotoSelect
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1060#1086#1090#1086
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1060#1086#1090#1086
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object DocumentRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1044#1086#1082#1091#1084#1077#1085#1090#1086#1074
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1044#1086#1082#1091#1084#1077#1085#1090#1086#1074
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object PhotoOpenAction: TDocumentOpenAction
      Category = 'DSDLib'
      MoveParams = <>
      Document = Photo
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1060#1086#1090#1086
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1060#1086#1090#1086
      ImageIndex = 60
    end
    object DocumentOpenAction: TDocumentOpenAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1080
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1080
      ImageIndex = 60
    end
    object MultiActionInsertPhoto: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spInserUpdateProdColorPattern
        end
        item
          Action = actInsertPhoto
        end
        item
          Action = PhotoRefresh
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1060#1086#1090#1086
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1060#1086#1090#1086
      ImageIndex = 0
    end
    object actDeletePhoto: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDeletePhoto
      StoredProcList = <
        item
          StoredProc = spDeletePhoto
        end
        item
          StoredProc = spPhotoSelect
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1060#1086#1090#1086
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1060#1086#1090#1086
      ImageIndex = 2
      QuestionBeforeExecute = #1042#1099' '#1076#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1093#1086#1090#1080#1090#1077' '#1091#1076#1072#1083#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
    end
    object spInserUpdateProdColorPattern: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'spInserUpdateProdColorPattern'
    end
  end
  object BarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 624
    Top = 139
    DockControlHeights = (
      0
      0
      0
      0)
    object BarManagerBar1: TdxBar
      Caption = #1059#1089#1083#1086#1074#1080#1103' '#1088#1072#1073#1086#1090#1099
      CaptionButtons = <>
      DockControl = dxBarDockControl3
      DockedDockControl = dxBarDockControl3
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 849
      FloatTop = 373
      FloatClientWidth = 51
      FloatClientHeight = 66
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertCondition'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedContractCondition'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPhotoOpenAction'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPhotoRefresh'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbAddDocument: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
      Visible = ivAlways
      ImageIndex = 0
    end
    object bbRefreshDoc: TdxBarButton
      Action = DocumentRefresh
      Category = 0
    end
    object bbStatic: TdxBarStatic
      Caption = '   '
      Category = 0
      Enabled = False
      Hint = '   '
      Visible = ivAlways
    end
    object bbOpenDocument: TdxBarButton
      Action = DocumentOpenAction
      Category = 0
    end
    object bbInsertCondition: TdxBarButton
      Action = MultiActionInsertPhoto
      Category = 0
    end
    object bbPhotoRefresh: TdxBarButton
      Action = PhotoRefresh
      Category = 0
    end
    object bbSetErasedContractCondition: TdxBarButton
      Action = actDeletePhoto
      Category = 0
    end
    object bbPhotoOpenAction: TdxBarButton
      Action = PhotoOpenAction
      Category = 0
    end
    object bbDeleteDocument: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
      Visible = ivAlways
      ImageIndex = 2
    end
  end
  object spGetPhoto_panel: TdsdStoredProc
    StoredProcName = 'gpGet_Object_ProdColorPattern_photo'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inProdColorPatternId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 720
    Top = 232
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 728
    Top = 80
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 672
    Top = 80
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGrid1DBTableView1
    OnDblClickActionList = <
      item
      end
      item
      end>
    ActionItemList = <
      item
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <
      item
        FieldName = 'Image1'
        Image = Image1
      end
      item
        FieldName = 'Image2'
        Image = Image2
      end
      item
        FieldName = 'Image3'
        Image = Image3
      end>
    PropertiesCellList = <>
    Left = 744
    Top = 304
  end
end
