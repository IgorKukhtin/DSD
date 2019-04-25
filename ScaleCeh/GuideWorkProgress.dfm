object GuideWorkProgressForm: TGuideWorkProgressForm
  Left = 578
  Top = 242
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1072#1088#1090#1080#1080' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072'>'
  ClientHeight = 424
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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object GridPanel: TPanel
    Left = 0
    Top = 41
    Width = 790
    Height = 383
    Align = alClient
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
      Width = 790
      Height = 350
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
            Column = CuterCount
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = CuterWeight_total
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Cuter_diff
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = CuterWeight
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = CuterWeight_current
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = RealWeight
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = RealWeight_current
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = RealWeight_total
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Real_diff
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = ',0.####'
            Kind = skSum
            Column = CuterCount
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = CuterWeight_total
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Cuter_diff
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = CuterWeight
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = CuterWeight_current
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = RealWeight
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = RealWeight_current
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = RealWeight_total
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Real_diff
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
        object colStatus: TcxGridDBColumn
          Caption = #1057#1090#1072#1090#1091#1089
          DataBinding.FieldName = 'StatusCode'
          PropertiesClassName = 'TcxImageComboBoxProperties'
          Properties.Images = dmMain.ImageList
          Properties.Items = <
            item
              Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
              ImageIndex = 11
              Value = 1
            end
            item
              Description = #1055#1088#1086#1074#1077#1076#1077#1085
              ImageIndex = 12
              Value = 2
            end
            item
              Description = #1059#1076#1072#1083#1077#1085
              ImageIndex = 13
              Value = 3
            end>
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 50
        end
        object colInvNumber: TcxGridDBColumn
          Caption = #8470' '#1044#1086#1082
          DataBinding.FieldName = 'InvNumber'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object colOperDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072
          DataBinding.FieldName = 'OperDate'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
        object GoodsCode: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'GoodsCode'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 45
        end
        object GoodsName: TcxGridDBColumn
          Caption = #1058#1086#1074#1072#1088
          DataBinding.FieldName = 'GoodsName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 150
        end
        object colMeasureName: TcxGridDBColumn
          Caption = #1045#1076'. '#1080#1079#1084'.'
          DataBinding.FieldName = 'MeasureName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 40
        end
        object colGoodsKindName: TcxGridDBColumn
          Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
          DataBinding.FieldName = 'GoodsKindName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object colGoodsKindName_Complete: TcxGridDBColumn
          Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055
          DataBinding.FieldName = 'GoodsKindName_Complete'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object Cuter_diff: TcxGridDBColumn
          Caption = #1056#1072#1079#1085#1080#1094#1072' '#1074#1077#1089' '#1082#1091#1090#1090#1077#1088
          DataBinding.FieldName = 'Cuter_diff'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1056#1072#1079#1085#1080#1094#1072' '#1074#1077#1089' '#1082#1091#1090#1090#1077#1088' ('#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077')'
          Width = 70
        end
        object Real_diff: TcxGridDBColumn
          Caption = #1056#1072#1079#1085#1080#1094#1072' '#1074#1077#1089' '#1089#1099#1088#1086#1081
          DataBinding.FieldName = 'Real_diff'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1056#1072#1079#1085#1080#1094#1072' '#1074#1077#1089' '#1089#1099#1088#1086#1081' ('#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077')'
          Width = 70
        end
        object CuterCount: TcxGridDBColumn
          Caption = #1050#1091#1090#1090#1077#1088#1086#1074' '#1092#1072#1082#1090
          DataBinding.FieldName = 'CuterCount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
          Options.Editing = False
          Width = 60
        end
        object Amount: TcxGridDBColumn
          Caption = #1050#1086#1083'-'#1074#1086' '#1092#1072#1082#1090
          DataBinding.FieldName = 'Amount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
          Options.Editing = False
          Width = 70
        end
        object CuterWeight_total: TcxGridDBColumn
          Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1082#1091#1090#1090#1077#1088
          DataBinding.FieldName = 'CuterWeight_total'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1082#1091#1090#1090#1077#1088' ('#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077')'
          Width = 80
        end
        object RealWeight_total: TcxGridDBColumn
          Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1089#1099#1088#1086#1081
          DataBinding.FieldName = 'RealWeight_total'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1089#1099#1088#1086#1081' ('#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077')'
          Width = 80
        end
        object CuterWeight_current: TcxGridDBColumn
          Caption = #1053#1077' '#1079#1072#1082#1088#1099#1090' '#1074#1077#1089' '#1082#1091#1090#1090#1077#1088
          DataBinding.FieldName = 'CuterWeight_current'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1053#1077' '#1079#1072#1082#1088#1099#1090' '#1074#1077#1089' '#1082#1091#1090#1090#1077#1088' ('#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077')'
          Width = 70
        end
        object RealWeight_current: TcxGridDBColumn
          Caption = #1053#1077' '#1079#1072#1082#1088#1099#1090' '#1074#1077#1089' '#1089#1099#1088#1086#1081
          DataBinding.FieldName = 'RealWeight_current'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1053#1077' '#1079#1072#1082#1088#1099#1090' '#1074#1077#1089' '#1089#1099#1088#1086#1081' ('#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077')'
          Width = 70
        end
        object CuterWeight: TcxGridDBColumn
          Caption = #1047#1072#1082#1088#1099#1090' '#1074#1077#1089' '#1082#1091#1090#1090#1077#1088
          DataBinding.FieldName = 'CuterWeight'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1047#1072#1082#1088#1099#1090' '#1074#1077#1089' '#1082#1091#1090#1090#1077#1088' ('#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077')'
          Options.Editing = False
          Width = 75
        end
        object RealWeight: TcxGridDBColumn
          Caption = #1047#1072#1082#1088#1099#1090' '#1074#1077#1089' '#1089#1099#1088#1086#1081
          DataBinding.FieldName = 'RealWeight'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Properties.ReadOnly = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1047#1072#1082#1088#1099#1090' '#1074#1077#1089' '#1089#1099#1088#1086#1081' ('#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077')'
          Options.Editing = False
          Width = 75
        end
        object colReceiptCode: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'.'
          DataBinding.FieldName = 'ReceiptCode'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object colReceiptName: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
          DataBinding.FieldName = 'ReceiptName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 90
        end
        object colInsertName: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
          DataBinding.FieldName = 'InsertName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 100
        end
        object colUpdateName: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
          DataBinding.FieldName = 'UpdateName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 110
        end
        object colInsertDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
          DataBinding.FieldName = 'InsertDate'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 90
        end
        object colUpdateDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
          DataBinding.FieldName = 'UpdateDate'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 110
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
    Width = 790
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object gbGoodsCode: TGroupBox
      Left = 0
      Top = 0
      Width = 137
      Height = 41
      Align = alLeft
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
        OnKeyDown = EditGoodsCodeKeyDown
        OnKeyPress = EditGoodsCodeKeyPress
      end
    end
    object gbGoodsName: TGroupBox
      Left = 137
      Top = 0
      Width = 653
      Height = 41
      Align = alClient
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077
      TabOrder = 1
      object EditGoodsName: TEdit
        Left = 5
        Top = 17
        Width = 332
        Height = 22
        TabOrder = 0
        Text = 'EditGoodsName'
        OnChange = EditGoodsNameChange
        OnEnter = EditGoodsNameEnter
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
    OnFilterRecord = CDSFilterRecord
    Left = 224
    Top = 352
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
    Left = 336
    Top = 264
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
