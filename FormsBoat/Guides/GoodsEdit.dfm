object GoodsEditForm: TGoodsEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
  ClientHeight = 651
  ClientWidth = 863
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
    Left = 40
    Top = 113
    TabOrder = 0
    Width = 279
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 96
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 75
    Top = 610
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 211
    Top = 610
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 229
    Top = 3
    Caption = 'Interne Nr'
  end
  object ceCode: TcxCurrencyEdit
    Left = 229
    Top = 21
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 90
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 140
    Caption = #1043#1088#1091#1087#1087#1072
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 281
    Caption = #1045#1076'. '#1080#1079#1084'.'
  end
  object edRefer: TcxLabel
    Left = 184
    Top = 468
    Caption = #1056#1077#1082#1086#1084#1077#1085#1076'. '#1082#1086#1083'. '#1079#1072#1082#1091#1087#1082#1080
  end
  object ceRefer: TcxCurrencyEdit
    Left = 182
    Top = 486
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 9
    Width = 137
  end
  object ceParentGroup: TcxButtonEdit
    Left = 40
    Top = 160
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 187
  end
  object ceMeasure: TcxButtonEdit
    Left = 40
    Top = 301
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 135
  end
  object edProdColor: TcxButtonEdit
    Left = 40
    Top = 254
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 135
  end
  object cxLabel5: TcxLabel
    Left = 40
    Top = 234
    Caption = 'Farbe'
  end
  object ceInfoMoney: TcxButtonEdit
    Left = 184
    Top = 254
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = False
    TabOrder = 14
    Width = 135
  end
  object cxLabel6: TcxLabel
    Left = 184
    Top = 234
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object cxLabel7: TcxLabel
    Left = 184
    Top = 281
    Caption = 'Gr'#246#223'e'
  end
  object edGoodsSize: TcxButtonEdit
    Left = 184
    Top = 301
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 17
    Width = 135
  end
  object cxLabel8: TcxLabel
    Left = 40
    Top = 375
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
  end
  object edPartner: TcxButtonEdit
    Left = 40
    Top = 393
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 198
  end
  object cxLabel9: TcxLabel
    Left = 40
    Top = 188
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
  end
  object edGoodsTag: TcxButtonEdit
    Left = 40
    Top = 207
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 21
    Width = 135
  end
  object cxLabel10: TcxLabel
    Left = 184
    Top = 328
    Caption = #1043#1088#1091#1087#1087#1072' '#1089#1082#1080#1076#1082#1080' '#1091' '#1087#1072#1088#1090'.'
  end
  object ceDiscountParner: TcxButtonEdit
    Left = 184
    Top = 347
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 135
  end
  object edGoodsType: TcxButtonEdit
    Left = 184
    Top = 207
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 24
    Width = 135
  end
  object cxLabel11: TcxLabel
    Left = 184
    Top = 188
    Caption = #1058#1080#1087' '#1076#1077#1090#1072#1083#1080
  end
  object cxLabel12: TcxLabel
    Left = 225
    Top = 419
    Caption = #1044#1072#1090#1072' '#1087#1088'. '#1086#1090' '#1087#1086#1089#1090'.'
  end
  object edPartnerDate: TcxDateEdit
    Left = 225
    Top = 437
    EditValue = 42005d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 27
    Width = 94
  end
  object cxLabel13: TcxLabel
    Left = 40
    Top = 419
    Caption = #1057#1082#1083#1072#1076
  end
  object edUnit: TcxButtonEdit
    Left = 40
    Top = 437
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    TabOrder = 29
    Width = 176
  end
  object ceMin: TcxCurrencyEdit
    Left = 40
    Top = 486
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 30
    Width = 135
  end
  object cxLabel14: TcxLabel
    Left = 40
    Top = 469
    Caption = #1052#1080#1085'. '#1082#1086#1083'. '#1085#1072' '#1089#1082#1083#1072#1076#1077
  end
  object cxLabel17: TcxLabel
    Left = 40
    Top = 328
    Caption = #1058#1080#1087' '#1053#1044#1057
  end
  object cxLabel18: TcxLabel
    Left = 40
    Top = 3
    Caption = 'Artikel Nr'
  end
  object edArticle: TcxTextEdit
    Left = 40
    Top = 21
    TabOrder = 34
    Width = 90
  end
  object edArticleVergl: TcxTextEdit
    Left = 136
    Top = 21
    TabOrder = 35
    Width = 86
  end
  object cxLabel19: TcxLabel
    Left = 136
    Top = 3
    Caption = 'Vergl. Nr'
  end
  object cxLabel20: TcxLabel
    Left = 40
    Top = 51
    Caption = 'EAN'
  end
  object edEAN: TcxTextEdit
    Left = 40
    Top = 69
    TabOrder = 38
    Width = 90
  end
  object cxLabel21: TcxLabel
    Left = 137
    Top = 51
    Caption = 'ASIN'
  end
  object edASIN: TcxTextEdit
    Left = 137
    Top = 69
    TabOrder = 40
    Width = 90
  end
  object cxLabel22: TcxLabel
    Left = 233
    Top = 51
    Caption = 'Matchcode'
  end
  object edMatchCode: TcxTextEdit
    Left = 233
    Top = 69
    TabOrder = 42
    Width = 86
  end
  object cxLabel23: TcxLabel
    Left = 231
    Top = 142
    Hint = #8470' '#1090#1072#1084#1086#1078'. '#1087#1086#1096#1083#1080#1085#1099
    Caption = 'Zolltarif Nr'
    ParentShowHint = False
    ShowHint = True
  end
  object edFeeNumber: TcxTextEdit
    Left = 233
    Top = 160
    TabOrder = 44
    Width = 86
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 512
    Hint = #1062#1077#1085#1072' '#1073#1077#1079' '#1053#1044#1057' '#1079#1072#1082#1091#1087'.'
    Caption = 'Netto EK'
  end
  object edEKPrice: TcxCurrencyEdit
    Left = 40
    Top = 529
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Properties.UseDisplayFormatWhenEditing = True
    TabOrder = 46
    Width = 135
  end
  object edEmpfPrice: TcxCurrencyEdit
    Left = 182
    Top = 529
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 47
    Width = 137
  end
  object cxLabel15: TcxLabel
    Left = 184
    Top = 511
    Hint = #1062#1077#1085#1072' '#1088#1077#1082#1086#1084#1077#1085#1076#1091#1077#1084#1072#1103' '#1073#1077#1079' '#1053#1044#1057
    Caption = 'Empf. VK'
  end
  object cxLabel16: TcxLabel
    Left = 182
    Top = 556
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edComment: TcxTextEdit
    Left = 182
    Top = 576
    TabOrder = 50
    Width = 137
  end
  object ceisArc: TcxCheckBox
    Left = 252
    Top = 393
    Caption = #1040#1088#1093#1080#1074
    TabOrder = 51
    Width = 67
  end
  object edTaxKind: TcxButtonEdit
    Left = 40
    Top = 347
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 52
    Width = 135
  end
  object Panel: TPanel
    Left = 344
    Top = 0
    Width = 519
    Height = 651
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 53
    object cxDBVerticalGrid: TcxDBVerticalGrid
      Left = 0
      Top = 327
      Width = 519
      Height = 142
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
    object dxBarDockControl1: TdxBarDockControl
      Left = 0
      Top = 0
      Width = 519
      Height = 26
      Align = dalTop
      BarManager = BarManager
    end
    object dxBarDockControl3: TdxBarDockControl
      Left = 0
      Top = 301
      Width = 519
      Height = 26
      Align = dalTop
      BarManager = BarManager
    end
    object PanelPhoto: TPanel
      Left = 0
      Top = 469
      Width = 519
      Height = 182
      Align = alBottom
      Caption = 'PanelPhoto'
      ShowCaption = False
      TabOrder = 3
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
    object Panel1: TPanel
      Left = 0
      Top = 26
      Width = 519
      Height = 275
      Align = alTop
      Caption = 'Panel1'
      TabOrder = 4
      object cxGrid2: TcxGrid
        Left = 304
        Top = 1
        Width = 214
        Height = 273
        Align = alRight
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DataSourceDoc
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object DocTagName: TcxGridDBColumn
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
            Width = 117
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            Width = 90
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxDBVerticalGrid1: TcxDBVerticalGrid
        Left = 1
        Top = 1
        Width = 299
        Height = 273
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
        DataController.DataSource = DocumentDS
        Version = 1
        object cxDBEditorRow1: TcxDBEditorRow
          Options.CanAutoHeight = False
          Height = 142
          Properties.Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
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
      object cxRightSplitter: TcxSplitter
        Left = 300
        Top = 1
        Width = 4
        Height = 273
        AlignSplitter = salRight
        Control = cxGrid2
      end
    end
  end
  object cxLabel24: TcxLabel
    Left = 40
    Top = 556
    Caption = 'Engine'
  end
  object edEngine: TcxButtonEdit
    Left = 40
    Top = 576
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 59
    Width = 135
  end
  object ActionList: TActionList
    Left = 248
    Top = 80
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
          StoredProc = spDocumentSelect2
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
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = #1054#1082
    end
    object dsdUpdateDataSetDoc: TdsdUpdateDataSet
      Category = 'Doc'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_GoodsDocument
      StoredProcList = <
        item
          StoredProc = spUpdate_GoodsDocument
        end
        item
          StoredProc = spDocumentSelect2
        end>
      Caption = 'actUpdateDataSetDoc'
      DataSource = DataSourceDoc
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
          Component = ClientDataSetDoc
          ComponentItem = 'DocTagId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSetDoc
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
      View = cxGridDBTableView1
      Action = OpenChoiceFormDocTag
      Params = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'/'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1072#1090#1077#1075#1086#1088#1080#1102' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'/'#1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Goods'
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
        Component = edArticle
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inArticleVergl'
        Value = Null
        Component = edArticleVergl
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEAN'
        Value = Null
        Component = edEAN
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inASIN'
        Value = Null
        Component = edASIN
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMatchCode'
        Value = Null
        Component = edMatchCode
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFeeNumber'
        Value = Null
        Component = edFeeNumber
        DataType = ftString
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
        Name = 'inisArc'
        Value = Null
        Component = ceisArc
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountMin'
        Value = Null
        Component = ceMin
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountRefer'
        Value = 0.000000000000000000
        Component = ceRefer
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEKPrice'
        Value = Null
        Component = edEKPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmpfPrice'
        Value = Null
        Component = edEmpfPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMeasureId'
        Value = ''
        Component = GuidesMeasure
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsTagId'
        Value = ''
        Component = GuidesGoodsTag
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsTypeId'
        Value = Null
        Component = GuidesGoodsType
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsSizeId'
        Value = ''
        Component = GuidesGoodsSize
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProdColorId'
        Value = ''
        Component = GuidesProdColor
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = '0'
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiscountParnerId'
        Value = ''
        Component = GuidesDiscountParner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxKindId'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEngineId'
        Value = Null
        Component = GuidesProdEngine
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 176
    Top = 88
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 184
    Top = 40
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Goods'
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
        Component = ceCode
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
        Name = 'ASIN'
        Value = Null
        Component = edASIN
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
        Name = 'MatchCode'
        Value = Null
        Component = edMatchCode
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FeeNumber'
        Value = Null
        Component = edFeeNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupId'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsTagId'
        Value = ''
        Component = GuidesGoodsTag
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsTagName'
        Value = ''
        Component = GuidesGoodsTag
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsTypeId'
        Value = Null
        Component = GuidesGoodsType
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsTypeName'
        Value = Null
        Component = GuidesGoodsType
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureId'
        Value = ''
        Component = GuidesMeasure
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureName'
        Value = ''
        Component = GuidesMeasure
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdColorId'
        Value = ''
        Component = GuidesProdColor
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProdColorName'
        Value = ''
        Component = GuidesProdColor
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountParnerId'
        Value = ''
        Component = GuidesDiscountParner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountParnerName'
        Value = ''
        Component = GuidesDiscountParner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsSizeId'
        Value = ''
        Component = GuidesGoodsSize
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsSizeName'
        Value = ''
        Component = GuidesGoodsSize
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerDate'
        Value = 42005d
        Component = edPartnerDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindId'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindName'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountRefer'
        Value = 0.000000000000000000
        Component = ceRefer
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountMin'
        Value = Null
        Component = ceMin
        DataType = ftFloat
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
        Name = 'EmpfPrice'
        Value = 0.000000000000000000
        Component = edEmpfPrice
        DataType = ftFloat
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
        Name = 'EngineId'
        Value = Null
        Component = GuidesProdEngine
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'EngineName'
        Value = Null
        Component = GuidesProdEngine
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 8
    Top = 72
  end
  object GuidesMeasure: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMeasure
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
    Left = 112
    Top = 280
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
    Left = 8
    Top = 258
  end
  object GuidesInfoMoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 187
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
    Left = 185
    Top = 539
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 16
    Top = 8
  end
  object GuidesGoodsSize: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsSize
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
    Left = 264
    Top = 240
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
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
    Top = 424
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParentGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'MasterCDS'
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
    Left = 72
    Top = 128
  end
  object GuidesGoodsTag: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsTag
    FormNameParam.Value = 'TGoodsTagForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsTagForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsTag
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsTag
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 24
    Top = 192
  end
  object GuidesDiscountParner: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceDiscountParner
    FormNameParam.Value = 'TDiscountParnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDiscountParnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesDiscountParner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesDiscountParner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupAnalystId'
        Value = Null
        Component = GuidesGoodsType
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupAnalystName'
        Value = Null
        Component = GuidesGoodsType
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 264
    Top = 326
  end
  object GuidesGoodsType: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsType
    FormNameParam.Value = 'TGoodsTypeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsTypeForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsType
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsType
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 136
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    Key = '0'
    FormNameParam.Value = 'TUnitForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 137
    Top = 496
  end
  object GuidesTaxKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTaxKind
    FormNameParam.Value = 'TTaxKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TTaxKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 93
    Top = 348
  end
  object spInsertDocument: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_GoodsDocument'
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
        Name = 'inGoodsId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsdocumentdata'
        Value = '789C535018D10000F1E01FE1'
        Component = Document
        ComponentItem = 'Data'
        DataType = ftBlob
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 448
    Top = 152
  end
  object spDocumentSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsDocument'
    DataSet = DocumentCDS
    DataSets = <
      item
        DataSet = DocumentCDS
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
    Left = 456
    Top = 200
  end
  object DocumentDS: TDataSource
    DataSet = DocumentCDS
    Left = 376
    Top = 184
  end
  object DocumentCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 376
    Top = 136
  end
  object spDeleteDocument: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_GoodsDocument'
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
    Left = 552
    Top = 40
  end
  object spGetDocument: TdsdStoredProc
    StoredProcName = 'gpGet_Object_GoodsDocument'
    DataSets = <>
    OutputType = otBlob
    Params = <
      item
        Name = 'inGoodsdocumentid'
        Value = Null
        Component = DocumentCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 520
    Top = 152
  end
  object Document: TDocument
    GetBlobProcedure = spGetDocument
    Left = 384
    Top = 56
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 483
    Top = 332
  end
  object PhotoCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 592
    Top = 352
  end
  object PhotoDS: TDataSource
    DataSet = PhotoCDS
    Left = 592
    Top = 296
  end
  object Photo: TDocument
    GetBlobProcedure = spGetPhoto
    Left = 784
    Top = 320
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
    Left = 792
    Top = 376
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
    Left = 808
    Top = 440
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
    Left = 720
    Top = 312
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
    Left = 712
    Top = 392
  end
  object ActionList1: TActionList
    Left = 453
    Top = 421
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
        end
        item
          StoredProc = spDocumentSelect2
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
      Document = Document
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1080
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1080
      ImageIndex = 60
    end
    object MultiActionInsertPhoto: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spInserUpdateGoods
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
    object MultiActionInsertDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spInserUpdateGoods
        end
        item
          Action = actInsertDocument
        end
        item
          Action = DocumentRefresh
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
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
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
      ImageIndex = 2
      QuestionBeforeExecute = #1042#1099' '#1076#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1093#1086#1090#1080#1090#1077' '#1091#1076#1072#1083#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
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
    Left = 376
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
      DockedLeft = 1
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
    Left = 656
    Top = 568
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 808
    Top = 528
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 752
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
    PropertiesCellList = <>
    Left = 792
    Top = 592
  end
  object GuidesProdEngine: TdsdGuides
    KeyField = 'Id'
    LookupControl = edEngine
    FormNameParam.Value = 'TProdEngineForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProdEngineForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesProdEngine
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesProdEngine
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 86
    Top = 554
  end
  object dsdDBViewAddOnDoc: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
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
    PropertiesCellList = <>
    Left = 736
    Top = 96
  end
  object ClientDataSetDoc: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'Id'
    MasterFields = 'Id'
    MasterSource = DocumentDS
    PacketRecords = 0
    Params = <>
    Left = 720
    Top = 144
  end
  object DataSourceDoc: TDataSource
    DataSet = ClientDataSetDoc
    Left = 776
    Top = 144
  end
  object spDocumentSelect2: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsDocument'
    DataSet = ClientDataSetDoc
    DataSets = <
      item
        DataSet = ClientDataSetDoc
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
    Left = 544
    Top = 224
  end
  object spUpdate_GoodsDocument: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsDocument'
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
        Component = ClientDataSetDoc
        ComponentItem = 'DocTagId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = ClientDataSetDoc
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 608
    Top = 152
  end
end
