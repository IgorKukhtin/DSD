inherited MainForm: TMainForm
  ClientHeight = 207
  ClientWidth = 1093
  KeyPreview = True
  Position = poDesigned
  ExplicitWidth = 1109
  ExplicitHeight = 265
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid [0]
    Left = 0
    Top = 0
    Width = 1093
    Height = 81
    Align = alTop
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = cxcbsNone
    Enabled = False
    TabOrder = 0
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = True
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.ColumnHeaderHints = False
      OptionsCustomize.ColumnFiltering = False
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.ColumnHidingOnGrouping = False
      OptionsCustomize.ColumnMoving = False
      OptionsCustomize.ColumnSorting = False
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GridLines = glNone
      OptionsView.GroupByBox = False
      OptionsView.Header = False
      Styles.Background = cxStyle1
      Styles.Content = cxStyle1
      Styles.Inactive = cxStyle1
      Styles.Selection = cxStyle1
      object colText: TcxGridDBColumn
        DataBinding.FieldName = 'ValueText'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Options.Editing = False
        Width = 100
      end
      object colData: TcxGridDBColumn
        DataBinding.FieldName = 'OperDate'
        Styles.Content = cxStyle1
        Width = 100
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  inherited ActionList: TActionList
    Left = 136
    Top = 32
    object actReport_Branch_App1: TdsdOpenForm [0]
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1083#1080#1072#1083#1099')'
      MoveParams = <>
      Caption = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077' 1 ('#1076#1074#1080#1078#1077#1085#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' '#1043#1055')'
      FormName = 'TReport_Branch_App1Form'
      FormNameParam.Value = 'TReport_Branch_App1Form'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Branch_App7_New: TdsdOpenForm [1]
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1083#1080#1072#1083#1099')'
      MoveParams = <>
      Caption = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077' 7 ('#1089#1074#1086#1076#1085#1099#1081' '#1086#1090#1095#1077#1090') ('#1085#1086#1074#1099#1081')'
      FormName = 'TReport_Branch_App7_NewForm'
      FormNameParam.Value = 'TReport_Branch_App7_NewForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsMI_SendonPrice: TdsdOpenForm [2]
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077
      Hint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077
      FormName = 'TReport_GoodsMI_InternalForm'
      FormNameParam.Value = 'TReport_GoodsMI_InternalForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = '4'
        end
        item
          Name = 'InDescName'
          Value = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077
          DataType = ftString
        end>
      isShowModal = False
    end
    object actPersonalBankAccount: TdsdOpenForm [3]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1042#1099#1087#1083#1072#1090#1072' '#1087#1086' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' ('#1073#1072#1085#1082')'
      Hint = #1042#1099#1087#1083#1072#1090#1072' '#1087#1086' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' ('#1073#1072#1085#1082')'
      FormName = 'TBankAccount_PersonalJournalForm'
      FormNameParam.Value = 'TBankAccount_PersonalJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = '14462'
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1044#1085#1077#1087#1088
          DataType = ftString
        end
        item
          Name = 'InDescName'
          Value = #1050#1072#1089#1089#1072
          DataType = ftString
        end
        item
          Name = 'inProcess'
          Value = 'zc_Enum_Process_PersonalCash()'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actReport_GoodsMI_Package: TdsdOpenForm [4]
      Category = #1054#1090#1095#1077#1090#1099' ('#1087#1088'-'#1074#1086')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1091#1087#1072#1082#1086#1074#1082#1077' '#1080#1083#1080' '#1094#1077#1093' '#1082#1086#1087#1095#1077#1085#1080#1103' '#1087#1077#1095#1072#1090#1100
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1091#1087#1072#1082#1086#1074#1082#1077' '#1080#1083#1080' '#1094#1077#1093' '#1082#1086#1087#1095#1077#1085#1080#1103' '#1087#1077#1095#1072#1090#1100
      FormName = 'TReport_GoodsMI_PackageForm'
      FormNameParam.Value = 'TReport_GoodsMI_PackageForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'InDescName'
          Value = #1055#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
          DataType = ftString
          ParamType = ptUnknown
        end>
      isShowModal = False
    end
    object actReport_Weighing: TdsdOpenForm [5]
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = 'C'#1088#1072#1074#1085#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1080' '#1074#1089#1077#1093' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1081
      FormName = 'TReport_WeighingForm'
      FormNameParam.Value = 'TReport_WeighingForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <>
      isShowModal = False
    end
    object actSale: TdsdOpenForm [6]
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102
      FormName = 'TSaleJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'inChangePercentAmount'
          Value = '0'
          DataType = ftFloat
        end>
      isShowModal = False
    end
    object actReport_Branch_App7: TdsdOpenForm [7]
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1083#1080#1072#1083#1099')'
      MoveParams = <>
      Caption = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077' 7 ('#1089#1074#1086#1076#1085#1099#1081' '#1086#1090#1095#1077#1090')'
      FormName = 'TReport_Branch_App7Form'
      FormNameParam.Value = 'TReport_Branch_App7Form'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReturnOut: TdsdOpenForm [8]
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
      FormName = 'TReturnOutJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsMI_Send: TdsdOpenForm [9]
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      Hint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      FormName = 'TReport_GoodsMI_InternalForm'
      FormNameParam.Value = 'TReport_GoodsMI_InternalForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = '3'
        end
        item
          Name = 'InDescName'
          Value = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
          DataType = ftString
        end>
      isShowModal = False
    end
    object actReturnOut_Partner: TdsdOpenForm [10]
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' - '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1102
      Hint = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
      FormName = 'TReturnOutPartnerJournalForm'
      FormNameParam.Value = 'TReturnOutPartnerJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actIncomePartionGoods: TdsdOpenForm [11]
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084
      Hint = #1055#1088#1080#1093#1086#1076' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084
      FormName = 'TIncomePartionGoodsJournalForm'
      FormNameParam.Value = 'TIncomePartionGoodsJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_PersonalComplete: TdsdOpenForm [12]
      Category = #1054#1090#1095#1077#1090#1099' ('#1087#1088'-'#1074#1086')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084'/'#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1082#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084'/'#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072#1084
      FormName = 'TReport_PersonalCompleteForm'
      FormNameParam.Value = 'TReport_PersonalCompleteForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MotionGoods_Ceh: TdsdOpenForm [13]
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072'('#1062#1077#1093')'
      Hint = #1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072'('#1062#1077#1093')'
      FormName = 'TReport_MotionGoodsCehForm'
      FormNameParam.Value = 'TReport_MotionGoodsCehForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actProductionUnionTech: TdsdOpenForm [14]
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1094#1077#1093' '#1050#1086#1083#1073#1072#1089#1085#1099#1081
      Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1094#1077#1093' '#1050#1086#1083#1073#1072#1089#1085#1099#1081
      FormName = 'TProductionUnionTechJournalForm'
      FormNameParam.Value = 'TProductionUnionTechJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'FromId'
          Value = 8447
        end
        item
          Name = 'FromName'
          Value = #1062#1045#1061' '#1082#1086#1083#1073#1072#1089#1085#1099#1081
          DataType = ftString
        end
        item
          Name = 'ToId'
          Value = 8447
        end
        item
          Name = 'ToName'
          Value = #1062#1045#1061' '#1082#1086#1083#1073#1072#1089#1085#1099#1081
          DataType = ftString
        end>
      isShowModal = False
    end
    object actProductionUnionTechDelic: TdsdOpenForm [15]
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1094#1077#1093' '#1044#1077#1083#1080#1082#1072#1090#1077#1089#1086#1074
      Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1094#1077#1093' '#1044#1077#1083#1080#1082#1072#1090#1077#1089#1086#1074
      FormName = 'TProductionUnionTechJournalForm'
      FormNameParam.Value = 'TProductionUnionTechJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'FromId'
          Value = 8448
        end
        item
          Name = 'FromName'
          Value = #1062#1045#1061' '#1076#1077#1083#1080#1082#1072#1090#1077#1089#1086#1074
          DataType = ftString
        end
        item
          Name = 'ToId'
          Value = 8448
        end
        item
          Name = 'ToName'
          Value = #1062#1045#1061' '#1076#1077#1083#1080#1082#1072#1090#1077#1089#1086#1074
          DataType = ftString
        end>
      isShowModal = False
    end
    object actReport_GoodsMI_ProductionUnionMD: TdsdOpenForm [16]
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1055#1088#1080#1093#1086#1076'/'#1056#1072#1089#1093#1086#1076' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077', '#1076#1077#1090#1072#1083#1100#1085#1086')'
      FormName = 'TReport_GoodsMI_ProductionUnionMDForm'
      FormNameParam.Value = 'TReport_GoodsMI_ProductionUnionMDForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'InDescName'
          Value = #1055#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
          DataType = ftString
          ParamType = ptUnknown
        end>
      isShowModal = False
    end
    object actReport_GoodsBalance: TdsdOpenForm [17]
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1054#1089#1090#1072#1090#1082#1080' '#1090#1086#1074#1072#1088#1072
      FormName = 'TReport_GoodsBalanceForm'
      FormNameParam.Value = 'TReport_GoodsBalanceForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsMI_ProductionSeparate: TdsdOpenForm [18]
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1055#1088#1080#1093#1086#1076'/'#1056#1072#1089#1093#1086#1076' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077')'
      FormName = 'TReport_GoodsMI_ProductionSeparateForm'
      FormNameParam.Value = 'TReport_GoodsMI_ProductionSeparateForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'InDescName'
          Value = #1055#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
          DataType = ftString
          ParamType = ptUnknown
        end>
      isShowModal = False
    end
    object actReport_MotionGoods_Upak: TdsdOpenForm [19]
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072'('#1062#1077#1093' '#1091#1087#1072#1082#1086#1074#1082#1080')'
      Hint = #1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072'('#1062#1077#1093' '#1091#1087#1072#1082#1086#1074#1082#1080')'
      FormName = 'TReport_MotionGoodsUpakForm'
      FormNameParam.Value = 'TReport_MotionGoodsUpakForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actRouteGroup: TdsdOpenForm [20]
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1052#1072#1088#1096#1088#1091#1090#1086#1074
      Hint = #1043#1088#1091#1087#1087#1099' '#1052#1072#1088#1096#1088#1091#1090#1086#1074
      FormName = 'TRouteGroupForm'
      FormNameParam.Value = 'TRouteGroupForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Transport_ProfitLoss: TdsdOpenForm [21]
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1047#1072#1090#1088#1072#1090#1099' '#1090#1088#1072#1085#1089#1087#1086#1088#1090#1072
      Hint = #1047#1072#1090#1088#1072#1090#1099' '#1090#1088#1072#1085#1089#1087#1086#1088#1090#1072
      FormName = 'TReport_Transport_ProfitLossForm'
      FormNameParam.Value = 'TReport_Transport_ProfitLossForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsMI_Internal: TdsdOpenForm [22]
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1057#1087#1080#1089#1072#1085#1080#1077
      FormName = 'TReport_GoodsMI_InternalForm'
      FormNameParam.Value = 'TReport_GoodsMI_InternalForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = '7'
        end
        item
          Name = 'InDescName'
          Value = #1057#1087#1080#1089#1072#1085#1080#1077
          DataType = ftString
        end>
      isShowModal = False
    end
    object actContractGoods: TdsdOpenForm [23]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1074' '#1076#1086#1075#1086#1074#1086#1088#1072#1093
      Hint = #1058#1086#1074#1072#1088#1099' '#1074' '#1076#1086#1075#1086#1074#1086#1088#1072#1093
      FormName = 'TContractGoodsForm'
      FormNameParam.Value = 'TContractGoodsForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsMI_Defroster: TdsdOpenForm [24]
      Category = #1054#1090#1095#1077#1090#1099' ('#1087#1088'-'#1074#1086')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1055#1088#1080#1093#1086#1076'/'#1056#1072#1089#1093#1086#1076' '#1044#1077#1092#1088#1086#1089#1090#1077#1088
      Hint = #1054#1090#1095#1077#1090' '#1055#1088#1080#1093#1086#1076'/'#1056#1072#1089#1093#1086#1076' '#1044#1077#1092#1088#1086#1089#1090#1077#1088
      FormName = 'TReport_GoodsMI_DefrosterForm'
      FormNameParam.Value = 'TReport_GoodsMI_DefrosterForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'InDescName'
          Value = #1055#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
          DataType = ftString
          ParamType = ptUnknown
        end>
      isShowModal = False
    end
    object actJuridical_PrintKindItem: TdsdOpenForm [25]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072' ('#1101#1083#1077#1084#1077#1085#1090#1099' '#1087#1077#1095#1072#1090#1080')'
      Hint = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072' ('#1101#1083#1077#1084#1077#1085#1090#1099' '#1087#1077#1095#1072#1090#1080')'
      FormName = 'TJuridical_PrintKindItemForm'
      FormNameParam.Value = 'TJuridical_PrintKindItemForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCashOperationDneprOfficial: TdsdOpenForm [26]
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' ('#1044#1085#1077#1087#1088' '#1041#1053')'
      Hint = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' ('#1053#1080#1082#1086#1083#1072#1077#1074')'
      FormName = 'TCashJournalUserForm'
      FormNameParam.Value = 'TCashJournalUserForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = '296540'
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1044#1085#1077#1087#1088' '#1041#1053
          DataType = ftString
        end>
      isShowModal = False
    end
    object actOrderType: TdsdOpenForm [27]
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1088#1072#1089#1095#1077#1090#1072' '#1079#1072#1103#1074#1082#1080' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      Hint = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1088#1072#1089#1095#1077#1090#1072' '#1079#1072#1103#1074#1082#1080' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      FormName = 'TOrderTypeForm'
      FormNameParam.Value = 'TOrderTypeForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsMI_ProductionUnion: TdsdOpenForm [28]
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1055#1088#1080#1093#1086#1076'/'#1056#1072#1089#1093#1086#1076' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077')'
      FormName = 'TReport_GoodsMI_ProductionUnionForm'
      FormNameParam.Value = 'TReport_GoodsMI_ProductionUnionForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'InDescName'
          Value = #1055#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
          DataType = ftString
          ParamType = ptUnknown
        end>
      isShowModal = False
    end
    object actForms: TdsdOpenForm [29]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1086#1081
      Hint = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1086#1081
      FormName = 'TFormsForm'
      FormNameParam.Value = 'TFormsForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsGroupAnalyst: TdsdOpenForm [30]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074' ('#1072#1085#1072#1083#1080#1090#1080#1082#1072')'
      Hint = #1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074' ('#1072#1085#1072#1083#1080#1090#1080#1082#1072')'
      FormName = 'TGoodsGroupAnalystForm'
      FormNameParam.Value = 'TGoodsGroupAnalystForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCashOperationKiev: TdsdOpenForm [31]
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' ('#1050#1080#1077#1074')'
      Hint = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' ('#1050#1080#1077#1074')'
      FormName = 'TCashJournalUserForm'
      FormNameParam.Value = 'TCashJournalUserForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = '14686'
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1050#1080#1077#1074
          DataType = ftString
        end>
      isShowModal = False
    end
    object actReport_OrderExternal_Sale: TdsdOpenForm [32]
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1047#1072#1103#1074#1082#1072' / '#1054#1090#1075#1088#1091#1079#1082#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081
      FormName = 'TReport_GoodsMI_OrderExternal_SaleForm'
      FormNameParam.Value = 'TReport_GoodsMI_OrderExternal_SaleForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 1
        end
        item
          Name = 'InDescName'
          Value = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074' ('#1080#1090#1086#1075')'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actPartnerTag: TdsdOpenForm [33]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1088#1075#1086#1074#1086#1081' '#1090#1086#1095#1082#1080
      Hint = #1056#1077#1075#1080#1086#1085#1099
      FormName = 'TPartnerTagForm'
      FormNameParam.Value = 'TPartnerTagForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Promo: TdsdOpenForm [34]
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1072#1082#1094#1080#1103#1084
      FormName = 'TReport_PromoForm'
      FormNameParam.Value = 'TReport_PromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <>
      isShowModal = False
    end
    object actReceiptCost: TdsdOpenForm [35]
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1047#1072#1090#1088#1072#1090#1099' '#1074' '#1088#1077#1094#1077#1087#1090#1091#1088#1072#1093
      Hint = #1047#1072#1090#1088#1072#1090#1099' '#1074' '#1088#1077#1094#1077#1087#1090#1091#1088#1072#1093
      FormName = 'TReceiptCostForm'
      FormNameParam.Value = 'TReceiptCostForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actQuality: TdsdOpenForm [36]
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1082#1072#1095#1077#1089#1090#1074#1077#1085#1085#1099#1093' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1081
      Hint = #1042#1080#1076#1099' '#1082#1072#1095#1077#1089#1090#1074#1077#1085#1085#1099#1093' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1081
      FormName = 'TQualityForm'
      FormNameParam.Value = 'TQualityForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsPlatform: TdsdOpenForm [37]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' '#1087#1083#1086#1097#1072#1076#1082#1072
      Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' '#1087#1083#1086#1097#1072#1076#1082#1072
      FormName = 'TGoodsPlatformForm'
      FormNameParam.Value = 'TGoodsPlatformForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsMI_SaleReturnInUnitNew: TdsdOpenForm [38]
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1057#1082#1083#1072#1076' '#1055#1088#1086#1076#1072#1078#1072' / '#1042#1086#1079#1074#1088#1072#1090' '#1087#1086' '#1076#1072#1090#1077' '#1089#1082#1083#1072#1076
      FormName = 'TReport_GoodsMI_SaleReturnInUnitNewForm'
      FormNameParam.Value = 'TReport_GoodsMI_SaleReturnInUnitNewForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <>
      isShowModal = False
    end
    object actContractPartner: TdsdOpenForm [39]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' '#1074' '#1076#1086#1075#1086#1074#1086#1088#1072#1093
      Hint = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' '#1074' '#1076#1086#1075#1086#1074#1086#1088#1072#1093
      FormName = 'TContractPartnerForm'
      FormNameParam.Value = 'TContractPartnerForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actContractTag: TdsdOpenForm [40]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075#1086#1074#1086#1088#1072
      Hint = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075#1086#1074#1086#1088#1072
      FormName = 'TContractTagForm'
      FormNameParam.Value = 'TContractTagForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actIncome: TdsdOpenForm [41]
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      FormName = 'TIncomeJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actIncomePartner: TdsdOpenForm [42]
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' - '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1102
      Hint = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' - '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1102
      FormName = 'TIncomePartnerJournalForm'
      FormNameParam.Value = 'TIncomePartnerJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actRetail_PrintKindItem: TdsdOpenForm [43]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' ('#1101#1083#1077#1084#1077#1085#1090#1099' '#1087#1077#1095#1072#1090#1080')'
      Hint = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' ('#1101#1083#1077#1084#1077#1085#1090#1099' '#1087#1077#1095#1072#1090#1080')'
      FormName = 'TRetail_PrintKindItemForm'
      FormNameParam.Value = 'TRetail_PrintKindItemForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Personal: TdsdOpenForm [44]
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1079#1087
      FormName = 'TReport_PersonalForm'
      FormNameParam.Value = 'TReport_PersonalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actRoleUnion: TdsdOpenForm [45]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1056#1086#1083#1080' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' ('#1087#1086#1076#1088#1086#1073#1085#1086')'
      FormName = 'TRoleUnionForm'
      FormNameParam.Value = 'TRoleUnionForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsQuality: TdsdOpenForm [46]
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1090#1086#1074#1072#1088#1072' '#1076#1083#1103' '#1050'.'#1059'.'
      Hint = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1090#1086#1074#1072#1088#1072' '#1076#1083#1103' '#1050'.'#1059'.'
      FormName = 'TGoodsQualityForm'
      FormNameParam.Value = 'TGoodsQualityForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actAdvertising: TdsdOpenForm [47]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080'\'#1040#1082#1094#1080#1080
      MoveParams = <>
      Caption = #1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072
      Hint = #1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072
      FormName = 'TAdvertisingForm'
      FormNameParam.Value = 'TAdvertisingForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCashOperationKrRog: TdsdOpenForm [48]
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' ('#1050#1088#1080#1074#1086#1081' '#1056#1086#1075')'
      Hint = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' ('#1050#1088#1080#1074#1086#1081' '#1056#1086#1075')'
      FormName = 'TCashJournalUserForm'
      FormNameParam.Value = 'TCashJournalUserForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = '279788'
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1050#1088#1080#1074#1086#1081' '#1056#1086#1075
          DataType = ftString
        end>
      isShowModal = False
    end
    object actCashOperationNikolaev: TdsdOpenForm [49]
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' ('#1053#1080#1082#1086#1083#1072#1077#1074')'
      Hint = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' ('#1053#1080#1082#1086#1083#1072#1077#1074')'
      FormName = 'TCashJournalUserForm'
      FormNameParam.Value = 'TCashJournalUserForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = '279789'
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1053#1080#1082#1086#1083#1072#1077#1074
          DataType = ftString
        end>
      isShowModal = False
    end
    object actCashOperationKharkov: TdsdOpenForm [50]
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' ('#1061#1072#1088#1100#1082#1086#1074')'
      Hint = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' ('#1061#1072#1088#1100#1082#1086#1074')'
      FormName = 'TCashJournalUserForm'
      FormNameParam.Value = 'TCashJournalUserForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = '279790'
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1061#1072#1088#1100#1082#1086#1074
          DataType = ftString
        end>
      isShowModal = False
    end
    object actCashOperationCherkassi: TdsdOpenForm [51]
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' ('#1063#1077#1088#1082#1072#1089#1089#1099')'
      Hint = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' ('#1063#1077#1088#1082#1072#1089#1089#1099')'
      FormName = 'TCashJournalUserForm'
      FormNameParam.Value = 'TCashJournalUserForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = '279791'
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1063#1077#1088#1082#1072#1089#1089#1099
          DataType = ftString
        end>
      isShowModal = False
    end
    object actGoodsByGoodsKind: TdsdOpenForm [52]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1090#1086#1074#1072#1088' '#1080' '#1074#1080#1076' '#1090#1086#1074#1072#1088#1072
      Hint = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1058#1086#1074#1072#1088' '#1080' '#1042#1080#1076' '#1090#1086#1074#1072#1088#1072
      FormName = 'TGoodsByGoodsKindForm'
      FormNameParam.Value = 'TGoodsByGoodsKindForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPersonalService: TdsdOpenForm [53]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1079#1072#1088#1087#1083#1072#1090#1099
      Hint = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1079#1072#1088#1087#1083#1072#1090#1099
      FormName = 'TPersonalServiceJournalForm'
      FormNameParam.Value = 'TPersonalServiceJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCashOperationZaporozhye: TdsdOpenForm [54]
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' ('#1047#1072#1087#1086#1088#1086#1078#1100#1077')'
      Hint = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' ('#1047#1072#1087#1086#1088#1086#1078#1100#1077')'
      FormName = 'TCashJournalUserForm'
      FormNameParam.Value = 'TCashJournalUserForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = '301799'
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1047#1072#1087#1086#1088#1086#1078#1100#1077
          DataType = ftString
        end>
      isShowModal = False
    end
    object actCashOperationOdessa: TdsdOpenForm [55]
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' ('#1054#1076#1077#1089#1089#1072')'
      Hint = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' ('#1054#1076#1077#1089#1089#1072')'
      FormName = 'TCashJournalUserForm'
      FormNameParam.Value = 'TCashJournalUserForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = '280296'
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1054#1076#1077#1089#1089#1072
          DataType = ftString
        end>
      isShowModal = False
    end
    object actCashOperationOld: TdsdOpenForm [56]
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' (Integer)'
      Hint = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' (Integer)'
      FormName = 'TCashJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = '273734'
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' Integer'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actCashOperationPav: TdsdOpenForm [57]
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' ('#1055#1072#1074#1080#1083#1100#1086#1085#1099' '#1041#1053')'
      Hint = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' ('#1055#1072#1074#1080#1083#1100#1086#1085#1099' '#1041#1053')'
      FormName = 'TCashJournalUserForm'
      FormNameParam.Value = 'TCashJournalUserForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = '407280'
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1055#1072#1074#1080#1083#1100#1086#1085#1099' '#1041#1053
          DataType = ftString
        end>
      isShowModal = False
    end
    object actPersonalReport: TdsdOpenForm [58]
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1040#1074#1072#1085#1089#1086#1074#1099#1081' '#1086#1090#1095#1077#1090
      FormName = 'TPersonalReportJournalForm'
      FormNameParam.Value = 'TPersonalReportJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPersonalServiceList: TdsdOpenForm [59]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
      Hint = #1042#1077#1076#1086#1084#1086#1089#1090#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
      FormName = 'TPersonalServiceListForm'
      FormNameParam.Value = 'TPersonalServiceListForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actArticleLoss: TdsdOpenForm [60]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1090#1072#1090#1100#1080' '#1089#1087#1080#1089#1072#1085#1080#1103
      Hint = #1057#1090#1072#1090#1100#1080' '#1089#1087#1080#1089#1072#1085#1080#1103
      FormName = 'TArticleLossForm'
      FormNameParam.Value = 'TArticleLossForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Founders: TdsdOpenForm [61]
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1091#1095#1088#1077#1076#1080#1090#1077#1083#1103#1084
      FormName = 'TReport_FoundersForm'
      FormNameParam.Value = 'TReport_FoundersForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actFounder: TdsdOpenForm [62]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1059#1095#1088#1077#1076#1080#1090#1077#1083#1080
      Hint = #1059#1095#1088#1077#1076#1080#1090#1077#1083#1080
      FormName = 'TFounderForm'
      FormNameParam.Value = 'TFounderForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCorrAccount: TdsdOpenForm [63]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1088#1088#1077#1089#1087#1086#1085#1076#1077#1085#1090#1089#1082#1080#1077' '#1089#1095#1077#1090#1072
      Hint = #1050#1086#1088#1088#1077#1089#1087#1086#1085#1076#1077#1085#1090#1089#1082#1080#1077' '#1089#1095#1077#1090#1072
      FormName = 'TCorrespondentAccountForm'
      FormNameParam.Value = 'TCorrespondentAccountForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actRetailReport: TdsdOpenForm [64]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' ('#1086#1090#1095#1077#1090')'
      Hint = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
      FormName = 'TRetailReportForm'
      FormNameParam.Value = 'TRetailReportForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReceipt: TdsdOpenForm [65]
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1056#1077#1094#1077#1087#1090#1091#1088#1099
      Hint = #1056#1077#1094#1077#1087#1090#1091#1088#1099
      FormName = 'TReceiptForm'
      FormNameParam.Value = 'TReceiptForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_BankAccount: TdsdOpenForm [66]
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088'/'#1089#1095#1077#1090#1091
      FormName = 'TReport_BankAccountForm'
      FormNameParam.Value = 'TReport_BankAccountForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Cash: TdsdOpenForm [67]
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1082#1072#1089#1089#1077
      FormName = 'TReport_CashForm'
      FormNameParam.Value = 'TReport_CashForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Member: TdsdOpenForm [68]
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1087#1086#1076#1086#1090#1095#1077#1090#1091
      FormName = 'TReport_MemberForm'
      FormNameParam.Value = 'TReport_MemberForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ProductionOrder: TdsdOpenForm [69]
      Category = #1054#1090#1095#1077#1090#1099' ('#1087#1088'-'#1074#1086')'
      MoveParams = <>
      Caption = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      FormName = 'TProductionOrderReportForm'
      FormNameParam.Value = 'TProductionOrderReportForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <>
      isShowModal = False
    end
    object actJuridicalGLN: TdsdOpenForm [70]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072' ('#1080#1079#1084#1077#1085#1077#1085#1080#1077' GLN)'
      Hint = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072' ('#1080#1079#1084#1077#1085#1077#1085#1080#1077' GLN)'
      FormName = 'TJuridicalGLNForm'
      FormNameParam.Value = 'TJuridicalGLNForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCashOperation: TdsdOpenForm [71]
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076' ('#1044#1085#1077#1087#1088')'
      Hint = #1050#1072#1089#1089#1072', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
      FormName = 'TCashJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = 14462
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1044#1085#1077#1087#1088
          DataType = ftString
        end>
      isShowModal = False
    end
    object actContractTagGroup: TdsdOpenForm [72]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1087#1088#1080#1079#1085#1072#1082#1086#1074' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
      Hint = #1043#1088#1091#1087#1087#1099' '#1087#1088#1080#1079#1085#1072#1082#1086#1074' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
      FormName = 'TContractTagGroupForm'
      FormNameParam.Value = 'TContractTagGroupForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPartnerGLN: TdsdOpenForm [73]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1080#1079#1084#1077#1085#1077#1085#1080#1077' GLN)'
      Hint = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1080#1079#1084#1077#1085#1077#1085#1080#1077' GLN)'
      FormName = 'TPartnerGLNForm'
      FormNameParam.Value = 'TPartnerGLNForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_LoginProtocol: TdsdOpenForm [94]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
      Hint = #1055#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
      FormName = 'TReport_LoginProtocolForm'
      FormNameParam.Value = 'TReport_LoginProtocolForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actAssetGroup: TdsdOpenForm
      Category = #1054#1057
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1054#1057
      Hint = #1043#1088#1091#1087#1087#1099' '#1086#1089#1085#1086#1074#1085#1099#1093' '#1089#1088#1077#1076#1089#1090#1074' '
      FormName = 'TAssetGroupForm'
      FormNameParam.Value = 'TAssetGroupForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actAreaContract: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1056#1077#1075#1080#1086#1085#1099' ('#1076#1086#1075#1086#1074#1086#1088#1072')'
      Hint = #1056#1077#1075#1080#1086#1085#1099
      FormName = 'TAreaContractForm'
      FormNameParam.Value = 'TAreaContractForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actContactPersonKind: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076' '#1082#1086#1085#1090#1072#1082#1090#1072
      Hint = #1042#1080#1076' '#1082#1086#1085#1090#1072#1082#1090#1072
      FormName = 'TContactPersonKindForm'
      FormNameParam.Value = 'TContactPersonKindForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actAsset: TdsdOpenForm
      Category = #1054#1057
      MoveParams = <>
      Caption = #1054#1089#1085#1086#1074#1085#1099#1077' '#1089#1088#1077#1076#1089#1090#1074#1072' '
      Hint = #1054#1089#1085#1086#1074#1085#1099#1077' '#1089#1088#1077#1076#1089#1090#1074#1072' '
      FormName = 'TAssetForm'
      FormNameParam.Value = 'TAssetForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actContactPerson: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1099#1077' '#1083#1080#1094#1072
      Hint = #1050#1086#1085#1090#1072#1082#1090#1085#1099#1077' '#1083#1080#1094#1072
      FormName = 'TContactPersonForm'
      FormNameParam.Value = 'TContactPersonForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actProvinceCity: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1056#1072#1081#1086#1085' '#1074' '#1085#1072#1089#1077#1083#1077#1085#1085#1086#1084' '#1087#1091#1085#1082#1090#1077
      Hint = #1056#1072#1081#1086#1085' '#1074' '#1085#1072#1089#1077#1083#1077#1085#1085#1086#1084' '#1087#1091#1085#1082#1090#1077
      FormName = 'TProvinceCityForm'
      FormNameParam.Value = 'TProvinceCityForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actProvince: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1056#1072#1081#1086#1085
      Hint = #1056#1072#1081#1086#1085
      FormName = 'TProvinceForm'
      FormNameParam.Value = 'TProvinceForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_OrderExternal: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1079#1072#1103#1074#1082#1080'  ('#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081')'
      FormName = 'TReport_GoodsMI_OrderExternalForm'
      FormNameParam.Value = 'TReport_GoodsMI_OrderExternalForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 1
        end
        item
          Name = 'InDescName'
          Value = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074' ('#1080#1090#1086#1075')'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actMaker: TdsdOpenForm
      Category = #1054#1057
      MoveParams = <>
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100' '#1054#1057
      Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100' ('#1054#1057')'
      FormName = 'TMakerForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsTag: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072
      Hint = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072
      FormName = 'TGoodsTagForm'
      FormNameParam.Value = 'TGoodsTagForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_JuridicalSold: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1102#1088'.'#1083#1080#1094#1072#1084
      FormName = 'TReport_JuridicalSoldForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actStorage_Object: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1052#1077#1089#1090#1072' '#1093#1088#1072#1085#1077#1085#1080#1103
      Hint = #1052#1077#1089#1090#1072' '#1093#1088#1072#1085#1077#1085#1080#1103
      FormName = 'TStorage_ObjectForm'
      FormNameParam.Value = 'TStorage_ObjectForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actStreet: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1059#1083#1080#1094#1072'/'#1087#1088#1086#1089#1087#1077#1082#1090
      Hint = #1059#1083#1080#1094#1072'/'#1087#1088#1086#1089#1087#1077#1082#1090
      FormName = 'TStreetForm'
      FormNameParam.Value = 'TStreetForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actStreetKind: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076'('#1091#1083#1080#1094#1072','#1087#1088#1086#1089#1087#1077#1082#1090')'
      Hint = #1042#1080#1076'('#1091#1083#1080#1094#1072','#1087#1088#1086#1089#1087#1077#1082#1090')'
      FormName = 'TStreetKindForm'
      FormNameParam.Value = 'TStreetKindForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actBankAccountContract: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1088'/'#1089#1095' '#1076#1083#1103' '#1042#1089#1077#1093' ('#1087#1077#1095#1072#1090#1100')'
      Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1088'/'#1089#1095' '#1076#1083#1103' '#1042#1089#1077#1093' ('#1087#1077#1095#1072#1090#1100')'
      FormName = 'TBankAccountContractForm'
      FormNameParam.Value = 'TBankAccountContractForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCityKind: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076' '#1085#1072#1089#1077#1083#1077#1085#1085#1086#1075#1086' '#1087#1091#1085#1082#1090#1072
      Hint = #1042#1080#1076' '#1085#1072#1089#1077#1083#1077#1085#1085#1086#1075#1086' '#1087#1091#1085#1082#1090#1072
      FormName = 'TCityKindForm'
      FormNameParam.Value = 'TCityKindForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_JuridicalDefermentPayment: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1080' '#1089' '#1086#1090#1089#1088#1086#1095#1082#1086#1081
      FormName = 'TReport_JuridicalDefermentPaymentForm'
      FormNameParam.Value = 'TReport_JuridicalDefermentPaymentForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actTransport: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090
      Hint = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090
      FormName = 'TTransportJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actIncomeFuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1047#1072#1087#1088#1072#1074#1082#1072' '#1072#1074#1090#1086') '
      Hint = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1079#1072#1087#1088#1072#1074#1082#1072' '#1072#1074#1090#1086') '
      FormName = 'TIncomeFuelJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsGroupStat: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074' ('#1089#1090#1072#1090#1080#1089#1090#1080#1082#1072')'
      Hint = #1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074' ('#1089#1090#1072#1090#1080#1089#1090#1080#1082#1072')'
      FormName = 'TGoodsGroupStatForm'
      FormNameParam.Value = 'TGoodsGroupStatForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPersonalSendCash: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1056#1072#1089#1093#1086#1076' '#1076#1077#1085#1077#1075' '#1089' '#1087#1086#1076#1086#1090#1095#1077#1090#1072' '#1085#1072' '#1087#1086#1076#1086#1090#1095#1077#1090
      Hint = #1056#1072#1089#1093#1086#1076' '#1076#1077#1085#1077#1075' '#1089' '#1087#1086#1076#1086#1090#1095#1077#1090#1072' '#1085#1072' '#1087#1086#1076#1086#1090#1095#1077#1090
      FormName = 'TPersonalSendCashJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPersonalGroup: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1080' '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' '
      Hint = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1080' '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' '
      FormName = 'TPersonalGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actRetail: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
      Hint = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
      FormName = 'TRetailForm'
      FormNameParam.Value = 'TRetailForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPersonal: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080' '
      Hint = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080' '
      FormName = 'TPersonalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPosition: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1080' '
      Hint = #1044#1086#1083#1078#1085#1086#1089#1090#1080' '
      FormName = 'TPositionForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCalendar: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1050#1072#1083#1077#1085#1076#1072#1088#1100' '#1088#1072#1073#1086#1095#1080#1093' '#1076#1085#1077#1081
      Hint = #1050#1072#1083#1077#1085#1076#1072#1088#1100' '#1088#1072#1073#1086#1095#1080#1093' '#1076#1085#1077#1081
      FormName = 'TCalendarForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPersonalAccount: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1056#1072#1089#1095#1077#1090#1099' '#1087#1086#1076#1086#1090#1095#1077#1090#1072' '#1089' '#1102#1088'.'#1083#1080#1094#1086#1084
      Hint = #1056#1072#1089#1095#1077#1090#1099' '#1087#1086#1076#1086#1090#1095#1077#1090#1072' '#1089' '#1102#1088'.'#1083#1080#1094#1086#1084
      FormName = 'TPersonalAccountJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actMember: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      Hint = #1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      FormName = 'TMemberForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actTransportService: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1085#1072#1077#1084#1085#1099#1081' '#1090#1088#1072#1085#1089#1087#1086#1088#1090
      Hint = #1056#1072#1089#1095#1077#1090#1099' '#1087#1086#1076#1086#1090#1095#1077#1090#1072' '#1089' '#1102#1088'.'#1083#1080#1094#1086#1084
      FormName = 'TTransportServiceJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actSendTicketFuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' ('#1058#1072#1083#1086#1085#1099' '#1085#1072' '#1090#1086#1087#1083#1080#1074#1086')'
      Hint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' ('#1058#1072#1083#1086#1085#1099' '#1085#1072' '#1090#1086#1087#1083#1080#1074#1086')'
      FormName = 'TSendTicketFuelJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actMemberExternal: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072'('#1089#1090#1086#1088#1086#1085#1085#1080#1077')'
      Hint = #1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072'('#1089#1090#1086#1088#1086#1085#1085#1080#1077')'
      FormName = 'TMemberExternalForm'
      FormNameParam.Value = 'TMemberExternalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actStaffListData: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1064#1090#1072#1090#1085#1086#1077' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077
      Hint = #1096#1090#1072#1090#1085#1086#1077' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077
      FormName = 'TStaffListDataForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCar: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1080
      Hint = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1080
      FormName = 'TCarForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actRoute: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1052#1072#1088#1096#1088#1091#1090#1099
      Hint = #1052#1072#1088#1096#1088#1091#1090#1099
      FormName = 'TRouteForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCarModel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1052#1072#1088#1082#1080' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1077#1081
      Hint = #1052#1072#1088#1082#1080' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1077#1081
      FormName = 'TCarModelForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actFuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1090#1086#1087#1083#1080#1074#1072
      Hint = #1042#1080#1076#1099' '#1090#1086#1087#1083#1080#1074#1072
      FormName = 'TFuelForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPartnerAddress: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      Hint = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1072#1076#1088#1077#1089#1072')'
      FormName = 'TPartnerAddressForm'
      FormNameParam.Value = 'TPartnerAddressForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actRateFuelKind: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1085#1086#1088#1084' '#1090#1086#1087#1083#1080#1074#1072
      Hint = #1042#1080#1076#1099' '#1085#1086#1088#1084' '#1090#1086#1087#1083#1080#1074#1072
      FormName = 'TRateFuelKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Balance: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      MoveParams = <>
      Caption = #1041#1072#1083#1072#1085#1089
      FormName = 'TReport_BalanceForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ProfitLoss: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1086' '#1055#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1059#1073#1099#1090#1082#1072#1093
      FormName = 'TReport_ProfitLossForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actProcess: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1088#1086#1094#1077#1089#1089#1099
      Hint = #1055#1088#1086#1094#1077#1089#1089#1099
      FormName = 'TProcessForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_HistoryCost: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1057#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1100
      FormName = 'TReport_HistoryCostForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actSaleAll: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' ('#1074#1089#1077')'
      FormName = 'TSaleJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'inChangePercentAmount'
          Value = '1'
          DataType = ftFloat
        end>
      isShowModal = False
    end
    object actSale_Partner: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' ('#1073#1091#1093'.)'
      FormName = 'TSale_PartnerJournalForm'
      FormNameParam.Value = 'TSale_PartnerJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'inChangePercentAmount'
          Value = '1'
          DataType = ftFloat
        end>
      isShowModal = False
    end
    object actSale_Order: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' ('#1087#1086' '#1079#1072#1103#1074#1082#1077')'
      FormName = 'TSale_OrderJournalForm'
      FormNameParam.Value = 'TSale_OrderJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'inChangePercentAmount'
          Value = '1'
          DataType = ftFloat
        end>
      isShowModal = False
    end
    object actReturnIn: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' ('#1074#1089#1077')'
      FormName = 'TReturnInJournalForm'
      FormNameParam.Value = 'TReturnInJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReturnIn_Partner: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
      FormName = 'TReturnIn_PartnerJournalForm'
      FormNameParam.Value = 'TReturnIn_PartnerJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actSendOnPrice: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077
      FormName = 'TSendOnPriceJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'inChangePercentAmount'
          Value = '1'
          DataType = ftFloat
        end>
      isShowModal = False
    end
    object actRegion: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1054#1073#1083#1072#1089#1090#1100
      Hint = #1054#1073#1083#1072#1089#1090#1100
      FormName = 'TRegionForm'
      FormNameParam.Value = 'TRegionForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actSendOnPrice_Branch: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077' ('#1092#1080#1083#1080#1072#1083')'
      FormName = 'TSendOnPrice_BranchJournalForm'
      FormNameParam.Value = 'TSendOnPrice_BranchJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'inChangePercentAmount'
          Value = '0'
          DataType = ftFloat
        end>
      isShowModal = False
    end
    object actSend: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      FormName = 'TSendJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actProductionSeparate: TdsdOpenForm
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      FormName = 'TProductionSeparateJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actProductionUnion: TdsdOpenForm
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077
      Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077
      FormName = 'TProductionUnionJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actOrderInternal: TdsdOpenForm
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1047#1072#1103#1074#1082#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' ('#1062#1077#1093')'
      Hint = #1047#1072#1103#1074#1082#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' ('#1062#1077#1093')'
      FormName = 'TOrderInternalJournalForm'
      FormNameParam.Value = 'TOrderInternalJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'inFromId'
          Value = '8457'
        end
        item
          Name = 'inToId'
          Value = '8446'
        end>
      isShowModal = False
    end
    object actOrderInternalPack: TdsdOpenForm
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1047#1072#1103#1074#1082#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' ('#1062#1077#1093' '#1091#1087#1072#1082#1086#1074#1082#1080')'
      Hint = #1047#1072#1103#1074#1082#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' ('#1062#1077#1093' '#1091#1087#1072#1082#1086#1074#1082#1080')'
      FormName = 'TOrderInternalPackJournalForm'
      FormNameParam.Value = 'TOrderInternalPackJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'inFromId'
          Value = '8457'
        end
        item
          Name = 'inToId'
          Value = '8451'
        end>
      isShowModal = False
    end
    object actLoss: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1057#1087#1080#1089#1072#1085#1080#1077
      FormName = 'TLossJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actInventory: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
      FormName = 'TInventoryJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actProductionPeresort: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072
      FormName = 'TProductionPeresortJournalForm'
      FormNameParam.Value = 'TProductionPeresortJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actBank: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1041#1072#1085#1082#1080
      Hint = #1041#1072#1085#1082#1080
      FormName = 'TBankForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actBankAccount: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1089#1095#1077#1090#1072
      Hint = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1089#1095#1077#1090#1072
      FormName = 'TBankAccountForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actBranch: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1060#1080#1083#1080#1072#1083#1099
      Hint = #1060#1080#1083#1080#1072#1083#1099
      FormName = 'TBranchForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actBusiness: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1041#1080#1079#1085#1077#1089#1099
      Hint = #1041#1080#1079#1085#1077#1089#1099
      FormName = 'TBusinessForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCash: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1072
      Hint = #1050#1072#1089#1089#1072
      FormName = 'TCashForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actContractKind: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
      Hint = #1042#1080#1076#1099' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
      FormName = 'TContractKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actContractConditionValue: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1044#1086#1075#1086#1074#1086#1088#1072' ('#1089' '#1091#1089#1083#1086#1074#1080#1103#1084#1080')'
      Hint = #1044#1086#1075#1086#1074#1086#1088#1072' ('#1089' '#1091#1089#1083#1086#1074#1080#1103#1084#1080')'
      FormName = 'TContractConditionValueForm'
      FormNameParam.Value = 'TContractConditionValueForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actContract: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1044#1086#1075#1086#1074#1086#1088#1072
      Hint = #1044#1086#1075#1086#1074#1086#1088#1072
      FormName = 'TContractForm'
      FormNameParam.Value = 'TContractForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actContractArticle: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1077#1076#1084#1077#1090' '#1076#1086#1075#1086#1074#1086#1088#1072
      Hint = #1055#1088#1077#1076#1084#1077#1090' '#1076#1086#1075#1086#1074#1086#1088#1072
      FormName = 'TContractArticleForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actArea: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1056#1077#1075#1080#1086#1085#1099
      Hint = #1056#1077#1075#1080#1086#1085#1099
      FormName = 'TAreaForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCurrency: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1072#1083#1102#1090#1099
      Hint = #1042#1072#1083#1102#1090#1099
      FormName = 'TCurrencyForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoods_List: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' ('#1089#1087#1080#1089#1086#1082')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoods: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsTreeForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TGoodsGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsKind: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsProperty: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TGoodsPropertyForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsPropertyValue: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1047#1085#1072#1095#1077#1085#1080#1103' '#1076#1083#1103' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1047#1085#1072#1095#1077#1085#1080#1103' '#1076#1083#1103' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TGoodsPropertyValueForm'
      FormNameParam.Value = 'TGoodsPropertyValueForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actJuridical_List: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072' ('#1089#1087#1080#1089#1086#1082')'
      Hint = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      FormName = 'TJuridicalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actJuridical: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      Hint = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      FormName = 'TJuridicalTreeForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actJuridical_PriceList: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072' ('#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1055#1088#1072#1081#1089')'
      Hint = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072' ('#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1055#1088#1072#1081#1089')'
      FormName = 'TJuridical_PriceListForm'
      FormNameParam.Value = 'TJuridical_PriceListForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actJuridicalGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1093' '#1083#1080#1094
      Hint = #1043#1088#1091#1087#1087#1099' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1093' '#1083#1080#1094
      FormName = 'TJuridicalGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actMeasure: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
      Hint = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
      FormName = 'TMeasureForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actBox: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1071#1097#1080#1082#1080
      Hint = #1071#1097#1080#1082#1080
      FormName = 'TBoxForm'
      FormNameParam.Value = 'TBoxForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPaidKind: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
      Hint = #1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
      FormName = 'TPaidKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPartner: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      Hint = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      FormName = 'TPartnerForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPartner_PriceList: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1055#1088#1072#1081#1089')'
      Hint = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1055#1088#1072#1081#1089')'
      FormName = 'TPartner_PriceListForm'
      FormNameParam.Value = 'TPartner_PriceListForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPartner_PriceList_view: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1087#1088#1086#1074#1077#1088#1082#1072' '#1055#1088#1072#1081#1089')'
      Hint = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      FormName = 'TPartner_PriceList_viewForm'
      FormNameParam.Value = 'TPartner_PriceList_viewForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actUnit_List: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' ('#1089#1087#1080#1089#1086#1082')'
      Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      FormName = 'TUnitForm'
      FormNameParam.Value = 'TUnitForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actUnit: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPriceList: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1099
      Hint = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090#1099
      FormName = 'TPriceListForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actTradeMark: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1088#1075#1086#1074#1099#1077' '#1084#1072#1088#1082#1080
      Hint = #1058#1086#1088#1075#1086#1074#1099#1077' '#1084#1072#1088#1082#1080
      FormName = 'TTradeMarkForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actRouteSorting: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1080' '#1084#1072#1088#1096#1088#1091#1090#1086#1074
      Hint = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1080' '#1084#1072#1088#1096#1088#1091#1090#1086#1074
      FormName = 'TRouteSortingForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actOrderExternal: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1047#1072#1103#1074#1082#1072' '#1089#1090#1086#1088#1086#1085#1085#1103#1103' ('#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103')'
      FormName = 'TOrderExternalJournalForm'
      FormNameParam.Value = 'TOrderExternalJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPriceListItem: TdsdOpenForm
      Category = #1048#1089#1090#1086#1088#1080#1080
      MoveParams = <>
      Caption = #1048#1089#1090#1086#1088#1080#1080' '#1094#1077#1085' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1048#1089#1090#1086#1088#1080#1080' '#1094#1077#1085' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TPriceListItemForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actQualityParams: TdsdOpenForm
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1046#1091#1088#1085#1072#1083' '#1050'.'#1059'. - '#1087#1072#1088#1072#1084#1077#1090#1088#1099
      Hint = #1046#1091#1088#1085#1072#1083' '#1050'.'#1059'. - '#1087#1072#1088#1072#1084#1077#1090#1088#1099
      FormName = 'TQualityParamsJournalForm'
      FormNameParam.Value = 'TQualityParamsJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MotionGoods: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
      FormName = 'TReport_MotionGoodsForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actRole: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1056#1086#1083#1080' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
      FormName = 'TRoleForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actAction: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1044#1077#1081#1089#1090#1074#1080#1103
      Hint = #1044#1077#1081#1089#1090#1074#1080#1103
      FormName = 'TActionForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actUser: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
      Hint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
      FormName = 'TUserForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actRateFuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1053#1086#1088#1084#1099' '#1090#1086#1087#1083#1080#1074#1072
      Hint = #1053#1086#1088#1084#1099' '#1090#1086#1087#1083#1080#1074#1072
      FormName = 'TRateFuelForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actFreight: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1053#1072#1079#1074#1072#1085#1080#1103' '#1075#1088#1091#1079#1086#1074
      Hint = #1053#1072#1079#1074#1072#1085#1080#1103' '#1075#1088#1091#1079#1086#1074
      FormName = 'TFreightForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCardFuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1058#1086#1087#1083#1080#1074#1085#1099#1077' '#1082#1072#1088#1090#1099
      Hint = #1058#1086#1087#1083#1080#1074#1085#1099#1077' '#1082#1072#1088#1090#1099
      FormName = 'TCardFuelForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actTicketFuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1058#1072#1083#1086#1085#1099' '#1085#1072' '#1090#1086#1087#1083#1080#1074#1086' '
      Hint = #1058#1072#1083#1086#1085#1099' '#1085#1072' '#1090#1086#1087#1083#1080#1074#1086' '
      FormName = 'TTicketFuelForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Fuel: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1088#1072#1089#1093#1086#1076#1072' '#1090#1086#1087#1083#1080#1074#1072
      Hint = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1088#1072#1089#1093#1086#1076#1072' '#1090#1086#1087#1083#1080#1074#1072
      FormName = 'TReport_FuelForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Transport: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1091#1090#1077#1074#1099#1084' '#1083#1080#1089#1090#1072#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1091#1090#1077#1074#1099#1084' '#1083#1080#1089#1090#1072#1084
      FormName = 'TReport_TransportForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_TransportHoursWork: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1086#1076#1080#1090#1077#1083#1103#1084' ('#1088#1072#1073#1086#1095#1077#1077' '#1074#1088#1077#1084#1103')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1086#1076#1080#1090#1077#1083#1103#1084' ('#1088#1072#1073#1086#1095#1077#1077' '#1074#1088#1077#1084#1103')'
      FormName = 'TReport_TransportHoursWorkForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actWorkTimeKind: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1058#1080#1087#1099' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      Hint = #1058#1080#1087#1099' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      FormName = 'TWorkTimeKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actSheetWorkTime: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1058#1072#1073#1077#1083#1100' '#1091#1095#1077#1090#1072' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      Hint = #1058#1072#1073#1077#1083#1100' '#1091#1095#1077#1090#1072' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      FormName = 'TSheetWorkTimeJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Account: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1091
      FormName = 'TReport_AccountForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_TransportList: TdsdOpenForm
      Category = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      MoveParams = <>
      Caption = #1056#1077#1077#1089#1090#1088' '#1087#1091#1090#1077#1074#1099#1093' + '#1085#1072#1077#1084#1085#1099#1081' '#1090#1088#1072#1085#1089#1087#1086#1088#1090
      Hint = #1056#1077#1077#1089#1090#1088' '#1087#1091#1090#1077#1074#1099#1093' + '#1085#1072#1077#1084#1085#1099#1081' '#1090#1088#1072#1085#1089#1087#1086#1088#1090
      FormName = 'TReport_TransportListForm'
      FormNameParam.Value = 'TReport_TransportListForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsTax: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091'  ('#1053#1072#1083#1086#1075#1086#1074#1099#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091'  ('#1053#1072#1083#1086#1075#1086#1074#1099#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099')'
      FormName = 'TReport_GoodsTaxForm'
      FormNameParam.Value = 'TReport_GoodsTaxForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPositionLevel: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1056#1072#1079#1088#1103#1076#1099' '#1076#1086#1083#1078#1085#1086#1089#1090#1077#1081' '
      Hint = #1056#1072#1079#1088#1103#1076#1099' '#1076#1086#1083#1078#1085#1086#1089#1090#1077#1081' '
      FormName = 'TPositionLevelForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actModelService: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1052#1086#1076#1077#1083#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
      Hint = #1052#1086#1076#1077#1083#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
      FormName = 'TModelServiceForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPersonalCash: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1042#1099#1087#1083#1072#1090#1072' '#1087#1086' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' ('#1044#1085#1077#1087#1088')'
      FormName = 'TCash_PersonalJournalForm'
      FormNameParam.Value = 'TCash_PersonalJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = '14462'
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1044#1085#1077#1087#1088
          DataType = ftString
        end>
      isShowModal = False
    end
    object actService: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1091#1089#1083#1091#1075
      FormName = 'TServiceJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actBankLoad: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1041#1072#1085#1082#1086#1074#1089#1082#1080#1077' '#1074#1099#1087#1080#1089#1082#1080
      FormName = 'TBankStatementJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actBankAccountDocument: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090', '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
      FormName = 'TBankAccountJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actSetUserDefaults: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1044#1077#1092#1086#1083#1090#1099' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
      Hint = #1044#1077#1092#1086#1083#1090#1099' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
      FormName = 'TSetUserDefaultsForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actLossDebt: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1079#1072#1076#1086#1083#1078#1077#1085#1085#1086#1089#1090#1080' ('#1102#1088'.'#1083#1080#1094#1072')'
      FormName = 'TLossDebtJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCity: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1086#1088#1086#1076#1072
      Hint = #1043#1086#1088#1086#1076#1072
      FormName = 'TCityForm'
      FormNameParam.Value = 'TCityForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_JuridicalDefermentIncome: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1055#1086'c'#1090#1072#1074#1097#1080#1082#1080' '#1089' '#1086#1090#1089#1088#1086#1095#1082#1086#1081
      FormName = 'TReport_JuridicalDefermentIncomeForm'
      FormNameParam.Value = 'TReport_JuridicalDefermentIncomeForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_JuridicalCollation: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080
      FormName = 'TReport_JuridicalCollationForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsMISale: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102
      FormName = 'TReport_GoodsMIForm'
      FormNameParam.Value = 'TReport_GoodsMIForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 5
        end
        item
          Name = 'inDescName'
          Value = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102
          DataType = ftString
        end>
      isShowModal = False
    end
    object actReport_GoodsMIReturn: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
      FormName = 'TReport_GoodsMIForm'
      FormNameParam.Value = 'TReport_GoodsMIForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 6
        end
        item
          Name = 'inDescName'
          Value = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
          DataType = ftString
        end>
      isShowModal = False
    end
    object actSendDebt: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1042#1079#1072#1080#1084#1086#1079#1072#1095#1077#1090' ('#1070#1088'. '#1083#1080#1094#1072')'
      FormName = 'TSendDebtJournalForm'
      FormNameParam.Value = 'TSendDebtJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPartner1CLink: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1057#1074#1103#1079#1100' '#1090#1086#1095#1077#1082' '#1076#1086#1089#1090#1072#1074#1082#1080' '#1089' 1'#1057
      FormName = 'TPartner1CLinkForm'
      FormNameParam.Value = 'TPartner1CLinkForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsByGoodsKind1CLink: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1057#1074#1103#1079#1100' '#1090#1086#1074#1072#1088#1086#1074' '#1089' 1'#1057
      FormName = 'TGoodsByGoodsKind1CLinkForm'
      FormNameParam.Value = 'TGoodsByGoodsKind1CLinkForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPartner1CLink_Excel: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1090#1086#1095#1077#1082' '#1076#1086#1089#1090#1072#1074#1082#1080' ('#1074#1089#1077')'
      FormName = 'TPartner1CLink_ExcelForm'
      FormNameParam.Value = 'TPartner1CLink_ExcelForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actLoad1CSale: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1088#1072#1089#1093#1086#1076#1085#1099#1093' '#1085#1072#1082#1083#1072#1076#1085#1099#1093
      FormName = 'TLoadSaleFrom1CForm'
      FormNameParam.Value = 'TLoadSaleFrom1CForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actLoad1CMoney: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1086#1087#1077#1088#1072#1094#1080#1081' '#1087#1086' '#1082#1072#1089#1089#1077
      FormName = 'TLoadMoneyFrom1CForm'
      FormNameParam.Value = 'TLoadMoneyFrom1CForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsMI_byMovementSale: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' ('#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084')'
      FormName = 'TReport_GoodsMI_byMovementForm'
      FormNameParam.Value = 'TReport_GoodsMI_byMovementForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 5
        end
        item
          Name = 'InDescName'
          Value = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102
          DataType = ftString
        end>
      isShowModal = False
    end
    object actReport_GoodsMI_byMovementReturn: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' ('#1087#1086' '#1085#1072#1082#1083#1072#1076#1085#1099#1084')'
      FormName = 'TReport_GoodsMI_byMovementForm'
      FormNameParam.Value = 'TReport_GoodsMI_byMovementForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 6
        end
        item
          Name = 'inDescName'
          Value = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
          DataType = ftString
        end>
      isShowModal = False
    end
    object actReport_GoodsMI_SaleReturnIn: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' / '#1042#1086#1079#1074#1088#1072#1090' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084
      FormName = 'TReport_GoodsMI_SaleReturnInForm'
      FormNameParam.Value = 'TReport_GoodsMI_SaleReturnInForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Production_Union: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1087#1088'-'#1074#1086')'
      MoveParams = <>
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1087#1088#1086#1076#1091#1082#1094#1080#1080
      FormName = 'TReport_Production_Union'
      FormNameParam.Value = 'TReport_Production_Union'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ReceiptProductionAnalyzeForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1087#1088'-'#1074#1086')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1072#1085#1072#1083#1080#1079' '#1088#1077#1094#1077#1087#1090#1091#1088' '#1080' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
      FormName = 'TReport_ReceiptProductionAnalyzeForm'
      FormNameParam.Value = 'TReport_ReceiptProductionAnalyzeForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsMI_IncomeByPartner: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076' '#1087#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      FormName = 'TReport_GoodsMI_IncomeByPartnerForm'
      FormNameParam.Value = 'TReport_GoodsMI_IncomeByPartnerForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 1
        end
        item
          Name = 'InDescName'
          Value = #1055#1088#1080#1093#1086#1076' '#1087#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
          DataType = ftString
        end>
      isShowModal = False
    end
    object actReport_GoodsMI_ReturnOutByPartner: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      FormName = 'TReport_GoodsMI_IncomeByPartnerForm'
      FormNameParam.Value = 'TReport_GoodsMI_IncomeByPartnerForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 2
        end
        item
          Name = 'InDescName'
          Value = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
          DataType = ftString
        end>
      isShowModal = False
    end
    object actTax: TdsdOpenForm
      Category = #1053#1072#1083#1086#1075#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1053#1072#1083#1086#1075#1086#1074#1099#1077' '#1085#1072#1082#1083#1072#1076#1085#1099#1077
      FormName = 'TTaxJournalForm'
      FormNameParam.Name = 'TTaxJournalForm'
      FormNameParam.Value = 'TTaxJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actTaxCorrection: TdsdOpenForm
      Category = #1053#1072#1083#1086#1075#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1099#1084' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      FormName = 'TTaxCorrectiveJournalForm'
      FormNameParam.Name = 'TTaxCorrectiveJournalForm'
      FormNameParam.Value = 'TTaxCorrectiveJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCountry: TdsdOpenForm
      Category = #1054#1057
      MoveParams = <>
      Caption = #1057#1090#1088#1072#1085#1099'-'#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100' '#1054#1057
      Hint = #1057#1090#1088#1072#1085#1099
      FormName = 'TCountryForm'
      FormNameParam.Value = 'TCountryForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_CheckTax: TdsdOpenForm
      Category = #1053#1072#1083#1086#1075#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1053#1072#1083#1086#1075#1086#1074#1099#1093' '#1085#1072#1082#1083#1072#1076#1085#1099#1093
      FormName = 'TReport_CheckTaxForm'
      FormNameParam.Value = 'TReport_CheckTaxForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actProfitLossService: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = 'actProfitLossService'
      FormName = 'TProfitLossServiceJournalForm'
      FormNameParam.Name = 'TProfitLossServiceJournalForm'
      FormNameParam.Value = 'TProfitLossServiceJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_CheckTaxCorrective: TdsdOpenForm
      Category = #1053#1072#1083#1086#1075#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1086#1082' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1099#1084' '#1085#1072#1082#1083#1072#1076#1085#1099#1084
      FormName = 'TReport_CheckTaxCorrectiveForm'
      FormNameParam.Value = 'TReport_CheckTaxCorrectiveForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPeriodClose: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1047#1072#1082#1088#1099#1090#1080#1077' '#1087#1077#1088#1080#1086#1076#1072' ('#1040#1076#1084#1080#1085')'
      FormName = 'TPeriodCloseForm'
      FormNameParam.Value = 'TPeriodCloseForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPeriodClose_User: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1047#1072#1082#1088#1099#1090#1080#1077' '#1087#1077#1088#1080#1086#1076#1072' ('#1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100')'
      FormName = 'TPeriodClose_UserForm'
      FormNameParam.Value = 'TPeriodClose_UserForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actSaveTaxDocument: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1085#1072#1083#1086#1075#1086#1074#1099#1093' '#1085#1072#1082#1083#1072#1076#1085#1099#1093
      FormName = 'TSaveTaxDocumentForm'
      FormNameParam.Value = 'TSaveTaxDocumentForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actToolsWeighingTree: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1103
      Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1103
      FormName = 'TToolsWeighingTreeForm'
      FormNameParam.Value = 'TToolsWeighingTreeForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actOrderExternalUnit: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1047#1072#1103#1074#1082#1072' '#1089#1090#1086#1088#1086#1085#1085#1103#1103' ('#1085#1072' '#1075#1083'.'#1089#1082#1083#1072#1076')'
      Hint = #1047#1072#1103#1074#1082#1080' '#1085#1072' '#1075#1083#1072#1074#1085#1099#1081' '#1089#1082#1083#1072#1076
      FormName = 'TOrderExternalUnitJournalForm'
      FormNameParam.Value = 'TOrderExternalUnitJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actWeighingPartner: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' ('#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090')'
      FormName = 'TWeighingPartnerJournalForm'
      FormNameParam.Value = 'TWeighingPartnerJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actWeighingProduction: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
      FormName = 'TWeighingProductionJournalForm'
      FormNameParam.Value = 'TWeighingProductionJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_CheckBonus: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081' '#1087#1086' '#1073#1086#1085#1091#1089#1072#1084
      FormName = 'TReport_CheckBonusForm'
      FormNameParam.Value = 'TReport_CheckBonusForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_BankAccountCash: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088'/'#1089#1095#1077#1090#1091' '#1080' '#1082#1072#1089#1089#1077
      Hint = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088'/'#1089#1095#1077#1090#1091' '#1080' '#1082#1072#1089#1089#1077
      FormName = 'TReport_BankAccount_CashForm'
      FormNameParam.Value = 'TReport_BankAccount_CashForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsKindWeighing: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074' '#1076#1083#1103' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1103
      Hint = #1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074' '#1076#1083#1103' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1103
      FormName = 'TGoodsKindWeighingTreeForm'
      FormNameParam.Value = 'TGoodsKindWeighingTreeForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsMI_byMovementDifSale: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' ('#1088#1072#1079#1085#1080#1094#1072' '#1074' '#1085#1072#1082#1083#1072#1076#1085#1099#1093')'
      FormName = 'TReport_GoodsMI_byMovementDifForm'
      FormNameParam.Value = 'TReport_GoodsMI_byMovementDifForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 5
        end
        item
          Name = 'InDescName'
          Value = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102
          DataType = ftString
        end>
      isShowModal = False
    end
    object actReport_GoodsMI_byMovementDifReturn: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' ('#1088#1072#1079#1085#1080#1094#1072' '#1074' '#1085#1072#1082#1083#1072#1076#1085#1099#1093')'
      FormName = 'TReport_GoodsMI_byMovementDifForm'
      FormNameParam.Value = 'TReport_GoodsMI_byMovementDifForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 6
        end
        item
          Name = 'InDescName'
          Value = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
          DataType = ftString
        end>
      isShowModal = False
    end
    object actReport_GoodsMI_byPriceDifSale: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' ('#1088#1072#1079#1085#1080#1094#1072' '#1074' '#1094#1077#1085#1072#1093')'
      FormName = 'TReport_GoodsMI_byPriceDifForm'
      FormNameParam.Value = 'TReport_GoodsMI_byPriceDifForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 5
        end
        item
          Name = 'InDescName'
          Value = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102
          DataType = ftString
        end>
      isShowModal = False
    end
    object actReport_GoodsMI_byPriceDifReturn: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' ('#1088#1072#1079#1085#1080#1094#1072' '#1074' '#1094#1077#1085#1072#1093')'
      FormName = 'TReport_GoodsMI_byPriceDifForm'
      FormNameParam.Value = 'TReport_GoodsMI_byPriceDifForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 6
        end
        item
          Name = 'InDescName'
          Value = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
          DataType = ftString
        end>
      isShowModal = False
    end
    object actReport_CheckContractInMovement: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1086#1074' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1093
      FormName = 'TReport_CheckContractInMovementForm'
      FormNameParam.Value = 'TReport_CheckContractInMovementForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 6
        end
        item
          Name = 'InDescName'
          Value = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084' ('#1088#1072#1079#1085#1080#1094#1072')'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actTransferDebtOut: TdsdOpenForm
      Category = #1053#1072#1083#1086#1075#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1074#1086#1076' '#1076#1086#1083#1075#1072' ('#1088#1072#1089#1093#1086#1076')'
      FormName = 'TTransferDebtOutJournalForm'
      FormNameParam.Name = 'TTransferDebtOutJournalForm'
      FormNameParam.Value = 'TTransferDebtOutJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actTransferDebtIn: TdsdOpenForm
      Category = #1053#1072#1083#1086#1075#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1074#1086#1076' '#1076#1086#1083#1075#1072' ('#1087#1088#1080#1093#1086#1076')'
      FormName = 'TTransferDebtInJournalForm'
      FormNameParam.Name = 'TTransferDebtOutJournalForm'
      FormNameParam.Value = 'TTransferDebtInJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actEDI: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = 'EDI'
      Hint = 'EDI'
      FormName = 'TEDIJournalForm'
      FormNameParam.Value = 'TEDIJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsMI_TransferDebtIn: TdsdOpenForm
      Category = #1053#1072#1083#1086#1075#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' - '#1055#1077#1088#1077#1074#1086#1076' '#1076#1086#1083#1075#1072' ('#1087#1088#1080#1093#1086#1076')'
      FormName = 'TReport_GoodsMI_TransferDebtForm'
      FormNameParam.Value = 'TReport_GoodsMI_TransferDebtForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 34
        end
        item
          Name = 'inDescName'
          Value = #1055#1077#1088#1077#1074#1086#1076' '#1076#1086#1083#1075#1072' ('#1087#1088#1080#1093#1086#1076')'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actReport_GoodsMI_TransferDebtOut: TdsdOpenForm
      Category = #1053#1072#1083#1086#1075#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' - '#1055#1077#1088#1077#1074#1086#1076' '#1076#1086#1083#1075#1072' ('#1088#1072#1089#1093#1086#1076')'
      FormName = 'TReport_GoodsMI_TransferDebtForm'
      FormNameParam.Value = 'TReport_GoodsMI_TransferDebtForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 33
        end
        item
          Name = 'inDescName'
          Value = #1055#1077#1088#1077#1074#1086#1076' '#1076#1086#1083#1075#1072' ('#1088#1072#1089#1093#1086#1076')'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actSaveDocumentTo1C: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1074' 1'#1057
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1074' 1'#1057
      FormName = 'TSaveDocumentTo1CForm'
      FormNameParam.Value = 'TSaveDocumentTo1CForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actSaveMarketingDocumentTo1CForm: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1089#1095#1077#1090' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072' '#1074' 1'#1057
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1089#1095#1077#1090' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072' '#1074' 1'#1057
      FormName = 'TSaveMarketingDocumentTo1CForm'
      FormNameParam.Value = 'TSaveMarketingDocumentTo1CForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Goods: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1086#1074#1072#1088#1091
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPriceCorrective: TdsdOpenForm
      Category = #1053#1072#1083#1086#1075#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1094#1077#1085#1099
      FormName = 'TPriceCorrectiveJournalForm'
      FormNameParam.Name = 'TPriceCorrectiveJournalForm'
      FormNameParam.Value = 'TPriceCorrectiveJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actCurrencyMovement: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1050#1091#1088#1089#1086#1074#1072#1103' '#1088#1072#1079#1085#1080#1094#1072
      Hint = #1050#1091#1088#1089#1086#1074#1072#1103' '#1088#1072#1079#1085#1080#1094#1072
      FormName = 'TCurrencyJournalForm'
      FormNameParam.Value = 'TCurrencyJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actFounderService: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1091#1095#1088#1077#1076#1080#1090#1077#1083#1103#1084
      Hint = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1091#1095#1088#1077#1076#1080#1090#1077#1083#1103#1084
      FormName = 'TFounderServiceJournalForm'
      FormNameParam.Value = 'TFounderServiceJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = 14462
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1044#1085#1077#1087#1088
          DataType = ftString
        end>
      isShowModal = False
    end
    object actReport_GoodsMI_ProductionUnionIncome: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072' '#1055#1088#1080#1093#1086#1076' '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077
      FormName = 'TReport_GoodsMI_ProductionForm'
      FormNameParam.Value = 'TReport_GoodsMI_ProductionForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 8
        end
        item
          Name = 'InDescName'
          Value = #1055#1088#1080#1093#1086#1076' '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077
          DataType = ftString
        end
        item
          Name = 'inisActive'
          Value = True
          DataType = ftBoolean
        end>
      isShowModal = False
    end
    object actReport_GoodsMI_ProductionUnionReturn: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072' '#1056#1072#1089#1093#1086#1076' '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077
      FormName = 'TReport_GoodsMI_ProductionForm'
      FormNameParam.Value = 'TReport_GoodsMI_ProductionForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 8
        end
        item
          Name = 'InDescName'
          Value = #1056#1072#1089#1093#1086#1076' '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077
          DataType = ftString
        end
        item
          Name = 'inisActive'
          Value = False
          DataType = ftBoolean
        end>
      isShowModal = False
    end
    object actReport_GoodsMI_ProductionSeparateIncome: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072' '#1055#1088#1080#1093#1086#1076' '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      FormName = 'TReport_GoodsMI_ProductionForm'
      FormNameParam.Value = 'TReport_GoodsMI_ProductionForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 9
        end
        item
          Name = 'InDescName'
          Value = #1055#1088#1080#1093#1086#1076' '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          DataType = ftString
        end
        item
          Name = 'inisActive'
          Value = True
          DataType = ftBoolean
        end>
      isShowModal = False
    end
    object actReport_GoodsMI_ProductionSeparateReturn: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072' '#1056#1072#1089#1093#1086#1076' '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      FormName = 'TReport_GoodsMI_ProductionForm'
      FormNameParam.Value = 'TReport_GoodsMI_ProductionForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <
        item
          Name = 'inDescId'
          Value = 9
        end
        item
          Name = 'InDescName'
          Value = #1056#1072#1089#1093#1086#1076' '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          DataType = ftString
        end
        item
          Name = 'inisActive'
          Value = False
          DataType = ftBoolean
        end>
      isShowModal = False
    end
    object actReport_OLAPSold: TAction
      Category = #1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' ('#1054#1051#1040#1055')'
      OnExecute = actReport_OLAPSoldExecute
    end
    object actTransferDebtOut_Order: TdsdOpenForm
      Category = #1053#1072#1083#1086#1075#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1074#1086#1076' '#1076#1086#1083#1075#1072' ('#1088#1072#1089#1093#1086#1076', '#1087#1086' '#1079#1072#1103#1074#1082#1077')'
      FormName = 'TTransferDebtOut_OrderJournalForm'
      FormNameParam.Name = 'TTransferDebtOutJournalForm'
      FormNameParam.Value = 'TTransferDebtOut_OrderJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actTransportGoods: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1086'-'#1090#1088#1072#1085#1089#1087#1086#1088#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1058#1086#1074#1072#1088#1086'-'#1090#1088#1072#1085#1089#1087#1086#1088#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      FormName = 'TTransportGoodsJournalForm'
      FormNameParam.Value = 'TTransportGoodsJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actLoadStatusFromMedoc: TdsdOpenForm
      Category = #1047#1072#1075#1088#1091#1079#1082#1080
      MoveParams = <>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1089#1090#1072#1090#1091#1089#1072' '#1080#1079' M.E.DOC'
      FormName = 'TLoadFlagFromMedocForm'
      FormNameParam.Value = 'TLoadFlagFromMedocForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actQualityDoc: TdsdOpenForm
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1046#1091#1088#1085#1072#1083' '#1074#1099#1087#1080#1089#1072#1085#1085#1099#1093' '#1050'.'#1059'. '
      Hint = #1046#1091#1088#1085#1072#1083' '#1074#1099#1087#1080#1089#1072#1085#1085#1099#1093' '#1050'.'#1059'. '
      FormName = 'TQualityDocJournalForm'
      FormNameParam.Value = 'TQualityDocJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actGlobalConst: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1089#1080#1089#1090#1077#1084#1099
      FormName = 'TGlobalConstForm'
      FormNameParam.Value = 'TGlobalConstForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object spRefresh: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      EnabledTimer = True
      Timer = spRefresh.Timer
      StoredProc = spGetInfo
      StoredProcList = <
        item
          StoredProc = spGetInfo
        end>
      Caption = 'spRefresh'
    end
    object actPersonalCashKiev: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1042#1099#1087#1083#1072#1090#1072' '#1087#1086' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' ('#1050#1080#1077#1074')'
      FormName = 'TCash_PersonalJournalForm'
      FormNameParam.Value = 'TCash_PersonalJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = '14686'
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1050#1080#1077#1074
          DataType = ftString
        end>
      isShowModal = False
    end
    object actPersonalCashKrRog: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1042#1099#1087#1083#1072#1090#1072' '#1087#1086' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' ('#1050#1088#1080#1074#1086#1081' '#1056#1086#1075')'
      FormName = 'TCash_PersonalJournalForm'
      FormNameParam.Value = 'TCash_PersonalJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = '279788'
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1050#1088#1080#1074#1086#1081' '#1056#1086#1075
          DataType = ftString
        end>
      isShowModal = False
    end
    object actPersonalCashNikolaev: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1042#1099#1087#1083#1072#1090#1072' '#1087#1086' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' ('#1053#1080#1082#1086#1083#1072#1077#1074')'
      FormName = 'TCash_PersonalJournalForm'
      FormNameParam.Value = 'TCash_PersonalJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = '279789'
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1053#1080#1082#1086#1083#1072#1077#1074
          DataType = ftString
        end>
      isShowModal = False
    end
    object actPersonalCashKharkov: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1042#1099#1087#1083#1072#1090#1072' '#1087#1086' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' ('#1061#1072#1088#1100#1082#1086#1074')'
      FormName = 'TCash_PersonalJournalForm'
      FormNameParam.Value = 'TCash_PersonalJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = '279790'
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1061#1072#1088#1100#1082#1086#1074
          DataType = ftString
        end>
      isShowModal = False
    end
    object actPersonalCashCherkassi: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1042#1099#1087#1083#1072#1090#1072' '#1087#1086' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' ('#1063#1077#1088#1082#1072#1089#1089#1099')'
      FormName = 'TCash_PersonalJournalForm'
      FormNameParam.Value = 'TCash_PersonalJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = '279791'
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1063#1077#1088#1082#1072#1089#1089#1099
          DataType = ftString
        end>
      isShowModal = False
    end
    object actPersonalCashZaporozhye: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1042#1099#1087#1083#1072#1090#1072' '#1087#1086' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' ('#1047#1072#1087#1086#1088#1086#1078#1100#1077')'
      FormName = 'TCash_PersonalJournalForm'
      FormNameParam.Value = 'TCash_PersonalJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = '301799'
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1047#1072#1087#1086#1088#1086#1078#1100#1077
          DataType = ftString
        end>
      isShowModal = False
    end
    object actPersonalCashOdessa: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1042#1099#1087#1083#1072#1090#1072' '#1087#1086' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' ('#1054#1076#1077#1089#1089#1072')'
      FormName = 'TCash_PersonalJournalForm'
      FormNameParam.Value = 'TCash_PersonalJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'CashId_top'
          Value = '280296'
        end
        item
          Name = 'CashName_top'
          Value = #1050#1072#1089#1089#1072' '#1054#1076#1077#1089#1089#1072
          DataType = ftString
        end>
      isShowModal = False
    end
    object actMedocJournal: TdsdOpenForm
      Category = #1053#1072#1083#1086#1075#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1074' '#1052#1077#1076#1082#1077
      FormName = 'TMedocJournalForm'
      FormNameParam.Value = 'TMedocJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actWeighingPartnerItem: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' <'#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' ('#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090')'
      Hint = #1055#1088#1086#1090#1086#1082#1086#1083' <'#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' ('#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090')'
      FormName = 'TWeighingPartnerItemJournalForm'
      FormNameParam.Value = 'TWeighingPartnerItemJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actWeighingProductionItem: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' <'#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')>'
      Hint = #1055#1088#1086#1090#1086#1082#1086#1083' <'#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')>'
      FormName = 'TWeighingProductionItemJournalForm'
      FormNameParam.Value = 'TWeighingProductionItemJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actOrderInternalBasis: TdsdOpenForm
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1047#1072#1103#1074#1082#1072' '#1089#1099#1088#1100#1103' ('#1062#1045#1061' '#1082#1086#1083#1073#1072#1089#1085#1099#1081')'
      Hint = #1047#1072#1103#1074#1082#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' ('#1057#1099#1088#1100#1077')'
      FormName = 'TOrderInternalBasisJournalForm'
      FormNameParam.Value = 'TOrderInternalBasisJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'inFromId'
          Value = '8447'
        end
        item
          Name = 'inToid'
          Value = '0'
        end>
      isShowModal = False
    end
    object actReport_GoodsMI_SaleReturnInUnit: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      MoveParams = <>
      Caption = #1057#1082#1083#1072#1076' '#1055#1088#1086#1076#1072#1078#1072' / '#1042#1086#1079#1074#1088#1072#1090' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084
      FormName = 'TReport_GoodsMI_SaleReturnInUnitForm'
      FormNameParam.Value = 'TReport_GoodsMI_SaleReturnInUnitForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <>
      isShowModal = False
    end
    object actOrderInternalBasisDelik: TdsdOpenForm
      Category = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      MoveParams = <>
      Caption = #1047#1072#1103#1074#1082#1072' '#1089#1099#1088#1100#1103' ('#1062#1077#1093' '#1076#1077#1083#1080#1082#1072#1090#1077#1089#1086#1074')'
      Hint = #1047#1072#1103#1074#1082#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' ('#1044#1077#1083#1080#1082#1072#1090#1077#1089#1099')'
      FormName = 'TOrderInternalBasisJournalForm'
      FormNameParam.Value = 'TOrderInternalBasisJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'inFromId'
          Value = '8448'
        end
        item
          Name = 'inToid'
          Value = '0'
        end>
      isShowModal = False
    end
    object actReport_ReceiptProductionOutAnalyzeForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1087#1088'-'#1074#1086')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1072#1085#1072#1083#1080#1079' '#1087#1083#1072#1085'/'#1092#1072#1082#1090' '#1088#1072#1089#1093#1086#1076' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      FormName = 'TReport_ReceiptProductionOutAnalyzeForm'
      FormNameParam.Value = 'TReport_ReceiptProductionOutAnalyzeForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ReceiptSaleAnalyzeForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1087#1088'-'#1074#1086')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1072#1085#1072#1083#1080#1079' '#1088#1077#1094#1077#1087#1090#1091#1088' '#1080' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
      FormName = 'TReport_ReceiptSaleAnalyzeForm'
      FormNameParam.Value = 'TReport_ReceiptSaleAnalyzeForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptResult
      GuiParams = <>
      isShowModal = False
    end
    object actPromoKind: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080'\'#1040#1082#1094#1080#1080
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1072#1082#1094#1080#1081
      Hint = #1042#1080#1076#1099' '#1072#1082#1094#1080#1081
      FormName = 'TPromoKindForm'
      FormNameParam.Value = 'TPromoKindForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actConditionPromo: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080'\'#1040#1082#1094#1080#1080
      MoveParams = <>
      Caption = #1059#1089#1083#1086#1074#1080#1103' '#1091#1095#1072#1089#1090#1080#1103' '#1074' '#1072#1082#1094#1080#1080
      Hint = #1059#1089#1083#1086#1074#1080#1103' '#1091#1095#1072#1089#1090#1080#1103' '#1074' '#1072#1082#1094#1080#1080
      FormName = 'TConditionPromoForm'
      FormNameParam.Value = 'TConditionPromoForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actPromoJournal: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1040#1082#1094#1080#1080
      Hint = #1040#1082#1094#1080#1080
      FormName = 'TPromoJournalForm'
      FormNameParam.Value = 'TPromoJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Wage: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1088#1072#1089#1095#1077#1090#1091' '#1079#1072#1088#1072#1073#1086#1090#1085#1086#1081' '#1087#1083#1072#1090#1099
      FormName = 'TReport_WageForm'
      FormNameParam.Value = 'TReport_WageForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Branch_Cash: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1083#1080#1072#1083#1099')'
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1072' ('#1092#1080#1083#1080#1072#1083#1099')'
      FormName = 'TReport_Branch_CashForm'
      FormNameParam.Value = 'TReport_Branch_CashForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actReport_SheetWorkTime: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1072#1073#1077#1083#1102' '#1091#1095#1077#1090#1072' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1072#1073#1077#1083#1102' '#1091#1095#1077#1090#1072' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      FormName = 'TReport_SheetWorkTimeForm'
      FormNameParam.Value = 'TReport_SheetWorkTimeForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object actHelp: TShellExecuteAction
      Category = 'DSDLib'
      MoveParams = <>
      Param.Value = Null
      Param.Component = FormParams
      Param.ComponentItem = 'HelpFile'
      Param.DataType = ftString
      Caption = #1055#1086#1084#1086#1097#1100
    end
    object actGet_Object_Form_HelpFile: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Object_Form_HelpFile
      StoredProcList = <
        item
          StoredProc = spGet_Object_Form_HelpFile
        end>
      Caption = 'actGet_Object_Form_HelpFile'
    end
    object mactHelp: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Object_Form_HelpFile
        end
        item
          Action = actHelp
        end>
      Caption = #1055#1086#1084#1086#1097#1100
      ShortCut = 112
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Active = False
    Top = 56
  end
  inherited StoredProc: TdsdStoredProc
    Top = 112
  end
  inherited ClientDataSet: TClientDataSet
    Left = 136
    Top = 112
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
      end>
  end
  inherited MainMenu: TMainMenu
    Left = 456
    Top = 64
    object miGoodsDocuments: TMenuItem [0]
      Caption = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      object miIncome: TMenuItem
        Action = actIncome
      end
      object N68: TMenuItem
        Action = actIncomePartionGoods
      end
      object N70: TMenuItem
        Action = actIncomePartner
      end
      object miReturnOut: TMenuItem
        Action = actReturnOut
      end
      object N69: TMenuItem
        Action = actReturnOut_Partner
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object miSale: TMenuItem
        Action = actSale
      end
      object miSale_Partner: TMenuItem
        Action = actSale_Partner
        Caption = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' ('#1073#1091#1093#1075#1072#1083#1090#1077#1088')'
      end
      object miSale_Order: TMenuItem
        Action = actSale_Order
      end
      object miSale_all: TMenuItem
        Action = actSaleAll
      end
      object miReturnIn: TMenuItem
        Action = actReturnIn
      end
      object miReturnIn_Partner: TMenuItem
        Action = actReturnIn_Partner
      end
      object miSendOnPrice: TMenuItem
        Action = actSendOnPrice
        AutoCheck = True
      end
      object miSendOnPrice_Branch: TMenuItem
        Action = actSendOnPrice_Branch
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object N6: TMenuItem
        Action = actProductionPeresort
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object miWeighingPartner: TMenuItem
        Action = actWeighingPartner
      end
      object miWeighingProduction: TMenuItem
        Action = actWeighingProduction
      end
      object N71: TMenuItem
        Action = actWeighingPartnerItem
      end
      object N72: TMenuItem
        Action = actWeighingProductionItem
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object miSend: TMenuItem
        Action = actSend
      end
      object miLoss: TMenuItem
        Action = actLoss
      end
      object miInventory: TMenuItem
        Action = actInventory
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object miOrderExternal: TMenuItem
        Action = actOrderExternal
      end
      object miOrderExternalUnit: TMenuItem
        Action = actOrderExternalUnit
      end
      object N41: TMenuItem
        Caption = '-'
      end
      object miTransportGoods: TMenuItem
        Action = actTransportGoods
      end
      object N83: TMenuItem
        Action = actPromoJournal
      end
    end
    object N42: TMenuItem [1]
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      object miProductionUnionTech: TMenuItem
        Action = actProductionUnionTech
      end
      object N43: TMenuItem
        Action = actProductionUnionTechDelic
      end
      object N44: TMenuItem
        Caption = '-'
      end
      object miProductionSeparate: TMenuItem
        Action = actProductionSeparate
      end
      object miProductionUnion: TMenuItem
        Action = actProductionUnion
      end
      object N45: TMenuItem
        Caption = '-'
      end
      object miOrderInternal: TMenuItem
        Action = actOrderInternal
      end
      object miOrderInternalPack: TMenuItem
        Action = actOrderInternalPack
      end
      object miOrderInternalBasis: TMenuItem
        Action = actOrderInternalBasis
      end
      object miOrderInternalBasisDelik: TMenuItem
        Action = actOrderInternalBasisDelik
      end
      object miOrderType: TMenuItem
        Action = actOrderType
      end
      object N46: TMenuItem
        Caption = '-'
      end
      object N39: TMenuItem
        Action = actQuality
      end
      object miGoodsQuality: TMenuItem
        Action = actGoodsQuality
      end
      object miQualityParams: TMenuItem
        Action = actQualityParams
      end
      object miQualityDoc: TMenuItem
        Action = actQualityDoc
      end
      object N47: TMenuItem
        Caption = '-'
      end
      object miReceipt: TMenuItem
        Action = actReceipt
      end
      object miReceiptCost: TMenuItem
        Action = actReceiptCost
      end
    end
    object miFinanceDocuments: TMenuItem [2]
      Caption = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      object miIncomeCashOld: TMenuItem
        Action = actCashOperationOld
      end
      object miIncomeCash: TMenuItem
        Action = actCashOperation
      end
      object miCashDneprOfficial: TMenuItem
        Action = actCashOperationDneprOfficial
      end
      object miCashKiev: TMenuItem
        Action = actCashOperationKiev
      end
      object miCashKrRog: TMenuItem
        Action = actCashOperationKrRog
      end
      object miCashNikolaev: TMenuItem
        Action = actCashOperationNikolaev
      end
      object miCashKharkov: TMenuItem
        Action = actCashOperationKharkov
      end
      object miCashCherkassi: TMenuItem
        Action = actCashOperationCherkassi
      end
      object miCashZaporozhye: TMenuItem
        Action = actCashOperationZaporozhye
      end
      object miCashOdessa: TMenuItem
        Action = actCashOperationOdessa
      end
      object miCashPav: TMenuItem
        Action = actCashOperationPav
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object miFounderService: TMenuItem
        Action = actFounderService
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object miJuridicalService: TMenuItem
        Action = actService
      end
      object miProfitLossService: TMenuItem
        Action = actProfitLossService
        Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1087#1086' '#1073#1086#1085#1091#1089#1072#1084' ('#1088#1072#1089#1093#1086#1076#1099' '#1073#1091#1076#1091#1097#1080#1093' '#1087#1077#1088#1080#1086#1076#1086#1074')'
      end
      object miBankLoad: TMenuItem
        Action = actBankLoad
      end
      object miBankAccountDocument: TMenuItem
        Action = actBankAccountDocument
      end
      object miPersonalReport: TMenuItem
        Action = actPersonalReport
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object miLossDebt: TMenuItem
        Action = actLossDebt
      end
      object miSendDebt: TMenuItem
        Action = actSendDebt
      end
      object miCurrencyMovement: TMenuItem
        Action = actCurrencyMovement
      end
    end
    object miTaxDocuments: TMenuItem [3]
      Caption = #1053#1072#1083#1086#1075#1086#1074#1099#1081' '#1091#1095#1077#1090
      object miTax: TMenuItem
        Action = actTax
      end
      object miTaxCorrective: TMenuItem
        Action = actTaxCorrection
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object miReport_CheckTax: TMenuItem
        Action = actReport_CheckTax
      end
      object miReport_CheckTaxCorrective: TMenuItem
        Action = actReport_CheckTaxCorrective
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object miSaveTaxDocument: TMenuItem
        Action = actSaveTaxDocument
      end
      object MEDOC1: TMenuItem
        Action = actLoadStatusFromMedoc
      end
      object N63: TMenuItem
        Action = actMedocJournal
      end
      object N15: TMenuItem
        Caption = '-'
      end
      object miTransferDebtIn: TMenuItem
        Action = actTransferDebtIn
      end
      object miTransferDebtOut: TMenuItem
        Action = actTransferDebtOut
      end
      object miTransferDebtOut_Order: TMenuItem
        Action = actTransferDebtOut_Order
      end
      object N16: TMenuItem
        Caption = '-'
      end
      object miPriceCorrective: TMenuItem
        Action = actPriceCorrective
      end
      object N17: TMenuItem
        Caption = '-'
      end
      object miReport_GoodsMI_TransferDebtIn: TMenuItem
        Action = actReport_GoodsMI_TransferDebtIn
      end
      object miReport_GoodsMI_TransferDebtOut: TMenuItem
        Action = actReport_GoodsMI_TransferDebtOut
      end
    end
    object miAssetDocuments: TMenuItem [4]
      Caption = #1054#1057
      object miAssetGroup: TMenuItem
        Action = actAssetGroup
      end
      object miAsset: TMenuItem
        Action = actAsset
      end
      object N18: TMenuItem
        Caption = '-'
      end
      object miCountry: TMenuItem
        Action = actCountry
      end
      object miMaker: TMenuItem
        Action = actMaker
      end
    end
    object miHistory: TMenuItem [5]
      Caption = #1048#1089#1090#1086#1088#1080#1080
      object miPriceListItem: TMenuItem
        Action = actPriceListItem
      end
    end
    object miTransportDocuments: TMenuItem [6]
      Caption = #1058#1088#1072#1085#1089#1087#1086#1088#1090
      object miTransport: TMenuItem
        Action = actTransport
      end
      object miIncomeFuel: TMenuItem
        Action = actIncomeFuel
      end
      object miPersonalSendCash: TMenuItem
        Action = actPersonalSendCash
      end
      object miPersonalAccount: TMenuItem
        Action = actPersonalAccount
      end
      object miTransportService: TMenuItem
        Action = actTransportService
      end
      object miSendTicketFuel: TMenuItem
        Action = actSendTicketFuel
      end
      object N19: TMenuItem
        Caption = '-'
      end
      object miCar: TMenuItem
        Action = actCar
      end
      object N54: TMenuItem
        Action = actRouteGroup
      end
      object miRoute: TMenuItem
        Action = actRoute
      end
      object miCarModel: TMenuItem
        Action = actCarModel
      end
      object miFreight: TMenuItem
        Action = actFreight
      end
      object miFuel: TMenuItem
        Action = actFuel
      end
      object miRateFuelKind: TMenuItem
        Action = actRateFuelKind
      end
      object miRateFuel: TMenuItem
        Action = actRateFuel
      end
      object miCardFuel: TMenuItem
        Action = actCardFuel
      end
      object miTicketFuel: TMenuItem
        Action = actTicketFuel
      end
      object N20: TMenuItem
        Caption = '-'
      end
      object miReport_Transport: TMenuItem
        Action = actReport_Transport
      end
      object miReport_Fuel: TMenuItem
        Action = actReport_Fuel
      end
      object miReport_TransportHoursWork: TMenuItem
        Action = actReport_TransportHoursWork
      end
      object N49: TMenuItem
        Action = actReport_TransportList
      end
      object N78: TMenuItem
        Action = actReport_Transport_ProfitLoss
      end
    end
    object miPersonalDocuments: TMenuItem [7]
      Caption = #1055#1077#1088#1089#1086#1085#1072#1083
      object miPersonalGroup: TMenuItem
        Action = actPersonalGroup
      end
      object miPersonal: TMenuItem
        Action = actPersonal
      end
      object miPosition: TMenuItem
        Action = actPosition
      end
      object miPositionLevel: TMenuItem
        Action = actPositionLevel
      end
      object miMember: TMenuItem
        Action = actMember
      end
      object miMemberExternal: TMenuItem
        Action = actMemberExternal
      end
      object miWorkTimeKind: TMenuItem
        Action = actWorkTimeKind
      end
      object miStaffListData: TMenuItem
        Action = actStaffListData
      end
      object miModelService: TMenuItem
        Action = actModelService
      end
      object miPersonalServiceList: TMenuItem
        Action = actPersonalServiceList
      end
      object N21: TMenuItem
        Caption = '-'
      end
      object miCalendar: TMenuItem
        Action = actCalendar
      end
      object miSheetWorkTime: TMenuItem
        Action = actSheetWorkTime
      end
      object N22: TMenuItem
        Caption = '-'
      end
      object miPersonalService: TMenuItem
        Action = actPersonalService
      end
      object N57: TMenuItem
        Caption = '-'
      end
      object miPersonalBankAccount: TMenuItem
        Action = actPersonalBankAccount
      end
      object miPersonalCash: TMenuItem
        Action = actPersonalCash
      end
      object miPersonalCashKiev: TMenuItem
        Action = actPersonalCashKiev
      end
      object miPersonalCashKrRog: TMenuItem
        Action = actPersonalCashKrRog
      end
      object miPersonalCashNikolaev: TMenuItem
        Action = actPersonalCashNikolaev
      end
      object miPersonalCashKharkov: TMenuItem
        Action = actPersonalCashKharkov
      end
      object miPersonalCashCherkassi: TMenuItem
        Action = actPersonalCashCherkassi
      end
      object miPersonalCashZaporozhye: TMenuItem
        Action = actPersonalCashZaporozhye
      end
      object miPersonalCashOdessa: TMenuItem
        Action = actPersonalCashOdessa
      end
      object N85: TMenuItem
        Caption = '-'
      end
      object mniReport_Wage: TMenuItem
        Action = actReport_Wage
      end
      object N89: TMenuItem
        Action = actReport_SheetWorkTime
      end
    end
    object miReportsProduction: TMenuItem [8]
      Caption = #1054#1090#1095#1077#1090#1099' ('#1087#1088'-'#1074#1086')'
      object miReportProductionUnion: TMenuItem
        Action = actReport_Production_Union
      end
      object miReport_ProductionOrder: TMenuItem
        Action = actReport_ProductionOrder
      end
      object miReport_ReceiptProductionAnalyze: TMenuItem
        Action = actReport_ReceiptProductionAnalyzeForm
      end
      object miReport_ReceiptSaleAnalyze: TMenuItem
        Action = actReport_ReceiptSaleAnalyzeForm
      end
      object miReport_ReceiptProductionOutAnalyze: TMenuItem
        Action = actReport_ReceiptProductionOutAnalyzeForm
      end
      object N27: TMenuItem
        Caption = '-'
      end
      object miReport_GoodsMI_Production: TMenuItem
        Action = actReport_GoodsMI_ProductionUnionIncome
      end
      object miReport_GoodsMI_ProductionUnionReturn: TMenuItem
        Action = actReport_GoodsMI_ProductionUnionReturn
      end
      object miReport_GoodsMI_ProductionSeparateIncome: TMenuItem
        Action = actReport_GoodsMI_ProductionSeparateIncome
      end
      object mitReport_GoodsMI_ProductionSeparateReturn: TMenuItem
        Action = actReport_GoodsMI_ProductionSeparateReturn
      end
      object miReport_GoodsMI_ProductionSeparate: TMenuItem
        Action = actReport_GoodsMI_ProductionSeparate
      end
      object miReport_GoodsMI_ProductionUnion: TMenuItem
        Action = actReport_GoodsMI_ProductionUnion
      end
      object miReport_GoodsMI_ProductionUnionMD: TMenuItem
        Action = actReport_GoodsMI_ProductionUnionMD
      end
      object N51: TMenuItem
        Caption = '-'
      end
      object N52: TMenuItem
        Action = actReport_GoodsMI_Defroster
      end
      object N53: TMenuItem
        Action = actReport_GoodsMI_Package
      end
      object N64: TMenuItem
        Caption = '-'
      end
      object miReport_WeighingPartner: TMenuItem
        Action = actReport_PersonalComplete
      end
    end
    object miReportsGoods: TMenuItem [9]
      Caption = #1054#1090#1095#1077#1090#1099' ('#1090#1086#1074'.)'
      object miReport_MotionGoods: TMenuItem
        Action = actReport_MotionGoods
      end
      object miReport_GoodsTax: TMenuItem
        Action = actReport_GoodsTax
      end
      object miReport_Goods: TMenuItem
        Action = actReport_Goods
      end
      object miReport_OrderExternal: TMenuItem
        Action = actReport_OrderExternal
      end
      object miReport_OrderExternal_Sale: TMenuItem
        Action = actReport_OrderExternal_Sale
      end
      object N58: TMenuItem
        Action = actReport_GoodsBalance
      end
      object N59: TMenuItem
        Action = actReport_MotionGoods_Upak
      end
      object N60: TMenuItem
        Action = actReport_MotionGoods_Ceh
      end
      object N73: TMenuItem
        Action = actReport_GoodsMI_Internal
      end
      object N74: TMenuItem
        Action = actReport_GoodsMI_Send
      end
      object N75: TMenuItem
        Action = actReport_GoodsMI_SendonPrice
      end
      object N23: TMenuItem
        Caption = '-'
      end
      object miReport_GoodsMI_IncomeByPartner: TMenuItem
        Action = actReport_GoodsMI_IncomeByPartner
      end
      object miReport_GoodsMI_Income: TMenuItem
        Action = actReport_GoodsMI_ReturnOutByPartner
      end
      object N24: TMenuItem
        Caption = '-'
      end
      object miReport_GoodsMI_SaleReturnIn: TMenuItem
        Action = actReport_GoodsMI_SaleReturnIn
      end
      object miReport_GoodsMI_SaleReturnInUnit: TMenuItem
        Action = actReport_GoodsMI_SaleReturnInUnit
      end
      object N77: TMenuItem
        Action = actReport_GoodsMI_SaleReturnInUnitNew
      end
      object miReport_GoodsMISale: TMenuItem
        Action = actReport_GoodsMISale
      end
      object miReport_GoodsMI_byMovementSale: TMenuItem
        Action = actReport_GoodsMI_byMovementSale
      end
      object miReport_GoodsMI_byMovementDifSale: TMenuItem
        Action = actReport_GoodsMI_byMovementDifSale
      end
      object miReport_GoodsMI_byPriceDifSale: TMenuItem
        Action = actReport_GoodsMI_byPriceDifSale
      end
      object N25: TMenuItem
        Caption = '-'
      end
      object miReport_GoodsMIReturn: TMenuItem
        Action = actReport_GoodsMIReturn
      end
      object miReport_GoodsMI_byMovementReturn: TMenuItem
        Action = actReport_GoodsMI_byMovementReturn
      end
      object miReport_GoodsMI_byMovementDifReturn: TMenuItem
        Action = actReport_GoodsMI_byMovementDifReturn
      end
      object N56: TMenuItem
        Action = actReport_GoodsMI_byPriceDifReturn
      end
      object N26: TMenuItem
        Caption = '-'
      end
      object miReport_HistoryCost: TMenuItem
        Action = actReport_HistoryCost
      end
      object N28: TMenuItem
        Caption = '-'
      end
      object miReport_CheckContractInMovement: TMenuItem
        Action = actReport_CheckContractInMovement
      end
      object C1: TMenuItem
        Action = actReport_Weighing
      end
      object N88: TMenuItem
        Action = actReport_Promo
      end
    end
    object miReportsFinance: TMenuItem [10]
      Caption = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      object miReport_JuridicalSold: TMenuItem
        Action = actReport_JuridicalSold
      end
      object miReport_JuridicalDefermentPayment: TMenuItem
        Action = actReport_JuridicalDefermentPayment
      end
      object miReport_JuridicalDefermentIncome: TMenuItem
        Action = actReport_JuridicalDefermentIncome
      end
      object miReport_JuridicalCollation: TMenuItem
        Action = actReport_JuridicalCollation
      end
      object N29: TMenuItem
        Caption = '-'
      end
      object miReport_CheckBonus: TMenuItem
        Action = actReport_CheckBonus
      end
      object N30: TMenuItem
        Caption = '-'
      end
      object miReport_Account: TMenuItem
        Action = actReport_Account
      end
      object miReport_Member: TMenuItem
        Action = actReport_Member
      end
      object miReport_Personal: TMenuItem
        Action = actReport_Personal
      end
      object miReport_Founders: TMenuItem
        Action = actReport_Founders
      end
      object miReport_Cash: TMenuItem
        Action = actReport_Cash
      end
      object miReport_BankAccount: TMenuItem
        Action = actReport_BankAccount
      end
      object N50: TMenuItem
        Action = actReport_BankAccountCash
      end
    end
    object miReportMain: TMenuItem [11]
      Caption = #1054#1090#1095#1077#1090#1099' ('#1059#1055')'
      object miReport_Balance: TMenuItem
        Action = actReport_Balance
      end
      object miReport_ProfitLoss: TMenuItem
        Action = actReport_ProfitLoss
      end
      object miReport_OLAPSold: TMenuItem
        Action = actReport_OLAPSold
      end
    end
    object N84: TMenuItem [12]
      Caption = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1083#1080#1072#1083#1099')'
      object N110: TMenuItem
        Action = actReport_Branch_App1
      end
      object N710: TMenuItem
        Action = actReport_Branch_App7
      end
      object N711: TMenuItem
        Action = actReport_Branch_App7_New
      end
      object N87: TMenuItem
        Caption = '-'
      end
      object N86: TMenuItem
        Action = actReport_Branch_Cash
      end
    end
    inherited miGuides: TMenuItem
      object miBusiness: TMenuItem
        Action = actBusiness
      end
      object miBranch: TMenuItem
        Action = actBranch
      end
      object miUnit_List: TMenuItem
        Action = actUnit_List
      end
      object miUnit: TMenuItem
        Action = actUnit
      end
      object miStorage_Object: TMenuItem
        Action = actStorage_Object
      end
      object N33: TMenuItem
        Caption = '-'
      end
      object miPaidKind: TMenuItem
        Action = actPaidKind
      end
      object miBank: TMenuItem
        Action = actBank
      end
      object miBankAccount: TMenuItem
        Action = actBankAccount
      end
      object miBankAccountContract: TMenuItem
        Action = actBankAccountContract
      end
      object miCorrAccount: TMenuItem
        Action = actCorrAccount
      end
      object miCash: TMenuItem
        Action = actCash
      end
      object miCurrency: TMenuItem
        Action = actCurrency
      end
      object miFounder: TMenuItem
        Action = actFounder
      end
      object N34: TMenuItem
        Caption = '-'
      end
      object miPriceList: TMenuItem
        Action = actPriceList
      end
      object N80: TMenuItem
        Caption = #1040#1082#1094#1080#1080
        object N79: TMenuItem
          Action = actAdvertising
        end
        object N81: TMenuItem
          Action = actPromoKind
        end
        object N82: TMenuItem
          Action = actConditionPromo
        end
      end
      object N55: TMenuItem
        Action = actGoodsPlatform
      end
      object miTradeMark: TMenuItem
        Action = actTradeMark
      end
      object miGoodsGroup: TMenuItem
        Action = actGoodsGroup
      end
      object miGoodsGroupStat: TMenuItem
        Action = actGoodsGroupStat
      end
      object miGoodsGroupAnalyst: TMenuItem
        Action = actGoodsGroupAnalyst
      end
      object miGoodsTag: TMenuItem
        Action = actGoodsTag
      end
      object miGoods_List: TMenuItem
        Action = actGoods_List
      end
      object miGoods: TMenuItem
        Action = actGoods
      end
      object miMeasure: TMenuItem
        Action = actMeasure
      end
      object N48: TMenuItem
        Action = actGoodsByGoodsKind
      end
      object miGoodsKind: TMenuItem
        Action = actGoodsKind
      end
      object miGoodsKindWeighing: TMenuItem
        Action = actGoodsKindWeighing
      end
      object miBox: TMenuItem
        Action = actBox
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miGoodsProperty: TMenuItem
        Action = actGoodsProperty
      end
      object miGoodsPropertyValue: TMenuItem
        Action = actGoodsPropertyValue
      end
      object N37: TMenuItem
        Caption = '-'
      end
      object miBarSubItem: TMenuItem
        Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
        object miInfoMoneyGroup: TMenuItem
          Action = actInfoMoneyGroup
        end
        object miInfoMoneyDestination: TMenuItem
          Action = actInfoMoneyDestination
        end
        object miInfoMoney: TMenuItem
          Action = actInfoMoney
        end
        object miArticleLoss: TMenuItem
          Action = actArticleLoss
        end
        object N35: TMenuItem
          Caption = '-'
        end
        object miAccountGroup: TMenuItem
          Action = actAccountGroup
        end
        object miAccountDirection: TMenuItem
          Action = actAccountDirection
        end
        object miAccount: TMenuItem
          Action = actAccount
        end
        object N36: TMenuItem
          Caption = '-'
        end
        object miProfitLossGroup: TMenuItem
          Action = actProfitLossGroup
        end
        object miProfitLossDirection: TMenuItem
          Action = actProfitLossDirection
        end
        object miProfitLoss: TMenuItem
          Action = actProfitLoss
        end
      end
    end
    object miJuridicalGuides: TMenuItem [14]
      Caption = #1050#1083#1080#1077#1085#1090#1099
      object miJuridicalGroup: TMenuItem
        Action = actJuridicalGroup
      end
      object miJuridical_List: TMenuItem
        Action = actJuridical_List
      end
      object miJuridical: TMenuItem
        Action = actJuridical
      end
      object N66: TMenuItem
        Action = actJuridical_PriceList
      end
      object miJuridicalGLN: TMenuItem
        Action = actJuridicalGLN
      end
      object N62: TMenuItem
        Action = actJuridical_PrintKindItem
      end
      object miPartner: TMenuItem
        Action = actPartner
      end
      object miPartnerAddress: TMenuItem
        Action = actPartnerAddress
      end
      object miPartnerGLN: TMenuItem
        Action = actPartnerGLN
      end
      object N65: TMenuItem
        Action = actPartner_PriceList
      end
      object N67: TMenuItem
        Action = actPartner_PriceList_view
      end
      object miRouteSorting: TMenuItem
        Action = actRouteSorting
      end
      object miArea: TMenuItem
        Action = actArea
      end
      object miAreaContract: TMenuItem
        Action = actAreaContract
      end
      object miRetail: TMenuItem
        Action = actRetail
      end
      object miRetailReport: TMenuItem
        Action = actRetailReport
      end
      object N61: TMenuItem
        Action = actRetail_PrintKindItem
      end
      object miContactPerson: TMenuItem
        Action = actContactPerson
      end
      object miContactPersonKind: TMenuItem
        Action = actContactPersonKind
      end
      object miPartnerTag: TMenuItem
        Action = actPartnerTag
      end
      object N38: TMenuItem
        Caption = '-'
      end
      object miContractConditionValue: TMenuItem
        Action = actContractConditionValue
      end
      object miContract: TMenuItem
        Action = actContract
      end
      object miContractKind: TMenuItem
        Action = actContractKind
      end
      object miContractTag: TMenuItem
        Action = actContractTag
      end
      object miContractTagGroup: TMenuItem
        Action = actContractTagGroup
      end
      object miContractArticle: TMenuItem
        Action = actContractArticle
      end
      object miContractPartner: TMenuItem
        Action = actContractPartner
      end
      object miContractGoods: TMenuItem
        Action = actContractGoods
      end
      object N32: TMenuItem
        Caption = '-'
      end
      object miAdres: TMenuItem
        Caption = #1040#1076#1088#1077#1089#1072' '#1076#1086#1089#1090#1072#1074#1082#1080
        object miactRegion: TMenuItem
          Action = actRegion
        end
        object miProvince: TMenuItem
          Action = actProvince
        end
        object miProvinceCity: TMenuItem
          Action = actProvinceCity
        end
        object miCity: TMenuItem
          Action = actCity
        end
        object miCityKind: TMenuItem
          Action = actCityKind
        end
        object miStreet: TMenuItem
          Action = actStreet
        end
        object miStreetKind: TMenuItem
          Action = actStreetKind
        end
      end
    end
    inherited miService: TMenuItem
      object miAction: TMenuItem [0]
        Action = actAction
      end
      object miProcess: TMenuItem [1]
        Action = actProcess
      end
      object miUser: TMenuItem [2]
        Action = actUser
      end
      object miRole: TMenuItem [3]
        Action = actRole
      end
      object miRoleUnion: TMenuItem [4]
        Action = actRoleUnion
      end
      object miSetUserDefaults: TMenuItem [5]
        Action = actSetUserDefaults
      end
      object miPeriodClose: TMenuItem [7]
        Action = actPeriodClose
      end
      object miPeriodClose_User: TMenuItem [8]
        Action = actPeriodClose_User
      end
      object miPartner1CLink: TMenuItem [9]
        Action = actPartner1CLink
      end
      object miGoodsByGoodsKind1CLink: TMenuItem [10]
        Action = actGoodsByGoodsKind1CLink
      end
      object miPartner1CLink_Excel: TMenuItem [11]
        Action = actPartner1CLink_Excel
      end
      object miExternalSave: TMenuItem [12]
        Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' 1'#1057
        object miSaveDocumentTo1C: TMenuItem
          Action = actSaveDocumentTo1C
        end
        object miSaveMarketingDocumentTo1CForm: TMenuItem
          Action = actSaveMarketingDocumentTo1CForm
        end
      end
      object miEDI: TMenuItem [13]
        Action = actEDI
      end
      object miLoad1CSale: TMenuItem [14]
        Action = actLoad1CSale
      end
      object miLoad1CMoney: TMenuItem [15]
        Action = actLoad1CMoney
      end
      object miToolsWeighingTree: TMenuItem [16]
        Action = actToolsWeighingTree
      end
      object N40: TMenuItem [17]
        Action = actGlobalConst
      end
      object N90: TMenuItem [18]
        Action = actForms
      end
      object N31: TMenuItem [19]
        Caption = '-'
      end
      object miImportGroup: TMenuItem [20]
        Action = actImportGroup
      end
      object miImportType: TMenuItem [21]
        Action = actImportType
      end
      object miImportSettings: TMenuItem [22]
        Action = actImportSettings
      end
      object miImportExportLink: TMenuItem [23]
        Action = actImportExportLink
      end
      object N76: TMenuItem [28]
        Action = actReport_LoginProtocol
      end
      object N91: TMenuItem
        Action = mactHelp
      end
    end
  end
  object spGetInfo: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GlobalConst'
    DataSet = CDSGetInfo
    DataSets = <
      item
        DataSet = CDSGetInfo
      end>
    Params = <
      item
        Name = 'ActualBankStatementText'
        Value = Null
        DataType = ftString
      end>
    PackSize = 1
    Left = 440
    Top = 128
  end
  object CDSGetInfo: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 488
    Top = 128
  end
  object DataSource: TDataSource
    DataSet = CDSGetInfo
    Left = 528
    Top = 128
  end
  object cxStyleRepository1: TcxStyleRepository
    PixelsPerInch = 96
    object cxStyle1: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clInactiveCaption
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      TextColor = clInactiveCaption
    end
  end
  object spGet_Object_Form_HelpFile: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Form_HelpFile'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inFormName'
        Value = 'TMainForm'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'outHelpFile'
        Value = Null
        Component = FormParams
        ComponentItem = 'HelpFile'
        DataType = ftString
      end>
    PackSize = 1
    Left = 944
    Top = 128
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'HelpFile'
        Value = Null
        DataType = ftString
      end>
    Left = 904
    Top = 128
  end
end
