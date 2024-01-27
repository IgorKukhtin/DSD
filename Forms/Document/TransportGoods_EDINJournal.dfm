inherited TransportGoods_EDINJournalForm: TTransportGoods_EDINJournalForm
  Caption = 
    #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1058#1086#1074#1072#1088#1085#1086'-'#1090#1088#1072#1085#1089#1087#1086#1088#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' '#1088#1072#1073#1086#1090#1072' '#1089'  e-'#1058#1058 +
    #1053'>'
  ClientHeight = 531
  ClientWidth = 1076
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ChoiceAction = actChoiceGuides
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1098
  ExplicitHeight = 587
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 66
    Width = 1076
    Height = 465
    TabOrder = 3
    ExplicitTop = 66
    ExplicitWidth = 1076
    ExplicitHeight = 465
    ClientRectBottom = 465
    ClientRectRight = 1076
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1076
      ExplicitHeight = 465
      inherited cxGrid: TcxGrid
        Width = 1076
        Height = 465
        ExplicitWidth = 1076
        ExplicitHeight = 465
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
          DataController.Filter.TranslateBetween = True
          DataController.Filter.TranslateIn = True
          DataController.Filter.TranslateLike = True
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountSh
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
              Column = TotalCountKg
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountSh
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
              Column = TotalCountKg
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end>
          OptionsBehavior.GoToNextCellOnEnter = False
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          OptionsView.HeaderHeight = 50
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object isSend_eTTN: TcxGridDBColumn [0]
            Caption = 'e-'#1058#1058#1053' '#1086#1090#1087#1088#1072#1074#1083'.'
            DataBinding.FieldName = 'isSend_eTTN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object isSignConsignor_eTTN: TcxGridDBColumn [1]
            Caption = #1055#1086#1076#1087#1080#1089#1100' '#1075#1088#1091#1079#1086#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103
            DataBinding.FieldName = 'isSignConsignor_eTTN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object isSignCarrier_eTTN: TcxGridDBColumn [2]
            Caption = #1055#1086#1076#1087#1080#1089#1100' '#1087#1077#1088#1077#1074#1086#1079#1095#1080#1082#1072
            DataBinding.FieldName = 'isSignCarrier_eTTN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object DeliveryInstructionsName: TcxGridDBColumn [3]
            Caption = #1042#1080#1076' '#1087#1077#1088#1077#1074#1077#1079#1077#1085#1100
            DataBinding.FieldName = 'DeliveryInstructionsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 113
          end
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          object ReestrKindName: TcxGridDBColumn [5]
            Caption = #1042#1080#1079#1072' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077
            DataBinding.FieldName = 'ReestrKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          inherited colOperDate: TcxGridDBColumn [6]
            HeaderAlignmentHorz = taCenter
            Width = 60
          end
          inherited colInvNumber: TcxGridDBColumn [7]
            Caption = #8470' '#1076#1086#1082'.'
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          object isExternal: TcxGridDBColumn
            Caption = #1057#1090#1086#1088#1086#1085#1085#1080#1077' '#1072#1074#1090#1086
            DataBinding.FieldName = 'isExternal'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1086#1088#1086#1085#1085#1080#1077' '#1072#1074#1090#1086' ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 70
          end
          object CommentError: TcxGridDBColumn
            Caption = #1054#1096#1080#1073#1082#1072' '#1086#1073#1088#1072#1073#1086#1090#1082#1080
            DataBinding.FieldName = 'CommentError'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 125
          end
          object PlaceOf: TcxGridDBColumn
            Caption = #1052#1077#1089#1090#1086' '#1089#1086#1089#1090#1072#1074#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'PlaceOf'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object KATOTTG_Unit: TcxGridDBColumn
            Caption = #1050#1040#1058#1054#1058#1058#1043' '#1055#1091#1085#1082#1090' '#1079#1072#1074#1072#1085#1090#1072#1078'.'
            DataBinding.FieldName = 'KATOTTG_Unit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1040#1058#1054#1058#1058#1043' '#1055#1091#1085#1082#1090' '#1079#1072#1074#1072#1085#1090#1072#1078#1077#1085#1085#1103
            Options.Editing = False
            Width = 85
          end
          object KATOTTG_Unloading: TcxGridDBColumn
            Caption = #1050#1040#1058#1054#1058#1058#1043' '#1055#1091#1085#1082#1090' '#1088#1086#1079#1074#1072#1085#1090#1072#1078'.'
            DataBinding.FieldName = 'KATOTTG_Unloading'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1040#1058#1054#1058#1058#1043' '#1055#1091#1085#1082#1090' '#1088#1086#1079#1074#1072#1085#1090#1072#1078#1077#1085#1085#1103
            Options.Editing = False
            Width = 85
          end
          object GLN_Unit: TcxGridDBColumn
            Caption = 'GLN '#1055#1091#1085#1082#1090' '#1079#1072#1074#1072#1085#1090#1072#1078'.'
            DataBinding.FieldName = 'GLN_Unit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 'GLN '#1055#1091#1085#1082#1090' '#1079#1072#1074#1072#1085#1090#1072#1078#1077#1085#1085#1103
            Options.Editing = False
            Width = 85
          end
          object GLN_Unloading: TcxGridDBColumn
            Caption = 'GLN '#1055#1091#1085#1082#1090' '#1088#1086#1079#1074#1072#1085#1090'.'
            DataBinding.FieldName = 'GLN_Unloading'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 'GLN '#1055#1091#1085#1082#1090' '#1088#1086#1079#1074#1072#1085#1090#1072#1078#1077#1085#1085#1103
            Options.Editing = False
            Width = 80
          end
          object GLN_from: TcxGridDBColumn
            Caption = 'GLN '#1042#1072#1085#1090#1072#1078#1086#1074#1110#1076#1087#1088#1072#1074#1085#1080#1082
            DataBinding.FieldName = 'GLN_from'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 125
          end
          object GLN_to: TcxGridDBColumn
            Caption = 'GLN '#1042#1072#1085#1090#1072#1078#1086#1086#1076#1077#1088#1078#1091#1074#1072#1095
            DataBinding.FieldName = 'GLN_to'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object OKPO_To: TcxGridDBColumn
            Caption = #1054#1050#1055#1054' '#1042#1072#1085#1090#1072#1078#1086#1086#1076#1077#1088#1078#1091#1074#1072#1095
            DataBinding.FieldName = 'OKPO_To'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GLN_car: TcxGridDBColumn
            Caption = 'GLN '#1040#1074#1090#1086#1084'. '#1087#1077#1088#1077#1074#1110#1079#1085#1080#1082
            DataBinding.FieldName = 'GLN_car'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 'GLN '#1040#1074#1090#1086#1084#1086#1073#1110#1083#1100#1085#1080#1081' '#1087#1077#1088#1077#1074#1110#1079#1085#1080#1082
            Options.Editing = False
            Width = 80
          end
          object OKPO_car: TcxGridDBColumn
            Caption = #1054#1050#1055#1054' '#1040#1074#1090#1086#1084'. '#1087#1077#1088#1077#1074#1110#1079#1085#1080#1082
            DataBinding.FieldName = 'OKPO_car'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1050#1055#1054' '#1040#1074#1090#1086#1084#1086#1073#1110#1083#1100#1085#1080#1081' '#1087#1077#1088#1077#1074#1110#1079#1085#1080#1082
            Options.Editing = False
            Width = 85
          end
          object CarJuridicalName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086' '#1040#1074#1090#1086#1084'. '#1087#1077#1088#1077#1074#1110#1079#1085#1080#1082
            DataBinding.FieldName = 'CarJuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1070#1088'.'#1083#1080#1094#1086' '#1040#1074#1090#1086#1084#1086#1073#1110#1083#1100#1085#1080#1081' '#1087#1077#1088#1077#1074#1110#1079#1085#1080#1082
            Width = 100
          end
          object GLN_Driver: TcxGridDBColumn
            Caption = 'GLN '#1074#1086#1076#1080#1090#1077#1083#1103
            DataBinding.FieldName = 'GLN_Driver'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object DriverINN: TcxGridDBColumn
            Caption = #1048#1053#1053' '#1074#1086#1076#1080#1090#1077#1083#1103
            DataBinding.FieldName = 'DriverINN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object DriverCertificate: TcxGridDBColumn
            Caption = #1042#1086#1076#1080#1090'. '#1091#1076#1086#1089#1090'.'
            DataBinding.FieldName = 'DriverCertificate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object Uuid: TcxGridDBColumn
            Caption = 'Uuid e-'#1058#1058#1053
            DataBinding.FieldName = 'Uuid'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object CarName: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
            DataBinding.FieldName = 'CarName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object CarModelName: TcxGridDBColumn
            Caption = #1052#1086#1076#1077#1083#1100' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
            DataBinding.FieldName = 'CarModelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object CarBrandName: TcxGridDBColumn
            Caption = #1052#1072#1088#1082'a '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
            DataBinding.FieldName = 'CarBrandName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object CarColorName: TcxGridDBColumn
            Caption = #1062#1074#1077#1090' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
            DataBinding.FieldName = 'CarColorName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object CarTypeName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
            DataBinding.FieldName = 'CarTypeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object CarTrailerName: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100' ('#1087#1088#1080#1094#1077#1087')'
            DataBinding.FieldName = 'CarTrailerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object CarTrailerModelName: TcxGridDBColumn
            Caption = #1052#1086#1076#1077#1083#1100' '#1087#1088#1080#1094#1077#1087#1072
            DataBinding.FieldName = 'CarTrailerModelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object CarTrailerBrandName: TcxGridDBColumn
            Caption = #1052#1072#1088#1082'a '#1087#1088#1080#1094#1077#1087#1072
            DataBinding.FieldName = 'CarTrailerBrandName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object CarTrailerColorName: TcxGridDBColumn
            Caption = #1062#1074#1077#1090' '#1087#1088#1080#1094#1077#1087#1072
            DataBinding.FieldName = 'CarTrailerColorName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object CarTrailerTypeName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1087#1088#1080#1094#1077#1087#1072
            DataBinding.FieldName = 'CarTrailerTypeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object PersonalDriverItemName: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090' ('#1074#1086#1076#1080#1090#1077#1083#1100')'
            DataBinding.FieldName = 'PersonalDriverItemName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object PersonalDriverName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'PersonalDriverName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object InvNumber_Sale: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'InvNumber_Sale'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object MemberSignConsignorName: TcxGridDBColumn
            Caption = #1055#1110#1076#1087#1080#1089' '#1042#1072#1085#1090#1072#1078#1086#1074#1110#1076#1087#1088#1072#1074#1085#1080#1082
            DataBinding.FieldName = 'MemberSignConsignorName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object SignConsignorDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1110#1076#1087#1080#1089#1091' '#1042#1072#1085#1090#1072#1078#1086#1074#1110#1076#1087#1088#1072#1074#1085#1080#1082
            DataBinding.FieldName = 'SignConsignorDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object MemberSignCarrierName: TcxGridDBColumn
            Caption = #1055#1110#1076#1087#1080#1089' '#1055#1077#1088#1077#1074#1110#1079#1085#1080#1082#1072
            DataBinding.FieldName = 'MemberSignCarrierName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object SignCarrierDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1110#1076#1087#1080#1089#1091' '#1055#1077#1088#1077#1074#1110#1079#1085#1080#1082#1072
            DataBinding.FieldName = 'SignCarrierDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object OperDate_Sale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'OperDate_Sale'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object InvNumberPartner_Sale: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'InvNumberPartner_Sale'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperDatePartner_Sale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'OperDatePartner_Sale'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object RouteName: TcxGridDBColumn
            Caption = #1052#1072#1088#1096#1088#1091#1090
            DataBinding.FieldName = 'RouteName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object TotalCountSh: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1096#1090'. ('#1091' '#1087#1086#1082#1091#1087'.)'
            DataBinding.FieldName = 'TotalCountSh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalCountKg: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' ('#1091' '#1087#1086#1082#1091#1087'.)'
            DataBinding.FieldName = 'TotalCountKg'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object OperDate_Transport: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1055'.'#1083'. ('#1058#1058#1053')'
            DataBinding.FieldName = 'OperDate_Transport'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1044#1086#1082#1091#1084#1077#1085#1090#1072' '#1058#1058#1053
            Options.Editing = False
            Width = 70
          end
          object InvNumber_Transport: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1055'.'#1083'. ('#1058#1058#1053')'
            DataBinding.FieldName = 'InvNumber_Transport'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1044#1086#1082#1091#1084#1077#1085#1090#1072' '#1058#1058#1053
            Options.Editing = False
            Width = 61
          end
          object CarName_Transport: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100' ('#1055'.'#1083'. -'#1058#1058#1053')'
            DataBinding.FieldName = 'CarName_Transport'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1044#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
            Options.Editing = False
            Width = 80
          end
          object PersonalDriverName_Transport: TcxGridDBColumn
            Caption = #1042#1086#1076#1080#1090#1077#1083#1100' ('#1055'.'#1083'. -'#1058#1058#1053')'
            DataBinding.FieldName = 'PersonalDriverName_Transport'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1044#1086#1082#1091#1084#1077#1085#1090#1072' '#1058#1058#1053
            Options.Editing = False
            Width = 70
          end
          object OperDate_Reestr: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1088#1077#1077#1089#1090#1088')'
            DataBinding.FieldName = 'OperDate_Reestr'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1056#1077#1077#1089#1090#1088#1072
            Width = 70
          end
          object InvNumber_Reestr: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. ('#1088#1077#1077#1089#1090#1088')'
            DataBinding.FieldName = 'InvNumber_Reestr'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1056#1077#1077#1089#1090#1088#1072
            Options.Editing = False
            Width = 70
          end
          object OperDate_Transport_reestr: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1055'.'#1083'. ('#1088#1077#1077#1089#1090#1088')'
            DataBinding.FieldName = 'OperDate_Transport_reestr'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1056#1077#1077#1089#1090#1088#1072
            Width = 70
          end
          object InvNumber_Transport_reestr: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1055'.'#1083'. ('#1088#1077#1077#1089#1090#1088')'
            DataBinding.FieldName = 'InvNumber_Transport_reestr'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1056#1077#1077#1089#1090#1088#1072
            Options.Editing = False
            Width = 80
          end
          object CarModelName_Reestr: TcxGridDBColumn
            Caption = #1052#1072#1088#1082'a '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103' ('#1088#1077#1077#1089#1090#1088')'
            DataBinding.FieldName = 'CarModelName_Reestr'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1056#1077#1077#1089#1090#1088#1072
            Width = 80
          end
          object CarName_Reestr: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100' ('#1088#1077#1077#1089#1090#1088')'
            DataBinding.FieldName = 'CarName_Reestr'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1056#1077#1077#1089#1090#1088#1072
            Options.Editing = False
            Width = 80
          end
          object PersonalDriverName_Reestr: TcxGridDBColumn
            Caption = #1042#1086#1076#1080#1090#1077#1083#1100' ('#1088#1077#1077#1089#1090#1088')'
            DataBinding.FieldName = 'PersonalDriverName_Reestr'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1056#1077#1077#1089#1090#1088#1072
            Options.Editing = False
            Width = 70
          end
          object MemberName_Reestr: TcxGridDBColumn
            Caption = #1069#1082#1089#1087#1077#1076#1080#1090#1086#1088' ('#1088#1077#1077#1089#1090#1088')'
            DataBinding.FieldName = 'MemberName_Reestr'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1056#1077#1077#1089#1090#1088#1072
            Options.Editing = False
            Width = 80
          end
          object MemberName1: TcxGridDBColumn
            Caption = #1042#1086#1076#1080#1090#1077#1083#1100'/'#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088' ('#1087#1086#1083#1091#1095#1080#1083')'
            DataBinding.FieldName = 'MemberName1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1090#1088#1080#1084#1072#1074' '#1074#1086#1076#1110#1081'/'#1077#1082#1089#1087#1077#1076#1080#1090#1086#1088
            Options.Editing = False
            Width = 108
          end
          object MemberName2: TcxGridDBColumn
            Caption = #1041#1091#1093#1075#1072#1083#1090#1077#1088
            DataBinding.FieldName = 'MemberName2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1091#1093#1075#1072#1083#1090#1077#1088' ('#1074#1110#1076#1087#1086#1074#1110#1076#1072#1083#1100#1085#1072' '#1086#1089#1086#1073#1072' '#1074#1072#1085#1090#1072#1078#1086#1074#1110#1076#1087#1088#1072#1074#1085#1080#1082#1072')'
            Options.Editing = False
            Width = 80
          end
          object MemberName3: TcxGridDBColumn
            Caption = #1056#1072#1079#1088#1077#1096#1080#1083' '#1086#1090#1075#1088#1091#1079#1082#1091
            DataBinding.FieldName = 'MemberName3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1110#1076#1087#1091#1089#1082' '#1076#1086#1079#1074#1086#1083#1080#1074
            Options.Editing = False
            Width = 80
          end
          object MemberName4: TcxGridDBColumn
            Caption = #1057#1076#1072#1083
            DataBinding.FieldName = 'MemberName4'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1076#1072#1074' ('#1074#1110#1076#1087#1086#1074#1110#1076#1072#1083#1100#1085#1072' '#1086#1089#1086#1073#1072' '#1074#1072#1085#1090#1072#1078#1086#1074#1110#1076#1087#1088#1072#1074#1085#1080#1082#1072')'
            Options.Editing = False
            Width = 80
          end
          object MemberName5: TcxGridDBColumn
            Caption = #1042#1086#1076#1080#1090#1077#1083#1100'/'#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088' ('#1087#1088#1080#1085#1103#1083')'
            DataBinding.FieldName = 'MemberName5'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1081#1085#1103#1074' '#1074#1086#1076#1110#1081'/'#1077#1082#1089#1087#1077#1076#1080#1090#1086#1088
            Options.Editing = False
            Width = 90
          end
          object MemberName6: TcxGridDBColumn
            Caption = #1042#1086#1076#1080#1090#1077#1083#1100'/'#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088' ('#1089#1076#1072#1083')'
            DataBinding.FieldName = 'MemberName6'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1076#1072#1074' '#1074#1086#1076#1110#1081'/'#1077#1082#1089#1087#1077#1076#1080#1090#1086#1088' - '#1087#1091#1089#1090#1086' '#1048#1051#1048' 1'
            Options.Editing = False
            Width = 103
          end
          object MemberName7: TcxGridDBColumn
            Caption = #1055#1088#1080#1085#1103#1083
            DataBinding.FieldName = 'MemberName7'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1081#1085#1103#1074' ('#1074#1110#1076#1087#1086#1074#1110#1076#1072#1083#1100#1085#1072' '#1086#1089#1086#1073#1072' '#1074#1072#1085#1090#1072#1078#1086#1086#1076#1077#1088#1078#1091#1074#1072#1095#1072') - '#1087#1091#1089#1090#1086
            Options.Editing = False
            Width = 80
          end
          object CityFromName: TcxGridDBColumn
            Caption = #1052#1110#1089#1090#1086' '#1055#1091#1085#1082#1090' '#1079#1072#1074#1072#1085#1090#1072#1078#1077#1085#1085#1103
            DataBinding.FieldName = 'CityFromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object CityToName: TcxGridDBColumn
            Caption = #1052#1110#1089#1090#1086' '#1055#1091#1085#1082#1090' '#1088#1086#1079#1074#1072#1085#1090#1072#1078#1077#1085#1085#1103
            DataBinding.FieldName = 'CityToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object Address_Unit: TcxGridDBColumn
            Caption = #1040#1076#1088#1077#1089#1072' '#1055#1091#1085#1082#1090' '#1079#1072#1074#1072#1085#1090#1072#1078#1077#1085#1085#1103
            DataBinding.FieldName = 'Address_Unit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 181
          end
          object isWeCar: TcxGridDBColumn
            Caption = #1043#1088#1091#1079#1086#1086#1090#1087#1088'. = '#1087#1077#1088#1077#1074#1086#1079#1095#1080#1082' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isWeCar'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1076
    ExplicitWidth = 1076
    inherited deStart: TcxDateEdit
      EditValue = 44927d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 44927d
    end
  end
  object cxLabel27: TcxLabel [2]
    Left = 722
    Top = 6
    Caption = #1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077':'
  end
  object edJuridicalBasis: TcxButtonEdit [3]
    Left = 800
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 150
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 179
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 243
  end
  inherited ActionList: TActionList
    Left = 23
    Top = 194
    inherited actMovementItemContainer: TdsdOpenForm
      Enabled = False
    end
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TTransportGoodsForm'
      FormNameParam.Value = 'TTransportGoodsForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_Sale'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TTransportGoodsForm'
      FormNameParam.Value = 'TTransportGoodsForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_Sale'
          Value = False
          Component = MasterCDS
          ComponentItem = 'MovementId_Sale'
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 41640d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
    object actSPPrintTTNProcName: TdsdExecStoredProc [22]
      Category = 'Print_TTN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReporNameTTN
      StoredProcList = <
        item
          StoredProc = spGetReporNameTTN
        end>
      Caption = 'actSPPrintTTNProcName'
    end
    object mactPrint_TTN: TMultiAction [23]
      Category = 'Print_TTN'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      ActionList = <
        item
          Action = actSPPrintTTNProcName
        end
        item
          Action = actPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      Hint = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      ImageIndex = 3
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081
      Hint = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_TTN'
      ReportNameParam.Value = 'PrintMovement_TTN'
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTTN'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.Component = FormParams
      PrinterNameParam.ComponentItem = 'ReportNameTTN'
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TMovement_PeriodDialogForm'
      FormNameParam.Value = 'TMovement_PeriodDialogForm'
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
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserJuridicalBasis
      StoredProcList = <
        item
          StoredProc = spGet_UserJuridicalBasis
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FromId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FromName'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ToId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ToName'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_Full'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber_Full'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1078#1091#1088#1085#1072#1083#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1078#1091#1088#1085#1072#1083#1072
      ImageIndex = 7
      DataSource = MasterDS
    end
    object mactSendETTN: TMultiAction
      Category = 'Send_ETTN'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_DefaultEDIN
        end
        item
          Action = actExecSelect_eTTN_Send
        end
        item
          Action = actSendETTN
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1054#1090#1087#1088#1072#1074#1080#1090#1100' e-'#1058#1058#1053'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' e-'#1058#1058#1053
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' e-'#1058#1058#1053
      ImageIndex = 85
    end
    object actSendETTN: TdsdEDINAction
      Category = 'Send_ETTN'
      MoveParams = <>
      Caption = 'actSendETTN'
      Host.Value = ''
      Host.Component = FormParams
      Host.ComponentItem = 'HostEDIN'
      Host.DataType = ftString
      Host.MultiSelectSeparator = ','
      Login.Value = ''
      Login.Component = FormParams
      Login.ComponentItem = 'UserNameEDIN'
      Login.DataType = ftString
      Login.MultiSelectSeparator = ','
      Password.Value = ''
      Password.Component = FormParams
      Password.ComponentItem = 'PasswordEDIN'
      Password.DataType = ftString
      Password.MultiSelectSeparator = ','
      Token.Value = ''
      Token.DataType = ftString
      Token.MultiSelectSeparator = ','
      Result.Value = ''
      Result.Component = FormParams
      Result.ComponentItem = 'Uuid'
      Result.DataType = ftString
      Result.MultiSelectSeparator = ','
      Error.Value = ''
      Error.Component = FormParams
      Error.ComponentItem = 'CommentError'
      Error.DataType = ftString
      Error.MultiSelectSeparator = ','
      KeyFileName.Value = ''
      KeyFileName.Component = FormParams
      KeyFileName.ComponentItem = 'FileNameKey'
      KeyFileName.DataType = ftString
      KeyFileName.MultiSelectSeparator = ','
      KeyUserName.Value = ''
      KeyUserName.Component = FormParams
      KeyUserName.ComponentItem = 'UserNameKey'
      KeyUserName.DataType = ftString
      KeyUserName.MultiSelectSeparator = ','
      HeaderDataSet = PrintHeaderCDS
      ListDataSet = PrintItemsCDS
      UpdateUuid = spUpdate_Uuid
      UpdateKATOTTG = spUpdate_Partner_KATOTTG
      UpdateError = spUpdate_CommentError
    end
    object actExecSelect_eTTN_Send: TdsdExecStoredProc
      Category = 'Send_ETTN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect_eTTN_Send
      StoredProcList = <
        item
          StoredProc = spSelect_eTTN_Send
        end>
      Caption = 'actExecSelect_eTTN_Send'
    end
    object actGet_DefaultEDIN: TdsdExecStoredProc
      Category = 'Send_ETTN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_DefaultEDIN
      StoredProcList = <
        item
          StoredProc = spGet_DefaultEDIN
        end>
      Caption = 'actGet_DefaultEDIN'
    end
    object mactSignConsignorETTN: TMultiAction
      Category = 'Send_ETTN'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_DefaultEDIN
        end
        item
          Action = actExecSelect_eTTN_Sign
        end
        item
          Action = actSignConsignorETTN
        end>
      QuestionBeforeExecute = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1100' '#1087#1086#1076#1087#1080#1089#1100' '#1075#1088#1091#1079#1086#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103' e-'#1058#1058#1053'?'
      Caption = #1055#1086#1076#1087#1080#1089#1100' '#1075#1088#1091#1079#1086#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103' e-'#1058#1058#1053
      Hint = #1055#1086#1076#1087#1080#1089#1100' '#1075#1088#1091#1079#1086#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103' e-'#1058#1058#1053
      ImageIndex = 85
    end
    object actSignConsignorETTN: TdsdEDINAction
      Category = 'Send_ETTN'
      MoveParams = <>
      Caption = 'actSendETTN'
      Host.Value = ''
      Host.Component = FormParams
      Host.ComponentItem = 'HostEDIN'
      Host.DataType = ftString
      Host.MultiSelectSeparator = ','
      Login.Value = ''
      Login.Component = FormParams
      Login.ComponentItem = 'UserNameEDIN'
      Login.DataType = ftString
      Login.MultiSelectSeparator = ','
      Password.Value = ''
      Password.Component = FormParams
      Password.ComponentItem = 'PasswordEDIN'
      Password.DataType = ftString
      Password.MultiSelectSeparator = ','
      Token.Value = ''
      Token.DataType = ftString
      Token.MultiSelectSeparator = ','
      Result.Value = ''
      Result.Component = FormParams
      Result.ComponentItem = 'Uuid'
      Result.DataType = ftString
      Result.MultiSelectSeparator = ','
      Error.Value = ''
      Error.Component = FormParams
      Error.ComponentItem = 'CommentError'
      Error.DataType = ftString
      Error.MultiSelectSeparator = ','
      KeyFileName.Value = ''
      KeyFileName.Component = FormParams
      KeyFileName.ComponentItem = 'FileNameKey'
      KeyFileName.DataType = ftString
      KeyFileName.MultiSelectSeparator = ','
      KeyUserName.Value = ''
      KeyUserName.Component = FormParams
      KeyUserName.ComponentItem = 'UserNameKey'
      KeyUserName.DataType = ftString
      KeyUserName.MultiSelectSeparator = ','
      HeaderDataSet = PrintHeaderCDS
      ListDataSet = PrintItemsCDS
      UpdateSign = spUpdate_Sign_Consignor
      UpdateError = spUpdate_CommentError
      EDINActions = edinSignConsignor
    end
    object mactSignCarrierETTN: TMultiAction
      Category = 'Send_ETTN'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_DefaultEDIN
        end
        item
          Action = actExecSelect_eTTN_Sign
        end
        item
          Action = actSignCarrierETTN
        end>
      QuestionBeforeExecute = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1100' '#1087#1086#1076#1087#1080#1089#1100' '#1087#1077#1088#1077#1074#1086#1079#1095#1080#1082#1072' e-'#1058#1058#1053'?'
      Caption = #1055#1086#1076#1087#1080#1089#1100' '#1087#1077#1088#1077#1074#1086#1079#1095#1080#1082#1072' e-'#1058#1058#1053
      Hint = #1055#1086#1076#1087#1080#1089#1100' '#1087#1077#1088#1077#1074#1086#1079#1095#1080#1082#1072' e-'#1058#1058#1053
      ImageIndex = 85
    end
    object actSignCarrierETTN: TdsdEDINAction
      Category = 'Send_ETTN'
      MoveParams = <>
      Caption = 'actSendETTN'
      Host.Value = ''
      Host.Component = FormParams
      Host.ComponentItem = 'HostEDIN'
      Host.DataType = ftString
      Host.MultiSelectSeparator = ','
      Login.Value = ''
      Login.Component = FormParams
      Login.ComponentItem = 'UserNameEDIN'
      Login.DataType = ftString
      Login.MultiSelectSeparator = ','
      Password.Value = ''
      Password.Component = FormParams
      Password.ComponentItem = 'PasswordEDIN'
      Password.DataType = ftString
      Password.MultiSelectSeparator = ','
      Token.Value = ''
      Token.DataType = ftString
      Token.MultiSelectSeparator = ','
      Result.Value = ''
      Result.Component = FormParams
      Result.ComponentItem = 'Uuid'
      Result.DataType = ftString
      Result.MultiSelectSeparator = ','
      Error.Value = ''
      Error.Component = FormParams
      Error.ComponentItem = 'CommentError'
      Error.DataType = ftString
      Error.MultiSelectSeparator = ','
      KeyFileName.Value = ''
      KeyFileName.Component = FormParams
      KeyFileName.ComponentItem = 'FileNameKey'
      KeyFileName.DataType = ftString
      KeyFileName.MultiSelectSeparator = ','
      KeyUserName.Value = ''
      KeyUserName.Component = FormParams
      KeyUserName.ComponentItem = 'UserNameKey'
      KeyUserName.DataType = ftString
      KeyUserName.MultiSelectSeparator = ','
      HeaderDataSet = PrintHeaderCDS
      ListDataSet = PrintItemsCDS
      UpdateSign = spUpdate_Sign_Carrier
      UpdateError = spUpdate_CommentError
      EDINActions = edinSignCarrier
    end
    object actDialog_TTN: TdsdOpenForm
      Category = 'Send_ETTN'
      MoveParams = <>
      Caption = 'actDialog_TTN'
      Hint = 'actDialog_TTN'
      FormName = 'TTransportGoodsForm'
      FormNameParam.Value = 'TTransportGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_Sale'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_Sale'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actExecSelect_eTTN_Sign: TdsdExecStoredProc
      Category = 'Send_ETTN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect_eTTN_Sing
      StoredProcList = <
        item
          StoredProc = spSelect_eTTN_Sing
        end>
      Caption = 'actExecSelect_eTTN_Sign'
    end
    object mactSendSingETTN: TMultiAction
      Category = 'Send_ETTN'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_DefaultEDIN
        end
        item
          Action = actExecSelect_eTTN_Send
        end
        item
          Action = actSendSignETTN
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1080' '#1087#1086#1076#1087#1080#1089#1072#1090#1100' e-'#1058#1058#1053'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1080' '#1087#1086#1076#1087#1080#1089#1072#1090#1100' e-'#1058#1058#1053
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1080' '#1087#1086#1076#1087#1080#1089#1072#1090#1100' e-'#1058#1058#1053
      ImageIndex = 85
    end
    object actSendSignETTN: TdsdEDINAction
      Category = 'Send_ETTN'
      MoveParams = <>
      Caption = 'actSendSignETTN'
      Host.Value = ''
      Host.Component = FormParams
      Host.ComponentItem = 'HostEDIN'
      Host.DataType = ftString
      Host.MultiSelectSeparator = ','
      Login.Value = ''
      Login.Component = FormParams
      Login.ComponentItem = 'UserNameEDIN'
      Login.DataType = ftString
      Login.MultiSelectSeparator = ','
      Password.Value = ''
      Password.Component = FormParams
      Password.ComponentItem = 'PasswordEDIN'
      Password.DataType = ftString
      Password.MultiSelectSeparator = ','
      Token.Value = ''
      Token.DataType = ftString
      Token.MultiSelectSeparator = ','
      Result.Value = '2'
      Result.Component = FormParams
      Result.ComponentItem = 'Uuid'
      Result.DataType = ftString
      Result.MultiSelectSeparator = ','
      Error.Value = Null
      Error.Component = FormParams
      Error.ComponentItem = 'CommentError'
      Error.DataType = ftString
      Error.MultiSelectSeparator = ','
      KeyFileName.Value = Null
      KeyFileName.Component = FormParams
      KeyFileName.ComponentItem = 'FileNameKey'
      KeyFileName.DataType = ftString
      KeyFileName.MultiSelectSeparator = ','
      KeyUserName.Value = Null
      KeyUserName.Component = FormParams
      KeyUserName.ComponentItem = 'UserNameKey'
      KeyUserName.DataType = ftString
      KeyUserName.MultiSelectSeparator = ','
      HeaderDataSet = PrintHeaderCDS
      ListDataSet = PrintItemsCDS
      UpdateUuid = spUpdate_Uuid
      UpdateSign = spUpdate_Sign_Consignor
      UpdateKATOTTG = spUpdate_Partner_KATOTTG
      UpdateError = spUpdate_CommentError
      EDINActions = edinSendSingETTN
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 139
  end
  inherited MasterCDS: TClientDataSet
    Top = 139
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TransportGoods_EDIN'
    Params = <
      item
        Name = 'instartdate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inenddate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalBasisId'
        Value = Null
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 163
  end
  inherited BarManager: TdxBarManager
    Left = 224
    Top = 155
    DockControlHeights = (
      0
      0
      35
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbComplete'
        end
        item
          Visible = True
          ItemName = 'bbUnComplete'
        end
        item
          Visible = True
          ItemName = 'bbDelete'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
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
          ItemName = 'bbChoiceGuides'
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
          ItemName = 'bbMovementProtocol'
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
          ItemName = 'bbSendETTN'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSendSingETTN'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bsSignETTN'
        end>
    end
    object bbTax: TdxBarButton
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1085#1072#1083#1086#1075#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      Category = 0
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1085#1072#1083#1086#1075#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      Visible = ivNever
      ImageIndex = 41
    end
    object bbPrint: TdxBarButton
      Action = mactPrint_TTN
      Category = 0
    end
    object bbPrintTax_Us: TdxBarButton
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbPrintTax_Client: TdxBarButton
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Visible = ivAlways
      ImageIndex = 18
    end
    object bbPrint_Bill: TdxBarButton
      Caption = #1057#1095#1077#1090
      Category = 0
      Hint = #1057#1095#1077#1090
      Visible = ivAlways
      ImageIndex = 21
    end
    object bbChoiceGuides: TdxBarButton
      Action = actChoiceGuides
      Category = 0
    end
    object bbSendETTN: TdxBarButton
      Action = mactSendETTN
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object bsSignETTN: TdxBarSubItem
      Caption = #1055#1086#1076#1087#1080#1089#1080
      Category = 0
      Visible = ivAlways
      ImageIndex = 85
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbSignConsignorETTN'
        end
        item
          Visible = True
          ItemName = 'bbSignCarrierETTN'
        end>
    end
    object bbSignConsignorETTN: TdxBarButton
      Action = mactSignConsignorETTN
      Category = 0
    end
    object bbSignCarrierETTN: TdxBarButton
      Action = mactSignCarrierETTN
      Category = 0
    end
    object bbSendSingETTN: TdxBarButton
      Action = mactSendSingETTN
      Category = 0
      PaintStyle = psCaptionGlyph
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 224
  end
  inherited PopupMenu: TPopupMenu
    Left = 640
    Top = 152
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 288
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = JuridicalBasisGuides
      end>
    Left = 320
    Top = 296
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_TransportGoods'
    Left = 80
    Top = 320
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_TransportGoods'
    Left = 80
    Top = 384
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_TransportGoods'
    Left = 208
    Top = 376
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameLoss'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameLossTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameTTN'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Uuid'
        Value = '2'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SignId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserNameKey'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FileNameKey'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CommentError'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 400
    Top = 200
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_TransportGoods'
    Left = 176
    Top = 304
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 217
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 270
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TTN_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Sale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 535
    Top = 248
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 628
    Top = 294
  end
  object JuridicalBasisGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridicalBasis
    Key = '0'
    FormNameParam.Value = 'TJuridical_BasisForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_BasisForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 719
    Top = 80
  end
  object spGet_UserJuridicalBasis: TdsdStoredProc
    StoredProcName = 'gpGet_User_JuridicalBasis'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'JuridicalBasisId'
        Value = '0'
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisName'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 904
    Top = 72
  end
  object spGetReporNameTTN: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TransportGoods_ReportName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_Movement_TransportGoods_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameTTN'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 824
    Top = 296
  end
  object spGet_DefaultEDIN: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultEDIN'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Host'
        Value = Null
        Component = FormParams
        ComponentItem = 'HostEDIN'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserNameEDIN'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Password'
        Value = Null
        Component = FormParams
        ComponentItem = 'PasswordEDIN'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 528
    Top = 352
  end
  object spSelect_eTTN_Send: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TransportGoods_EDIN_Send'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 651
    Top = 360
  end
  object spSelect_eTTN_Sing: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TransportGoods_EDIN_Sign'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 819
    Top = 352
  end
  object spUpdate_Uuid: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_TransportGoods_Uuid'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUuid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Uuid'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCommentError'
        Value = Null
        Component = FormParams
        ComponentItem = 'CommentError'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 313
    Top = 360
  end
  object spUpdate_Sign_Consignor: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_TransportGoods_Sign'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSignId'
        Value = '1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserNameKey'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserNameKey'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFileNameKey'
        Value = Null
        Component = FormParams
        ComponentItem = 'FileNameKey'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMemberSignConsignorName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MemberSignConsignorName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSignConsignorDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SignConsignorDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMemberSignCarrierName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MemberSignCarrierName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSignCarrierDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SignCarrierDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCommentError'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CommentError'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSignConsignor_eTTN'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSignConsignor_eTTN'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSignCarrier_eTTN'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSignCarrier_eTTN'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 416
  end
  object spUpdate_Sign_Carrier: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_TransportGoods_Sign'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSignId'
        Value = '2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserNameKey'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserNameKey'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFileNameKey'
        Value = Null
        Component = FormParams
        ComponentItem = 'FileNameKey'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMemberSignConsignorName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MemberSignConsignorName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSignConsignorDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SignConsignorDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMemberSignCarrierName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MemberSignCarrierName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSignCarrierDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SignCarrierDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCommentError'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CommentError'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSignConsignor_eTTN'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSignConsignor_eTTN'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSignCarrier_eTTN'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSignCarrier_eTTN'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 416
  end
  object spUpdate_CommentError: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_TransportGoods_CommentError'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCommentError'
        Value = '2'
        Component = FormParams
        ComponentItem = 'CommentError'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 632
    Top = 416
  end
  object spUpdate_Partner_KATOTTG: TdsdStoredProc
    StoredProcName = 'gpUpdateObject_Partner_KATOTTG'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ToId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKATOTTG'
        Value = '2'
        Component = FormParams
        ComponentItem = 'Uuid'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 840
    Top = 176
  end
end
