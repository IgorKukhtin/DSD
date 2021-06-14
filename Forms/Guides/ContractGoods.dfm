inherited ContractGoodsForm: TContractGoodsForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1058#1086#1074#1072#1088#1099' '#1074' '#1076#1086#1075#1086#1074#1086#1088#1072#1093' ('#1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103')>'
  ClientHeight = 374
  ClientWidth = 773
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.isSingle = False
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 789
  ExplicitHeight = 412
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 773
    Height = 348
    ExplicitWidth = 773
    ExplicitHeight = 348
    ClientRectBottom = 348
    ClientRectRight = 773
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 773
      ExplicitHeight = 348
      inherited cxGrid: TcxGrid
        Width = 773
        Height = 348
        ExplicitWidth = 773
        ExplicitHeight = 348
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
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
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 62
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            Options.Editing = False
            Width = 70
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 123
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 54
          end
          object StartDate: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1089
            DataBinding.FieldName = 'StartDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object EndDate: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1087#1086
            DataBinding.FieldName = 'EndDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 47
          end
          object Persent: TcxGridDBColumn
            Caption = '% '#1080#1079#1084'. '#1094#1077#1085#1099
            DataBinding.FieldName = 'Persent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1086#1090#1085#1086#1089#1080#1090#1077#1083#1100#1085#1086' '#1087#1088#1077#1076#1099#1076#1091#1097#1077#1081' '#1094#1077#1085#1099
            Options.Editing = False
            Width = 47
          end
          object PriceListName: TcxGridDBColumn
            Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
            DataBinding.FieldName = 'PriceListName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object ContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 66
          end
          object ContractTagGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1087#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object JuridicalGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1102#1088'. '#1083'.'
            DataBinding.FieldName = 'JuridicalGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object JuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1102#1088'.'#1083'.'
            DataBinding.FieldName = 'JuridicalCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 132
          end
          object JuridicalDocumentName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086' ('#1087#1077#1095#1072#1090#1100' '#1076#1086#1082'.)'
            DataBinding.FieldName = 'JuridicalDocumentName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object OKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099' ('#1076#1086#1075'.)'
            DataBinding.FieldName = 'PaidKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object SigningDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1079#1072#1082#1083#1102#1095#1077#1085#1080#1103' ('#1076#1086#1075'.)'
            DataBinding.FieldName = 'SigningDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object StartDate_contract: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1089' ('#1076#1086#1075'.)'
            DataBinding.FieldName = 'StartDate_contract'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object EndDate_contract: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1076#1086' ('#1076#1086#1075'.)'
            DataBinding.FieldName = 'EndDate_contract'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object ContractKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object InfoMoneyGroupCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055' '#1075#1088#1091#1087#1087#1099
            DataBinding.FieldName = 'InfoMoneyGroupCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 113
          end
          object InfoMoneyDestinationCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055' '#1085#1072#1079#1085#1072#1095'.'
            DataBinding.FieldName = 'InfoMoneyDestinationCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 39
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PersonalName: TcxGridDBColumn
            Caption = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalName'
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
          object PersonalTradeName: TcxGridDBColumn
            Caption = #1058#1055' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalTradeName'
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
            Width = 60
          end
          object PersonalCollationName: TcxGridDBColumn
            Caption = #1041#1091#1093#1075'.'#1089#1074#1077#1088#1082#1072' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalCollationName'
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
            Width = 60
          end
          object AreaContractName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085' ('#1076#1086#1075#1086#1074#1086#1088')'
            DataBinding.FieldName = 'AreaContractName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ContractArticleName: TcxGridDBColumn
            Caption = #1055#1088#1077#1076#1084#1077#1090' '#1076#1086#1075#1086#1074#1086#1088#1072
            DataBinding.FieldName = 'ContractArticleName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object JuridicalBasisName: TcxGridDBColumn
            Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalBasisName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object BankAccountName: TcxGridDBColumn
            Caption = #1056'.'#1089#1095#1077#1090' ('#1074#1093'.'#1087#1083#1072#1090#1077#1078')'
            DataBinding.FieldName = 'BankAccountName'
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
            Options.Editing = False
            Width = 60
          end
          object BankAccountExternal: TcxGridDBColumn
            Caption = #1056'.'#1089#1095#1077#1090' ('#1080#1089#1093'.'#1087#1083#1072#1090#1077#1078')'
            DataBinding.FieldName = 'BankAccountExternal'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
          end
          object BankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082' ('#1080#1089#1093'.'#1087#1083#1072#1090#1077#1078')'
            DataBinding.FieldName = 'BankName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object InsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object UpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 48
          end
          object GLNCode: TcxGridDBColumn
            Caption = #1050#1086#1076' GLN'
            DataBinding.FieldName = 'GLNCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object IsStandart: TcxGridDBColumn
            Caption = #1058#1080#1087#1086#1074#1086#1081
            DataBinding.FieldName = 'isStandart'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object IsPersonal: TcxGridDBColumn
            Caption = 'C'#1083#1091#1078'. '#1079#1072#1087'.'
            DataBinding.FieldName = 'isPersonal'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object IsDefault: TcxGridDBColumn
            Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
            DataBinding.FieldName = 'isDefault'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
            Options.Editing = False
            Width = 40
          end
          object IsDefaultOut: TcxGridDBColumn
            Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1080#1089#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
            DataBinding.FieldName = 'isDefaultOut'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1080#1089#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
            Options.Editing = False
            Width = 40
          end
          object IsUnique: TcxGridDBColumn
            Caption = #1056#1072#1089#1095#1077#1090' '#1076#1086#1083#1075#1072
            DataBinding.FieldName = 'isUnique'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object DocumentCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1086#1082'-'#1090#1086#1074
            DataBinding.FieldName = 'DocumentCount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object DateDocument: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'-'#1090#1072
            DataBinding.FieldName = 'DateDocument'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ContractKeyId: TcxGridDBColumn
            Caption = #1050#1083#1102#1095' ('#1088#1072#1089#1095'. '#1076#1086#1083#1075#1072')'
            DataBinding.FieldName = 'ContractKeyId'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object isErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 92
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited actInsert: TInsertUpdateChoiceAction
      FormName = 'TContractGoodsEditForm'
      FormNameParam.Value = 'TContractGoodsEditForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TContractGoodsEditForm'
      FormNameParam.Value = 'TContractGoodsEditForm'
    end
    inherited dsdChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1087#1086#1089#1083#1077#1076#1085#1080#1093' '#1094#1077#1085
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1087#1086#1089#1083#1077#1076#1085#1080#1093' '#1094#1077#1085
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object macSetErased_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = dsdSetErased
        end>
      View = cxGridDBTableView
      Caption = 'macSetErased_list'
    end
    object macSetErased: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macSetErased_list
        end>
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1042#1089#1077' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1090#1086#1074#1072#1088#1099'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1091#1076#1072#1083#1077#1085#1099
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1090#1086#1074#1072#1088#1099
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1090#1086#1074#1072#1088#1099
      ImageIndex = 52
    end
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 72
  end
  inherited MasterCDS: TClientDataSet
    Left = 24
    Top = 128
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ContractGoods_All'
    Params = <
      item
        Name = 'inisShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 64
  end
  inherited BarManager: TdxBarManager
    Left = 136
    Top = 72
    DockControlHeights = (
      0
      0
      26
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
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbmacSetErased'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
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
          BeginGroup = True
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbShowErased: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object bbmacSetErased: TdxBarButton
      Action = macSetErased
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actUpdate
      end>
    Left = 480
    Top = 224
  end
  inherited PopupMenu: TPopupMenu
    Left = 128
    Top = 256
  end
  inherited spErasedUnErased: TdsdStoredProc
    Left = 224
  end
end
