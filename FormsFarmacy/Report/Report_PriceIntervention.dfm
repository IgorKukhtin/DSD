inherited Report_PriceInterventionForm: TReport_PriceInterventionForm
  Caption = #1054#1090#1095#1077#1090' '#1062#1077#1085#1086#1074#1072#1103' '#1080#1085#1090#1077#1088#1074#1077#1085#1094#1080#1103
  ClientHeight = 492
  ClientWidth = 1212
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1228
  ExplicitHeight = 530
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 91
    Width = 1212
    Height = 401
    TabOrder = 3
    ExplicitTop = 91
    ExplicitWidth = 1212
    ExplicitHeight = 401
    ClientRectBottom = 401
    ClientRectRight = 1212
    ClientRectTop = 24
    inherited tsMain: TcxTabSheet
      Caption = #1056#1077#1079#1091#1083#1100#1090#1080#1088#1091#1102#1097#1080#1077' '#1076#1072#1085#1085#1099#1077
      TabVisible = True
      ExplicitTop = 24
      ExplicitWidth = 1212
      ExplicitHeight = 377
      inherited cxGrid: TcxGrid
        Width = 1212
        Height = 377
        ExplicitWidth = 1212
        ExplicitHeight = 377
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
              Format = ',0.00'
              Kind = skSum
              Column = cxAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSummaSale
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSumma
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxAmount1
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSummaSale1
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSumma1
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxAmount2
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSummaSale2
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSumma2
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxAmount3
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSummaSale3
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSumma3
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxAmount4
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSummaSale4
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSumma4
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxAmount5
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSummaSale5
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSumma5
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxAmount6
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSummaSale6
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSumma6
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxAmount7
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSummaSale7
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSumma7
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSummaSale
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSumma
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxAmount1
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSummaSale1
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSumma1
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxAmount2
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSummaSale2
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSumma2
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxAmount3
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSummaSale3
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSumma3
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxAmount4
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSummaSale4
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSumma4
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxAmount5
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSummaSale5
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSumma5
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxAmount6
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSummaSale6
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSumma6
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxAmount7
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSummaSale7
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = cxSumma7
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
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
              Width = 279
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
            Width = 96
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
            Width = 100
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxAmount: TcxGridDBBandedColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1050#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1050#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
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
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
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
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 85
            Position.BandIndex = 1
            Position.ColIndex = 2
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxAmount1: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
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
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
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
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 85
            Position.BandIndex = 2
            Position.ColIndex = 2
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentAmount1: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = '% '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PersentAmount1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 85
            Position.BandIndex = 2
            Position.ColIndex = 3
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentSummaSale1: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PersentSummaSale1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 85
            Position.BandIndex = 2
            Position.ColIndex = 4
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentSumma1: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PersentSumma1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 85
            Position.BandIndex = 2
            Position.ColIndex = 5
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxAmount2: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2:  '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 3
            Position.ColIndex = 2
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentAmount2: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = '% '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PersentAmount2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 3
            Position.ColIndex = 3
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentSummaSale2: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PersentSummaSale2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 3
            Position.ColIndex = 4
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentSumma2: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PersentSumma2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 3
            Position.ColIndex = 5
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxAmount3: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3:  '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 4
            Position.ColIndex = 2
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentAmount3: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = '% '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PersentAmount3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 4
            Position.ColIndex = 3
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentSummaSale3: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PersentSummaSale3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 4
            Position.ColIndex = 4
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentSumma3: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PersentSumma3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 4
            Position.ColIndex = 5
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxAmount4: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4:  '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 5
            Position.ColIndex = 2
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentAmount4: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = '% '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PersentAmount4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 5
            Position.ColIndex = 3
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentSummaSale4: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PersentSummaSale4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 5
            Position.ColIndex = 4
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentSumma4: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PersentSumma4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 5
            Position.ColIndex = 5
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxAmount5: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5:  '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 6
            Position.ColIndex = 2
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentAmount5: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = '% '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PersentAmount5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 6
            Position.ColIndex = 3
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentSummaSale5: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PersentSummaSale5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 6
            Position.ColIndex = 4
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentSumma5: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PersentSumma5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 6
            Position.ColIndex = 5
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxAmount6: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 7
            Position.ColIndex = 2
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentAmount6: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = '% '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PersentAmount6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 7
            Position.ColIndex = 3
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentSummaSale6: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PersentSummaSale6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 7
            Position.ColIndex = 4
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentSumma6: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PersentSumma6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 7
            Position.ColIndex = 5
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxAmount7: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7:  '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 8
            Position.ColIndex = 2
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentAmount7: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = '% '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PersentAmount7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 8
            Position.ColIndex = 3
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentSummaSale7: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PersentSummaSale7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 8
            Position.ColIndex = 4
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxPersentSumma7: TcxGridDBBandedColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = '% '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PersentSumma7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
            Position.BandIndex = 8
            Position.ColIndex = 5
            Position.LineCount = 2
            Position.RowIndex = 0
          end
          object cxColor_Amount: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_Amount'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object cxColor_Summa: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_Summa'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object cxColor_SummaSale: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_SummaSale'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object cxColor_PersentAmount1: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentAmount1'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object cxColor_PersentSumma1: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentSumma1'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
          object cxColor_PersentSummaSale1: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentSummaSale1'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 7
            Position.RowIndex = 0
          end
          object cxColor_PersentAmount2: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentAmount2'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 8
            Position.RowIndex = 0
          end
          object cxColor_PersentSumma2: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentSumma2'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 9
            Position.RowIndex = 0
          end
          object cxColor_PersentSummaSale2: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentSummaSale2'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 10
            Position.RowIndex = 0
          end
          object cxColor_PersentAmount3: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentAmount3'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 11
            Position.RowIndex = 0
          end
          object cxColor_PersentSumma3: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentSumma3'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 12
            Position.RowIndex = 0
          end
          object cxColor_PersentSummaSale3: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentSummaSale3'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 13
            Position.RowIndex = 0
          end
          object cxColor_PersentAmount4: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentAmount4'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 14
            Position.RowIndex = 0
          end
          object cxColor_PersentSumma4: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentSumma4'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 15
            Position.RowIndex = 0
          end
          object cxColor_PersentSummaSale4: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentSummaSale4'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 16
            Position.RowIndex = 0
          end
          object cxColor_PersentAmount5: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentAmount5'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 17
            Position.RowIndex = 0
          end
          object cxColor_PersentSumma5: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentSumma5'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 18
            Position.RowIndex = 0
          end
          object cxColor_PersentSummaSale5: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentSummaSale5'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 19
            Position.RowIndex = 0
          end
          object cxColor_PersentAmount6: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentAmount6'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 20
            Position.RowIndex = 0
          end
          object cxColor_PersentSumma6: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentSumma6'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 21
            Position.RowIndex = 0
          end
          object cxColor_PersentSummaSale6: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentSummaSale6'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 22
            Position.RowIndex = 0
          end
          object cxColor_PersentAmount7: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentAmount7'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 23
            Position.RowIndex = 0
          end
          object cxColor_PersentSumma7: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentSumma7'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 24
            Position.RowIndex = 0
          end
          object cxColor_PersentSummaSale7: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_PersentSummaSale7'
            Visible = False
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
    ExplicitWidth = 1212
    ExplicitHeight = 65
    inherited deStart: TcxDateEdit
      Left = 127
      Top = 6
      EditValue = 42370d
      ExplicitLeft = 127
      ExplicitTop = 6
    end
    inherited deEnd: TcxDateEdit
      Left = 127
      Top = 36
      EditValue = 42371d
      ExplicitLeft = 127
      ExplicitTop = 36
    end
    inherited cxLabel1: TcxLabel
      Left = 64
      Top = 7
      Caption = #1053#1072#1095'.'#1076#1072#1090#1072':'
      ExplicitLeft = 64
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
      Left = 971
      Top = 15
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' 1:'
      Visible = False
    end
    object ceJuridical1: TcxButtonEdit
      Left = 1051
      Top = 14
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 5
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      TextHint = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      Visible = False
      Width = 57
    end
    object cxLabel4: TcxLabel
      Left = 64
      Top = 40
      Caption = #1050#1086#1085'.'#1076#1072#1090#1072':'
    end
    object cxLabel5: TcxLabel
      Left = 971
      Top = 27
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' 2:'
      Visible = False
    end
    object ceJuridical2: TcxButtonEdit
      Left = 1051
      Top = 41
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 8
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      TextHint = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      Visible = False
      Width = 57
    end
    object cxLabel10: TcxLabel
      Left = 444
      Top = 7
      Caption = #1055#1088#1077#1076#1077#1083' 3 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
    end
    object cxLabel11: TcxLabel
      Left = 444
      Top = 37
      Caption = #1055#1088#1077#1076#1077#1083' 4 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
    end
    object cePrice3: TcxCurrencyEdit
      Left = 585
      Top = 6
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      TabOrder = 11
      Width = 80
    end
    object cePrice4: TcxCurrencyEdit
      Left = 585
      Top = 36
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      TabOrder = 12
      Width = 80
    end
  end
  object cxLabel8: TcxLabel [2]
    Left = 220
    Top = 7
    Caption = #1055#1088#1077#1076#1077#1083' 1 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
  end
  object cePrice1: TcxCurrencyEdit [3]
    Left = 358
    Top = 6
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 7
    Width = 80
  end
  object cxLabel9: TcxLabel [4]
    Left = 219
    Top = 37
    Caption = #1055#1088#1077#1076#1077#1083' 2 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
  end
  object cePrice2: TcxCurrencyEdit [5]
    Left = 358
    Top = 36
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 9
    Width = 80
  end
  object cxLabel6: TcxLabel [6]
    Left = 673
    Top = 7
    Caption = #1055#1088#1077#1076#1077#1083' 5 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
  end
  object cePrice5: TcxCurrencyEdit [7]
    Left = 813
    Top = 6
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 11
    Width = 80
  end
  object cxLabel12: TcxLabel [8]
    Left = 673
    Top = 37
    Caption = #1055#1088#1077#1076#1077#1083' 6 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
  end
  object cePrice6: TcxCurrencyEdit [9]
    Left = 813
    Top = 36
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 13
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
        Component = cePrice1
        Properties.Strings = (
          'TStrings')
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
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
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
      Control = ceJuridical1
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
        ColorColumn = cxPersentAmount1
        BackGroundValueColumn = cxColor_PersentAmount1
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentSumma1
        BackGroundValueColumn = cxColor_PersentSumma1
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentSummaSale1
        BackGroundValueColumn = cxColor_PersentSummaSale1
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentAmount2
        BackGroundValueColumn = cxColor_PersentAmount2
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentSumma2
        BackGroundValueColumn = cxColor_PersentSumma2
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentSummaSale2
        BackGroundValueColumn = cxColor_PersentSummaSale2
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentAmount3
        BackGroundValueColumn = cxColor_PersentAmount3
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentSumma3
        BackGroundValueColumn = cxColor_PersentSumma3
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentSummaSale3
        BackGroundValueColumn = cxColor_PersentSummaSale3
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentAmount4
        BackGroundValueColumn = cxColor_PersentAmount4
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentSumma4
        BackGroundValueColumn = cxColor_PersentSumma4
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentSummaSale4
        BackGroundValueColumn = cxColor_PersentSummaSale4
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentAmount5
        BackGroundValueColumn = cxColor_PersentAmount5
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentSumma5
        BackGroundValueColumn = cxColor_PersentSumma5
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentSummaSale5
        BackGroundValueColumn = cxColor_PersentSummaSale5
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentAmount6
        BackGroundValueColumn = cxColor_PersentAmount6
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentSumma6
        BackGroundValueColumn = cxColor_PersentSumma6
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentSummaSale6
        BackGroundValueColumn = cxColor_PersentSummaSale6
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentAmount7
        BackGroundValueColumn = cxColor_PersentAmount7
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentSumma7
        BackGroundValueColumn = cxColor_PersentSumma7
        ColorValueList = <>
      end
      item
        ColorColumn = cxPersentSummaSale7
        BackGroundValueColumn = cxColor_PersentSummaSale7
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
  object Juridical1Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical1
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Juridical1Guides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Juridical1Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 1024
    Top = 8
  end
  object Juridical2Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical2
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Juridical2Guides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Juridical2Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 1040
    Top = 32
  end
end
