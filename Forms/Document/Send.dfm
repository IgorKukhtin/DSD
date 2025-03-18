inherited SendForm: TSendForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>'
  ClientHeight = 658
  ClientWidth = 1186
  ExplicitWidth = 1202
  ExplicitHeight = 697
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 118
    Width = 1186
    Height = 540
    ExplicitTop = 118
    ExplicitWidth = 1186
    ExplicitHeight = 540
    ClientRectBottom = 540
    ClientRectRight = 1186
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1186
      ExplicitHeight = 516
      inherited cxGrid: TcxGrid
        Width = 1186
        Height = 516
        ExplicitWidth = 1186
        ExplicitHeight = 516
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
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
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = HeadCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_child_sec
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Diff
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
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
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = HeadCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_child_sec
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Diff
            end>
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsGroupNameFull: TcxGridDBColumn [0]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode: TcxGridDBColumn [1]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object GoodsName: TcxGridDBColumn [2]
            Caption = #1058#1086#1074#1072#1088' / '#1054#1057
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1086#1074#1072#1088' '#1080#1083#1080' '#1054#1089#1085#1086#1074#1085#1099#1077' '#1089#1088#1077#1076#1089#1090#1074#1072
            Width = 182
          end
          object GoodsName_old: TcxGridDBColumn [3]
            Caption = '***'#1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName_old'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1072#1088#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077
            Options.Editing = False
            Width = 80
          end
          object GoodsKindName: TcxGridDBColumn [4]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object PartionGoodsDate: TcxGridDBColumn [5]
            Caption = #1055#1072#1088#1090#1080#1103' ('#1076#1072#1090#1072')'
            DataBinding.FieldName = 'PartionGoodsDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.SaveTime = False
            Properties.ShowTime = False
            Properties.UseNullString = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 84
          end
          object GoodsKindName_Complete: TcxGridDBColumn [6]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055
            DataBinding.FieldName = 'GoodsKindName_Complete'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindCompleteChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object PartionGoods: TcxGridDBColumn [7]
            Caption = #1055#1072#1088#1090#1080#1103' / '#1048#1085#1074#1077#1085#1090'.'#8470
            DataBinding.FieldName = 'PartionGoods'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPartionGoodsChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object PartNumber: TcxGridDBColumn [8]
            Caption = #8470' '#1087#1086' '#1090#1077#1093' '#1087#1072#1089#1087#1086#1088#1090#1091
            DataBinding.FieldName = 'PartNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object PartionModelName: TcxGridDBColumn [9]
            Caption = #1052#1086#1076#1077#1083#1100' ('#1087#1072#1088#1090#1080#1103')'
            DataBinding.FieldName = 'PartionModelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object isPeresort: TcxGridDBColumn [10]
            Caption = #1055#1077#1088#1077#1089#1086#1088#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPeresort'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MeasureName: TcxGridDBColumn [11]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object AmountRemains: TcxGridDBColumn [12]
            Caption = #1054#1089#1090'. '#1082#1086#1083'-'#1074#1086' '
            DataBinding.FieldName = 'AmountRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Amount: TcxGridDBColumn [13]
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Count: TcxGridDBColumn [14]
            Caption = #1050#1086#1083'-'#1074#1086' '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'Count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object HeadCount: TcxGridDBColumn [15]
            Caption = #1050#1086#1083'. '#1075#1086#1083#1086#1074
            DataBinding.FieldName = 'HeadCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object UnitName: TcxGridDBColumn [16]
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1087#1072#1088#1090#1080#1103' '#1058#1052#1062')'
            DataBinding.FieldName = 'UnitName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actUnitChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object StorageName: TcxGridDBColumn [17]
            Caption = #1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1087#1072#1088#1090#1080#1103' '#1058#1052#1062')'
            DataBinding.FieldName = 'StorageName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actStorageChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object Price: TcxGridDBColumn [18]
            Caption = #1062#1077#1085#1072' ('#1087#1072#1088#1090#1080#1103' '#1058#1052#1062')'
            DataBinding.FieldName = 'Price'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object AssetCode: TcxGridDBColumn [19]
            Caption = #1050#1086#1076' ('#1074#1099#1088'. '#1085#1072' '#1086#1073#1086#1088#1091#1076'.1)'
            DataBinding.FieldName = 'AssetCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AssetName: TcxGridDBColumn [20]
            Caption = #1042#1099#1088#1072#1073#1086#1090#1082#1072' '#1085#1072' '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1080' 1'
            DataBinding.FieldName = 'AssetName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actAssetChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1088#1072#1073#1086#1090#1082#1072' '#1085#1072' '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1080' 1'
            Width = 70
          end
          object AssetCode_two: TcxGridDBColumn [21]
            Caption = #1050#1086#1076' ('#1074#1099#1088'. '#1085#1072' '#1086#1073#1086#1088#1091#1076'.2)'
            DataBinding.FieldName = 'AssetCode_two'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AssetName_two: TcxGridDBColumn [22]
            Caption = #1042#1099#1088#1072#1073#1086#1090#1082#1072' '#1085#1072' '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1080' 2'
            DataBinding.FieldName = 'AssetName_two'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actAsset_twoChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1088#1072#1073#1086#1090#1082#1072' '#1085#1072' '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1080' 2'
            Width = 70
          end
          object InfoMoneyCode: TcxGridDBColumn [23]
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object InfoMoneyGroupName: TcxGridDBColumn [24]
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyDestinationName: TcxGridDBColumn [25]
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName: TcxGridDBColumn [26]
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Amount_child_sec: TcxGridDBColumn [27]
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1076#1083#1103' '#1079#1072#1103#1074#1086#1082
            DataBinding.FieldName = 'Amount_child_sec'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1076#1083#1103' '#1079#1072#1103#1074#1086#1082
            Options.Editing = False
            Width = 104
          end
          object Amount_Diff: TcxGridDBColumn [28]
            Caption = #1054#1090#1082#1083'. '#1088#1077#1079#1077#1088#1074#1072' '#1086#1090' '#1087#1077#1088#1077#1084'-'#1103
            DataBinding.FieldName = 'Amount_Diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1082#1083'. '#1088#1077#1079#1077#1088#1074#1072' '#1086#1090' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
            Options.Editing = False
            Width = 87
          end
          object InDate: TcxGridDBColumn [29]
            Caption = #1044#1072#1090#1072' '#1087#1088'. '#1086#1090' '#1087#1086#1089#1090'. '
            DataBinding.FieldName = 'InDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1087#1086#1089#1083#1077#1076#1085#1077#1075#1086' '#1087#1088#1080#1093#1086#1076#1072' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 80
          end
          object PartnerInName: TcxGridDBColumn [30]
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'PartnerInName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1089#1090#1072#1074#1097#1080#1082' '#1087#1086#1089#1083#1077#1076#1085#1077#1075#1086' '#1087#1088#1080#1093#1086#1076#1072
            Options.Editing = False
            Width = 80
          end
          object PartionGoodsId: TcxGridDBColumn [31]
            DataBinding.FieldName = 'PartionGoodsId'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
    end
    object cxTabSheetDetail: TcxTabSheet
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086
      ImageIndex = 1
      object cxGridDetail: TcxGrid
        Left = 0
        Top = 0
        Width = 1186
        Height = 516
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 0
        object cxGridDBTableViewDetail: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DetailDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ch2
            end
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
            end
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
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ch2
            end
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
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Kind = skSum
            end
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
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName_ch2
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object ord: TcxGridDBColumn
            Caption = #8470' '#1087'.'#1087'.'
            DataBinding.FieldName = 'ord'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object GoodsGroupNameFull_ch2: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode_ch2: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object GoodsName_ch2: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' / '#1054#1057
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actAssetGoodsChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 182
          end
          object GoodsKindName_ch2: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object MeasureName_ch2: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object Amount_ch2: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ReturnKindName_ch2: TcxGridDBColumn
            Caption = #1058#1080#1087
            DataBinding.FieldName = 'ReturnKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actReturnKindOpenForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 159
          end
          object SubjectDocName_ch2: TcxGridDBColumn
            Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
            DataBinding.FieldName = 'SubjectDocName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actSubjectDocOpenForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 166
          end
          object isErased_ch2: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
        end
        object cxGridLevelDetail: TcxGridLevel
          GridView = cxGridDBTableViewDetail
        end
      end
    end
    object cxTabSheetChild: TcxTabSheet
      Caption = #1056#1072#1089#1093#1086#1076' '#1085#1072' '#1087#1088#1086#1080#1079#1074'.'
      ImageIndex = 2
      object cxGridChild: TcxGrid
        Left = 0
        Top = 0
        Width = 1186
        Height = 516
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 0
        object cxGridDBTableViewChild: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ch3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_master_ch3
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ch3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_master_ch3
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object ord_ch3: TcxGridDBColumn
            Caption = #8470' '#1087'.'#1087'.'
            DataBinding.FieldName = 'ord'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object GoodsGroupNameFull_ch3: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode_ch3: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object GoodsName_ch3: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' / '#1054#1057
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 182
          end
          object GoodsKindName_ch3: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object MeasureName_ch3: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object Amount_ch3: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ReturnKindName_ch3: TcxGridDBColumn
            Caption = #1058#1080#1087
            DataBinding.FieldName = 'ReturnKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 159
          end
          object isErased_ch3: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object GoodsCode_master_ch3: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'GoodsCode_master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object GoodsName_master_ch3: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' / '#1054#1057' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'GoodsName_master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 182
          end
          object GoodsKindName_master_ch3: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Amount_master_ch3: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'Amount_master'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableViewChild
        end
      end
    end
    object cxTabSheet_PartionCell: TcxTabSheet
      Caption = #1054#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1071#1095#1077#1081#1082#1072#1084' '#1093#1088#1072#1085#1077#1085#1080#1103
      ImageIndex = 3
      object cxGrid_PartionCell: TcxGrid
        Left = 0
        Top = 0
        Width = 1186
        Height = 516
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 0
        object cxGridDBTableView_PartionCell: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = PartionCellDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ch4
            end
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
            end
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
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_ch4
            end
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
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Kind = skSum
            end
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
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName_ch4
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object GoodsGroupNameFull_ch4: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode_ch4: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object GoodsName_ch4: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' / '#1054#1057
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actAssetGoodsChoiceFormPC
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 182
          end
          object GoodsKindName_ch4GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoicePC
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object MeasureName_ch4: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object PartionGoodsDate_ch4: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' ('#1076#1072#1090#1072')'
            DataBinding.FieldName = 'PartionGoodsDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.SaveTime = False
            Properties.ShowTime = False
            Properties.UseNullString = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object Amount_ch4: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PartionCellName_1_ch4: TcxGridDBColumn
            Caption = '1.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_1'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm1
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-1 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 68
          end
          object PartionCellName_2_ch4: TcxGridDBColumn
            Caption = '2.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_2'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm2
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-2 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 68
          end
          object PartionCellName_3_ch4: TcxGridDBColumn
            Caption = '3.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_3'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm3
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-3 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 68
          end
          object PartionCellName_4_ch4: TcxGridDBColumn
            Caption = '4.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_4'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm4
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-4 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 68
          end
          object PartionCellName_5_ch4: TcxGridDBColumn
            Caption = '5.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_5'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm5
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-5 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 68
          end
          object PartionCellName_6_ch4: TcxGridDBColumn
            Caption = '6.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_6'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm6
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-6 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 68
          end
          object PartionCellName_7_ch4: TcxGridDBColumn
            Caption = '7.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_7'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm7
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-7 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 68
          end
          object PartionCellName_8_ch4: TcxGridDBColumn
            Caption = '8.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_8'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm8
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-8 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 68
          end
          object PartionCellName_9_ch4: TcxGridDBColumn
            Caption = '9.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_9'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm9
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-9 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 68
          end
          object PartionCellName_10_ch4: TcxGridDBColumn
            Caption = '10.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_10'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm10
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-10 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 68
          end
          object PartionCellName_11_ch4: TcxGridDBColumn
            Caption = '11.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_11'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm11
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-11 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 68
          end
          object PartionCellName_12_ch4: TcxGridDBColumn
            Caption = '12.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_12'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenPartionCellForm12
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-12 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Width = 68
          end
          object PartionCellName_13_ch4: TcxGridDBColumn
            Caption = '13.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_13'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-13 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_14_ch4: TcxGridDBColumn
            Caption = '14.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_14'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-14 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_15_ch4: TcxGridDBColumn
            Caption = '15.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_15'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-15 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_16_ch4: TcxGridDBColumn
            Caption = '16.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_16'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-16 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_17_ch4: TcxGridDBColumn
            Caption = '17.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_17'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-17 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_18_ch4: TcxGridDBColumn
            Caption = '18.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_18'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-18 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_19_ch4: TcxGridDBColumn
            Caption = '19.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_19'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-19 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_20_ch4: TcxGridDBColumn
            Caption = '20.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_20'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-20 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_21_ch4: TcxGridDBColumn
            Caption = '21.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_21'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-21 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_22_ch4: TcxGridDBColumn
            Caption = '22.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_22'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-22 '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1055#1072#1088#1090#1080#1103' '#1091#1095#1077#1090#1072')'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_1_ch4: TcxGridDBColumn
            Caption = '1.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-51 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_2_ch4: TcxGridDBColumn
            Caption = '2.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-2 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_3_ch4: TcxGridDBColumn
            Caption = '3.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-3 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_4_ch4: TcxGridDBColumn
            Caption = '4.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_4'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-4 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_5_ch4: TcxGridDBColumn
            Caption = '5.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_5'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-5 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_6_ch4: TcxGridDBColumn
            Caption = '6.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_6'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-6 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_7_ch4: TcxGridDBColumn
            Caption = '7.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_7'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-7 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_8_ch4: TcxGridDBColumn
            Caption = '8.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_8'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-8 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_9_ch4: TcxGridDBColumn
            Caption = '9.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_9'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-9 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_10_ch4: TcxGridDBColumn
            Caption = '10.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_10'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-10 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_11_ch4: TcxGridDBColumn
            Caption = '11.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_11'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-11 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_12_ch4: TcxGridDBColumn
            Caption = '12.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_12'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-12 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_13_ch4: TcxGridDBColumn
            Caption = '13.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_13'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-13 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_14_ch4: TcxGridDBColumn
            Caption = '14.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_14'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-14 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_15_ch4: TcxGridDBColumn
            Caption = '15.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_15'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-15 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_16_ch4: TcxGridDBColumn
            Caption = '16.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_16'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-16 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_17_ch4: TcxGridDBColumn
            Caption = '17.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_17'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-17 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_18_ch4: TcxGridDBColumn
            Caption = '18.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_18'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-18 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_19_ch4: TcxGridDBColumn
            Caption = '19.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_19'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-19 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_20_ch4: TcxGridDBColumn
            Caption = '20.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_20'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-20 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_21_ch4: TcxGridDBColumn
            Caption = '21.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_21'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-21 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object PartionCellName_real_22_ch4: TcxGridDBColumn
            Caption = '22.4 '#1071#1095#1077#1081#1082#1072' ('#1089#1090#1072#1088#1090')'
            DataBinding.FieldName = 'PartionCellName_real_22'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1071#1095#1077#1081#1082#1072'-22 ('#1089#1090#1072#1088#1090', '#1076#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1084#1077#1089#1090#1086' '#1086#1090#1073#1086#1088#1072'")'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_1_ch4: TcxGridDBColumn
            Caption = '1.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_1'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-1('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_2_ch4: TcxGridDBColumn
            Caption = '2.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_2'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-2('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_3_ch4: TcxGridDBColumn
            Caption = '3.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_3'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-3('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_4_ch4: TcxGridDBColumn
            Caption = '4.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_4'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-4('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_5_ch4: TcxGridDBColumn
            Caption = '5.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_5'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-5('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_6_ch4: TcxGridDBColumn
            Caption = '6.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_6'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-6('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_7_ch4: TcxGridDBColumn
            Caption = '7.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_7'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-7('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_8_ch4: TcxGridDBColumn
            Caption = '8.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_8'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-8('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_9_ch4: TcxGridDBColumn
            Caption = '9.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_9'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-9('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_10_ch4: TcxGridDBColumn
            Caption = '10.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_10'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-10('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_11_ch4: TcxGridDBColumn
            Caption = '11.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_11'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-11('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_12_ch4: TcxGridDBColumn
            Caption = '12.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_12'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-12('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_13_ch4: TcxGridDBColumn
            Caption = '13.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_13'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-13('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_14_ch4: TcxGridDBColumn
            Caption = '14.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_14'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-14('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_15_ch4: TcxGridDBColumn
            Caption = '15.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_15'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-15('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_16_ch4: TcxGridDBColumn
            Caption = '16.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_16'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-16('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_17_ch4: TcxGridDBColumn
            Caption = '17.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_17'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-17('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_18_ch4: TcxGridDBColumn
            Caption = '18.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_18'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-18('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_19_ch4: TcxGridDBColumn
            Caption = '19.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_19'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-19('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_20_ch4: TcxGridDBColumn
            Caption = '20.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_20'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-20('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_21_ch4: TcxGridDBColumn
            Caption = '21.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_21'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-21('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object isPartionCell_Close_22_ch4: TcxGridDBColumn
            Caption = '22.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_22'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-22('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 68
          end
          object PartionCell_Amount_1_ch4: TcxGridDBColumn
            Caption = '1.3 '#1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'PartionCell_Amount_1'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-1'
            Options.Editing = False
            Width = 130
          end
          object PartionCell_Amount_2_ch4: TcxGridDBColumn
            Caption = '2.3 '#1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'PartionCell_Amount_2'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-2'
            Options.Editing = False
            Width = 130
          end
          object PartionCell_Amount_3_ch4: TcxGridDBColumn
            Caption = '3.3 '#1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'PartionCell_Amount_3'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-3'
            Options.Editing = False
            Width = 130
          end
          object PartionCell_Amount_4_ch4: TcxGridDBColumn
            Caption = '4.3 '#1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'PartionCell_Amount_4'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-4'
            Options.Editing = False
            Width = 130
          end
          object PartionCell_Amount_5_ch4: TcxGridDBColumn
            Caption = '5.3 '#1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'PartionCell_Amount_5'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-5'
            Options.Editing = False
            Width = 130
          end
          object PartionCell_Amount_6_ch4: TcxGridDBColumn
            Caption = '6.3 '#1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'PartionCell_Amount_6'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-6'
            Options.Editing = False
            Width = 130
          end
          object PartionCell_Amount_7_ch4: TcxGridDBColumn
            Caption = '7.3 '#1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'PartionCell_Amount_7'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-7'
            Options.Editing = False
            Width = 130
          end
          object PartionCell_Amount_8_ch4: TcxGridDBColumn
            Caption = '8.3 '#1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'PartionCell_Amount_8'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-8'
            Options.Editing = False
            Width = 130
          end
          object PartionCell_Amount_9_ch4: TcxGridDBColumn
            Caption = '9.3 '#1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'PartionCell_Amount_9'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-9'
            Options.Editing = False
            Width = 130
          end
          object PartionCell_Amount_10_ch4: TcxGridDBColumn
            Caption = '10.3 '#1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'PartionCell_Amount_10'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-10'
            Options.Editing = False
            Width = 130
          end
          object PartionCell_Amount_11_ch4: TcxGridDBColumn
            Caption = '11.3 '#1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'PartionCell_Amount_11'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-11'
            Options.Editing = False
            Width = 130
          end
          object PartionCell_Amount_12_ch4: TcxGridDBColumn
            Caption = '12.3 '#1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'PartionCell_Amount_12'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1083#1103' '#1071#1095#1077#1081#1082#1072'-12'
            Options.Editing = False
            Width = 130
          end
          object PartionCell_Last_ch4: TcxGridDBColumn
            Caption = #8470' '#1087#1086#1089#1083'. '#1079#1072#1087#1086#1083#1085'. '#1103#1095'.'
            DataBinding.FieldName = 'PartionCell_Last'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1084#1077#1088' '#1103#1095#1077#1081#1082#1080' '#1082#1086#1090#1086#1088#1072#1103' '#1079#1072#1082#1086#1085#1095#1080#1083#1072#1089#1100' '#1074' '#1087#1086#1089#1083#1077#1076#1085#1080#1081' '#1088#1072#1079
            Width = 116
          end
          object isErased_ch4: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
        end
        object cxGridLevel_PartionCell: TcxGridLevel
          GridView = cxGridDBTableView_PartionCell
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1186
    Height = 92
    TabOrder = 3
    ExplicitWidth = 1186
    ExplicitHeight = 92
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 89
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 89
      ExplicitWidth = 84
      Width = 84
    end
    inherited cxLabel2: TcxLabel
      Left = 89
      Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
      ExplicitLeft = 89
      ExplicitWidth = 71
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      Caption = '*'#1057#1090#1072#1090#1091#1089
      ExplicitTop = 45
      ExplicitWidth = 46
    end
    inherited ceStatus: TcxButtonEdit
      Top = 63
      ExplicitTop = 63
      ExplicitWidth = 165
      ExplicitHeight = 22
      Width = 165
    end
    object cxLabel3: TcxLabel
      Left = 179
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object edFrom: TcxButtonEdit
      Left = 179
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 275
    end
    object edTo: TcxButtonEdit
      Left = 460
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Width = 220
    end
    object cxLabel4: TcxLabel
      Left = 460
      Top = 5
      Caption = #1050#1086#1084#1091
    end
    object cxLabel22: TcxLabel
      Left = 1054
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 1054
      Top = 63
      TabOrder = 11
      Width = 114
    end
    object cxLabel8: TcxLabel
      Left = 938
      Top = 5
      Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
    end
    object edInsertDate: TcxDateEdit
      Left = 938
      Top = 23
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 112
    end
    object cxLabel7: TcxLabel
      Left = 1054
      Top = 5
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
    end
    object edInsertName: TcxButtonEdit
      Left = 1054
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 114
    end
    object cxLabel27: TcxLabel
      Left = 460
      Top = 45
      Caption = #8470' '#1076#1086#1082'. '#1086#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
    end
    object edInvNumberSend: TcxButtonEdit
      Left = 460
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ClickKey = 0
      Properties.HideSelection = False
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 220
    end
    object cxLabel9: TcxLabel
      Left = 686
      Top = 45
      Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
    end
    object edSubjectDoc: TcxButtonEdit
      Left = 686
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 19
      Width = 153
    end
    object edInvNumberProduction: TcxButtonEdit
      Left = 936
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 20
      Width = 112
    end
    object cxLabel12: TcxLabel
      Left = 936
      Top = 45
      Caption = #8470' '#1076#1086#1082'. '#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1099
    end
    object cbisRePack: TcxCheckBox
      Left = 300
      Top = 63
      Caption = #1055#1077#1088#1077#1087#1072#1082
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 22
      Width = 67
    end
  end
  object cxLabel6: TcxLabel [2]
    Left = 686
    Top = 5
    Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object edDocumentKind: TcxButtonEdit [3]
    Left = 686
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 153
  end
  object edIsAuto: TcxCheckBox [4]
    Left = 177
    Top = 63
    Caption = #1057#1086#1079#1076#1072#1085' '#1072#1074#1090#1086#1084#1072#1090#1080#1095'.'
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 120
  end
  object cxLabel5: TcxLabel [5]
    Left = 373
    Top = 45
    Caption = #8470' '#1079#1072#1103#1074#1082#1080
  end
  object edInvNumberOrder: TcxButtonEdit [6]
    Left = 373
    Top = 63
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 81
  end
  object cxLabel10: TcxLabel [7]
    Left = 846
    Top = 5
    Caption = #8470' '#1073#1088#1080#1075#1072#1076#1099
  end
  object edPersonalGroup: TcxButtonEdit [8]
    Left = 846
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 85
  end
  object cxLabel11: TcxLabel [9]
    Left = 846
    Top = 45
    Caption = #1058#1080#1087
  end
  object edReturnKind: TcxButtonEdit [10]
    Left = 846
    Top = 63
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 14
    Width = 85
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 171
    Top = 552
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 640
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    object actRefreshPartionCell: TdsdDataSetRefresh [0]
      Category = 'OperDatePartner'
      MoveParams = <>
      StoredProc = spSelect_MI_PartionCell
      StoredProcList = <
        item
          StoredProc = spSelect_MI_PartionCell
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectDetail
        end
        item
          StoredProc = spSelectChild
        end
        item
          StoredProc = spSelect_MI_PartionCell
        end>
      RefreshOnTabSetChanges = True
    end
    object actGetImportSetting2: TdsdExecStoredProc [2]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting2
      StoredProcList = <
        item
          StoredProc = spGetImportSetting2
        end>
      Caption = 'actGetImportSetting'
    end
    object actMISetErasedPC: TdsdUpdateErased [3]
      Category = 'DSDLib'
      TabSheet = cxTabSheet_PartionCell
      MoveParams = <>
      Enabled = False
      StoredProc = spErasedMIPC
      StoredProcList = <
        item
          StoredProc = spErasedMIPC
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = PartionCellDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    inherited actGridToExcel: TdsdGridToExcel
      ShortCut = 16433
    end
    object actGridDetailToExcel: TdsdGridToExcel [5]
      Category = 'DSDLib'
      TabSheet = cxTabSheetDetail
      MoveParams = <>
      Enabled = False
      Grid = cxGridDetail
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16434
    end
    object actGridChildlToExcel: TdsdGridToExcel [6]
      Category = 'DSDLib'
      TabSheet = cxTabSheetChild
      MoveParams = <>
      Enabled = False
      Grid = cxGridChild
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16435
    end
    object actGrid_PartionCelllToExcel: TdsdGridToExcel [7]
      Category = 'DSDLib'
      TabSheet = cxTabSheet_PartionCell
      MoveParams = <>
      Enabled = False
      Grid = cxGrid_PartionCell
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16436
    end
    object macLoadExcel2: TMultiAction [8]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting2
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1092#1072#1081#1083#1072' Excel ('#1040'/B/C/D)?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1092#1072#1081#1083#1072' Excel ('#1040'/B/C/D)'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' Excel ('#1040'/B/C/D)'
      ImageIndex = 41
    end
    object actMISetUnErasedPC: TdsdUpdateErased [9]
      Category = 'DSDLib'
      TabSheet = cxTabSheet_PartionCell
      MoveParams = <>
      Enabled = False
      StoredProc = spUnErasedMIPC
      StoredProcList = <
        item
          StoredProc = spUnErasedMIPC
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = PartionCellDS
    end
    object actMISetErasedDetail: TdsdUpdateErased [10]
      Category = 'DSDLib'
      TabSheet = cxTabSheetDetail
      MoveParams = <>
      Enabled = False
      StoredProc = spErasedMIDetail
      StoredProcList = <
        item
          StoredProc = spErasedMIDetail
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = DetailDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    inherited actMISetErased: TdsdUpdateErased
      TabSheet = tsMain
    end
    object actMISetUnErasedDetail: TdsdUpdateErased [12]
      Category = 'DSDLib'
      TabSheet = cxTabSheetDetail
      MoveParams = <>
      Enabled = False
      StoredProc = spUnErasedMIDetail
      StoredProcList = <
        item
          StoredProc = spUnErasedMIDetail
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DetailDS
    end
    object actShowErasedPC: TBooleanStoredProcAction [13]
      Category = 'DSDLib'
      TabSheet = cxTabSheet_PartionCell
      MoveParams = <>
      Enabled = False
      StoredProc = spSelect_MI_PartionCell
      StoredProcList = <
        item
          StoredProc = spSelect_MI_PartionCell
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    inherited actMISetUnErased: TdsdUpdateErased
      TabSheet = tsMain
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
        end>
    end
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spInsertUpdateMovement_order
        end>
    end
    object actShowErasedDetail: TBooleanStoredProcAction [16]
      Category = 'DSDLib'
      TabSheet = cxTabSheetDetail
      MoveParams = <>
      Enabled = False
      StoredProc = spSelectDetail
      StoredProcList = <
        item
          StoredProc = spSelectDetail
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    inherited actShowErased: TBooleanStoredProcAction
      TabSheet = tsMain
    end
    object actShowAllDetail: TBooleanStoredProcAction [18]
      Category = 'DSDLib'
      TabSheet = cxTabSheetDetail
      MoveParams = <>
      Enabled = False
      StoredProc = spSelectDetail
      StoredProcList = <
        item
          StoredProc = spSelectDetail
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    inherited actShowAll: TBooleanStoredProcAction
      TabSheet = tsMain
    end
    object actUpdatePartionCellDS: TdsdUpdateDataSet [20]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIPartionCell
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIPartionCell
        end
        item
          StoredProc = spSelectDetail
        end>
      Caption = 'actUpdatePartionCellDS'
      DataSource = PartionCellDS
    end
    object actPrintNoGroup: TdsdPrintAction [21]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintNoGroup
      StoredProcList = <
        item
          StoredProc = spSelectPrintNoGroup
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      ImageIndex = 16
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Send'
      ReportNameParam.Value = 'PrintMovement_Send'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actPrint: TdsdPrintAction [22]
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Send'
      ReportNameParam.Value = 'PrintMovement_Send'
    end
    object actUpdateDetailDS: TdsdUpdateDataSet [23]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIDetail
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIDetail
        end
        item
          StoredProc = spSelectDetail
        end>
      Caption = 'actUpdateDetailDS'
      DataSource = DetailDS
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet [24]
    end
    object actOpenPartionCellForm1: TOpenChoiceForm [25]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCell_listForm'
      FormNameParam.Value = 'TPartionCell_listForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellId_1'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellName_1'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenPartionCellForm2: TOpenChoiceForm [26]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TPartionCell_listForm'
      FormName = 'TPartionCell_listForm'
      FormNameParam.Value = 'TPartionCell_listForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellId_2'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellName_2'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenPartionCellForm3: TOpenChoiceForm [27]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCell_listForm'
      FormNameParam.Value = 'TPartionCell_listForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellId_3'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellName_3'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenPartionCellForm4: TOpenChoiceForm [28]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCell_listForm'
      FormNameParam.Value = 'TPartionCell_listForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellId_4'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellName_4'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenPartionCellForm5: TOpenChoiceForm [29]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionCellForm'
      FormName = 'TPartionCell_listForm'
      FormNameParam.Value = 'TPartionCell_listForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellId_5'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellName_5'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actMovementItemContainer: TdsdOpenForm
      TabSheet = tsMain
    end
    object actGoodsKindChoicePC: TOpenChoiceForm [34]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actReturnKindOpenForm: TOpenChoiceForm [35]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ReturnKindForm'
      FormName = 'TReturnKindForm'
      FormNameParam.Value = 'TReturnKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'ReturnKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'ReturnKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actSubjectDocOpenForm: TOpenChoiceForm [36]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TSubjectDocForm'
      FormNameParam.Value = 'TSubjectDocForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'SubjectDocId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'SubjectDocName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actMICellProtocolOpenForm: TdsdOpenForm [37]
      Category = 'DSDLib'
      TabSheet = cxTabSheet_PartionCell
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actAssetChoiceForm: TOpenChoiceForm [38]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TAsset_DocGoodsForm'
      FormNameParam.Value = 'TAsset_DocGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AssetId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AssetName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsKindChoice: TOpenChoiceForm [39]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actAsset_twoChoiceForm: TOpenChoiceForm [40]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TAsset_DocGoodsForm'
      FormNameParam.Value = 'TAsset_DocGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AssetId_two'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AssetName_two'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    inherited MovementItemProtocolOpenForm: TdsdOpenForm
      TabSheet = tsMain
    end
    object actAddMaskDetail: TdsdExecStoredProc [44]
      Category = 'DSDLib'
      TabSheet = cxTabSheetDetail
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      StoredProc = spInsertMaskMIDetail
      StoredProcList = <
        item
          StoredProc = spInsertMaskMIDetail
        end
        item
          StoredProc = spSelectDetail
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      ImageIndex = 54
    end
    inherited actAddMask: TdsdExecStoredProc
      TabSheet = tsMain
    end
    object actOpenPartionCellForm6: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TPartionCell_listForm'
      FormName = 'TPartionCell_listForm'
      FormNameParam.Value = 'TPartionCell_listForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellId_6'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellName_6'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenPartionCellForm7: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TPartionCell_listForm'
      FormName = 'TPartionCell_listForm'
      FormNameParam.Value = 'TPartionCell_listForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellId_7'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellName_7'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenPartionCellForm8: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TPartionCell_listForm'
      FormName = 'TPartionCell_listForm'
      FormNameParam.Value = 'TPartionCell_listForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellId_8'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellName_8'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenPartionCellForm9: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TPartionCell_listForm'
      FormName = 'TPartionCell_listForm'
      FormNameParam.Value = 'TPartionCell_listForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellId_9'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellName_9'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenPartionCellForm10: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TPartionCell_listForm'
      FormName = 'TPartionCell_listForm'
      FormNameParam.Value = 'TPartionCell_listForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellId_10'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellName_10'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenPartionCellForm11: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TPartionCell_listForm'
      FormName = 'TPartionCell_listForm'
      FormNameParam.Value = 'TPartionCell_listForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellId_11'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellName_11'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenPartionCellForm12: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TPartionCell_listForm'
      FormName = 'TPartionCell_listForm'
      FormNameParam.Value = 'TPartionCell_listForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellId_12'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'PartionCellName_12'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actRefreshPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPersonalGroupChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StorageForm'
      ImageIndex = 76
      FormName = 'TPersonalGroupForm'
      FormNameParam.Value = 'TPersonalGroupForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = GuidesPersonalGroup
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = GuidesPersonalGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = edPersonalGroup
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPartionGoodsAssetChoiceForm: TOpenChoiceForm
      Category = 'Asset'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' <'#1054#1057'>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' <'#1054#1057'>'
      ImageIndex = 1
      FormName = 'TPartionGoodsAssetChoiceForm'
      FormNameParam.Value = 'TPartionGoodsAssetChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inGoodsId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitName'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoods'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Price'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Amount'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AmountRemains'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionModelId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionModelId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionModelName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionModelName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StorageId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StorageName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actStorageChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StorageForm'
      FormName = 'TStorage_ObjectForm'
      FormNameParam.Value = 'TStorage_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object OpenChoiceForm1: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsForm'
      FormName = 'TAssetGoods_ObjectForm'
      FormNameParam.Value = 'TAssetGoods_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actAssetGoodsChoiceFormPC: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsForm1'
      FormName = 'TAssetGoods_ObjectForm'
      FormNameParam.Value = 'TAssetGoods_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUnitChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'UnitForm'
      FormName = 'TUnit_ObjectForm'
      FormNameParam.Value = 'TUnit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPartionGoods20202ChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionGoods20202'
      FormName = 'TPartionGoods20202ChoiceForm'
      FormNameParam.Value = 'TPartionGoods20202ChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inGoodsId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoods'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Price'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Amount'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AmountRemains'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPartionGoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionGoodsForm'
      FormName = 'TPartionGoods20202ChoiceForm'
      FormNameParam.Value = 'TPartionGoods20202ChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inGoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitName'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoods'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Price'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Amount'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AmountRemains'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actAssetGoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsForm'
      FormName = 'TAssetGoods_ObjectForm'
      FormNameParam.Value = 'TAssetGoods_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsKindCompleteChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsKindCompleteChoiceMaster'
      FormName = 'TGoodsKind_ObjectForm'
      FormNameParam.Value = 'TGoodsKind_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId_Complete'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName_Complete'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPrintSaleOrder: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint_SaleOrder
      StoredProcList = <
        item
          StoredProc = spSelectPrint_SaleOrder
        end>
      Caption = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072
      Hint = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072
      ImageIndex = 21
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Sale_Order'
      ReportNameParam.Value = 'PrintMovement_Sale_Order'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintSaleOrderTax: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint_SaleOrderTax
      StoredProcList = <
        item
          StoredProc = spSelectPrint_SaleOrderTax
        end>
      Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1085#1072' %'
      Hint = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1085#1072' %'
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Sale_Order'
      ReportNameParam.Value = 'PrintMovement_Sale_Order'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actUpdatePersonalGroup: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdatePersonalGroup
      StoredProcList = <
        item
          StoredProc = spUpdatePersonalGroup
        end>
      Caption = 'actUpdatePersonalGroup'
    end
    object mactUpdateMaskReturn: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actReturnInJournalChoice
        end
        item
          Action = actUpdateMask
        end
        item
          Action = actRefresh
        end>
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      ImageIndex = 59
    end
    object macUpdatePersonalGroup: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actPersonalGroupChoiceForm
        end
        item
          Action = actUpdatePersonalGroup
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#8470' '#1073#1088#1080#1075#1072#1076#1099
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#8470' '#1073#1088#1080#1075#1072#1076#1099
      ImageIndex = 76
    end
    object actIncomeJournalChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'IncomeJournalChoice'
      FormName = 'TIncomeJournalChoiceForm'
      FormNameParam.Value = 'TIncomeJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MaskId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actInsertRecordAsset: TInsertRecord
      Category = 'Asset'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actPartionGoodsAssetChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' <'#1054#1057'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' <'#1054#1057'>'
      ImageIndex = 0
    end
    object macInsertRecordAsset: TMultiAction
      Category = 'Asset'
      TabSheet = tsMain
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertRecordAsset
        end
        item
          Action = actRefreshPrice
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' <'#1054#1057'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' <'#1054#1057'>'
      ImageIndex = 0
    end
    object mactUpdateMaskIncome: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actIncomeJournalChoice
        end
        item
          Action = actUpdateMask
        end
        item
          Action = actRefresh
        end>
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      ImageIndex = 81
    end
    object mactUpdateMaskReturnOut: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actReturnOutJournalChoice
        end
        item
          Action = actUpdateMask
        end
        item
          Action = actRefresh
        end>
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      ImageIndex = 82
    end
    object actReturnOutJournalChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ReturnOutJournalChoice'
      FormName = 'TReturnOutJournalChoiceForm'
      FormNameParam.Value = 'TReturnOutJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MaskId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateMask: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMask
      StoredProcList = <
        item
          StoredProc = spUpdateMask
        end>
      Caption = 'actUpdateMask'
    end
    object mactUpdateMaskSale: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSaleJournalChoice
        end
        item
          Action = actUpdateMask
        end
        item
          Action = actRefresh
        end>
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      ImageIndex = 30
    end
    object actReturnInJournalChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ReturnInJournalChoice'
      FormName = 'TReturnInJournalChoiceForm'
      FormNameParam.Value = 'TReturnInJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MaskId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerName'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object InsertRecord20202: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actPartionGoods20202ChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' '#1057#1087#1077#1094#1086#1076#1077#1078#1076#1099
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' '#1057#1087#1077#1094#1086#1076#1077#1078#1076#1099
      ImageIndex = 0
    end
    object macInsertRecord20202: TMultiAction
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      ActionList = <
        item
          Action = InsertRecord20202
        end
        item
          Action = actRefreshPrice
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' <'#1057#1087#1077#1094#1086#1076#1077#1078#1076#1072'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' <'#1057#1087#1077#1094#1086#1076#1077#1078#1076#1072'>'
      ImageIndex = 0
    end
    object actSaleJournalChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'SaleJournalChoice'
      FormName = 'TSaleJournalChoiceForm'
      FormNameParam.Value = 'TSaleJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MaskId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenFormOrderExternalChildSend: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1088#1077#1079#1077#1088#1074#1072' '#1076#1083#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1088#1077#1079#1077#1088#1074#1072' '#1076#1083#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      ImageIndex = 24
      FormName = 'TOrderExternalChild_BySendForm'
      FormNameParam.Value = 'TOrderExternalChild_BySendForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMask'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actOpenProductionForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072'>'
      ImageIndex = 26
      FormName = 'TProductionPeresortForm'
      FormNameParam.Value = 'TProductionPeresortForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          Component = GuidesProductionDoc
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = '0'
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
    end
    object actGetImportSetting: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting
      StoredProcList = <
        item
          StoredProc = spGetImportSetting
        end>
      Caption = 'actGetImportSetting'
    end
    object macLoadExcel: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1092#1072#1081#1083#1072' Excel (B/C/D/F) ?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1092#1072#1081#1083#1072' Excel (B/C/D/F)'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' Excel (B/C/D/F)'
      ImageIndex = 41
    end
    object actGoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateMIPertionCell_edit: TdsdInsertUpdateAction
      Category = 'DSDLib'
      TabSheet = cxTabSheet_PartionCell
      MoveParams = <>
      Enabled = False
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1072#1085#1085#1099#1077' '#1103#1095#1077#1077#1082'>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1072#1085#1085#1099#1077' '#1103#1095#1077#1077#1082'>'
      ImageIndex = 1
      FormName = 'TSendPartionCellEditForm'
      FormNameParam.Value = 'TSendPartionCellEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsKindId'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsKindName'
          Value = Null
          Component = PartionCellCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'MovementItemId'
    end
    object actUpdate_PartionGoodsDate: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1090#1091' '#1087#1072#1088#1090#1080#1080
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1090#1091' '#1087#1072#1088#1090#1080#1080
      ImageIndex = 67
    end
    object ExecuteDialogUpdatePartionGoodsDate: TExecuteDialog
      Category = 'OperDatePartner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1055#1072#1088#1090#1080#1080
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1055#1072#1088#1090#1080#1080
      ImageIndex = 67
      FormName = 'TSend_DatePartionDialogForm'
      FormNameParam.Value = 'TSend_DatePartionDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inPartionGoodsDate'
          Value = 43282d
          Component = PartionCellCDS
          ComponentItem = 'PartionGoodsDate'
          DataType = ftDateTime
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdatePartionGoodsDate: TdsdDataSetRefresh
      Category = 'OperDatePartner'
      MoveParams = <>
      StoredProc = spUpdateMI_PartionGoodsDate
      StoredProcList = <
        item
          StoredProc = spUpdateMI_PartionGoodsDate
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 67
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macUpdatePartionGoodsDate: TMultiAction
      Category = 'OperDatePartner'
      TabSheet = cxTabSheet_PartionCell
      MoveParams = <>
      Enabled = False
      ActionList = <
        item
          Action = ExecuteDialogUpdatePartionGoodsDate
        end
        item
          Action = actUpdatePartionGoodsDate
        end
        item
          Action = actRefreshPartionCell
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1055#1072#1088#1090#1080#1080
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1055#1072#1088#1090#1080#1080
      ImageIndex = 67
    end
    object actUpdate_isRePack: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isRePack
      StoredProcList = <
        item
          StoredProc = spUpdate_isRePack
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1055#1077#1088#1077#1087#1072#1082' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1055#1077#1088#1077#1087#1072#1082' ('#1044#1072'/'#1053#1077#1090')'
    end
    object actPrintPackGross: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint_Pack
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Pack
        end>
      Caption = #1059#1087#1072#1082'. '#1051#1080#1089#1090' '#1074#1077#1089' '#1041#1056#1059#1058#1058#1054
      Hint = #1059#1087#1072#1082'. '#1051#1080#1089#1090' '#1074#1077#1089' '#1041#1056#1059#1058#1058#1054
      ImageIndex = 16
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'MovementId;WeighingNumber;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_SendPackGross'
      ReportNameParam.Value = 'PrintMovement_SendPackGross'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 512
  end
  inherited MasterCDS: TClientDataSet
    Left = 88
    Top = 512
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Send'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 80
    Top = 207
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowErasedDetail'
        end
        item
          Visible = True
          ItemName = 'bbShowErasedPC'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          Visible = True
          ItemName = 'bbShowAllDetail'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddMask'
        end
        item
          Visible = True
          ItemName = 'bbAddMaskDetail'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecord20202'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecordAsset'
        end
        item
          Visible = True
          ItemName = 'bbPartionGoodsAssetChoiceForm'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMIPertionCell_edit'
        end
        item
          Visible = True
          ItemName = 'bbUpdatePartionGoodsDate'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          Visible = True
          ItemName = 'bbMISetErasedDetail'
        end
        item
          Visible = True
          ItemName = 'bbMISetUnErasedDetail'
        end
        item
          Visible = True
          ItemName = 'bbMISetErasedPC'
        end
        item
          Visible = True
          ItemName = 'bbMISetUnErasedPC'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPersonalGroupChoiceForm'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isRePack'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMaskSale'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMaskReturn'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMaskIncome'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMaskReturnOut'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbLoadExcel'
        end
        item
          Visible = True
          ItemName = 'bbLoadExcel2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenFormOrderExtChildSend'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenProductionForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemContainer'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbsPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'bbMICellProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'bbGridDetailToExcel'
        end
        item
          Visible = True
          ItemName = 'bbGridChildlToExcel'
        end
        item
          Visible = True
          ItemName = 'bbGrid_PartionCelllToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbPrintNoGroup: TdxBarButton
      Action = actPrintNoGroup
      Category = 0
    end
    object bbPrintSaleOrder: TdxBarButton
      Action = actPrintSaleOrder
      Category = 0
    end
    object bbPrintSaleOrderTax: TdxBarButton
      Action = actPrintSaleOrderTax
      Category = 0
    end
    object bbPersonalGroupChoiceForm: TdxBarButton
      Action = macUpdatePersonalGroup
      Category = 0
    end
    object bbInsertRecord20202: TdxBarButton
      Action = macInsertRecord20202
      Category = 0
    end
    object bbAddMaskDetail: TdxBarButton
      Action = actAddMaskDetail
      Category = 0
    end
    object bbShowAllDetail: TdxBarButton
      Action = actShowAllDetail
      Category = 0
    end
    object bbMISetErasedDetail: TdxBarButton
      Action = actMISetErasedDetail
      Category = 0
    end
    object bbMISetUnErasedDetail: TdxBarButton
      Action = actMISetUnErasedDetail
      Category = 0
    end
    object bbShowErasedDetail: TdxBarButton
      Action = actShowErasedDetail
      Category = 0
    end
    object bbUpdateMaskSale: TdxBarButton
      Action = mactUpdateMaskSale
      Category = 0
    end
    object bbUpdateMaskReturn: TdxBarButton
      Action = mactUpdateMaskReturn
      Category = 0
    end
    object bbUpdateMaskIncome: TdxBarButton
      Action = mactUpdateMaskIncome
      Category = 0
    end
    object bbUpdateMaskReturnOut: TdxBarButton
      Action = mactUpdateMaskReturnOut
      Category = 0
    end
    object bbOpenFormOrderExtChildSend: TdxBarButton
      Action = actOpenFormOrderExternalChildSend
      Category = 0
    end
    object bbOpenProductionForm: TdxBarButton
      Action = actOpenProductionForm
      Category = 0
    end
    object bbLoadExcel: TdxBarButton
      Action = macLoadExcel
      Category = 0
    end
    object bbLoadExcel2: TdxBarButton
      Action = macLoadExcel2
      Category = 0
    end
    object bbInsertRecordAsset: TdxBarButton
      Action = macInsertRecordAsset
      Category = 0
    end
    object bbPartionGoodsAssetChoiceForm: TdxBarButton
      Action = actPartionGoodsAssetChoiceForm
      Category = 0
    end
    object bbUpdateMIPertionCell_edit: TdxBarButton
      Action = actUpdateMIPertionCell_edit
      Category = 0
    end
    object bbUpdatePartionGoodsDate: TdxBarButton
      Action = macUpdatePartionGoodsDate
      Category = 0
    end
    object bbMISetErasedPC: TdxBarButton
      Action = actMISetErasedPC
      Category = 0
    end
    object bbMISetUnErasedPC: TdxBarButton
      Action = actMISetUnErasedPC
      Category = 0
    end
    object bbShowErasedPC: TdxBarButton
      Action = actShowErasedPC
      Category = 0
    end
    object bbGridDetailToExcel: TdxBarButton
      Action = actGridDetailToExcel
      Category = 0
    end
    object bbGridChildlToExcel: TdxBarButton
      Action = actGridChildlToExcel
      Category = 0
    end
    object bbGrid_PartionCelllToExcel: TdxBarButton
      Action = actGrid_PartionCelllToExcel
      Category = 0
    end
    object bbsPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 3
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbPrintNoGroup'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbPrintSaleOrder'
        end
        item
          Visible = True
          ItemName = 'bbPrintSaleOrderTax'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbPrintPackGross'
        end>
    end
    object dxBarSeparator1: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbMICellProtocol: TdxBarButton
      Action = actMICellProtocolOpenForm
      Category = 0
    end
    object bbUpdate_isRePack: TdxBarButton
      Action = actUpdate_isRePack
      Category = 0
      ImageIndex = 77
    end
    object bbPrintPackGross: TdxBarButton
      Action = actPrintPackGross
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    Left = 750
    Top = 225
  end
  inherited PopupMenu: TPopupMenu
    Left = 872
    Top = 368
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSend'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 464
  end
  inherited StatusGuides: TdsdGuides
    Tag = 123
    Left = 80
    Top = 48
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Send'
    Left = 104
    Top = 40
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Send'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DocumentKindId'
        Value = 0d
        Component = GuidesDocumentKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DocumentKindName'
        Value = 'False'
        Component = GuidesDocumentKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAuto'
        Value = False
        Component = edIsAuto
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRePack'
        Value = Null
        Component = cbisRePack
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = 0.000000000000000000
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertName'
        Value = Null
        Component = edInsertName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertDate'
        Value = Null
        Component = edInsertDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Send'
        Value = Null
        Component = GuidesSendDoc
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_SendFull'
        Value = Null
        Component = edInvNumberSend
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Order'
        Value = Null
        Component = GuidesInvNumberOrder
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberOrder'
        Value = Null
        Component = GuidesInvNumberOrder
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SubjectDocId'
        Value = Null
        Component = GuidesSubjectDoc
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'SubjectDocName'
        Value = Null
        Component = GuidesSubjectDoc
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupId'
        Value = Null
        Component = GuidesPersonalGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalGroupName'
        Value = Null
        Component = GuidesPersonalGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Production'
        Value = Null
        Component = GuidesProductionDoc
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_ProductionFull'
        Value = Null
        Component = GuidesProductionDoc
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Send'
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
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentKindId'
        Value = 0d
        Component = GuidesDocumentKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSubjectDocId'
        Value = Null
        Component = GuidesSubjectDoc
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = 'False'
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
    Left = 200
    Top = 192
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = edDocumentKind
      end
      item
        Control = ceComment
      end
      item
        Control = edSubjectDoc
      end>
    Left = 272
    Top = 201
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 800
    Top = 280
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Send_SetErased'
    Left = 718
    Top = 416
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Send_SetUnErased'
    Left = 710
    Top = 368
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Send'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Count'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHeadCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'HeadCount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartNumber'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartNumber'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindCompleteId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId_Complete'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAssetId'
        Value = 0
        Component = MasterCDS
        ComponentItem = 'AssetId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAssetId_two'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AssetId_two'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageId'
        Value = 0
        Component = MasterCDS
        ComponentItem = 'StorageId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionModelId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionModelId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsId'
        Value = 0
        Component = MasterCDS
        ComponentItem = 'PartionGoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 144
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Send'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHeadCount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindCompleteId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId_Complete'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAssetId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionModelId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionModelId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 420
    Top = 188
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshPrice
    ComponentList = <
      item
      end>
    Left = 512
    Top = 328
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 193
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 246
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 644
    Top = 334
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Send_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Weighing'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisItem'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 367
    Top = 376
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TStoragePlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStoragePlace_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 432
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TStoragePlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStoragePlace_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 520
    Top = 65520
  end
  object GuidesDocumentKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edDocumentKind
    FormNameParam.Value = 'TDocumentKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDocumentKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesDocumentKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesDocumentKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 704
    Top = 8
  end
  object spSelectPrintNoGroup: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Send_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Weighing'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisItem'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 543
    Top = 408
  end
  object GuidesSendDoc: TdsdGuides
    KeyField = 'Id'
    FormNameParam.Value = 'TSendJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSendJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesSendDoc
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesSendDoc
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 764
    Top = 64
  end
  object GuidesInvNumberOrder: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberOrder
    FormNameParam.Value = 'TOrderInternalJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderInternalJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInvNumberOrder
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInvNumberOrder
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRemains'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 396
    Top = 56
  end
  object GuidesSubjectDoc: TdsdGuides
    KeyField = 'Id'
    LookupControl = edSubjectDoc
    FormNameParam.Value = 'TSubjectDocForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSubjectDocForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesSubjectDoc
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesSubjectDoc
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 504
    Top = 48
  end
  object spSelectPrint_SaleOrder: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_Order_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = ''
        Component = GuidesInvNumberOrder
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Weighing'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDiff'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDiffTax'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 967
    Top = 224
  end
  object spSelectPrint_SaleOrderTax: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_Order_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = ''
        Component = GuidesInvNumberOrder
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Weighing'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDiff'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDiffTax'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 999
    Top = 280
  end
  object spInsertUpdateMovement_order: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Send_Order'
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
        Name = 'inMovementId_Order'
        Value = ''
        Component = GuidesInvNumberOrder
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 290
    Top = 344
  end
  object HeaderSaver1: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spInsertUpdateMovement_order
    ControlList = <
      item
        Control = edInvNumberOrder
      end>
    GetStoredProc = spGet
    Left = 336
    Top = 225
  end
  object GuidesPersonalGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalGroup
    FormNameParam.Value = 'TPersonalGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 880
  end
  object spUpdatePersonalGroup: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Send_PersonalGroup'
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
        Name = 'inPersonalGroupId'
        Value = ''
        Component = GuidesPersonalGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 866
    Top = 312
  end
  object DetailDS: TDataSource
    DataSet = DetailCDS
    Left = 368
    Top = 512
  end
  object DetailCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 424
    Top = 496
  end
  object DBViewAddOnDetail: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewDetail
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 478
    Top = 537
  end
  object spSelectDetail: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Send_Detail'
    DataSet = DetailCDS
    DataSets = <
      item
        DataSet = DetailCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = actShowAllDetail
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErasedDetail
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 42132d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 544
    Top = 504
  end
  object GuidesReturnKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edReturnKind
    FormNameParam.Value = 'TReturnKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TReturnKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesReturnKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesReturnKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 864
    Top = 32
  end
  object spInsertMaskMIDetail: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Send_Detail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'ParentId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSubjectDocId_top'
        Value = 0
        Component = GuidesSubjectDoc
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReturnKindId_top'
        Value = Null
        Component = GuidesReturnKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSubjectDocId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReturnKindId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 640
    Top = 480
  end
  object spInsertUpdateMIDetail: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Send_Detail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        Component = DetailCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'ParentId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSubjectDocId_top'
        Value = ''
        Component = GuidesSubjectDoc
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReturnKindId_top'
        Value = ''
        Component = GuidesReturnKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSubjectDocId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'SubjectDocId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReturnKindId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'ReturnKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        Component = DetailCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 640
    Top = 232
  end
  object spUnErasedMIDetail: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Send_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 774
    Top = 504
  end
  object spErasedMIDetail: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Send_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 846
    Top = 512
  end
  object spUpdateMask: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_Send_isMask'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId '
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementMaskId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MaskId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 400
    Top = 443
  end
  object GuidesProductionDoc: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberProduction
    Key = '0'
    FormNameParam.Value = 'TProductionPeresortJournalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProductionPeresortJournalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesProductionDoc
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesProductionDoc
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 980
    Top = 56
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 936
    Top = 456
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 992
    Top = 440
  end
  object dsdDBViewAddOnChild: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewChild
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 1054
    Top = 505
  end
  object spSelectChild: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Send_Child'
    DataSet = ChildCDS
    DataSets = <
      item
        DataSet = ChildCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErasedDetail
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 992
    Top = 480
  end
  object spGetImportSetting: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TSendForm;zc_Object_ImportSetting_Send'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1080
    Top = 184
  end
  object TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TPersonalServiceForm;zc_Object_ImportSetting_PersonalService'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 968
    Top = 264
  end
  object spGetImportSetting2: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TSendForm;zc_Object_ImportSetting_Send2'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1088
    Top = 240
  end
  object PartionCellDS: TDataSource
    DataSet = PartionCellCDS
    Left = 1072
    Top = 384
  end
  object PartionCellCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 1104
    Top = 384
  end
  object spSelect_MI_PartionCell: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_Send_PartionCell'
    DataSet = PartionCellCDS
    DataSets = <
      item
        DataSet = PartionCellCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErasedPC
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 936
    Top = 512
  end
  object DBViewAddOn_PartionCell: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView_PartionCell
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 1110
    Top = 329
  end
  object spInsertUpdateMIPartionCell: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Send_PartionCell'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_1'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'PartionCellName_1'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_2'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'PartionCellName_2'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_3'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'PartionCellName_3'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_4'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'PartionCellName_4'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_5'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'PartionCellName_5'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_6'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'PartionCellName_6'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_7'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'PartionCellName_7'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_8'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'PartionCellName_8'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_9'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'PartionCellName_9'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_10'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'PartionCellName_10'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_11'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'PartionCellName_11'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionCellName_12'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'PartionCellName_12'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1120
    Top = 448
  end
  object spUpdateMI_PartionGoodsDate: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_Send_PartionGoodsDate'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsDate'
        Value = 43282d
        Component = PartionCellCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 578
    Top = 552
  end
  object spUnErasedMIPC: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Send_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 790
    Top = 384
  end
  object spErasedMIPC: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Send_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 790
    Top = 424
  end
  object spUpdate_isRePack: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Send_isRePack'
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
        Name = 'inisRePack'
        Value = ''
        Component = cbisRePack
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisRePack'
        Value = Null
        Component = cbisRePack
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 730
    Top = 296
  end
  object spSelectPrint_Pack: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Send_Pack_Print'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_by'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 847
    Top = 178
  end
end
