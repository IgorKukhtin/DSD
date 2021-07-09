object Report_Transport_CostForm: TReport_Transport_CostForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' <'#1047#1072#1090#1088#1072#1090#1099' '#1090#1088#1072#1085#1089#1087#1086#1088#1090#1072'> ('#1088#1077#1077#1089#1090#1088')'
  ClientHeight = 395
  ClientWidth = 1362
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 115
    Width = 1362
    Height = 280
    Align = alClient
    TabOrder = 0
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumCount_Transport
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumAmount_Transport
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumAmount_TransportService
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumAmount_PersonalSendCash
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumTotal
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Distance
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = WeightTransport
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumAmount_TransportAdd
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumAmount_TransportAddLong
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumAmount_TransportTaxi
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumAmount_ServiceAdd
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumAmount_ServiceTotal
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Weight_Sale
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount_Sale
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalWeight_Sale
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Count_doc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Sum_one
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Weight_one
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Wage_kg
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Wage_Hours
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Wage_doc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalWageSumm
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalWageKg
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalSum_one
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Count_tt
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumCount_Transport
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumAmount_Transport
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumAmount_TransportService
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumAmount_PersonalSendCash
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumTotal
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Distance
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = WeightTransport
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumAmount_TransportAdd
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumAmount_TransportAddLong
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumAmount_TransportTaxi
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumAmount_ServiceAdd
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = SumAmount_ServiceTotal
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Weight_Sale
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Amount_Sale
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalWeight_Sale
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Count_doc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Sum_one
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Weight_one
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Wage_kg
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Wage_Hours
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Wage_doc
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalWageSumm
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalWageKg
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = TotalSum_one
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = Count_tt
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object BusinessName: TcxGridDBColumn
        Caption = #1041#1080#1079#1085#1077#1089
        DataBinding.FieldName = 'BusinessName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object BranchName: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083
        DataBinding.FieldName = 'BranchName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 90
      end
      object UnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'UnitName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 103
      end
      object RouteName: TcxGridDBColumn
        Caption = #1052#1072#1088#1096#1088#1091#1090
        DataBinding.FieldName = 'RouteName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 91
      end
      object OperDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1087'.'#1083'.'
        DataBinding.FieldName = 'OperDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 68
      end
      object InvNumber: TcxGridDBColumn
        Caption = #8470' '#1087'.'#1083'.'
        DataBinding.FieldName = 'InvNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 69
      end
      object PersonalDriverName: TcxGridDBColumn
        Caption = #1042#1086#1076#1080#1090#1077#1083#1100
        DataBinding.FieldName = 'PersonalDriverName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 77
      end
      object CarName: TcxGridDBColumn
        Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
        DataBinding.FieldName = 'CarName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 107
      end
      object CarModelName: TcxGridDBColumn
        Caption = #1052#1072#1088#1082'a '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
        DataBinding.FieldName = 'CarModelName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 121
      end
      object HoursWork: TcxGridDBColumn
        Caption = #1042#1088#1077#1084#1103' '#1074' '#1087#1091#1090#1080
        DataBinding.FieldName = 'HoursWork'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object Count_doc: TcxGridDBColumn
        Caption = #1050#1086#1083'. '#1076#1086#1082'. '#1074' '#1088#1077#1077#1089#1090#1088#1077
        DataBinding.FieldName = 'Count_doc'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'.'#1076#1086#1082'. '#1042' '#1088#1077#1077#1089#1090#1088#1077' '#1074#1080#1079
        Width = 70
      end
      object Count_tt: TcxGridDBColumn
        Caption = #1050#1086#1083'. '#1090#1086#1095#1077#1082' '#1074' '#1088#1077#1077#1089#1090#1088#1077
        DataBinding.FieldName = 'Count_tt'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1082#1086#1083'. '#1090#1086#1095#1077#1082' '#1087#1086' '#1087#1091#1090#1077#1074#1086#1084#1091' '#1080#1079' '#1088#1077#1077#1089#1090#1088#1072' '
        Width = 70
      end
      object TotalWeight_Sale: TcxGridDBColumn
        Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1074' '#1088#1077#1077#1089#1090#1088#1077
        DataBinding.FieldName = 'TotalWeight_Sale'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object PartnerName: TcxGridDBColumn
        Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
        DataBinding.FieldName = 'PartnerName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object Amount_Sale: TcxGridDBColumn
        Caption = #1050#1086#1083'. '#1087#1088#1086#1076'.'
        DataBinding.FieldName = 'Amount_Sale'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object Weight_Sale: TcxGridDBColumn
        Caption = #1042#1077#1089' '#1087#1088#1086#1076'.'
        DataBinding.FieldName = 'Weight_Sale'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object TotalWeight_Doc: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1085#1072#1082#1083'. '#1050#1075
        DataBinding.FieldName = 'TotalWeight_Doc'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object TotalSumm_Sale: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076'.'
        DataBinding.FieldName = 'TotalSumm_Sale'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 87
      end
      object OperDate_Sale: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1087#1088#1086#1076'.'
        DataBinding.FieldName = 'OperDate_Sale'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 98
      end
      object Invnumber_Sale: TcxGridDBColumn
        Caption = #8470' '#1087#1088#1086#1076'.'
        DataBinding.FieldName = 'Invnumber_Sale'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 98
      end
      object isAccount_50000: TcxGridDBColumn
        Caption = #1047#1072#1090#1088#1072#1090#1099' '#1074' '#1087#1088#1080#1093'.'
        DataBinding.FieldName = 'isAccount_50000'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1047#1072#1090#1088#1072#1090#1099' '#1074' '#1087#1088#1080#1093#1086#1076#1077' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' - '#1056#1072#1089#1093#1086#1076#1099' '#1073#1091#1076#1091#1097#1080#1093' '#1087#1077#1088#1080#1086#1076#1086#1074
        Options.Editing = False
        Width = 70
      end
      object MovementDescName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
        DataBinding.FieldName = 'MovementDescName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object SumAmount_Transport: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085'. ('#1087#1091#1090#1077#1074#1086#1081' '#1083'.)'
        DataBinding.FieldName = 'SumAmount_Transport'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object SumAmount_TransportAddLong: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085'. ('#1044#1072#1083#1100#1085#1086#1073#1086#1081#1085#1099#1077')'
        DataBinding.FieldName = 'SumAmount_TransportAddLong'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 90
      end
      object SumAmount_TransportTaxi: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085'. ('#1058#1072#1082#1089#1080')'
        DataBinding.FieldName = 'SumAmount_TransportTaxi'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 90
      end
      object SumAmount_TransportAdd: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085'. ('#1050#1086#1084#1072#1085#1076#1080#1088#1086#1074#1086#1095#1085#1099#1077')'
        DataBinding.FieldName = 'SumAmount_TransportAdd'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 90
      end
      object SumAmount_ServiceTotal: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1075#1088#1085'. ('#1085#1072#1077#1084' '#1080#1090#1086#1075#1086')'
        DataBinding.FieldName = 'SumAmount_ServiceTotal'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object SumCount_Transport: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086', '#1083'. ('#1087#1091#1090#1077#1074#1086#1081' '#1083'.)'
        DataBinding.FieldName = 'SumCount_Transport'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object PriceFuel: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' ('#1087#1091#1090#1077#1074#1086#1081' '#1083'.)'
        DataBinding.FieldName = 'PriceFuel'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object SumAmount_TransportService: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1075#1088#1085'. ('#1085#1072#1077#1084' '#1085#1072#1095#1080#1089#1083'.)'
        DataBinding.FieldName = 'SumAmount_TransportService'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object SumAmount_ServiceAdd: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072' '#1075#1088#1085'. ('#1085#1072#1077#1084' '#1076#1086#1087#1083'.)'
        DataBinding.FieldName = 'SumAmount_ServiceAdd'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object SumAmount_PersonalSendCash: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085'. ('#1087#1086#1076#1086#1090#1095#1077#1090')'
        DataBinding.FieldName = 'SumAmount_PersonalSendCash'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object SumTotal: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085'. ('#1048#1090#1086#1075#1086')'
        DataBinding.FieldName = 'SumTotal'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
      object ProfitLossGroupName: TcxGridDBColumn
        Caption = #1054#1055#1080#1059' '#1075#1088#1091#1087#1087#1072
        DataBinding.FieldName = 'ProfitLossGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 98
      end
      object ProfitLossDirectionName: TcxGridDBColumn
        Caption = #1054#1055#1080#1059' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'ProfitLossDirectionName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 98
      end
      object ProfitLossName: TcxGridDBColumn
        Caption = #1054#1055#1080#1059' '#1089#1090#1072#1090#1100#1103
        DataBinding.FieldName = 'ProfitLossName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 98
      end
      object ProfitLossName_all: TcxGridDBColumn
        Caption = #1087#1088#1080#1084'. '#1054#1055#1080#1059' '#1085#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'ProfitLossName_all'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 98
      end
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 98
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 98
      end
      object GoodsKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsKindName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 82
      end
      object Distance: TcxGridDBColumn
        Caption = #1050'-'#1074#1086', '#1082#1084
        DataBinding.FieldName = 'Distance'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object One_KM: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' 1 '#1082#1084
        DataBinding.FieldName = 'One_KM'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 50
      end
      object One_KG: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' 1 '#1082#1075
        DataBinding.FieldName = 'One_KG'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 50
      end
      object WeightTransport: TcxGridDBColumn
        Caption = #1042#1077#1089' ('#1087#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090')'
        DataBinding.FieldName = 'WeightTransport'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object Sum_one: TcxGridDBColumn
        Caption = #1048#1090#1086#1075#1086' '#1088#1072#1089#1093#1086#1076#1099' '#1085#1072' '#1090#1086#1095#1082#1091' '#1075#1088#1085' ('#1056#1072#1089#1093#1086#1076#1099' '#1085#1072' '#1043#1057#1052')'
        DataBinding.FieldName = 'Sum_one'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 77
      end
      object Weight_one: TcxGridDBColumn
        Caption = #1048#1090#1086#1075#1086' '#1088#1072#1089#1093#1086#1076#1099' '#1085#1072' '#1082#1075' ('#1056#1072#1089#1093#1086#1076#1099' '#1085#1072' '#1043#1057#1052')'
        DataBinding.FieldName = 'Weight_one'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object Wage_kg: TcxGridDBColumn
        Caption = #1047#1072' '#1074#1077#1089' '#1075#1088#1085'/'#1082#1075' (0.05) ('#1056#1072#1089#1093#1086#1076#1099' '#1047#1055' '#1074#1086#1076#1080#1090#1077#1083#1077#1081')'
        DataBinding.FieldName = 'Wage_kg'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 82
      end
      object Wage_Hours: TcxGridDBColumn
        Caption = #1047#1072' '#1074#1088#1077#1084#1103' '#1075#1088#1085'/'#1095#1072#1089' (60) ('#1056#1072#1089#1093#1086#1076#1099' '#1047#1055' '#1074#1086#1076#1080#1090#1077#1083#1077#1081')'
        DataBinding.FieldName = 'Wage_Hours'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 90
      end
      object Wage_doc: TcxGridDBColumn
        Caption = #1047#1072' '#1090#1086#1095#1082#1091' '#1076#1086#1089#1090#1072#1074#1082#1080' '#1075#1088#1085' (5) ('#1056#1072#1089#1093#1086#1076#1099' '#1047#1055' '#1074#1086#1076#1080#1090#1077#1083#1077#1081')'
        DataBinding.FieldName = 'Wage_doc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 87
      end
      object TotalWageSumm: TcxGridDBColumn
        Caption = #1048#1090#1086#1075#1086' '#1088#1072#1089#1093#1086#1076#1099' '#1085#1072' '#1090#1086#1095#1082#1091' '#1075#1088#1085' ('#1056#1072#1089#1093#1086#1076#1099' '#1047#1055' '#1074#1086#1076#1080#1090#1077#1083#1077#1081')'
        DataBinding.FieldName = 'TotalWageSumm'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 95
      end
      object TotalWageKg: TcxGridDBColumn
        Caption = #1048#1090#1086#1075#1086' '#1088#1072#1089#1093#1086#1076#1099' '#1085#1072' '#1082#1075' ('#1056#1072#1089#1093#1086#1076#1099' '#1047#1055' '#1074#1086#1076#1080#1090#1077#1083#1077#1081')'
        DataBinding.FieldName = 'TotalWageKg'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 85
      end
      object TotalSum_one: TcxGridDBColumn
        Caption = #1048#1090#1086#1075#1086' '#1088#1072#1089#1093#1086#1076#1099' '#1085#1072' '#1090#1086#1095#1082#1091' '#1075#1088#1085' ('#1043#1057#1052'+'#1047#1055')'
        DataBinding.FieldName = 'TotalSum_one'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object TotalSum_kg: TcxGridDBColumn
        Caption = #1048#1090#1086#1075#1086' '#1088#1072#1089#1093#1086#1076#1099' '#1085#1072' '#1082#1075' ('#1043#1057#1052'+'#1047#1055')'
        DataBinding.FieldName = 'TotalSum_kg'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object SummByPrint: TcxGridDBColumn
        DataBinding.FieldName = 'SummByPrint'
        Visible = False
        VisibleForCustomization = False
        Width = 50
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1362
    Height = 89
    Align = alTop
    TabOrder = 2
    object deStart: TcxDateEdit
      Left = 122
      Top = 7
      EditValue = 42005d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 122
      Top = 45
      EditValue = 42005d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 25
      Top = 8
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel2: TcxLabel
      Left = 10
      Top = 46
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel5: TcxLabel
      Left = 215
      Top = 46
      Caption = #1060#1080#1083#1080#1072#1083':'
    end
    object edBranch: TcxButtonEdit
      Left = 262
      Top = 45
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 195
    end
    object cbPartner: TcxCheckBox
      Left = 795
      Top = 42
      Caption = #1055#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084
      Properties.ReadOnly = False
      TabOrder = 6
      Width = 110
    end
    object cbGoods: TcxCheckBox
      Left = 924
      Top = 42
      Caption = #1055#1086' '#1090#1086#1074#1072#1088#1072#1084
      Properties.ReadOnly = False
      TabOrder = 7
      Width = 90
    end
  end
  object cxLabel3: TcxLabel
    Left = 219
    Top = 8
    Caption = #1041#1080#1079#1085#1077#1089':'
  end
  object edBusiness: TcxButtonEdit
    Left = 262
    Top = 7
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 195
  end
  object cxLabel4: TcxLabel
    Left = 467
    Top = 8
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object edUnit: TcxButtonEdit
    Left = 557
    Top = 7
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 220
  end
  object cxLabel6: TcxLabel
    Left = 483
    Top = 46
    Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100' :'
  end
  object edCar: TcxButtonEdit
    Left = 557
    Top = 45
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 220
  end
  object cbMovement: TcxCheckBox
    Left = 795
    Top = 7
    Caption = #1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
    Properties.ReadOnly = False
    TabOrder = 12
    Width = 158
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 104
    Top = 200
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 64
    Top = 256
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = BranchGuides
        Properties.Strings = (
          'Key'
          'TextValue')
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
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 304
    Top = 232
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 32
    Top = 200
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 2
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbDialogForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbToExcel'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object dxBarStatic1: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object bbToExcel: TdxBarButton
      Action = actExportToExcel
      Category = 0
    end
    object bbDialogForm: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 240
    Top = 224
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actExportToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Transport_CostDialogForm'
      FormNameParam.Value = 'TReport_Transport_CostDialogForm'
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
          Name = 'BranchId'
          Value = ''
          Component = BranchGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName'
          Value = ''
          Component = BranchGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BusinessId'
          Value = Null
          Component = BusinessGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BusinessName'
          Value = Null
          Component = BusinessGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = UnitGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = UnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CarId'
          Value = Null
          Component = CarGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CarName'
          Value = Null
          Component = CarGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisMovement'
          Value = Null
          Component = cbMovement
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartner'
          Value = Null
          Component = cbPartner
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoods'
          Value = Null
          Component = cbGoods
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
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDataset'
          IndexFieldNames = 'RouteName;PartnerName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1047#1072#1090#1088#1072#1090#1099' '#1090#1088#1072#1085#1089#1087#1086#1088#1090#1072' ('#1088#1077#1077#1089#1090#1088')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1047#1072#1090#1088#1072#1090#1099' '#1090#1088#1072#1085#1089#1087#1086#1088#1090#1072' ('#1088#1077#1077#1089#1090#1088')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpReport_Transport_Cost'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
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
        Name = 'inBusinessId'
        Value = Null
        Component = BusinessGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCarId'
        Value = 0
        Component = CarGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsMovement'
        Value = Null
        Component = cbMovement
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartner'
        Value = Null
        Component = cbPartner
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoods'
        Value = Null
        Component = cbGoods
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 152
    Top = 248
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
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
    Left = 304
    Top = 296
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 440
    Top = 240
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 96
    Top = 16
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = deStart
      end
      item
        Component = deEnd
      end
      item
        Component = BranchGuides
      end
      item
        Component = BusinessGuides
      end
      item
        Component = UnitGuides
      end
      item
        Component = CarGuides
      end
      item
        Component = cbMovement
      end>
    Left = 168
    Top = 200
  end
  object BranchGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    FormNameParam.Value = 'TBranchForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBranchForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 352
    Top = 27
  end
  object BusinessGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBusiness
    FormNameParam.Value = 'TBusiness_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBusiness_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BusinessGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 312
    Top = 65535
  end
  object CarGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCar
    FormNameParam.Value = 'TCarForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCarForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = CarGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CarGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 671
    Top = 38
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
    Left = 591
    Top = 6
  end
end
