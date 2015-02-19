inherited Report_JuridicalDefermentPaymentForm: TReport_JuridicalDefermentPaymentForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1086#1082#1091#1087#1072#1090#1077#1083#1080' '#1089' '#1086#1090#1089#1088#1086#1095#1082#1086#1081'>'
  ClientHeight = 394
  ClientWidth = 1115
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1131
  ExplicitHeight = 429
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1115
    Height = 337
    TabOrder = 3
    ExplicitTop = 57
    ExplicitWidth = 1115
    ExplicitHeight = 337
    ClientRectBottom = 337
    ClientRectRight = 1115
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1115
      ExplicitHeight = 337
      inherited cxGrid: TcxGrid
        Width = 1115
        Height = 337
        ExplicitWidth = 1115
        ExplicitHeight = 337
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSaleSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colKreditRemains
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colDebetRemains
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colDefermentPaymentRemains
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSaleSumm1
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSaleSumm2
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSaleSumm3
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSaleSumm4
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSaleSumm5
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSaleSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colKreditRemains
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colDebetRemains
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colDefermentPaymentRemains
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSaleSumm1
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSaleSumm2
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSaleSumm3
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSaleSumm4
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSaleSumm5
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clAccountName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090
            DataBinding.FieldName = 'AccountName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clAreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085' ('#1076#1086#1075#1086#1074#1086#1088')'
            DataBinding.FieldName = 'AreaName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clRetailName_main: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName_main'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object clRetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' ('#1087#1088#1086#1089#1088#1086#1095#1082#1072')'
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
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
            Width = 70
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
          object clJuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object clOKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            Visible = False
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
          object clPaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
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
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colContractNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractNumber'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clContractTagGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1087#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clStartDate: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088' '#1089
            DataBinding.FieldName = 'StartDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clEndDate: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088' '#1076#1086
            DataBinding.FieldName = 'EndDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clPersonalName: TcxGridDBColumn
            Caption = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1079#1072' '#1076#1086#1075'. ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object clPersonalTradeName: TcxGridDBColumn
            Caption = #1058#1055' '#1079#1072' '#1076#1086#1075'. ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalTradeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object clPersonalCollationName: TcxGridDBColumn
            Caption = #1041#1091#1093#1075'.'#1089#1074#1077#1088#1082#1072' '#1087#1086' '#1076#1086#1075'.  ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalCollationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clInfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clInfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clInfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clInfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object clStartContractDate: TcxGridDBColumn
            Caption = #1054#1090#1089#1088#1086#1095#1082#1072' '#1085#1072#1095'.'#1076#1072#1090#1072
            DataBinding.FieldName = 'StartContractDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colDebetRemains: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1076#1086#1083#1075' ('#1044#1077#1073#1077#1090')'
            DataBinding.FieldName = 'DebetRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object colKreditRemains: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1076#1086#1083#1075' ('#1050#1088#1077#1076#1080#1090')'
            DataBinding.FieldName = 'KreditRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object colSaleSumm: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072
            DataBinding.FieldName = 'SaleSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object colDefermentPaymentRemains: TcxGridDBColumn
            Caption = #1044#1086#1083#1075' '#1089' '#1086#1090#1089#1088#1086#1095#1082#1086#1081
            DataBinding.FieldName = 'DefermentPaymentRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object colSaleSumm1: TcxGridDBColumn
            Caption = '7 '#1076#1085'.'
            DataBinding.FieldName = 'SaleSumm1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object colSaleSumm2: TcxGridDBColumn
            Caption = '14 '#1076#1085'.'
            DataBinding.FieldName = 'SaleSumm2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object colSaleSumm3: TcxGridDBColumn
            Caption = '21 '#1076#1085'.'
            DataBinding.FieldName = 'SaleSumm3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object colSaleSumm4: TcxGridDBColumn
            Caption = '28 '#1076#1085'.'
            DataBinding.FieldName = 'SaleSumm4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object colSaleSumm5: TcxGridDBColumn
            Caption = '>28 '#1076#1085'.'
            DataBinding.FieldName = 'SaleSumm5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object colCondition: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1077
            DataBinding.FieldName = 'Condition'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1115
    ExplicitWidth = 1115
    inherited deStart: TcxDateEdit
      Left = 59
      EditValue = 42005d
      Properties.SaveTime = False
      ExplicitLeft = 59
    end
    inherited deEnd: TcxDateEdit
      Left = 1024
      Top = -2
      Visible = False
      ExplicitLeft = 1024
      ExplicitTop = -2
    end
    inherited cxLabel1: TcxLabel
      Caption = #1085#1072' '#1076#1072#1090#1091':'
      ExplicitWidth = 48
    end
    inherited cxLabel2: TcxLabel
      Left = 966
      Top = -2
      Visible = False
      ExplicitLeft = 966
      ExplicitTop = -2
    end
    object edAccount: TcxButtonEdit
      Left = 246
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 320
    end
    object cxLabel3: TcxLabel
      Left = 161
      Top = 6
      Caption = #1057#1095#1077#1090' '#1085#1072#1079#1074#1072#1085#1080#1077':'
    end
    object cxLabel6: TcxLabel
      Left = 570
      Top = 6
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099':'
    end
    object edPaidKind: TcxButtonEdit
      Left = 653
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 55
    end
    object cxLabel9: TcxLabel
      Left = 717
      Top = 6
      Caption = #1060#1080#1083#1080#1072#1083':'
    end
    object edBranch: TcxButtonEdit
      Left = 765
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 120
    end
    object cxLabel4: TcxLabel
      Left = 890
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1102#1088'.'#1083#1080#1094':'
    end
    object edJuridicalGroup: TcxButtonEdit
      Left = 975
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
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
    object actPrintOneWeek: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = '1'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'PeriodNumber'
        end
        item
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'SaleSumm1'
          FromParam.DataType = ftFloat
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'SaleSumm'
          ToParam.DataType = ftFloat
        end>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1055#1077#1088#1074#1072#1103' '#1085#1077#1076#1077#1083#1103
      Hint = #1055#1077#1088#1074#1072#1103' '#1085#1077#1076#1077#1083#1103
      ImageIndex = 21
      DataSets = <
        item
          DataSet = cdsReport
          UserName = 'frxDBDataset'
        end>
      Params = <
        item
          Name = 'OperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'StartContractDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StartContractDate'
          DataType = ftDateTime
        end
        item
          Name = 'PeriodNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'PeriodNumber'
        end
        item
          Name = 'Summ'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SaleSumm1'
          DataType = ftFloat
        end
        item
          Name = 'ContractNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
        end
        item
          Name = 'AccountName'
          Value = ''
          Component = AccountGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = PaidKindGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.DataType = ftString
    end
    object actPrintTwoWeek: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = '2'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'PeriodNumber'
        end
        item
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'SaleSumm2'
          FromParam.DataType = ftFloat
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'SaleSumm'
          ToParam.DataType = ftFloat
        end>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1042#1090#1086#1088#1072#1103' '#1085#1077#1076#1077#1083#1103
      Hint = #1042#1090#1086#1088#1072#1103' '#1085#1077#1076#1077#1083#1103
      ImageIndex = 17
      DataSets = <
        item
          DataSet = cdsReport
          UserName = 'frxDBDataset'
        end>
      Params = <
        item
          Name = 'OperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'StartContractDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StartContractDate'
          DataType = ftDateTime
        end
        item
          Name = 'PeriodNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'PeriodNumber'
        end
        item
          Name = 'Summ'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SaleSumm2'
          DataType = ftFloat
        end
        item
          Name = 'ContractNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
        end
        item
          Name = 'AccountName'
          Value = ''
          Component = AccountGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = PaidKindGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.DataType = ftString
    end
    object actPrintThreeWeek: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = '3'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'PeriodNumber'
        end
        item
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'SaleSumm3'
          FromParam.DataType = ftFloat
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'SaleSumm'
          ToParam.DataType = ftFloat
        end>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1058#1088#1077#1090#1100#1103' '#1085#1077#1076#1077#1083#1103
      Hint = #1058#1088#1077#1090#1100#1103' '#1085#1077#1076#1077#1083#1103
      ImageIndex = 19
      DataSets = <
        item
          DataSet = cdsReport
          UserName = 'frxDBDataset'
        end>
      Params = <
        item
          Name = 'OperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'StartContractDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StartContractDate'
          DataType = ftDateTime
        end
        item
          Name = 'PeriodNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'PeriodNumber'
        end
        item
          Name = 'Summ'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SaleSumm3'
          DataType = ftFloat
        end
        item
          Name = 'ContractNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
        end
        item
          Name = 'AccountName'
          Value = ''
          Component = AccountGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = PaidKindGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.DataType = ftString
    end
    object actPrintFourWeek: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = '4'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'PeriodNumber'
        end
        item
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'SaleSumm4'
          FromParam.DataType = ftFloat
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'SaleSumm'
          ToParam.DataType = ftFloat
        end>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1063#1077#1090#1074#1077#1088#1090#1072#1103' '#1085#1077#1076#1077#1083#1103
      Hint = #1063#1077#1090#1074#1077#1088#1090#1072#1103' '#1085#1077#1076#1077#1083#1103
      ImageIndex = 22
      DataSets = <
        item
          DataSet = cdsReport
          UserName = 'frxDBDataset'
        end>
      Params = <
        item
          Name = 'OperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'StartContractDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StartContractDate'
          DataType = ftDateTime
        end
        item
          Name = 'PeriodNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'PeriodNumber'
        end
        item
          Name = 'Summ'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SaleSumm4'
          DataType = ftFloat
        end
        item
          Name = 'ContractNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
        end
        item
          Name = 'AccountName'
          Value = ''
          Component = AccountGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = PaidKindGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.DataType = ftString
    end
    object actPrintOther: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = '5'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'PeriodNumber'
        end
        item
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'SaleSumm5'
          FromParam.DataType = ftFloat
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'SaleSumm'
          ToParam.DataType = ftFloat
        end>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1041#1086#1083#1100#1096#1077' 28 '#1076#1085#1077#1081
      Hint = #1041#1086#1083#1100#1096#1077' 28 '#1076#1085#1077#1081
      ImageIndex = 23
      DataSets = <
        item
          DataSet = cdsReport
          UserName = 'frxDBDataset'
        end>
      Params = <
        item
          Name = 'OperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'StartContractDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StartContractDate'
          DataType = ftDateTime
        end
        item
          Name = 'PeriodNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'PeriodNumber'
        end
        item
          Name = 'Summ'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SaleSumm5'
          DataType = ftFloat
        end
        item
          Name = 'ContractNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
        end
        item
          Name = 'AccountName'
          Value = ''
          Component = AccountGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = PaidKindGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.DataType = ftString
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1086#1090#1095#1077#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 16
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frDataSet'
        end>
      Params = <
        item
          Name = 'OperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'StartContractDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StartContractDate'
          DataType = ftDateTime
        end
        item
          Name = 'PeriodNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'PeriodNumber'
        end
        item
          Name = 'Summ'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SaleSumm1'
          DataType = ftFloat
        end
        item
          Name = 'ContractNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
        end
        item
          Name = 'AccountName'
          Value = ''
          Component = AccountGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = PaidKindGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081')'
      ReportNameParam.DataType = ftString
    end
    object actPrintSale: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport_JuridicalSaleDocument
      StoredProcList = <
        item
          StoredProc = spReport_JuridicalSaleDocument
        end>
      Caption = #1055#1088#1086#1076#1072#1078#1072
      Hint = #1055#1088#1086#1076#1072#1078#1072
      ImageIndex = 3
      DataSets = <
        item
          DataSet = cdsReport
          UserName = 'frxDBDataset'
          IndexFieldNames = 'OperDate'
        end>
      Params = <
        item
          Name = 'OperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'StartContractDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StartContractDate'
          DataType = ftDateTime
        end
        item
          Name = 'PeriodNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'PeriodNumber'
        end
        item
          Name = 'Summ'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SaleSumm1'
          DataType = ftFloat
        end
        item
          Name = 'ContractNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
        end
        item
          Name = 'AccountName'
          Value = ''
          Component = AccountGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = PaidKindGuides
          ComponentItem = 'TextValue'
          DataType = ftString
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1103')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1103')'
      ReportNameParam.DataType = ftString
    end
    object actPrint_byJuridical: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1077#1090#1103#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1077#1090#1103#1084
      ImageIndex = 19
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'RetailName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1089#1088#1086#1095#1082#1077
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1089#1088#1086#1095#1082#1077
      ReportNameParam.DataType = ftString
    end
  end
  inherited MasterDS: TDataSource
    Top = 155
  end
  inherited MasterCDS: TClientDataSet
    IndexFieldNames = 'JuridicalName'
    StoreDefs = True
    Top = 155
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_JuridicalDefermentPayment'
    Params = <
      item
        Name = 'inOperDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEmptyParam'
        Value = 41395d
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
    Top = 187
  end
  inherited BarManager: TdxBarManager
    Top = 155
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
          ItemName = 'bbPribt'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSale'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReportOneWeek'
        end
        item
          Visible = True
          ItemName = 'bbTwoWeek'
        end
        item
          Visible = True
          ItemName = 'bbThreeWeek'
        end
        item
          Visible = True
          ItemName = 'bbFourWeek'
        end
        item
          Visible = True
          ItemName = 'bbOther'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_byJuridical'
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
    object bbReportOneWeek: TdxBarButton
      Action = actPrintOneWeek
      Category = 0
    end
    object bbTwoWeek: TdxBarButton
      Action = actPrintTwoWeek
      Category = 0
    end
    object bbThreeWeek: TdxBarButton
      Action = actPrintThreeWeek
      Category = 0
    end
    object bbFourWeek: TdxBarButton
      Action = actPrintFourWeek
      Category = 0
    end
    object bbOther: TdxBarButton
      Action = actPrintOther
      Category = 0
    end
    object bbPribt: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbSale: TdxBarButton
      Action = actPrintSale
      Category = 0
    end
    object bbPrint_byJuridical: TdxBarButton
      Action = actPrint_byJuridical
      Category = 0
      ImageIndex = 20
    end
  end
  inherited PeriodChoice: TPeriodChoice
    DateStart = nil
    DateEnd = nil
    Left = 32
    Top = 211
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = deStart
      end
      item
        Component = AccountGuides
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
    Left = 456
    Top = 8
  end
  object spReport: TdsdStoredProc
    StoredProcName = 'gpReport_JuridicalDefermentPaymentByDocument'
    DataSet = cdsReport
    DataSets = <
      item
        DataSet = cdsReport
      end>
    Params = <
      item
        Name = 'inOperDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inContractDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StartContractDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalId'
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
        Name = 'inContractId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PaidKindId'
        ParamType = ptInput
      end
      item
        Name = 'inBranchId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BranchId'
        ParamType = ptInput
      end
      item
        Name = 'inPeriodCount'
        Value = Null
        Component = FormParams
        ComponentItem = 'PeriodNumber'
        ParamType = ptInput
      end
      item
        Name = 'inSaleSumm'
        Value = Null
        Component = FormParams
        ComponentItem = 'SaleSumm'
        DataType = ftFloat
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 192
    Top = 192
  end
  object cdsReport: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 224
    Top = 200
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'PeriodNumber'
        Value = Null
      end
      item
        Name = 'SaleSumm'
        Value = Null
        DataType = ftFloat
      end>
    Left = 344
    Top = 112
  end
  object spReport_JuridicalSaleDocument: TdsdStoredProc
    StoredProcName = 'gpReport_JuridicalSaleDocument'
    DataSet = cdsReport
    DataSets = <
      item
        DataSet = cdsReport
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StartContractDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalId'
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
        Name = 'inContractId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PaidKindId'
        ParamType = ptInput
      end
      item
        Name = 'inBranchId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BranchId'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 200
    Top = 248
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
    Left = 888
    Top = 40
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
