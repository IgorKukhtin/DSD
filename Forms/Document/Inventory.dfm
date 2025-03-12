inherited InventoryForm: TInventoryForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103'>'
  ClientHeight = 598
  ClientWidth = 1020
  ExplicitWidth = 1036
  ExplicitHeight = 637
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 126
    Width = 1020
    Height = 472
    ExplicitTop = 126
    ExplicitWidth = 1020
    ExplicitHeight = 472
    ClientRectBottom = 472
    ClientRectRight = 1020
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1020
      ExplicitHeight = 448
      inherited cxGrid: TcxGrid
        Width = 1020
        Height = 448
        ExplicitWidth = 1020
        ExplicitHeight = 448
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
              Column = Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_pr
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
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
              Column = Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_pr
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
            Width = 100
          end
          object GoodsCode: TcxGridDBColumn [1]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsName: TcxGridDBColumn [2]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object GoodsKindName: TcxGridDBColumn [3]
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
            Width = 80
          end
          object GoodsKindName_Complete: TcxGridDBColumn [4]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055
            DataBinding.FieldName = 'GoodsKindName_Complete'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindCompleteChoiceMaster
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object MeasureName: TcxGridDBColumn [5]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 45
          end
          object PartionGoods: TcxGridDBColumn [6]
            Caption = #1055#1072#1088#1090#1080#1103' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 102
          end
          object PartionGoodsDate: TcxGridDBColumn [7]
            Caption = #1055#1072#1088#1090#1080#1103' ('#1076#1072#1090#1072')'
            DataBinding.FieldName = 'PartionGoodsDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Amount: TcxGridDBColumn [8]
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Count: TcxGridDBColumn [9]
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1073#1072#1090#1086#1085#1086#1074' '#1080#1083#1080' '#1091#1087#1072#1082#1086#1074#1086#1082
            DataBinding.FieldName = 'Count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object HeadCount: TcxGridDBColumn [10]
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1075#1086#1083#1086#1074
            DataBinding.FieldName = 'HeadCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ; '
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Price: TcxGridDBColumn [11]
            Caption = #1062#1077#1085#1072' ('#1087#1072#1088#1090#1080#1103')'
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Price_pr: TcxGridDBColumn [12]
            Caption = #1062#1077#1085#1072' ('#1087#1088#1072#1081#1089')'
            DataBinding.FieldName = 'Price_pr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object GoodsName_old: TcxGridDBColumn
            Caption = '***'#1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName_old'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1072#1088#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077
            Options.Editing = False
            Width = 100
          end
          object AssetName: TcxGridDBColumn
            Caption = #1054#1089#1085'. '#1089#1088#1077#1076#1089#1090#1074#1086
            DataBinding.FieldName = 'AssetName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actAssetChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1085#1086#1074#1085#1086#1077' '#1089#1088#1077#1076#1089#1090#1074#1086' ('#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1058#1052#1062')'
            Width = 68
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1087#1072#1088#1090#1080#1103')'
            DataBinding.FieldName = 'UnitName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actUnitChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 67
          end
          object StorageName: TcxGridDBColumn
            Caption = #1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1087#1072#1088#1090#1080#1103')'
            DataBinding.FieldName = 'StorageName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actStorageChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object PartNumber: TcxGridDBColumn
            Caption = #8470' '#1087#1086' '#1090#1077#1093' '#1087#1072#1089#1087#1086#1088#1090#1091
            DataBinding.FieldName = 'PartNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object PartionModelName: TcxGridDBColumn
            Caption = #1052#1086#1076#1077#1083#1100' ('#1087#1072#1088#1090#1080#1103')'
            DataBinding.FieldName = 'PartionModelName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPartionModelForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object PartionCellCode_1: TcxGridDBColumn
            Caption = '1.1 '#1050#1086#1076
            DataBinding.FieldName = 'PartionCellCode_1'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '1.1 '#1050#1086#1076' '#1071#1095#1077#1081#1082#1072
            Options.Editing = False
            Width = 70
          end
          object PartionCellName_1: TcxGridDBColumn
            Caption = '1.1 '#1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName_1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ContainerId: TcxGridDBColumn
            DataBinding.FieldName = 'ContainerId'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 0
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Summ: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Summ_pr: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' (-)'#1091#1073#1099#1083#1100' (+)'#1101#1082#1086#1085#1086#1084'. '#1055#1056#1040#1049#1057
            DataBinding.FieldName = 'Summ_pr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object IdBarCode: TcxGridDBColumn
            Caption = #1064#1090#1088#1080#1093#1082#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'IdBarCode'
            Visible = False
            Width = 70
          end
          object OperDate: TcxGridDBColumn
            DataBinding.FieldName = 'OperDate'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
        end
      end
    end
    object cxTabSheet_PartionCell: TcxTabSheet
      Caption = #1054#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1071#1095#1077#1081#1082#1072#1084' '#1093#1088#1072#1085#1077#1085#1080#1103
      ImageIndex = 1
      object cxGrid_PartionCell: TcxGrid
        Left = 0
        Top = 0
        Width = 1020
        Height = 448
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
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsChoiceFormPC
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 224
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
            HeaderHint = #1071#1095#1077#1081#1082#1072'-1 '#1093#1088#1072#1085#1077#1085#1080#1103
            Width = 159
          end
          object isPartionCell_Close_1_ch4: TcxGridDBColumn
            Caption = '1.2 '#1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close_1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1101#1090#1086#1081' '#1087#1072#1088#1090#1080#1080' '#1074' '#1071#1095#1077#1081#1082#1072'-1('#1076#1072'/'#1085#1077#1090')'
            Width = 125
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
    Width = 1020
    Height = 100
    TabOrder = 3
    ExplicitWidth = 1020
    ExplicitHeight = 100
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
      ExplicitWidth = 109
      Width = 109
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 126
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 126
    end
    inherited cxLabel2: TcxLabel
      Left = 126
      ExplicitLeft = 126
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
      ExplicitWidth = 218
      ExplicitHeight = 22
      Width = 218
    end
    object cxLabel3: TcxLabel
      Left = 232
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object edFrom: TcxButtonEdit
      Left = 232
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 270
    end
    object edTo: TcxButtonEdit
      Left = 514
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Width = 270
    end
    object cxLabel4: TcxLabel
      Left = 514
      Top = 5
      Caption = #1050#1086#1084#1091
    end
    object cxLabel5: TcxLabel
      Left = 232
      Top = 45
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 232
      Top = 64
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 270
    end
    object cbisGoodsGroupIn: TcxCheckBox
      Left = 515
      Top = 63
      Caption = #1058#1086#1083#1100#1082#1086' '#1074#1099#1073#1088'. '#1075#1088#1091#1087#1087#1072
      Properties.ReadOnly = False
      State = cbsChecked
      TabOrder = 12
      Width = 134
    end
    object cbisGoodsGroupExc: TcxCheckBox
      Left = 655
      Top = 63
      Caption = #1050#1088#1086#1084#1077' '#1074#1099#1073#1088'. '#1075#1088#1091#1087#1087#1099
      Properties.ReadOnly = False
      TabOrder = 13
      Width = 129
    end
    object cbList: TcxCheckBox
      Left = 793
      Top = 63
      Hint = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103' '#1090#1086#1083#1100#1082#1086' '#1087#1086' '#1079#1072#1087#1086#1083#1085#1077#1085#1085#1099#1084' '#1090#1086#1074#1072#1088#1072#1089
      Caption = #1055#1077#1088#1077#1089#1086#1088#1090
      Properties.ReadOnly = False
      TabOrder = 14
      Width = 122
    end
    object cxLabel18: TcxLabel
      Left = 796
      Top = 5
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
    end
    object edPriceList: TcxButtonEdit
      Left = 796
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 16
      Width = 157
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 171
    Top = 552
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    Left = 32
    Top = 216
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    object actSendOnPriceOpenForm: TOpenChoiceForm [0]
      Category = 'Send'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actSendOnPriceJournal'
      FormName = 'TSendOnPriceJournalChoiceForm'
      FormNameParam.Value = 'TSendOnPriceJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MovementId_Send'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actSaleOpenForm: TOpenChoiceForm [1]
      Category = 'Sale'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      FormName = 'TSaleJournalChoiceForm'
      FormNameParam.Value = 'TSaleJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MovementId_Sale'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actRefreshGet: TdsdDataSetRefresh [2]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdateMovement
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = True
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
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = PartionCellDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object macDelete_bySale: TMultiAction [4]
      Category = 'Sale'
      MoveParams = <>
      ActionList = <
        item
          Action = actSaleOpenForm
        end
        item
          Action = actDelete_bySale
        end
        item
          Action = actRefresh
        end>
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1086#1090#1084#1080#1085#1091#1089#1086#1074#1072#1085#1099' '#1086#1090' '#1086#1089#1090#1072#1090#1082#1072
      Caption = #1054#1090#1085#1103#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1080#1079' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1055#1088#1086#1076#1072#1078#1080
      Hint = #1054#1090#1085#1103#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1080#1079' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1055#1088#1086#1076#1072#1078#1080
      ImageIndex = 39
    end
    object actMISetUnErasedPc: TdsdUpdateErased [5]
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
        end
        item
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = PartionCellDS
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
          StoredProc = spSelect_MI_PartionCell
        end>
      RefreshOnTabSetChanges = True
    end
    object macDelete_bySendOnPrice: TMultiAction [7]
      Category = 'Send'
      MoveParams = <>
      ActionList = <
        item
          Action = actSendOnPriceOpenForm
        end
        item
          Action = actDelete_bySendOnPrice
        end
        item
          Action = actRefresh
        end>
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1086#1090#1084#1080#1085#1091#1089#1086#1074#1072#1085#1099' '#1086#1090' '#1086#1089#1090#1072#1090#1082#1072
      Caption = #1054#1090#1085#1103#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1080#1079' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1087#1086' '#1094#1077#1085#1077
      Hint = #1054#1090#1085#1103#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1080#1079' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1087#1086' '#1094#1077#1085#1077
      ImageIndex = 39
    end
    object actDelete_bySendOnPrice: TdsdExecStoredProc [8]
      Category = 'Send'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_MI_Inventory_bySend
      StoredProcList = <
        item
          StoredProc = spDelete_MI_Inventory_bySend
        end>
      Caption = #1054#1090#1085#1103#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1087#1086' '#1094#1077#1085#1077
      Hint = #1054#1090#1085#1103#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1087#1086' '#1094#1077#1085#1077
      ImageIndex = 39
    end
    object macInsert_bySendOnPrice: TMultiAction [9]
      Category = 'Send'
      MoveParams = <>
      ActionList = <
        item
          Action = actSendOnPriceOpenForm
        end
        item
          Action = actInsert_bySendOnPrice
        end
        item
          Action = actRefresh
        end>
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1076#1086#1073#1072#1074#1083#1077#1085#1099
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1080#1079' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1087#1086' '#1094#1077#1085#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1080#1079' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1087#1086' '#1094#1077#1085#1077
      ImageIndex = 27
    end
    object actInsert_bySendOnPrice: TdsdExecStoredProc [10]
      Category = 'Send'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_MI_Inventory_bySend
      StoredProcList = <
        item
          StoredProc = spInsert_MI_Inventory_bySend
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      ImageIndex = 27
    end
    object actDelete_bySale: TdsdExecStoredProc [11]
      Category = 'Sale'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_MI_Inventory_bySale
      StoredProcList = <
        item
          StoredProc = spDelete_MI_Inventory_bySale
        end>
      Caption = #1054#1090#1085#1103#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
      Hint = #1054#1090#1085#1103#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
      ImageIndex = 39
    end
    object macDelete_bySeparate: TMultiAction [12]
      Category = 'Separate'
      MoveParams = <>
      ActionList = <
        item
          Action = actSeparateOpenForm
        end
        item
          Action = actDelete_bySeparate
        end
        item
          Action = actRefresh
        end>
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1086#1090#1084#1080#1085#1091#1089#1086#1074#1072#1085#1099' '#1086#1090' '#1086#1089#1090#1072#1090#1082#1072
      Caption = #1054#1090#1085#1103#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1080#1079' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'-'#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Hint = #1054#1090#1085#1103#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1080#1079' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      ImageIndex = 39
    end
    object macInsert_bySale: TMultiAction [13]
      Category = 'Sale'
      MoveParams = <>
      ActionList = <
        item
          Action = actSaleOpenForm
        end
        item
          Action = actInsert_bySale
        end
        item
          Action = actRefresh
        end>
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1076#1086#1073#1072#1074#1083#1077#1085#1099
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1080#1079' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1055#1088#1086#1076#1072#1078#1080
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1080#1079' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1055#1088#1086#1076#1072#1078#1080
      ImageIndex = 27
    end
    object actDelete_bySeparate: TdsdExecStoredProc [14]
      Category = 'Separate'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_MI_Inventory_bySeparate
      StoredProcList = <
        item
          StoredProc = spDelete_MI_Inventory_bySeparate
        end>
      Caption = #1054#1090#1085#1103#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Hint = #1054#1090#1085#1103#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      ImageIndex = 39
    end
    object actInsert_bySale: TdsdExecStoredProc [15]
      Category = 'Sale'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_MI_Inventory_bySale
      StoredProcList = <
        item
          StoredProc = spInsert_MI_Inventory_bySale
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
      ImageIndex = 27
    end
    inherited actMISetErased: TdsdUpdateErased
      TabSheet = tsMain
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
        end>
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
    inherited actShowErased: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MI_PartionCell
        end>
    end
    object actGoodsKindChoicePC: TOpenChoiceForm [21]
      Category = 'PartionCell'
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
    object actPrint1: TdsdPrintAction [23]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = 22
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsName;GoodsKindName;PartionGoods;PartionG' +
            'oodsDate'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Inventory'
      ReportNameParam.Value = 'PrintMovement_Inventory'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actPrint: TdsdPrintAction
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
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName;PartionGoods'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Inventory'
      ReportNameParam.Value = 'PrintMovement_Inventory'
      ReportNameParam.ParamType = ptInput
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
    object actStorageChoice: TOpenChoiceForm [30]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StorageChoice'
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
    object actAssetChoice: TOpenChoiceForm [31]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'AssetChoice'
      FormName = 'TAssetForm'
      FormNameParam.Value = 'TAssetForm'
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
    object actInsertUpdateMIAmount: TdsdExecStoredProc [32]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIAmount
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIAmount
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1050#1086#1083'-'#1074#1086'> '#1087#1086' '#1088#1072#1089#1095#1077#1090#1085#1086#1084#1091' '#1086#1089#1090#1072#1090#1082#1091' '#1085#1072' '#1076#1072#1090#1091
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1050#1086#1083'-'#1074#1086'> '#1087#1086' '#1088#1072#1089#1095#1077#1090#1085#1086#1084#1091' '#1086#1089#1090#1072#1090#1082#1091' '#1085#1072' '#1076#1072#1090#1091
      ImageIndex = 50
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1050#1086#1083'-'#1074#1086'> '#1087#1086' '#1088#1072#1089#1095#1077#1090#1085#1086#1084#1091' '#1086#1089#1090#1072#1090#1082#1091' ' +
        #1085#1072' '#1076#1072#1090#1091'?'
      InfoAfterExecute = '<'#1050#1086#1083'-'#1074#1086'> '#1087#1086' '#1088#1072#1089#1095#1077#1090#1085#1086#1084#1091' '#1086#1089#1090#1072#1090#1082#1091' '#1085#1072' '#1076#1072#1090#1091' '#1079#1072#1087#1086#1083#1085#1077#1085#1086' '#1091#1089#1087#1077#1096#1085#1086'.'
    end
    object actUnitChoice: TOpenChoiceForm [33]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'UnitChoice'
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
    object actGoodsKindChoice: TOpenChoiceForm [34]
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
    object mactUpdate_Summ: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = mactUpdate_SummAll
        end
        item
          Action = actRefreshPrice
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1073#1085#1091#1083#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' <'#1057#1091#1084#1084#1072'> '#1076#1083#1103' '#1042#1057#1045#1061'?'
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' <'#1057#1091#1084#1084#1072'> '#1086#1073#1085#1091#1083#1080#1083#1072#1089#1100' '#1076#1083#1103' '#1042#1057#1045#1061'.'
      Caption = #1054#1073#1085#1091#1083#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' <'#1057#1091#1084#1084#1072'> '#1076#1083#1103' '#1042#1057#1045#1061
      Hint = #1054#1073#1085#1091#1083#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' <'#1057#1091#1084#1084#1072'> '#1076#1083#1103' '#1042#1057#1045#1061
    end
    object actUpdate_Summ: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMIMaster_Summ
      StoredProcList = <
        item
          StoredProc = spUpdateMIMaster_Summ
        end>
      Caption = 'actUpdate_Summ'
      Hint = 'actUpdate_Summ'
    end
    object mactUpdate_SummAll: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Summ
        end>
      View = cxGridDBTableView
      Caption = 'mactUpdate_SummAll'
      Hint = 'mactUpdate_SummAll'
    end
    object actPrintStickerGrid: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintSticker
      StoredProcList = <
        item
          StoredProc = spSelectPrintSticker
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080' ('#1080#1079' '#1075#1088#1080#1076#1072')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080' ('#1080#1079' '#1075#1088#1080#1076#1072')'
      ImageIndex = 18
      DataSets = <
        item
          UserName = 'frxDBDItems'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'isPrintTermo'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_IncomeSticker'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072' '#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      ReportNameParam.Value = 'PrintMovement_IncomeSticker'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actGoodsKindCompleteChoiceMaster: TOpenChoiceForm
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
    object actSeparateOpenForm: TOpenChoiceForm
      Category = 'Separate'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsChoice'
      FormName = 'TProductionSeparateJournalChoiceForm'
      FormNameParam.Value = 'TProductionSeparateJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MovementId_Separate'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPartionGoodsChoiceForm: TOpenChoiceForm
      Category = 'Partion'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actPartionGoodsChoice'
      FormName = 'TPartionGoodsChoiceForm'
      FormNameParam.Value = 'TPartionGoodsChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'PartionGoodsId'
          MultiSelectSeparator = ','
        end
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
        end>
      isShowModal = True
    end
    object actSendOpenForm: TOpenChoiceForm
      Category = 'Send'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsChoice'
      FormName = 'TSendJournalChoiceForm'
      FormNameParam.Value = 'TSendJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'MovementId_Send'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object macDelete_bySend: TMultiAction
      Category = 'Send'
      MoveParams = <>
      ActionList = <
        item
          Action = actSendOpenForm
        end
        item
          Action = actDelete_bySend
        end
        item
          Action = actRefresh
        end>
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1086#1090#1084#1080#1085#1091#1089#1086#1074#1072#1085#1099' '#1086#1090' '#1086#1089#1090#1072#1090#1082#1072
      Caption = #1054#1090#1085#1103#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1080#1079' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      Hint = #1054#1090#1085#1103#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1080#1079' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      ImageIndex = 39
    end
    object macUpdate_PartionGoods: TMultiAction
      Category = 'Partion'
      MoveParams = <>
      ActionList = <
        item
          Action = actPartionGoodsChoiceForm
        end
        item
          Action = actUpdate_PartionGoods
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' '#1090#1086#1074#1072#1088#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' '#1090#1086#1074#1072#1088#1072
      ImageIndex = 77
    end
    object macInsert_bySeparate: TMultiAction
      Category = 'Separate'
      MoveParams = <>
      ActionList = <
        item
          Action = actSeparateOpenForm
        end
        item
          Action = actInsert_bySeparate
        end
        item
          Action = actRefresh
        end>
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1076#1086#1073#1072#1074#1083#1077#1085#1099
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1080#1079' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1080#1079' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object actInsert_bySeparate: TdsdExecStoredProc
      Category = 'Separate'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_MI_Inventory_bySeparate
      StoredProcList = <
        item
          StoredProc = spInsert_MI_Inventory_bySeparate
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'-'#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      ImageIndex = 27
    end
    object actDelete_bySend: TdsdExecStoredProc
      Category = 'Send'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_MI_Inventory_bySend
      StoredProcList = <
        item
          StoredProc = spDelete_MI_Inventory_bySend
        end>
      Caption = #1054#1090#1085#1103#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      Hint = #1054#1090#1085#1103#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      ImageIndex = 39
    end
    object actUpdate_PartionGoods: TdsdExecStoredProc
      Category = 'Partion'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_PartionGoods
      StoredProcList = <
        item
          StoredProc = spUpdate_PartionGoods
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' '#1090#1086#1074#1072#1088#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1090#1080#1102' '#1090#1086#1074#1072#1088#1072
      ImageIndex = 77
    end
    object macInsert_bySend: TMultiAction
      Category = 'Send'
      MoveParams = <>
      ActionList = <
        item
          Action = actSendOpenForm
        end
        item
          Action = actInsert_bySend
        end
        item
          Action = actRefresh
        end>
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1076#1086#1073#1072#1074#1083#1077#1085#1099
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1080#1079' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1080#1079' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
    end
    object actInsert_bySend: TdsdExecStoredProc
      Category = 'Send'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_MI_Inventory_bySend
      StoredProcList = <
        item
          StoredProc = spInsert_MI_Inventory_bySend
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      ImageIndex = 27
    end
    object actPrintStickerTermo: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintSticker
      StoredProcList = <
        item
          StoredProc = spSelectPrintSticker
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1085#1072' '#1090#1077#1088#1084#1086#1087#1088#1080#1085#1090#1077#1088' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      Hint = #1055#1077#1095#1072#1090#1100' '#1085#1072' '#1090#1077#1088#1084#1086#1087#1088#1080#1085#1090#1077#1088' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      ImageIndex = 20
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDItems'
        end>
      Params = <
        item
          Name = 'isPrintTermo'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_IncomeSticker'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072' '#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      ReportNameParam.Value = 'PrintMovement_IncomeSticker'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintSticker: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintSticker
      StoredProcList = <
        item
          StoredProc = spSelectPrintSticker
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDItems'
        end>
      Params = <
        item
          Name = 'isPrintTermo'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_IncomeSticker'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072' '#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      ReportNameParam.Value = 'PrintMovement_IncomeSticker'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPartionGoodsAssetChoiceForm: TOpenChoiceForm
      Category = 'Asset'
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
          ComponentItem = 'Amount'
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
    object actPartionModelForm: TOpenChoiceForm
      Category = 'Asset'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionModelForm'
      FormName = 'TPartionModelForm'
      FormNameParam.Value = 'TPartionModelForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionModelId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionModelName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object acrRefreshPartionCell: TdsdDataSetRefresh
      Category = 'PartionCell'
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
    object actUpdatePartionCellDS: TdsdUpdateDataSet
      Category = 'PartionCell'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIPartionCell
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIPartionCell
        end
        item
        end>
      Caption = 'actUpdatePartionCellDS'
      DataSource = PartionCellDS
    end
    object actGoodsChoiceFormPC: TOpenChoiceForm
      Category = 'PartionCell'
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
    object actOpenPartionCellForm1: TOpenChoiceForm
      Category = 'PartionCell'
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
    StoredProcName = 'gpSelect_MovementItem_Inventory'
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
    Left = 88
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
          ItemName = 'bbShowAll'
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
          ItemName = 'bbMISetErasedPC'
        end
        item
          Visible = True
          ItemName = 'bbMISetUnErasedPc'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMIAmount'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsert_bySend'
        end
        item
          Visible = True
          ItemName = 'bbDelete_bySend'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsert_bySeparate'
        end
        item
          Visible = True
          ItemName = 'bbDelete_bySeparate'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsert_bySale'
        end
        item
          Visible = True
          ItemName = 'bbDelete_bySale'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsert_bySendOnPrice'
        end
        item
          Visible = True
          ItemName = 'bbDelete_bySendOnPrice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_PartionGoods'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintStickerGrid'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintStickerTermo'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Summ'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    object bbInsertUpdateMIAmount: TdxBarButton
      Action = actInsertUpdateMIAmount
      Category = 0
    end
    object bbUpdate_Summ: TdxBarButton
      Action = mactUpdate_Summ
      Category = 0
    end
    object bbInsert_bySend: TdxBarButton
      Action = macInsert_bySend
      Category = 0
      ImageIndex = 27
    end
    object bbPrintSticker: TdxBarButton
      Action = actPrintSticker
      Category = 0
    end
    object bbPrintStickerTermo: TdxBarButton
      Action = actPrintStickerTermo
      Category = 0
    end
    object bbDelete_bySend: TdxBarButton
      Action = macDelete_bySend
      Category = 0
    end
    object bbUpdate_PartionGoods: TdxBarButton
      Action = macUpdate_PartionGoods
      Category = 0
    end
    object bbInsert_bySeparate: TdxBarButton
      Action = macInsert_bySeparate
      Category = 0
      ImageIndex = 27
    end
    object bbDelete_bySeparate: TdxBarButton
      Action = macDelete_bySeparate
      Category = 0
    end
    object bbPrintStickerGrid: TdxBarButton
      Action = actPrintStickerGrid
      Category = 0
    end
    object bbInsert_bySale: TdxBarButton
      Action = macInsert_bySale
      Category = 0
    end
    object bbDelete_bySale: TdxBarButton
      Action = macDelete_bySale
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
    object bbInsert_bySendOnPrice: TdxBarButton
      Action = macInsert_bySendOnPrice
      Category = 0
    end
    object bbDelete_bySendOnPrice: TdxBarButton
      Action = macDelete_bySendOnPrice
      Category = 0
    end
    object bbMISetErasedPC: TdxBarButton
      Action = actMISetErasedPC
      Category = 0
    end
    object bbMISetUnErasedPc: TdxBarButton
      Action = actMISetUnErasedPc
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
    Left = 830
    Top = 265
  end
  inherited PopupMenu: TPopupMenu
    Left = 800
    Top = 464
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
        Name = 'ReportNameInventory'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameInventoryTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameInventoryBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGoodsGroupIn'
        Value = Null
        Component = cbisGoodsGroupIn
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGoodsGroupExc'
        Value = Null
        Component = cbisGoodsGroupExc
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 552
  end
  inherited StatusGuides: TdsdGuides
    Tag = 123
    Left = 80
    Top = 48
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Inventory'
    Left = 128
    Top = 56
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Inventory'
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
        Name = 'GoodsGroupId'
        Value = 0d
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = 'False'
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGoodsGroupIn'
        Value = False
        Component = cbisGoodsGroupIn
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isGoodsGroupExc'
        Value = False
        Component = cbisGoodsGroupExc
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isList'
        Value = Null
        Component = cbList
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Inventory'
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
        Name = 'inGoodsGroupId'
        Value = 0d
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId'
        Value = 0.000000000000000000
        Component = GuidesPriceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioisGoodsGroupIn'
        Value = False
        Component = cbisGoodsGroupIn
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioisGoodsGroupExc'
        Value = False
        Component = cbisGoodsGroupExc
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisList'
        Value = ''
        Component = cbList
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
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = False
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 154
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
    Left = 160
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
        Control = cbisGoodsGroupExc
      end
      item
        Control = cbisGoodsGroupIn
      end
      item
        Control = edGoodsGroup
      end
      item
        Control = cbList
      end
      item
        Control = edPriceList
      end>
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 912
    Top = 320
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Inventory_SetErased'
    Left = 542
    Top = 512
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Inventory_SetUnErased'
    Left = 598
    Top = 520
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Inventory'
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
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summ'
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
        Name = 'inCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Count'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartNumber'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartNumber'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoodsId'
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
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AssetId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageId'
        Value = Null
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
      end>
    Left = 176
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Inventory'
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
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summ'
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
        Name = 'inCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Count'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartNumber'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartNumber'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoodsId'
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
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AssetId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageId'
        Value = Null
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
    ComponentList = <>
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
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Inventory_Print'
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
      end>
    PackSize = 1
    Left = 319
    Top = 208
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
    Left = 360
    Top = 8
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
    Left = 568
    Top = 8
  end
  object spInsertUpdateMIAmount: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Inventory_Amount'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 330
    Top = 384
  end
  object spUpdateMIMaster_Summ: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_Inventory_Summ'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSumm'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
    Top = 328
  end
  object spInsert_MI_Inventory_bySend: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Inventory_bySend'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inMovementId_Send'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId_Send'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsAdd'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 80
    Top = 416
  end
  object spSelectPrintSticker: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Income_PrintSticker'
    DataSet = PrintItemsCDS
    DataSets = <
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
      end>
    PackSize = 1
    Left = 631
    Top = 208
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 376
    Top = 56
  end
  object HeaderChanger: THeaderChanger
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    ChangerList = <
      item
        Control = cbisGoodsGroupExc
      end
      item
        Control = cbisGoodsGroupIn
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Action = actRefreshGet
    Left = 736
    Top = 333
  end
  object spDelete_MI_Inventory_bySend: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Inventory_bySend'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inMovementId_Send'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MovementId_Send'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsAdd'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 72
    Top = 464
  end
  object spUpdate_PartionGoods: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_Inventory_PartionGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'PartionGoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 656
    Top = 384
  end
  object spInsert_MI_Inventory_bySeparate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Inventory_bySeparate'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inMovementId_Separate'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MovementId_Separate'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsAdd'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 248
    Top = 424
  end
  object spDelete_MI_Inventory_bySeparate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Inventory_bySeparate'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inMovementId_Separate'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MovementId_Separate'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsAdd'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 480
  end
  object spInsert_MI_Inventory_bySale: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Inventory_bySale'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inMovementId_Sale'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MovementId_Sale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsAdd'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 392
    Top = 440
  end
  object spDelete_MI_Inventory_bySale: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Inventory_bySale'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inMovementId_Sale'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MovementId_Sale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsAdd'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 384
    Top = 488
  end
  object GuidesPriceList: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPriceList
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPriceList
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 876
    Top = 8
  end
  object PartionCellCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 912
    Top = 432
  end
  object PartionCellDS: TDataSource
    DataSet = PartionCellCDS
    Left = 968
    Top = 408
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
    Left = 918
    Top = 385
  end
  object spSelect_MI_PartionCell: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_Inventory_PartionCell'
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
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 872
    Top = 480
  end
  object spInsertUpdateMIPartionCell: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Inventory_PartionCell'
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
        Name = 'inisPartionCell_Close_1'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'isPartionCell_Close_1'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsDate'
        Value = Null
        Component = PartionCellCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 792
    Top = 392
  end
  object spErasedMIPC: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Inventory_SetErased'
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
    Left = 526
    Top = 440
  end
  object spUnErasedMIPC: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Inventory_SetUnErased'
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
    Left = 590
    Top = 448
  end
end
