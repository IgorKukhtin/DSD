inherited Report_PriceIntervention2Form: TReport_PriceIntervention2Form
  Caption = #1054#1090#1095#1077#1090' '#1062#1077#1085#1086#1074#1072#1103' '#1080#1085#1090#1077#1088#1074#1077#1085#1094#1080#1103
  ClientHeight = 594
  ClientWidth = 1273
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1289
  ExplicitHeight = 629
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel: TPanel [0]
    Width = 1273
    Height = 65
    ExplicitWidth = 1273
    ExplicitHeight = 65
    inherited deStart: TcxDateEdit
      Left = 67
      Top = 6
      ExplicitLeft = 67
      ExplicitTop = 6
    end
    inherited deEnd: TcxDateEdit
      Left = 67
      Top = 36
      ExplicitLeft = 67
      ExplicitTop = 36
    end
    inherited cxLabel1: TcxLabel
      Top = 7
      Caption = #1053#1072#1095'.'#1076#1072#1090#1072':'
      ExplicitTop = 7
      ExplicitWidth = 56
    end
    inherited cxLabel2: TcxLabel
      Left = 10
      Top = 37
      Caption = #1050#1086#1085'.'#1076#1072#1090#1072':'
      ExplicitLeft = 10
      ExplicitTop = 37
      ExplicitWidth = 56
    end
    object cxLabel13: TcxLabel
      Left = 408
      Top = 7
      Caption = #1055#1088#1077#1076#1077#1083' 3 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
    end
    object cePrice3: TcxCurrencyEdit
      Left = 549
      Top = 6
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      TabOrder = 5
      Width = 80
    end
    object cxLabel14: TcxLabel
      Left = 408
      Top = 37
      Caption = #1055#1088#1077#1076#1077#1083' 4 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
    end
    object cePrice4: TcxCurrencyEdit
      Left = 549
      Top = 36
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      TabOrder = 7
      Width = 80
    end
    object cxLabel15: TcxLabel
      Left = 875
      Top = 7
      Caption = #1042#1080#1088#1090#1091#1072#1083#1100#1085#1072#1103' '#1082#1072#1090#1077#1075#1086#1088#1080#1103' '#1085#1072#1094#1077#1085#1082#1080
    end
    object ceMarginReport: TcxButtonEdit
      Left = 875
      Top = 35
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 9
      Width = 230
    end
  end
  inherited PageControl: TcxPageControl [1]
    Top = 91
    Width = 1273
    Height = 503
    TabOrder = 3
    ExplicitTop = 91
    ExplicitWidth = 1273
    ExplicitHeight = 503
    ClientRectBottom = 503
    ClientRectRight = 1273
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1273
      ExplicitHeight = 503
      inherited cxGrid: TcxGrid
        Left = 318
        Width = 955
        Height = 503
        TabOrder = 1
        ExplicitLeft = 323
        ExplicitWidth = 950
        ExplicitHeight = 503
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
            end
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
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtProfit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtSummaSale
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
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
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtProfit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxVirtSummaSale
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.HeaderAutoHeight = False
          OptionsView.HeaderHeight = 60
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object cxJuridicalMainName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalMainName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
            Width = 89
          end
          object cxUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
            Width = 143
          end
          object cxMarginCategoryName: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1085#1072#1094#1077#1085#1082#1080' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'MarginCategoryName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            MinWidth = 10
            VisibleForCustomization = False
            Width = 83
          end
          object cxAmount: TcxGridDBColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1050#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1050#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 1
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSummaSale: TcxGridDBColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1042' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1042' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSumma: TcxGridDBColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1042' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            Caption = #1042' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Summa'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentProfit: TcxGridDBColumn
            AlternateCaption = #1048#1090#1086#1075#1086': % '#1076#1086#1093#1086#1076#1072
            Caption = '% '#1076#1086#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentProfit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSummaProfit: TcxGridDBColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1076#1086#1093#1086#1076
            Caption = #1076#1086#1093#1086#1076
            DataBinding.FieldName = 'SummaProfit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxVitrPercent: TcxGridDBColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1074#1080#1088#1090'. %'
            Caption = #1074#1080#1088#1090'. %'
            DataBinding.FieldName = 'VirtPercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxVirtSummaSale: TcxGridDBColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'VirtSummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxVirtProfit: TcxGridDBColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            Caption = #1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'VirtProfit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxAmount1: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1055#1088#1077#1076#1077#1083' 1: '#1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 1: '#1082#1086#1083'-'#1074#1086', '#1096#1090
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSummaSale1: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 1: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 1: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSumma1: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 1: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Summa1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 1: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentAmount1: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = #1055#1088#1077#1076#1077#1083' 1: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PercentAmount1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 1: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentSummaSale1: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = #1055#1088#1077#1076#1077#1083' 1: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PercentSummaSale1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 1: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentSumma1: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = #1055#1088#1077#1076#1077#1083' 1: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentSumma1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 1: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentProfit1: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: % '#1076#1086#1093#1086#1076#1072
            Caption = #1055#1088#1077#1076#1077#1083' 1: % '#1076#1086#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentProfit1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 1: % '#1076#1086#1093#1086#1076#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSummaProfit1: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: '#1076#1086#1093#1086#1076
            Caption = #1055#1088#1077#1076#1077#1083' 1: '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'SummaProfit1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 1: '#1076#1086#1093#1086#1076
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxVitrPercent1: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: '#1074#1080#1088#1090'. %'
            Caption = #1055#1088#1077#1076#1077#1083' 1: '#1074#1080#1088#1090'. %'
            DataBinding.FieldName = 'VirtPercent1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 1: '#1074#1080#1088#1090'. %'
            MinWidth = 10
            Width = 75
          end
          object cxVirtProfit1: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            Caption = #1055#1088#1077#1076#1077#1083' 1: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'VirtProfit1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxVirtSummaSale1: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 1: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'VirtSummaSale1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 1: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxMarginPercent1: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 1: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            Caption = #1055#1088#1077#1076#1077#1083' 1: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            DataBinding.FieldName = 'MarginPercent1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 1: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxAmount2: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2:  '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1055#1088#1077#1076#1077#1083' 2: '#1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 2: '#1082#1086#1083'-'#1074#1086', '#1096#1090
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSummaSale2: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 2: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 2: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSumma2: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 2: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Summa2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 2: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentAmount2: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = #1055#1088#1077#1076#1077#1083' 2: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PercentAmount2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 2: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentSummaSale2: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = #1055#1088#1077#1076#1077#1083' 2: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PercentSummaSale2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 2: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentSumma2: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = #1055#1088#1077#1076#1077#1083' 2: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentSumma2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 2: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentProfit2: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: % '#1076#1086#1093#1086#1076#1072
            Caption = #1055#1088#1077#1076#1077#1083' 2: % '#1076#1086#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentProfit2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 2: % '#1076#1086#1093#1086#1076#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSummaProfit2: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: '#1076#1086#1093#1086#1076
            Caption = #1055#1088#1077#1076#1077#1083' 2: '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'SummaProfit2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 2: '#1076#1086#1093#1086#1076
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxVitrPercent2: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: '#1074#1080#1088#1090'. %'
            Caption = #1055#1088#1077#1076#1077#1083' 2: '#1074#1080#1088#1090'. %'
            DataBinding.FieldName = 'VirtPercent2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 2: '#1074#1080#1088#1090'. %'
            MinWidth = 10
            Width = 75
          end
          object cxVirtSummaSale2: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 2: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'VirtSummaSale2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 2: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxVirtProfit2: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            Caption = #1055#1088#1077#1076#1077#1083' 2: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'VirtProfit2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 2: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxMarginPercent2: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 2: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            Caption = #1055#1088#1077#1076#1077#1083' 2: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            DataBinding.FieldName = 'MarginPercent2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 2: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxAmount3: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3:  '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1055#1088#1077#1076#1077#1083' 3: '#1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 3: '#1082#1086#1083'-'#1074#1086', '#1096#1090
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSummaSale3: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 3: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 3: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSumma3: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 3: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Summa3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 3: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentAmount3: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = #1055#1088#1077#1076#1077#1083' 3: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PercentAmount3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 3: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentSummaSale3: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = #1055#1088#1077#1076#1077#1083' 3: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PercentSummaSale3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 3: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentSumma3: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = #1055#1088#1077#1076#1077#1083' 3: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentSumma3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 3: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentProfit3: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: % '#1076#1086#1093#1086#1076#1072
            Caption = #1055#1088#1077#1076#1077#1083' 3: % '#1076#1086#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentProfit3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 3: % '#1076#1086#1093#1086#1076#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSummaProfit3: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: '#1076#1086#1093#1086#1076
            Caption = #1055#1088#1077#1076#1077#1083' 3: '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'SummaProfit3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 3: '#1076#1086#1093#1086#1076
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxVitrPercent3: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: '#1074#1080#1088#1090'. %'
            Caption = #1055#1088#1077#1076#1077#1083' 3: '#1074#1080#1088#1090'. %'
            DataBinding.FieldName = 'VirtPercent3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 3: '#1074#1080#1088#1090'. %'
            MinWidth = 10
            Width = 75
          end
          object cxVirtSummaSale3: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 3: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'VirtSummaSale3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 3: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxVirtProfit3: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            Caption = #1055#1088#1077#1076#1077#1083' 3: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'VirtProfit3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 3: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxMarginPercent3: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 3: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            Caption = #1055#1088#1077#1076#1077#1083' 3: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            DataBinding.FieldName = 'MarginPercent3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 3: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxAmount4: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4:  '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1055#1088#1077#1076#1077#1083' 4: '#1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 4: '#1082#1086#1083'-'#1074#1086', '#1096#1090
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSummaSale4: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 4: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 4: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSumma4: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 4: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Summa4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 4: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentAmount4: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = #1055#1088#1077#1076#1077#1083' 4: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PercentAmount4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 4: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentSummaSale4: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = #1055#1088#1077#1076#1077#1083' 4: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PercentSummaSale4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 4: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentSumma4: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = #1055#1088#1077#1076#1077#1083' 4: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentSumma4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 4: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentProfit4: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: % '#1076#1086#1093#1086#1076#1072
            Caption = #1055#1088#1077#1076#1077#1083' 4: % '#1076#1086#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentProfit4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 4: % '#1076#1086#1093#1086#1076#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSummaProfit4: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: '#1076#1086#1093#1086#1076
            Caption = #1055#1088#1077#1076#1077#1083' 4: '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'SummaProfit4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 4: '#1076#1086#1093#1086#1076
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxVitrPercent4: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: '#1074#1080#1088#1090'. %'
            Caption = #1055#1088#1077#1076#1077#1083' 4: '#1074#1080#1088#1090'. %'
            DataBinding.FieldName = 'VirtPercent4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 4: '#1074#1080#1088#1090'. %'
            MinWidth = 10
            Width = 75
          end
          object cxVirtSummaSale4: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 4: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'VirtSummaSale4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 4: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxMarginPercent4: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            Caption = #1055#1088#1077#1076#1077#1083' 4: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            DataBinding.FieldName = 'MarginPercent4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 4: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxVirtProfit4: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 4: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            Caption = #1055#1088#1077#1076#1077#1083' 4: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'VirtProfit4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 4: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxAmount5: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5:  '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1055#1088#1077#1076#1077#1083' 5:  '#1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentVert = vaTop
            HeaderHint = #1055#1088#1077#1076#1077#1083' 5:  '#1082#1086#1083'-'#1074#1086', '#1096#1090
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSummaSale5: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 5: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 5: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSumma5: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 5: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Summa5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 5: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentAmount5: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = #1055#1088#1077#1076#1077#1083' 5: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PercentAmount5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 5: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentSummaSale5: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = #1055#1088#1077#1076#1077#1083' 5: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PercentSummaSale5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 5: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentSumma5: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = #1055#1088#1077#1076#1077#1083' 5: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentSumma5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 5: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentProfit5: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: % '#1076#1086#1093#1086#1076#1072
            Caption = #1055#1088#1077#1076#1077#1083' 5: % '#1076#1086#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentProfit5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 5: % '#1076#1086#1093#1086#1076#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSummaProfit5: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: '#1076#1086#1093#1086#1076
            Caption = #1055#1088#1077#1076#1077#1083' 5: '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'SummaProfit5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 5: '#1076#1086#1093#1086#1076
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxVitrPercent5: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: '#1074#1080#1088#1090'. %'
            Caption = #1055#1088#1077#1076#1077#1083' 5: '#1074#1080#1088#1090'. %'
            DataBinding.FieldName = 'VirtPercent5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 5: '#1074#1080#1088#1090'. %'
            MinWidth = 10
            Width = 75
          end
          object cxVirtSummaSale5: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 5: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'VirtSummaSale5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 5: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxVirtProfit5: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            Caption = #1055#1088#1077#1076#1077#1083' 5: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'VirtProfit5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 5: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxMarginPercent5: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 5: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            Caption = #1055#1088#1077#1076#1077#1083' 5: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            DataBinding.FieldName = 'MarginPercent5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 5: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxAmount6: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1055#1088#1077#1076#1077#1083' 6: '#1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 6: '#1082#1086#1083'-'#1074#1086', '#1096#1090
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSummaSale6: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 6: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 6: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSumma6: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 6: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Summa6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 6: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentAmount6: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = #1055#1088#1077#1076#1077#1083' 6: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PercentAmount6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 6: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentSummaSale6: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = #1055#1088#1077#1076#1077#1083' 6: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PercentSummaSale6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 6: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentSumma6: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = #1055#1088#1077#1076#1077#1083' 6: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentSumma6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 6: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentProfit6: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: % '#1076#1086#1093#1086#1076#1072
            Caption = #1055#1088#1077#1076#1077#1083' 6: % '#1076#1086#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentProfit6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 6: % '#1076#1086#1093#1086#1076#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSummaProfit6: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: '#1076#1086#1093#1086#1076
            Caption = #1055#1088#1077#1076#1077#1083' 6: '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'SummaProfit6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 6: '#1076#1086#1093#1086#1076
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxVitrPercent6: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: '#1074#1080#1088#1090'. %'
            Caption = #1055#1088#1077#1076#1077#1083' 6: '#1074#1080#1088#1090'. %'
            DataBinding.FieldName = 'VirtPercent6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 6: '#1074#1080#1088#1090'. %'
            MinWidth = 10
            Width = 75
          end
          object cxVirtSummaSale6: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 6: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'VirtSummaSale6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 6: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxVirtProfit6: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            Caption = #1055#1088#1077#1076#1077#1083' 6: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'VirtProfit6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 6: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxMarginPercent6: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 6: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            Caption = #1055#1088#1077#1076#1077#1083' 6: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            DataBinding.FieldName = 'MarginPercent6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 6: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxAmount7: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7:  '#1082#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1055#1088#1077#1076#1077#1083' 7:  '#1082#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 7:  '#1082#1086#1083'-'#1074#1086', '#1096#1090
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSummaSale7: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 7: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 7: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSumma7: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 7: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Summa7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 7: '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentAmount7: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            Caption = #1055#1088#1077#1076#1077#1083' 7: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'PercentAmount7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 7: % '#1086#1090' '#1086#1073#1097#1077#1075#1086' '#1082#1086#1083'-'#1074#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentSummaSale7: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            Caption = #1055#1088#1077#1076#1077#1083' 7: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'PercentSummaSale7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 7: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'.'
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentSumma7: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            Caption = #1055#1088#1077#1076#1077#1083' 7: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentSumma7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 7: % '#1086#1090' '#1089#1091#1084#1084#1099' '#1074'  '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxPercentProfit7: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: % '#1076#1086#1093#1086#1076#1072
            Caption = #1055#1088#1077#1076#1077#1083' 7: % '#1076#1086#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentProfit7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 7: % '#1076#1086#1093#1086#1076#1072
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxSummaProfit7: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: '#1076#1086#1093#1086#1076
            Caption = #1055#1088#1077#1076#1077#1083' 7: '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'SummaProfit7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 7: '#1076#1086#1093#1086#1076
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxVitrPercent7: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: '#1074#1080#1088#1090'. %'
            Caption = #1055#1088#1077#1076#1077#1083' 7: '#1074#1080#1088#1090'. %'
            DataBinding.FieldName = 'VirtPercent7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 7: '#1074#1080#1088#1090'. %'
            MinWidth = 10
            Width = 75
          end
          object cxVirtSummaSale7: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1055#1088#1077#1076#1077#1083' 7: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'VirtSummaSale7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 7: '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxVirtProfit7: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            Caption = #1055#1088#1077#1076#1077#1083' 7: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'VirtProfit7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 7: '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxMarginPercent7: TcxGridDBColumn
            AlternateCaption = #1055#1088#1077#1076#1077#1083' 7: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            Caption = #1055#1088#1077#1076#1077#1083' 7: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            DataBinding.FieldName = 'MarginPercent7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1077#1083' 7: % '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1087#1088#1077#1076#1077#1083#1091
            MinWidth = 10
            Options.Editing = False
            Width = 75
          end
          object cxColor_Amount: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Amount'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_Summa: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Summa'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_SummaSale: TcxGridDBColumn
            DataBinding.FieldName = 'Color_SummaSale'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentAmount1: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentAmount1'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentSumma1: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentSumma1'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentSummaSale1: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentSummaSale1'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentAmount2: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentAmount2'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentSumma2: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentSumma2'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentSummaSale2: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentSummaSale2'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentAmount3: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentAmount3'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentSumma3: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentSumma3'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentSummaSale3: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentSummaSale3'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentAmount4: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentAmount4'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentSumma4: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentSumma4'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentSummaSale4: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentSummaSale4'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentAmount5: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentAmount5'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentSumma5: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentSumma5'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentSummaSale5: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentSummaSale5'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentAmount6: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentAmount6'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentSumma6: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentSumma6'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentSummaSale6: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentSummaSale6'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentAmount7: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentAmount7'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentSumma7: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentSumma7'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
          object cxColor_PercentSummaSale7: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentSummaSale7'
            Visible = False
            MinWidth = 10
            Options.Editing = False
            VisibleForCustomization = False
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 0
        Width = 315
        Height = 503
        Align = alLeft
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        PopupMenu = PopupMenu
        TabOrder = 0
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxGridDBColumn4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxGridDBColumn5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxGridDBColumn6
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
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxGridDBColumn8
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
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxGridDBColumn11
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxGridDBColumn10
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxGridDBColumn4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxGridDBColumn5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxGridDBColumn6
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
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxGridDBColumn8
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
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxGridDBColumn11
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxGridDBColumn10
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
          OptionsView.HeaderHeight = 60
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object cxGridDBColumn1: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalMainName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 150
          end
          object cxGridDBColumn2: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 200
          end
          object cxGridDBColumn3: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1085#1072#1094#1077#1085#1082#1080' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'MarginCategoryName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 83
          end
          object cxGridDBColumn4: TcxGridDBColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1050#1086#1083'-'#1074#1086', '#1096#1090
            Caption = #1050#1086#1083'-'#1074#1086', '#1096#1090
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 85
          end
          object cxGridDBColumn5: TcxGridDBColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1042' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1042' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'SummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 85
          end
          object cxGridDBColumn6: TcxGridDBColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1042' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            Caption = #1042' '#1094#1077#1085#1072#1093' '#1087#1088#1080#1093#1086#1076#1072', '#1075#1088#1085
            DataBinding.FieldName = 'Summa'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 85
          end
          object cxGridDBColumn7: TcxGridDBColumn
            AlternateCaption = #1048#1090#1086#1075#1086': % '#1076#1086#1093#1086#1076#1072
            Caption = '% '#1076#1086#1093#1086#1076#1072
            DataBinding.FieldName = 'PercentProfit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object cxGridDBColumn8: TcxGridDBColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1076#1086#1093#1086#1076
            Caption = #1076#1086#1093#1086#1076
            DataBinding.FieldName = 'SummaProfit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object cxGridDBColumn9: TcxGridDBColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1074#1080#1088#1090'. %'
            Caption = #1074#1080#1088#1090'. %'
            DataBinding.FieldName = 'VirtPercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 50
          end
          object cxGridDBColumn10: TcxGridDBColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            Caption = #1074#1080#1088#1090'. '#1074' '#1094#1077#1085#1072#1093' '#1087#1088#1086#1076'., '#1075#1088#1085
            DataBinding.FieldName = 'VirtSummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 85
          end
          object cxGridDBColumn11: TcxGridDBColumn
            AlternateCaption = #1048#1090#1086#1075#1086': '#1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            Caption = #1074#1080#1088#1090'. '#1076#1086#1093#1086#1076
            DataBinding.FieldName = 'VirtProfit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 85
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter: TcxSplitter
        Left = 315
        Top = 0
        Width = 3
        Height = 503
        Control = cxGrid1
      end
    end
  end
  object cxLabel8: TcxLabel [2]
    Left = 176
    Top = 7
    Caption = #1055#1088#1077#1076#1077#1083' 1 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
  end
  object cxLabel9: TcxLabel [3]
    Left = 175
    Top = 37
    Caption = #1055#1088#1077#1076#1077#1083' 2 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
  end
  object cePrice1: TcxCurrencyEdit [4]
    Left = 314
    Top = 6
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 8
    Width = 80
  end
  object cePrice2: TcxCurrencyEdit [5]
    Left = 314
    Top = 36
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 9
    Width = 80
  end
  object cxLabel7: TcxLabel [6]
    Left = 642
    Top = 7
    Caption = #1055#1088#1077#1076#1077#1083' 5 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
  end
  object cxLabel12: TcxLabel [7]
    Left = 642
    Top = 37
    Caption = #1055#1088#1077#1076#1077#1083' 6 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
  end
  object cePrice5: TcxCurrencyEdit [8]
    Left = 782
    Top = 6
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 12
    Width = 80
  end
  object cePrice6: TcxCurrencyEdit [9]
    Left = 782
    Top = 36
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 13
    Width = 80
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
        Component = cxSplitter
        Properties.Strings = (
          'Left')
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
    object actisVipCheck: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1042#1048#1055
      Hint = #1074#1099#1076#1077#1083#1080#1090#1100' '#1042#1048#1055
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actinisDay: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1044#1085#1103#1084
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
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
          Value = ''
          Component = MarginReportGuides
          ComponentItem = 'Key'
        end
        item
          Name = 'MarginReportName'
          Value = ''
          Component = MarginReportGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end>
      isShowModal = False
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
          Value = 42400d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'Price1'
          Value = 0.000000000000000000
          Component = cePrice1
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'Price2'
          Value = 0.000000000000000000
          Component = cePrice2
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'Price3'
          Value = 0.000000000000000000
          Component = cePrice3
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'Price4'
          Value = 0.000000000000000000
          Component = cePrice4
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'Price5'
          Value = 0.000000000000000000
          Component = cePrice5
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'Price6'
          Value = 0.000000000000000000
          Component = cePrice6
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'MarginReportId'
          Value = ''
          Component = MarginReportGuides
          ComponentItem = 'Key'
          ParamType = ptInput
        end
        item
          Name = 'MarginReportName'
          Value = ''
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
  end
  inherited MasterDS: TDataSource
    Left = 48
    Top = 160
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 160
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
    Left = 80
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 120
    Top = 216
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
          ItemName = 'bb'
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
    object bb: TdxBarButton
      Action = MarginReportItemOpenForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
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
    ColumnAddOnList = <
      item
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end>
    Left = 536
    Top = 192
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 32
    Top = 0
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end
      item
      end
      item
        Component = deStart
      end
      item
        Component = deEnd
      end
      item
      end>
    Left = 576
    Top = 112
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
        Value = Null
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
    Left = 840
    Top = 224
  end
  object DBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
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
    ColumnAddOnList = <
      item
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 144
    Top = 368
  end
  object MasterCDS1: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'UnitId'
    MasterFields = 'UnitId'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 144
    Top = 416
  end
  object MasterDS1: TDataSource
    DataSet = MasterCDS1
    Left = 216
    Top = 400
  end
  object spSelectMaster: TdsdStoredProc
    StoredProcName = 'gpReport_PriceIntervention'
    DataSet = MasterCDS1
    DataSets = <
      item
        DataSet = MasterCDS1
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 42400d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inPrice1'
        Value = 0.000000000000000000
        Component = cePrice1
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPrice2'
        Value = 0.000000000000000000
        Component = cePrice2
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPrice3'
        Value = 0.000000000000000000
        Component = cePrice3
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPrice4'
        Value = 0.000000000000000000
        Component = cePrice4
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPrice5'
        Value = 0.000000000000000000
        Component = cePrice5
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPrice6'
        Value = 0.000000000000000000
        Component = cePrice6
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inMarginReportId'
        Value = ''
        Component = MarginReportGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 312
    Top = 376
  end
end
