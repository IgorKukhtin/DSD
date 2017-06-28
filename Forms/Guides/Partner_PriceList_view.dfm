inherited Partner_PriceList_viewForm: TPartner_PriceList_viewForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' + '#1044#1086#1075#1086#1074#1086#1088' + '#1087#1088#1086#1074#1077#1088#1082#1072' '#1055#1088#1072#1081#1089'>'
  ClientHeight = 496
  ClientWidth = 1054
  ExplicitWidth = 1070
  ExplicitHeight = 535
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1054
    Height = 470
    ExplicitWidth = 1054
    ExplicitHeight = 470
    ClientRectBottom = 470
    ClientRectRight = 1054
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1054
      ExplicitHeight = 470
      inherited cxGrid: TcxGrid
        Width = 1054
        Height = 470
        ExplicitWidth = 1054
        ExplicitHeight = 470
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
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
          object PartnerCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'PartnerCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object PartnerName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'PartnerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
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
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object JuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1102#1088'. '#1083'.'
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object OKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object ContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'Code'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object ContractStateKindName: TcxGridDBColumn
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object StartDate: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1089
            DataBinding.FieldName = 'StartDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object EndDate: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1076#1086
            DataBinding.FieldName = 'EndDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ContractComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractComment'
            Visible = False
            Options.Editing = False
            Width = 70
          end
          object OperDate_GP_sale: TcxGridDBColumn
            Caption = #1076#1072#1090#1072' '#1055#1088#1086#1076#1072#1078#1072
            DataBinding.FieldName = 'OperDate_GP_sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PriceListName_GP_sale: TcxGridDBColumn
            Caption = #1087#1088#1072#1081#1089' '#1055#1088#1086#1076#1072#1078#1072
            DataBinding.FieldName = 'PriceListName_GP_sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object DescName_GP_sale: TcxGridDBColumn
            Caption = #1080#1085#1092'. '#1055#1088#1086#1076#1072#1078#1072
            DataBinding.FieldName = 'DescName_GP_sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperDate_GP_return: TcxGridDBColumn
            Caption = #1076#1072#1090#1072' '#1042#1086#1079#1074#1088#1072#1090
            DataBinding.FieldName = 'OperDate_GP_return'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PriceListName_GP_return: TcxGridDBColumn
            Caption = #1087#1088#1072#1081#1089' '#1042#1086#1079#1074#1088#1072#1090
            DataBinding.FieldName = 'PriceListName_GP_return'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object DescName_GP_return: TcxGridDBColumn
            Caption = #1080#1085#1092'. '#1042#1086#1079#1074#1088#1072#1090
            DataBinding.FieldName = 'DescName_GP_return'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperDate_GP_return_prior: TcxGridDBColumn
            Caption = #1076#1072#1090#1072' '#1042#1086#1079#1074#1088#1072#1090' '#1087#1086' '#1089#1090#1072#1088#1099#1084' '#1094'.'
            DataBinding.FieldName = 'OperDate_GP_return_prior'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PriceListName_GP_return_prior: TcxGridDBColumn
            Caption = #1087#1088#1072#1081#1089' '#1042#1086#1079#1074#1088#1072#1090' '#1087#1086' '#1089#1090#1072#1088#1099#1084' '#1094'.'
            DataBinding.FieldName = 'PriceListName_GP_return_prior'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object DescName_GP_return_prior: TcxGridDBColumn
            Caption = #1080#1085#1092'. '#1042#1086#1079#1074#1088'. '#1087#1086' '#1089#1090'.'#1094'.'
            DataBinding.FieldName = 'DescName_GP_return_prior'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperDate_30201_sale: TcxGridDBColumn
            Caption = #1076#1072#1090#1072' '#1055#1088#1086#1076#1072#1078#1072' '#1052#1103#1089#1086
            DataBinding.FieldName = 'OperDate_30201_sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PriceListName_30201_sale: TcxGridDBColumn
            Caption = #1087#1088#1072#1081#1089' '#1055#1088#1086#1076#1072#1078#1072' '#1052#1103#1089#1086
            DataBinding.FieldName = 'PriceListName_30201_sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object DescName_30201_sale: TcxGridDBColumn
            Caption = #1080#1085#1092'. '#1055#1088#1086#1076#1072#1078#1072' '#1052#1103#1089#1086
            DataBinding.FieldName = 'DescName_30201_sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperDate_30201_return: TcxGridDBColumn
            Caption = #1076#1072#1090#1072' '#1042#1086#1079#1074#1088#1072#1090' '#1052#1103#1089#1086
            DataBinding.FieldName = 'OperDate_30201_return'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PriceListName_30201_return: TcxGridDBColumn
            Caption = #1087#1088#1072#1081#1089' '#1042#1086#1079#1074#1088#1072#1090' '#1052#1103#1089#1086
            DataBinding.FieldName = 'PriceListName_30201_return'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object DescName_30201_return: TcxGridDBColumn
            Caption = #1080#1085#1092'. '#1042#1086#1079#1074#1088#1072#1090' '#1052#1103#1089#1086
            DataBinding.FieldName = 'DescName_30201_return'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperDate_30103_sale: TcxGridDBColumn
            Caption = #1076#1072#1090#1072' '#1055#1088#1086#1076#1072#1078#1072' '#1061#1083#1077#1073
            DataBinding.FieldName = 'OperDate_30103_sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PriceListName_30103_sale: TcxGridDBColumn
            Caption = #1087#1088#1072#1081#1089' '#1055#1088#1086#1076#1072#1078#1072' '#1061#1083#1077#1073
            DataBinding.FieldName = 'PriceListName_30103_sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object DescName_30103_sale: TcxGridDBColumn
            Caption = #1080#1085#1092'. '#1055#1088#1086#1076#1072#1078#1072' '#1061#1083#1077#1073
            DataBinding.FieldName = 'DescName_30103_sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperDate_30103_return: TcxGridDBColumn
            Caption = #1076#1072#1090#1072' '#1042#1086#1079#1074#1088#1072#1090' '#1061#1083#1077#1073
            DataBinding.FieldName = 'OperDate_30103_return'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PriceListName_30103_return: TcxGridDBColumn
            Caption = #1087#1088#1072#1081#1089' '#1042#1086#1079#1074#1088#1072#1090' '#1061#1083#1077#1073
            DataBinding.FieldName = 'PriceListName_30103_return'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object DescName_30103_return: TcxGridDBColumn
            Caption = #1080#1085#1092'. '#1042#1086#1079#1074#1088#1072#1090' '#1061#1083#1077#1073
            DataBinding.FieldName = 'DescName_30103_return'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperDate_income: TcxGridDBColumn
            Caption = #1076#1072#1090#1072' '#1055#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'OperDate_income'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PriceListName_income: TcxGridDBColumn
            Caption = #1087#1088#1072#1081#1089' '#1055#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'PriceListName_income'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object DescName_income: TcxGridDBColumn
            Caption = #1080#1085#1092'. '#1055#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'DescName_income'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object PersonalTradeCode: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1058#1055')'
            DataBinding.FieldName = 'PersonalTradeCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object PersonalTradeName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1058#1055')'
            DataBinding.FieldName = 'PersonalTradeName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PositionName_PersonalTrade: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1058#1055')'
            DataBinding.FieldName = 'PositionName_PersonalTrade'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object BranchName_PersonalTrade: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083' ('#1058#1055')'
            DataBinding.FieldName = 'BranchName_PersonalTrade'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PersonalMerchCode: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1084#1077#1088#1095#1072#1085#1076#1072#1081#1079#1077#1088')'
            DataBinding.FieldName = 'PersonalMerchCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object PersonalMerchName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1084#1077#1088#1095#1072#1085#1076#1072#1081#1079#1077#1088')'
            DataBinding.FieldName = 'PersonalMerchName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object PositionName_PersonalMerch: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1084#1077#1088#1095#1072#1085#1076#1072#1081#1079#1077#1088')'
            DataBinding.FieldName = 'PositionName_PersonalMerch'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object BranchName_PersonalMerch: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083' ('#1084#1077#1088#1095#1072#1085#1076#1072#1081#1079#1077#1088')'
            DataBinding.FieldName = 'BranchName_PersonalMerch'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 111
          end
          object GLNCode: TcxGridDBColumn
            Caption = 'GLN - '#1084#1077#1089#1090#1086' '#1076#1086#1089#1090#1072#1074#1082#1080
            DataBinding.FieldName = 'GLNCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ContainerId: TcxGridDBColumn
            Caption = 'Id'
            DataBinding.FieldName = 'ContainerId'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Enabled = False
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            Width = 55
          end
          object isErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
        end
      end
      object LabelOperDate: TcxLabel
        Left = 214
        Top = 3
        AutoSize = False
        Caption = #1053#1072' '#1076#1072#1090#1091' '#1079#1072#1103#1074#1082#1080':'
        Height = 17
        Width = 92
      end
      object deOperDate: TcxDateEdit
        Left = 312
        Top = 2
        EditValue = 42005d
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 2
        Width = 97
      end
      object LabelJuridical: TcxLabel
        Left = 688
        Top = 10
        AutoSize = False
        Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086':'
        Height = 17
        Width = 110
      end
      object edJuridical: TcxButtonEdit
        Left = 807
        Top = 9
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 4
        Width = 218
      end
      object LabelRetail: TcxLabel
        Left = 432
        Top = 10
        AutoSize = False
        Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100':'
        Height = 17
        Width = 81
      end
      object edRetail: TcxButtonEdit
        Left = 519
        Top = 3
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 6
        Width = 163
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 67
    Top = 200
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deOperDate
        Properties.Strings = (
          'Date')
      end
      item
        Component = GuidesJuridical
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesRetail
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    Left = 95
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
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
          Name = 'JuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName_all'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName_all'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractTagId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractTagId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractTagName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractTagName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'RouteName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'RouteSortingId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteSortingId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'RouteSortingName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteSortingName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalTakeId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberTakeId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalTakeName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberTakeName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ChangePercent'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ChangePercent'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListId'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListName'
          Value = ''
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
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object actChoiceRoute: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Route_ObjectForm'
      FormName = 'TRoute_ObjectForm'
      FormNameParam.Value = 'TRoute_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceRouteSorting: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'RouteSorting_ObjectForm'
      FormName = 'TRouteSorting_ObjectForm'
      FormNameParam.Value = 'TRouteSorting_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteSortingId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RouteSortingName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoicePersonalTake: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Member_ObjectForm'
      FormName = 'TMember_ObjectForm'
      FormNameParam.Value = 'TMember_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberTakeId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberTakeName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 82
  end
  inherited MasterCDS: TClientDataSet
    Top = 82
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Partner_PriceList'
    Params = <
      item
        Name = 'inOperDate'
        Value = False
        Component = deOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 130
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 82
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
          ItemName = 'bbShowAll'
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
          ItemName = 'bbChoice'
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
          ItemName = 'bbLabelOperDate'
        end
        item
          Visible = True
          ItemName = 'bbOperDate'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbLabelRetail'
        end
        item
          Visible = True
          ItemName = 'bbRetail'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbLabelJuridical'
        end
        item
          Visible = True
          ItemName = 'bbJuridical'
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
    object bbLabelOperDate: TdxBarControlContainerItem
      Caption = 'bbLabelOperDate'
      Category = 0
      Hint = 'bbLabelOperDate'
      Visible = ivAlways
      Control = LabelOperDate
    end
    object bbOperDate: TdxBarControlContainerItem
      Caption = 'bbOperDate'
      Category = 0
      Hint = 'bbOperDate'
      Visible = ivAlways
      Control = deOperDate
    end
    object bbLabelJuridical: TdxBarControlContainerItem
      Caption = 'bbLabelJuridical'
      Category = 0
      Hint = 'bbLabelJuridical'
      Visible = ivAlways
      Control = LabelJuridical
    end
    object bbJuridical: TdxBarControlContainerItem
      Caption = 'bbJuridical'
      Category = 0
      Hint = 'bbJuridical'
      Visible = ivAlways
      Control = edJuridical
    end
    object bbLabelRetail: TdxBarControlContainerItem
      Caption = 'bbLabelRetail'
      Category = 0
      Hint = 'bbLabelRetail'
      Visible = ivAlways
      Control = LabelRetail
    end
    object bbRetail: TdxBarControlContainerItem
      Caption = 'bbRetail'
      Category = 0
      Hint = 'bbRetail'
      Visible = ivAlways
      Control = edRetail
    end
  end
  inherited PopupMenu: TPopupMenu
    Left = 160
  end
  object spInsertUpdate: TdsdStoredProc
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartnerId'
        ParamType = ptInputOutput
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
        Name = 'inRouteSortingId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RouteSortingId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MemberTakeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrepareDayCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PrepareDayCount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentDayCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DocumentDayCount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 168
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 872
    Top = 24
  end
  object GuidesRetail: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 576
    Top = 24
  end
end
