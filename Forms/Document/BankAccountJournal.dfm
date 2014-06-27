inherited BankAccountJournalForm: TBankAccountJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076'>'
  ClientHeight = 377
  ClientWidth = 1056
  ExplicitWidth = 1064
  ExplicitHeight = 411
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1056
    Height = 318
    TabOrder = 3
    ExplicitWidth = 1056
    ExplicitHeight = 318
    ClientRectBottom = 314
    ClientRectRight = 1052
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1050
      ExplicitHeight = 312
      inherited cxGrid: TcxGrid
        Width = 1050
        Height = 312
        ExplicitWidth = 1050
        ExplicitHeight = 312
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colDebet
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colKredit
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colDebet
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colKredit
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            Options.Editing = False
            Width = 69
          end
          inherited colInvNumber: TcxGridDBColumn
            Options.Editing = False
            Width = 63
          end
          object colInvNumber_Parent: TcxGridDBColumn [2]
            Caption = #8470' '#1087#1083#1072#1090'. '#1074' '#1073'/'#1074
            DataBinding.FieldName = 'InvNumber_Parent'
            HeaderAlignmentVert = vaCenter
            Width = 44
          end
          inherited colOperDate: TcxGridDBColumn
            Options.Editing = False
            Width = 48
          end
          object colBankAccount: TcxGridDBColumn
            Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
            DataBinding.FieldName = 'BankAccountName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object colBankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082
            DataBinding.FieldName = 'BankName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object colDebet: TcxGridDBColumn
            Caption = #1044#1077#1073#1077#1090
            DataBinding.FieldName = 'AmountIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 44
          end
          object colKredit: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'AmountOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
          end
          object clOKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            HeaderAlignmentVert = vaCenter
            Width = 42
          end
          object clOKPO_Parent: TcxGridDBColumn
            Caption = #1054#1050#1055#1054' '#1074' '#1073'/'#1074
            DataBinding.FieldName = 'OKPO_Parent'
            HeaderAlignmentVert = vaCenter
            Width = 41
          end
          object colJuridical: TcxGridDBColumn
            Caption = #1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091
            DataBinding.FieldName = 'MoneyPlaceName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object colContract: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractInvNumber'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
          end
          object clInfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            HeaderAlignmentVert = vaCenter
            Width = 33
          end
          object clInfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clInfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colInfoMoney: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object colUnit: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object clComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object colPartnerBankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082' '#1087#1072#1088#1090#1085#1077#1088#1072
            DataBinding.FieldName = 'PartnerBankName'
            Width = 46
          end
          object colPartnerBankMFO: TcxGridDBColumn
            Caption = #1052#1060#1054' '#1073#1072#1085#1082#1072' '#1087#1072#1088#1090#1085#1077#1088#1072
            DataBinding.FieldName = 'PartnerBankMFO'
            Width = 44
          end
          object colPartnerBankAccount: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1087#1072#1088#1090#1085#1077#1088#1072
            DataBinding.FieldName = 'PartnerBankAccountName'
            Visible = False
            Width = 46
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 0
        Width = 1050
        Height = 312
        Align = alClient
        TabOrder = 1
        ExplicitTop = 139
        ExplicitWidth = 1189
        ExplicitHeight = 382
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
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
              Format = ',0.00'
              Kind = skSum
              Column = SummStart
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummIn
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummOut
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummEnd
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
              Column = SummStart
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummIn
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
              Column = SummEnd
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
              Format = ',0.00'
              Kind = skSum
              Column = SummOut
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
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object AccountCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1089#1095'.'
            DataBinding.FieldName = 'AccountCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object AccountName_All: TcxGridDBColumn
            Caption = #1057#1095#1077#1090
            DataBinding.FieldName = 'AccountName_All'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object ObjectCode_Direction: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1086#1073'.'#1085#1072#1087#1088'.'
            DataBinding.FieldName = 'ObjectCode_Direction'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object ObjectName_Direction: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'ObjectName_Direction'
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object DescName_Direction: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'DescName_Direction'
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ObjectCode_Destination: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1086#1073'.'#1085#1072#1079#1085'.'
            DataBinding.FieldName = 'ObjectCode_Destination'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ObjectName_Destination: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1082#1090' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'ObjectName_Destination'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object DescName_Destination: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'DescName_Destination'
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object JuridicalBasisName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086' ('#1075#1083#1072#1074#1085#1086#1077')'
            DataBinding.FieldName = 'JuridicalBasisName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object BusinessName: TcxGridDBColumn
            Caption = #1041#1080#1079#1085#1077#1089
            DataBinding.FieldName = 'BusinessName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object ContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object MovementDescName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'.'
            DataBinding.FieldName = 'MovementDescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object AccountCode_inf: TcxGridDBColumn
            Caption = #1087#1088#1080#1084'. '#1050#1086#1076' '#1089#1095'.'
            DataBinding.FieldName = 'AccountCode_inf'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object AccountName_All_inf: TcxGridDBColumn
            Caption = #1087#1088#1080#1084'. '#1057#1095#1077#1090
            DataBinding.FieldName = 'AccountName_All_inf'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object ProfitLossName_All_inf: TcxGridDBColumn
            Caption = #1087#1088#1080#1084'. '#1054#1055#1080#1059' '#1085#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'ProfitLossName_All_inf'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object BusinessName_inf: TcxGridDBColumn
            Caption = #1087#1088#1080#1084'. '#1041#1080#1079#1085#1077#1089
            DataBinding.FieldName = 'BusinessName_inf'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object BranchName_inf: TcxGridDBColumn
            Caption = #1087#1088#1080#1084'.  '#1060#1080#1083#1080#1072#1083'  ('#1054#1055#1080#1059')'
            DataBinding.FieldName = 'BranchName_inf'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object UnitName_inf: TcxGridDBColumn
            Caption = #1087#1088#1080#1084'. '#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1054#1055#1080#1059')'
            DataBinding.FieldName = 'UnitName_inf'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object RouteName_inf: TcxGridDBColumn
            Caption = #1087#1088#1080#1084'. '#1052#1072#1088#1096#1088#1091#1090
            DataBinding.FieldName = 'RouteName_inf'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object OperPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'OperPrice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object SummStart: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1085#1072#1095#1072#1083#1086
            DataBinding.FieldName = 'SummStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummIn: TcxGridDBColumn
            Caption = #1044#1077#1073#1077#1090
            DataBinding.FieldName = 'SummIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummOut: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'SummOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummEnd: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1082#1086#1085#1077#1094
            DataBinding.FieldName = 'SummEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1056
    ExplicitWidth = 1056
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
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
      end>
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TBankAccountMovementForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end>
    end
    inherited actInsertMask: TdsdInsertUpdateAction
      FormName = 'TBankAccountMovementForm'
      FormNameParam.Value = 'TBankAccountMovementForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
        end
        item
          Name = 'inMovementId_Value'
          Component = MasterCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end>
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TBankAccountMovementForm'
      GuiParams = <
        item
          Name = 'Id'
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
        end
        item
          Name = 'inMovementId_Value'
          Component = MasterCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end>
    end
    object actInsertProfitLossService: TdsdInsertUpdateAction
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1073#1086#1085#1091#1089#1086#1074
      ImageIndex = 27
      FormName = 'TProfitLossServiceForm'
      FormNameParam.Value = 'TProfitLossServiceForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Value = '-1'
        end
        item
          Name = 'inMovementId_Value'
          Component = MasterCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end>
      isShowModal = False
      IdFieldName = 'Id'
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
        end>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDItems'
        end>
      Params = <>
      ReportName = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091
      ReportNameParam.Name = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091
      ReportNameParam.Value = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_BankAccount'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      28
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbInsertMask'
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
          ItemName = 'bbAddBonus'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemContainer'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbAddBonus: TdxBarButton
      Action = actInsertProfitLossService
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_BankAccount'
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_BankAccount'
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_BankAccount'
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 740
    Top = 201
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 740
    Top = 254
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpReport_Account_Print'
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
        Name = 'inAccountGroupId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inAccountDirectionId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inAccountId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inBusinessId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inProfitLossGroupId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inProfitLossDirectionId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inProfitLossId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inBranchId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 663
    Top = 224
  end
end
