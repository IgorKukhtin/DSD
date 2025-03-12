inherited Report_GoodsForm: TReport_GoodsForm
  Caption = #1054#1090#1095#1077#1090' <'#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
  ClientHeight = 380
  ClientWidth = 1071
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1087
  ExplicitHeight = 419
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 80
    Width = 1071
    Height = 300
    TabOrder = 3
    ExplicitTop = 80
    ExplicitWidth = 1071
    ExplicitHeight = 300
    ClientRectBottom = 300
    ClientRectRight = 1071
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1071
      ExplicitHeight = 300
      inherited cxGrid: TcxGrid
        Width = 1071
        Height = 300
        ExplicitWidth = 1071
        ExplicitHeight = 300
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPartnerIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPartnerOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Change
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_Change_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_Change_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_40200
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_40200_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_40200_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Loss
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_Loss_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_Loss_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummStart_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummEnd_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountIn_weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOut_weight
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPartnerIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPartnerOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Change
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_Change_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_Change_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_40200
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_40200_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_40200_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Loss
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_Loss_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_Loss_zavod
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummStart_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummIn_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummOut_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummEnd_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_branch
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = ObjectByName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountIn_weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOut_weight
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
          object MovementDescName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'.'
            DataBinding.FieldName = 'MovementDescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperDatePartner: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'OperDatePartner'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object DayOfWeekName_doc: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1085#1077#1076'. '#1076#1072#1090#1072' '#1089#1082#1083#1072#1076
            DataBinding.FieldName = 'DayOfWeekName_doc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object DayOfWeekName_partner: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1085#1077#1076'. '#1076#1072#1090#1072' '#1076#1086#1082'.'#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'DayOfWeekName_partner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isActive: TcxGridDBColumn
            Caption = #1055#1088#1080#1093' / '#1056#1072#1089#1093
            DataBinding.FieldName = 'isActive'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object LocationDescName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1084#1077#1089#1090#1072' '#1091#1095#1077#1090#1072
            DataBinding.FieldName = 'LocationDescName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object LocationCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1084#1077#1089#1090#1072' '#1091#1095'.'
            DataBinding.FieldName = 'LocationCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object LocationName: TcxGridDBColumn
            Caption = #1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072
            DataBinding.FieldName = 'LocationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object CarCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1072#1074#1090#1086#1084'.'
            DataBinding.FieldName = 'CarCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object CarName: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
            DataBinding.FieldName = 'CarName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ObjectByDescName: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'ObjectByDescName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ObjectByCode: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1086#1090' '#1082#1086#1075#1086' / '#1050#1086#1084#1091')'
            DataBinding.FieldName = 'ObjectByCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object ObjectByName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086' / '#1050#1086#1084#1091
            DataBinding.FieldName = 'ObjectByName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 250
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'
            DataBinding.FieldName = 'GoodsCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsKindName_complete: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1043#1055')'
            DataBinding.FieldName = 'GoodsKindName_complete'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Name_Scale: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' (Scale)'
            DataBinding.FieldName = 'Name_Scale'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PartionGoods: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object StorageName: TcxGridDBColumn
            Caption = #1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103' ('#1087#1072#1088#1090#1080#1103')'
            DataBinding.FieldName = 'StorageName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object Unit_Partion: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1087#1072#1088#1090#1080#1103' '#1087#1088#1080#1093#1086#1076#1072')'
            DataBinding.FieldName = 'Unit_Partion'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object PartionModelName: TcxGridDBColumn
            Caption = #1052#1086#1076#1077#1083#1100' ('#1087#1072#1088#1090#1080#1103' '#1087#1088#1080#1093#1086#1076#1072')'
            DataBinding.FieldName = 'PartionModelName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object BranchName_Partion: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083' ('#1087#1072#1088#1090#1080#1103' '#1087#1088#1080#1093#1086#1076#1072')'
            DataBinding.FieldName = 'BranchName_Partion'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object PartNumber_Partion: TcxGridDBColumn
            Caption = #1057#1077#1088#1080#1081#1085#1099#1081' '#1085#1086#1084#1077#1088' ('#8470' '#1087#1086' '#1090#1077#1093' '#1087#1072#1089#1087#1086#1088#1090#1091')'
            DataBinding.FieldName = 'PartNumber_Partion'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' c/c '#1079#1072#1074#1086#1076
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Price_branch: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' c/c '#1092#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'Price_branch'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Price_end: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' c/c '#1079#1072#1074#1086#1076' '#1086#1089#1090'. '#1082#1086#1085#1077#1095'.'
            DataBinding.FieldName = 'Price_end'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Price_branch_end: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' c/c '#1092#1080#1083#1080#1072#1083' '#1086#1089#1090'. '#1082#1086#1085#1077#1095'.'
            DataBinding.FieldName = 'Price_branch_end'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Price_partner: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
            DataBinding.FieldName = 'Price_partner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object AmountStart: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountStart_weight: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1074#1077#1089
            DataBinding.FieldName = 'AmountStart_weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummStart: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1089#1091#1084#1084#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076
            DataBinding.FieldName = 'SummStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummStart_branch: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1089#1091#1084#1084#1072' '#1089'/'#1089' '#1092#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'SummStart_branch'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountIn: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountIn_weight: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1074#1077#1089
            DataBinding.FieldName = 'AmountIn_weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummIn: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1089#1091#1084#1084#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076
            DataBinding.FieldName = 'SummIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummIn_branch: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1089#1091#1084#1084#1072' '#1089'/'#1089' '#1092#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'SummIn_branch'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountOut: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountOut_weight: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1074#1077#1089
            DataBinding.FieldName = 'AmountOut_weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummOut: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1089#1091#1084#1084#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076
            DataBinding.FieldName = 'SummOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummOut_branch: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1089#1091#1084#1084#1072' '#1089'/'#1089' '#1092#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'SummOut_branch'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountEnd: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountEnd_weight: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1074#1077#1089
            DataBinding.FieldName = 'AmountEnd_weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object SummEnd: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1089#1091#1084#1084#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076
            DataBinding.FieldName = 'SummEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummEnd_branch: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1082#1086#1085#1077#1095'. '#1089#1091#1084#1084#1072' '#1089'/'#1089' '#1092#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'SummEnd_branch'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummPartnerIn: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1089#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'SummPartnerIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummPartnerOut: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1089#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'SummPartnerOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object GoodsCode_parent: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1088'. '#1087#1088#1080#1093'.'
            DataBinding.FieldName = 'GoodsCode_parent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object GoodsName_parent: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsName_parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object GoodsKindName_parent: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1088'. '#1087#1088#1080#1093'.)'
            DataBinding.FieldName = 'GoodsKindName_parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object PersonalGroupName: TcxGridDBColumn
            Caption = #1041#1088#1080#1075#1072#1076#1072
            DataBinding.FieldName = 'PersonalGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount_Change: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074#1077#1089'  ('#1089#1082'.1%)'
            DataBinding.FieldName = 'Amount_Change'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Summ_Change_branch: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1092#1083'. ('#1089#1082'.1%)'
            DataBinding.FieldName = 'Summ_Change_branch'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Summ_Change_zavod: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076' ('#1089#1082'.1%)'
            DataBinding.FieldName = 'Summ_Change_zavod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount_40200: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074#1077#1089' (-)'#1091#1073#1099#1083#1100' (+)'#1101#1082#1086#1085#1086#1084'.'
            DataBinding.FieldName = 'Amount_40200'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Summ_40200_branch: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1092#1083'. (-)'#1091#1073#1099#1083#1100' (+)'#1101#1082#1086#1085#1086#1084'.'
            DataBinding.FieldName = 'Summ_40200_branch'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Summ_40200_zavod: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089'/'#1089' '#1079#1072#1074#1086#1076' (-)'#1091#1073#1099#1083#1100' (+)'#1101#1082#1086#1085#1086#1084'.'
            DataBinding.FieldName = 'Summ_40200_zavod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Amount_Loss: TcxGridDBColumn
            Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount_Loss'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Summ_Loss_branch: TcxGridDBColumn
            Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1089#1091#1084#1084#1072' '#1089'/'#1089' ('#1092#1083'.)'
            DataBinding.FieldName = 'Summ_Loss_branch'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Summ_Loss_zavod: TcxGridDBColumn
            Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1089#1091#1084#1084#1072' '#1089'/'#1089' ('#1079#1072#1074#1086#1076')'
            DataBinding.FieldName = 'Summ_Loss_zavod'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MovementDescName_order: TcxGridDBColumn
            DataBinding.FieldName = 'MovementDescName_order'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 55
          end
          object Amount: TcxGridDBColumn
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 55
          end
          object Summ: TcxGridDBColumn
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 55
          end
          object Summ_branch: TcxGridDBColumn
            DataBinding.FieldName = 'Summ_branch'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 55
          end
          object MovementId: TcxGridDBColumn
            DataBinding.FieldName = 'MovementId'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 55
          end
          object isRemains: TcxGridDBColumn
            DataBinding.FieldName = 'isRemains'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 55
          end
          object isRePrice: TcxGridDBColumn
            DataBinding.FieldName = 'isRePrice'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object isInv: TcxGridDBColumn
            DataBinding.FieldName = 'isInv'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object isPage3: TcxGridDBColumn
            DataBinding.FieldName = 'isPage3'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object isExistsPage3: TcxGridDBColumn
            DataBinding.FieldName = 'isExistsPage3'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object isPeresort: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072
            DataBinding.FieldName = 'isPeresort'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072' '#1044#1072'/'#1053#1077#1090
            Options.Editing = False
            Width = 40
          end
          object PersonalKVKName: TcxGridDBColumn
            Caption = #1054#1087#1077#1088#1072#1090#1086#1088' '#1050#1042#1050' ('#1060'.'#1048'.'#1054')'
            DataBinding.FieldName = 'PersonalKVKName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object PositionName_KVK: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1054#1087'. '#1050#1042#1050')'
            DataBinding.FieldName = 'PositionName_KVK'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1054#1087#1077#1088#1072#1090#1086#1088' '#1050#1042#1050')'
            Options.Editing = False
            Width = 78
          end
          object UnitName_KVK: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1054#1087'. '#1050#1042#1050')'
            DataBinding.FieldName = 'UnitName_KVK'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1054#1087#1077#1088#1072#1090#1086#1088' '#1050#1042#1050')'
            Options.Editing = False
            Width = 83
          end
          object KVK: TcxGridDBColumn
            Caption = #8470' '#1050#1042#1050
            DataBinding.FieldName = 'KVK'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InvNumber_Full: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082' '#1040#1082#1094#1080#1103
            DataBinding.FieldName = 'InvNumber_Full'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object StartSale_promo: TcxGridDBColumn
            Caption = #1054#1090#1075#1088#1091#1079#1082#1072' '#1089
            DataBinding.FieldName = 'StartSale_promo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1075#1088#1091#1079#1082#1072' '#1089'  ('#1040#1082#1094#1080#1103')'
            Options.Editing = False
            Width = 70
          end
          object EndSale_promo: TcxGridDBColumn
            Caption = #1054#1090#1075#1088#1091#1079#1082#1072' '#1087#1086
            DataBinding.FieldName = 'EndSale_promo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1075#1088#1091#1079#1082#1072' '#1087#1086' ('#1040#1082#1094#1080#1103')'
            Options.Editing = False
            Width = 70
          end
          object OperDate_Protocol: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077')'
            DataBinding.FieldName = 'OperDate_Protocol'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1087#1086#1089#1083#1077#1076#1085#1077#1077' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072')'
            Options.Editing = False
            Width = 100
          end
          object UserName_Protocol: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077')'
            DataBinding.FieldName = 'UserName_Protocol'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1087#1086#1089#1083#1077#1076#1085#1077#1077' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072')'
            Options.Editing = False
            Width = 100
          end
          object OperDate_Protocol_auto: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1072#1074#1090#1086'-'#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077')'
            DataBinding.FieldName = 'OperDate_Protocol_auto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1087#1086#1089#1083#1077#1076#1085#1077#1077' '#1072#1074#1090#1086'-'#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072')'
            Options.Editing = False
            Width = 120
          end
          object UserName_Protocol_auto: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1072#1074#1090#1086'-'#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077')'
            DataBinding.FieldName = 'UserName_Protocol_auto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1087#1086#1089#1083#1077#1076#1085#1077#1077' '#1072#1074#1090#1086'-'#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072')'
            Options.Editing = False
            Width = 120
          end
          object OperDate_Insert: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'OperDate_Insert'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object UserName_Insert: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'UserName_Insert'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object PartionCellName: TcxGridDBColumn
            Caption = #1071#1095#1077#1081#1082#1072
            DataBinding.FieldName = 'PartionCellName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object isPartionCell_Close: TcxGridDBColumn
            Caption = #1045#1089#1090#1100' '#1054#1089#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionCell_Close'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1086#1085#1095#1080#1083#1089#1103' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1071#1095#1077#1077#1082' ('#1076#1072'/'#1085#1077#1090')'
            Width = 60
          end
          object OperDate_Protocol_mi: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'OperDate_Protocol_mi'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1087#1086#1089#1083#1077#1076#1085#1077#1077' '#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1090#1088#1086#1095#1085#1086#1081' '#1095#1072#1089#1090#1080')'
            Width = 80
          end
          object UserName_Protocol_mi: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UserName_Protocol_mi'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1087#1086#1089#1083#1077#1076#1085#1077#1077' '#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1090#1088#1086#1095#1085#1086#1081' '#1095#1072#1089#1090#1080')'
            Width = 70
          end
        end
      end
      object cbSumm_branch: TcxCheckBox
        Left = 69
        Top = 3
        Caption = #1087#1077#1095#1072#1090#1100' '#1089'/'#1089' '#1092#1080#1083#1080#1072#1083
        Properties.ReadOnly = False
        TabOrder = 1
        Width = 125
      end
    end
  end
  inherited Panel: TPanel
    Width = 1071
    Height = 54
    ExplicitWidth = 1071
    ExplicitHeight = 54
    inherited deStart: TcxDateEdit
      Left = 118
      EditValue = 43101d
      Properties.SaveTime = False
      ExplicitLeft = 118
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 30
      EditValue = 43101d
      Properties.SaveTime = False
      ExplicitLeft = 118
      ExplicitTop = 30
    end
    inherited cxLabel1: TcxLabel
      Left = 25
      ExplicitLeft = 25
    end
    inherited cxLabel2: TcxLabel
      Left = 6
      Top = 31
      ExplicitLeft = 6
      ExplicitTop = 31
    end
    object cxLabel3: TcxLabel
      Left = 589
      Top = 31
      Caption = #1058#1086#1074#1072#1088
    end
    object edGoods: TcxButtonEdit
      Left = 629
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 300
    end
    object cxLabel4: TcxLabel
      Left = 244
      Top = 31
      Caption = #1052#1077#1089#1090#1086' '#1091#1095#1077#1090#1072':'
    end
    object edLocation: TcxButtonEdit
      Left = 318
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 210
    end
    object cxLabel5: TcxLabel
      Left = 538
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 629
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 300
    end
    object cxLabel8: TcxLabel
      Left = 209
      Top = 6
      Caption = #1043#1088'. '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081':'
    end
    object edUnitGroup: TcxButtonEdit
      Left = 318
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 210
    end
    object cbPartner: TcxCheckBox
      Left = 938
      Top = 5
      Caption = #1055#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084
      Properties.ReadOnly = False
      State = cbsChecked
      TabOrder = 12
      Width = 113
    end
    object cbPapty: TcxCheckBox
      Left = 938
      Top = 30
      Caption = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Properties.ReadOnly = False
      TabOrder = 13
      Width = 95
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cbPartner
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbSumm_branch
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
        Component = GoodsGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GoodsGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesUnitGroup
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = LocationGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = cbPapty
        Properties.Strings = (
          'Checked')
      end>
  end
  inherited ActionList: TActionList
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'MovementDescName_order;OperDate;ObjectByName;InvNumber'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = Null
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = LocationGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = Null
          Component = GoodsGroupGuides
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GoodsGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isSumm_branch'
          Value = Null
          Component = cbSumm_branch
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091' '#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_GoodsDialogForm'
      FormNameParam.Value = 'TReport_GoodsDialogForm'
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
          Name = 'GoodsId'
          Value = ''
          Component = GoodsGuides
          ComponentItem = 'Key'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GoodsGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'Key'
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
          Name = 'UnitGroupId'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = GuidesUnitGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationId'
          Value = ''
          Component = LocationGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
          Component = LocationGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartner'
          Value = False
          Component = cbPartner
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPapty'
          Value = Null
          Component = cbPapty
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementForm
      StoredProcList = <
        item
          StoredProc = getMovementForm
        end>
      Caption = 'actGetForm'
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormName = 'NULL'
      FormNameParam.Value = Null
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
          Name = 'inChangePercentAmount'
          Value = 0.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetForm
        end
        item
          Action = actOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 28
    end
    object actMovementReComplete: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementReComplete
      StoredProcList = <
        item
          StoredProc = spMovementReComplete
        end>
      Caption = 'actMovementReComplete'
      ImageIndex = 66
    end
    object macMovementReComplete_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actMovementReComplete
        end>
      View = cxGridDBTableView
      Caption = 'macMovementReComplete_list'
      ImageIndex = 66
    end
    object macMovementReComplete: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macMovementReComplete_list
        end>
      QuestionBeforeExecute = #1041#1091#1076#1091#1090' '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1099' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099', '#1087#1088#1086#1076#1086#1083#1078#1080#1090#1100'?'
      InfoAfterExecute = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1079#1072#1074#1077#1088#1096#1077#1085#1086
      Caption = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      ImageIndex = 66
    end
    object MovementProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = ''
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
          Name = 'InvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
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
    StoredProcName = 'gpReport_Goods'
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
        Name = 'inUnitGroupId'
        Value = Null
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLocationId'
        Value = ''
        Component = LocationGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = Null
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPartner'
        Value = Null
        Component = cbPartner
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPartion'
        Value = Null
        Component = cbPapty
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 144
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
          ItemName = 'bbOpenDocument'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSumm_branch'
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
          ItemName = 'bbMovementReComplete'
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
          ItemName = 'bbMovementProtocolOpenForm'
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
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbSumm_branch: TdxBarControlContainerItem
      Caption = 'bbSumm_branch'
      Category = 0
      Hint = 'bbSumm_branch'
      Visible = ivAlways
      Control = cbSumm_branch
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbOpenDocument: TdxBarButton
      Action = actOpenDocument
      Category = 0
    end
    object bbMovementReComplete: TdxBarButton
      Action = macMovementReComplete
      Category = 0
    end
    object bbMovementProtocolOpenForm: TdxBarButton
      Action = MovementProtocolOpenForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 368
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 80
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesUnitGroup
      end
      item
        Component = LocationGuides
      end
      item
        Component = GoodsGroupGuides
      end
      item
        Component = GoodsGuides
      end>
    Left = 184
    Top = 136
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 712
    Top = 27
  end
  object LocationGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLocation
    FormNameParam.Value = 'TStoragePlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TStoragePlace_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = LocationGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = LocationGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 176
  end
  object GuidesUnitGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnitGroup
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnitGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 384
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
    Left = 792
  end
  object getMovementForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
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
      end
      item
        Name = 'FormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 632
    Top = 200
  end
  object TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 120
  end
  object TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 120
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'FormName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate'
        Value = 43101d
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 43101d
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitGroupId'
        Value = Null
        Component = GuidesUnitGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitGroupName'
        Value = Null
        Component = GuidesUnitGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LocationId'
        Value = Null
        Component = LocationGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'LocationName'
        Value = Null
        Component = LocationGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupId'
        Value = Null
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = Null
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = Null
        Component = GoodsGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = Null
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsPartner'
        Value = Null
        Component = cbPartner
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 200
  end
  object spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_byReport'
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
    Left = 849
    Top = 202
  end
end
