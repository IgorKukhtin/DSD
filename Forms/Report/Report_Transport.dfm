object Report_TransportForm: TReport_TransportForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1091#1090#1077#1074#1099#1084' '#1083#1080#1089#1090#1072#1084
  ClientHeight = 395
  ClientWidth = 1336
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
    Top = 57
    Width = 1336
    Height = 338
    Align = alClient
    TabOrder = 0
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Position = spFooter
        end
        item
          Format = ',0.00'
          Position = spFooter
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = DistanceFuel
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = AmountFuel_In
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = AmountFuel_Out
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = ColdHour
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = ColdDistance
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Amount_Distance_calc
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Amount_ColdHour_calc
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Amount_ColdDistance_calc
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = WeightTransport
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Weight
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SumTransportAdd
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SumTransportAddLong
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SumTransportTaxi
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = CountDoc_Reestr
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = TotalCountKg_Reestr
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SumRateExp
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = TotalCountKg_Reestr_zp
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = HoursWork
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = HoursStop
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = HoursMove
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = PartnerCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = HoursPartner_all
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = CountDoc_Reestr_zp
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
        end
        item
          Format = ',0.00'
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = DistanceFuel
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = AmountFuel_In
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = AmountFuel_Out
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = ColdHour
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = ColdDistance
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Amount_Distance_calc
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Amount_ColdHour_calc
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Amount_ColdDistance_calc
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = WeightTransport
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = Weight
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SumTransportAdd
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SumTransportAddLong
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SumTransportTaxi
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = CountDoc_Reestr
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = TotalCountKg_Reestr
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = SumRateExp
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = TotalCountKg_Reestr_zp
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = HoursWork
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = HoursStop
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = HoursMove
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = PartnerCount
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = HoursPartner_all
        end
        item
          Format = ',0.##'
          Kind = skSum
          Column = CountDoc_Reestr_zp
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
      object OperDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072
        DataBinding.FieldName = 'OperDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 46
      end
      object OperDate_Month: TcxGridDBColumn
        Caption = #1052#1077#1089#1103#1094
        DataBinding.FieldName = 'OperDate'
        PropertiesClassName = 'TcxDateEditProperties'
        Properties.DisplayFormat = 'MMMM YYYY'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 67
      end
      object InvNumberTransport: TcxGridDBColumn
        Caption = #8470
        DataBinding.FieldName = 'InvNumberTransport'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 37
      end
      object FuelName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1087#1083#1080#1074#1072
        DataBinding.FieldName = 'FuelName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 58
      end
      object CarModelName: TcxGridDBColumn
        Caption = #1052#1072#1088#1082'a '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
        DataBinding.FieldName = 'CarModelName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 78
      end
      object CarName: TcxGridDBColumn
        Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
        DataBinding.FieldName = 'CarName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 78
      end
      object BranchName: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083' ('#1040#1074#1090#1086')'
        DataBinding.FieldName = 'BranchName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 53
      end
      object UnitName_car: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1040#1074#1090#1086')'
        DataBinding.FieldName = 'UnitName_car'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object PersonalDriverName: TcxGridDBColumn
        Caption = #1042#1086#1076#1080#1090#1077#1083#1100'/ '#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088
        DataBinding.FieldName = 'PersonalDriverName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 75
      end
      object PositionName: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1074#1086#1076#1080#1090#1077#1083#1100')'
        DataBinding.FieldName = 'PositionName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object PositionLevelName: TcxGridDBColumn
        Caption = #1056#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080' ('#1074#1086#1076#1080#1090#1077#1083#1100')'
        DataBinding.FieldName = 'PositionLevelName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PersonalServiceListName_find: TcxGridDBColumn
        Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100
        DataBinding.FieldName = 'PersonalServiceListName_find'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object RouteName: TcxGridDBColumn
        Caption = #1052#1072#1088#1096#1088#1091#1090
        DataBinding.FieldName = 'RouteName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 58
      end
      object RouteKindName: TcxGridDBColumn
        Caption = #1058#1080#1087' '#1084#1072#1088#1096#1088#1091#1090#1072
        DataBinding.FieldName = 'RouteKindName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object RouteName_order: TcxGridDBColumn
        Caption = #1052#1072#1088#1096#1088#1091#1090' ('#1079#1072#1103#1074#1082#1072')'
        DataBinding.FieldName = 'RouteName_order'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object UnitName_route: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1052#1072#1088#1096#1088#1091#1090')'
        DataBinding.FieldName = 'UnitName_route'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object Weight: TcxGridDBColumn
        Caption = #1042#1077#1089' '#1075#1088#1091#1079#1072', '#1082#1075' ('#1088#1072#1079#1075#1088#1091#1079#1082#1072')'
        DataBinding.FieldName = 'Weight'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object WeightTransport: TcxGridDBColumn
        Caption = #1042#1077#1089' '#1075#1088#1091#1079#1072', '#1082#1075' ('#1087#1077#1088#1077#1074#1077#1079#1077#1085#1086')'
        DataBinding.FieldName = 'WeightTransport'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object SumTransportAdd: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085'. ('#1050#1086#1084#1072#1085#1076#1080#1088#1086#1074#1086#1095#1085#1099#1077')'
        DataBinding.FieldName = 'SumTransportAdd'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object SumTransportAddLong: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085'. ('#1044#1072#1083#1100#1085#1086#1073#1086#1081#1085#1099#1077')'
        DataBinding.FieldName = 'SumTransportAddLong'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object SumTransportTaxi: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085'. ('#1058#1072#1082#1089#1080')'
        DataBinding.FieldName = 'SumTransportTaxi'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object SumRateExp: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085'. ('#1069#1082#1089#1087'. '#1050#1086#1084#1072#1085#1076'.)'
        DataBinding.FieldName = 'SumRateExp'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1057#1091#1084#1084#1072', '#1075#1088#1085'. ('#1069#1082#1089#1087#1077#1076#1080#1090#1086#1088' '#1050#1086#1084#1072#1085#1076#1080#1088#1086#1074#1086#1095#1085#1099#1077')'
        Width = 60
      end
      object StartOdometre: TcxGridDBColumn
        Caption = #1053#1072#1095'. '#1087#1086#1082#1072#1079'.'#1082#1084
        DataBinding.FieldName = 'StartOdometre'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 58
      end
      object EndOdometre: TcxGridDBColumn
        Caption = #1050#1086#1085#1077#1095'. '#1087#1086#1082#1072#1079'.'#1082#1084
        DataBinding.FieldName = 'EndOdometre'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 57
      end
      object DistanceFuel: TcxGridDBColumn
        Caption = #1055#1088#1086#1073#1077#1075', '#1082#1084
        DataBinding.FieldName = 'DistanceFuel'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 49
      end
      object AmountFuel_Start: TcxGridDBColumn
        Caption = #1053#1072#1095'. '#1086#1089#1090', '#1083'.'
        DataBinding.FieldName = 'AmountFuel_Start'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object AmountFuel_In: TcxGridDBColumn
        Caption = #1047#1072#1087#1088#1072#1074#1082#1072', '#1083'.'
        DataBinding.FieldName = 'AmountFuel_In'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object AmountFuel_Out: TcxGridDBColumn
        Caption = #1056#1072#1089#1093#1086#1076', '#1083'.'
        DataBinding.FieldName = 'AmountFuel_Out'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object AmountFuel_End: TcxGridDBColumn
        Caption = #1050#1086#1085#1077#1095'. '#1086#1089#1090'., '#1083'.'
        DataBinding.FieldName = 'AmountFuel_End'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 46
      end
      object ColdHour: TcxGridDBColumn
        Caption = #1063#1072#1089#1086#1074' '#1092#1072#1082#1090', '#1093#1086#1083#1086#1076
        DataBinding.FieldName = 'ColdHour'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 58
      end
      object ColdDistance: TcxGridDBColumn
        Caption = #1050#1084'. '#1092#1072#1082#1090', '#1093#1086#1083#1086#1076
        DataBinding.FieldName = 'ColdDistance'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 59
      end
      object RateFuelKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1085#1086#1088#1084#1099
        DataBinding.FieldName = 'RateFuelKindName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object RateFuelKindTax: TcxGridDBColumn
        Caption = '% '#1089#1077#1079#1086#1085', '#1090#1077#1084#1087'.'
        DataBinding.FieldName = 'RateFuelKindTax'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object AmountFuel: TcxGridDBColumn
        Caption = #1053#1086#1088#1084#1072' '#1085#1072' 100 '#1082#1084
        DataBinding.FieldName = 'AmountFuel'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 39
      end
      object AmountColdHour: TcxGridDBColumn
        Caption = #1053#1086#1088#1084#1072' '#1085#1072' '#1093#1086#1083#1086#1076', '#1074' '#1095#1072#1089
        DataBinding.FieldName = 'AmountColdHour'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object AmountColdDistance: TcxGridDBColumn
        Caption = #1053#1086#1088#1084#1072' '#1085#1072' '#1093#1086#1083#1086#1076', '#1079#1072' 100 '#1082#1084
        DataBinding.FieldName = 'AmountColdDistance'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object Amount_Distance_calc: TcxGridDBColumn
        Caption = #1056#1072#1089#1095#1077#1090' '#1085#1072' '#1087#1088#1086#1073#1077#1075
        DataBinding.FieldName = 'Amount_Distance_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 57
      end
      object Amount_ColdHour_calc: TcxGridDBColumn
        Caption = #1056#1072#1089#1095#1077#1090' '#1085#1072' '#1093#1086#1083#1086#1076' '#1095'.'
        DataBinding.FieldName = 'Amount_ColdHour_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 57
      end
      object Amount_ColdDistance_calc: TcxGridDBColumn
        Caption = #1056#1072#1089#1095#1077#1090' '#1085#1072' '#1093#1086#1083#1086#1076' '#1082#1084'.'
        DataBinding.FieldName = 'Amount_ColdDistance_calc'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 58
      end
      object CountDoc_Reestr: TcxGridDBColumn
        Caption = #1050#1086#1083'.'#1076#1086#1082'. ('#1074' '#1088#1077#1077#1089#1090#1088#1077' '#1074#1080#1079')'
        DataBinding.FieldName = 'CountDoc_Reestr'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'. '#1076#1086#1082'. ('#1074' '#1088#1077#1077#1089#1090#1088#1077' '#1074#1080#1079')'
        Options.Editing = False
        Width = 70
      end
      object CountDoc_Reestr_zp: TcxGridDBColumn
        Caption = ' '#1050#1086#1083'.'#1076#1086#1082'. '#1076#1083#1103' '#1047#1055' ('#1074' '#1088#1077#1077#1089#1090#1088#1077' '#1074#1080#1079')'
        DataBinding.FieldName = 'CountDoc_Reestr_zp'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083'. '#1076#1086#1082'. ('#1074' '#1088#1077#1077#1089#1090#1088#1077' '#1074#1080#1079')'
        Options.Editing = False
        Width = 70
      end
      object TotalCountKg_Reestr: TcxGridDBColumn
        Caption = #1048#1090#1086#1075#1086' '#1042#1077#1089' ('#1074' '#1088#1077#1077#1089#1090#1088#1077' '#1074#1080#1079')'
        DataBinding.FieldName = 'TotalCountKg_Reestr'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1077#1089' ('#1074' '#1088#1077#1077#1089#1090#1088#1077' '#1074#1080#1079')'
        Options.Editing = False
        Width = 76
      end
      object TotalCountKg_Reestr_zp: TcxGridDBColumn
        Caption = #1048#1090#1086#1075#1086' '#1076#1083#1103' '#1047#1055' '#1042#1077#1089' ('#1074' '#1088#1077#1077#1089#1090#1088#1077' '#1074#1080#1079')'
        DataBinding.FieldName = 'TotalCountKg_Reestr_zp'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1042#1077#1089' '#1076#1083#1103' '#1047#1055' ('#1074' '#1088#1077#1077#1089#1090#1088#1077' '#1074#1080#1079')'
        Width = 76
      end
      object InvNumber_Reestr: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1082' ('#1088#1077#1077#1089#1090#1088')'
        DataBinding.FieldName = 'InvNumber_Reestr'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PartnerCount: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1058#1058
        DataBinding.FieldName = 'PartnerCount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 54
      end
      object HoursWork: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1095#1072#1089#1086#1074
        DataBinding.FieldName = 'HoursWork'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object HoursStop: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1095#1072#1089#1086#1074' '#1087#1088#1086#1089#1090#1086#1103
        DataBinding.FieldName = 'HoursStop'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Properties.ReadOnly = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object HoursMove: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1095#1072#1089#1086#1074' '#1076#1074#1080#1078#1077#1085#1080#1103
        DataBinding.FieldName = 'HoursMove'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        Properties.ReadOnly = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 53
      end
      object HoursPartner_all: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1095#1072#1089#1086#1074' '#1074' '#1090#1086#1095#1082#1072#1093
        DataBinding.FieldName = 'HoursPartner_all'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object HoursPartner: TcxGridDBColumn
        Caption = #1050#1086#1083'-'#1074#1086' '#1095#1072#1089#1086#1074' (1 '#1058#1086#1095#1082#1072')'
        DataBinding.FieldName = 'HoursPartner'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 55
      end
      object Speed: TcxGridDBColumn
        Caption = #1057#1082#1086#1088#1086#1089#1090#1100' '#1076#1074#1080#1078#1077#1085#1080#1103' '#1074' '#1087#1091#1090#1080
        DataBinding.FieldName = 'Speed'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        Properties.ReadOnly = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 64
      end
      object CommentStop: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1087#1088#1080#1095#1080#1085#1072' '#1087#1088#1086#1089#1090#1086#1103')'
        DataBinding.FieldName = 'CommentStop'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 26
    Width = 1336
    Height = 31
    Align = alTop
    TabOrder = 5
    object deStart: TcxDateEdit
      Left = 101
      Top = 5
      EditValue = 42370d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 310
      Top = 5
      EditValue = 42370d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 10
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel2: TcxLabel
      Left = 200
      Top = 6
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel5: TcxLabel
      Left = 507
      Top = 7
      Caption = #1060#1080#1083#1080#1072#1083':'
    end
    object edBranch: TcxButtonEdit
      Left = 557
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 174
    end
    object cbIsMonth: TcxCheckBox
      Left = 408
      Top = 4
      Action = actRefreshMonth
      Properties.ReadOnly = False
      TabOrder = 6
      Width = 81
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 56
    Top = 64
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
    Left = 312
    Top = 200
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
    Left = 144
    Top = 24
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbDialogForm'
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
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
    object bbToExcel: TdxBarButton
      Action = actExportToExcel
      Category = 0
    end
    object bbDialogForm: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 256
    Top = 232
    object actRefreshMonth: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1087#1086' Me'#1089#1103#1094#1072#1084
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
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
      FormName = 'TReport_TransportDialogForm'
      FormNameParam.Value = 'TReport_TransportDialogForm'
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
          Name = 'IsMonth'
          Value = Null
          Component = cbIsMonth
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpReport_Transport'
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
        Name = 'inCarId'
        Value = 0
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
        Name = 'inIsMonth'
        Value = Null
        Component = cbIsMonth
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
    ViewDocumentList = <>
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
    Left = 200
    Top = 64
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
        Component = BranchGuides
      end>
    Left = 248
    Top = 16
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
    Left = 664
    Top = 27
  end
end
