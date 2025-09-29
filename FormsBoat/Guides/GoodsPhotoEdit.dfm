object GoodsPhotoEditForm: TGoodsPhotoEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' - Document / Photo>'
  ClientHeight = 595
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
    Left = 33
    Top = 230
    Properties.ReadOnly = True
    TabOrder = 0
    Visible = False
    Width = 187
  end
  object cxLabel1: TcxLabel
    Left = 14
    Top = 172
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 15
    Top = 545
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 126
    Top = 545
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 14
    Top = 48
    Caption = 'Interne Nr'
  end
  object ceCode: TcxCurrencyEdit
    Left = 14
    Top = 65
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 187
  end
  object PanelMain: TPanel
    Left = 216
    Top = 0
    Width = 756
    Height = 595
    Align = alRight
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'PanelMain'
    ShowCaption = False
    TabOrder = 6
    ExplicitHeight = 412
    object Panel: TPanel
      Left = 1
      Top = 1
      Width = 232
      Height = 593
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitHeight = 410
      object dxBarDockControl1: TdxBarDockControl
        Left = 0
        Top = 0
        Width = 232
        Align = dalTop
        BarManager = BarManager
      end
      object dxBarDockControl3: TdxBarDockControl
        Left = 0
        Top = 3
        Width = 232
        Height = 26
        Align = dalTop
        BarManager = BarManager
      end
      object PanelPhotoList: TPanel
        Left = 0
        Top = 29
        Width = 232
        Height = 564
        Align = alClient
        Caption = 'PanelPhotoList'
        ShowCaption = False
        TabOrder = 2
        ExplicitHeight = 381
        object cxGrid3: TcxGrid
          Left = 1
          Top = 19
          Width = 230
          Height = 544
          Align = alClient
          TabOrder = 0
          ExplicitHeight = 361
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
      Height = 593
      Align = alClient
      Caption = 'PanelView'
      ShowCaption = False
      TabOrder = 1
      ExplicitHeight = 410
      object PanelPhoto: TPanel
        Left = 1
        Top = 1
        Width = 520
        Height = 220
        Align = alTop
        Caption = 'PanelPhoto'
        ShowCaption = False
        TabOrder = 0
        object Image3: TcxImage
          Left = 341
          Top = 1
          Align = alLeft
          Properties.ReadOnly = True
          TabOrder = 0
          Height = 218
          Width = 170
        end
        object Image2: TcxImage
          Left = 171
          Top = 1
          Align = alLeft
          Properties.ReadOnly = True
          TabOrder = 1
          Height = 218
          Width = 170
        end
        object Image1: TcxImage
          Left = 1
          Top = 1
          Align = alLeft
          Properties.ReadOnly = True
          TabOrder = 2
          Height = 218
          Width = 170
        end
        object cxGrid1: TcxGrid
          Left = 177
          Top = 128
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
  object edArticle: TcxTextEdit
    Left = 14
    Top = 26
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 90
  end
  object cxLabel4: TcxLabel
    Left = 14
    Top = 8
    Caption = 'Artikel Nr'
  end
  object cxLabel5: TcxLabel
    Left = 114
    Top = 8
    Caption = 'Vergl. Nr'
  end
  object edArticleVergl: TcxTextEdit
    Left = 111
    Top = 26
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 90
  end
  object cxLabel20: TcxLabel
    Left = 15
    Top = 90
    Caption = 'EAN'
  end
  object edEAN: TcxTextEdit
    Left = 14
    Top = 107
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 90
  end
  object edASIN: TcxTextEdit
    Left = 111
    Top = 107
    Properties.ReadOnly = True
    TabOrder = 14
    Width = 90
  end
  object cxLabel21: TcxLabel
    Left = 111
    Top = 90
    Caption = 'ASIN'
  end
  object edMatchCode: TcxTextEdit
    Left = 14
    Top = 150
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 90
  end
  object cxLabel22: TcxLabel
    Left = 14
    Top = 132
    Caption = 'Matchcode'
  end
  object cxLabel6: TcxLabel
    Left = 111
    Top = 130
    Caption = #1045#1076'. '#1080#1079#1084'.'
  end
  object ceMeasure: TcxButtonEdit
    Left = 111
    Top = 150
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 18
    Width = 90
  end
  object cxButton3: TcxButton
    Left = 8
    Top = 498
    Width = 186
    Height = 25
    Action = actSetVisiblePanelPhoto
    ModalResult = 8
    TabOrder = 22
  end
  object edNameMemo: TcxMemo
    Left = 14
    Top = 188
    TabOrder = 24
    Height = 63
    Width = 188
  end
  object cxLabel30: TcxLabel
    Left = 143
    Top = 255
    Caption = #1054#1089#1090#1072#1090#1086#1082
  end
  object edAmountRemains: TcxCurrencyEdit
    Left = 143
    Top = 272
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 26
    Width = 58
  end
  object cxLabel7: TcxLabel
    Left = 101
    Top = 379
    Caption = 'Gr'#246#223'e'
  end
  object edGoodsSize: TcxButtonEdit
    Left = 101
    Top = 396
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = False
    TabOrder = 28
    Width = 100
  end
  object cxLabel29: TcxLabel
    Left = 14
    Top = 379
    Caption = 'Weight'
  end
  object ceWeight: TcxCurrencyEdit
    Left = 14
    Top = 396
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    TabOrder = 30
    Width = 82
  end
  object cxLabel8: TcxLabel
    Left = 14
    Top = 297
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
  end
  object edPartner: TcxButtonEdit
    Left = 14
    Top = 313
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 32
    Width = 187
  end
  object cxLabel16: TcxLabel
    Left = 14
    Top = 422
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edComment: TcxTextEdit
    Left = 14
    Top = 440
    Properties.ReadOnly = True
    TabOrder = 34
    Width = 187
  end
  object cxLabel2: TcxLabel
    Left = 14
    Top = 339
    Caption = 'Farbe'
  end
  object edProdColor: TcxButtonEdit
    Left = 14
    Top = 355
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 36
    Width = 123
  end
  object cxLabel9: TcxLabel
    Left = 14
    Top = 255
    Caption = #1043#1088#1091#1087#1087#1072
  end
  object ceParentGroup: TcxButtonEdit
    Left = 14
    Top = 272
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 38
    Width = 123
  end
  object edEKPrice: TcxCurrencyEdit
    Left = 143
    Top = 355
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.ReadOnly = True
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 39
    Width = 58
  end
  object cxLabel10: TcxLabel
    Left = 143
    Top = 339
    Hint = #1062#1077#1085#1072' '#1073#1077#1079' '#1053#1044#1057' '#1079#1072#1082#1091#1087'.'
    Caption = 'Netto EK'
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 896
    Top = 448
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
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
      StoredProcList = <
        item
        end>
      Caption = 'actUpdateDataSetDoc'
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
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
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
    Left = 920
    Top = 16
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 664
    Top = 424
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Goods'
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
        Name = 'inPriceListId'
        Value = '2773'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMaskId'
        Value = '0'
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
        Name = 'Article'
        Value = Null
        Component = edArticle
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ArticleVergl'
        Value = Null
        Component = edArticleVergl
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'EAN'
        Value = Null
        Component = edEAN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ASIN'
        Value = Null
        Component = edASIN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MatchCode'
        Value = Null
        Component = edMatchCode
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureId'
        Value = Null
        Component = GuidesMeasure
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureName'
        Value = Null
        Component = GuidesMeasure
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = Null
        Component = edNameMemo
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupId'
        Value = Null
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = Null
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRemains'
        Value = Null
        Component = edAmountRemains
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsSizeId'
        Value = Null
        Component = GuidesGoodsSize
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsSizeName'
        Value = Null
        Component = GuidesGoodsSize
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'EKPrice'
        Value = Null
        Component = edEKPrice
        DataType = ftFloat
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
      end
      item
        Name = 'Weight'
        Value = Null
        Component = ceWeight
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 40
    Top = 224
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
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 561
    Top = 427
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 176
    Top = 522
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 99
    Top = 550
  end
  object PhotoCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 256
    Top = 168
  end
  object PhotoDS: TDataSource
    DataSet = PhotoCDS
    Left = 256
    Top = 112
  end
  object Photo: TDocument
    GetBlobProcedure = spGetPhoto
    Left = 400
    Top = 112
  end
  object spGetPhoto: TdsdStoredProc
    StoredProcName = 'gpGet_Object_GoodsPhoto'
    DataSets = <>
    OutputType = otBlob
    Params = <
      item
        Name = 'inGoodsPhotoid'
        Value = Null
        Component = PhotoCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 400
    Top = 176
  end
  object spDeletePhoto: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_GoodsPhoto'
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
    Left = 376
    Top = 272
  end
  object spPhotoSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsPhoto'
    DataSet = PhotoCDS
    DataSets = <
      item
        DataSet = PhotoCDS
      end>
    Params = <
      item
        Name = 'inGoodsId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 336
    Top = 112
  end
  object spInsertPhoto: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsPhoto'
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
        Name = 'inGoodsId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsPhotodata'
        Value = '789C535018D10000F1E01FE1'
        Component = Photo
        ComponentItem = 'Data'
        DataType = ftBlob
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 280
    Top = 264
  end
  object ActionList1: TActionList
    Images = dmMain.ImageList
    Left = 21
    Top = 551
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
    object actInsertDocument: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
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
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 60
    end
    object DocumentSaveAction: TDocumentSaveAction
      Category = 'DSDLib'
      MoveParams = <>
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
      StoredProcList = <
        item
        end
        item
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
    Left = 336
    Top = 171
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
    StoredProcName = 'gpGet_Object_Goods_photo'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inGoodsId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 560
    Top = 320
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 784
    Top = 328
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 696
    Top = 312
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
    Top = 328
  end
  object GuidesMeasure: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMeasure
    DisableGuidesOpen = True
    FormNameParam.Value = 'TMeasureForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMeasureForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMeasure
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMeasure
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 128
  end
  object GuidesGoodsSize: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsSize
    DisableGuidesOpen = True
    FormNameParam.Value = 'TGoodsSizeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsSizeForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsSize
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsSize
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 199
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 297
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParentGroup
    DisableGuidesOpen = True
    FormNameParam.Value = 'TGoodsGroupChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroupChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 256
  end
  object GuidesProdColor: TdsdGuides
    KeyField = 'Id'
    LookupControl = edProdColor
    DisableGuidesOpen = True
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesProdColor
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 56
    Top = 338
  end
end
