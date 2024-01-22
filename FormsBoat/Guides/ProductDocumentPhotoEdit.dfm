object ProductDocumentPhotoEditForm: TProductDocumentPhotoEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <Boat - Document / Photo>'
  ClientHeight = 651
  ClientWidth = 972
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
    Left = 12
    Top = 180
    Properties.ReadOnly = True
    TabOrder = 0
    Width = 182
  end
  object cxLabel1: TcxLabel
    Left = 12
    Top = 160
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 10
    Top = 615
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 121
    Top = 615
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 12
    Top = 6
    Caption = 'Interne Nr'
  end
  object ceCode: TcxCurrencyEdit
    Left = 12
    Top = 24
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 182
  end
  object cxLabel18: TcxLabel
    Left = 12
    Top = 58
    Caption = 'CIN Nr.'
  end
  object edCIN: TcxTextEdit
    Left = 12
    Top = 76
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 182
  end
  object cxLabel19: TcxLabel
    Left = 12
    Top = 103
    Caption = 'Model'
  end
  object edModel: TcxButtonEdit
    Left = 12
    Top = 122
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 182
  end
  object PanelMain: TPanel
    Left = 216
    Top = 0
    Width = 756
    Height = 651
    Align = alRight
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'PanelMain'
    ShowCaption = False
    TabOrder = 10
    object Panel: TPanel
      Left = 1
      Top = 1
      Width = 232
      Height = 649
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object dxBarDockControl1: TdxBarDockControl
        Left = 0
        Top = 0
        Width = 232
        Height = 26
        Align = dalTop
        BarManager = BarManager
      end
      object dxBarDockControl3: TdxBarDockControl
        Left = 0
        Top = 301
        Width = 232
        Height = 26
        Align = dalTop
        BarManager = BarManager
      end
      object Panel1: TPanel
        Left = 0
        Top = 26
        Width = 232
        Height = 275
        Align = alTop
        Caption = 'Panel1'
        TabOrder = 2
        object cxGrid2: TcxGrid
          Left = 1
          Top = 19
          Width = 226
          Height = 255
          Align = alClient
          TabOrder = 0
          object cxGrid2DBBandedTableView1: TcxGridDBBandedTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = DocumentDS
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Inserting = False
            OptionsView.ColumnAutoWidth = True
            OptionsView.GroupByBox = False
            OptionsView.Header = False
            OptionsView.BandHeaders = False
            Bands = <
              item
              end>
            object DocFileName: TcxGridDBBandedColumn
              Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
              DataBinding.FieldName = 'FileName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 70
              Position.BandIndex = 0
              Position.ColIndex = 0
              Position.RowIndex = 0
            end
            object DocDocTagName: TcxGridDBBandedColumn
              Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1080
              DataBinding.FieldName = 'DocTagName'
              PropertiesClassName = 'TcxButtonEditProperties'
              Properties.Buttons = <
                item
                  Action = OpenChoiceFormDocTag
                  Default = True
                  Kind = bkEllipsis
                end>
              Properties.ReadOnly = True
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 70
              Position.BandIndex = 0
              Position.ColIndex = 0
              Position.RowIndex = 1
            end
            object DocComment: TcxGridDBBandedColumn
              Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
              DataBinding.FieldName = 'Comment'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 70
              Position.BandIndex = 0
              Position.ColIndex = 1
              Position.RowIndex = 1
            end
          end
          object cxGridLevel1: TcxGridLevel
            GridView = cxGrid2DBBandedTableView1
          end
        end
        object cxRightSplitter: TcxSplitter
          Left = 227
          Top = 19
          Width = 4
          Height = 255
          AlignSplitter = salRight
          Control = cxGrid2
        end
        object cxLabel2: TcxLabel
          Left = 1
          Top = 1
          Align = alTop
          Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
          ParentFont = False
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -12
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = [fsBold]
          Style.IsFontAssigned = True
          Properties.Alignment.Horz = taCenter
          AnchorX = 116
        end
      end
      object PanelPhotoList: TPanel
        Left = 0
        Top = 327
        Width = 232
        Height = 322
        Align = alClient
        Caption = 'PanelPhotoList'
        ShowCaption = False
        TabOrder = 3
        object cxGrid3: TcxGrid
          Left = 1
          Top = 19
          Width = 230
          Height = 302
          Align = alClient
          TabOrder = 0
          object cxGridDBBandedTableView1: TcxGridDBBandedTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = PhotoDS
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsData.CancelOnExit = False
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Editing = False
            OptionsData.Inserting = False
            OptionsView.ColumnAutoWidth = True
            OptionsView.GroupByBox = False
            OptionsView.Header = False
            OptionsView.BandHeaders = False
            Bands = <
              item
              end>
            object PhFileName: TcxGridDBBandedColumn
              Caption = #1060#1072#1081#1083
              DataBinding.FieldName = 'FileName'
              Options.Editing = False
              Position.BandIndex = 0
              Position.ColIndex = 0
              Position.RowIndex = 0
            end
          end
          object cxGridLevel2: TcxGridLevel
            GridView = cxGridDBBandedTableView1
          end
        end
        object cxLabel3: TcxLabel
          Left = 1
          Top = 1
          Align = alTop
          Caption = #1060#1086#1090#1086
          ParentFont = False
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -12
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = [fsBold]
          Style.IsFontAssigned = True
          Properties.Alignment.Horz = taCenter
          AnchorX = 116
        end
      end
    end
    object PanelView: TPanel
      Left = 233
      Top = 1
      Width = 522
      Height = 649
      Align = alClient
      Caption = 'PanelView'
      ShowCaption = False
      TabOrder = 1
      object PanelDocView: TPanel
        Left = 1
        Top = 1
        Width = 520
        Height = 489
        Align = alClient
        Caption = 'PanelDocView'
        ShowCaption = False
        TabOrder = 0
      end
      object PanelPhoto: TPanel
        Left = 1
        Top = 490
        Width = 520
        Height = 158
        Align = alBottom
        Caption = 'PanelPhoto'
        ShowCaption = False
        TabOrder = 1
        object Image3: TcxImage
          Left = 341
          Top = 1
          Align = alLeft
          Properties.ReadOnly = True
          TabOrder = 0
          Height = 156
          Width = 170
        end
        object Image2: TcxImage
          Left = 171
          Top = 1
          Align = alLeft
          Properties.ReadOnly = True
          TabOrder = 1
          Height = 156
          Width = 170
        end
        object Image1: TcxImage
          Left = 1
          Top = 1
          Align = alLeft
          Properties.ReadOnly = True
          TabOrder = 2
          Height = 156
          Width = 170
        end
        object cxGrid1: TcxGrid
          Left = 85
          Top = 54
          Width = 330
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
  end
  object cxButton3: TcxButton
    Left = 10
    Top = 575
    Width = 186
    Height = 25
    Action = actSetVisiblePanelPhoto
    ModalResult = 8
    TabOrder = 15
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 104
    Top = 432
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spDocumentSelect
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
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <>
      Caption = #1054#1082
    end
    object dsdUpdateDataSetDoc: TdsdUpdateDataSet
      Category = 'Doc'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_ProductDocument
      StoredProcList = <
        item
          StoredProc = spUpdate_ProductDocument
        end>
      Caption = 'actUpdateDataSetDoc'
      DataSource = DocumentDS
    end
    object OpenChoiceFormDocTag: TOpenChoiceForm
      Category = 'Doc'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'DocTagForm'
      FormName = 'TDocTagForm'
      FormNameParam.Value = 'TDocTagForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DocumentCDS
          ComponentItem = 'DocTagId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = DocumentCDS
          ComponentItem = 'DocTagName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object InsertRecordDoc: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Action = OpenChoiceFormDocTag
      Params = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'/'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'/'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
  end
  object spInsertUpdate: TdsdStoredProc
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
        Component = ceCode
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
        Name = 'inArticle'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inArticleVergl'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEAN'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inASIN'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMatchCode'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFeeNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisArc'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountMin'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountRefer'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEKPrice'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmpfPrice'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMeasureId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsTagId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsTypeId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsSizeId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdColorId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountParnerId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxKindId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEngineId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 72
    Top = 288
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 16
    Top = 432
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Product'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_OrderClient'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'inMovementId_OrderClient'
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
        Component = ceCode
        DataType = ftUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'CIN'
        Value = Null
        Component = edCIN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelId'
        Value = Null
        Component = GuidesModel
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ModelName'
        Value = Null
        Component = GuidesModel
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 16
    Top = 280
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
      end
      item
        Component = actSetVisiblePanelPhoto
        Properties.Strings = (
          'Value')
      end
      item
        Component = dsdDBViewAddOnDoc
        Properties.Strings = (
          'ViewDocumentParam')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 17
    Top = 219
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 80
    Top = 224
  end
  object spInsertDocument: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ProductDocument'
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
        Name = 'indocumentname'
        Value = ''
        Component = Document
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProductId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProductDocumentData'
        Value = '789C535018D10000F1E01FE1'
        Component = Document
        ComponentItem = 'Data'
        DataType = ftBlob
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 384
    Top = 64
  end
  object spDocumentSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ProductDocument'
    DataSet = DocumentCDS
    DataSets = <
      item
        DataSet = DocumentCDS
      end>
    Params = <
      item
        Name = 'inProductId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 408
    Top = 136
  end
  object DocumentDS: TDataSource
    DataSet = DocumentCDS
    Left = 288
    Top = 200
  end
  object DocumentCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 296
    Top = 128
  end
  object spDeleteDocument: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_ProductDocument'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = DocumentCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 584
    Top = 40
  end
  object spGetDocument: TdsdStoredProc
    StoredProcName = 'gpGet_Object_ProductDocument'
    DataSets = <>
    OutputType = otBlob
    Params = <
      item
        Name = 'inProductDocumentid'
        Value = Null
        Component = DocumentCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 40
  end
  object Document: TDocument
    GetBlobProcedure = spGetDocument
    Left = 288
    Top = 56
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 99
    Top = 364
  end
  object PhotoCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 264
    Top = 432
  end
  object PhotoDS: TDataSource
    DataSet = PhotoCDS
    Left = 264
    Top = 376
  end
  object Photo: TDocument
    GetBlobProcedure = spGetPhoto
    Left = 408
    Top = 376
  end
  object spGetPhoto: TdsdStoredProc
    StoredProcName = 'gpGet_Object_ProductPhoto'
    DataSets = <>
    OutputType = otBlob
    Params = <
      item
        Name = 'inProductPhotoid'
        Value = Null
        Component = PhotoCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 408
    Top = 440
  end
  object spDeletePhoto: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_ProductPhoto'
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
    Left = 344
    Top = 520
  end
  object spPhotoSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ProductPhoto'
    DataSet = PhotoCDS
    DataSets = <
      item
        DataSet = PhotoCDS
      end>
    Params = <
      item
        Name = 'inProductId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 376
  end
  object spInsertPhoto: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ProductPhoto'
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
        Name = 'inProductId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProductPhotoData'
        Value = '789C535018D10000F1E01FE1'
        Component = Photo
        ComponentItem = 'Data'
        DataType = ftBlob
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 256
    Top = 512
  end
  object ActionList1: TActionList
    Images = dmMain.ImageList
    Left = 21
    Top = 365
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
          StoredProc = spDocumentSelect
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
    object actInsertDocument: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertDocument
      StoredProcList = <
        item
          StoredProc = spInsertDocument
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 0
    end
    object PhotoRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPhotoSelect
      StoredProcList = <
        item
          StoredProc = spPhotoSelect
        end
        item
          StoredProc = spGetPhoto_panel
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
      StoredProc = spDocumentSelect
      StoredProcList = <
        item
          StoredProc = spDocumentSelect
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
    object PhotoSaveAction: TDocumentSaveAction
      Category = 'DSDLib'
      MoveParams = <>
      Document = Photo
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1060#1086#1090#1086
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1060#1086#1090#1086
      ImageIndex = 8
    end
    object DocumentOpenAction: TDocumentOpenAction
      Category = 'DSDLib'
      MoveParams = <>
      Document = Document
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 60
    end
    object DocumentSaveAction: TDocumentSaveAction
      Category = 'DSDLib'
      MoveParams = <>
      Document = Document
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 8
    end
    object MultiActionInsertPhoto: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
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
    object MultiActionInsertDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertDocument
        end
        item
          Action = DocumentRefresh
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090
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
        end
        item
          StoredProc = spGetPhoto_panel
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1060#1086#1090#1086
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1060#1086#1090#1086
      ImageIndex = 2
      QuestionBeforeExecute = #1042#1099' '#1076#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1093#1086#1090#1080#1090#1077' '#1091#1076#1072#1083#1080#1090#1100' '#1060#1086#1090#1086'?'
    end
    object actDeleteDocument: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDeleteDocument
      StoredProcList = <
        item
          StoredProc = spDeleteDocument
        end
        item
          StoredProc = spDocumentSelect
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1044#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 2
      QuestionBeforeExecute = #1042#1099' '#1076#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1093#1086#1090#1080#1090#1077' '#1091#1076#1072#1083#1080#1090#1100' '#1057#1082#1072#1085' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'?'
      InfoAfterExecute = #1057#1082#1072#1085' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085'.'
    end
    object spInserUpdateGoods: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'spInserUpdateGoods'
    end
    object actSetVisiblePanelPhoto: TBooleanSetVisibleAction
      Category = 'DSDLib'
      MoveParams = <>
      Components = <
        item
          Component = PanelPhoto
        end>
      HintTrue = #1057#1082#1088#1099#1090#1100' '#1086#1073#1083#1072#1089#1090#1100' '#1092#1086#1090#1086#1075#1088#1072#1092#1080#1081
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1086#1073#1083#1072#1089#1090#1100' '#1092#1086#1090#1086#1075#1088#1072#1092#1080#1081
      CaptionTrue = #1057#1082#1088#1099#1090#1100' '#1086#1073#1083#1072#1089#1090#1100' '#1092#1086#1090#1086#1075#1088#1072#1092#1080#1081
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1086#1073#1083#1072#1089#1090#1100' '#1092#1086#1090#1086#1075#1088#1072#1092#1080#1081
      ImageIndexTrue = 65
      ImageIndexFalse = 64
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
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 344
    Top = 435
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
          ItemName = 'bbPhotoSaveAction'
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
    object BarManagerBar2: TdxBar
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      CaptionButtons = <>
      DockControl = dxBarDockControl1
      DockedDockControl = dxBarDockControl1
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 868
      FloatTop = 151
      FloatClientWidth = 51
      FloatClientHeight = 84
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbAddDocument'
        end
        item
          Visible = True
          ItemName = 'bbDeleteDocument'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenDocument'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbDocumentSave'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefreshDoc'
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
      Action = MultiActionInsertDocument
      Category = 0
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
      ShowCaption = False
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
      Action = actDeleteDocument
      Category = 0
    end
    object bb: TdxBarButton
      Action = InsertRecordDoc
      Category = 0
      ImageIndex = 1
    end
    object bbDocumentSave: TdxBarButton
      Action = DocumentSaveAction
      Category = 0
    end
    object bbPhotoSaveAction: TdxBarButton
      Action = PhotoSaveAction
      Category = 0
    end
  end
  object spGetPhoto_panel: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Product_photo'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inProductId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 568
    Top = 536
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 776
    Top = 528
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 688
    Top = 528
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGrid1DBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
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
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 904
    Top = 528
  end
  object dsdDBViewAddOnDoc: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGrid2DBBandedTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <
      item
        FieldName = 'DocumentData'
        Control = PanelDocView
        isFocused = True
      end>
    PropertiesCellList = <>
    Left = 496
    Top = 120
  end
  object spUpdate_ProductDocument: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_ProductDocument'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inid'
        Value = Null
        Component = DocumentCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocTagId'
        Value = Null
        Component = DocumentCDS
        ComponentItem = 'DocTagId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = DocumentCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 408
    Top = 256
  end
  object GuidesModel: TdsdGuides
    KeyField = 'Id'
    LookupControl = edModel
    DisableGuidesOpen = True
    FormNameParam.Value = 'TProdModelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProdModelForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesModel
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesModel
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BrandName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdEngineId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdEngineName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptProdModelId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptProdModelName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 77
    Top = 107
  end
end
