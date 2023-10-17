inherited Report_RemainsOverGoodsForm: TReport_RemainsOverGoodsForm
  Caption = #1054#1090#1095#1077#1090' <'#1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1081' '#1080#1079#1083#1080#1096#1082#1086#1074' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084'>'
  ClientHeight = 557
  ClientWidth = 1104
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1126
  ExplicitHeight = 613
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 101
    Width = 1104
    Height = 456
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Properties.ActivateFocusedTab = False
    Properties.Options = [pcoGradient, pcoGradientClientArea, pcoRedrawOnResize, pcoSort]
    ExplicitTop = 101
    ExplicitWidth = 1104
    ExplicitHeight = 456
    ClientRectBottom = 456
    ClientRectRight = 1104
    ClientRectTop = 24
    inherited tsMain: TcxTabSheet
      Caption = #1054#1089#1085#1086#1074#1085#1072#1103
      TabVisible = True
      ExplicitTop = 24
      ExplicitWidth = 1104
      ExplicitHeight = 432
      inherited cxGrid: TcxGrid
        Width = 1104
        Height = 211
        ExplicitWidth = 1104
        ExplicitHeight = 211
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsMCS_from
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemainsMCS_from
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsMCS_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemainsMCS_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsMCS_to_Child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemainsMCS_to_Child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsMCS_from_Child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemainsMCS_from_Child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = MCSValue
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaMCSValue
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = MCSValue_Child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaMCSValue_Child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsMCS_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemainsMCS_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Over
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_OverDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa_Over
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSend
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Reserve
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_In
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsMCS_result_inf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemainsMCS_result_inf
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
              Column = RemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsMCS_from
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemainsMCS_from
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsMCS_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemainsMCS_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsMCS_to_Child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemainsMCS_to_Child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsMCS_from_Child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemainsMCS_from_Child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = MCSValue
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaMCSValue
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = MCSValue_Child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaMCSValue_Child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsMCS_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemainsMCS_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Over
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_OverDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa_Over
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSend
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Reserve
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_In
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsMCS_result_inf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemainsMCS_result_inf
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object isChoice: TcxGridDBColumn
            Caption = #1054#1090#1073#1086#1088
            DataBinding.FieldName = 'isChoice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 49
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 100
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object IsClose: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090' '#1082#1086#1076' '#1087#1086' '#1074#1089#1077#1081' '#1089#1077#1090#1080
            DataBinding.FieldName = 'IsClose'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 67
          end
          object IsTop: TcxGridDBColumn
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'IsTop'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 37
          end
          object isFirst: TcxGridDBColumn
            Caption = '1-'#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isFirst'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 45
          end
          object isSecond: TcxGridDBColumn
            Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isSecond'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1085#1072' '#1076#1072#1090#1091' ('#1080#1089#1090#1086#1088#1080#1103')'
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00'
            Properties.MinValue = 0.010000000000000000
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object StartDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089' ('#1080#1089#1090#1086#1088#1080#1103')'
            DataBinding.FieldName = 'StartDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object EndDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086' ('#1080#1089#1090#1086#1088#1080#1103')'
            DataBinding.FieldName = 'EndDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object RemainsStart: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1082#1086#1083'-'#1074#1086' '#1085#1072#1095'.'
            DataBinding.FieldName = 'RemainsStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountSend: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1088#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'AmountSend'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1088#1072#1089#1093#1086#1076
            Options.Editing = False
            Width = 69
          end
          object Amount_Reserve: TcxGridDBColumn
            Caption = #1054#1090#1083'. '#1090#1086#1074#1072#1088' ('#1095#1077#1082')'
            DataBinding.FieldName = 'Amount_Reserve'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1083#1086#1078#1077#1085#1085#1099#1081' '#1090#1086#1074#1072#1088' ('#1095#1077#1082')'
            Options.Editing = False
            Width = 51
          end
          object Amount_In: TcxGridDBColumn
            Caption = #1047#1072#1090#1086#1074#1072#1088#1082#1072' ('#1087#1088#1080#1093'.)'
            DataBinding.FieldName = 'Amount_In'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1090#1086#1074#1072#1088#1082#1072' ('#1087#1088#1080#1093'.)'
            Options.Editing = False
            Width = 54
          end
          object SummaRemainsStart: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1089#1091#1084#1084#1072' '#1085#1072#1095'.'
            DataBinding.FieldName = 'SummaRemainsStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Invnumber_Over: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1048#1079#1083#1080#1096#1082#1086#1074
            DataBinding.FieldName = 'Invnumber_Over'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object Amount_Over: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1082#1086#1083'-'#1074#1086' '#1088#1072#1089#1093#1086#1076' ('#1076#1086#1082')'
            DataBinding.FieldName = 'Amount_Over'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object Summa_Over: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1089#1091#1084#1084#1072' '#1088#1072#1089#1093#1086#1076' ('#1076#1086#1082')'
            DataBinding.FieldName = 'Summa_Over'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount_OverDiff: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1076#1086#1082'./'#1086#1090#1095#1077#1090
            DataBinding.FieldName = 'Amount_OverDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object RemainsMCS_result: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1082#1086#1083'-'#1074#1086' '#1088#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'RemainsMCS_result'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummaRemainsMCS_result: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1089#1091#1084#1084#1072' '#1088#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'SummaRemainsMCS_result'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object RemainsMCS_result_inf: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1082#1086#1083'-'#1074#1086' '#1088#1072#1089#1093#1086#1076' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'RemainsMCS_result_inf'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummaRemainsMCS_result_inf: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1089#1091#1084#1084#1072' '#1088#1072#1089#1093#1086#1076' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'SummaRemainsMCS_result_inf'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MCSValue: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1053#1058#1047
            DataBinding.FieldName = 'MCSValue'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077#1089#1085#1080#1078#1072#1077#1084#1099#1081' '#1090#1086#1074#1072#1088#1085#1099#1081' '#1079#1072#1087#1072#1089
            Options.Editing = False
            Width = 53
          end
          object SummaMCSValue: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1053#1058#1047
            DataBinding.FieldName = 'SummaMCSValue'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object RemainsMCS_from: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' > '#1053#1058#1047
            DataBinding.FieldName = 'RemainsMCS_from'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummaRemainsMCS_from: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' > '#1053#1058#1047
            DataBinding.FieldName = 'SummaRemainsMCS_from'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object RemainsMCS_to: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' < '#1053#1058#1047
            DataBinding.FieldName = 'RemainsMCS_to'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object SummaRemainsMCS_to: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' < '#1053#1058#1047
            DataBinding.FieldName = 'SummaRemainsMCS_to'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object RemainsMCS_from_Child: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1082#1086#1083'-'#1074#1086' > '#1053#1058#1047
            DataBinding.FieldName = 'RemainsMCS_from_Child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1086#1089#1090#1072#1090#1082#1072' '#1089#1074#1077#1088#1093' '#1053#1058#1047
            Options.Editing = False
            Width = 88
          end
          object SummaRemainsMCS_from_Child: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1089#1091#1084#1084#1072' > '#1053#1058#1047
            DataBinding.FieldName = 'SummaRemainsMCS_from_Child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object RemainsMCS_to_Child: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1082#1086#1083'-'#1074#1086' < '#1053#1058#1047
            DataBinding.FieldName = 'RemainsMCS_to_Child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object SummaRemainsMCS_to_Child: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1089#1091#1084#1084#1072' < '#1053#1058#1047
            DataBinding.FieldName = 'SummaRemainsMCS_to_Child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object isErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1086#1074#1072#1088' '#1091#1076#1072#1083#1077#1085
            Options.Editing = False
            Width = 27
          end
          object MCSValue_Child: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1082#1086#1083'-'#1074#1086' '#1053#1058#1047
            DataBinding.FieldName = 'MCSValue_Child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummaMCSValue_Child: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1089#1091#1084#1084#1072' '#1053#1058#1047
            DataBinding.FieldName = 'SummaMCSValue_Child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MinExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1086#1089#1090#1072#1090#1082#1072
            DataBinding.FieldName = 'MinExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 112
          end
          object isError: TcxGridDBColumn
            Caption = #1054#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isError'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1054#1096#1080#1073#1082#1072' '#1076#1072'/'#1085#1077#1090
            Options.Editing = False
            Width = 63
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 216
        Width = 1104
        Height = 216
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaRemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemainsMCS_from
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaRemainsMCS_from
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemainsMCS_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaRemainsMCS_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chMCSValue
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaMCSValue
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemainsMCS_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaRemainsMCS_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_Over
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSumma_Over
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountSend
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_Reserve
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemainsMCS_result_inf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaRemainsMCS_result_inf
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaRemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemainsMCS_from
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaRemainsMCS_from
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemainsMCS_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaRemainsMCS_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chMCSValue
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaMCSValue
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemainsMCS_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaRemainsMCS_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_Over
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSumma_Over
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountSend
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_Reserve
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemainsMCS_result_inf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSummaRemainsMCS_result_inf
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 250
          end
          object chPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1085#1072' '#1076#1072#1090#1091' ('#1080#1089#1090#1086#1088#1080#1103')'
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00'
            Properties.MinValue = 0.010000000000000000
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object chStartDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089' ('#1080#1089#1090#1086#1088#1080#1103')'
            DataBinding.FieldName = 'StartDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object chEndDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086' ('#1080#1089#1090#1086#1088#1080#1103')'
            DataBinding.FieldName = 'EndDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object chRemainsStart: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1082#1086#1083'-'#1074#1086' '#1085#1072#1095'.'
            DataBinding.FieldName = 'RemainsStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object chAmountSend: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'AmountSend'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1088#1080#1093#1086#1076
            Options.Editing = False
            Width = 69
          end
          object chAmount_Reserve: TcxGridDBColumn
            Caption = #1054#1090#1083'. '#1090#1086#1074#1072#1088' ('#1095#1077#1082')'
            DataBinding.FieldName = 'Amount_Reserve'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1083#1086#1078#1077#1085#1085#1099#1081' '#1090#1086#1074#1072#1088' ('#1095#1077#1082')'
            Options.Editing = False
            Width = 51
          end
          object chSummaRemainsStart: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1089#1091#1084#1084#1072' '#1085#1072#1095'.'
            DataBinding.FieldName = 'SummaRemainsStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object chRemainsMCS_result: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1055#1056#1048#1061#1054#1044
            DataBinding.FieldName = 'RemainsMCS_result'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chSummaRemainsMCS_result: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1056#1048#1061#1054#1044
            DataBinding.FieldName = 'SummaRemainsMCS_result'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object chRemainsMCS_result_inf: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1055#1056#1048#1061#1054#1044' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'RemainsMCS_result_inf'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chSummaRemainsMCS_result_inf: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1056#1048#1061#1054#1044' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'SummaRemainsMCS_result_inf'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object chMCSValue: TcxGridDBColumn
            AlternateCaption = #1053#1077#1089#1085#1080#1078#1072#1077#1084#1099#1081' '#1090#1086#1074#1072#1088#1085#1099#1081' '#1079#1072#1087#1072#1089
            Caption = #1050#1086#1083'-'#1074#1086' '#1053#1058#1047
            DataBinding.FieldName = 'MCSValue'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077#1089#1085#1080#1078#1072#1077#1084#1099#1081' '#1090#1086#1074#1072#1088#1085#1099#1081' '#1079#1072#1087#1072#1089
            Options.Editing = False
            Width = 70
          end
          object chSummaMCSValue: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1053#1058#1047
            DataBinding.FieldName = 'SummaMCSValue'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chRemainsMCS_from: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' > '#1053#1058#1047
            DataBinding.FieldName = 'RemainsMCS_from'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object chSummaRemainsMCS_from: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' > '#1053#1058#1047
            DataBinding.FieldName = 'SummaRemainsMCS_from'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object chRemainsMCS_to: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' < '#1053#1058#1047
            DataBinding.FieldName = 'RemainsMCS_to'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object chSummaRemainsMCS_to: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' < '#1053#1058#1047
            DataBinding.FieldName = 'SummaRemainsMCS_to'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object chMinExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1086#1089#1090#1072#1090#1082#1072
            DataBinding.FieldName = 'MinExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 112
          end
          object chAmount_Over: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1055#1056#1048#1061#1054#1044' ('#1076#1086#1082')'
            DataBinding.FieldName = 'Amount_Over'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object chSumma_Over: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1093#1086#1076' ('#1076#1086#1082')'
            DataBinding.FieldName = 'Summa_Over'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chAmount_OverDiff: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1082#1086#1083'-'#1074#1072' '#1087#1088#1080#1093#1086#1076' '#1089' '#1076#1086#1082#1091#1084'.'
            DataBinding.FieldName = 'Amount_OverDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'
            DataBinding.FieldName = 'GoodsCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PriceFrom: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'PriceFrom'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitterChild: TcxSplitter
        Left = 0
        Top = 211
        Width = 1104
        Height = 5
        AlignSplitter = salBottom
        Control = cxGrid1
      end
    end
    object cxTabSheetTotal: TcxTabSheet
      Caption = #1048#1090#1086#1075#1080
      ImageIndex = 2
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cxGridTotal: TcxGrid
        Left = 0
        Top = 0
        Width = 1104
        Height = 432
        Align = alClient
        TabOrder = 0
        object cxGridTotalDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = TotalDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
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
              Kind = skSum
            end
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
              Column = cxRemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaRemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxRemainsMCS_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaRemainsMCS_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxMCSValue
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaMCSValue
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxRemainsMCS_from
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaRemainsMCS_from
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxRemainsMCS_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaRemainsMCS_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount_Over
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSumma_Over
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount_OverDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxRemainsMCS_result_inf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaRemainsMCS_result_inf
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
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
              Kind = skSum
            end
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
              Column = cxRemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaRemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxRemainsMCS_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaRemainsMCS_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxMCSValue
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaMCSValue
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxRemainsMCS_from
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaRemainsMCS_from
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxRemainsMCS_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaRemainsMCS_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount_Over
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSumma_Over
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount_OverDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxRemainsMCS_result_inf
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxSummaRemainsMCS_result_inf
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
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object cxUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 250
          end
          object cxRemainsStart: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1082#1086#1083'-'#1074#1086' '#1085#1072#1095'.'
            DataBinding.FieldName = 'RemainsStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object cxSummaRemainsStart: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1089#1091#1084#1084#1072' '#1085#1072#1095'.'
            DataBinding.FieldName = 'SummaRemainsStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object cxRemainsMCS_result: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1055#1056#1048#1061#1054#1044
            DataBinding.FieldName = 'RemainsMCS_result'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object cxSummaRemainsMCS_result: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1056#1048#1061#1054#1044
            DataBinding.FieldName = 'SummaRemainsMCS_result'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object cxRemainsMCS_result_inf: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1055#1056#1048#1061#1054#1044' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'RemainsMCS_result_inf'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object cxSummaRemainsMCS_result_inf: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1056#1048#1061#1054#1044' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'SummaRemainsMCS_result_inf'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object cxMCSValue: TcxGridDBColumn
            AlternateCaption = #1053#1077#1089#1085#1080#1078#1072#1077#1084#1099#1081' '#1090#1086#1074#1072#1088#1085#1099#1081' '#1079#1072#1087#1072#1089
            Caption = #1050#1086#1083'-'#1074#1086' '#1053#1058#1047
            DataBinding.FieldName = 'MCSValue'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077#1089#1085#1080#1078#1072#1077#1084#1099#1081' '#1090#1086#1074#1072#1088#1085#1099#1081' '#1079#1072#1087#1072#1089
            Options.Editing = False
            Width = 70
          end
          object cxSummaMCSValue: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1053#1058#1047
            DataBinding.FieldName = 'SummaMCSValue'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object cxRemainsMCS_from: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' > '#1053#1058#1047
            DataBinding.FieldName = 'RemainsMCS_from'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object cxSummaRemainsMCS_from: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' > '#1053#1058#1047
            DataBinding.FieldName = 'SummaRemainsMCS_from'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object cxRemainsMCS_to: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' < '#1053#1058#1047
            DataBinding.FieldName = 'RemainsMCS_to'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object cxSummaRemainsMCS_to: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' < '#1053#1058#1047
            DataBinding.FieldName = 'SummaRemainsMCS_to'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object cxAmount_Reserve: TcxGridDBColumn
            Caption = #1054#1090#1083'. '#1090#1086#1074#1072#1088' ('#1095#1077#1082')'
            DataBinding.FieldName = 'Amount_Reserve'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1083#1086#1078#1077#1085#1085#1099#1081' '#1090#1086#1074#1072#1088' ('#1095#1077#1082')'
            Options.Editing = False
            Width = 51
          end
          object cxAmount_In: TcxGridDBColumn
            Caption = #1047#1072#1090#1086#1074#1072#1088#1082#1072' ('#1087#1088#1080#1093'.)'
            DataBinding.FieldName = 'Amount_In'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1090#1086#1074#1072#1088#1082#1072' ('#1087#1088#1080#1093'.)'
            Options.Editing = False
            Width = 54
          end
          object cxAmount_Over: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1055#1056#1048#1061#1054#1044' ('#1076#1086#1082')'
            DataBinding.FieldName = 'Amount_Over'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object cxSumma_Over: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1093#1086#1076' ('#1076#1086#1082')'
            DataBinding.FieldName = 'Summa_Over'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object cxAmount_OverDiff: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1082#1086#1083'-'#1074#1072' '#1087#1088#1080#1093#1086#1076' '#1089' '#1076#1086#1082#1091#1084'.'
            DataBinding.FieldName = 'Amount_OverDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object cxRersent_from: TcxGridDBColumn
            Caption = '% '#1080#1079#1083#1080#1096#1082#1086#1074
            DataBinding.FieldName = 'Rersent_from'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object cxRersent_to: TcxGridDBColumn
            Caption = '% '#1085#1077' '#1093#1074#1072#1090#1072#1077#1090
            DataBinding.FieldName = 'Rersent_to'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
        end
        object cxGridTotalLevel: TcxGridLevel
          GridView = cxGridTotalDBTableView
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1104
    Height = 75
    ExplicitWidth = 1104
    ExplicitHeight = 75
    inherited deStart: TcxDateEdit
      Left = 99
      Top = 4
      ExplicitLeft = 99
      ExplicitTop = 4
    end
    inherited deEnd: TcxDateEdit
      Left = 1019
      Top = 3
      Visible = False
      ExplicitLeft = 1019
      ExplicitTop = 3
    end
    inherited cxLabel1: TcxLabel
      Left = 6
      Top = 5
      Caption = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1076#1072#1090#1091':'
      ExplicitLeft = 6
      ExplicitTop = 5
      ExplicitWidth = 94
    end
    inherited cxLabel2: TcxLabel
      Left = 963
      Top = 7
      Visible = False
      ExplicitLeft = 963
      ExplicitTop = 7
    end
    object cxLabel4: TcxLabel
      Left = 193
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 281
      Top = 4
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 247
    end
    object cxLabel3: TcxLabel
      Left = 535
      Top = 5
      Caption = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1072#1085#1072#1083#1080#1079#1072' '#1053#1058#1047
    end
    object edPeriod: TcxCurrencyEdit
      Left = 690
      Top = 4
      EditValue = 30.000000000000000000
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.MinValue = 1.000000000000000000
      TabOrder = 7
      Width = 22
    end
    object cxLabel6: TcxLabel
      Left = 535
      Top = 30
      Caption = #1048#1079#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1053#1058#1047' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072':'
    end
    object cxLabel7: TcxLabel
      Left = 6
      Top = 30
      Caption = #1054#1089#1090#1072#1074#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1076#1083#1103' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1072
    end
    object edAssortment: TcxCurrencyEdit
      Left = 214
      Top = 29
      EditValue = 1.000000000000000000
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.MinValue = 1.000000000000000000
      TabOrder = 10
      Width = 30
    end
    object cxLabel8: TcxLabel
      Left = 252
      Top = 30
      Caption = #1053#1077' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1103#1090#1100' '#1089#1088#1086#1082#1080' '#1084#1077#1085#1077#1077' '#1061#1061#1061' '#1084#1077#1089#1103#1094#1077#1074
    end
    object edTerm: TcxCurrencyEdit
      Left = 498
      Top = 29
      EditValue = 1.000000000000000000
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.MinValue = 1.000000000000000000
      TabOrder = 12
      Width = 30
    end
    object cbReserve: TcxCheckBox
      Left = 6
      Top = 51
      Hint = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1081' '#1090#1086#1074#1072#1088' ('#1044#1072'/'#1053#1077#1090')'
      Caption = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1081' '#1090#1086#1074#1072#1088' ('#1044#1072'/'#1053#1077#1090')'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 13
      Width = 251
    end
    object cbIncome: TcxCheckBox
      Left = 263
      Top = 51
      Hint = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1090#1086#1074#1072#1088', '#1087#1088#1080#1096#1077#1076#1096#1080#1081' '#1079#1072' '#1087#1086#1089#1083#1077#1076#1085#1080#1077' '#1061' '#1076#1085#1077#1081
      Caption = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1090#1086#1074#1072#1088', '#1087#1088#1080#1096#1077#1076#1096#1080#1081' '#1079#1072' '#1087#1086#1089#1083#1077#1076#1085#1080#1077' '#1061' '#1076#1085#1077#1081
      ParentShowHint = False
      ShowHint = True
      TabOrder = 14
      Width = 305
    end
    object edDayIncome: TcxCurrencyEdit
      Left = 566
      Top = 51
      EditValue = 15.000000000000000000
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.MinValue = 1.000000000000000000
      TabOrder = 15
      Width = 30
    end
    object cbMCS_0: TcxCheckBox
      Left = 907
      Top = 51
      Hint = #1055#1086#1083#1091#1095#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1089' '#1053#1058#1047' 0'
      Caption = #1055#1086#1083#1091#1095#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1089' '#1053#1058#1047' 0'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 16
      Width = 172
    end
    object cbNoPromo: TcxCheckBox
      Left = 925
      Top = 1
      Hint = #1041#1077#1079' '#1084#1072#1088#1082#1077#1090'. '#1082#1086#1085#1090#1088#1072#1082#1090#1086#1074
      Caption = #1041#1077#1079' '#1084#1072#1088#1082#1077#1090'. '#1082#1086#1085#1090#1088#1072#1082#1090#1086#1074
      ParentShowHint = False
      ShowHint = True
      TabOrder = 17
      Width = 169
    end
  end
  object cxLabel5: TcxLabel [2]
    Left = 719
    Top = 6
    Caption = #1057#1090#1088#1072#1093#1086#1074#1086#1081' '#1079#1072#1087#1072#1089' '#1053#1058#1047' '#1076#1083#1103' '#1061' '#1076#1085#1077#1081
  end
  object edDay: TcxCurrencyEdit [3]
    Left = 892
    Top = 4
    EditValue = 12.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.MinValue = 1.000000000000000000
    TabOrder = 7
    Width = 27
  end
  object cbInMCS: TcxCheckBox [4]
    Left = 718
    Top = 29
    Hint = #1076#1083#1103' '#1072#1087#1090#1077#1082'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081' '#1080#1079#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1053#1058#1047' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
    Caption = #1076#1083#1103' '#1072#1087#1090#1077#1082'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081
    TabOrder = 8
    Width = 149
  end
  object cbMCS: TcxCheckBox [5]
    Left = 867
    Top = 29
    Hint = #1076#1083#1103' '#1072#1087#1090#1077#1082'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081' '#1080#1079#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1053#1058#1047' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
    Caption = #1076#1083#1103' '#1072#1087#1090#1077#1082#1080'-'#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
    TabOrder = 9
    Width = 152
  end
  object cbisRecal: TcxCheckBox [6]
    Left = 1034
    Top = 30
    Hint = #1076#1083#1103' '#1072#1087#1090#1077#1082'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081' '#1080#1079#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1053#1058#1047' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    Width = 22
  end
  object cbAssortment: TcxCheckBox [7]
    Left = 190
    Top = 29
    Hint = #1076#1083#1103' '#1072#1087#1090#1077#1082'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081' '#1080#1079#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1053#1058#1047' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
    TabOrder = 11
    Width = 21
  end
  object cbTerm: TcxCheckBox [8]
    Left = 474
    Top = 29
    Hint = #1076#1083#1103' '#1072#1087#1090#1077#1082'-'#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077#1081' '#1080#1079#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1053#1058#1047' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
    TabOrder = 12
    Width = 22
  end
  object cbSummSend: TcxCheckBox [9]
    Left = 612
    Top = 51
    Hint = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1090#1086#1074#1072#1088', '#1087#1088#1080#1096#1077#1076#1096#1080#1081' '#1079#1072' '#1087#1086#1089#1083#1077#1076#1085#1080#1077' '#1061' '#1076#1085#1077#1081
    Caption = #1053#1077' '#1087#1077#1088#1077#1084#1077#1097#1072#1090#1100' '#1090#1086#1074#1072#1088#1099' '#1085#1072' '#1089#1091#1084#1084#1091' '#1084#1077#1085#1077#1077' '#1061' '#1075#1088#1085
    ParentShowHint = False
    ShowHint = True
    TabOrder = 13
    Width = 253
  end
  object edSummSend: TcxCurrencyEdit [10]
    Left = 866
    Top = 51
    EditValue = 100.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.MinValue = 1.000000000000000000
    TabOrder = 14
    Width = 30
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
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Tag'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    object dsdGridToExcelTotal: TdsdGridToExcel [1]
      Category = 'DSDLib'
      TabSheet = cxTabSheetTotal
      MoveParams = <>
      Enabled = False
      Grid = cxGridTotal
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    inherited actGridToExcel: TdsdGridToExcel
      TabSheet = tsMain
    end
    object actOpenPartionReport: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084
      ImageIndex = 39
      FormName = 'TReport_GoodsPartionMoveForm'
      FormNameParam.Value = 'TReport_GoodsPartionMoveForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyName'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'RemainsDate'
          Value = Null
          Component = deStart
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actRefreshPartionPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1072#1088#1090#1080#1080' '#1094#1077#1085#1099
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshIsPartion: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_RemainsOverGoodsDialogForm'
      FormNameParam.Value = 'TReport_RemainsOverGoodsDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41395d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPeriod'
          Value = 'False'
          Component = edPeriod
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inDay'
          Value = 'False'
          Component = edDay
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isMCS'
          Value = Null
          Component = cbMCS
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isInMCS'
          Value = Null
          Component = cbInMCS
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isRecal'
          Value = Null
          Component = cbisRecal
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isAssortment'
          Value = Null
          Component = cbAssortment
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Assortment'
          Value = Null
          Component = edAssortment
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTerm'
          Value = Null
          Component = cbTerm
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Term'
          Value = Null
          Component = edTerm
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isReserve'
          Value = Null
          Component = cbReserve
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isIncome'
          Value = Null
          Component = cbIncome
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DayIncome'
          Value = Null
          Component = edDayIncome
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isSummSend'
          Value = Null
          Component = cbSummSend
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'SummSend'
          Value = Null
          Component = edSummSend
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isMCS_0'
          Value = Null
          Component = cbMCS_0
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isNoPromo'
          Value = Null
          Component = cbNoPromo
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actSetErased_Over: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSetErased_Over
      StoredProcList = <
        item
          StoredProc = spSetErased_Over
        end>
      Caption = 'actSetErased_Over'
      ImageIndex = 41
      QuestionBeforeExecute = #1056#1072#1085#1077#1077' '#1089#1086#1079#1076#1072#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103' '#1073#1091#1076#1077#1090' '#1091#1076#1072#1083#1077#1085'. '#1055#1088#1086#1076#1086#1083#1078#1080#1090#1100'?'
    end
    object actOverChild: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spOverChild
      StoredProcList = <
        item
          StoredProc = spOverChild
        end>
      Caption = 'actOver'
      ImageIndex = 41
    end
    object macOverChild: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actOverChild
        end>
      DataSource = DataSourceDocs
      Hint = #1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1086#1076#1095#1080#1085#1077#1085#1085#1099#1093' '#1101#1083#1077#1084#1077#1085#1090#1086#1074
      ImageIndex = 41
    end
    object actOver: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spOver
      StoredProcList = <
        item
          StoredProc = spOver
        end>
      Caption = 'actOver'
      ImageIndex = 41
    end
    object macOverAll: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSetErased_Over
        end
        item
          Action = macOver
        end
        item
          Action = macOverChild
        end>
      QuestionBeforeExecute = 
        #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1081' '#1080#1079#1083#1080#1096#1082#1086#1074'>.  '#1056 +
        #1072#1085#1077#1077' '#1089#1086#1079#1076#1072#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1073#1091#1076#1077#1090' '#1091#1076#1072#1083#1077#1085'. '#1055#1088#1086#1076#1086#1083#1078#1080#1090#1100'?'
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1081' '#1080#1079#1083#1080#1096#1082#1086#1074'> '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1081' '#1080#1079#1083#1080#1096#1082#1086#1074'>'
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1081' '#1080#1079#1083#1080#1096#1082#1086#1074'>'
      ImageIndex = 30
      WithoutNext = True
    end
    object macOver: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actOver
        end>
      View = cxGridDBTableView
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1081'>'
      ImageIndex = 41
    end
    object actSend: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSend
      StoredProcList = <
        item
          StoredProc = spSend
        end>
      ImageIndex = 41
    end
    object macSend: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSend
        end>
      DataSource = DataSourceDocs
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'> '#1089#1086#1079#1076#1072#1085#1099
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>'
      ImageIndex = 41
    end
    object actSendChild: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSendChild
      StoredProcList = <
        item
          StoredProc = spSendChild
        end>
      Caption = 'actSendChild'
      ImageIndex = 41
    end
    object macSendChild: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSendChild
        end>
      View = cxGridDBTableView1
      QuestionBeforeExecute = 
        #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'> '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1090 +
        #1086#1074#1072#1088#1091'? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'> '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1090#1086#1074#1072#1088#1091' '#1089#1086#1079#1076#1072#1085#1099
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'> '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1090#1086#1074#1072#1088#1091' '
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'> '#1087#1086' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1090#1086#1074#1072#1088#1091' '
      ImageIndex = 41
    end
    object actUpdateMainDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIMaster
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end>
      Caption = 'actUpdateMainDS'
      DataSource = MasterDS
    end
    object actUpdateChildDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end>
      Caption = 'actUpdateChildDS'
      DataSource = ChildDS
    end
    object actSendOver: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSendOver
      StoredProcList = <
        item
          StoredProc = spSendOver
        end>
      Caption = 'actSendOver'
      ImageIndex = 41
    end
    object actOpenUnitForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1089#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103'>'
      Hint = #1089#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103'>'
      ImageIndex = 43
      FormName = 'TUnit_ObjectForm'
      FormNameParam.Value = 'TUnit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = True
    end
    object macSendOver: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSendOver
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'> '#1089#1086#1079#1076#1072#1085#1099
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>'
      ImageIndex = 41
    end
    object actRefreshIncome: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1090#1086#1074#1072#1088', '#1087#1088#1080#1096#1077#1076#1096#1080#1081' '#1079#1072' '#1087#1086#1089#1083#1077#1076#1085#1080#1077' '#1061' '#1076#1085#1077#1081
      Hint = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1090#1086#1074#1072#1088', '#1087#1088#1080#1096#1077#1076#1096#1080#1081' '#1079#1072' '#1087#1086#1089#1083#1077#1076#1085#1080#1077' '#1061' '#1076#1085#1077#1081
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshReserve: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1086#1090#1083'. '#1090#1086#1074#1072#1088
      Hint = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1081' '#1090#1086#1074#1072#1088' ('#1044#1072'/'#1053#1077#1090')'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actLoadGoodsId: TdsdDataToJsonAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = ''
          FromParam.DataType = ftWideString
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = ''
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'GoodsList'
          ToParam.DataType = ftWideString
          ToParam.MultiSelectSeparator = ','
        end>
      JsonParam.Value = Null
      JsonParam.Component = FormParams
      JsonParam.ComponentItem = 'GoodsList'
      JsonParam.DataType = ftWideString
      JsonParam.MultiSelectSeparator = ','
      PairParams = <
        item
          PairName = 'GoodsId'
          DataType = ftInteger
        end>
      FileNameParam.Value = ''
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1090#1086#1074#1072#1088#1072' '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1090#1086#1074#1072#1088#1072' '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 54
    end
  end
  inherited MasterDS: TDataSource
    Left = 456
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    MasterFields = 'GoodsId'
    Left = 272
    Top = 192
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_RemainsOverGoods'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ChildCDS
      end
      item
        DataSet = DataSetDocs
      end
      item
        DataSet = TotalCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inUnitId'
        Value = 41395d
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod'
        Value = Null
        Component = edPeriod
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay'
        Value = Null
        Component = edDay
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDayIncome'
        Value = Null
        Component = edDayIncome
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAssortment'
        Value = Null
        Component = edAssortment
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummSend'
        Value = Null
        Component = edSummSend
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMCS'
        Value = Null
        Component = cbMCS
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisInMCS'
        Value = Null
        Component = cbInMCS
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisRecal'
        Value = Null
        Component = cbisRecal
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAssortment'
        Value = Null
        Component = cbAssortment
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsReserve'
        Value = Null
        Component = cbReserve
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsIncome'
        Value = Null
        Component = cbIncome
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSummSend'
        Value = Null
        Component = cbSummSend
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMCS_0'
        Value = Null
        Component = cbMCS_0
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNoPromo'
        Value = Null
        Component = cbNoPromo
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 416
    Top = 80
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 168
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
          ItemName = 'bbOpenUnitForm'
        end
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
          ItemName = 'bbSendOver'
        end
        item
          Visible = True
          ItemName = 'bbSend'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbmacOverAll'
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
          ItemName = 'bb'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbGoodsPartyReport: TdxBarButton
      Action = actOpenPartionReport
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbSend: TdxBarButton
      Action = macSend
      Category = 0
      Enabled = False
      Visible = ivNever
    end
    object bbSendChild: TdxBarButton
      Action = macSendChild
      Category = 0
      Visible = ivNever
      ImageIndex = 30
    end
    object bbmacOverAll: TdxBarButton
      Action = macOverAll
      Category = 0
    end
    object bbSendOver: TdxBarButton
      Action = macSendOver
      Category = 0
    end
    object bbOpenUnitForm: TdxBarButton
      Action = actOpenUnitForm
      Caption = #1042#1099#1073#1088#1072#1090#1100'  '#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      Category = 0
      Hint = #1042#1099#1073#1088#1072#1090#1100'  '#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103
    end
    object bb: TdxBarButton
      Action = dsdGridToExcelTotal
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actLoadGoodsId
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 480
    Top = 224
  end
  inherited PopupMenu: TPopupMenu
    Left = 104
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 264
    Top = 152
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = GuidesUnit
      end
      item
        Component = deStart
      end>
    Left = 368
    Top = 192
  end
  object GuidesUnit: TdsdGuides
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
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 65520
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 184
    Top = 448
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'GoodsMainId'
    MasterFields = 'GoodsMainId'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 104
    Top = 448
  end
  object spSend: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Send_Auto'
    DataSets = <
      item
      end>
    OutputType = otMultiExecute
    Params = <
      item
        Name = 'inFromId'
        Value = '0'
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = DataSetDocs
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = DataSetDocs
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRemainsMCS_result'
        Value = Null
        Component = DataSetDocs
        ComponentItem = 'RemainsMCS_result'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice_from'
        Value = Null
        Component = DataSetDocs
        ComponentItem = 'PriceFrom'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice_to'
        Value = Null
        Component = DataSetDocs
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCSPeriod'
        Value = 0.000000000000000000
        Component = edPeriod
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCSDay'
        Value = 0.000000000000000000
        Component = edDay
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1000
    Left = 704
    Top = 232
  end
  object DataSetDocs: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 560
    Top = 424
  end
  object DataSourceDocs: TDataSource
    DataSet = DataSetDocs
    Left = 448
    Top = 440
  end
  object spSendChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Send_Auto'
    DataSets = <
      item
      end>
    OutputType = otMultiExecute
    Params = <
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRemainsMCS_result'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'RemainsMCS_result'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice_from'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice_to'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCSPeriod'
        Value = 30.000000000000000000
        Component = edPeriod
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCSDay'
        Value = 12.000000000000000000
        Component = edDay
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1000
    Left = 648
    Top = 224
  end
  object spSetErased_Over: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_Over_Report'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 880
    Top = 168
  end
  object spOver: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Over_Auto'
    DataSets = <
      item
      end>
    OutputType = otMultiExecute
    Params = <
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
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
        ComponentItem = 'RemainsMCS_result'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRemains'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RemainsStart'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountSend'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSend'
        DataType = ftFloat
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
        Name = 'inMCS'
        Value = 30.000000000000000000
        Component = MasterCDS
        ComponentItem = 'MCSValue'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTerm'
        Value = Null
        Component = edTerm
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisTerm'
        Value = Null
        Component = cbTerm
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinExpirationDate'
        Value = 12.000000000000000000
        Component = MasterCDS
        ComponentItem = 'MinExpirationDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1000
    Left = 816
    Top = 168
  end
  object spOverChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Child_Over_Auto'
    DataSets = <
      item
      end>
    OutputType = otMultiExecute
    Params = <
      item
        Name = 'inUnitFromId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitToId'
        Value = Null
        Component = DataSetDocs
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = DataSetDocs
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = DataSetDocs
        ComponentItem = 'RemainsMCS_result'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRemains'
        Value = Null
        Component = DataSetDocs
        ComponentItem = 'RemainsStart'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = DataSetDocs
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCS'
        Value = 30.000000000000000000
        Component = DataSetDocs
        ComponentItem = 'MCSValue'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinExpirationDate'
        Value = 12.000000000000000000
        Component = DataSetDocs
        ComponentItem = 'MinExpirationDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1000
    Left = 800
    Top = 216
  end
  object spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Over_Master'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MIMaster_Id_Over'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Over'
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
        Name = 'ioAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount_Over'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumma'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summa_Over'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRemains'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RemainsStart'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountSend'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSend'
        DataType = ftFloat
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
        Name = 'inMCS'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MCSValue'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinExpirationDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MinExpirationDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 776
    Top = 424
  end
  object spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Over_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'MIChild_Id_Over'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Over'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MIMaster_Id_Over'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount_Over'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRemains'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'RemainsStart'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCS'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'MCSValue'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRemeinsMaster'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RemainsStart'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountMaster'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount_Over'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSummaMaster'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summa_Over'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSummaChild'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Summa_Over'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisError'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isError'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinExpirationDate'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'MinExpirationDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 912
    Top = 424
  end
  object spSendOver: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Send_Auto'
    DataSets = <
      item
      end>
    OutputType = otMultiExecute
    Params = <
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
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
        ComponentItem = 'Amount_Over'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice_from'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCSPeriod'
        Value = 30.000000000000000000
        Component = edPeriod
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCSDay'
        Value = 12.000000000000000000
        Component = edDay
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1000
    Left = 576
    Top = 192
  end
  object TotalCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    MasterFields = 'GoodsId'
    Params = <>
    Left = 944
    Top = 296
  end
  object TotalDS: TDataSource
    DataSet = TotalCDS
    Left = 904
    Top = 304
  end
  object DBViewAddOnTotal: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridTotalDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 880
    Top = 312
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'GoodsList'
        Value = ''
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 176
  end
end
