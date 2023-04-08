inherited Report_PersonalService_RecalcForm: TReport_PersonalService_RecalcForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1085#1080#1103#1084' ('#1076#1083#1103' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1047#1055')>'
  ClientHeight = 483
  ClientWidth = 1077
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1093
  ExplicitHeight = 522
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 91
    Width = 1077
    Height = 392
    TabOrder = 3
    ExplicitTop = 91
    ExplicitWidth = 1077
    ExplicitHeight = 392
    ClientRectBottom = 392
    ClientRectRight = 1077
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1077
      ExplicitHeight = 392
      inherited cxGrid: TcxGrid
        Width = 1077
        Height = 392
        ExplicitWidth = 1077
        ExplicitHeight = 392
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAddOthRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardSecondRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummNalogRetRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummChildRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHospOthRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummFineOthRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummMinusExtRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummNalogRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCompensationRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAvanceRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardRecalc
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAddOthRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardSecondRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummNalogRetRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummChildRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHospOthRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummFineOthRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummMinusExtRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummNalogRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCompensationRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAvanceRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardRecalc
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = PersonalName
            end>
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code1C: TcxGridDBColumn
            Caption = #1050#1086#1076' 1'#1057
            DataBinding.FieldName = 'Code1C'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object PersonalCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'PersonalCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PersonalName: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object PositionName: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PersonalServiceListName: TcxGridDBColumn
            Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' ('#1076#1086#1082'.)'
            DataBinding.FieldName = 'PersonalServiceListName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 140
          end
          object PersonalServiceListName_mi: TcxGridDBColumn
            Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' ('#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1041#1053')'
            DataBinding.FieldName = 'PersonalServiceListName_mi'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 140
          end
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1076#1088'.'
            DataBinding.FieldName = 'UnitCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object INN: TcxGridDBColumn
            Caption = #1048#1053#1053
            DataBinding.FieldName = 'INN'
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
            VisibleForCustomization = False
            Width = 70
          end
          object IsMain: TcxGridDBColumn
            Caption = #1054#1089#1085#1086#1074'. '#1084#1077#1089#1090#1086' '#1088'.'
            DataBinding.FieldName = 'isMain'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object IsOfficial: TcxGridDBColumn
            Caption = #1054#1092#1086#1088#1084#1083'. '#1086#1092#1080#1094'.'
            DataBinding.FieldName = 'isOfficial'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object DateIn: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1080#1077#1084#1072
            DataBinding.FieldName = 'DateIn'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object DateOut: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'DateOut'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object SummNalog: TcxGridDBColumn
            Caption = #1053#1072#1083#1086#1075#1080' - '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1089' '#1047#1055' '
            DataBinding.FieldName = 'SummNalog'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummCard: TcxGridDBColumn
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' - 1'#1092'. '
            DataBinding.FieldName = 'SummCard'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummCardSecond: TcxGridDBColumn
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' - 2'#1092'.'
            DataBinding.FieldName = 'SummCardSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummAddOth: TcxGridDBColumn
            Caption = #1055#1088#1077#1084#1080#1103' ('#1088#1072#1089#1087#1088#1077#1076'.)'
            DataBinding.FieldName = 'SummAddOth'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummNalogRet: TcxGridDBColumn
            Caption = #1053#1072#1083#1086#1075#1080' - '#1074#1086#1079#1084#1077#1097#1077#1085#1080#1077' '#1082' '#1047#1055
            DataBinding.FieldName = 'SummNalogRet'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummChild: TcxGridDBColumn
            Caption = #1040#1083#1080#1084#1077#1085#1090#1099' - '#1091#1076#1077#1088#1078#1072#1085#1080#1077
            DataBinding.FieldName = 'SummChild'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SummHospOth: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1086#1083#1100#1085#1080#1095'. ('#1088#1072#1089#1087#1088'.)'
            DataBinding.FieldName = 'SummHospOth'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1073#1086#1083#1100#1085#1080#1095#1085#1099#1077' ('#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086')'
            Options.Editing = False
            Width = 75
          end
          object SummFineOth: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072' ('#1088#1072#1089#1087#1088'.)'
            DataBinding.FieldName = 'SummFineOth'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072' ('#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086')'
            Options.Editing = False
            Width = 75
          end
          object SummMinusExt: TcxGridDBColumn
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1089#1090#1086#1088#1086#1085'. '#1102#1088'.'#1083'.'
            DataBinding.FieldName = 'SummMinusExt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SummCompensation: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1082#1086#1084#1087'. '#1079#1072' '#1085#1077#1080#1089#1087'. '#1086#1090#1087'.'
            DataBinding.FieldName = 'SummCompensation'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080' '#1079#1072' '#1085#1077#1080#1089#1087'.'#1086#1090#1087#1091#1089#1082
            Options.Editing = False
            Width = 75
          end
          object SummAvance: TcxGridDBColumn
            Caption = #1040#1074#1072#1085#1089' ('#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086')'
            DataBinding.FieldName = 'SummAvance'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SummAddOthRecalc: TcxGridDBColumn
            Caption = #1055#1088#1077#1084#1080#1103' ('#1074#1074#1086#1076' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076'.) ('#1090#1077#1082'.'#1076#1086#1082'.)'
            DataBinding.FieldName = 'SummAddOthRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1077#1084#1080#1103' ('#1074#1074#1086#1076' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103')'
            Width = 70
          end
          object SummCardSecondRecalc: TcxGridDBColumn
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'. ('#1090#1077#1082'.'#1076#1086#1082'.) '
            DataBinding.FieldName = 'SummCardSecondRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummNalogRetRecalc: TcxGridDBColumn
            Caption = #1053#1072#1083#1086#1075#1080' - '#1074#1086#1079#1084#1077#1097#1077#1085#1080#1077' '#1082' '#1047#1055' ('#1074#1074#1086#1076')  ('#1090#1077#1082'.'#1076#1086#1082'.)'
            DataBinding.FieldName = 'SummNalogRetRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummChildRecalc: TcxGridDBColumn
            Caption = #1040#1083#1080#1084#1077#1085#1090#1099' - '#1091#1076#1077#1088#1078#1072#1085#1080#1077' ('#1074#1074#1086#1076')  ('#1090#1077#1082'.'#1076#1086#1082'.) '
            DataBinding.FieldName = 'SummChildRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object SummHospOthRecalc: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1086#1083#1100#1085#1080#1095'. ('#1074#1074#1086#1076') ('#1090#1077#1082'.'#1076#1086#1082'.)'
            DataBinding.FieldName = 'SummHospOthRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1073#1086#1083#1100#1085#1080#1095#1085#1099#1077' ('#1074#1074#1086#1076' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103')'
            Width = 75
          end
          object SummFineOthRecalc: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072' ('#1074#1074#1086#1076') ('#1090#1077#1082'.'#1076#1086#1082'.)'
            DataBinding.FieldName = 'SummFineOthRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072' ('#1074#1074#1086#1076' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103')'
            Width = 75
          end
          object SummMinusExtRecalc: TcxGridDBColumn
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1089#1090#1086#1088#1086#1085'. '#1102#1088'.'#1083'. ('#1074#1074#1086#1076') ('#1090#1077#1082'.'#1076#1086#1082'.)'
            DataBinding.FieldName = 'SummMinusExtRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object SummNalogRecalc: TcxGridDBColumn
            Caption = #1053#1072#1083#1086#1075#1080' - '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1089' '#1047#1055' ('#1074#1074#1086#1076')('#1090#1077#1082'.'#1076#1086#1082'.)'
            DataBinding.FieldName = 'SummNalogRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummCompensationRecalc: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1082#1086#1084#1087'. '#1079#1072' '#1085#1077#1080#1089#1087'. '#1086#1090#1087'. ('#1074#1074#1086#1076') ('#1090#1077#1082'.'#1076#1086#1082'.)'
            DataBinding.FieldName = 'SummCompensationRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080' '#1079#1072' '#1085#1077#1080#1089#1087'.'#1086#1090#1087#1091#1089#1082' ('#1074#1074#1086#1076')'
            Width = 75
          end
          object SummAvanceRecalc: TcxGridDBColumn
            Caption = #1040#1074#1072#1085#1089' ('#1074#1074#1086#1076' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103') ('#1090#1077#1082'.'#1076#1086#1082'.)'
            DataBinding.FieldName = 'SummAvanceRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object SummCardRecalc: TcxGridDBColumn
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 1'#1092'. ('#1090#1077#1082'.'#1076#1086#1082'.)'
            DataBinding.FieldName = 'SummCardRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object FineSubjectName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1085#1072#1088#1091#1096#1077#1085#1080#1081
            DataBinding.FieldName = 'FineSubjectName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object UnitFineSubjectName: TcxGridDBColumn
            Caption = #1050#1077#1084' '#1085#1072#1083#1072#1075#1072#1077#1090#1089#1103' '#1074#1079#1099#1089#1082#1072#1085#1080#1077
            DataBinding.FieldName = 'UnitFineSubjectName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1077#1084' '#1085#1072#1083#1072#1075#1072#1077#1090#1089#1103' '#1074#1079#1099#1089#1082#1072#1085#1080#1077
            Width = 70
          end
          object MemberName: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1040#1083#1080#1084#1077#1085#1090#1099')'
            DataBinding.FieldName = 'MemberName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1077
    Height = 65
    ExplicitWidth = 1077
    ExplicitHeight = 65
    inherited deStart: TcxDateEdit
      Left = 992
      Top = 15
      EditValue = 42522d
      Properties.SaveTime = False
      Visible = False
      ExplicitLeft = 992
      ExplicitTop = 15
    end
    inherited deEnd: TcxDateEdit
      Left = 992
      Top = 44
      EditValue = 42522d
      Properties.SaveTime = False
      Visible = False
      ExplicitLeft = 992
      ExplicitTop = 44
    end
    inherited cxLabel1: TcxLabel
      Left = 895
      Top = 21
      Visible = False
      ExplicitLeft = 895
      ExplicitTop = 21
    end
    inherited cxLabel2: TcxLabel
      Left = 880
      Top = 45
      Visible = False
      ExplicitLeft = 880
      ExplicitTop = 45
    end
    object cxLabel5: TcxLabel
      Left = 2
      Top = 10
      Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edInvNumber: TcxTextEdit
      Left = 2
      Top = 28
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 114
    end
    object edOperDate: TcxDateEdit
      Left = 122
      Top = 28
      EditValue = 44998d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 6
      Width = 100
    end
    object cxLabel4: TcxLabel
      Left = 122
      Top = 10
      Caption = #1044#1072#1090#1072
    end
    object cxLabel6: TcxLabel
      Left = 232
      Top = 10
      Caption = #1052#1077#1089#1103#1094' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081
    end
    object edServiceDate: TcxDateEdit
      Left = 232
      Top = 28
      EditValue = 41640d
      Properties.DisplayFormat = 'mmmm yyyy'
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 9
      Width = 97
    end
    object cxLabel3: TcxLabel
      Left = 336
      Top = 10
      Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100
    end
    object edPersonalServiceList: TcxButtonEdit
      Left = 336
      Top = 28
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 289
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 320
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 48
  end
  inherited ActionList: TActionList
    Left = 623
    Top = 279
    inherited actRefresh: TdsdDataSetRefresh
      TabSheet = tsMain
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Check_ReturnInToSaleDialogForm'
      FormNameParam.Value = 'TReport_Check_ReturnInToSaleDialogForm'
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
        end
        item
          Name = 'PartnerId'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalId'
          Value = ''
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inShowAll'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inInvNumber'
          Value = Null
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actOpenMovementForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'>'
      ImageIndex = 28
      FormName = 'TPersonalServiceForm'
      FormNameParam.Value = 'TPersonalServiceForm'
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
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
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
        end>
      isShowModal = False
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
    StoredProcName = 'gpReport_PersonalService_Recalc'
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
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inMovementId'
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
          ItemName = 'bbOpenMovementForm'
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
    object bbOpenMovementForm: TdxBarButton
      Action = actOpenMovementForm
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'>'
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 648
    Top = 208
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 960
    Top = 24
  end
  inherited RefreshDispatcher: TRefreshDispatcher
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
      end>
    Left = 560
    Top = 208
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inPersonalServiceListName'
        Value = Null
        Component = GuidesPersonalServiceList
        ComponentItem = 'TextValue'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalServiceListId'
        Value = Null
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inServiceDate'
        Value = Null
        Component = edServiceDate
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = Null
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 320
    Top = 154
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 256
    Top = 208
  end
  object GuidesPersonalServiceList: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalServiceList
    DisableGuidesOpen = True
    isShowModal = True
    FormNameParam.Value = 'TPersonalServiceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalServiceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalServiceList
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 408
    Top = 21
  end
end
