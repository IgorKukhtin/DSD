inherited Report_OrderExternal_UpdateForm: TReport_OrderExternal_UpdateForm
  Caption = #1047#1072#1103#1074#1082#1072' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' - '#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077
  ClientHeight = 590
  ClientWidth = 1184
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1200
  ExplicitHeight = 629
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 1184
    Height = 317
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 1184
    ExplicitHeight = 317
    ClientRectBottom = 317
    ClientRectRight = 1184
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1184
      ExplicitHeight = 317
      inherited cxGrid: TcxGrid
        Width = 1184
        Height = 317
        ExplicitWidth = 1184
        ExplicitHeight = 317
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountSh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_child_one
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_child_sec
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Min_calc
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Hours_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_child_one
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_child_sec
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_child
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Count_Partner
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Count_Doc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_sub_child_one
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_sub_child_sec
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_sub_child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_sub_child_one
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_sub_child_sec
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_sub_child
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = RouteName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_child_one
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_child_sec
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Min_calc
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Hours_real
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_child_one
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_child_sec
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_diff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_child
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Count_Partner
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = Count_Doc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_sub_child_one
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_sub_child_sec
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountWeight_sub_child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_sub_child_one
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_sub_child_sec
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSh_sub_child
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Ord: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Ord'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087'/'#1087' '#1076#1083#1103' '#1084#1072#1088#1096#1088#1091#1090#1072' '#1079#1072' '#1089#1084#1077#1085#1091
            Options.Editing = False
            Width = 40
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1079#1072#1103#1074#1082#1080
            DataBinding.FieldName = 'OperDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object DayOfWeekName: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1079#1072#1103#1074#1082#1080
            DataBinding.FieldName = 'DayOfWeekName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1076#1083#1103' '#1044#1072#1090#1072' '#1079#1072#1103#1074#1082#1080
            Options.Editing = False
            Width = 55
          end
          object OperDate_CarInfo_date: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1084#1077#1085#1072')'
            DataBinding.FieldName = 'OperDate_CarInfo_date'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1087#1083#1072#1085' '#1076#1083#1103' '#1088#1072#1073#1086#1095#1072#1103' '#1089#1084#1077#1085#1072
            Options.Editing = False
            Width = 55
          end
          object DayOfWeekName_CarInfo_date: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' ('#1089#1084#1077#1085#1072')'
            DataBinding.FieldName = 'DayOfWeekName_CarInfo_date'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1076#1083#1103' '#1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1087#1083#1072#1085' '#1076#1083#1103' '#1088#1072#1073#1086#1095#1072#1103' '#1089#1084#1077#1085#1072
            Options.Editing = False
            Width = 80
          end
          object OperDate_CarInfo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'OperDate_CarInfo'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm - hh:mm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1087#1083#1072#1085
            Options.Editing = False
            Width = 85
          end
          object DayOfWeekName_CarInfo: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'DayOfWeekName_CarInfo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1076#1083#1103' '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1087#1083#1072#1085
            Options.Editing = False
            Width = 60
          end
          object OperDate_CarInfo_calc: TcxGridDBColumn
            Caption = '***'#1044#1072#1090#1072'/'#1074#1088' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1088#1072#1089#1095'.'
            DataBinding.FieldName = 'OperDate_CarInfo_calc'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm - hh:mm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1087#1083#1072#1085' - '#1088#1072#1089#1095#1077#1090
            Options.Editing = False
            Width = 95
          end
          object DayOfWeekName_CarInfo_calc: TcxGridDBColumn
            Caption = '***'#1044#1077#1085#1100' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1088#1072#1089#1095'.'
            DataBinding.FieldName = 'DayOfWeekName_CarInfo_calc'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1076#1083#1103' '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1087#1083#1072#1085'-'#1088#1072#1089#1095#1077#1090
            Options.Editing = False
            Width = 100
          end
          object Min_calc: TcxGridDBColumn
            Caption = '***'#1052#1080#1085#1091#1090
            DataBinding.FieldName = 'Min_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1084#1080#1085#1091#1090' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1076#1083#1103' '#1055#1083#1072#1085' '#1086#1090' '#1088#1072#1089#1095#1077#1090
            Options.Editing = False
            Width = 58
          end
          object Days: TcxGridDBColumn
            Caption = #1086#1090#1082#1083'. '#1076#1085'. +/-'
            DataBinding.FieldName = 'Days'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.Alignment.Horz = taCenter
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1076#1083#1103' '#1088#1072#1089#1095#1077#1090#1072' '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1087#1083#1072#1085' - '#1086#1090#1082#1083#1086#1085#1077#1085#1085#1080#1077' '#1074' '#1076#1085#1103#1093' '#1086#1090' '#1044#1072#1090 +
              #1099' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1088#1072#1089#1095#1077#1090
            Width = 55
          end
          object Times: TcxGridDBColumn
            Caption = #1042#1088#1077#1084#1103
            DataBinding.FieldName = 'Times'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1088#1077#1084#1103' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1087#1083#1072#1085
            Width = 55
          end
          object OperDatePartner: TcxGridDBColumn
            Caption = '***'#1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'OperDatePartner'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1088#1072#1089#1095#1077#1090' ('#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077' '#1047#1072#1082#1072#1079')'
            Options.Editing = False
            Width = 60
          end
          object DayOfWeekName_Partner: TcxGridDBColumn
            Caption = '***'#1044#1077#1085#1100' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'DayOfWeekName_Partner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1076#1083#1103' '#1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1088#1072#1089#1095#1077#1090' ('#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077' '#1047#1072#1082#1072#1079')'
            Options.Editing = False
            Width = 60
          end
          object OperDate_CarInfo_str: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1087#1083#1072#1085' ('#1080#1085#1092#1086')'
            DataBinding.FieldName = 'OperDate_CarInfo_str'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1087#1083#1072#1085' ('#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080')'
            Options.Editing = False
            Width = 70
          end
          object CarInfoName: TcxGridDBColumn
            Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1076#1083#1103' '#1087#1083#1072#1085' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'CarInfoName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenChoiceCarInfoForm
                Default = True
                Kind = bkEllipsis
              end>
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 138
          end
          object CarComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1083#1072#1085' '#1086#1090#1075#1088#1091#1079#1082#1080
            DataBinding.FieldName = 'CarComment'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 132
          end
          object StartWeighing: TcxGridDBColumn
            Caption = #1057#1090#1072#1088#1090' '#1092#1072#1082#1090
            DataBinding.FieldName = 'StartWeighing'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm - hh:mm'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1072#1088#1090' '#1089#1073#1086#1088#1082#1072' '#1079#1072#1082#1072#1079#1086#1074
            Options.Editing = False
            Width = 70
          end
          object DayOfWeekName_StartW: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1089#1090#1072#1088#1090
            DataBinding.FieldName = 'DayOfWeekName_StartW'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1092#1072#1082#1090' '#1089#1090#1072#1088#1090' '#1089#1073#1086#1088#1082#1072' '#1079#1072#1082#1072#1079#1086#1074
            Options.Editing = False
            Width = 70
          end
          object EndWeighing: TcxGridDBColumn
            Caption = #1060#1080#1085#1080#1096' '#1092#1072#1082#1090
            DataBinding.FieldName = 'EndWeighing'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm - hh:mm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1080#1085#1080#1096' '#1089#1073#1086#1088#1082#1072' '#1079#1072#1082#1072#1079#1086#1074
            Options.Editing = False
            Width = 85
          end
          object DayOfWeekName_EndW: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1092#1080#1085#1080#1096
            DataBinding.FieldName = 'DayOfWeekName_EndW'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1092#1072#1082#1090' '#1092#1080#1085#1080#1096' '#1089#1073#1086#1088#1082#1072' '#1079#1072#1082#1072#1079#1086#1074
            Options.Editing = False
            Width = 70
          end
          object Hours_real: TcxGridDBColumn
            Caption = '***'#1063#1072#1089#1086#1074
            DataBinding.FieldName = 'Hours_real'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1095#1072#1089#1086#1074' '#1087#1086#1079#1078#1077' '#1095#1077#1084' '#1055#1083#1072#1085
            Options.Editing = False
            Width = 70
          end
          object Hours_EndW: TcxGridDBColumn
            Caption = #1063#1072#1089#1086#1074
            DataBinding.FieldName = 'Hours_EndW'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1072#1082#1090' '#1095#1072#1089#1086#1074' '#1076#1083#1103' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1103' '#1079#1072#1082#1072#1079#1086#1074
            Options.Editing = False
            Width = 70
          end
          object RouteName: TcxGridDBColumn
            Caption = #1052#1072#1088#1096#1088#1091#1090
            DataBinding.FieldName = 'RouteName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075'.'#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object PartnerTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1058#1058
            DataBinding.FieldName = 'PartnerTagName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ToName: TcxGridDBColumn
            Caption = #1057#1082#1083#1072#1076
            DataBinding.FieldName = 'ToName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object isRemains: TcxGridDBColumn
            Caption = #1056#1077#1079#1077#1088#1074' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isRemains'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1089' '#1056#1077#1079#1077#1088#1074#1080#1088#1086#1074#1072#1085#1080#1077#1084
            Options.Editing = False
            Width = 55
          end
          object Count_Partner: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1058#1058
            DataBinding.FieldName = 'Count_Partner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1058#1058
            Options.Editing = False
            Width = 80
          end
          object Count_Doc: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1044#1086#1082'.'
            DataBinding.FieldName = 'Count_Doc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.;-,0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1086#1074
            Options.Editing = False
          end
          object AmountWeight: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086', '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1072#1079' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
            Options.Editing = False
            Width = 100
          end
          object AmountSh: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086',  '#1096#1090' '
            DataBinding.FieldName = 'AmountSh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086',  '#1096#1090' '
            Options.Editing = False
            Width = 70
          end
          object AmountWeight_child: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074',  '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeight_child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1086#1089#1090#1072#1090#1082#1072'+'#1087#1088#1080#1093#1086#1076', '#1074#1077#1089
            Options.Editing = False
            Width = 100
          end
          object AmountWeight_child_one: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074'-1,  '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeight_child_one'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1086#1089#1090#1072#1090#1082#1072', '#1074#1077#1089
            Options.Editing = False
            Width = 70
          end
          object AmountWeight_child_sec: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074'-2,  '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeight_child_sec'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1087#1088#1080#1093#1086#1076#1072', '#1074#1077#1089
            Options.Editing = False
            Width = 70
          end
          object AmountWeight_diff: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1084#1080#1085#1091#1089', '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeight_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1085#1077' '#1093#1074#1072#1090#1072#1077#1090' '#1076#1083#1103' '#1088#1077#1079#1077#1088#1074#1072', '#1074#1077#1089
            Options.Editing = False
            Width = 100
          end
          object AmountSh_child: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074',  '#1096#1090
            DataBinding.FieldName = 'AmountSh_child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1086#1089#1090#1072#1090#1082#1072'+'#1087#1088#1080#1093#1086#1076', '#1096#1090
            Options.Editing = False
            Width = 100
          end
          object AmountSh_child_one: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074'-1, '#1096#1090
            DataBinding.FieldName = 'AmountSh_child_one'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1086#1089#1090#1072#1090#1082#1072', '#1096#1090
            Options.Editing = False
            Width = 70
          end
          object AmountSh_child_sec: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074'-2, '#1096#1090
            DataBinding.FieldName = 'AmountSh_child_sec'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1089' '#1087#1088#1080#1093#1086#1076#1072', '#1096#1090
            Options.Editing = False
            Width = 70
          end
          object AmountSh_diff: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074' '#1084#1080#1085#1091#1089', '#1096#1090
            DataBinding.FieldName = 'AmountSh_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1085#1077' '#1093#1074#1072#1090#1072#1077#1090' '#1076#1083#1103' '#1088#1077#1079#1077#1088#1074#1072', '#1096#1090
            Options.Editing = False
            Width = 100
          end
          object AmountWeight_sub_child: TcxGridDBColumn
            Caption = '***'#1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074',  '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeight_sub_child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1079#1077#1088#1074#1099' - '#1087#1077#1088#1077#1089#1086#1088#1090
            Options.Editing = False
            Width = 100
          end
          object AmountWeight_sub_child_one: TcxGridDBColumn
            Caption = '***'#1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074'-1,  '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeight_sub_child_one'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1079#1077#1088#1074#1099' - '#1087#1077#1088#1077#1089#1086#1088#1090
            Options.Editing = False
            Width = 100
          end
          object AmountWeight_sub_child_sec: TcxGridDBColumn
            Caption = '***'#1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074'-2,  '#1074#1077#1089
            DataBinding.FieldName = 'AmountWeight_sub_child_sec'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1079#1077#1088#1074#1099' - '#1087#1077#1088#1077#1089#1086#1088#1090
            Options.Editing = False
            Width = 100
          end
          object AmountSh_sub_child: TcxGridDBColumn
            Caption = '***'#1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074',  '#1096#1090
            DataBinding.FieldName = 'AmountSh_sub_child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1079#1077#1088#1074#1099' - '#1087#1077#1088#1077#1089#1086#1088#1090
            Options.Editing = False
            Width = 100
          end
          object AmountSh_sub_child_one: TcxGridDBColumn
            Caption = '***'#1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074'-1, '#1096#1090
            DataBinding.FieldName = 'AmountSh_sub_child_one'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1079#1077#1088#1074#1099' - '#1087#1077#1088#1077#1089#1086#1088#1090
            Options.Editing = False
            Width = 100
          end
          object AmountSh_sub_child_sec: TcxGridDBColumn
            Caption = '***'#1048#1090#1086#1075#1086' '#1088#1077#1079#1077#1088#1074'-2, '#1096#1090
            DataBinding.FieldName = 'AmountSh_sub_child_sec'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1079#1077#1088#1074#1099' - '#1087#1077#1088#1077#1089#1086#1088#1090
            Options.Editing = False
            Width = 100
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 126
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 250
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsCode_sub: TcxGridDBColumn
            Caption = '***'#1050#1086#1076
            DataBinding.FieldName = 'GoodsCode_sub'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072' ('#1088#1072#1089#1093#1086#1076')'
            Options.Editing = False
            Width = 80
          end
          object GoodsName_sub: TcxGridDBColumn
            Caption = '***'#1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName_sub'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072' ('#1088#1072#1089#1093#1086#1076')'
            Options.Editing = False
            Width = 80
          end
          object GoodsKindName_sub: TcxGridDBColumn
            Caption = '***'#1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName_sub'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072' ('#1088#1072#1089#1093#1086#1076')'
            Options.Editing = False
            Width = 80
          end
          object MeasureName_sub: TcxGridDBColumn
            Caption = '***'#1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName_sub'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072' ('#1088#1072#1089#1093#1086#1076')'
            Options.Editing = False
            Width = 55
          end
          object Id_calc: TcxGridDBColumn
            DataBinding.FieldName = 'Id_calc'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1184
    Height = 33
    ExplicitWidth = 1184
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 94
      EditValue = 44562d
      Properties.SaveTime = False
      ExplicitLeft = 94
      ExplicitWidth = 82
      Width = 82
    end
    inherited deEnd: TcxDateEdit
      Left = 834
      EditValue = 44562d
      Properties.SaveTime = False
      Visible = False
      ExplicitLeft = 834
      ExplicitWidth = 81
      Width = 81
    end
    inherited cxLabel1: TcxLabel
      Left = 2
      ExplicitLeft = 2
    end
    inherited cxLabel2: TcxLabel
      Left = 874
      Visible = False
      ExplicitLeft = 874
    end
    object edIsSubPrint: TcxCheckBox
      Left = 650
      Top = 5
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080
      TabOrder = 4
      Width = 151
    end
    object cbisGoods: TcxCheckBox
      Left = 197
      Top = 5
      Action = actRefresh_Goods
      TabOrder = 5
      Width = 82
    end
  end
  object edTo: TcxButtonEdit [2]
    Left = 353
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 6
    Width = 275
  end
  object cxLabel8: TcxLabel [3]
    Left = 310
    Top = 6
    Caption = #1057#1082#1083#1072#1076':'
  end
  object cxSplitter1: TcxSplitter [4]
    Left = 0
    Top = 376
    Width = 1184
    Height = 8
    HotZoneClassName = 'TcxMediaPlayer8Style'
    AlignSplitter = salBottom
    Control = grChart
  end
  object grChart: TcxGrid [5]
    Left = 0
    Top = 384
    Width = 1184
    Height = 206
    Align = alBottom
    TabOrder = 9
    object grChartDBChartView1: TcxGridDBChartView
      DataController.DataSource = MasterDS
      DiagramArea.Values.LineWidth = 2
      DiagramLine.Active = True
      DiagramLine.Values.LineWidth = 2
      ToolBox.CustomizeButton = True
      ToolBox.DiagramSelector = True
      object grDayOfWeekName_CarInfo: TcxGridDBChartDataGroup
        DataBinding.FieldName = 'DayOfWeekName_CarInfo_all_1'
        DisplayText = #1044#1077#1085#1100' '#1086#1090#1075#1088#1091#1079#1082#1080
      end
      object dgOperDate_CarInfo_str: TcxGridDBChartDataGroup
        DataBinding.FieldName = 'DayOfWeekName_CarInfo_all_2'
        DisplayText = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103
      end
      object serCount_Partner: TcxGridDBChartSeries
        DataBinding.FieldName = 'Count_Partner'
        DisplayText = #1048#1090#1086#1075#1086' '#1058#1058
      end
      object serCount_Doc: TcxGridDBChartSeries
        DataBinding.FieldName = 'Count_Doc'
        DisplayText = #1048#1090#1086#1075#1086' '#1044#1086#1082'.'
      end
      object serAmountWeight: TcxGridDBChartSeries
        DataBinding.FieldName = 'AmountWeight'
        DisplayText = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086', '#1074#1077#1089
      end
    end
    object grChartLevel1: TcxGridLevel
      GridView = grChartDBChartView1
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 320
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
        Component = GuidesTo
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
    Left = 48
  end
  inherited ActionList: TActionList
    Left = 519
    Top = 231
    object actUpdateMIChild_AmountSecondNull: TdsdExecStoredProc [0]
      Category = 'UpdateMIChild'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMIChild_AmountSecondNull_report
      StoredProcList = <
        item
          StoredProc = spUpdateMIChild_AmountSecondNull_report
        end>
      Caption = 'actUpdateMIChild_Amount'
      ImageIndex = 71
    end
    object actUpdateMIChild_AmountNull: TdsdExecStoredProc [1]
      Category = 'UpdateMIChild'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMIChild_AmountNull_report
      StoredProcList = <
        item
          StoredProc = spUpdateMIChild_AmountNull_report
        end>
      Caption = 'actUpdateMIChild_Amount'
      ImageIndex = 70
    end
    object macUpdateMIChild_AmountSecondNull_list: TMultiAction [2]
      Category = 'UpdateMIChild'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateMIChild_AmountSecondNull
        end>
      View = cxGridDBTableView
      Caption = 'macUpdateMIChild_Amount_list'
      ImageIndex = 71
    end
    object actRefresh_Goods: TdsdDataSetRefresh [3]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086' '#1090#1086#1074#1072#1088#1072#1084
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object macUpdateMIChild_AmountSecondNull: TMultiAction [4]
      Category = 'UpdateMIChild'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateMIChild_AmountSecondNull_list
        end>
      QuestionBeforeExecute = #1054#1095#1080#1089#1090#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077') '#1076#1083#1103' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' '#1089#1090#1088#1086#1082'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077') '#1086#1073#1085#1091#1083#1077#1085#1099
      Caption = #1054#1073#1085#1091#1083#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1093' '#1088#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      Hint = #1054#1073#1085#1091#1083#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1093' '#1088#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      ImageIndex = 71
    end
    object macUpdateMIChild_AmountNull_list: TMultiAction [5]
      Category = 'UpdateMIChild'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateMIChild_AmountNull
        end>
      View = cxGridDBTableView
      Caption = 'macUpdateMIChild_Amount_list'
      ImageIndex = 70
    end
    object actRefresh_Car: TdsdDataSetRefresh [6]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086' '#1076#1072#1090#1077' '#1086#1090#1075#1088#1091#1079#1082#1080
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object macUpdateMIChild_AmountNull: TMultiAction [7]
      Category = 'UpdateMIChild'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateMIChild_AmountNull_list
        end>
      QuestionBeforeExecute = 
        #1054#1095#1080#1089#1090#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082' '#1080' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077') '#1076#1083#1103' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' '#1089#1090#1088 +
        #1086#1082'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082' '#1080' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077') '#1086#1073#1085#1091#1083#1077#1085#1099
      Caption = #1054#1073#1085#1091#1083#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1093' '#1088#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082' '#1080' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      Hint = #1054#1073#1085#1091#1083#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1093' '#1088#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082' '#1080' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      ImageIndex = 70
    end
    inherited actRefresh: TdsdDataSetRefresh
      TabSheet = tsMain
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_OrderExternal_UpdateDialogForm'
      FormNameParam.Value = 'TReport_OrderExternal_UpdateDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
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
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToId'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsDate_CarInfo'
          Value = Null
          Component = edIsSubPrint
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGoods'
          Value = Null
          Component = cbisGoods
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormName = 'TOrderExternalForm'
      FormNameParam.Value = 'TOrderExternalForm'
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMask'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actMovementCheck: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementCheck
      StoredProcList = <
        item
          StoredProc = getMovementCheck
        end>
      Caption = 'actMovementCheck'
    end
    object mactOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actMovementCheck
        end
        item
          Action = actOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1057#1095#1077#1090
      ImageIndex = 28
    end
    object actOpenChoiceCarInfoForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'CarInfoForm'
      FormName = 'TCarInfoForm'
      FormNameParam.Value = 'TCarInfoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CarInfoId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CarInfoName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object macUpdate_CarInfo: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_CarInfo_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1048#1085#1092'. '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072#1103#1074#1086#1082'?'
      InfoAfterExecute = #1048#1085#1092'. '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077' '#1087#1077#1088#1077#1085#1077#1089#1077#1085#1072' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072#1103#1074#1086#1082
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1048#1085#1092'. '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072#1103#1074#1086#1082
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1048#1085#1092'. '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072#1103#1074#1086#1082
      ImageIndex = 30
    end
    object macUpdate_CarInfo_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_CarInfo
        end>
      View = cxGridDBTableView
      Caption = 'macUpdate_CarInfo_list'
    end
    object actUpdate_CarInfo_grid: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CarInfo_grid
      StoredProcList = <
        item
          StoredProc = spUpdate_CarInfo_grid
        end>
      Caption = 'actUpdate_CarInfo'
    end
    object actPrintGoodsDiff_3: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintGoodsDiff_3
      StoredProcList = <
        item
          StoredProc = spSelectPrintGoodsDiff_3
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' '#1090#1086#1083#1100#1082#1086' '#1084#1080#1085#1091#1089' '#1088#1077#1079#1077#1088#1074' <'#1048#1090#1086#1075#1086' '#1079#1072' 3 '#1076#1085#1103'>'
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' '#1090#1086#1083#1100#1082#1086' '#1084#1080#1085#1091#1089' '#1088#1077#1079#1077#1088#1074' <'#1048#1090#1086#1075#1086' '#1079#1072' 3 '#1076#1085#1103'>'
      ImageIndex = 23
      DataSets = <
        item
          DataSet = ItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 44562d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 44562d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inText'
          Value = #1056#1077#1079#1077#1088#1074' '#1084#1080#1085#1091#1089
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsSubPrint'
          Value = Null
          Component = edIsSubPrint
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1095#1072#1090#1100' '#1058#1086#1074#1072#1088#1086#1074' '#1047#1072#1103#1074#1082#1080' ('#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077')3'#1076#1085#1103
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100' '#1058#1086#1074#1072#1088#1086#1074' '#1047#1072#1103#1074#1082#1080' ('#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077')3'#1076#1085#1103
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintGoodsDiff_3Upack: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintGoodsDiff_3Upack
      StoredProcList = <
        item
          StoredProc = spSelectPrintGoodsDiff_3Upack
        end>
      Caption = 
        #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1059#1087#1072#1082#1086#1074#1082#1080' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' '#1090#1086#1083#1100#1082#1086' '#1084#1080#1085#1091#1089' '#1088#1077#1079#1077#1088#1074' <'#1048#1090#1086#1075#1086' '#1079#1072' 3 '#1076 +
        #1085#1103'>'
      Hint = 
        #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1059#1087#1072#1082#1086#1074#1082#1080' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' '#1090#1086#1083#1100#1082#1086' '#1084#1080#1085#1091#1089' '#1088#1077#1079#1077#1088#1074' <'#1048#1090#1086#1075#1086' '#1079#1072' 3 '#1076 +
        #1085#1103'>'
      ImageIndex = 23
      DataSets = <
        item
          DataSet = ItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 44562d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 44562d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inText'
          Value = #1056#1077#1079#1077#1088#1074' '#1084#1080#1085#1091#1089
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1095#1072#1090#1100' '#1058#1086#1074#1072#1088#1086#1074' '#1047#1072#1103#1074#1082#1080' ('#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077')3'#1076#1085#1103' '#1091#1087#1072#1082
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100' '#1058#1086#1074#1072#1088#1086#1074' '#1047#1072#1103#1074#1082#1080' ('#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077')3'#1076#1085#1103' '#1091#1087#1072#1082
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintGoodsDiff_Upack: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintGoodsDiff_Upack
      StoredProcList = <
        item
          StoredProc = spSelectPrintGoodsDiff_Upack
        end>
      Caption = 
        #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1059#1087#1072#1082#1086#1074#1082#1080#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' '#1090#1086#1083#1100#1082#1086' '#1084#1080#1085#1091#1089' '#1088#1077#1079#1077#1088#1074' <'#1048#1090#1086#1075#1086' '#1079#1072' '#1086#1076#1080#1085 +
        ' '#1076#1077#1085#1100' '#1087#1086' '#1084#1072#1088#1096#1088#1091#1090#1072#1084'>'
      Hint = 
        #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1059#1087#1072#1082#1086#1074#1082#1080#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' '#1090#1086#1083#1100#1082#1086' '#1084#1080#1085#1091#1089' '#1088#1077#1079#1077#1088#1074' <'#1048#1090#1086#1075#1086' '#1079#1072' '#1086#1076#1080#1085 +
        ' '#1076#1077#1085#1100' '#1087#1086' '#1084#1072#1088#1096#1088#1091#1090#1072#1084'>'
      ImageIndex = 21
      DataSets = <
        item
          DataSet = ItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GroupPrint;Ord;GoodsGroupNameFull;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 44562d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 44562d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inText'
          Value = #1056#1077#1079#1077#1088#1074' '#1084#1080#1085#1091#1089
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1095#1072#1090#1100' '#1058#1086#1074#1072#1088#1086#1074' '#1047#1072#1103#1074#1082#1080' ('#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077')'#1091#1087#1072#1082#1086#1074#1082#1072
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100' '#1058#1086#1074#1072#1088#1086#1074' '#1047#1072#1103#1074#1082#1080' ('#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077')'#1091#1087#1072#1082#1086#1074#1082#1072
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintGoods_Upack: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintGoods_upack
      StoredProcList = <
        item
          StoredProc = spSelectPrintGoods_upack
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' <'#1048#1090#1086#1075#1086' '#1079#1072' '#1086#1076#1080#1085' '#1076#1077#1085#1100' '#1087#1086' '#1084#1072#1088#1096#1088#1091#1090#1072#1084'> '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' <'#1048#1090#1086#1075#1086' '#1079#1072' '#1086#1076#1080#1085' '#1076#1077#1085#1100' '#1087#1086' '#1084#1072#1088#1096#1088#1091#1090#1072#1084'> '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080
      ImageIndex = 17
      DataSets = <
        item
          DataSet = ItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GroupPrint;Ord;GoodsGroupNameFull;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 44562d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 44562d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inText'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1095#1072#1090#1100' '#1058#1086#1074#1072#1088#1086#1074' '#1047#1072#1103#1074#1082#1080' ('#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077')'#1091#1087#1072#1082#1086#1074#1082#1072
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100' '#1058#1086#1074#1072#1088#1086#1074' '#1047#1072#1103#1074#1082#1080' ('#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077')'#1091#1087#1072#1082#1086#1074#1082#1072
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actUpdate_CarInfo: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CarInfo
      StoredProcList = <
        item
          StoredProc = spUpdate_CarInfo
        end>
      Caption = 'actUpdate_CarInfo'
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CarInfo_grid
      StoredProcList = <
        item
          StoredProc = spUpdate_CarInfo_grid
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object actOrderExternal_byReport: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      Hint = #1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      FormName = 'TOrderExternalJournal_byReportForm'
      FormNameParam.Value = 'TOrderExternalJournal_byReportForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDatePartner'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDatePartner'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inToId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ToId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inRouteId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inRetailId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RetailId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' <'#1048#1090#1086#1075#1086' '#1087#1086' '#1076#1085#1103#1084'>'
      Hint = #1055#1077#1095#1072#1090#1100' <'#1048#1090#1086#1075#1086' '#1087#1086' '#1076#1085#1103#1084'>'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = HeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 'GroupPrint'
        end
        item
          DataSet = ItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GroupPrint;OperDate_CarInfo;RouteName;RetailName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 44562d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 44562d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1095#1072#1090#1100' '#1047#1072#1103#1074#1082#1080' ('#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077')'
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100' '#1047#1072#1103#1074#1082#1080' ('#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintGoods: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintGoods
      StoredProcList = <
        item
          StoredProc = spSelectPrintGoods
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' <'#1048#1090#1086#1075#1086' '#1079#1072' '#1086#1076#1080#1085' '#1076#1077#1085#1100' '#1087#1086' '#1084#1072#1088#1096#1088#1091#1090#1072#1084'>'
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' <'#1048#1090#1086#1075#1086' '#1079#1072' '#1086#1076#1080#1085' '#1076#1077#1085#1100' '#1087#1086' '#1084#1072#1088#1096#1088#1091#1090#1072#1084'>'
      ImageIndex = 17
      DataSets = <
        item
          DataSet = ItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GroupPrint;Ord;GoodsGroupNameFull;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 44562d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 44562d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inText'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsSubPrint'
          Value = Null
          Component = edIsSubPrint
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1095#1072#1090#1100' '#1058#1086#1074#1072#1088#1086#1074' '#1047#1072#1103#1074#1082#1080' ('#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077')'
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100' '#1058#1086#1074#1072#1088#1086#1074' '#1047#1072#1103#1074#1082#1080' ('#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintGoodsDiff: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintGoodsDiff
      StoredProcList = <
        item
          StoredProc = spSelectPrintGoodsDiff
        end>
      Caption = 
        #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' '#1090#1086#1083#1100#1082#1086' '#1084#1080#1085#1091#1089' '#1088#1077#1079#1077#1088#1074' <'#1048#1090#1086#1075#1086' '#1079#1072' '#1086#1076#1080#1085' '#1076#1077#1085#1100' '#1087#1086' '#1084#1072#1088 +
        #1096#1088#1091#1090#1072#1084'>'
      Hint = 
        #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' '#1090#1086#1083#1100#1082#1086' '#1084#1080#1085#1091#1089' '#1088#1077#1079#1077#1088#1074' <'#1048#1090#1086#1075#1086' '#1079#1072' '#1086#1076#1080#1085' '#1076#1077#1085#1100' '#1087#1086' '#1084#1072#1088 +
        #1096#1088#1091#1090#1072#1084'>'
      ImageIndex = 21
      DataSets = <
        item
          DataSet = ItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GroupPrint;Ord;GoodsGroupNameFull;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 44562d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 44562d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inText'
          Value = #1056#1077#1079#1077#1088#1074' '#1084#1080#1085#1091#1089
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsSubPrint'
          Value = Null
          Component = edIsSubPrint
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1095#1072#1090#1100' '#1058#1086#1074#1072#1088#1086#1074' '#1047#1072#1103#1074#1082#1080' ('#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077')'
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100' '#1058#1086#1074#1072#1088#1086#1074' '#1047#1072#1103#1074#1082#1080' ('#1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1087#1086' '#1086#1090#1075#1088#1091#1079#1082#1077')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actUpdateMIChild_Amount: TdsdExecStoredProc
      Category = 'UpdateMIChild'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMIChild_Amount_report
      StoredProcList = <
        item
          StoredProc = spUpdateMIChild_Amount_report
        end>
      Caption = 'actUpdateMIChild_Amount'
      ImageIndex = 68
    end
    object macUpdateMIChild_Amount_list: TMultiAction
      Category = 'UpdateMIChild'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateMIChild_Amount
        end>
      View = cxGridDBTableView
      Caption = 'macUpdateMIChild_Amount_list'
      ImageIndex = 68
    end
    object macUpdateMIChild_Amount: TMultiAction
      Category = 'UpdateMIChild'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateMIChild_Amount_list
        end>
      QuestionBeforeExecute = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082') '#1076#1083#1103' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' '#1089#1090#1088#1086#1082'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082') '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '
      Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1088#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')'
      Hint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1088#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')'
      ImageIndex = 68
    end
    object actUpdateMIChild_AmountSecond: TdsdExecStoredProc
      Category = 'UpdateMIChild'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMIChild_AmountSecond_report
      StoredProcList = <
        item
          StoredProc = spUpdateMIChild_AmountSecond_report
        end>
      Caption = 'actUpdateMIChild_Amount'
      ImageIndex = 69
    end
    object macUpdateMIChild_AmountSecond_list: TMultiAction
      Category = 'UpdateMIChild'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateMIChild_AmountSecond
        end>
      View = cxGridDBTableView
      Caption = 'macUpdateMIChild_AmountSecond_list'
      ImageIndex = 69
    end
    object macUpdateMIChild_AmountSecond: TMultiAction
      Category = 'UpdateMIChild'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateMIChild_AmountSecond_list
        end>
      QuestionBeforeExecute = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077') '#1076#1083#1103' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' '#1089#1090#1088#1086#1082'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077') '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '
      Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1088#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      Hint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1088#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      ImageIndex = 69
    end
  end
  inherited MasterDS: TDataSource
    Left = 112
    Top = 200
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_OrderExternal_Update'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
      end
      item
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
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDate_CarInfo'
        Value = Null
        Component = edIsSubPrint
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoods'
        Value = Null
        Component = cbisGoods
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 200
  end
  inherited BarManager: TdxBarManager
    Left = 408
    Top = 272
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOrderExternal_byReport'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMIChild_Amount'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMIChild_AmountSecond'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMIChild_AmountNull'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMIChild_AmountSecondNull'
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintGoods'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintGoodsDiff'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintGoodsDiff_3'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintGoods_Upack'
        end
        item
          Visible = True
          ItemName = 'bbPrintGoodsDiff_Upack'
        end
        item
          Visible = True
          ItemName = 'bbPrintGoodsDiff_3Upack'
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
    object bbOpenDocument: TdxBarButton
      Action = mactOpenDocument
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Category = 0
    end
    object bbUpdate_CarInfo: TdxBarButton
      Action = macUpdate_CarInfo
      Category = 0
    end
    object bbOrderExternal_byReport: TdxBarButton
      Action = actOrderExternal_byReport
      Category = 0
      ImageIndex = 26
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbPrintGoods: TdxBarButton
      Action = actPrintGoods
      Category = 0
    end
    object bbUpdateMIChild_Amount: TdxBarButton
      Action = macUpdateMIChild_Amount
      Category = 0
    end
    object bbUpdateMIChild_AmountSecond: TdxBarButton
      Action = macUpdateMIChild_AmountSecond
      Category = 0
    end
    object bbUpdateMIChild_AmountNull: TdxBarButton
      Action = macUpdateMIChild_AmountNull
      Category = 0
    end
    object bbUpdateMIChild_AmountSecondNull: TdxBarButton
      Action = macUpdateMIChild_AmountSecondNull
      Category = 0
    end
    object bbPrintGoodsDiff: TdxBarButton
      Action = actPrintGoodsDiff
      Category = 0
    end
    object bbPrintGoodsDiff_3: TdxBarButton
      Action = actPrintGoodsDiff_3
      Category = 0
    end
    object bbPrintGoods_Upack: TdxBarButton
      Action = actPrintGoods_Upack
      Caption = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1059#1087#1072#1082#1086#1074#1082#1080' '#1087#1086' '#1090#1086#1074#1072#1088#1072#1084' <'#1048#1090#1086#1075#1086' '#1079#1072' '#1086#1076#1080#1085' '#1076#1077#1085#1100' '#1087#1086' '#1084#1072#1088#1096#1088#1091#1090#1072#1084'>'
      Category = 0
    end
    object bbPrintGoodsDiff_Upack: TdxBarButton
      Action = actPrintGoodsDiff_Upack
      Category = 0
    end
    object bbPrintGoodsDiff_3Upack: TdxBarButton
      Action = actPrintGoodsDiff_3Upack
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 696
    Top = 136
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 240
    Top = 65528
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
      end
      item
      end
      item
      end
      item
      end
      item
        Component = GuidesTo
      end
      item
      end
      item
      end
      item
      end>
    Left = 592
    Top = 144
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'FormName'
        Value = 'TOrderExternalForm'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 288
    Top = 178
  end
  object GuidesTo: TdsdGuides
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
        Component = GuidesTo
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 671
    Top = 12
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 288
    Top = 256
  end
  object ItemsCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 240
    Top = 256
  end
  object getMovementCheck: TdsdStoredProc
    StoredProcName = 'gpGet_MovementCheck'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 760
    Top = 248
  end
  object spUpdate_CarInfo: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderExternal_CarInfo'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDatePartner'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDatePartner'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ToId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RouteId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RetailId'
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
        Name = 'inDays'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Days'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioTimes'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Times'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCarInfoName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CarInfoName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCarComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CarComment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 624
    Top = 304
  end
  object spUpdate_CarInfo_grid: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderExternal_CarInfo'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDatePartner'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDatePartner'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outOperDate_CarInfo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate_CarInfo'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDayName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DayOfWeekName_CarInfo'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ToId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RouteId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RetailId'
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
        Name = 'inDays'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Days'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioTimes'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Times'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCarInfoName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CarInfoName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCarComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CarComment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 624
    Top = 232
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpReport_OrderExternal_UpdatePrint'
    DataSet = HeaderCDS
    DataSets = <
      item
        DataSet = HeaderCDS
      end
      item
        DataSet = ItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 43101d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 43101d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDate_CarInfo'
        Value = ''
        Component = edIsSubPrint
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 784
    Top = 144
  end
  object spSelectPrintGoods: TdsdStoredProc
    StoredProcName = 'gpReport_OrderExternal_UpdateGoodsPrint'
    DataSet = ItemsCDS
    DataSets = <
      item
        DataSet = ItemsCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 44562d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 44562d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDate_CarInfo'
        Value = False
        Component = edIsSubPrint
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSub'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 848
    Top = 160
  end
  object spUpdateMIChild_Amount_report: TdsdStoredProc
    StoredProcName = 'gpUpdateMIChild_OrderExternal_Amount_report'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDatePartner'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDatePartner'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ToId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RouteId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RetailId'
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
      end>
    PackSize = 1
    Left = 408
    Top = 392
  end
  object spUpdateMIChild_AmountSecond_report: TdsdStoredProc
    StoredProcName = 'gpUpdateMIChild_OrderExternal_AmountSecond_report'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDatePartner'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDatePartner'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ToId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RouteId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RetailId'
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
      end>
    PackSize = 1
    Left = 424
    Top = 440
  end
  object spUpdateMIChild_AmountNull_report: TdsdStoredProc
    StoredProcName = 'gpUpdateMIChild_OrderExternal_AmountNull_report'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDatePartner'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDatePartner'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ToId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RouteId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RetailId'
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
      end>
    PackSize = 1
    Left = 584
    Top = 392
  end
  object spUpdateMIChild_AmountSecondNull_report: TdsdStoredProc
    StoredProcName = 'gpUpdateMIChild_OrderExternal_AmountSecondNull_report'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDatePartner'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDatePartner'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ToId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRouteId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RouteId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RetailId'
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
      end>
    PackSize = 1
    Left = 592
    Top = 456
  end
  object spSelectPrintGoodsDiff: TdsdStoredProc
    StoredProcName = 'gpReport_OrderExternal_UpdateGoodsDiffPrint'
    DataSet = ItemsCDS
    DataSets = <
      item
        DataSet = ItemsCDS
      end
      item
        DataSet = HeaderCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 44562d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 44562d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDate_CarInfo'
        Value = False
        Component = edIsSubPrint
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSub'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 856
    Top = 216
  end
  object spSelectPrintGoodsDiff_3: TdsdStoredProc
    StoredProcName = 'gpReport_OrderExternal_UpdateGoodsDiff3Print'
    DataSet = ItemsCDS
    DataSets = <
      item
        DataSet = ItemsCDS
      end
      item
        DataSet = HeaderCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 44562d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 44562d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDate_CarInfo'
        Value = False
        Component = edIsSubPrint
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSub'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 848
    Top = 280
  end
  object spSelectPrintGoods_upack: TdsdStoredProc
    StoredProcName = 'gpReport_OrderExternal_UpdateGoodsPrint'
    DataSet = ItemsCDS
    DataSets = <
      item
        DataSet = ItemsCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 44562d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 44562d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDate_CarInfo'
        Value = False
        Component = edIsSubPrint
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSub'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 944
    Top = 152
  end
  object spSelectPrintGoodsDiff_Upack: TdsdStoredProc
    StoredProcName = 'gpReport_OrderExternal_UpdateGoodsDiffPrint'
    DataSet = ItemsCDS
    DataSets = <
      item
        DataSet = ItemsCDS
      end
      item
        DataSet = HeaderCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 44562d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 44562d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDate_CarInfo'
        Value = False
        Component = edIsSubPrint
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSub'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 936
    Top = 208
  end
  object spSelectPrintGoodsDiff_3Upack: TdsdStoredProc
    StoredProcName = 'gpReport_OrderExternal_UpdateGoodsDiff3Print'
    DataSet = ItemsCDS
    DataSets = <
      item
        DataSet = ItemsCDS
      end
      item
        DataSet = HeaderCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 44562d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 44562d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDate_CarInfo'
        Value = False
        Component = edIsSubPrint
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSub'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 944
    Top = 272
  end
end
