inherited Report_MovementCheck_UnLiquidForm: TReport_MovementCheck_UnLiquidForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1053#1077#1083#1080#1082#1074#1080#1076#1085#1086#1084#1091' '#1090#1086#1074#1072#1088#1091
  ClientHeight = 480
  ClientWidth = 941
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 957
  ExplicitHeight = 518
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 58
    Width = 941
    Height = 422
    TabOrder = 3
    ExplicitTop = 58
    ExplicitWidth = 941
    ExplicitHeight = 422
    ClientRectBottom = 422
    ClientRectRight = 941
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 941
      ExplicitHeight = 422
      inherited cxGrid: TcxGrid
        Width = 941
        Height = 200
        ExplicitWidth = 941
        ExplicitHeight = 200
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa_Sale
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
              Column = RemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sale1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa_Sale1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sale3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa_Sale3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sale6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa_Sale6
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
              Column = Summa_Remains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa_RemainsEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsMCS_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Send
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Reserve
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa_Sale
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
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
              Column = RemainsStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sale1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa_Sale1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sale3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa_Sale3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Sale6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa_Sale6
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
              Column = Summa_Remains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summa_RemainsEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsMCS_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Send
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Reserve
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object isSaleAnother: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072' '#1085#1072' '#1076#1088'. '#1072#1087#1090#1077#1082#1072#1093
            DataBinding.FieldName = 'isSaleAnother'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 62
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsId: TcxGridDBColumn
            Caption = #1048#1044' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsId'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 27
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 151
          end
          object NDS: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object MinExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1086#1089#1090#1072#1090#1082#1072
            DataBinding.FieldName = 'MinExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object OperDate_LastIncome: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1086#1089#1083#1077#1076#1085#1077#1075#1086' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'OperDate_LastIncome'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1087#1086#1089#1083#1077#1076#1085#1077#1075#1086' '#1087#1088#1080#1093#1086#1076#1072
            Options.Editing = False
            Width = 80
          end
          object Amount_LastIncome: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1089#1083#1077#1076#1085#1077#1075#1086' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'Amount_LastIncome'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1086#1089#1083#1077#1076#1085#1077#1075#1086' '#1087#1088#1080#1093#1086#1076#1072
            Width = 80
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
          object Amount_Send: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1088#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'Amount_Send'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
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
          object RemainsStart: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1085#1072#1095'. '#1076#1072#1090#1091
            DataBinding.FieldName = 'RemainsStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1090#1086#1095#1082#1077' '#1085#1072' '#1085#1072#1095'. '#1076#1072#1090#1091
            Width = 55
          end
          object Price_Remains: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1085#1072#1095'. '#1086#1089#1090#1072#1090#1082#1072
            DataBinding.FieldName = 'Price_Remains'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1085#1077#1083#1080#1082#1074#1080#1076#1085#1086#1075#1086' '#1085#1072#1095'. '#1086#1089#1090#1072#1090#1082#1072
            Width = 60
          end
          object Summa_Remains: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1085#1072#1095'. '#1086#1089#1090#1072#1090#1082#1072
            DataBinding.FieldName = 'Summa_Remains'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1085#1077#1083#1080#1082#1074#1080#1076#1085#1086#1075#1086' '#1085#1072#1095'. '#1086#1089#1090#1072#1090#1082#1072
            Width = 60
          end
          object RemainsEnd: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1082#1086#1085'. '#1076#1072#1090#1091
            DataBinding.FieldName = 'RemainsEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1090#1086#1095#1082#1077' '#1085#1072' '#1082#1086#1085'. '#1076#1072#1090#1091
            Width = 55
          end
          object Price_RemainsEnd: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1082#1086#1085'. '#1086#1089#1090#1072#1090#1082#1072
            DataBinding.FieldName = 'Price_RemainsEnd'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1085#1077#1083#1080#1082#1074#1080#1076#1085#1086#1075#1086' '#1082#1086#1085'. '#1086#1089#1090#1072#1090#1082#1072
            Width = 60
          end
          object Summa_RemainsEnd: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1082#1086#1085'. '#1086#1089#1090#1072#1090#1082#1072
            DataBinding.FieldName = 'Summa_RemainsEnd'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1085#1077#1083#1080#1082#1074#1080#1076#1085#1086#1075#1086' '#1082#1086#1085'. '#1086#1089#1090#1072#1090#1082#1072
            Width = 60
          end
          object Price_Sale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'Price_Sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object Amount_Sale: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'Amount_Sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object Summa_Sale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'Summa_Sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object Amount_Sale1: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' 1-'#1099#1081' '#1084#1077#1089'.'
            DataBinding.FieldName = 'Amount_Sale1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object Summa_Sale1: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' 1-'#1099#1081' '#1084#1077#1089'.'
            DataBinding.FieldName = 'Summa_Sale1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object Amount_Sale3: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' 3 '#1084#1077#1089'.'
            DataBinding.FieldName = 'Amount_Sale3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object Summa_Sale3: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' 3 '#1084#1077#1089'.'
            DataBinding.FieldName = 'Summa_Sale3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object Amount_Sale6: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' 6 '#1084#1077#1089'.'
            DataBinding.FieldName = 'Amount_Sale6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object Summa_Sale6: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' 6 '#1084#1077#1089'.'
            DataBinding.FieldName = 'Summa_Sale6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 208
        Width = 941
        Height = 214
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
              Column = chAmount_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_Sale6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSumma_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_Sale1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSumma_Sale1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_Sale3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSumma_Sale3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSumma_Sale6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemainsMCS_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_Send
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemainsEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_Reserve
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_Sale6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSumma_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_Sale1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSumma_Sale1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_Sale3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSumma_Sale3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chSumma_Sale6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemainsMCS_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_Send
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemainsEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_Reserve
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
          OptionsData.Editing = False
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
            Width = 231
          end
          object chRemainsEnd: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1082#1086#1085'. '#1076#1072#1090#1091
            DataBinding.FieldName = 'RemainsEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1090#1086#1095#1082#1077' '#1085#1072' '#1082#1086#1085'. '#1076#1072#1090#1091
            Width = 55
          end
          object chAmount_Send: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'Amount_Send'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
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
          object chRemainsMCS_result: TcxGridDBColumn
            Caption = #1048#1058#1054#1043#1054' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'RemainsMCS_result'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chAmount_Sale: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'Amount_Sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object chSumma_Sale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'Summa_Sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object chAmount_Sale1: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' 1-'#1099#1081' '#1084#1077#1089'.'
            DataBinding.FieldName = 'Amount_Sale1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object chSumma_Sale1: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' 1-'#1099#1081' '#1084#1077#1089'.'
            DataBinding.FieldName = 'Summa_Sale1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object chAmount_Sale3: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' 3 '#1084#1077#1089'.'
            DataBinding.FieldName = 'Amount_Sale3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object chSumma_Sale3: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' 3 '#1084#1077#1089'.'
            DataBinding.FieldName = 'Summa_Sale3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object chAmount_Sale6: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' 6 '#1084#1077#1089'.'
            DataBinding.FieldName = 'Amount_Sale6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object chSumma_Sale6: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079'. '#1079#1072' 6 '#1084#1077#1089'.'
            DataBinding.FieldName = 'Summa_Sale6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 200
        Width = 941
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = cxGrid1
      end
    end
  end
  inherited Panel: TPanel
    Width = 941
    Height = 32
    ExplicitWidth = 941
    ExplicitHeight = 32
    inherited deStart: TcxDateEdit
      Left = 29
      EditValue = 43101d
      ExplicitLeft = 29
    end
    inherited deEnd: TcxDateEdit
      Left = 142
      EditValue = 43101d
      ExplicitLeft = 142
    end
    inherited cxLabel1: TcxLabel
      Caption = #1057':'
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 120
      Caption = #1087#1086':'
      ExplicitLeft = 120
      ExplicitWidth = 20
    end
    object cxLabel3: TcxLabel
      Left = 234
      Top = 5
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object ceUnit: TcxButtonEdit
      Left = 325
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 5
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Width = 188
    end
    object cbList: TcxCheckBox
      Left = 537
      Top = 5
      Action = actRefreshList
      TabOrder = 6
      Width = 137
    end
    object cbReserve: TcxCheckBox
      Left = 680
      Top = 5
      Action = actRefreshReserve
      TabOrder = 7
      Width = 249
    end
  end
  inherited ActionList: TActionList
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshJuridical: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      Hint = #1087#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
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
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1072#1088#1090#1080#1080' '#1094#1077#1085#1099
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
      Caption = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1081' '#1090#1086#1074#1072#1088' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1059#1095#1080#1090#1099#1074#1072#1090#1100' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1081' '#1090#1086#1074#1072#1088' ('#1044#1072'/'#1053#1077#1090')'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_MovementCheck_UnLiquidDialogForm'
      FormNameParam.Value = 'TReport_MovementCheck_UnLiquidDialogForm'
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
          Name = 'isList'
          Value = Null
          Component = cbList
          DataType = ftBoolean
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
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'JuridicalName;GoodsName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actReportUnLiquid_mov: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spReportUnLiquid_mov
      StoredProcList = <
        item
          StoredProc = spReportUnLiquid_mov
        end>
      Caption = 'actReportUnLiquid_mov'
      ImageIndex = 43
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
      Caption = 'actSend'
      ImageIndex = 41
    end
    object macReportUnLiquid_mov: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actReportUnLiquid_mov
        end>
      DataSource = MasterDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1086' '#1086#1090#1095#1077#1090#1091'? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1054#1090#1095#1077#1090' '#1087#1086' '#1085#1077#1083#1080#1082#1074#1080#1076#1085#1086#1084#1091' '#1090#1086#1074#1072#1088#1091'> '#1089#1086#1079#1076#1072#1085
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1086#1090#1095#1077#1090#1072' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1086#1090#1095#1077#1090#1072' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 43
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
    object actRefreshList: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1058#1054#1051#1068#1050#1054' '#1055#1054' '#1057#1055#1048#1057#1050#1059
      Hint = #1058#1054#1051#1068#1050#1054' '#1055#1054' '#1057#1055#1048#1057#1050#1059
      ShortCut = 116
      RefreshOnTabSetChanges = False
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
    StoredProcName = 'gpReport_Movement_Check_UnLiquid'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ChildCDS
      end
      item
        DataSet = DataSetDocs
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
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
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisUnitList'
        Value = Null
        Component = cbList
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
      end>
    Left = 80
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Top = 160
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
          ItemName = 'bbmacSend'
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
          ItemName = 'bbReportUnLiquid_mov'
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
    object dxBarButton1: TdxBarButton
      Caption = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Category = 0
      Hint = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Visible = ivAlways
      ImageIndex = 38
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbmacSend: TdxBarButton
      Action = macSend
      Category = 0
    end
    object bbReportUnLiquid_mov: TdxBarButton
      Action = macReportUnLiquid_mov
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 232
    Top = 176
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 432
    Top = 32
  end
  object rdUnit: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesUnit
      end>
    Left = 328
    Top = 144
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
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
    Left = 328
    Top = 32
  end
  object spGet_UserUnit: TdsdStoredProc
    StoredProcName = 'gpGet_UserUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 592
    Top = 32
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 608
    Top = 384
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'GoodsMainId'
    MasterFields = 'GoodsMainId'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 528
    Top = 384
  end
  object DataSourceDocs: TDataSource
    DataSet = DataSetDocs
    Left = 184
    Top = 384
  end
  object DataSetDocs: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 128
    Top = 368
  end
  object spSend: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Send_byUnLiquid'
    DataSets = <
      item
      end>
    OutputType = otMultiExecute
    Params = <
      item
        Name = 'inStartSale'
        Value = 'NULL'
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndSale'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
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
        Component = DataSetDocs
        ComponentItem = 'UnitId'
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
        ComponentItem = 'PriceTo'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCSPeriod'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCSDay'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1000
    Left = 48
    Top = 360
  end
  object spReportUnLiquid_mov: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ReportUnLiquid_Auto'
    DataSets = <
      item
      end>
    OutputType = otMultiExecute
    Params = <
      item
        Name = 'inStartSale'
        Value = 'NULL'
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndSale'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
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
        ComponentItem = 'Amount_Sale'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRemainsStart'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RemainsStart'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRemainsEnd'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RemainsEnd'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountM1'
        Value = 0.000000000000000000
        Component = MasterCDS
        ComponentItem = 'Amount_Sale1'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountM3'
        Value = 0.000000000000000000
        Component = MasterCDS
        ComponentItem = 'Amount_Sale3'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountM6'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount_Sale6'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountIncome'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount_LastIncome'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summa_Sale'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummStart'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summa_Remains'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummEnd'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summa_RemainsEnd'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummM1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summa_Sale1'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummM3'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summa_Sale3'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummM6'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summa_Sale6'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateIncome'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'OperDate_LastIncome'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinExpirationDate'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'MinExpirationDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 500
    Left = 296
    Top = 360
  end
end
