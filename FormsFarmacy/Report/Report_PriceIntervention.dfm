inherited Report_PriceInterventionForm: TReport_PriceInterventionForm
  Caption = #1054#1090#1095#1077#1090' '#1062#1077#1085#1086#1074#1072#1103' '#1080#1085#1090#1077#1088#1074#1077#1085#1094#1080#1103
  ClientHeight = 431
  ClientWidth = 1212
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1228
  ExplicitHeight = 469
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 91
    Width = 1212
    Height = 340
    TabOrder = 5
    ExplicitTop = 91
    ExplicitWidth = 1212
    ExplicitHeight = 340
    ClientRectBottom = 340
    ClientRectRight = 1212
    ClientRectTop = 24
    inherited tsMain: TcxTabSheet
      Caption = #1048#1090#1086#1075#1080
      TabVisible = True
      ExplicitTop = 24
      ExplicitWidth = 1212
      ExplicitHeight = 316
      inherited cxGrid: TcxGrid
        Width = 1212
        Height = 316
        ExplicitWidth = 1212
        ExplicitHeight = 316
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
        object cxGridDBBandedTableView1: TcxGridDBBandedTableView [1]
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSale1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSale2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSale3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSale4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSale5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSale6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSale7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtSummaSale1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtProfit1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtSummaSale2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtProfit2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtSummaSale3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtProfit3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtSummaSale4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtProfit4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtSummaSale5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtProfit5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtSummaSale6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtProfit6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtSummaSale7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtProfit7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaProfit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaProfit1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaProfit2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaProfit3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaProfit4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaProfit5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaProfit6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaProfit7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtProfit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtSummaSale
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = '0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSale1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSale2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSale3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSale4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSale5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSale6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaSale7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtSummaSale1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtProfit1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtSummaSale2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtProfit2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtSummaSale3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtProfit3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtSummaSale4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtProfit4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtSummaSale5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtProfit5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtSummaSale6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtProfit6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtSummaSale7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtProfit7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaProfit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaProfit1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaProfit2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaProfit3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaProfit4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaProfit5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaProfit6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaProfit7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtProfit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = VirtSummaSale
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsCustomize.ColumnVertSizing = False
          OptionsCustomize.NestedBands = False
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.Footer = True
          OptionsView.FooterAutoHeight = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.HeaderFilterButtonShowMode = fbmButton
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridBandedTableViewStyleSheet
          Bands = <
            item
              Caption = #1048#1085#1092#1086
              FixedKind = fkLeft
              Options.HoldOwnColumnsOnly = True
              Options.Moving = False
              Width = 316
            end
            item
              Caption = #1048#1090#1086#1075#1086
              Options.HoldOwnColumnsOnly = True
            end
            item
              Caption = #1055#1088#1077#1076#1077#1083' 1'
              Options.HoldOwnColumnsOnly = True
            end
            item
              Caption = #1055#1088#1077#1076#1077#1083' 2'
              Options.HoldOwnColumnsOnly = True
            end
            item
              Caption = #1055#1088#1077#1076#1077#1083' 3'
              Options.HoldOwnColumnsOnly = True
            end
            item
              Caption = #1055#1088#1077#1076#1077#1083' 4'
              Options.HoldOwnColumnsOnly = True
            end
            item
              Caption = #1055#1088#1077#1076#1077#1083' 5'
              Options.HoldOwnColumnsOnly = True
            end
            item
              Caption = #1055#1088#1077#1076#1077#1083' 6'
              Options.HoldOwnColumnsOnly = True
            end
            item
              Caption = #1055#1088#1077#1076#1077#1083' 7'
              Options.HoldOwnColumnsOnly = True
            end>
          object JuridicalMainName: TcxGridDBBandedColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalMainName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 89
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object UnitName: TcxGridDBBandedColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 143
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object MarginCategoryName: TcxGridDBBandedColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1085#1072#1094#1077#1085#1082#1080' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'MarginCategoryName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 83
            Position.BandIndex = 0
            Position.ColIndex = 26
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object Amount: TcxGridDBBandedColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1050#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1050#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object SummaSale: TcxGridDBBandedColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1042' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1042' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 1
            Position.ColIndex = 1
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object Summa: TcxGridDBBandedColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1042' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            Caption = #1042' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Summa'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 1
            Position.ColIndex = 2
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentProfit: TcxGridDBBandedColumn
            AlternateCaption = #1048#1090#1086#1075#1086': % '#1076#1086#1093#1086#1076#1072
            Caption = '% '#1076#1086#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentProfit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
            Position.BandIndex = 1
            Position.ColIndex = 3
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object SummaProfit: TcxGridDBBandedColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1076#1086#1093#1086#1076
            Caption = #1076#1086#1093#1086#1076
            DataBinding.FieldName = 'SummaProfit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
            Position.BandIndex = 1
            Position.ColIndex = 4
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VirtPercent: TcxGridDBBandedColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1074#1080#1088#1090'. %'
            Caption = #1074#1080#1088#1090'. %'
            DataBinding.FieldName = 'VirtPercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
            Position.BandIndex = 1
            Position.ColIndex = 5
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VirtSummaSale: TcxGridDBBandedColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'VirtSummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 1
            Position.ColIndex = 6
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VirtProfit: TcxGridDBBandedColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            Caption = #1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'VirtProfit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 1
            Position.ColIndex = 7
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object Amount1: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 2
            Position.ColIndex = 0
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object SummaSale1: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 2
            Position.ColIndex = 1
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object Summa1: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            Caption = #1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Summa1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 2
            Position.ColIndex = 2
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentAmount1: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = '% '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PercentAmount1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 2
            Position.ColIndex = 3
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentSummaSale1: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PercentSummaSale1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 2
            Position.ColIndex = 4
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentSumma1: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentSumma1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 2
            Position.ColIndex = 5
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentProfit1: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: % '#1076#1086#1093#1086#1076#1072
            Caption = '% '#1076#1086#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentProfit1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
            Position.BandIndex = 2
            Position.ColIndex = 6
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object SummaProfit1: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: '#1076#1086#1093#1086#1076
            Caption = #1076#1086#1093#1086#1076
            DataBinding.FieldName = 'SummaProfit1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
            Position.BandIndex = 2
            Position.ColIndex = 7
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VitrPercent1: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: '#1074#1080#1088#1090'. %'
            Caption = #1074#1080#1088#1090'. %'
            DataBinding.FieldName = 'VirtPercent1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
            Position.BandIndex = 2
            Position.ColIndex = 8
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VirtSummaSale1: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'VirtSummaSale1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 2
            Position.ColIndex = 9
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VirtProfit1: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            Caption = #1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'VirtProfit1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 2
            Position.ColIndex = 11
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object MarginPercent1: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            DataBinding.FieldName = 'MarginPercent1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
            Position.BandIndex = 2
            Position.ColIndex = 10
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object Amount2: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2:  '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 3
            Position.ColIndex = 0
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object SummaSale2: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 3
            Position.ColIndex = 1
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object Summa2: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            Caption = #1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Summa2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 3
            Position.ColIndex = 2
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentAmount2: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = '% '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PercentAmount2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 3
            Position.ColIndex = 3
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentSummaSale2: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PercentSummaSale2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 3
            Position.ColIndex = 4
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentSumma2: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentSumma2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 3
            Position.ColIndex = 5
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentProfit2: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: % '#1076#1086#1093#1086#1076#1072
            Caption = '% '#1076#1086#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentProfit2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
            Position.BandIndex = 3
            Position.ColIndex = 6
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object SummaProfit2: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: '#1076#1086#1093#1086#1076
            Caption = #1076#1086#1093#1086#1076
            DataBinding.FieldName = 'SummaProfit2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
            Position.BandIndex = 3
            Position.ColIndex = 7
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VitrPercent2: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: '#1074#1080#1088#1090'. %'
            Caption = #1074#1080#1088#1090'. %'
            DataBinding.FieldName = 'VirtPercent2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
            Position.BandIndex = 3
            Position.ColIndex = 8
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VirtSummaSale2: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'VirtSummaSale2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 3
            Position.ColIndex = 10
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VirtProfit2: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            Caption = #1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'VirtProfit2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 3
            Position.ColIndex = 9
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object MarginPercent2: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            DataBinding.FieldName = 'MarginPercent2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
            Position.BandIndex = 3
            Position.ColIndex = 11
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object Amount3: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3:  '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 4
            Position.ColIndex = 0
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object SummaSale3: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 4
            Position.ColIndex = 1
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object Summa3: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            Caption = #1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Summa3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 4
            Position.ColIndex = 2
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentAmount3: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = '% '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PercentAmount3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 4
            Position.ColIndex = 3
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentSummaSale3: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PercentSummaSale3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 4
            Position.ColIndex = 4
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentSumma3: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentSumma3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 4
            Position.ColIndex = 5
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentProfit3: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: % '#1076#1086#1093#1086#1076#1072
            Caption = '% '#1076#1086#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentProfit3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
            Position.BandIndex = 4
            Position.ColIndex = 6
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object SummaProfit3: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: '#1076#1086#1093#1086#1076
            Caption = #1076#1086#1093#1086#1076
            DataBinding.FieldName = 'SummaProfit3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
            Position.BandIndex = 4
            Position.ColIndex = 7
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VitrPercent3: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: '#1074#1080#1088#1090'. %'
            Caption = #1074#1080#1088#1090'. %'
            DataBinding.FieldName = 'VirtPercent3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
            Position.BandIndex = 4
            Position.ColIndex = 8
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VirtSummaSale3: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3:'#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'VirtSummaSale3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 4
            Position.ColIndex = 10
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VirtProfit3: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            Caption = #1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'VirtProfit3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 4
            Position.ColIndex = 9
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object MarginPercent3: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            DataBinding.FieldName = 'MarginPercent3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
            Position.BandIndex = 4
            Position.ColIndex = 11
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object Amount4: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4:  '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 5
            Position.ColIndex = 0
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object SummaSale4: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 5
            Position.ColIndex = 1
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object Summa4: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            Caption = #1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Summa4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 5
            Position.ColIndex = 2
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentAmount4: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = '% '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PercentAmount4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 5
            Position.ColIndex = 3
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentSummaSale4: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PercentSummaSale4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 5
            Position.ColIndex = 4
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentSumma4: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentSumma4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 5
            Position.ColIndex = 5
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentProfit4: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: % '#1076#1086#1093#1086#1076#1072
            Caption = '% '#1076#1086#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentProfit4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
            Position.BandIndex = 5
            Position.ColIndex = 6
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object SummaProfit4: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: '#1076#1086#1093#1086#1076
            Caption = #1076#1086#1093#1086#1076
            DataBinding.FieldName = 'SummaProfit4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
            Position.BandIndex = 5
            Position.ColIndex = 7
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VirtPercent4: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: '#1074#1080#1088#1090'. %'
            Caption = #1074#1080#1088#1090'. %'
            DataBinding.FieldName = 'VirtPercent4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
            Position.BandIndex = 5
            Position.ColIndex = 8
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VirtSummaSale4: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'VirtSummaSale4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 5
            Position.ColIndex = 10
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object MarginPercent4: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            DataBinding.FieldName = 'MarginPercent4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
            Position.BandIndex = 5
            Position.ColIndex = 11
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VirtProfit4: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            Caption = #1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'VirtProfit4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 5
            Position.ColIndex = 9
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object Amount5: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5:  '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 6
            Position.ColIndex = 0
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object SummaSale5: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 6
            Position.ColIndex = 1
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object Summa5: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            Caption = #1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Summa5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 6
            Position.ColIndex = 2
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentAmount5: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = '% '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PercentAmount5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 6
            Position.ColIndex = 3
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentSummaSale5: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PercentSummaSale5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 6
            Position.ColIndex = 4
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentSumma5: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentSumma5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 6
            Position.ColIndex = 5
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentProfit5: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: % '#1076#1086#1093#1086#1076#1072
            Caption = '% '#1076#1086#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentProfit5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
            Position.BandIndex = 6
            Position.ColIndex = 6
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object SummaProfit5: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: '#1076#1086#1093#1086#1076
            Caption = #1076#1086#1093#1086#1076
            DataBinding.FieldName = 'SummaProfit5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
            Position.BandIndex = 6
            Position.ColIndex = 7
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VitrPercent5: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: '#1074#1080#1088#1090'. %'
            Caption = #1074#1080#1088#1090'. %'
            DataBinding.FieldName = 'VirtPercent5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
            Position.BandIndex = 6
            Position.ColIndex = 8
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VirtSummaSale5: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'VirtSummaSale5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 6
            Position.ColIndex = 10
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VirtProfit5: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            Caption = #1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'VirtProfit5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 6
            Position.ColIndex = 9
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object MarginPercent5: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            DataBinding.FieldName = 'MarginPercent5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
            Position.BandIndex = 6
            Position.ColIndex = 11
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object Amount6: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 7
            Position.ColIndex = 0
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object SummaSale6: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 7
            Position.ColIndex = 1
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object Summa6: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            Caption = #1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Summa6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 7
            Position.ColIndex = 2
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentAmount6: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = '% '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PercentAmount6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 7
            Position.ColIndex = 3
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentSummaSale6: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PercentSummaSale6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 7
            Position.ColIndex = 4
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentSumma6: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentSumma6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 7
            Position.ColIndex = 5
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentProfit6: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: % '#1076#1086#1093#1086#1076#1072
            Caption = '% '#1076#1086#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentProfit6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
            Position.BandIndex = 7
            Position.ColIndex = 6
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object SummaProfit6: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: '#1076#1086#1093#1086#1076
            Caption = #1076#1086#1093#1086#1076
            DataBinding.FieldName = 'SummaProfit6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
            Position.BandIndex = 7
            Position.ColIndex = 7
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VitrPercent6: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: '#1074#1080#1088#1090'. %'
            Caption = #1074#1080#1088#1090'. %'
            DataBinding.FieldName = 'VirtPercent6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
            Position.BandIndex = 7
            Position.ColIndex = 8
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VirtSummaSale6: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'VirtSummaSale6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 7
            Position.ColIndex = 10
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VirtProfit6: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            Caption = #1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'VirtProfit6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 7
            Position.ColIndex = 9
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object MarginPercent6: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            DataBinding.FieldName = 'MarginPercent6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
            Position.BandIndex = 7
            Position.ColIndex = 11
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object Amount7: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7:  '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 8
            Position.ColIndex = 0
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object SummaSale7: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 8
            Position.ColIndex = 1
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object Summa7: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            Caption = #1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Summa7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 8
            Position.ColIndex = 2
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentAmount7: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = '% '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PercentAmount7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 8
            Position.ColIndex = 3
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentSummaSale7: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PercentSummaSale7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 8
            Position.ColIndex = 4
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentSumma7: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentSumma7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 8
            Position.ColIndex = 5
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object PercentProfit7: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: % '#1076#1086#1093#1086#1076#1072
            Caption = '% '#1076#1086#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentProfit7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
            Position.BandIndex = 8
            Position.ColIndex = 6
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object SummaProfit7: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: '#1076#1086#1093#1086#1076
            Caption = #1076#1086#1093#1086#1076
            DataBinding.FieldName = 'SummaProfit7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
            Position.BandIndex = 8
            Position.ColIndex = 7
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VitrPercent7: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: '#1074#1080#1088#1090'. %'
            Caption = #1074#1080#1088#1090'. %'
            DataBinding.FieldName = 'VirtPercent7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
            Position.BandIndex = 8
            Position.ColIndex = 8
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VirtSummaSale7: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'VirtSummaSale7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 8
            Position.ColIndex = 10
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object VirtProfit7: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            Caption = #1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'VirtProfit7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
            Position.BandIndex = 8
            Position.ColIndex = 9
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object MarginPercent7: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            DataBinding.FieldName = 'MarginPercent7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
            Position.BandIndex = 8
            Position.ColIndex = 11
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object Color_Amount: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_Amount'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object Color_Summa: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_Summa'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object Color_SummaSale: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_SummaSale'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object Color_PercentAmount1: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentAmount1'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object Color_PercentSumma1: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSumma1'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
          object Color_PercentSummaSale1: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSummaSale1'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 7
            Position.RowIndex = 0
          end
          object Color_PercentAmount2: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentAmount2'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 8
            Position.RowIndex = 0
          end
          object Color_PercentSumma2: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSumma2'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 9
            Position.RowIndex = 0
          end
          object Color_PercentSummaSale2: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSummaSale2'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 10
            Position.RowIndex = 0
          end
          object Color_PercentAmount3: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentAmount3'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 11
            Position.RowIndex = 0
          end
          object Color_PercentSumma3: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSumma3'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 12
            Position.RowIndex = 0
          end
          object Color_PercentSummaSale3: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSummaSale3'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 13
            Position.RowIndex = 0
          end
          object Color_PercentAmount4: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentAmount4'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 14
            Position.RowIndex = 0
          end
          object Color_PercentSumma4: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSumma4'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 15
            Position.RowIndex = 0
          end
          object Color_PercentSummaSale4: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSummaSale4'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 16
            Position.RowIndex = 0
          end
          object Color_PercentAmount5: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentAmount5'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 17
            Position.RowIndex = 0
          end
          object Color_PercentSumma5: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSumma5'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 18
            Position.RowIndex = 0
          end
          object Color_PercentSummaSale5: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSummaSale5'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 19
            Position.RowIndex = 0
          end
          object Color_PercentAmount6: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentAmount6'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 20
            Position.RowIndex = 0
          end
          object Color_PercentSumma6: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSumma6'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 21
            Position.RowIndex = 0
          end
          object Color_PercentSummaSale6: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSummaSale6'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 22
            Position.RowIndex = 0
          end
          object Color_PercentAmount7: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentAmount7'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 23
            Position.RowIndex = 0
          end
          object Color_PercentSumma7: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSumma7'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 24
            Position.RowIndex = 0
          end
          object Color_PercentSummaSale7: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSummaSale7'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 25
            Position.RowIndex = 0
          end
        end
        inherited cxGridLevel: TcxGridLevel
          GridView = cxGridDBBandedTableView1
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1212
    Height = 65
    TabOrder = 9
    ExplicitWidth = 1212
    ExplicitHeight = 65
    inherited deStart: TcxDateEdit
      Left = 78
      Top = 6
      ExplicitLeft = 78
      ExplicitTop = 6
    end
    inherited deEnd: TcxDateEdit
      Left = 77
      Top = 33
      EditValue = 42371d
      TabOrder = 2
      ExplicitLeft = 77
      ExplicitTop = 33
    end
    inherited cxLabel1: TcxLabel
      Left = 15
      Top = 7
      Caption = #1053#1072#1095'.'#1076#1072#1090#1072':'
      ExplicitLeft = 15
      ExplicitTop = 7
      ExplicitWidth = 56
    end
    inherited cxLabel2: TcxLabel
      Left = 13
      Top = 18
      Caption = '-'
      Visible = False
      ExplicitLeft = 13
      ExplicitTop = 18
      ExplicitWidth = 8
    end
    object cxLabel3: TcxLabel
      Left = 868
      Top = 13
      Caption = #1042#1080#1088#1090#1091#1072#1083#1100#1085#1072#1103' '#1082#1072#1090#1077#1075#1086#1088#1080#1103' '#1085#1072#1094#1077#1085#1082#1080
    end
    object ceMarginReport: TcxButtonEdit
      Left = 875
      Top = 36
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 8
      Width = 230
    end
    object cxLabel4: TcxLabel
      Left = 15
      Top = 40
      Caption = #1050#1086#1085'.'#1076#1072#1090#1072':'
    end
    object cxLabel10: TcxLabel
      Left = 408
      Top = 7
      Caption = #1055#1088#1077#1076#1077#1083' 3 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
    end
    object cxLabel11: TcxLabel
      Left = 408
      Top = 37
      Caption = #1055#1088#1077#1076#1077#1083' 4 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
    end
    object cePrice3: TcxCurrencyEdit
      Left = 549
      Top = 6
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      TabOrder = 5
      Width = 80
    end
    object cePrice4: TcxCurrencyEdit
      Left = 549
      Top = 36
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      TabOrder = 6
      Width = 80
    end
  end
  object cxLabel8: TcxLabel [2]
    Left = 176
    Top = 7
    Caption = #1055#1088#1077#1076#1077#1083' 1 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
  end
  object cePrice1: TcxCurrencyEdit [3]
    Left = 314
    Top = 6
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 3
    Width = 80
  end
  object cxLabel9: TcxLabel [4]
    Left = 175
    Top = 37
    Caption = #1055#1088#1077#1076#1077#1083' 2 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
  end
  object cePrice2: TcxCurrencyEdit [5]
    Left = 314
    Top = 36
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    Style.Color = 15395562
    TabOrder = 4
    Width = 80
  end
  object cxLabel6: TcxLabel [6]
    Left = 642
    Top = 7
    Caption = #1055#1088#1077#1076#1077#1083' 5 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
  end
  object cePrice5: TcxCurrencyEdit [7]
    Left = 782
    Top = 6
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 7
    Width = 80
  end
  object cxLabel12: TcxLabel [8]
    Left = 642
    Top = 37
    Caption = #1055#1088#1077#1076#1077#1083' 6 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
  end
  object cePrice6: TcxCurrencyEdit [9]
    Left = 782
    Top = 36
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 8
    Width = 80
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 123
    Top = 328
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cePrice1
        Properties.Strings = (
          'Value')
      end
      item
        Component = cePrice2
        Properties.Strings = (
          'Value')
      end
      item
        Component = cePrice3
        Properties.Strings = (
          'Value')
      end
      item
        Component = cePrice4
        Properties.Strings = (
          'Value')
      end
      item
        Component = cePrice5
        Properties.Strings = (
          'Value')
      end
      item
        Component = cePrice6
        Properties.Strings = (
          'Value')
      end
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
        Component = MarginReportGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    Left = 159
    Top = 255
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actQuasiSchedule: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1069#1084#1087#1080#1088#1080#1095#1077#1089#1082#1080#1081
      Hint = 
        #1055#1083#1072#1085' '#1088#1072#1087#1088#1077#1076#1077#1083#1103#1077#1090#1089#1103' '#1087#1086' '#1076#1085#1103#1084' '#1085#1077#1076#1077#1083#1080' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1076#1086#1083#1080' '#1087#1088#1086#1076#1072#1078' '#1076#1085#1103' '#1079#1072' '#1087#1086 +
        #1089#1083#1077#1076#1085#1080#1077' 8 '#1085#1077#1076#1077#1083#1100
      ImageIndex = 40
      Value = False
      HintTrue = #1055#1083#1072#1085' '#1076#1077#1083#1080#1090#1089#1103' '#1088#1072#1074#1085#1086#1084#1077#1088#1085#1086' '#1085#1072' '#1082#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1074' '#1084#1077#1089#1103#1094#1077
      HintFalse = 
        #1055#1083#1072#1085' '#1088#1072#1087#1088#1077#1076#1077#1083#1103#1077#1090#1089#1103' '#1087#1086' '#1076#1085#1103#1084' '#1085#1077#1076#1077#1083#1080' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1076#1086#1083#1080' '#1087#1088#1086#1076#1072#1078' '#1076#1085#1103' '#1079#1072' '#1087#1086 +
        #1089#1083#1077#1076#1085#1080#1077' 8 '#1085#1077#1076#1077#1083#1100
      CaptionTrue = #1056#1072#1074#1085#1086#1084#1077#1088#1085#1099#1081
      CaptionFalse = #1069#1084#1087#1080#1088#1080#1095#1077#1089#1082#1080#1081
      ImageIndexTrue = 35
      ImageIndexFalse = 40
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_PriceInterventionDialogForm'
      FormNameParam.Value = 'TReport_PriceInterventionDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42371d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price1'
          Value = Null
          Component = cePrice1
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price2'
          Value = Null
          Component = cePrice2
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price3'
          Value = Null
          Component = cePrice3
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price4'
          Value = Null
          Component = cePrice4
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price5'
          Value = Null
          Component = cePrice5
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price6'
          Value = Null
          Component = cePrice6
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MarginReportId'
          Value = Null
          Component = MarginReportGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MarginReportName'
          Value = Null
          Component = MarginReportGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actInsertUpdate: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actInsertUpdate'
      DataSource = MasterDS
    end
    object MarginReportItemOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1069#1083#1077#1084#1077#1085#1090#1099' '#1074#1080#1088#1090'. '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1082#1080
      ImageIndex = 60
      FormName = 'TMarginReportItemForm'
      FormNameParam.Value = 'TMarginReportItemForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MarginReportId'
          Value = Null
          Component = MarginReportGuides
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MarginReportName'
          Value = Null
          Component = MarginReportGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 520
  end
  inherited MasterCDS: TClientDataSet
    Left = 464
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_PriceIntervention'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42248d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice1'
        Value = Null
        Component = cePrice1
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice2'
        Value = Null
        Component = cePrice2
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice3'
        Value = Null
        Component = cePrice3
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice4'
        Value = Null
        Component = cePrice4
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice5'
        Value = Null
        Component = cePrice5
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice6'
        Value = Null
        Component = cePrice6
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMarginReportId'
        Value = Null
        Component = MarginReportGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 584
    Top = 80
  end
  inherited BarManager: TdxBarManager
    Left = 648
    Top = 80
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMarginReportItem'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = #1053#1072#1095'.'#1076#1072#1090#1072
      Category = 0
      Hint = #1053#1072#1095'.'#1076#1072#1090#1072
      Visible = ivAlways
      Control = cxLabel1
    end
    object bbStart: TdxBarControlContainerItem
      Caption = #1053#1072#1095'.'#1076#1072#1090#1072
      Category = 0
      Hint = #1053#1072#1095'.'#1076#1072#1090#1072
      Visible = ivAlways
      Control = deStart
    end
    object dxBarControlContainerItem3: TdxBarControlContainerItem
      Caption = #1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Category = 0
      Hint = #1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Visible = ivAlways
      Control = cxLabel3
    end
    object dxBarControlContainerItem4: TdxBarControlContainerItem
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Category = 0
      Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Visible = ivAlways
      Control = ceMarginReport
    end
    object bbQuasiSchedule: TdxBarButton
      Action = actQuasiSchedule
      Category = 0
    end
    object bb122: TdxBarControlContainerItem
      Caption = #1050#1086#1085' '#1076#1072#1090#1072
      Category = 0
      Hint = #1050#1086#1085' '#1076#1072#1090#1072
      Visible = ivAlways
      Control = cxLabel4
    end
    object bbEnd: TdxBarControlContainerItem
      Caption = #1050#1086#1085'.'#1076#1072#1090#1072
      Category = 0
      Hint = #1050#1086#1085'.'#1076#1072#1090#1072
      Visible = ivAlways
      Control = deEnd
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbMarginReportItem: TdxBarButton
      Action = MarginReportItemOpenForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    View = cxGridDBBandedTableView1
    ColorRuleList = <
      item
        ColorColumn = Amount
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Amount1
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Amount2
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Amount3
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Amount4
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Amount5
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Amount6
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Amount7
        BackGroundValueColumn = Color_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = Summa
        BackGroundValueColumn = Color_Summa
        ColorValueList = <>
      end
      item
        ColorColumn = Summa1
        BackGroundValueColumn = Color_Summa
        ColorValueList = <>
      end
      item
        ColorColumn = Summa2
        BackGroundValueColumn = Color_Summa
        ColorValueList = <>
      end
      item
        ColorColumn = Summa3
        BackGroundValueColumn = Color_Summa
        ColorValueList = <>
      end
      item
        ColorColumn = Summa4
        BackGroundValueColumn = Color_Summa
        ColorValueList = <>
      end
      item
        ColorColumn = Summa5
        BackGroundValueColumn = Color_Summa
        ColorValueList = <>
      end
      item
        ColorColumn = Summa6
        BackGroundValueColumn = Color_Summa
        ColorValueList = <>
      end
      item
        ColorColumn = Summa7
        BackGroundValueColumn = Color_Summa
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale1
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale2
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale3
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale4
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale5
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale6
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = SummaSale7
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = PercentAmount1
        BackGroundValueColumn = Color_PercentAmount1
        ColorValueList = <>
      end
      item
        ColorColumn = PercentSumma1
        BackGroundValueColumn = Color_PercentSumma1
        ColorValueList = <>
      end
      item
        ColorColumn = PercentSummaSale1
        BackGroundValueColumn = Color_PercentSummaSale1
        ColorValueList = <>
      end
      item
        ColorColumn = PercentAmount2
        BackGroundValueColumn = Color_PercentAmount2
        ColorValueList = <>
      end
      item
        ColorColumn = PercentSumma2
        BackGroundValueColumn = Color_PercentSumma2
        ColorValueList = <>
      end
      item
        ColorColumn = PercentSummaSale2
        BackGroundValueColumn = Color_PercentSummaSale2
        ColorValueList = <>
      end
      item
        ColorColumn = PercentAmount3
        BackGroundValueColumn = Color_PercentAmount3
        ColorValueList = <>
      end
      item
        ColorColumn = PercentSumma3
        BackGroundValueColumn = Color_PercentSumma3
        ColorValueList = <>
      end
      item
        ColorColumn = PercentSummaSale3
        BackGroundValueColumn = Color_PercentSummaSale3
        ColorValueList = <>
      end
      item
        ColorColumn = PercentAmount4
        BackGroundValueColumn = Color_PercentAmount4
        ColorValueList = <>
      end
      item
        ColorColumn = PercentSumma4
        BackGroundValueColumn = Color_PercentSumma4
        ColorValueList = <>
      end
      item
        ColorColumn = PercentSummaSale4
        BackGroundValueColumn = Color_PercentSummaSale4
        ColorValueList = <>
      end
      item
        ColorColumn = PercentAmount5
        BackGroundValueColumn = Color_PercentAmount5
        ColorValueList = <>
      end
      item
        ColorColumn = PercentSumma5
        BackGroundValueColumn = Color_PercentSumma5
        ColorValueList = <>
      end
      item
        ColorColumn = PercentSummaSale5
        BackGroundValueColumn = Color_PercentSummaSale5
        ColorValueList = <>
      end
      item
        ColorColumn = PercentAmount6
        BackGroundValueColumn = Color_PercentAmount6
        ColorValueList = <>
      end
      item
        ColorColumn = PercentSumma6
        BackGroundValueColumn = Color_PercentSumma6
        ColorValueList = <>
      end
      item
        ColorColumn = PercentSummaSale6
        BackGroundValueColumn = Color_PercentSummaSale6
        ColorValueList = <>
      end
      item
        ColorColumn = PercentAmount7
        BackGroundValueColumn = Color_PercentAmount7
        ColorValueList = <>
      end
      item
        ColorColumn = PercentSumma7
        BackGroundValueColumn = Color_PercentSumma7
        ColorValueList = <>
      end
      item
        ColorColumn = PercentSummaSale7
        BackGroundValueColumn = Color_PercentSummaSale7
        ColorValueList = <>
      end>
    Left = 360
    Top = 288
  end
  inherited PopupMenu: TPopupMenu
    Left = 248
    Top = 256
  end
  inherited PeriodChoice: TPeriodChoice
    DateStart = nil
    DateEnd = nil
    Left = 24
    Top = 176
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
      end>
    Left = 120
    Top = 184
  end
  object MarginReportGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMarginReport
    FormNameParam.Value = 'TMarginReportForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMarginReportForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MarginReportGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MarginReportGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 936
    Top = 24
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_MarginReportItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMarginReportId'
        Value = ''
        Component = MarginReportGuides
        ComponentItem = 'Key'
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
        Name = 'inPercent1'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'VirtPercent1'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercent2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'VirtPercent2'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercent3'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'VirtPercent3'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercent4'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'VirtPercent4'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercent5'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'VirtPercent5'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercent6'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'VirtPercent6'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercent7'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'VirtPercent7'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 840
    Top = 224
  end
end
