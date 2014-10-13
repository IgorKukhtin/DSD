inherited Report_JuridicalSoldForm: TReport_JuridicalSoldForm
  Caption = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1102#1088'.'#1083#1080#1094#1072#1084'>'
  ClientHeight = 555
  ClientWidth = 1044
  ExplicitLeft = -62
  ExplicitWidth = 1060
  ExplicitHeight = 590
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 1044
    Height = 472
    TabOrder = 3
    ExplicitTop = 83
    ExplicitWidth = 1044
    ExplicitHeight = 472
    ClientRectBottom = 472
    ClientRectRight = 1044
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1044
      ExplicitHeight = 472
      inherited cxGrid: TcxGrid
        Width = 1044
        Height = 472
        ExplicitWidth = 1044
        ExplicitHeight = 472
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colStartAmount_A
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colEndAmount_A
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSaleSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colServiceSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colMoneySumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colOtherSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colStartAmount_P
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colStartAmountD
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colStartAmountK
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colIncomeSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colReturnOutSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colReturnInSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSendDebtSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colEndAmount_P
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colEndAmount_D
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colEndAmount_K
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colDebetSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colKreditSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSaleRealSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colReturnInRealSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colTransferDebtSumm
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colStartAmount_A
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colEndAmount_A
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSaleSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colServiceSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colMoneySumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colOtherSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colStartAmount_P
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colStartAmountD
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colStartAmountK
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colIncomeSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colReturnOutSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colReturnInSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSendDebtSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colEndAmount_P
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colEndAmount_D
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colEndAmount_K
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colDebetSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colKreditSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSaleRealSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colReturnInRealSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colTransferDebtSumm
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colAreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085
            DataBinding.FieldName = 'AreaName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colBranchCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1092#1083'.'
            DataBinding.FieldName = 'BranchCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object colBranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object clJuridicalGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'JuridicalGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colJuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1102#1088'.'#1083'.'
            DataBinding.FieldName = 'JuridicalCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 142
          end
          object colOKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clPartnerCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
            DataBinding.FieldName = 'PartnerCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object clPartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colPaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clContractStateKindName: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractStateKindCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1055#1086#1076#1087#1080#1089#1072#1085
                ImageIndex = 12
                Value = 1
              end
              item
                Description = #1053#1077' '#1087#1086#1076#1087#1080#1089#1072#1085
                ImageIndex = 11
                Value = 2
              end
              item
                Description = #1047#1072#1074#1077#1088#1096#1077#1085
                ImageIndex = 13
                Value = 3
              end
              item
                Description = #1059' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
                ImageIndex = 66
                Value = 4
              end>
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colContractNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colStartDate: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088' '#1089
            DataBinding.FieldName = 'StartDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colEndDate: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088' '#1076#1086
            DataBinding.FieldName = 'EndDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clPersonalName: TcxGridDBColumn
            Caption = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object clPersonalTradeName: TcxGridDBColumn
            Caption = #1058#1055' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalTradeName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clPersonalCollationName: TcxGridDBColumn
            Caption = #1041#1091#1093#1075'.'#1089#1074#1077#1088#1082#1072' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalCollationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colInfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colInfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colInfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colInfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colContractConditionKindName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1077' '#1073#1086#1085#1091#1089
            DataBinding.FieldName = 'ContractConditionKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object colContractConditionValue: TcxGridDBColumn
            Caption = #1047#1085#1072#1095'. '#1073#1086#1085#1091#1089
            DataBinding.FieldName = 'ContractConditionValue'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colStartAmount_A: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1076#1086#1083#1075' ('#1040#1082#1090#1080#1074')'
            DataBinding.FieldName = 'StartAmount_A'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colStartAmount_P: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1076#1086#1083#1075' ('#1055#1072#1089#1089#1080#1074')'
            DataBinding.FieldName = 'StartAmount_P'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colStartAmountD: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1089#1072#1083#1100#1076#1086' ('#1044#1077#1073#1077#1090')'
            DataBinding.FieldName = 'StartAmountD'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colStartAmountK: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1089#1072#1083#1100#1076#1086' ('#1050#1088#1077#1076#1080#1090')'
            DataBinding.FieldName = 'StartAmountK'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colIncomeSumm: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'IncomeSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colReturnOutSumm: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090'-'#1082#1091'.'
            DataBinding.FieldName = 'ReturnOutSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colSaleRealSumm: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072
            DataBinding.FieldName = 'SaleRealSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colSaleSumm: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072' ('#1073#1091#1093#1075'.)'
            DataBinding.FieldName = 'SaleSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colReturnInRealSumm: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082'.'
            DataBinding.FieldName = 'ReturnInRealSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colReturnInSumm: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082'. ('#1073#1091#1093#1075'.)'
            DataBinding.FieldName = 'ReturnInSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colMoneySumm: TcxGridDBColumn
            Caption = #1054#1087#1083#1072#1090#1072' (+)'#1087#1088#1080#1093' (-)'#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'MoneySumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colServiceSumm: TcxGridDBColumn
            Caption = #1059#1089#1083#1091#1075#1080'. (+)'#1087#1086#1083#1091#1095'. (-)'#1086#1082#1072#1079#1072#1085'.'
            DataBinding.FieldName = 'ServiceSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colTransferDebtSumm: TcxGridDBColumn
            Caption = #1055'.'#1076#1086#1083#1075#1072' (+)'#1087#1088#1086#1076'. (-)'#1074#1086#1079#1074#1088'.'
            DataBinding.FieldName = 'TransferDebtSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colSendDebtSumm: TcxGridDBColumn
            Caption = #1042#1079'-'#1079#1072#1095#1077#1090' (+)'#1086#1087#1083'.'#1087#1088#1080#1093'. (-)'#1086#1087#1083'.'#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'SendDebtSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colOtherSumm: TcxGridDBColumn
            Caption = '***'
            DataBinding.FieldName = 'OtherSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colDebetSumm: TcxGridDBColumn
            Caption = #1054#1073#1086#1088#1086#1090' '#1044#1077#1073#1077#1090
            DataBinding.FieldName = 'DebetSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colKreditSumm: TcxGridDBColumn
            Caption = #1054#1073#1086#1088#1086#1090' '#1050#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'KreditSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colEndAmount_A: TcxGridDBColumn
            Caption = #1050#1086#1085'. '#1076#1086#1083#1075' ('#1040#1082#1090#1080#1074')'
            DataBinding.FieldName = 'EndAmount_A'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colEndAmount_P: TcxGridDBColumn
            Caption = #1050#1086#1085'.  '#1076#1086#1083#1075' ('#1055#1072#1089#1089#1080#1074')'
            DataBinding.FieldName = 'EndAmount_P'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colEndAmount_D: TcxGridDBColumn
            Caption = #1050#1086#1085'. '#1089#1072#1083#1100#1076#1086' ('#1044#1077#1073#1077#1090')'
            DataBinding.FieldName = 'EndAmount_D'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colEndAmount_K: TcxGridDBColumn
            Caption = #1050#1086#1085'. '#1089#1072#1083#1100#1076#1086' ('#1050#1088#1077#1076#1080#1090')'
            DataBinding.FieldName = 'EndAmount_K'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colAccountName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090
            DataBinding.FieldName = 'AccountName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1044
    Height = 57
    ExplicitWidth = 1044
    ExplicitHeight = 57
    inherited deStart: TcxDateEdit
      Left = 60
      EditValue = 41640d
      Properties.SaveTime = False
      ExplicitLeft = 60
    end
    inherited deEnd: TcxDateEdit
      Left = 60
      Top = 30
      EditValue = 41640d
      Properties.SaveTime = False
      ExplicitLeft = 60
      ExplicitTop = 30
    end
    inherited cxLabel1: TcxLabel
      Left = 15
      Caption = #1044#1072#1090#1072' '#1089' :'
      ExplicitLeft = 15
      ExplicitWidth = 45
    end
    inherited cxLabel2: TcxLabel
      Left = 8
      Top = 31
      Caption = #1044#1072#1090#1072' '#1087#1086' :'
      ExplicitLeft = 8
      ExplicitTop = 31
      ExplicitWidth = 52
    end
    object cxLabel3: TcxLabel
      Left = 305
      Top = 6
      Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103':'
    end
    object ceInfoMoneyGroup: TcxButtonEdit
      Left = 305
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 125
    end
    object ceInfoMoneyDestination: TcxButtonEdit
      Left = 435
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 120
    end
    object cxLabel4: TcxLabel
      Left = 435
      Top = 6
      Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077':'
    end
    object ceInfoMoney: TcxButtonEdit
      Left = 560
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 135
    end
    object cxLabel5: TcxLabel
      Left = 560
      Top = 6
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103':'
    end
    object cxLabel6: TcxLabel
      Left = 160
      Top = 6
      Caption = #1057#1095#1077#1090' '#1085#1072#1079#1074#1072#1085#1080#1077':'
    end
    object edAccount: TcxButtonEdit
      Left = 160
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 140
    end
    object cxLabel7: TcxLabel
      Left = 700
      Top = 6
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099':'
    end
    object edPaidKind: TcxButtonEdit
      Left = 700
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 81
    end
    object cxLabel8: TcxLabel
      Left = 785
      Top = 6
      Caption = #1060#1080#1083#1080#1072#1083':'
    end
    object edBranch: TcxButtonEdit
      Left = 785
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 120
    end
    object cxLabel9: TcxLabel
      Left = 911
      Top = 8
      Caption = #1043#1088#1091#1087#1087#1072' '#1102#1088'.'#1083#1080#1094':'
    end
    object edJuridicalGroup: TcxButtonEdit
      Left = 911
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 120
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = AccountGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
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
        Component = InfoMoneyDestinationGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = InfoMoneyGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = InfoMoneyGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = JuridicalGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = PaidKindGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    Top = 327
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spGetDescSets
      StoredProcList = <
        item
          StoredProc = spGetDescSets
        end
        item
          StoredProc = spSelect
        end>
    end
    object dsdPrintAction: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084' ('#1073#1091#1093#1075#1072#1083#1090#1077#1088#1089#1082#1080#1077' '#1076#1072#1085#1085#1099#1077')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084' ('#1073#1091#1093#1075#1072#1083#1090#1077#1088#1089#1082#1080#1077' '#1076#1072#1085#1085#1099#1077')'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDataset'
          IndexFieldNames = 'JuridicalName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end>
      ReportName = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1102#1088' '#1083#1080#1094#1072#1084' - '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1080'('#1073#1091#1093#1075')'
      ReportNameParam.Value = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1102#1088' '#1083#1080#1094#1072#1084' - '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1080'('#1073#1091#1093#1075')'
      ReportNameParam.DataType = ftString
    end
    object dsdPrintReal_byJuridicalPersonal: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084' ('#1092#1072#1082#1090#1080#1095#1077#1089#1082#1080#1077' '#1076#1072#1085#1085#1099#1077')'
      Hint = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084' ('#1092#1072#1082#1090#1080#1095#1077#1089#1082#1080#1077' '#1076#1072#1085#1085#1099#1077')'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDataset'
          IndexFieldNames = 'JuridicalPartnerlName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end>
      ReportName = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084' ('#1092#1072#1082#1090')'
      ReportNameParam.Value = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084' ('#1092#1072#1082#1090')'
      ReportNameParam.DataType = ftString
    end
    object dsdPrintRealAction: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084' ('#1092#1072#1082#1090#1080#1095#1077#1089#1082#1080#1077' '#1076#1072#1085#1085#1099#1077')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084' ('#1092#1072#1082#1090#1080#1095#1077#1089#1082#1080#1077' '#1076#1072#1085#1085#1099#1077')'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDataset'
          IndexFieldNames = 'JuridicalName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end>
      ReportName = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1102#1088' '#1083#1080#1094#1072#1084' - '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1080'('#1092#1072#1082#1090')'
      ReportNameParam.Value = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1102#1088' '#1083#1080#1094#1072#1084' - '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1080'('#1092#1072#1082#1090')'
      ReportNameParam.DataType = ftString
    end
    object IncomeJournal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'IncomeJournal'
      FormName = 'TMovementJournalForm'
      FormNameParam.Value = 'TMovementJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'AccountId'
          Component = MasterCDS
          ComponentItem = 'AccountId'
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'PartnerId'
          Component = MasterCDS
          ComponentItem = 'PartnerId'
        end
        item
          Name = 'InfoMoneyId'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'ContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end
        item
          Name = 'PaidKindId'
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'IncomeDesc'
          DataType = ftString
        end
        item
          Name = 'AccountName'
          Component = MasterCDS
          ComponentItem = 'AccountName'
          DataType = ftString
        end
        item
          Name = 'JuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'PartnerName'
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyName'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end
        item
          Name = 'ContractNumber'
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
        end
        item
          Name = 'PaidKindName'
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
        end
        item
          Name = 'BranchId'
          Component = MasterCDS
          ComponentItem = 'BranchId'
        end
        item
          Name = 'BranchName'
          Component = MasterCDS
          ComponentItem = 'BranchName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object ReturnOutJournal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'ReturnOutJournal'
      FormName = 'TMovementJournalForm'
      FormNameParam.Value = 'TMovementJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'AccountId'
          Component = MasterCDS
          ComponentItem = 'AccountId'
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'PartnerId'
          Component = MasterCDS
          ComponentItem = 'PartnerId'
        end
        item
          Name = 'InfoMoneyId'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'ContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end
        item
          Name = 'PaidKindId'
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'ReturnOutDesc'
          DataType = ftString
        end
        item
          Name = 'AccountName'
          Component = MasterCDS
          ComponentItem = 'AccountName'
          DataType = ftString
        end
        item
          Name = 'JuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'PartnerName'
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyName'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end
        item
          Name = 'ContractNumber'
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
        end
        item
          Name = 'PaidKindName'
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
        end
        item
          Name = 'BranchId'
          Component = MasterCDS
          ComponentItem = 'BranchId'
        end
        item
          Name = 'BranchName'
          Component = MasterCDS
          ComponentItem = 'BranchName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object SaleJournal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      FormName = 'TMovementJournalForm'
      FormNameParam.Value = 'TMovementJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'AccountId'
          Component = MasterCDS
          ComponentItem = 'AccountId'
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'PartnerId'
          Component = MasterCDS
          ComponentItem = 'PartnerId'
        end
        item
          Name = 'InfoMoneyId'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'ContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end
        item
          Name = 'PaidKindId'
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'SaleDesc'
          DataType = ftString
        end
        item
          Name = 'AccountName'
          Component = MasterCDS
          ComponentItem = 'AccountName'
          DataType = ftString
        end
        item
          Name = 'JuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'PartnerName'
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyName'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end
        item
          Name = 'ContractNumber'
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
        end
        item
          Name = 'PaidKindName'
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
        end
        item
          Name = 'BranchId'
          Component = MasterCDS
          ComponentItem = 'BranchId'
        end
        item
          Name = 'BranchName'
          Component = MasterCDS
          ComponentItem = 'BranchName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object ReturnInJournal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'ReturnInJournal'
      FormName = 'TMovementJournalForm'
      FormNameParam.Value = 'TMovementJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'AccountId'
          Component = MasterCDS
          ComponentItem = 'AccountId'
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'PartnerId'
          Component = MasterCDS
          ComponentItem = 'PartnerId'
        end
        item
          Name = 'InfoMoneyId'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'ContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end
        item
          Name = 'PaidKindId'
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'ReturnInDesc'
          DataType = ftString
        end
        item
          Name = 'AccountName'
          Component = MasterCDS
          ComponentItem = 'AccountName'
          DataType = ftString
        end
        item
          Name = 'JuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'PartnerName'
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyName'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end
        item
          Name = 'ContractNumber'
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
        end
        item
          Name = 'PaidKindName'
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
        end
        item
          Name = 'BranchId'
          Component = MasterCDS
          ComponentItem = 'BranchId'
        end
        item
          Name = 'BranchName'
          Component = MasterCDS
          ComponentItem = 'BranchName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object MoneyJournal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'MoneyJournal'
      FormName = 'TMovementJournalForm'
      FormNameParam.Value = 'TMovementJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'AccountId'
          Component = MasterCDS
          ComponentItem = 'AccountId'
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'PartnerId'
          Component = MasterCDS
          ComponentItem = 'PartnerId'
        end
        item
          Name = 'InfoMoneyId'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'ContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end
        item
          Name = 'PaidKindId'
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'MoneyDesc'
          DataType = ftString
        end
        item
          Name = 'AccountName'
          Component = MasterCDS
          ComponentItem = 'AccountName'
          DataType = ftString
        end
        item
          Name = 'JuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'PartnerName'
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyName'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end
        item
          Name = 'ContractNumber'
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
        end
        item
          Name = 'PaidKindName'
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
        end
        item
          Name = 'BranchId'
          Component = MasterCDS
          ComponentItem = 'BranchId'
        end
        item
          Name = 'BranchName'
          Component = MasterCDS
          ComponentItem = 'BranchName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object ServiceJournal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'ServiceJournal'
      FormName = 'TMovementJournalForm'
      FormNameParam.Value = 'TMovementJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'AccountId'
          Component = MasterCDS
          ComponentItem = 'AccountId'
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'PartnerId'
          Component = MasterCDS
          ComponentItem = 'PartnerId'
        end
        item
          Name = 'InfoMoneyId'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'ContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end
        item
          Name = 'PaidKindId'
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'ServiceDesc'
          DataType = ftString
        end
        item
          Name = 'AccountName'
          Component = MasterCDS
          ComponentItem = 'AccountName'
          DataType = ftString
        end
        item
          Name = 'JuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'PartnerName'
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyName'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end
        item
          Name = 'ContractNumber'
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
        end
        item
          Name = 'PaidKindName'
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
        end
        item
          Name = 'BranchId'
          Component = MasterCDS
          ComponentItem = 'BranchId'
        end
        item
          Name = 'BranchName'
          Component = MasterCDS
          ComponentItem = 'BranchName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object SendDebtJournal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'SendDebtJournal'
      FormName = 'TMovementJournalForm'
      FormNameParam.Value = 'TMovementJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'AccountId'
          Component = MasterCDS
          ComponentItem = 'AccountId'
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'PartnerId'
          Component = MasterCDS
          ComponentItem = 'PartnerId'
        end
        item
          Name = 'InfoMoneyId'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'ContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end
        item
          Name = 'PaidKindId'
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'SendDebtDesc'
          DataType = ftString
        end
        item
          Name = 'AccountName'
          Component = MasterCDS
          ComponentItem = 'AccountName'
          DataType = ftString
        end
        item
          Name = 'JuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'PartnerName'
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyName'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end
        item
          Name = 'ContractNumber'
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
        end
        item
          Name = 'PaidKindName'
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
        end
        item
          Name = 'BranchId'
          Component = MasterCDS
          ComponentItem = 'BranchId'
        end
        item
          Name = 'BranchName'
          Component = MasterCDS
          ComponentItem = 'BranchName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object OtherJournal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'OtherJournal'
      FormName = 'TMovementJournalForm'
      FormNameParam.Value = 'TMovementJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'AccountId'
          Component = MasterCDS
          ComponentItem = 'AccountId'
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'PartnerId'
          Component = MasterCDS
          ComponentItem = 'PartnerId'
        end
        item
          Name = 'InfoMoneyId'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'ContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end
        item
          Name = 'PaidKindId'
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'OtherDesc'
          DataType = ftString
        end
        item
          Name = 'AccountName'
          Component = MasterCDS
          ComponentItem = 'AccountName'
          DataType = ftString
        end
        item
          Name = 'JuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'PartnerName'
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyName'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end
        item
          Name = 'ContractNumber'
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
        end
        item
          Name = 'PaidKindName'
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
        end
        item
          Name = 'BranchId'
          Component = MasterCDS
          ComponentItem = 'BranchId'
        end
        item
          Name = 'BranchName'
          Component = MasterCDS
          ComponentItem = 'BranchName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object SaleRealJournal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'SaleRealJournal'
      FormName = 'TMovementJournalForm'
      FormNameParam.Value = 'TMovementJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'AccountId'
          Component = MasterCDS
          ComponentItem = 'AccountId'
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'PartnerId'
          Component = MasterCDS
          ComponentItem = 'PartnerId'
        end
        item
          Name = 'InfoMoneyId'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'ContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end
        item
          Name = 'PaidKindId'
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'SaleRealDesc'
          DataType = ftString
        end
        item
          Name = 'AccountName'
          Component = MasterCDS
          ComponentItem = 'AccountName'
          DataType = ftString
        end
        item
          Name = 'JuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'PartnerName'
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyName'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end
        item
          Name = 'ContractNumber'
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
        end
        item
          Name = 'PaidKindName'
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
        end
        item
          Name = 'BranchId'
          Component = MasterCDS
          ComponentItem = 'BranchId'
        end
        item
          Name = 'BranchName'
          Component = MasterCDS
          ComponentItem = 'BranchName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object ReturnInRealJournal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'ReturnInJournal'
      FormName = 'TMovementJournalForm'
      FormNameParam.Value = 'TMovementJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'AccountId'
          Component = MasterCDS
          ComponentItem = 'AccountId'
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'PartnerId'
          Component = MasterCDS
          ComponentItem = 'PartnerId'
        end
        item
          Name = 'InfoMoneyId'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'ContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end
        item
          Name = 'PaidKindId'
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'ReturnInRealDesc'
          DataType = ftString
        end
        item
          Name = 'AccountName'
          Component = MasterCDS
          ComponentItem = 'AccountName'
          DataType = ftString
        end
        item
          Name = 'JuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'PartnerName'
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyName'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end
        item
          Name = 'ContractNumber'
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
        end
        item
          Name = 'PaidKindName'
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
        end
        item
          Name = 'BranchId'
          Component = MasterCDS
          ComponentItem = 'BranchId'
        end
        item
          Name = 'BranchName'
          Component = MasterCDS
          ComponentItem = 'BranchName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object TransferDebtJournal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'SendDebtJournal'
      FormName = 'TMovementJournalForm'
      FormNameParam.Value = 'TMovementJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'AccountId'
          Component = MasterCDS
          ComponentItem = 'AccountId'
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'PartnerId'
          Component = MasterCDS
          ComponentItem = 'PartnerId'
        end
        item
          Name = 'InfoMoneyId'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'ContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end
        item
          Name = 'PaidKindId'
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
        end
        item
          Name = 'DescSet'
          Value = Null
          Component = FormParams
          ComponentItem = 'TransferDebtDesc'
          DataType = ftString
        end
        item
          Name = 'AccountName'
          Component = MasterCDS
          ComponentItem = 'AccountName'
          DataType = ftString
        end
        item
          Name = 'JuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'PartnerName'
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyName'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end
        item
          Name = 'ContractNumber'
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
        end
        item
          Name = 'PaidKindName'
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
        end
        item
          Name = 'BranchId'
          Component = MasterCDS
          ComponentItem = 'BranchId'
        end
        item
          Name = 'BranchName'
          Component = MasterCDS
          ComponentItem = 'BranchName'
          DataType = ftString
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 184
  end
  inherited MasterCDS: TClientDataSet
    IndexFieldNames = 'JuridicalName'
    Top = 184
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_JuridicalSold'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inAccountId'
        Value = ''
        Component = AccountGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyGroupId'
        Value = ''
        Component = InfoMoneyGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyDestinationId'
        Value = ''
        Component = InfoMoneyDestinationGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inBranchId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalGroupId'
        Value = ''
        Component = JuridicalGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 112
    Top = 192
  end
  inherited BarManager: TdxBarManager
    Left = 176
    Top = 200
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintReal'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintReal_byJuridicalPersonal'
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
      Action = dsdPrintAction
      Category = 0
    end
    object bbPrintReal: TdxBarButton
      Action = dsdPrintRealAction
      Category = 0
    end
    object bbPrintReal_byJuridicalPersonal: TdxBarButton
      Action = dsdPrintReal_byJuridicalPersonal
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColumnAddOnList = <
      item
        Column = colIncomeSumm
        Action = IncomeJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = colReturnOutSumm
        Action = ReturnOutJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = colSaleSumm
        Action = SaleJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = colReturnInSumm
        Action = ReturnInJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = colMoneySumm
        Action = MoneyJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = colServiceSumm
        Action = ServiceJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = colSendDebtSumm
        Action = SendDebtJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = colOtherSumm
        Action = OtherJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = colSaleRealSumm
        Action = SaleRealJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = colReturnInRealSumm
        Action = ReturnInRealJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = colTransferDebtSumm
        Action = TransferDebtJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end>
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 152
    Top = 72
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = AccountGuides
      end
      item
        Component = InfoMoneyGroupGuides
      end
      item
        Component = InfoMoneyDestinationGuides
      end
      item
        Component = InfoMoneyGuides
      end
      item
        Component = PaidKindGuides
      end
      item
        Component = BranchGuides
      end
      item
        Component = JuridicalGroupGuides
      end>
    Top = 228
  end
  object InfoMoneyGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoneyGroup
    FormNameParam.Value = 'TInfoMoneyGroupForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoneyGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = InfoMoneyGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 704
    Top = 53
  end
  object InfoMoneyDestinationGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoneyDestination
    FormNameParam.Value = 'TInfoMoneyDestinationForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoneyDestinationForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = InfoMoneyDestinationGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyDestinationGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 584
    Top = 53
  end
  object InfoMoneyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 440
    Top = 61
  end
  object AccountGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edAccount
    FormNameParam.Value = 'TAccount_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TAccount_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = AccountGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValueAll'
        Value = ''
        Component = AccountGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 312
    Top = 48
  end
  object spGetDescSets: TdsdStoredProc
    StoredProcName = 'gpGetDescSets'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'IncomeDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'IncomeDesc'
        DataType = ftString
      end
      item
        Name = 'ReturnOutDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnOutDesc'
        DataType = ftString
      end
      item
        Name = 'SaleDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SaleDesc'
        DataType = ftString
      end
      item
        Name = 'ReturnInDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnInDesc'
        DataType = ftString
      end
      item
        Name = 'MoneyDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'MoneyDesc'
        DataType = ftString
      end
      item
        Name = 'ServiceDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ServiceDesc'
        DataType = ftString
      end
      item
        Name = 'SendDebtDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SendDebtDesc'
        DataType = ftString
      end
      item
        Name = 'OtherDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'OtherDesc'
        DataType = ftString
      end
      item
        Name = 'SaleRealDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SaleRealDesc'
        DataType = ftString
      end
      item
        Name = 'ReturnInRealDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnInRealDesc'
        DataType = ftString
      end
      item
        Name = 'TransferDebtDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'TransferDebtDesc'
        DataType = ftString
      end>
    PackSize = 1
    Left = 296
    Top = 232
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'IncomeDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'ReturnOutDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'SaleDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'ReturnInDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'MoneyDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'ServiceDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'SendDebtDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'OtherDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'SaleRealDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'ReturnInRealDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'TransferDebtDesc'
        Value = Null
        DataType = ftString
      end>
    Left = 240
    Top = 232
  end
  object PaidKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 800
    Top = 56
  end
  object BranchGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 864
    Top = 72
  end
  object JuridicalGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridicalGroup
    FormNameParam.Value = 'TJuridicalGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridicalGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 960
    Top = 64
  end
end
