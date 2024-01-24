inherited Report_GoodsMI_InternalForm: TReport_GoodsMI_InternalForm
  Caption = #1054#1090#1095#1077#1090' <'#1087#1086' '#1090#1086#1074#1072#1088#1072#1084'>'
  ClientHeight = 352
  ClientWidth = 1183
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1199
  ExplicitHeight = 391
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 99
    Width = 1183
    Height = 253
    TabOrder = 3
    ExplicitTop = 99
    ExplicitWidth = 1183
    ExplicitHeight = 253
    ClientRectBottom = 253
    ClientRectRight = 1183
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1183
      ExplicitHeight = 253
      inherited cxGrid: TcxGrid
        Width = 1183
        Height = 253
        ExplicitWidth = 1183
        ExplicitHeight = 253
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_60000
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOut_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOut_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountIn_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountIn_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_60000
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_PriceList
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_ProfitLoss
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Send_pl
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_ProfitLoss_loss
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_ProfitLoss_send
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOut_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOut_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountIn_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountIn_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_60000
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_60000
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_PriceList
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_ProfitLoss
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Send_pl
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_ProfitLoss_loss
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_ProfitLoss_send
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object LocationItemName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086' ('#1101#1083#1077#1084#1077#1085#1090')'
            DataBinding.FieldName = 'LocationItemName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object LocationCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1086#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'LocationCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object LocationName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'LocationName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object LocationItemName_by: TcxGridDBColumn
            Caption = #1050#1086#1084#1091' ('#1101#1083#1077#1084#1077#1085#1090')'
            DataBinding.FieldName = 'LocationItemName_by'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object LocationCode_by: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1082#1086#1084#1091
            DataBinding.FieldName = 'LocationCode_by'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object LocationName_by: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'LocationName_by'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object ArticleLossCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1089#1090#1072#1090#1100#1103' '#1089#1087#1080#1089#1072#1085#1080#1103
            DataBinding.FieldName = 'ArticleLossCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ArticleLossName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1103' '#1089#1087#1080#1089#1072#1085#1080#1103
            DataBinding.FieldName = 'ArticleLossName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object DayOfWeekName: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' ('#1076#1072#1090#1072' '#1076#1086#1082'.)'
            DataBinding.FieldName = 'DayOfWeekName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Invnumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'Invnumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 200
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1086#1074#1072#1088
            Width = 141
          end
          object Name_Scale: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' (Scale)'
            DataBinding.FieldName = 'Name_Scale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AssetCode: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1074#1099#1088'. '#1085#1072' '#1086#1073#1086#1088#1091#1076'.1)'
            DataBinding.FieldName = 'AssetCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AssetName: TcxGridDBColumn
            Caption = #1042#1099#1088#1072#1073#1086#1090#1082#1072' '#1085#1072' '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1080' 1'
            DataBinding.FieldName = 'AssetName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1088#1072#1073#1086#1090#1082#1072' '#1085#1072' '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1080' 1'
            Options.Editing = False
            Width = 70
          end
          object AssetCode_two: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1074#1099#1088'. '#1085#1072' '#1086#1073#1086#1088#1091#1076'.2)'
            DataBinding.FieldName = 'AssetCode_two'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AssetName_two: TcxGridDBColumn
            Caption = #1042#1099#1088#1072#1073#1086#1090#1082#1072' '#1085#1072' '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1080' 2'
            DataBinding.FieldName = 'AssetName_two'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1088#1072#1073#1086#1090#1082#1072' '#1085#1072' '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1080' 2'
            Options.Editing = False
            Width = 70
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PartionGoods: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object AmountOut: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1088#1072#1089#1093'.)'
            DataBinding.FieldName = 'AmountOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountOut_Weight: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1042#1077#1089' ('#1088#1072#1089#1093'.)'
            DataBinding.FieldName = 'AmountOut_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountOut_Sh: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1064#1090'. ('#1088#1072#1089#1093'.)'
            DataBinding.FieldName = 'AmountOut_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount_Send_pl: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1054#1055#1080#1059' ('#1079#1072#1090#1088#1072#1090#1099')'
            DataBinding.FieldName = 'Amount_Send_pl'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Summ_ProfitLoss: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1054#1055#1080#1059' ('#1079#1072#1090#1088#1072#1090#1099')'
            DataBinding.FieldName = 'Summ_ProfitLoss'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Summ_ProfitLoss_loss: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1054#1055#1080#1059' ('#1089#1087#1080#1089#1072#1085#1080#1077')'
            DataBinding.FieldName = 'Summ_ProfitLoss_loss'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1054#1055#1080#1059' ('#1089#1087#1080#1089#1072#1085#1080#1077', '#1079#1072#1090#1088#1072#1090#1099')'
            Width = 70
          end
          object Summ_ProfitLoss_send: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1054#1055#1080#1059' ('#1087#1077#1088#1077#1084#1077#1097')'
            DataBinding.FieldName = 'Summ_ProfitLoss_send'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1054#1055#1080#1059' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077', '#1079#1072#1090#1088#1072#1090#1099')'
            Width = 70
          end
          object Price_PriceList: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089' ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'Price_PriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_PriceList: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1072#1089#1093'. '#1087#1086' '#1087#1088#1072#1081#1089#1091' ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'SummOut_PriceList'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PriceOut_zavod: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076' ('#1088#1072#1089#1093'.)'
            DataBinding.FieldName = 'PriceOut_zavod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PriceOut_branch: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089'/'#1089' '#1092#1080#1083#1080#1072#1083' ('#1088#1072#1089#1093'.)'
            DataBinding.FieldName = 'PriceOut_branch'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_zavod: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076' ('#1088#1072#1089#1093'.)'
            DataBinding.FieldName = 'SummOut_zavod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_branch: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1092#1080#1083#1080#1072#1083' ('#1088#1072#1089#1093'.)'
            DataBinding.FieldName = 'SummOut_branch'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummOut_60000: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1087#1088'.'#1073#1091#1076'. '#1087#1077#1088#1080#1086#1076' ('#1088#1072#1089#1093'.)'
            DataBinding.FieldName = 'SummOut_60000'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountIn: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1093')'
            DataBinding.FieldName = 'AmountIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountIn_Weight: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1042#1077#1089' ('#1087#1088#1080#1093')'
            DataBinding.FieldName = 'AmountIn_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountIn_Sh: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1064#1090'. ('#1087#1088#1080#1093')'
            DataBinding.FieldName = 'AmountIn_Sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PriceIn_zavod: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076' ('#1087#1088#1080#1093')'
            DataBinding.FieldName = 'PriceIn_zavod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PriceIn_branch: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089'/'#1089' '#1092#1080#1083#1080#1072#1083' ('#1087#1088#1080#1093')'
            DataBinding.FieldName = 'PriceIn_branch'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_zavod: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076' ('#1087#1088#1080#1093')'
            DataBinding.FieldName = 'SummIn_zavod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_branch: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1092#1080#1083#1080#1072#1083' ('#1087#1088#1080#1093')'
            DataBinding.FieldName = 'SummIn_branch'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummIn_60000: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1087#1088'.'#1073#1091#1076'. '#1087#1077#1088#1080#1086#1076' ('#1087#1088#1080#1093')'
            DataBinding.FieldName = 'SummIn_60000'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object TradeMarkName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 113
          end
          object ProfitLossCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '
            DataBinding.FieldName = 'ProfitLossCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ProfitLossGroupName: TcxGridDBColumn
            Caption = #1054#1055#1080#1059' '#1075#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'ProfitLossGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object ProfitLossDirectionName: TcxGridDBColumn
            Caption = #1054#1055#1080#1059' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'ProfitLossDirectionName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object ProfitLossName: TcxGridDBColumn
            Caption = #1054#1055#1080#1059' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'ProfitLossName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object ProfitLossName_All: TcxGridDBColumn
            Caption = #1054#1055#1080#1059' '#1085#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'ProfitLossName_All'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object SubjectDocName: TcxGridDBColumn
            Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
            DataBinding.FieldName = 'SubjectDocName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 109
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object BranchCode_from: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1092'. ('#1086#1090' '#1082#1086#1075#1086')'
            DataBinding.FieldName = 'BranchCode_from'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072' '#1054#1090' '#1082#1086#1075#1086
            Options.Editing = False
            Width = 26
          end
          object BranchName_from: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083' ('#1086#1090' '#1082#1086#1075#1086')'
            DataBinding.FieldName = 'BranchName_from'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072' '#1054#1090' '#1082#1086#1075#1086
            Options.Editing = False
            Width = 61
          end
          object UnitCode_from: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087'.  ('#1086#1090' '#1082#1086#1075#1086')'
            DataBinding.FieldName = 'UnitCode_from'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072' '#1054#1090' '#1082#1086#1075#1086
            Options.Editing = False
            Width = 35
          end
          object UnitName_from: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1086#1090' '#1082#1086#1075#1086')'
            DataBinding.FieldName = 'UnitName_from'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072' '#1054#1090' '#1082#1086#1075#1086
            Options.Editing = False
            Width = 61
          end
          object PositionName_from: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1086#1090' '#1082#1086#1075#1086')'
            DataBinding.FieldName = 'PositionName_from'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072' '#1054#1090' '#1082#1086#1075#1086
            Options.Editing = False
            Width = 61
          end
          object BranchCode_to: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1092'.  ('#1082#1086#1084#1091')'
            DataBinding.FieldName = 'BranchCode_to'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072' '#1050#1086#1084#1091
            Options.Editing = False
            Width = 26
          end
          object BranchName_to: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083' ('#1082#1086#1084#1091')'
            DataBinding.FieldName = 'BranchName_to'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072' '#1050#1086#1084#1091
            Options.Editing = False
            Width = 61
          end
          object UnitCode_to: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087'. ('#1082#1086#1084#1091')'
            DataBinding.FieldName = 'UnitCode_to'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072' '#1050#1086#1084#1091
            Options.Editing = False
            Width = 35
          end
          object UnitName_to: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1082#1086#1084#1091')'
            DataBinding.FieldName = 'UnitName_to'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072' '#1050#1086#1084#1091
            Options.Editing = False
            Width = 61
          end
          object PositionName_to: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1082#1086#1084#1091')'
            DataBinding.FieldName = 'PositionName_to'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1083#1103' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072' '#1050#1086#1084#1091
            Options.Editing = False
            Width = 61
          end
          object myCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1086#1082'.'
            DataBinding.FieldName = 'myCount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
            Options.Editing = False
            Width = 55
          end
          object Date_Insert: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1086#1077#1084#1103' '#1089#1086#1079#1076#1072#1085#1080#1103
            DataBinding.FieldName = 'Date_Insert'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
      end
      object cbLocation: TcxCheckBox
        Left = 111
        Top = 7
        Caption = #1087#1086' '#1052#1077#1089#1090#1072#1084' '#1091#1095#1077#1090#1072
        Properties.ReadOnly = False
        TabOrder = 1
        Width = 118
      end
      object cbGoodsKind: TcxCheckBox
        Left = 230
        Top = 7
        Caption = #1087#1086' '#1042#1080#1076#1072#1084' '#1090#1086#1074#1072#1088#1072
        Properties.ReadOnly = False
        TabOrder = 2
        Width = 114
      end
      object cbPartionGoods: TcxCheckBox
        Left = 354
        Top = 7
        Caption = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
        Properties.ReadOnly = False
        TabOrder = 3
        Width = 88
      end
    end
  end
  inherited Panel: TPanel
    Width = 1183
    Height = 73
    ExplicitWidth = 1183
    ExplicitHeight = 73
    inherited deStart: TcxDateEdit
      Left = 121
      Properties.SaveTime = False
      ExplicitLeft = 121
    end
    inherited deEnd: TcxDateEdit
      Left = 121
      Top = 30
      Properties.SaveTime = False
      ExplicitLeft = 121
      ExplicitTop = 30
    end
    inherited cxLabel2: TcxLabel
      Left = 10
      Top = 31
      ExplicitLeft = 10
      ExplicitTop = 31
    end
    object cxLabel4: TcxLabel
      Left = 450
      Top = 9
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 540
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 196
    end
    object edInDescName: TcxTextEdit
      AlignWithMargins = True
      Left = 1049
      Top = 5
      ParentCustomHint = False
      BeepOnEnter = False
      Enabled = False
      ParentFont = False
      Properties.HideSelection = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 6
      Width = 153
    end
    object cxLabel3: TcxLabel
      Left = 226
      Top = 31
      Caption = #1050#1086#1084#1091':'
    end
    object edTo: TcxButtonEdit
      Left = 258
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 184
    end
    object cxLabel5: TcxLabel
      Left = 211
      Top = 6
      Caption = #1054#1090' '#1082#1086#1075#1086':'
    end
    object edFrom: TcxButtonEdit
      Left = 258
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 184
    end
    object cxLabel6: TcxLabel
      Left = 743
      Top = 53
      Caption = #1060#1054':'
      Visible = False
    end
    object edPaidKind: TcxButtonEdit
      Left = 768
      Top = 52
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 12
      Visible = False
      Width = 73
    end
    object cbMO_all: TcxCheckBox
      Left = 746
      Top = 32
      Caption = #1042#1057#1045' '#1052#1072#1090#1077#1088#1080#1072#1083#1100#1085#1086' '#1086#1090#1074#1077#1089#1090#1074#1077#1085#1085#1099#1077
      Properties.ReadOnly = False
      TabOrder = 13
      Width = 195
    end
    object cbComment: TcxCheckBox
      Left = 943
      Top = 32
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1087#1088#1080#1084#1077#1095#1072#1085#1080#1077
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
      ParentShowHint = False
      Properties.ReadOnly = False
      ShowHint = True
      TabOrder = 14
      Width = 89
    end
    object cbSubjectDoc: TcxCheckBox
      Left = 746
      Top = 5
      Hint = #1055#1086' '#1086#1089#1085#1086#1074#1072#1085#1080#1103#1084
      Caption = #1055#1086' '#1086#1089#1085#1086#1074#1072#1085#1080#1103#1084
      ParentShowHint = False
      Properties.ReadOnly = False
      ShowHint = True
      TabOrder = 15
      Width = 98
    end
    object cbDateDoc: TcxCheckBox
      Left = 850
      Top = 5
      Hint = #1044#1072#1090#1072' '#1076#1086#1082'-'#1090#1072' ('#1076#1072'/'#1085#1077#1090')'
      Caption = #1044#1072#1090#1072' '#1076#1086#1082'-'#1090#1072' ('#1076#1072'/'#1085#1077#1090')'
      ParentShowHint = False
      Properties.ReadOnly = False
      ShowHint = True
      TabOrder = 16
      Width = 88
    end
    object cbInvnumber: TcxCheckBox
      Left = 943
      Top = 5
      Hint = #8470' '#1076#1086#1082' '#1076#1086#1082'-'#1090#1072' ('#1076#1072'/'#1085#1077#1090')'
      Caption = #8470' '#1076#1086#1082' '#1076#1086#1082'-'#1090#1072
      ParentShowHint = False
      Properties.ReadOnly = False
      ShowHint = True
      TabOrder = 17
      Width = 99
    end
  end
  object cxLabel7: TcxLabel [2]
    Left = 474
    Top = 31
    Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090':'
  end
  object edPriceList: TcxButtonEdit [3]
    Left = 540
    Top = 32
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 196
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cbGoodsKind
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbLocation
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbMO_all
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbPartionGoods
        Properties.Strings = (
          'Checked')
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
        Component = FromGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GoodsGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = PriceListGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = ToGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_GoodsMI_InternalDialogForm'
      FormNameParam.Value = 'TReport_GoodsMI_InternalDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindId'
          Value = ''
          Component = PaidKindGuides
          ComponentItem = 'Key'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = PaidKindGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromId'
          Value = ''
          Component = FromGuides
          ComponentItem = 'Key'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = FromGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'Key'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToId'
          Value = ''
          Component = ToGuides
          ComponentItem = 'Key'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = ToGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListId'
          Value = Null
          Component = PriceListGuides
          ComponentItem = 'Key'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListName'
          Value = Null
          Component = PriceListGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isComment'
          Value = Null
          Component = cbComment
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isSubjectDoc'
          Value = Null
          Component = cbSubjectDoc
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isMO_all'
          Value = Null
          Component = cbMO_all
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDateDoc'
          Value = Null
          Component = cbDateDoc
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isInvnumber'
          Value = Null
          Component = cbInvnumber
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actPrintArticleLossGroup: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42370d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42370d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' ('#1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' ('#1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072')'
      ImageIndex = 17
      DataSets = <
        item
          UserName = 'frxDBDItems'
          IndexFieldNames = 'ArticleLossName;GoodsName;GoodsKindName;PartionGoods'
          GridView = cxGridDBTableView
        end>
      Params = <
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
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'FromName'
          Value = ''
          Component = FromGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = ToGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLocation'
          Value = False
          Component = cbLocation
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = False
          Component = cbGoodsKind
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = False
          Component = cbPartionGoods
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescName'
          Value = ''
          Component = FormParams
          ComponentItem = 'InDescName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1089#1087#1080#1089#1072#1085#1080#1077' '#1075#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1089#1087#1080#1089#1072#1085#1080#1077' '#1075#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintArticleLossPrice: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42370d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42370d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1089#1090#1072#1090#1100#1080' '#1089#1087#1080#1089#1072#1085#1080#1103') ('#1089#1091#1084#1084#1072' '#1087#1088#1072#1081#1089#1072' '#1089' '#1053#1044#1057')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1089#1090#1072#1090#1100#1080' '#1089#1087#1080#1089#1072#1085#1080#1103')'
      ImageIndex = 20
      DataSets = <
        item
          UserName = 'frxDBDItems'
          IndexFieldNames = 
            'ArticleLossName;LocationName;GoodsName;GoodsKindName;PartionGood' +
            's'
          GridView = cxGridDBTableView
        end>
      Params = <
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
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'FromName'
          Value = ''
          Component = FromGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = ToGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLocation'
          Value = False
          Component = cbLocation
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = False
          Component = cbGoodsKind
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = False
          Component = cbPartionGoods
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescName'
          Value = ''
          Component = FormParams
          ComponentItem = 'InDescName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1089#1090#1072#1090#1100#1080' '#1089#1087#1080#1089#1072#1085#1080#1103')_'#1055#1088#1072#1081#1089
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1089#1090#1072#1090#1100#1080' '#1089#1087#1080#1089#1072#1085#1080#1103')_'#1055#1088#1072#1081#1089
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintArticleLoss: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42370d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42370d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1089#1090#1072#1090#1100#1080' '#1089#1087#1080#1089#1072#1085#1080#1103')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1089#1090#1072#1090#1100#1080' '#1089#1087#1080#1089#1072#1085#1080#1103')'
      ImageIndex = 16
      DataSets = <
        item
          UserName = 'frxDBDItems'
          IndexFieldNames = 
            'ArticleLossName;LocationName;GoodsName;GoodsKindName;PartionGood' +
            's'
          GridView = cxGridDBTableView
        end>
      Params = <
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
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'FromName'
          Value = ''
          Component = FromGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = ToGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLocation'
          Value = False
          Component = cbLocation
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = False
          Component = cbGoodsKind
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = False
          Component = cbPartionGoods
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescName'
          Value = ''
          Component = FormParams
          ComponentItem = 'InDescName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1089#1090#1072#1090#1100#1080' '#1089#1087#1080#1089#1072#1085#1080#1103')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1089#1090#1072#1090#1100#1080' '#1089#1087#1080#1089#1072#1085#1080#1103')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42005d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42005d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDItems'
          IndexFieldNames = 'LocationName;GoodsName;GoodsKindName;PartionGoods'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'FromName'
          Value = ''
          Component = FromGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = '1'
          Component = ToGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLocation'
          Value = Null
          Component = cbLocation
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = Null
          Component = cbGoodsKind
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = Null
          Component = cbPartionGoods
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescName'
          Value = ''
          Component = FormParams
          ComponentItem = 'InDescName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1074#1085#1091#1090#1088#1077#1085#1085#1080#1081')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1074#1085#1091#1090#1088#1077#1085#1085#1080#1081')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintComment: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42370d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42370d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1087#1088#1080#1084#1077#1095#1072#1085#1080#1077')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1087#1088#1080#1084#1077#1095#1072#1085#1080#1077')'
      ImageIndex = 15
      DataSets = <
        item
          UserName = 'frxDBDItems'
          IndexFieldNames = 'LocationName;GoodsName;GoodsKindName;PartionGoods'
          GridView = cxGridDBTableView
        end>
      Params = <
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
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'FromName'
          Value = ''
          Component = FromGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = ToGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLocation'
          Value = False
          Component = cbLocation
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoodsKind'
          Value = False
          Component = cbGoodsKind
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionGoods'
          Value = False
          Component = cbPartionGoods
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescName'
          Value = ''
          Component = FormParams
          ComponentItem = 'InDescName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1087#1088#1080#1084#1077#1095#1072#1085#1080#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1087#1088#1080#1084#1077#1095#1072#1085#1080#1077')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actReport_Goods: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      Hint = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      ImageIndex = 26
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
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
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupId'
          Value = ''
          Component = FromGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = FromGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LocationId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LocationName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
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
          Name = 'IsPartner'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_GoodsMI_Internal'
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
        Name = 'inDescId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inDescId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = Null
        Component = FromGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = ToGuides
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
        Name = 'inPriceListId'
        Value = Null
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsMO_all'
        Value = Null
        Component = cbMO_all
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisComment'
        Value = Null
        Component = cbComment
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSubjectDoc'
        Value = Null
        Component = cbSubjectDoc
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDateDoc'
        Value = Null
        Component = cbDateDoc
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisInvnumber'
        Value = Null
        Component = cbInvnumber
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 208
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
          ItemName = 'bbLocation'
        end
        item
          Visible = True
          ItemName = 'bbGoodsKind'
        end
        item
          Visible = True
          ItemName = 'bbPartionGoods'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReport_Goods'
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
          ItemName = 'bbPrintArticleLoss'
        end
        item
          Visible = True
          ItemName = 'bbPrintArticleLossPrice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintComment'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintArticleLossGroup'
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
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbLocation: TdxBarControlContainerItem
      Caption = 'bbLocation'
      Category = 0
      Hint = 'bbLocation'
      Visible = ivAlways
      Control = cbLocation
    end
    object bbGoodsKind: TdxBarControlContainerItem
      Caption = 'bbGoodsKind'
      Category = 0
      Hint = 'bbGoodsKind'
      Visible = ivAlways
      Control = cbGoodsKind
    end
    object bbPartionGoods: TdxBarControlContainerItem
      Caption = 'bbPartionGoods'
      Category = 0
      Hint = 'bbPartionGoods'
      Visible = ivAlways
      Control = cbPartionGoods
    end
    object bbPrintArticleLoss: TdxBarButton
      Action = actPrintArticleLoss
      Category = 0
    end
    object bbPrintComment: TdxBarButton
      Action = actPrintComment
      Category = 0
    end
    object bbPrintArticleLossGroup: TdxBarButton
      Action = actPrintArticleLossGroup
      Category = 0
    end
    object bbReport_Goods: TdxBarButton
      Action = actReport_Goods
      Category = 0
    end
    object bbPrintArticleLossPrice: TdxBarButton
      Action = actPrintArticleLossPrice
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 232
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 48
    Top = 32
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = FromGuides
      end
      item
        Component = ToGuides
      end
      item
        Component = GoodsGroupGuides
      end>
    Left = 216
    Top = 208
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
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inDescId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InDescName'
        Value = ''
        Component = edInDescName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 170
  end
  object ToGuides: TdsdGuides
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
        Component = ToGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ToGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 32
  end
  object FromGuides: TdsdGuides
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
        Component = FromGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 384
    Top = 65528
  end
  object PaidKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 728
    Top = 200
  end
  object PriceListGuides: TdsdGuides
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
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 608
    Top = 24
  end
end
