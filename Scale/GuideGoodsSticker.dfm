object GuideGoodsStickerForm: TGuideGoodsStickerForm
  Left = 578
  Top = 242
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1088#1086#1076#1091#1082#1094#1080#1080
  ClientHeight = 665
  ClientWidth = 790
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
    Top = 252
    Width = 790
    Height = 413
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object ButtonPanel: TPanel
      Left = 0
      Top = 0
      Width = 790
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
      Width = 790
      Height = 380
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
        OptionsView.ColumnAutoWidth = True
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object GoodsCode: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1090#1086#1074'.'
          DataBinding.FieldName = 'GoodsCode'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 35
        end
        object GoodsName: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'GoodsName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 100
        end
        object GoodsKindCode: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1087#1072#1082'.'
          DataBinding.FieldName = 'GoodsKindCode'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 25
        end
        object GoodsKindName: TcxGridDBColumn
          Caption = #1042#1080#1076' '#1087#1072#1082#1091#1074#1072#1085#1085#1103
          DataBinding.FieldName = 'GoodsKindName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          VisibleForCustomization = False
          Width = 55
        end
        object StickerSkinName: TcxGridDBColumn
          Caption = #1054#1073#1086#1083#1086#1095#1082#1072
          DataBinding.FieldName = 'StickerSkinName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object GoodsKindName_complete: TcxGridDBColumn
          Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
          DataBinding.FieldName = 'GoodsKindName_complete'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object MeasureName: TcxGridDBColumn
          Caption = #1045#1076'. '#1080#1079#1084'.'
          DataBinding.FieldName = 'MeasureName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 25
        end
        object Amount_Weighing: TcxGridDBColumn
          Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1087#1077#1095#1072#1090#1080
          DataBinding.FieldName = 'Amount_Weighing'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          VisibleForCustomization = False
          Width = 50
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
    Width = 790
    Height = 244
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object PreviewPanel: TPanel
      Left = 0
      Top = 0
      Width = 320
      Height = 244
      Align = alClient
      TabOrder = 2
      object frxPreview1: TfrxPreview
        Left = 1
        Top = 1
        Width = 318
        Height = 242
        Align = alClient
        OutlineVisible = False
        OutlineWidth = 120
        ThumbnailVisible = False
        UseReportHints = True
      end
    end
    object cxSplitter1: TcxSplitter
      Left = 320
      Top = 0
      Width = 8
      Height = 244
      AlignSplitter = salRight
      AllowHotZoneDrag = False
      Control = ParamsAllPanel
    end
    object ParamsPanel: TPanel
      Left = 328
      Top = 0
      Width = 462
      Height = 244
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object infoPanelTare: TPanel
        Left = 240
        Top = 0
        Width = 137
        Height = 244
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 2
        Visible = False
        object rgTareWeight: TRadioGroup
          Left = 0
          Top = 82
          Width = 137
          Height = 77
          Align = alClient
          Caption = #1058#1072#1088#1072' '#1074#1077#1089
          Color = clBtnFace
          Columns = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 2
          OnClick = rgTareWeightClick
        end
        object PanelTare: TPanel
          Left = 0
          Top = 0
          Width = 137
          Height = 41
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object gbTareCount: TGroupBox
            Left = 0
            Top = 0
            Width = 79
            Height = 41
            Align = alClient
            Caption = #1050#1086#1083'-'#1074#1086' '#1090#1072#1088#1099
            TabOrder = 0
            object EditTareCount: TEdit
              Left = 5
              Top = 17
              Width = 100
              Height = 22
              TabOrder = 0
              Text = 'EditTareCount'
              OnEnter = EditTareCountEnter
              OnExit = EditTareCountExit
              OnKeyPress = EditTareCountKeyPress
            end
          end
          object gbTareWeightCode: TGroupBox
            Left = 79
            Top = 0
            Width = 58
            Height = 41
            Align = alRight
            Caption = #1050#1086#1076' '#1074#1077#1089
            TabOrder = 1
            object EditTareWeightCode: TEdit
              Left = 5
              Top = 17
              Width = 60
              Height = 22
              TabOrder = 0
              Text = 'EditTareWeightCode'
              OnChange = EditTareWeightCodeChange
              OnEnter = EditTareCountEnter
              OnExit = EditTareWeightCodeExit
              OnKeyPress = EditTareWeightCodeKeyPress
            end
          end
        end
        object infoPanelChangePercentAmount: TPanel
          Left = 0
          Top = 159
          Width = 137
          Height = 85
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 3
          object rgChangePercentAmount: TRadioGroup
            Left = 0
            Top = 41
            Width = 137
            Height = 44
            Align = alClient
            Caption = #1057#1082#1080#1076#1082#1072' '#1087#1086' '#1074#1077#1089#1091
            Color = clBtnFace
            Columns = 3
            ParentColor = False
            TabOrder = 1
            OnClick = rgChangePercentAmountClick
            OnEnter = rgChangePercentAmountClick
          end
          object gbChangePercentAmountCode: TGroupBox
            Left = 0
            Top = 0
            Width = 137
            Height = 41
            Align = alTop
            Caption = #1050#1086#1076' '#1089#1082#1080#1076#1082#1080
            TabOrder = 0
            object EditChangePercentAmountCode: TEdit
              Left = 5
              Top = 17
              Width = 100
              Height = 22
              TabOrder = 0
              Text = 'EditChangePercentAmountCode'
              OnChange = EditChangePercentAmountCodeChange
              OnEnter = EditTareCountEnter
              OnExit = EditChangePercentAmountCodeExit
              OnKeyPress = EditChangePercentAmountCodeKeyPress
            end
          end
        end
        object gbTareWeightEnter: TGroupBox
          Left = 0
          Top = 41
          Width = 137
          Height = 41
          Align = alTop
          Caption = #1042#1077#1089' '#1090#1072#1088#1099
          TabOrder = 1
          object EditTareWeightEnter: TEdit
            Left = 5
            Top = 17
            Width = 100
            Height = 22
            TabOrder = 0
            Text = 'EditTareWeightEnter'
            OnEnter = EditTareCountEnter
            OnExit = EditTareWeightEnterExit
          end
        end
      end
      object infoPanelPriceList: TPanel
        Left = 377
        Top = 0
        Width = 85
        Height = 244
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 3
        Visible = False
        object rgPriceList: TRadioGroup
          Left = 0
          Top = 41
          Width = 85
          Height = 203
          Align = alClient
          Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
          OnClick = rgPriceListClick
          OnEnter = rgPriceListClick
        end
        object gbPriceListCode: TGroupBox
          Left = 0
          Top = 0
          Width = 85
          Height = 41
          Align = alTop
          Caption = #1050#1086#1076
          TabOrder = 0
          object EditPriceListCode: TEdit
            Left = 5
            Top = 17
            Width = 140
            Height = 22
            TabOrder = 0
            Text = 'EditPriceListCode'
            OnChange = EditPriceListCodeChange
            OnEnter = EditTareCountEnter
            OnExit = EditPriceListCodeExit
            OnKeyPress = EditPriceListCodeKeyPress
          end
        end
      end
      object infoPanelGoods: TPanel
        Left = 0
        Top = 0
        Width = 135
        Height = 244
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object gbGoodsName: TGroupBox
          Left = 0
          Top = 41
          Width = 135
          Height = 41
          Align = alTop
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          TabOrder = 1
          object EditGoodsName: TEdit
            Left = 5
            Top = 17
            Width = 125
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
          Width = 135
          Height = 41
          Align = alTop
          Caption = #1050#1086#1076
          TabOrder = 0
          object EditGoodsCode: TEdit
            Left = 5
            Top = 17
            Width = 125
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
          Top = 123
          Width = 135
          Height = 41
          Align = alTop
          Caption = #1042#1077#1089' '#1085#1072' '#1058#1072#1073#1083#1086
          TabOrder = 2
          Visible = False
          object PanelGoodsWieghtValue: TPanel
            Left = 2
            Top = 16
            Width = 131
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
        object gbWeightValue: TGroupBox
          Left = 0
          Top = 82
          Width = 135
          Height = 41
          Align = alTop
          Caption = #1042#1074#1086#1076' '#1050#1054#1051#1048#1063#1045#1057#1058#1042#1054
          TabOrder = 3
          object EditWeightValue: TcxCurrencyEdit
            Left = 5
            Top = 18
            EditValue = 2.000000000000000000
            Properties.Alignment.Horz = taRightJustify
            Properties.Alignment.Vert = taVCenter
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 0
            TabOrder = 0
            OnEnter = EditTareCountEnter
            OnExit = EditWeightValueExit
            OnKeyDown = EditWeightValueKeyDown
            Width = 125
          end
        end
      end
      object infoPanelGoodsKind: TPanel
        Left = 135
        Top = 0
        Width = 105
        Height = 244
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object rgGoodsKind: TRadioGroup
          Left = 0
          Top = 41
          Width = 105
          Height = 203
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
          Width = 105
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
    end
  end
  object cxSplitter2: TcxSplitter
    Left = 0
    Top = 244
    Width = 790
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
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
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
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 84
    Top = 49
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
        Value = '1370933'
        ComponentItem = 'Id'
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
        Name = 'inIsDataProduction'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTara'
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
        Name = 'inIsDataPartion'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDataTara'
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
        Name = 'inDateUpack'
        Value = 43101d
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateTara'
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
        Name = 'inNumUpack'
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
  object frxDBDHeader1: TfrxDBDataset
    UserName = 'frxDBDHeader'
    CloseDataSource = False
    DataSet = PrintHeaderCDS
    BCDToCurrency = False
    Left = 80
    Top = 112
  end
end
