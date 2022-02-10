object GuideGoodsRemainsForm: TGuideGoodsRemainsForm
  Left = 578
  Top = 242
  Caption = #1055#1086#1076#1073#1086#1088' '#1086#1089#1090#1072#1090#1082#1072' <'#1058#1086#1074#1072#1088'>'
  ClientHeight = 471
  ClientWidth = 859
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object GridPanel: TPanel
    Left = 0
    Top = 41
    Width = 859
    Height = 430
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 619
    object ButtonPanel: TPanel
      Left = 0
      Top = 0
      Width = 859
      Height = 33
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 619
      object bbExit: TSpeedButton
        Left = 443
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
        Left = 241
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
      object bbChoice: TSpeedButton
        Left = 67
        Top = 3
        Width = 31
        Height = 29
        Action = actChoice
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
      Width = 859
      Height = 397
      Align = alClient
      TabOrder = 1
      ExplicitWidth = 619
      object cxDBGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = DS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount_Remains_Weighing
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount_Remains_Weighing
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
        object GoodsCode: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'GoodsCode'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object GoodsName: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'GoodsName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 250
        end
        object GoodsKindName: TcxGridDBColumn
          Caption = #1042#1080#1076
          DataBinding.FieldName = 'GoodsKindName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 150
        end
        object PartionGoodsName: TcxGridDBColumn
          Caption = #1055#1072#1088#1090#1080#1103
          DataBinding.FieldName = 'PartionGoodsName'
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
        object Amount_Remains: TcxGridDBColumn
          Caption = #1054#1089#1090#1072#1090#1086#1082
          DataBinding.FieldName = 'Amount_Remains'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object Amount_Remains_Weighing: TcxGridDBColumn
          Caption = #1054#1089#1090#1072#1090#1086#1082' ('#1074#1077#1089')'
          DataBinding.FieldName = 'Amount_Remains_Weighing'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object GoodsGroupNameFull: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072
          DataBinding.FieldName = 'GoodsGroupNameFull'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 250
        end
      end
      object cxDBGridLevel: TcxGridLevel
        GridView = cxDBGridDBTableView
      end
    end
  end
  object ParamsPanel: TPanel
    Left = 0
    Top = 0
    Width = 859
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 619
    object gbGoodsCode: TGroupBox
      Left = 0
      Top = 0
      Width = 137
      Height = 41
      Align = alLeft
      Caption = #1050#1086#1076
      TabOrder = 0
      object EditGoodsCode: TEdit
        Left = 6
        Top = 16
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
    object gbGoodsName: TGroupBox
      Left = 137
      Top = 0
      Width = 722
      Height = 41
      Align = alClient
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077
      TabOrder = 1
      ExplicitWidth = 482
      object EditGoodsName: TEdit
        Left = 0
        Top = 16
        Width = 332
        Height = 22
        TabOrder = 0
        Text = 'EditGoodsName'
        OnChange = EditGoodsNameChange
        OnEnter = EditGoodsNameEnter
        OnExit = EditGoodsCodeExit
        OnKeyDown = EditGoodsNameKeyDown
        OnKeyPress = EditGoodsNameKeyPress
      end
    end
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 168
    Top = 360
  end
  object spSelect: TdsdStoredProc
    DataSet = CDS
    DataSets = <
      item
        DataSet = CDS
      end>
    Params = <>
    PackSize = 1
    Left = 264
    Top = 296
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
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
    PropertiesCellList = <>
    Left = 80
    Top = 144
  end
  object ActionList: TActionList
    Left = 384
    Top = 168
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
  end
end
