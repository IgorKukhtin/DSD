object GuideGoodsStickerForm: TGuideGoodsStickerForm
  Left = 578
  Top = 242
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1088#1086#1076#1091#1082#1094#1080#1080
  ClientHeight = 665
  ClientWidth = 858
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object GridPanel: TPanel
    Left = 0
    Top = 415
    Width = 858
    Height = 250
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object ButtonPanel: TPanel
      Left = 0
      Top = 0
      Width = 858
      Height = 33
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object bbExit: TSpeedButton
        Left = 511
        Top = 3
        Width = 31
        Height = 29
        Action = actExit
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888808077708888888880807770880800008080777088888880008077
          7088888880088078708800808000807770888888000000777088888888008007
          7088888880008077708888888800800770888888888880000088888888888888
          8888888888884444888888888888488488888888888844448888}
        ParentShowHint = False
        ShowHint = True
      end
      object bbRefresh: TSpeedButton
        Left = 306
        Top = 3
        Width = 31
        Height = 29
        Action = actRefresh
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777000000
          00007777770FFFFFFFF000700000FF0F00F0E00BFBFB0FFFFFF0E0BFBF000FFF
          F0F0E0FBFBFBF0F00FF0E0BFBF00000B0FF0E0FBFBFBFBF0FFF0E0BF0000000F
          FFF0000BFB00B0FF00F07770000B0FFFFFF0777770B0FFFF000077770B0FF00F
          0FF07770B00FFFFF0F077709070FFFFF00777770770000000777}
        ParentShowHint = False
        ShowHint = True
      end
      object bbSave: TSpeedButton
        Left = 67
        Top = 3
        Width = 31
        Height = 29
        Action = actSave
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          888888888888888888888888888888888888873333333333338887BB3B33B3B3
          B38887B3B3B13B3B3388873B3B9913B3B38887B3B399973B3388873B397B9973
          B38887B397BBB997338887FFFFFFFF91BB8888FBBBBB88891888888FFFF88888
          9188888888888888898888888888888888988888888888888888}
        ParentShowHint = False
        ShowHint = True
      end
    end
    object cxDBGrid: TcxGrid
      Left = 0
      Top = 33
      Width = 858
      Height = 217
      Align = alClient
      TabOrder = 1
      object cxDBGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = DS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = ',0.####'
            Kind = skSum
          end
          item
            Format = ',0.####'
            Kind = skSum
          end
          item
            Format = ',0.####'
            Kind = skSum
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = ',0.####'
            Kind = skSum
          end
          item
            Format = ',0.####'
            Kind = skSum
          end
          item
            Format = ',0.####'
            Kind = skSum
          end>
        DataController.Summary.SummaryGroups = <>
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnMoving = False
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object TradeMarkName_goods: TcxGridDBColumn
          Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
          DataBinding.FieldName = 'TradeMarkName_goods'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 100
        end
        object GoodsCode: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1090#1086#1074'.'
          DataBinding.FieldName = 'GoodsCode'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object GoodsName: TcxGridDBColumn
          Caption = #1055#1088#1086#1076#1091#1082#1090
          DataBinding.FieldName = 'GoodsName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 150
        end
        object GoodsName_original: TcxGridDBColumn
          Caption = #1058#1086#1074#1072#1088
          DataBinding.FieldName = 'GoodsName_original'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 150
        end
        object MeasureName: TcxGridDBColumn
          Caption = #1045#1076'. '#1080#1079#1084'.'
          DataBinding.FieldName = 'MeasureName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 35
        end
        object GoodsKindCode: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1087#1072#1082'.'
          DataBinding.FieldName = 'GoodsKindCode'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 35
        end
        object GoodsKindName: TcxGridDBColumn
          Caption = #1042#1080#1076' '#1087#1072#1082#1091#1074#1072#1085#1085#1103
          DataBinding.FieldName = 'GoodsKindName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          VisibleForCustomization = False
          Width = 100
        end
        object StickerSortName: TcxGridDBColumn
          Caption = #1057#1086#1088#1090#1085#1086#1089#1090#1100
          DataBinding.FieldName = 'StickerSortName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object StickerSkinName: TcxGridDBColumn
          Caption = #1054#1073#1086#1083#1086#1095#1082#1072
          DataBinding.FieldName = 'StickerSkinName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object GoodsKindName_complete: TcxGridDBColumn
          Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
          DataBinding.FieldName = 'GoodsKindName_complete'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 80
        end
        object Amount_Weighing: TcxGridDBColumn
          Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1087#1077#1095#1072#1090#1080
          DataBinding.FieldName = 'Amount_Weighing'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          VisibleForCustomization = False
          Width = 50
        end
        object Comment: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          DataBinding.FieldName = 'Comment'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 100
        end
        object StickerFileName: TcxGridDBColumn
          Caption = #1064#1040#1041#1051#1054#1053
          DataBinding.FieldName = 'StickerFileName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 200
        end
        object StickerFileName_70_70: TcxGridDBColumn
          Caption = #1064#1040#1041#1051#1054#1053' 70x70'
          DataBinding.FieldName = 'StickerFileName_70_70'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
      end
      object cxDBGridLevel: TcxGridLevel
        GridView = cxDBGridDBTableView
      end
    end
  end
  object ParamsAllPanel: TPanel
    Left = 0
    Top = 0
    Width = 858
    Height = 407
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object PreviewPanel: TPanel
      Left = 0
      Top = 0
      Width = 380
      Height = 407
      Align = alLeft
      TabOrder = 2
      object frxPreview: TfrxPreview
        Left = 1
        Top = 1
        Width = 378
        Height = 405
        Align = alClient
        OutlineVisible = False
        OutlineWidth = 120
        ThumbnailVisible = False
        UseReportHints = True
      end
    end
    object cxSplitter1: TcxSplitter
      Left = 850
      Top = 0
      Width = 8
      Height = 407
      AlignSplitter = salRight
      AllowHotZoneDrag = False
      Control = ParamsAllPanel
    end
    object ParamsPanel: TPanel
      Left = 380
      Top = 0
      Width = 470
      Height = 407
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object infoPanelPriceList: TPanel
        Left = 338
        Top = 0
        Width = 132
        Height = 348
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 2
        object gbWeightValue: TGroupBox
          Left = 0
          Top = 0
          Width = 132
          Height = 41
          Align = alTop
          Caption = #1042#1074#1086#1076' '#1050#1054#1051'-'#1042#1054
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          object EditWeightValue: TcxCurrencyEdit
            Left = 5
            Top = 17
            EditValue = 2.000000000000000000
            Properties.Alignment.Horz = taRightJustify
            Properties.Alignment.Vert = taVCenter
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 0
            TabOrder = 0
            OnEnter = EditTareCountEnter
            OnExit = EditWeightValueExit
            OnKeyDown = EditWeightValueKeyDown
            Width = 121
          end
        end
        object rgPriceList: TRadioGroup
          Left = 0
          Top = 115
          Width = 132
          Height = 212
          Align = alClient
          Caption = #1055#1088#1080#1085#1090#1077#1088#1099
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 1
          WordWrap = True
          OnClick = rgPriceListClick
        end
        object gbPriceListCode: TGroupBox
          Left = 0
          Top = 74
          Width = 132
          Height = 41
          Align = alTop
          Caption = #1050#1086#1076
          TabOrder = 0
          object EditPriceListCode: TEdit
            Left = 5
            Top = 17
            Width = 121
            Height = 22
            TabOrder = 0
            Text = 'EditPriceListCode'
            OnChange = EditPriceListCodeChange
            OnEnter = EditTareCountEnter
            OnExit = EditPriceListCodeExit
            OnKeyPress = EditPriceListCodeKeyPress
          end
        end
        object PanelPrint: TPanel
          Left = 0
          Top = 41
          Width = 132
          Height = 33
          Align = alTop
          BevelOuter = bvNone
          Caption = 'PanelPrint'
          TabOrder = 2
          object btnPrint: TButton
            Left = 20
            Top = 1
            Width = 100
            Height = 33
            Caption = #1055#1045#1063#1040#1058#1068
            TabOrder = 0
            OnClick = actSaveExecute
          end
        end
        object PanelIsPreview: TPanel
          Left = 0
          Top = 327
          Width = 132
          Height = 21
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 4
          object cbPreviewPrint: TcxCheckBox
            Left = 20
            Top = 0
            Caption = #1055#1088#1086#1089#1084#1086#1090#1088
            TabOrder = 0
            Width = 91
          end
        end
      end
      object infoPanelGoods: TPanel
        Left = 0
        Top = 0
        Width = 95
        Height = 348
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object gbGoodsName: TGroupBox
          Left = 0
          Top = 41
          Width = 95
          Height = 41
          Align = alTop
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          TabOrder = 1
          object EditGoodsName: TEdit
            Left = 5
            Top = 17
            Width = 85
            Height = 22
            TabOrder = 0
            Text = 'EditGoodsName'
            OnChange = EditGoodsNameChange
            OnEnter = EditGoodsNameEnter
            OnExit = EditGoodsNameExit
            OnKeyDown = EditGoodsNameKeyDown
            OnKeyPress = EditGoodsNameKeyPress
          end
        end
        object gbGoodsCode: TGroupBox
          Left = 0
          Top = 0
          Width = 95
          Height = 41
          Align = alTop
          Caption = #1050#1086#1076
          TabOrder = 0
          object EditGoodsCode: TEdit
            Left = 5
            Top = 17
            Width = 85
            Height = 22
            TabOrder = 0
            Text = 'EditGoodsCode'
            OnChange = EditGoodsCodeChange
            OnEnter = EditGoodsCodeEnter
            OnExit = EditGoodsCodeExit
            OnKeyDown = EditGoodsCodeKeyDown
            OnKeyPress = EditGoodsCodeKeyPress
          end
        end
        object gbGoodsWieghtValue: TGroupBox
          Left = 0
          Top = 82
          Width = 95
          Height = 41
          Align = alTop
          Caption = #1042#1077#1089' '#1085#1072' '#1058#1072#1073#1083#1086
          TabOrder = 2
          object PanelGoodsWieghtValue: TPanel
            Left = 2
            Top = 16
            Width = 91
            Height = 23
            Align = alClient
            BevelOuter = bvNone
            Caption = 'PanelWieghtValue'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
        end
        object PanelIs_70_70: TPanel
          Left = 0
          Top = 327
          Width = 95
          Height = 21
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 3
          object cb_70_70: TcxCheckBox
            Left = 15
            Top = -1
            Caption = '70 x 70'
            TabOrder = 0
            OnClick = cb_70_70Click
            Width = 71
          end
        end
      end
      object infoPanelGoodsKind: TPanel
        Left = 95
        Top = 0
        Width = 243
        Height = 348
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object rgGoodsKind: TRadioGroup
          Left = 0
          Top = 41
          Width = 243
          Height = 307
          Align = alClient
          Caption = #1055#1072#1082#1091#1074#1072#1085#1085#1103
          Color = clBtnFace
          Columns = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 1
          OnClick = rgGoodsKindClick
        end
        object gbGoodsKindCode: TGroupBox
          Left = 0
          Top = 0
          Width = 243
          Height = 41
          Align = alTop
          Caption = #1050#1086#1076' '#1087#1072#1082#1091#1074#1072#1085#1085#1103
          TabOrder = 0
          object EditGoodsKindCode: TEdit
            Left = 5
            Top = 17
            Width = 108
            Height = 22
            TabOrder = 0
            Text = 'EditGoodsKindCode'
            OnChange = EditGoodsKindCodeChange
            OnEnter = EditTareCountEnter
            OnExit = EditGoodsKindCodeExit
            OnKeyPress = EditGoodsKindCodeKeyPress
          end
        end
      end
      object PanelSticker: TPanel
        Left = 0
        Top = 348
        Width = 470
        Height = 59
        Align = alBottom
        TabOrder = 3
        object cbStartEnd: TcxCheckBox
          Left = 5
          Top = 5
          Caption = #1055#1077#1095#1072#1090#1072#1090#1100' '#1076#1072#1090#1091' '#1087#1088#1086#1080#1079#1074'-'#1074#1072
          State = cbsChecked
          TabOrder = 0
          OnClick = cbStartEndClick
          OnEnter = cbStartEndEnter
          Width = 180
        end
        object cxLabel1: TcxLabel
          Left = 11
          Top = 31
          Caption = #1044#1072#1090#1072' '#1089' ...'
        end
        object deDateStart: TcxDateEdit
          Left = 73
          Top = 31
          EditValue = 43101d
          Properties.SaveTime = False
          Properties.ShowTime = False
          Properties.OnChange = deDateStartPropertiesChange
          TabOrder = 2
          OnEnter = cbStartEndEnter
          Width = 99
        end
        object cbTare: TcxCheckBox
          Left = 191
          Top = 5
          Caption = #1055#1077#1095#1072#1090#1072#1090#1100' '#1076#1083#1103' '#1058#1040#1056#1067
          TabOrder = 3
          OnClick = cbStartEndClick
          OnEnter = cbStartEndEnter
          Width = 140
        end
        object cbGoodsName: TcxCheckBox
          Left = 191
          Top = 28
          Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
          State = cbsChecked
          TabOrder = 4
          OnClick = cbStartEndClick
          OnEnter = cbStartEndEnter
          Width = 140
        end
        object btnDialogStickerTare: TButton
          Left = 339
          Top = 14
          Width = 124
          Height = 33
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1083#1103' '#1058#1072#1088#1099
          TabOrder = 5
          OnClick = btnDialogStickerTareClick
        end
      end
    end
  end
  object cxSplitter2: TcxSplitter
    Left = 0
    Top = 407
    Width = 858
    Height = 8
    AlignSplitter = salBottom
    InvertDirection = True
    Control = GridPanel
  end
  object DS: TDataSource
    DataSet = CDS
    OnDataChange = DSDataChange
    Left = 320
    Top = 336
  end
  object spSelect: TdsdStoredProc
    DataSet = CDS
    DataSets = <
      item
        DataSet = CDS
      end>
    Params = <>
    PackSize = 1
    Left = 224
    Top = 344
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    OnFilterRecord = CDSFilterRecord
    Left = 272
    Top = 384
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxDBGridDBTableView
    OnDblClickActionList = <
      item
        Action = actChoice
      end>
    ActionItemList = <
      item
        Action = actChoice
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 408
    Top = 392
  end
  object ActionList: TActionList
    Left = 120
    Top = 336
    object actRefresh: TAction
      Category = 'ScaleLib'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      OnExecute = actRefreshExecute
    end
    object actChoice: TAction
      Category = 'ScaleLib'
      Hint = #1042#1099#1073#1086#1088' '#1079#1085#1072#1095#1077#1085#1080#1103
      OnExecute = actChoiceExecute
    end
    object actExit: TAction
      Category = 'ScaleLib'
      Hint = #1042#1099#1093#1086#1076
      OnExecute = actExitExecute
    end
    object actSave: TAction
      Category = 'ScaleLib'
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      OnExecute = actSaveExecute
    end
    object actPrint: TdsdPrintAction
      Category = 'Print'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <>
      ReportName = 'NULL'
      ReportNameParam.Value = Null
      ReportNameParam.ComponentItem = 'ReportNameSticker'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  object PrintHeaderFormCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 84
    Top = 49
  end
  object spSelectPrintForm: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_StickerProperty_Print'
    DataSet = PrintHeaderFormCDS
    DataSets = <
      item
        DataSet = PrintHeaderFormCDS
      end>
    Params = <
      item
        Name = 'inObjectId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsJPG'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsLength'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIs70_70'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsStartEnd'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTare'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPartion'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsGoodsName'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateStart'
        Value = 43101d
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateTare'
        Value = 43101d
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDatePack'
        Value = 43101d
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateProduction'
        Value = 43101d
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumPack'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumTech'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 191
    Top = 96
  end
  object frxDBDHeaderForm: TfrxDBDataset
    UserName = 'frxDBDHeader'
    CloseDataSource = False
    DataSet = PrintHeaderFormCDS
    BCDToCurrency = False
    Left = 80
    Top = 112
  end
  object FReport: TfrxReport
    Version = '4.15.6'
    DataSet = frxDBDHeaderForm
    DataSetName = 'frxDBDHeader'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    Preview = frxPreview
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PreviewOptions.ZoomMode = zmWholePage
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 43169.638123020840000000
    ReportOptions.LastChange = 43169.638123020840000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 176
    Top = 168
    Datasets = <>
    Variables = <>
    Style = <>
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 652
    Top = 9
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_StickerProperty_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end>
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsJPG'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsLength'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIs70_70'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsStartEnd'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTare'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPartion'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsGoodsName'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateStart'
        Value = 43101d
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateTare'
        Value = 43101d
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDatePack'
        Value = 43101d
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateProduction'
        Value = 43101d
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumPack'
        Value = 1.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumTech'
        Value = 1.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 647
    Top = 64
  end
end
