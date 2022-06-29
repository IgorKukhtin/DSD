inherited Report_Goods_byMovementForm: TReport_Goods_byMovementForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1086#1090#1075#1088#1091#1079#1082#1072#1084'>'
  ClientHeight = 542
  ClientWidth = 894
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 910
  ExplicitHeight = 581
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 80
    Width = 894
    Height = 248
    TabOrder = 3
    ExplicitTop = 80
    ExplicitWidth = 894
    ExplicitHeight = 248
    ClientRectBottom = 248
    ClientRectRight = 894
    ClientRectTop = 24
    inherited tsMain: TcxTabSheet
      Caption = #1043#1086#1090#1086#1074#1072#1103' '#1087#1088#1086#1076#1091#1082#1094#1080#1103
      TabVisible = True
      ExplicitTop = 24
      ExplicitWidth = 894
      ExplicitHeight = 224
      inherited cxGrid: TcxGrid
        Width = 894
        Height = 224
        ExplicitWidth = 894
        ExplicitHeight = 224
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object NumLine: TcxGridDBColumn
            Caption = #8470' '#1087'.'#1087'.'
            DataBinding.FieldName = 'NumLine'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object colGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GroupName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 300
          end
          object SaleAmount: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075
            DataBinding.FieldName = 'SaleAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmount: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075
            DataBinding.FieldName = 'ReturnAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object Amount: TcxGridDBColumn
            Caption = #1063#1080#1089#1090#1072#1103' '#1087#1088#1086#1076#1072#1078#1072', '#1082#1075
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object SaleAmountPartner: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'SaleAmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmountPartner: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'ReturnAmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object AmountPartner: TcxGridDBColumn
            Caption = #1063#1080#1089#1090#1072#1103' '#1087#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object isTop: TcxGridDBColumn
            DataBinding.FieldName = 'isTop'
            Visible = False
            Width = 20
          end
          object ColorRecord: TcxGridDBColumn
            DataBinding.FieldName = 'ColorRecord'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object BoldRecord: TcxGridDBColumn
            DataBinding.FieldName = 'BoldRecord'
            Visible = False
            VisibleForCustomization = False
          end
        end
      end
    end
    object tsPivot: TcxTabSheet
      Caption = #1058#1091#1096#1077#1085#1082#1072
      ImageIndex = 1
      object cxGridPivot: TcxGrid
        Left = 0
        Top = 0
        Width = 894
        Height = 224
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 0
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSaleAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chReturnAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chReturnAmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSaleAmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPartner
            end>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object chNumLine: TcxGridDBColumn
            Caption = #8470' '#1087'.'#1087'.'
            DataBinding.FieldName = 'NumLine'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object chGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GroupName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 300
          end
          object chSaleAmount: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075
            DataBinding.FieldName = 'SaleAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object chReturnAmount: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075
            DataBinding.FieldName = 'ReturnAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object chAmount: TcxGridDBColumn
            Caption = #1063#1080#1089#1090#1072#1103' '#1087#1088#1086#1076#1072#1078#1072', '#1082#1075
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object chReturnAmountPartner: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'ReturnAmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object chSaleAmountPartner: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'SaleAmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object chAmountPartner: TcxGridDBColumn
            Caption = #1063#1080#1089#1090#1072#1103' '#1087#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object chSaleAmountSh: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1077#1076'.'
            DataBinding.FieldName = 'SaleAmountSh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object chReturnAmountSh: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1077#1076'.'
            DataBinding.FieldName = 'ReturnAmountSh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object chAmountSh: TcxGridDBColumn
            Caption = #1063#1080#1089#1090#1072#1103' '#1087#1088#1086#1076#1072#1078#1072', '#1077#1076'.'
            DataBinding.FieldName = 'AmountSh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object chReturnAmountPartnerSh: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1077#1076'. ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'ReturnAmountPartnerSh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object chSaleAmountPartnerSh: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1077#1076'. ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'SaleAmountPartnerSh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object chAmountPartnerSh: TcxGridDBColumn
            Caption = #1063#1080#1089#1090#1072#1103' '#1087#1088#1086#1076#1072#1078#1072', '#1077#1076'. ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'AmountPartnerSh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object chisTop: TcxGridDBColumn
            DataBinding.FieldName = 'isTop'
            Visible = False
            VisibleForCustomization = False
            Width = 20
          end
          object chColorRecord: TcxGridDBColumn
            DataBinding.FieldName = 'ColorRecord'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object chBoldRecord: TcxGridDBColumn
            DataBinding.FieldName = 'BoldRecord'
            Visible = False
            VisibleForCustomization = False
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
    end
    object tsDetail: TcxTabSheet
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086
      ImageIndex = 1
      object cxGridDetail: TcxGrid
        Left = 0
        Top = 0
        Width = 894
        Height = 224
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 0
        object cxGridDBTableViewDetail: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DSDetail
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.00;-,0.00'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00;0.00;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SaleAmount_11
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ReturnAmount_11
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
              Column = OrderAmount_11
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = MoreAmount_11
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = UnderAmount_11
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DiffAmount_11
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OrderAmount_21
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = MoreAmount_21
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = UnderAmount_21
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DiffAmount_21
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_11
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_11
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_12
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_12
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_13
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_13
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_21
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_21
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_1_Alan
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_1_Alan
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_1_SpecCeh
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_1_SpecCeh
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_1_Varto
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_1_Varto
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_1_Nashi
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_1_Nashi
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_1_Amstor
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_1_Amstor
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_1_Fitness
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_1_Fitness
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_1_PovnaChasha
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_1_PovnaChasha
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_1_Premiya
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_1_Premiya
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_1_Irna
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_1_Irna
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_1_Ashan
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_1_Ashan
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_1_Horeca
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_1_Horeca
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_1_Aro
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_1_Aro
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_1_Hit
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_1_Hit
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_1_Num1
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_1_Num1
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_2_Alan
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_2_Alan
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = SaleAmount_2_Nashi
            end
            item
              Format = ',0.#'
              Kind = skSum
              Column = ReturnAmount_2_Nashi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OrderAmount_11
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = MoreAmount_11
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = UnderAmount_11
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DiffAmount_11
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = OrderAmount_21
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = MoreAmount_21
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = UnderAmount_21
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DiffAmount_21
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object cdNumLine: TcxGridDBColumn
            Caption = #8470' '#1087'.'#1087'.'
            DataBinding.FieldName = 'NumLine'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object GroupNum: TcxGridDBColumn
            DataBinding.FieldName = 'GroupNum'
            Visible = False
            VisibleForCustomization = False
            Width = 52
          end
          object Num: TcxGridDBColumn
            DataBinding.FieldName = 'Num'
            Visible = False
            VisibleForCustomization = False
            Width = 60
          end
          object Num2: TcxGridDBColumn
            DataBinding.FieldName = 'Num2'
            Visible = False
            VisibleForCustomization = False
            Width = 60
          end
          object GroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GroupName'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 300
          end
          object cdColorRecord: TcxGridDBColumn
            DataBinding.FieldName = 'ColorRecord'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 75
          end
          object cdBoldRecord: TcxGridDBColumn
            DataBinding.FieldName = 'BoldRecord'
            Visible = False
            VisibleForCustomization = False
          end
          object dSaleAmount: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075
            DataBinding.FieldName = 'SaleAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 90
          end
          object dReturnAmount: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075
            DataBinding.FieldName = 'ReturnAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 90
          end
          object SaleAmountSh: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1077#1076'.'
            DataBinding.FieldName = 'SaleAmountSh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 100
          end
          object ReturnAmountSh: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1077#1076
            DataBinding.FieldName = 'ReturnAmountSh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 90
          end
          object DOW_StartDate: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1085#1072#1095'.'
            DataBinding.FieldName = 'DOW_StartDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object StartDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '
            DataBinding.FieldName = 'StartDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object DOW_EndDate: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1082#1086#1085'.'
            DataBinding.FieldName = 'DOW_EndDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object EndDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'  '#1082#1086#1085'.'
            DataBinding.FieldName = 'EndDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object SaleAmount_11: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072' '#1048#1058#1054#1043#1054', '#1082#1075' ('#1082#1086#1083#1073#1072#1089#1072')'
            DataBinding.FieldName = 'SaleAmount_11'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmount_11: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090' '#1048#1058#1054#1043#1054', '#1082#1075' ('#1082#1086#1083#1073#1072#1089#1072')'
            DataBinding.FieldName = 'ReturnAmount_11'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object OrderAmount_11: TcxGridDBColumn
            Caption = #1047#1072#1103#1074#1082#1072' '#1048#1058#1054#1043#1054', '#1082#1075' ('#1082#1086#1083#1073#1072#1089#1072')'
            DataBinding.FieldName = 'OrderAmount_11'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object MoreAmount_11: TcxGridDBColumn
            Caption = #1041#1086#1083#1100#1096#1077' '#1079#1072#1103#1074#1082#1080' '#1048#1058#1054#1043#1054', '#1082#1075' ('#1082#1086#1083#1073#1072#1089#1072')'
            DataBinding.FieldName = 'MoreAmount_11'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object UnderAmount_11: TcxGridDBColumn
            Caption = #1052#1077#1085#1100#1096#1077' '#1079#1072#1103#1074#1082#1080' '#1048#1058#1054#1043#1054', '#1082#1075' ('#1082#1086#1083#1073#1072#1089#1072')'
            DataBinding.FieldName = 'UnderAmount_11'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object DiffAmount_11: TcxGridDBColumn
            Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1103' '#1087#1088#1086#1076#1072#1078#1080' '#1086#1090' '#1079#1072#1103#1074#1082#1080' '#1048#1058#1054#1043#1054', '#1082#1075' ('#1082#1086#1083#1073#1072#1089#1072')'
            DataBinding.FieldName = 'DiffAmount_11'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SaleAmount_12: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1075#1088'. '#1040#1083#1072#1085')'
            DataBinding.FieldName = 'SaleAmount_12'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object ReturnAmount_12: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1075#1088'. '#1040#1083#1072#1085')'
            DataBinding.FieldName = 'ReturnAmount_12'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object SaleAmount_13: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1075#1088'. '#1048#1088#1085#1072')'
            DataBinding.FieldName = 'SaleAmount_13'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object ReturnAmount_13: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1075#1088'. '#1048#1088#1085#1072')'
            DataBinding.FieldName = 'ReturnAmount_13'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SaleAmount_1_Alan: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1040#1083#1072#1085')'
            DataBinding.FieldName = 'SaleAmount_1_Alan'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmount_1_Alan: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1040#1083#1072#1085')'
            DataBinding.FieldName = 'ReturnAmount_1_Alan'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SaleAmount_1_SpecCeh: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1057#1087#1077#1094' '#1062#1077#1093')'
            DataBinding.FieldName = 'SaleAmount_1_SpecCeh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmount_1_SpecCeh: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1057#1087#1077#1094' '#1062#1077#1093')'
            DataBinding.FieldName = 'ReturnAmount_1_SpecCeh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SaleAmount_1_Varto: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1042#1072#1088#1090#1086')'
            DataBinding.FieldName = 'SaleAmount_1_Varto'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmount_1_Varto: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1042#1072#1088#1090#1086')'
            DataBinding.FieldName = 'ReturnAmount_1_Varto'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SaleAmount_1_Nashi: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1053#1072#1096#1080' '#1050#1086#1074#1073#1072#1089#1080')'
            DataBinding.FieldName = 'SaleAmount_1_Nashi'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmount_1_Nashi: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1053#1072#1096#1080' '#1050#1086#1074#1073#1072#1089#1080')'
            DataBinding.FieldName = 'ReturnAmount_1_Nashi'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SaleAmount_1_Amstor: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1040#1084#1089#1090#1086#1088')'
            DataBinding.FieldName = 'SaleAmount_1_Amstor'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmount_1_Amstor: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1040#1084#1089#1090#1086#1088')'
            DataBinding.FieldName = 'ReturnAmount_1_Amstor'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SaleAmount_1_Fitness: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1060#1080#1090#1085#1077#1089' '#1060#1086#1088#1084#1072#1090')'
            DataBinding.FieldName = 'SaleAmount_1_Fitness'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmount_1_Fitness: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1060#1080#1090#1085#1077#1089' '#1060#1086#1088#1084#1072#1090')'
            DataBinding.FieldName = 'ReturnAmount_1_Fitness'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SaleAmount_1_PovnaChasha: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1055#1086#1074#1085#1072' '#1063#1072#1096#1072')'
            DataBinding.FieldName = 'SaleAmount_1_PovnaChasha'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmount_1_PovnaChasha: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1055#1086#1074#1085#1072' '#1063#1072#1096#1072')'
            DataBinding.FieldName = 'ReturnAmount_1_PovnaChasha'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SaleAmount_1_Premiya: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1055#1088#1077#1084#1080#1103')'
            DataBinding.FieldName = 'SaleAmount_1_Premiya'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmount_1_Premiya: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1055#1088#1077#1084#1080#1103')'
            DataBinding.FieldName = 'ReturnAmount_1_Premiya'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SaleAmount_1_Irna: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1048#1088#1085#1072')'
            DataBinding.FieldName = 'SaleAmount_1_Irna'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmount_1_Irna: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1048#1088#1085#1072')'
            DataBinding.FieldName = 'ReturnAmount_1_Irna'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SaleAmount_1_Ashan: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1040#1096#1072#1085')'
            DataBinding.FieldName = 'SaleAmount_1_Ashan'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmount_1_Ashan: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1040#1096#1072#1085')'
            DataBinding.FieldName = 'ReturnAmount_1_Ashan'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SaleAmount_1_Horeca: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' Horeca Select)'
            DataBinding.FieldName = 'SaleAmount_1_Horeca'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmount_1_Horeca: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' Horeca Select)'
            DataBinding.FieldName = 'ReturnAmount_1_Horeca'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SaleAmount_1_Aro: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' ARO)'
            DataBinding.FieldName = 'SaleAmount_1_Aro'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmount_1_Aro: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' ARO)'
            DataBinding.FieldName = 'ReturnAmount_1_Aro'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SaleAmount_1_Hit: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1061#1080#1090' '#1055#1088#1086#1076#1091#1082#1090')'
            DataBinding.FieldName = 'SaleAmount_1_Hit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmount_1_Hit: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1061#1080#1090' '#1055#1088#1086#1076#1091#1082#1090')'
            DataBinding.FieldName = 'ReturnAmount_1_Hit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SaleAmount_1_Num1: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#8470' 1)'
            DataBinding.FieldName = 'SaleAmount_1_Num1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmount_1_Num1: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#8470' 1)'
            DataBinding.FieldName = 'ReturnAmount_1_Num1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SaleAmount_21: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072' '#1048#1058#1054#1043#1054', '#1077#1076' ('#1090#1091#1096#1077#1085#1082#1072')'
            DataBinding.FieldName = 'SaleAmount_21'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmount_21: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090' '#1048#1058#1054#1043#1054', '#1077#1076' ('#1090#1091#1096#1077#1085#1082#1072')'
            DataBinding.FieldName = 'ReturnAmount_21'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object OrderAmount_21: TcxGridDBColumn
            Caption = #1047#1072#1103#1074#1072' '#1048#1058#1054#1043#1054', '#1077#1076' ('#1090#1091#1096#1077#1085#1082#1072')'
            DataBinding.FieldName = 'OrderAmount_21'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object MoreAmount_21: TcxGridDBColumn
            Caption = #1041#1086#1083#1100#1096#1077' '#1079#1072#1103#1074#1082#1080' '#1048#1058#1054#1043#1054', '#1077#1076' ('#1090#1091#1096#1077#1085#1082#1072')'
            DataBinding.FieldName = 'MoreAmount_21'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object UnderAmount_21: TcxGridDBColumn
            Caption = #1052#1077#1085#1100#1096#1077' '#1079#1072#1103#1074#1082#1080' '#1048#1058#1054#1043#1054', '#1077#1076' ('#1090#1091#1096#1077#1085#1082#1072')'
            DataBinding.FieldName = 'UnderAmount_21'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object DiffAmount_21: TcxGridDBColumn
            Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1103' '#1087#1088#1086#1076#1072#1078#1080' '#1086#1090' '#1079#1072#1103#1074#1082#1080' '#1048#1058#1054#1043#1054', '#1077#1076' ('#1090#1091#1096#1077#1085#1082#1072')'
            DataBinding.FieldName = 'DiffAmount_21'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SaleAmount_2_Alan: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1077#1076' ('#1090#1091#1096#1077#1085#1082#1072', '#1090#1084' '#1040#1083#1072#1085')'
            DataBinding.FieldName = 'SaleAmount_2_Alan'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmount_2_Alan: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1077#1076' ('#1090#1091#1096#1077#1085#1082#1072', '#1090#1084' '#1040#1083#1072#1085')'
            DataBinding.FieldName = 'ReturnAmount_2_Alan'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object SaleAmount_2_Nashi: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072', '#1077#1076' ('#1090#1091#1096#1077#1085#1082#1072', '#1090#1084' '#1053#1072#1096#1080' '#1050#1086#1074#1073#1072#1089#1080')'
            DataBinding.FieldName = 'SaleAmount_2_Nashi'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ReturnAmount_2_Nashi: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1077#1076' ('#1090#1091#1096#1077#1085#1082#1072', '#1090#1084' '#1053#1072#1096#1080' '#1050#1086#1074#1073#1072#1089#1080')'
            DataBinding.FieldName = 'ReturnAmount_2_Nashi'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBTableViewDetail
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 894
    Height = 54
    ExplicitWidth = 894
    ExplicitHeight = 54
    inherited deStart: TcxDateEdit
      Left = 59
      EditValue = 43101d
      Properties.SaveTime = False
      ExplicitLeft = 59
    end
    inherited deEnd: TcxDateEdit
      Left = 59
      Top = 30
      EditValue = 43101d
      Properties.SaveTime = False
      ExplicitLeft = 59
      ExplicitTop = 30
    end
    inherited cxLabel1: TcxLabel
      Left = 12
      Caption = #1044#1072#1090#1072' '#1089' :'
      ExplicitLeft = 12
      ExplicitWidth = 45
    end
    inherited cxLabel2: TcxLabel
      Left = 5
      Top = 31
      Caption = #1044#1072#1090#1072' '#1087#1086' :'
      ExplicitLeft = 5
      ExplicitTop = 31
      ExplicitWidth = 52
    end
    object cxLabel4: TcxLabel
      Left = 472
      Top = 31
      Caption = #1043#1088'. '#1090#1086#1074'. '#1058#1091#1096#1077#1085#1082#1072':'
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 574
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 196
    end
    object cxLabel3: TcxLabel
      Left = 148
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 238
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 226
    end
    object cxLabel5: TcxLabel
      Left = 148
      Top = 31
      Caption = #1043#1088'. '#1087#1086#1076#1088#1072#1079#1076'. '#1042#1086#1079#1074#1088#1072#1090':'
    end
    object edUnitGroup: TcxButtonEdit
      Left = 264
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 200
    end
    object cxLabel8: TcxLabel
      Left = 469
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074' '#1043#1055':'
    end
    object edGoodsGroupGP: TcxButtonEdit
      Left = 574
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 196
    end
    object chWeek: TcxCheckBox
      Left = 784
      Top = 5
      Caption = #1087#1086' '#1085#1077#1076#1077#1083#1103#1084
      TabOrder = 12
      Width = 97
    end
    object chMonth: TcxCheckBox
      Left = 784
      Top = 30
      Caption = #1087#1086' '#1084#1077#1089#1103#1094#1072#1084
      TabOrder = 13
      Width = 97
    end
  end
  object grChart: TcxGrid [2]
    Left = 0
    Top = 336
    Width = 894
    Height = 206
    Align = alBottom
    TabOrder = 6
    object grChartDBChartView1: TcxGridDBChartView
      DataController.DataSource = DSDetail
      DiagramArea.Values.LineWidth = 2
      DiagramLine.Active = True
      DiagramLine.Values.LineWidth = 2
      ToolBox.CustomizeButton = True
      ToolBox.DiagramSelector = True
      object dgOperDate: TcxGridDBChartDataGroup
        DataBinding.FieldName = 'StartDate'
        DisplayText = #1044#1072#1090#1072' '#1085#1072#1095'.'
      end
      object serSaleAmount_11: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_11'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072' '#1048#1058#1054#1043#1054', '#1082#1075' ('#1082#1086#1083#1073#1072#1089#1072')'
      end
      object serReturnAmount_11: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_11'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090' '#1048#1058#1054#1043#1054', '#1082#1075' ('#1082#1086#1083#1073#1072#1089#1072')'
        Visible = False
      end
      object serOrderAmount_11: TcxGridDBChartSeries
        DataBinding.FieldName = 'OrderAmount_11'
        DisplayText = #1047#1072#1103#1074#1082#1072' '#1048#1058#1054#1043#1054', '#1082#1075' ('#1082#1086#1083#1073#1072#1089#1072')'
      end
      object serMoreAmount_11: TcxGridDBChartSeries
        DataBinding.FieldName = 'MoreAmount_11'
        DisplayText = #1041#1086#1083#1100#1096#1077' '#1079#1072#1103#1074#1082#1080' '#1048#1058#1054#1043#1054', '#1082#1075' ('#1082#1086#1083#1073#1072#1089#1072')'
      end
      object serUnderAmount_11: TcxGridDBChartSeries
        DataBinding.FieldName = 'UnderAmount_11'
        DisplayText = #1052#1077#1085#1100#1096#1077' '#1079#1072#1103#1074#1082#1080' '#1048#1058#1054#1043#1054', '#1082#1075' ('#1082#1086#1083#1073#1072#1089#1072')'
      end
      object serSaleAmount_12: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_12'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1075#1088'. '#1040#1083#1072#1085')'
        Visible = False
      end
      object serReturnAmount_12: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_12'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1075#1088'. '#1040#1083#1072#1085')'
        Visible = False
      end
      object serSaleAmount_13: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_13'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1075#1088'. '#1048#1088#1085#1072')'
        Visible = False
      end
      object serReturnAmount_13: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_13'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1075#1088'. '#1048#1088#1085#1072')'
        Visible = False
      end
      object serSaleAmount_1_Alan: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_1_Alan'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1040#1083#1072#1085')'
        Visible = False
      end
      object serReturnAmount_1_Alan: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_1_Alan'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1040#1083#1072#1085')'
        Visible = False
      end
      object serSaleAmount_1_SpecCeh: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_1_SpecCeh'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1057#1087#1077#1094' '#1062#1077#1093')'
        Visible = False
      end
      object serReturnAmount_1_SpecCeh: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_1_SpecCeh'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1057#1087#1077#1094' '#1062#1077#1093')'
        Visible = False
      end
      object serSaleAmount_1_Varto: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_1_Varto'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1042#1072#1088#1090#1086')'
        Visible = False
      end
      object serReturnAmount_1_Varto: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_1_Varto'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1042#1072#1088#1090#1086')'
        Visible = False
      end
      object serSaleAmount_1_Nashi: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_1_Nashi'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1053#1072#1096#1080' '#1050#1086#1074#1073#1072#1089#1080')'
        Visible = False
      end
      object serReturnAmount_1_Nashi: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_1_Nashi'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1053#1072#1096#1080' '#1050#1086#1074#1073#1072#1089#1080')'
        Visible = False
      end
      object serSaleAmount_1_Amstor: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_1_Amstor'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1040#1084#1089#1090#1086#1088')'
        Visible = False
      end
      object serReturnAmount_1_Amstor: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_1_Amstor'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1040#1084#1089#1090#1086#1088')'
        Visible = False
      end
      object serSaleAmount_1_Fitness: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_1_Fitness'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1060#1080#1090#1085#1077#1089' '#1060#1086#1088#1084#1072#1090')'
        Visible = False
      end
      object serReturnAmount_1_Fitness: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_1_Fitness'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1060#1080#1090#1085#1077#1089' '#1060#1086#1088#1084#1072#1090')'
        Visible = False
      end
      object serSaleAmount_1_PovnaChasha: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_1_PovnaChasha'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1055#1086#1074#1085#1072' '#1063#1072#1096#1072')'
        Visible = False
      end
      object serReturnAmount_1_PovnaChasha: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_1_PovnaChasha'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1055#1086#1074#1085#1072' '#1063#1072#1096#1072')'
        Visible = False
      end
      object serSaleAmount_1_Premiya: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_1_Premiya'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1055#1088#1077#1084#1080#1103')'
        Visible = False
      end
      object serReturnAmount_1_Premiya: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_1_Premiya'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1055#1088#1077#1084#1080#1103')'
        Visible = False
      end
      object serSaleAmount_1_Irna: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_1_Irna'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1048#1088#1085#1072')'
        Visible = False
      end
      object serReturnAmount_1_Irna: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_1_Irna'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1048#1088#1085#1072')'
        Visible = False
      end
      object serSaleAmount_1_Ashan: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_1_Ashan'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1040#1096#1072#1085')'
        Visible = False
      end
      object serReturnAmount_1_Ashan: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_1_Ashan'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1040#1096#1072#1085')'
        Visible = False
      end
      object serSaleAmount_1_Horeca: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_1_Horeca'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' Horeca Select)'
        Visible = False
      end
      object serReturnAmount_1_Horeca: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_1_Horeca'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' Horeca Select)'
        Visible = False
      end
      object serSaleAmount_1_Aro: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_1_Aro'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' ARO)'
        Visible = False
      end
      object serReturnAmount_1_Aro: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_1_Aro'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' ARO)'
        Visible = False
      end
      object serSaleAmount_1_Hit: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_1_Hit'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#1061#1080#1090' '#1055#1088#1086#1076#1091#1082#1090')'
        Visible = False
      end
      object serReturnAmount_1_Hit: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_1_Hit'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#1061#1080#1090' '#1055#1088#1086#1076#1091#1082#1090')'
        Visible = False
      end
      object serSaleAmount_1_Num1: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_1_Num1'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072', '#1082#1075' ('#1090#1084' '#8470' 1)'
        Visible = False
      end
      object serReturnAmount_1_Num1: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_1_Num1'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1090#1084' '#8470' 1)'
        Visible = False
      end
      object serSaleAmount_21: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_21'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072' '#1048#1058#1054#1043#1054', '#1077#1076' ('#1090#1091#1096#1077#1085#1082#1072')'
        Visible = False
      end
      object serReturnAmount_21: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_21'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090' '#1048#1058#1054#1043#1054', '#1077#1076' ('#1090#1091#1096#1077#1085#1082#1072')'
        Visible = False
      end
      object serOrderAmount_21: TcxGridDBChartSeries
        DataBinding.FieldName = 'OrderAmount_21'
        DisplayText = #1047#1072#1103#1074#1082#1072' '#1048#1058#1054#1043#1054',  '#1077#1076' ('#1090#1091#1096#1077#1085#1082#1072')'
      end
      object serMoreAmount_21: TcxGridDBChartSeries
        DataBinding.FieldName = 'MoreAmount_21'
        DisplayText = #1041#1086#1083#1100#1096#1077' '#1079#1072#1103#1074#1082#1080' '#1048#1058#1054#1043#1054',  '#1077#1076' ('#1090#1091#1096#1077#1085#1082#1072')'
      end
      object serUnderAmount_1: TcxGridDBChartSeries
        DataBinding.FieldName = 'UnderAmount_21'
        DisplayText = #1052#1077#1085#1100#1096#1077' '#1079#1072#1103#1074#1082#1080' '#1048#1058#1054#1043#1054',  '#1077#1076' ('#1090#1091#1096#1077#1085#1082#1072')'
      end
      object serSaleAmount_2_Alan: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_2_Alan'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072', '#1077#1076' ('#1090#1091#1096#1077#1085#1082#1072', '#1090#1084' '#1040#1083#1072#1085')'
        Visible = False
      end
      object serReturnAmount_2_Alan: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_2_Alan'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090', '#1077#1076' ('#1090#1091#1096#1077#1085#1082#1072', '#1090#1084' '#1040#1083#1072#1085')'
        Visible = False
      end
      object serSaleAmount_2_Nashi: TcxGridDBChartSeries
        DataBinding.FieldName = 'SaleAmount_2_Nashi'
        DisplayText = #1055#1088#1086#1076#1072#1078#1072', '#1077#1076' ('#1090#1091#1096#1077#1085#1082#1072', '#1090#1084' '#1053#1072#1096#1080' '#1050#1086#1074#1073#1072#1089#1080')'
        Visible = False
      end
      object serReturnAmount_2_Nashi: TcxGridDBChartSeries
        DataBinding.FieldName = 'ReturnAmount_2_Nashi'
        DisplayText = #1042#1086#1079#1074#1088#1072#1090', '#1077#1076' ('#1090#1091#1096#1077#1085#1082#1072', '#1090#1084' '#1053#1072#1096#1080' '#1050#1086#1074#1073#1072#1089#1080')'
        Visible = False
      end
    end
    object grChartLevel1: TcxGridLevel
      GridView = grChartDBChartView1
    end
  end
  object cxSplitter1: TcxSplitter [3]
    Left = 0
    Top = 328
    Width = 894
    Height = 8
    HotZoneClassName = 'TcxMediaPlayer8Style'
    AlignSplitter = salBottom
    Control = grChart
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 312
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = chWeek
        Properties.Strings = (
          'Checked')
      end
      item
        Component = chMonth
        Properties.Strings = (
          'Checked')
      end>
  end
  inherited ActionList: TActionList
    inherited actGridToExcel: TdsdGridToExcel
      TabSheet = tsMain
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Goods_byMovementDialogForm'
      FormNameParam.Value = 'TReport_Goods_byMovementDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = UnitGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = UnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupId'
          Value = ''
          Component = UnitGroupGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = UnitGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId_gp'
          Value = ''
          Component = GoodsGroupGPGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName_gp'
          Value = ''
          Component = GoodsGroupGPGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inWeek'
          Value = Null
          Component = chWeek
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMonth'
          Value = Null
          Component = chMonth
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'NumLine'
        end
        item
          DataSet = ChildCDS
          UserName = 'frxDBDChild'
          IndexFieldNames = 'NumLine'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupGPName'
          Value = Null
          Component = GoodsGroupGPGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReportName'
          Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1072#1084
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1055#1086' '#1054#1090#1075#1088#1091#1079#1082#1072#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1055#1086' '#1054#1090#1075#1088#1091#1079#1082#1072#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPivotToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      TabSheet = tsPivot
      MoveParams = <>
      Enabled = False
      Grid = cxGridPivot
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actDetailToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      TabSheet = tsDetail
      MoveParams = <>
      Enabled = False
      Grid = cxGridDetail
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
  end
  inherited MasterDS: TDataSource
    Left = 88
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Goods_byMovement'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ChildCDS
      end
      item
        DataSet = DetailCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitGroupId'
        Value = ''
        Component = UnitGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupGPId'
        Value = ''
        Component = GoodsGroupGPGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeek'
        Value = Null
        Component = chWeek
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMonth'
        Value = Null
        Component = chMonth
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 224
    Top = 224
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 240
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
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
          ItemName = 'bbPrint'
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
          ItemName = 'bbPivotToExcel'
        end
        item
          Visible = True
          ItemName = 'bbDetailToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bb: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbPivotToExcel: TdxBarButton
      Action = actPivotToExcel
      Category = 0
    end
    object bbDetailToExcel: TdxBarButton
      Action = actDetailToExcel
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = ''
    ColorRuleList = <
      item
        ValueColumn = ColorRecord
        ColorValueList = <>
        ValueBoldColumn = BoldRecord
      end>
    Left = 24
    Top = 152
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 288
    Top = 136
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = UnitGuides
      end
      item
      end
      item
        Component = GoodsGroupGuides
      end
      item
      end
      item
      end
      item
      end>
    Left = 208
    Top = 168
  end
  object GoodsGroupGuides: TdsdGuides
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
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 656
    Top = 16
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 312
    Top = 194
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 360
  end
  object GoodsGroupGPGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroupGP
    FormNameParam.Value = 'TGoodsGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupGPGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGPGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 721
    Top = 3
  end
  object UnitGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitGroup
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 400
    Top = 16
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 632
    Top = 200
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 576
    Top = 216
  end
  object ChildDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ValueColumn = chColorRecord
        ColorValueList = <>
        ValueBoldColumn = chBoldRecord
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 680
    Top = 232
  end
  object DetailCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 832
    Top = 200
  end
  object DSDetail: TDataSource
    DataSet = DetailCDS
    Left = 776
    Top = 200
  end
  object DetaildsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewDetail
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ValueColumn = cdColorRecord
        ColorValueList = <>
        ValueBoldColumn = cdBoldRecord
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 809
    Top = 192
  end
end
