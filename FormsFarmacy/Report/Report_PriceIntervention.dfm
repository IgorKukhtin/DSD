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
      Caption = #1056#1077#1079#1091#1083#1100#1090#1080#1088#1091#1102#1097#1080#1077' '#1076#1072#1085#1085#1099#1077
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
              Column = cxAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaSale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSumma
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaSale1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSumma1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaSale2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSumma2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaSale3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSumma3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaSale4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSumma4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaSale5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSumma5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaSale6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSumma6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaSale7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSumma7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtSummaSale1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtProfit1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtSummaSale2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtProfit2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtSummaSale3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtProfit3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtSummaSale4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtProfit4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtSummaSale5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtProfit5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtSummaSale6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtProfit6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtSummaSale7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtProfit7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaProfit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaProfit1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaProfit2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaProfit3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaProfit4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaProfit5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaProfit6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaProfit7
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = '0.####'
              Kind = skSum
              Column = cxAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaSale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSumma
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaSale1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSumma1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaSale2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSumma2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaSale3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSumma3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaSale4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSumma4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaSale5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSumma5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaSale6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSumma6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaSale7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSumma7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtSummaSale1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtProfit1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtSummaSale2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtProfit2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtSummaSale3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtProfit3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtSummaSale4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtProfit4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtSummaSale5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtProfit5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtSummaSale6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtProfit6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtSummaSale7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtProfit7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaProfit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaProfit1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaProfit2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaProfit3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaProfit4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaProfit5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaProfit6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaProfit7
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
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
          object cxJuridicalMainName: TcxGridDBBandedColumn
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
          object cxUnitName: TcxGridDBBandedColumn
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
          object cxMarginCategoryName: TcxGridDBBandedColumn
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
          object cxAmount: TcxGridDBBandedColumn
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
          object cxSummaSale: TcxGridDBBandedColumn
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
          object cxSumma: TcxGridDBBandedColumn
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
          object cxPercentProfit: TcxGridDBBandedColumn
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
          object cxSummaProfit: TcxGridDBBandedColumn
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
          object cxAmount1: TcxGridDBBandedColumn
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
          object cxSummaSale1: TcxGridDBBandedColumn
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
          object cxSumma1: TcxGridDBBandedColumn
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
          object cxPercentAmount1: TcxGridDBBandedColumn
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
          object cxPercentSummaSale1: TcxGridDBBandedColumn
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
          object cxPercentSumma1: TcxGridDBBandedColumn
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
          object cxPercentProfit1: TcxGridDBBandedColumn
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
          object cxSummaProfit1: TcxGridDBBandedColumn
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
          object cxVitrPercent1: TcxGridDBBandedColumn
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
          object cxVirtSummaSale1: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
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
            Position.ColIndex = 10
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxVirtProfit1: TcxGridDBBandedColumn
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
            Position.ColIndex = 9
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxMarginPercent1: TcxGridDBBandedColumn
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
            Position.ColIndex = 11
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxAmount2: TcxGridDBBandedColumn
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
          object cxSummaSale2: TcxGridDBBandedColumn
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
          object cxSumma2: TcxGridDBBandedColumn
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
          object cxPercentAmount2: TcxGridDBBandedColumn
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
          object cxPercentSummaSale2: TcxGridDBBandedColumn
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
          object cxPercentSumma2: TcxGridDBBandedColumn
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
          object cxPercentProfit2: TcxGridDBBandedColumn
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
          object cxSummaProfit2: TcxGridDBBandedColumn
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
          object cxVitrPercent2: TcxGridDBBandedColumn
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
          object cxVirtSummaSale2: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
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
          object cxVirtProfit2: TcxGridDBBandedColumn
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
          object cxMarginPercent2: TcxGridDBBandedColumn
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
          object cxAmount3: TcxGridDBBandedColumn
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
          object cxSummaSale3: TcxGridDBBandedColumn
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
          object cxSumma3: TcxGridDBBandedColumn
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
          object cxPercentAmount3: TcxGridDBBandedColumn
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
          object cxPercentSummaSale3: TcxGridDBBandedColumn
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
          object cxPercentSumma3: TcxGridDBBandedColumn
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
          object cxPercentProfit3: TcxGridDBBandedColumn
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
          object cxSummaProfit3: TcxGridDBBandedColumn
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
          object cxVitrPercent3: TcxGridDBBandedColumn
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
          object cxVirtSummaSale3: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
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
          object cxVirtProfit3: TcxGridDBBandedColumn
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
          object cxMarginPercent3: TcxGridDBBandedColumn
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
          object cxAmount4: TcxGridDBBandedColumn
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
          object cxSummaSale4: TcxGridDBBandedColumn
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
          object cxSumma4: TcxGridDBBandedColumn
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
          object cxPercentAmount4: TcxGridDBBandedColumn
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
          object cxPercentSummaSale4: TcxGridDBBandedColumn
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
          object cxPercentSumma4: TcxGridDBBandedColumn
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
          object cxPercentProfit4: TcxGridDBBandedColumn
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
          object cxSummaProfit4: TcxGridDBBandedColumn
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
          object cxVitrPercent4: TcxGridDBBandedColumn
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
          object cxVirtSummaSale4: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
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
          object cxVirtProfit4: TcxGridDBBandedColumn
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
          object cxMarginPercent4: TcxGridDBBandedColumn
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
          object cxAmount5: TcxGridDBBandedColumn
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
          object cxSummaSale5: TcxGridDBBandedColumn
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
          object cxSumma5: TcxGridDBBandedColumn
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
          object cxPercentAmount5: TcxGridDBBandedColumn
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
          object cxPercentSummaSale5: TcxGridDBBandedColumn
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
          object cxPercentSumma5: TcxGridDBBandedColumn
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
          object cxPercentProfit5: TcxGridDBBandedColumn
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
          object cxSummaProfit5: TcxGridDBBandedColumn
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
          object cxVitrPercent5: TcxGridDBBandedColumn
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
          object cxVirtSummaSale5: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
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
          object cxVirtProfit5: TcxGridDBBandedColumn
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
          object cxMarginPercent5: TcxGridDBBandedColumn
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
          object cxAmount6: TcxGridDBBandedColumn
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
          object cxSummaSale6: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6:   '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
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
          object cxSumma6: TcxGridDBBandedColumn
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
          object cxPercentAmount6: TcxGridDBBandedColumn
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
          object cxPercentSummaSale6: TcxGridDBBandedColumn
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
          object cxPercentSumma6: TcxGridDBBandedColumn
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
          object cxPercentProfit6: TcxGridDBBandedColumn
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
          object cxSummaProfit6: TcxGridDBBandedColumn
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
          object cxVitrPercent6: TcxGridDBBandedColumn
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
          object cxVirtSummaSale6: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
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
          object cxVirtProfit6: TcxGridDBBandedColumn
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
          object cxMarginPercent6: TcxGridDBBandedColumn
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
          object cxAmount7: TcxGridDBBandedColumn
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
          object cxSummaSale7: TcxGridDBBandedColumn
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
          object cxSumma7: TcxGridDBBandedColumn
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
          object cxPercentAmount7: TcxGridDBBandedColumn
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
          object cxPercentSummaSale7: TcxGridDBBandedColumn
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
          object cxPercentSumma7: TcxGridDBBandedColumn
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
          object cxPercentProfit7: TcxGridDBBandedColumn
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
          object cxSummaProfit7: TcxGridDBBandedColumn
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
          object cxVitrPercent7: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: '#1074#1080#1088#1090'. %'
            Caption = #1074#1080#1088#1090'. %'
            DataBinding.FieldName = 'VirtPercent7'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
            Position.BandIndex = 8
            Position.ColIndex = 8
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxVirtSummaSale7: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
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
          object cxVirtProfit7: TcxGridDBBandedColumn
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
          object cxMarginPercent7: TcxGridDBBandedColumn
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
          object cxColor_Amount: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_Amount'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object cxColor_Summa: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_Summa'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object cxColor_SummaSale: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_SummaSale'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object cxColor_PercentAmount1: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentAmount1'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object cxColor_PercentSumma1: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSumma1'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
          object cxColor_PercentSummaSale1: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSummaSale1'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 7
            Position.RowIndex = 0
          end
          object cxColor_PercentAmount2: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentAmount2'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 8
            Position.RowIndex = 0
          end
          object cxColor_PercentSumma2: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSumma2'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 9
            Position.RowIndex = 0
          end
          object cxColor_PercentSummaSale2: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSummaSale2'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 10
            Position.RowIndex = 0
          end
          object cxColor_PercentAmount3: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentAmount3'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 11
            Position.RowIndex = 0
          end
          object cxColor_PercentSumma3: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSumma3'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 12
            Position.RowIndex = 0
          end
          object cxColor_PercentSummaSale3: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSummaSale3'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 13
            Position.RowIndex = 0
          end
          object cxColor_PercentAmount4: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentAmount4'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 14
            Position.RowIndex = 0
          end
          object cxColor_PercentSumma4: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSumma4'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 15
            Position.RowIndex = 0
          end
          object cxColor_PercentSummaSale4: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSummaSale4'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 16
            Position.RowIndex = 0
          end
          object cxColor_PercentAmount5: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentAmount5'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 17
            Position.RowIndex = 0
          end
          object cxColor_PercentSumma5: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSumma5'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 18
            Position.RowIndex = 0
          end
          object cxColor_PercentSummaSale5: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSummaSale5'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 19
            Position.RowIndex = 0
          end
          object cxColor_PercentAmount6: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentAmount6'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 20
            Position.RowIndex = 0
          end
          object cxColor_PercentSumma6: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSumma6'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 21
            Position.RowIndex = 0
          end
          object cxColor_PercentSummaSale6: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSummaSale6'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 22
            Position.RowIndex = 0
          end
          object cxColor_PercentAmount7: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentAmount7'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 23
            Position.RowIndex = 0
          end
          object cxColor_PercentSumma7: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PercentSumma7'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 24
            Position.RowIndex = 0
          end
          object cxColor_PercentSummaSale7: TcxGridDBBandedColumn
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
      Left = 875
      Top = 7
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
          'key'
          'TextValue')
      end
      item
        Component = cePrice2
        Properties.Strings = (
          'Date')
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
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'EndDate'
          Value = 42371d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'Price1'
          Value = Null
          Component = cePrice1
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'Price2'
          Value = Null
          Component = cePrice2
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'Price3'
          Value = Null
          Component = cePrice3
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'Price4'
          Value = Null
          Component = cePrice4
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'Price5'
          Value = Null
          Component = cePrice5
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'Price6'
          Value = Null
          Component = cePrice6
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'MarginReportId'
          Value = Null
          Component = MarginReportGuides
          ComponentItem = 'Key'
          ParamType = ptInput
        end
        item
          Name = 'MarginReportName'
          Value = Null
          Component = MarginReportGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
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
      GuiParams = <
        item
          Name = 'MarginReportId'
          Value = Null
          Component = MarginReportGuides
          ComponentItem = 'Key'
        end
        item
          Name = 'MarginReportName'
          Value = Null
          Component = MarginReportGuides
          ComponentItem = 'TextValue'
          DataType = ftString
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
      end
      item
        Name = 'inEndDate'
        Value = 42248d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inPrice1'
        Value = Null
        Component = cePrice1
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPrice2'
        Value = Null
        Component = cePrice2
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPrice3'
        Value = Null
        Component = cePrice3
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPrice4'
        Value = Null
        Component = cePrice4
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPrice5'
        Value = Null
        Component = cePrice5
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPrice6'
        Value = Null
        Component = cePrice6
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inMarginReportId'
        Value = Null
        Component = MarginReportGuides
        ComponentItem = 'Key'
        ParamType = ptInput
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMarginReportItem'
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
        ColorColumn = cxAmount
        BackGroundValueColumn = cxColor_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = cxAmount1
        BackGroundValueColumn = cxColor_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = cxAmount2
        BackGroundValueColumn = cxColor_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = cxAmount3
        BackGroundValueColumn = cxColor_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = cxAmount4
        BackGroundValueColumn = cxColor_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = cxAmount5
        BackGroundValueColumn = cxColor_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = cxAmount6
        BackGroundValueColumn = cxColor_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = cxAmount7
        BackGroundValueColumn = cxColor_Amount
        ColorValueList = <>
      end
      item
        ColorColumn = cxSumma
        BackGroundValueColumn = cxColor_Summa
        ColorValueList = <>
      end
      item
        ColorColumn = cxSumma1
        BackGroundValueColumn = cxColor_Summa
        ColorValueList = <>
      end
      item
        ColorColumn = cxSumma2
        BackGroundValueColumn = cxColor_Summa
        ColorValueList = <>
      end
      item
        ColorColumn = cxSumma3
        BackGroundValueColumn = cxColor_Summa
        ColorValueList = <>
      end
      item
        ColorColumn = cxSumma4
        BackGroundValueColumn = cxColor_Summa
        ColorValueList = <>
      end
      item
        ColorColumn = cxSumma5
        BackGroundValueColumn = cxColor_Summa
        ColorValueList = <>
      end
      item
        ColorColumn = cxSumma6
        BackGroundValueColumn = cxColor_Summa
        ColorValueList = <>
      end
      item
        ColorColumn = cxSumma7
        BackGroundValueColumn = cxColor_Summa
        ColorValueList = <>
      end
      item
        ColorColumn = cxSummaSale
        BackGroundValueColumn = cxColor_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = cxSummaSale1
        BackGroundValueColumn = cxColor_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = cxSummaSale2
        BackGroundValueColumn = cxColor_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = cxSummaSale3
        BackGroundValueColumn = cxColor_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = cxSummaSale4
        BackGroundValueColumn = cxColor_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = cxSummaSale5
        BackGroundValueColumn = cxColor_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = cxSummaSale6
        BackGroundValueColumn = cxColor_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = cxSummaSale7
        BackGroundValueColumn = cxColor_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentAmount1
        BackGroundValueColumn = cxColor_PercentAmount1
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentSumma1
        BackGroundValueColumn = cxColor_PercentSumma1
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentSummaSale1
        BackGroundValueColumn = cxColor_PercentSummaSale1
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentAmount2
        BackGroundValueColumn = cxColor_PercentAmount2
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentSumma2
        BackGroundValueColumn = cxColor_PercentSumma2
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentSummaSale2
        BackGroundValueColumn = cxColor_PercentSummaSale2
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentAmount3
        BackGroundValueColumn = cxColor_PercentAmount3
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentSumma3
        BackGroundValueColumn = cxColor_PercentSumma3
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentSummaSale3
        BackGroundValueColumn = cxColor_PercentSummaSale3
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentAmount4
        BackGroundValueColumn = cxColor_PercentAmount4
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentSumma4
        BackGroundValueColumn = cxColor_PercentSumma4
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentSummaSale4
        BackGroundValueColumn = cxColor_PercentSummaSale4
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentAmount5
        BackGroundValueColumn = cxColor_PercentAmount5
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentSumma5
        BackGroundValueColumn = cxColor_PercentSumma5
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentSummaSale5
        BackGroundValueColumn = cxColor_PercentSummaSale5
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentAmount6
        BackGroundValueColumn = cxColor_PercentAmount6
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentSumma6
        BackGroundValueColumn = cxColor_PercentSumma6
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentSummaSale6
        BackGroundValueColumn = cxColor_PercentSummaSale6
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentAmount7
        BackGroundValueColumn = cxColor_PercentAmount7
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentSumma7
        BackGroundValueColumn = cxColor_PercentSumma7
        ColorValueList = <>
      end
      item
        ColorColumn = cxPercentSummaSale7
        BackGroundValueColumn = cxColor_PercentSummaSale7
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
    FormName = 'TMarginReportForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MarginReportGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MarginReportGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
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
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
      end
      item
        Name = 'inPercent1'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'VirtPercent1'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPercent2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'VirtPercent2'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPercent3'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'VirtPercent3'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPercent4'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'VirtPercent4'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPercent5'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'VirtPercent5'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPercent6'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'VirtPercent6'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPercent7'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'VirtPercent7'
        DataType = ftFloat
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 816
    Top = 232
  end
end
