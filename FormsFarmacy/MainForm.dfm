inherited MainForm: TMainForm
  Caption = #1056#1072#1073#1086#1090#1072' '#1089' '#1079#1072#1082#1072#1079#1072#1084#1080
  ClientHeight = 145
  ClientWidth = 730
  KeyPreview = True
  ExplicitWidth = 746
  ExplicitHeight = 204
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid [0]
    Left = 0
    Top = 0
    Width = 730
    Height = 121
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
      DataController.DataSource = DSGetInfo
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
      object colText: TcxGridDBColumn
        DataBinding.FieldName = 'ValueText'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Options.Editing = False
        Width = 498
      end
      object colData: TcxGridDBColumn
        DataBinding.FieldName = 'OperDate'
        Width = 146
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  inherited ActionList: TActionList
    Left = 328
    object actReport_SendSUN_SUNv2: TdsdOpenForm [0]
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053' v.1/ '#1057#1059#1053' v2 / '#1057#1059#1053' v3'
      FormName = 'TReport_SendSUN_SUNv2Form'
      FormNameParam.Value = 'TReport_SendSUN_SUNv2Form'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_JuridicalSales: TdsdOpenForm [1]
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1057#1091#1084#1084#1072#1088#1085#1099#1077' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1102#1088'.'#1083#1080#1094#1072#1084
      Hint = #1057#1091#1084#1084#1072#1088#1085#1099#1077' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1102#1088'.'#1083#1080#1094#1072#1084
      FormName = 'TReport_JuridicalSalesForm'
      FormNameParam.Value = 'TReport_JuridicalSalesForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Movement_Send_RemainsSunOut_expressV2: TdsdOpenForm [2]
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1102' '#1057#1059#1053'-'#1069#1082#1089#1087#1088#1077#1089#1089' ('#1088#1072#1089#1093#1086#1076#1099') V2'
      FormName = 'TReport_Movement_Send_RemainsSunOut_express_v2Form'
      FormNameParam.Value = 'TReport_Movement_Send_RemainsSunOut_express_v2Form'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Movement_Send_RemainsSun_pi: TdsdOpenForm [3]
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1102' '#1057#1059#1053' v2 ('#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1048#1079#1083#1080#1096#1082#1086#1074')'
      FormName = 'TReport_Movement_Send_RemainsSun_piForm'
      FormNameParam.Value = 'TReport_Movement_Send_RemainsSun_piForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Check_Count: TdsdOpenForm [4]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1050#1072#1089#1089#1086#1074#1099#1077' '#1095#1077#1082#1080' '#1087#1086' '#1091#1089#1083#1086#1074#1080#1102
      FormName = 'TReport_Check_CountForm'
      FormNameParam.Name = 'TReport_Check_CountForm'
      FormNameParam.Value = 'TReport_Check_CountForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsPartionDate: TdsdOpenForm [5]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' '#1089#1088#1086#1082#1086#1074#1099#1093' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TReport_GoodsPartionDateForm'
      FormNameParam.Value = 'TReport_GoodsPartionDateForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsRetailTab_Error: TdsdOpenForm [6]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1053#1086#1074#1086#1075#1086' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072' '#1090#1086#1074#1072#1088#1086#1074' '#1089#1077#1090#1080
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsRetailTab_ErrorForm'
      FormNameParam.Value = 'TGoodsRetailTab_ErrorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Movement_Send_RemainsSun_express: TdsdOpenForm [7]
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1102' '#1057#1059#1053'-'#1069#1082#1089#1087#1088#1077#1089#1089' ('#1087#1088#1080#1093#1086#1076#1099')'
      FormName = 'TReport_Movement_Send_RemainsSun_expressForm'
      FormNameParam.Value = 'TReport_Movement_Send_RemainsSun_expressForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Movement_Send_RemainsSun: TdsdOpenForm [8]
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1102' '#1057#1059#1053' v.1 ('#1087#1088#1080#1093#1086#1076#1099')'
      FormName = 'TReport_Movement_Send_RemainsSunForm'
      FormNameParam.Value = 'TReport_Movement_Send_RemainsSunForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actLayoutJournal: TdsdOpenForm [9]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1042#1099#1082#1083#1072#1076#1082#1080
      FormName = 'TLayoutJournalForm'
      FormNameParam.Value = 'TLayoutJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Movement_Send_RemainsSunOut_express: TdsdOpenForm [10]
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1102' '#1057#1059#1053'-'#1069#1082#1089#1087#1088#1077#1089#1089' ('#1088#1072#1089#1093#1086#1076#1099')'
      FormName = 'TReport_Movement_Send_RemainsSunOut_expressForm'
      FormNameParam.Value = 'TReport_Movement_Send_RemainsSunOut_expressForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Movement_Send_RemainsSunOut: TdsdOpenForm [11]
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1102' '#1057#1059#1053' v.1 ('#1088#1072#1089#1093#1086#1076#1099')'
      FormName = 'TReport_Movement_Send_RemainsSunOutForm'
      FormNameParam.Value = 'TReport_Movement_Send_RemainsSunOutForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Movement_ReturnOut: TdsdOpenForm [12]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1042#1086#1079#1074#1088#1072#1090#1072#1084' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
      FormName = 'TReport_Movement_ReturnOutForm'
      FormNameParam.Value = 'TReport_Movement_ReturnOutForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSunExclusion: TdsdOpenForm [13]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1048#1089#1082#1083#1102#1095#1077#1085#1080#1103' '#1076#1083#1103' '#1057#1059#1053
      FormName = 'TSunExclusionForm'
      FormNameParam.Value = 'TSunExclusionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_IncomeSale_UseNDSKind: TdsdOpenForm [14]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1088#1080#1093#1086#1076'/'#1087#1088#1086#1076#1072#1078#1080' '#1090#1086#1074#1072#1088#1072' '#1089' '#1053#1044#1057'-0%'
      Hint = #1054#1090#1095#1077#1090' '#1087#1088#1080#1093#1086#1076'/'#1087#1088#1086#1076#1072#1078#1080' '#1090#1086#1074#1072#1088#1072' '#1089' '#1053#1044#1057'-0%'
      FormName = 'TReport_IncomeSale_UseNDSKindForm'
      FormNameParam.Value = 'TReport_IncomeSale_UseNDSKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportRogersMovementCheck: TdsdOpenForm [15]
      Category = #1054#1090#1095#1077#1090#1099' (Rogers)'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      FormName = 'TReportRogersMovementCheckForm'
      FormNameParam.Value = 'TReportRogersMovementCheckForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMarginCategory_All: TdsdOpenForm [16]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082' ('#1085#1086#1074#1099#1081')'
      FormName = 'TMarginCategory_AllForm'
      FormNameParam.Value = 'TMarginCategory_AllForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsSendSUN: TdsdOpenForm [17]
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053' v.1/ '#1054#1090#1083#1086#1078#1077#1085#1085#1086#1077' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053' v.1'
      FormName = 'TReport_GoodsSendSUNForm'
      FormNameParam.Value = 'TReport_GoodsSendSUNForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPartionDateKind: TdsdOpenForm [18]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1058#1080#1087#1099' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082
      Hint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072
      FormName = 'TPartionDateKindForm'
      FormNameParam.Value = 'TPartionDateKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRepriceRogersJournal: TdsdOpenForm [19]
      Category = #1054#1090#1095#1077#1090#1099' (Rogers)'
      MoveParams = <>
      Caption = #1046#1091#1088#1085#1072#1083' '#1087#1077#1088#1077#1086#1094#1077#1085#1086#1082
      Hint = #1046#1091#1088#1085#1072#1083' '#1087#1077#1088#1077#1086#1094#1077#1085#1086#1082
      FormName = 'TRepriceRogersJournalForm'
      FormNameParam.Value = 'TRepriceRogersJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Send_RemainsSun_over: TdsdOpenForm [20]
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053' v.2 ('#1057#1074#1077#1088#1093' '#1079#1072#1087#1072#1089')'
      FormName = 'TReport_Send_RemainsSun_overForm'
      FormNameParam.Value = 'TReport_Send_RemainsSun_overForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOrderInternalPromo: TdsdOpenForm [21]
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1047#1072#1103#1074#1082#1080' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1077' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099')'
      FormName = 'TOrderInternalPromoJournalForm'
      FormNameParam.Value = 'TOrderInternalPromoJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Check_Rating: TdsdOpenForm [22]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1056#1077#1081#1090#1080#1085#1075' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1086#1074
      FormName = 'TReport_Check_RatingForm'
      FormNameParam.Value = 'TReport_Check_RatingForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_SummSP: TdsdOpenForm [23]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1044#1086#1089#1090#1091#1087#1085#1099#1077' '#1083#1077#1082'-'#1074#1072' '#1080' '#1055#1050#1052#1059'1303 '#1076#1083#1103' '#1079'/'#1087' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1072#1084
      Hint = #1054#1090#1095#1077#1090' '#1044#1086#1089#1090#1091#1087#1085#1099#1077' '#1083#1077#1082'-'#1074#1072' '#1080' '#1055#1050#1052#1059'1303 '#1076#1083#1103' '#1079'/'#1087' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1072#1084
      FormName = 'TReport_SummSPForm'
      FormNameParam.Name = 'TOverSettingsForm'
      FormNameParam.Value = 'TReport_SummSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRetailCostCredit: TdsdOpenForm [24]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1082#1088#1077#1076#1080#1090#1085#1099#1093' '#1089#1088#1077#1076#1089#1090#1074' '#1087#1086' '#1089#1077#1090#1103#1084
      Hint = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1082#1088#1077#1076#1080#1090#1085#1099#1093' '#1089#1088#1077#1076#1089#1090#1074' '#1087#1086' '#1089#1077#1090#1103#1084
      FormName = 'TRetailCostCreditForm'
      FormNameParam.Value = 'TRetailCostCreditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsReprice: TdsdOpenForm [25]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1089' '#1073#1083#1086#1082#1080#1088#1086#1074#1082#1086#1081' '#1087#1077#1088#1077#1086#1094#1077#1085#1082#1080' '#1074' '#1084#1080#1085#1091#1089
      FormName = 'TGoodsRepriceForm'
      FormNameParam.Value = 'TGoodsRepriceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsMainTab_Error: TdsdOpenForm [26]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1053#1086#1074#1086#1075#1086' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072' '#1075#1083#1072#1074#1085#1099#1093' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsMainTab_ErrorForm'
      FormNameParam.Value = 'TGoodsMainTab_ErrorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPlanIventory: TdsdOpenForm [27]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1072#1092#1080#1082' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1081
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TPlanIventoryForm'
      FormNameParam.Value = 'TPlanIventoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReturnOutPharmacy: TdsdOpenForm [28]
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091' ('#1076#1083#1103' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1086#1074')'
      FormName = 'TReturnOutPharmacyJournalForm'
      FormNameParam.Value = 'TReturnOutPharmacyJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MovementPriceList_Cross: TdsdOpenForm [29]
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1072#1081#1089#1072#1084
      FormName = 'TReport_MovementPriceListForm'
      FormNameParam.Value = 'TReport_MovementPriceListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'JuridicalId_1'
          Value = '59611'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId_2'
          Value = '59610'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId_3'
          Value = '59612'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName_1'
          Value = #1054#1087#1090#1080#1084#1072
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName_2'
          Value = #1041#1072#1044#1052
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName_3'
          Value = #1042#1077#1085#1090#1072
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId_1'
          Value = '183338'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId_2'
          Value = '183275'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId_3'
          Value = '183378'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName_1'
          Value = #1054#1087#1090#1080#1084#1072' '#1060#1072#1082#1090
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName_2'
          Value = #1041#1072#1076#1084' '#1060#1072#1082#1090
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName_3'
          Value = #1042#1077#1085#1090#1072
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReport_CheckSUN: TdsdOpenForm [30]
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1090#1086#1074#1072#1088#1086#1074' '#1057#1059#1053' v.1'
      FormName = 'TReport_CheckSUNForm'
      FormNameParam.Value = 'TReport_CheckSUNForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_PriceProtocol: TdsdOpenForm [31]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1055#1088#1086#1090#1086#1082#1086#1083' '#1080#1079#1084#1077#1085#1077#1085#1080#1081' '#1055#1088#1072#1081#1089#1072
      FormName = 'TReport_PriceProtocolForm'
      FormNameParam.Value = 'TReport_PriceProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_CheckSendSUN_InOut: TdsdOpenForm [32]
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1057#1082#1074#1086#1079#1085#1086#1077' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053' v.1'
      Hint = #1054#1090#1095#1077#1090' <'#1057#1082#1074#1086#1079#1085#1086#1077' '#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1057#1059#1053'>'
      FormName = 'TReport_CheckSendSUN_InOutForm'
      FormNameParam.Value = 'TReport_CheckSendSUN_InOutForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceListLoad_Add: TdsdOpenForm [33]
      Category = #1047#1072#1075#1088#1091#1079#1082#1080
      MoveParams = <>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1086#1074' ('#1082#1086#1083'. '#1087#1086#1079'.)'
      FormName = 'TPriceListLoad_AddForm'
      FormNameParam.Value = 'TPriceListLoad_AddForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMarginCategoryJournal2: TdsdOpenForm [34]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = 'Test '#1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1082#1080' ('#1057#1040#1059#1062')'
      FormName = 'TMarginCategoryJournal2Form'
      FormNameParam.Value = 'TMarginCategoryJournal2Form'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_IncomeSample: TdsdOpenForm [35]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1080#1093#1086#1076' '#1090#1086#1074#1072#1088#1072' ('#1062#1077#1085#1072' '#1057#1069#1052#1055#1051')>'
      FormName = 'TReport_IncomeSampleForm'
      FormNameParam.Value = 'TReport_IncomeSampleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMemberIncomeCheck: TdsdOpenForm [36]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1060#1048#1054' '#1059#1087#1086#1083#1085#1086#1084#1086#1095#1077#1085#1085#1099#1093' '#1083#1080#1094
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TMemberIncomeCheckForm'
      FormNameParam.Value = 'TMemberIncomeCheckForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPromoUnit: TdsdOpenForm [37]
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1083#1072#1085' '#1087#1086' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1091' '#1076#1083#1103' '#1090#1086#1095#1077#1082
      FormName = 'TPromoUnitJournalForm'
      FormNameParam.Value = 'TPromoUnitJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUnitForOrderInternalPromo: TdsdOpenForm [38]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' ('#1079#1072#1103#1074#1082#1080' '#1074#1085'. ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099'))'
      FormName = 'TUnitForOrderInternalPromoForm'
      FormNameParam.Value = 'TUnitForOrderInternalPromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_CheckPartionDate: TdsdOpenForm [39]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1089#1088#1086#1082#1086#1074#1099#1093' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1089#1088#1086#1082#1086#1074#1099#1093' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TReport_CheckPartionDateForm'
      FormNameParam.Value = 'TReport_CheckPartionDateForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_RemainsOverGoods_test: TdsdOpenForm [40]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1080#1079#1083#1080#1096#1082#1086#1074' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084' (test)'
      FormName = 'TReport_RemainsOverGoods_NForm'
      FormNameParam.Value = 'TReport_RemainsOverGoods_NForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProvinceCity: TdsdOpenForm [41]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1056#1072#1081#1086#1085' '#1075#1086#1088#1086#1076#1072
      Hint = #1056#1072#1081#1086#1085' '#1075#1086#1088#1086#1076#1072
      FormName = 'TProvinceCityForm'
      FormNameParam.Name = #1045
      FormNameParam.Value = 'TProvinceCityForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDiffKind: TdsdOpenForm [42]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1086#1090#1082#1072#1079#1086#1074
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TDiffKindForm'
      FormNameParam.Value = 'TDiffKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportUnLiquid_Movement: TdsdOpenForm [43]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090#1099' '#1087#1086' '#1085#1077#1083#1080#1082#1074#1080#1076#1085#1086#1084#1091' '#1090#1086#1074#1072#1088#1091' ('#1044#1086#1082#1091#1084#1077#1085#1090#1099')'
      FormName = 'TReportUnLiquidJournalForm'
      FormNameParam.Value = 'TReportUnLiquidJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPersonalList: TdsdOpenForm [44]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080' ('#1087#1088#1086#1089#1084#1086#1090#1088')'
      Hint = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080
      FormName = 'TPersonal_ObjectForm'
      FormNameParam.Value = 'TPersonal_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGlobalConst: TdsdOpenForm [45]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1089#1080#1089#1090#1077#1084#1099
      Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1089#1080#1089#1090#1077#1084#1099
      FormName = 'TGlobalConstForm'
      FormNameParam.Value = 'TGlobalConstForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Movement_ListDiff: TdsdOpenForm [46]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1083#1080#1089#1090#1072#1084' '#1086#1090#1082#1072#1079#1072
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1083#1080#1089#1090#1072#1084' '#1086#1090#1082#1072#1079#1072
      FormName = 'TReport_Movement_ListDiffForm'
      FormNameParam.Value = 'TReport_Movement_ListDiffForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actListDiff: TdsdOpenForm [47]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1051#1080#1089#1090#1099' '#1086#1090#1082#1072#1079#1086#1074
      FormName = 'TListDiffJournalForm'
      FormNameParam.Value = 'TListDiffJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPromoCode: TdsdOpenForm [48]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1056#1054#1052#1054' '#1050#1054#1044' ('#1053#1072#1079#1074#1072#1085#1080#1077' '#1072#1082#1094#1080#1080')'
      Hint = #1055#1056#1054#1052#1054' '#1050#1054#1044' ('#1053#1072#1079#1074#1072#1085#1080#1077' '#1072#1082#1094#1080#1080')'
      FormName = 'TPromoCodeForm'
      FormNameParam.Value = 'TPromoCodeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRepriceChangeJournal: TdsdOpenForm [49]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1046#1091#1088#1085#1072#1083' '#1087#1077#1088#1077#1086#1094#1077#1085#1086#1082' '#1094#1077#1085#1099' '#1057#1054' '#1057#1050#1048#1044#1050#1054#1049
      Hint = #1046#1091#1088#1085#1072#1083' '#1087#1077#1088#1077#1086#1094#1077#1085#1086#1082' '#1094#1077#1085#1099' '#1057#1054' '#1057#1050#1048#1044#1050#1054#1049
      FormName = 'TRepriceChangeJournalForm'
      FormNameParam.Value = 'TRepriceChangeJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Check_PriceChange: TdsdOpenForm [50]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1094#1077#1085#1077' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
      Hint = #1055#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1094#1077#1085#1077' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
      FormName = 'TReport_Check_PriceChangeForm'
      FormNameParam.Value = 'TReport_Check_PriceChangeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSendPartionDate: TdsdOpenForm [51]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1088#1086#1082'/ '#1085#1077' '#1089#1088#1086#1082
      FormName = 'TSendPartionDateJournalForm'
      FormNameParam.Value = 'TSendPartionDateJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsCategory: TdsdOpenForm [52]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1085#1072#1103' '#1084#1072#1090#1088#1080#1094#1072' ('#1050#1072#1090#1077#1075#1086#1088#1080#1080')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsCategoryForm'
      FormNameParam.Value = 'TGoodsCategoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_JuridicalRemains: TdsdOpenForm [53]
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1057#1091#1084#1084#1072#1088#1085#1099#1077' '#1086#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1102#1088'.'#1083#1080#1094#1072#1084
      Hint = #1057#1091#1084#1084#1072#1088#1085#1099#1077' '#1086#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1102#1088'.'#1083#1080#1094#1072#1084
      FormName = 'TReport_JuridicalRemainsForm'
      FormNameParam.Value = 'TReport_JuridicalRemainsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Check_UKTZED: TdsdOpenForm [54]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1076#1083#1103' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1080
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1076#1083#1103' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1080#1080
      FormName = 'TReport_Check_UKTZEDForm'
      FormNameParam.Value = 'TReport_Check_UKTZEDForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_OverOrder: TdsdOpenForm [55]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1040#1085#1072#1083#1080#1079' '#1079#1072#1082#1072#1079'/'#1087#1088#1080#1093#1086#1076'/'#1086#1090#1082#1072#1079
      FormName = 'TReport_OverOrderForm'
      FormNameParam.Value = 'TReport_OverOrderForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsAllRetail_Tab: TdsdOpenForm [56]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099'  '#1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' ('#1053#1086#1074#1099#1081')'
      Hint = #1058#1086#1074#1072#1088#1099'  '#1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
      FormName = 'TGoodsAllRetail_TabForm'
      FormNameParam.Value = 'TGoodsAllRetail_TabForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSPKind: TdsdOpenForm [57]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1089#1086#1094'.'#1087#1088#1086#1077#1082#1090#1086#1074
      Hint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072
      FormName = 'TSPKindForm'
      FormNameParam.Value = 'TSPKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsAll_Tab: TdsdOpenForm [58]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1054#1073#1097#1080#1081' ('#1053#1086#1074#1099#1081')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsAll_TabForm'
      FormNameParam.Value = 'TGoodsAll_TabForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUnit_MCS: TdsdOpenForm [59]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' ('#1087#1072#1088#1072#1084'. '#1076#1083#1103' '#1088#1072#1089#1095#1077#1090#1072' '#1053#1058#1047')'
      Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' ('#1087#1072#1088#1072#1084'. '#1076#1083#1103' '#1088#1072#1089#1095#1077#1090#1072' '#1053#1058#1047')'
      FormName = 'TUnit_MCSForm'
      FormNameParam.Value = 'TUnit_MCSForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReturnInJournal: TdsdOpenForm [60]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
      FormName = 'TReturnInJournalForm'
      FormNameParam.Value = 'TReturnInJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMedicSP: TdsdOpenForm [61]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1060#1048#1054' '#1074#1088#1072#1095#1072' ('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TMedicSPForm'
      FormNameParam.Value = 'TMedicSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMemberSP: TdsdOpenForm [62]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1060#1048#1054' '#1087#1072#1094#1080#1077#1085#1090#1072' ('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TMemberSPForm'
      FormNameParam.Value = 'TMemberSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Check_GoodsPriceChange: TdsdOpenForm [63]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1080' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1094#1077#1085#1077' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081' '
      Hint = 'C'#1091#1084#1084#1072#1088#1085#1099#1077' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1089#1077#1090#1080' '
      FormName = 'TReport_Check_GoodsPriceChangeForm'
      FormNameParam.Value = 'TReport_Check_GoodsPriceChangeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMarginCategory_Total: TdsdOpenForm [64]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082' ('#1086#1073#1097#1080#1081')'
      FormName = 'TMarginCategory_TotalForm'
      FormNameParam.Value = 'TMarginCategory_TotalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsSPJournal: TdsdOpenForm [65]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072' ('#1076#1086#1082#1091#1084#1077#1085#1090')'
      FormName = 'TGoodsSPJournalForm'
      FormNameParam.Value = 'TGoodsSPJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_SaleSP: TdsdOpenForm [66]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' "'#1088#1077#1077#1089#1090#1088' '#1087#1086' '#1087#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1102' 1303"'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1090#1086#1074#1072#1088#1086#1074' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
      FormName = 'TReport_SaleSPForm'
      FormNameParam.Value = 'TReport_SaleSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsRemainsCurrent: TdsdOpenForm [67]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1058#1077#1082#1091#1097#1080#1077' '#1086#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1089#1077#1090#1080
      FormName = 'TReport_GoodsRemainsCurrentForm'
      FormNameParam.Value = 'TReport_GoodsRemainsCurrentForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBarCode: TdsdOpenForm [68]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076#1099' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1064#1090#1088#1080#1093'-'#1082#1086#1076#1099' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TBarCodeForm'
      FormNameParam.Value = 'TBarCodeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUnit_JuridicalArea: TdsdOpenForm [69]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' ('#1087#1086#1089#1090#1072#1074#1097#1080#1082')'
      Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      FormName = 'TUnit_JuridicalAreaForm'
      FormNameParam.Value = 'TUnit_JuridicalAreaForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actFiscal: TdsdOpenForm [70]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1086#1074#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1099
      Hint = #1050#1072#1089#1089#1086#1074#1099#1081' '#1072#1087#1087#1072#1088#1072#1090
      FormName = 'TFiscalForm'
      FormNameParam.Value = 'TFiscalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMarginCategory_Movement: TdsdOpenForm [71]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1082#1080' ('#1057#1040#1059#1062')'
      FormName = 'TMarginCategoryJournalForm'
      FormNameParam.Value = 'TMarginCategoryJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Check_Assortment: TdsdOpenForm [72]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090' '#1089#1077#1090#1080
      Hint = #1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090' '#1089#1077#1090#1080
      FormName = 'TReport_Check_AssortmentForm'
      FormNameParam.Value = 'TReport_Check_AssortmentForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_CheckMiddle_Detail: TdsdOpenForm [73]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1057#1088#1077#1076#1085#1080#1081' '#1095#1077#1082' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      FormName = 'TReport_CheckMiddle_DetailForm'
      FormNameParam.Value = 'TReport_CheckMiddle_DetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsRemains_AnotherRetail: TdsdOpenForm [74]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1054#1089#1090#1072#1090#1082#1080' '#1090#1086#1074#1072#1088#1072' (ID '#1090#1086#1074#1072#1088#1072' '#1076#1088#1091#1075#1086#1081' '#1089#1077#1090#1080')'
      FormName = 'TReport_GoodsRemains_AnotherRetailForm'
      FormNameParam.Value = 'TReport_GoodsRemains_AnotherRetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMarginCategory_Cross: TdsdOpenForm [75]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082' (cross)'
      FormName = 'TMarginCategory_CrossForm'
      FormNameParam.Value = 'TMarginCategory_CrossForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actConfirmedKind: TdsdOpenForm [76]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072
      Hint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072
      FormName = 'TConfirmedKindForm'
      FormNameParam.Value = 'TConfirmedKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actTaxUnit: TdsdOpenForm [77]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1053#1072#1094#1077#1085#1082#1080' '#1076#1083#1103' '#1085#1086#1095#1085#1099#1093' '#1094#1077#1085
      FormName = 'TTaxUnitForm'
      FormNameParam.Value = 'TTaxUnitForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBrandSP: TdsdOpenForm [78]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1088#1075#1086#1074#1077#1083#1100#1085#1072' '#1085#1072#1079#1074#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091' ('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TBrandSPForm'
      FormNameParam.Value = 'TBrandSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actConditionsKeep: TdsdOpenForm [79]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TConditionsKeepForm'
      FormNameParam.Value = 'TConditionsKeepForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPartnerMedical: TdsdOpenForm [80]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1077' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TPartnerMedicalForm'
      FormNameParam.Value = 'TPartnerMedicalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsRetail: TdsdOpenForm [81]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' ('#1074#1099#1073#1086#1088' '#1090#1086#1088#1075'. '#1089#1077#1090#1080')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsRetailForm'
      FormNameParam.Value = 'TGoodsRetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoods_NDS_diff: TdsdOpenForm [82]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1089#1077#1090#1080' ('#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1053#1044#1057')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoods_NDS_diffForm'
      FormNameParam.Value = 'TGoods_NDS_diffForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actIntenalSP: TdsdOpenForm [83]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1052#1110#1078#1085#1072#1088#1086#1076#1085#1072' '#1085#1077#1087#1072#1090#1077#1085#1090#1086#1074#1072#1085#1072' '#1085#1072#1079#1074#1072' ('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TIntenalSPForm'
      FormNameParam.Value = 'TIntenalSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDiscountExternalJuridical: TdsdOpenForm [84]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1055#1088#1086#1077#1082#1090#1086#1074' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099', '#1102#1088'. '#1083#1080#1094#1072')'
      Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1055#1088#1086#1077#1082#1090#1086#1074' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099', '#1102#1088'. '#1083#1080#1094#1072')'
      FormName = 'TDiscountExternalJuridicalForm'
      FormNameParam.Value = 'TDiscountExternalJuridicalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsSP: TdsdOpenForm [85]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1057#1086#1094'. '#1055#1088#1086#1077#1082#1090#1072
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsSPForm'
      FormNameParam.Value = 'TGoodsSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actInvoice: TdsdOpenForm [86]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1046#1091#1088#1085#1072#1083' '#1089#1095#1077#1090#1086#1074' '#1087#1086' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072#1084
      FormName = 'TInvoiceJournalForm'
      FormNameParam.Value = 'TInvoiceJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MinPrice_onGoods: TdsdOpenForm [87]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1043#1088#1072#1092#1080#1082' '#1076#1074#1080#1078#1077#1085#1080#1103' '#1094#1077#1085#1099' '#1087#1088#1077#1087#1072#1088#1072#1090#1072
      Hint = #1043#1088#1072#1092#1080#1082' '#1076#1074#1080#1078#1077#1085#1080#1103' '#1094#1077#1085#1099' '#1087#1088#1077#1087#1072#1088#1072#1090#1072
      FormName = 'TReport_MinPrice_onGoodsForm'
      FormNameParam.Name = 'TReport_MinPrice_onGoodsForm'
      FormNameParam.Value = 'TReport_MinPrice_onGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Badm: TdsdOpenForm [88]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084' ('#1041#1072#1044#1052')'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084' ('#1041#1072#1044#1052')'
      FormName = 'TReport_BadmForm'
      FormNameParam.Value = 'TReport_BadmForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoods_BarCode: TdsdOpenForm [89]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1089#1077#1090#1080' ('#1096'/'#1082' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1103')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoods_BarCodeForm'
      FormNameParam.Value = 'TGoods_BarCodeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actEmail: TdsdOpenForm [90]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1086#1095#1090#1086#1074#1099#1081' '#1103#1097#1080#1082
      Hint = #1055#1086#1095#1090#1086#1074#1099#1081' '#1103#1097#1080#1082
      FormName = 'TEmailForm'
      FormNameParam.Value = 'TEmailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_CheckSP: TdsdOpenForm [91]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1090#1086#1074#1072#1088#1086#1074' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1090#1086#1074#1072#1088#1086#1074' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
      FormName = 'TReport_CheckSPForm'
      FormNameParam.Name = 'TOverSettingsForm'
      FormNameParam.Value = 'TReport_CheckSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_CheckPromoFarm: TdsdOpenForm [92]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1060#1072#1088#1084'-'#1090#1091' '#1086#1090#1095#1077#1090' % ('#1089#1091#1084#1084#1099') '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1077#1078#1077#1084#1077#1089#1103#1095'.'#1084#1072#1088#1082#1077#1090' '#1087#1083#1072#1085#1072
      Hint = #1060#1072#1088#1084'-'#1090#1091' '#1086#1090#1095#1077#1090' % ('#1089#1091#1084#1084#1099') '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1077#1078#1077#1084#1077#1089#1103#1095'.'#1084#1072#1088#1082#1077#1090' '#1087#1083#1072#1085#1072
      FormName = 'TReport_CheckPromoForm'
      FormNameParam.Value = 'TReport_CheckPromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inIsFarm'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReport_CheckPromo: TdsdOpenForm [93]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1093' '#1087#1088#1086#1076#1072#1078
      Hint = #1054#1090#1095#1077#1090' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1093' '#1087#1088#1086#1076#1072#1078
      FormName = 'TReport_CheckPromoForm'
      FormNameParam.Value = 'TReport_CheckPromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inIsFarm'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUnit_Object: TdsdOpenForm [94]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' ('#1089#1087#1080#1089#1086#1082')'
      Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      FormName = 'TUnit_ObjectForm'
      FormNameParam.Value = 'TUnit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MovementCheck_Cross: TdsdOpenForm [95]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1083#1072#1085#1091' '#1084#1072#1088#1082#1077#1090#1087#1088#1086#1076#1072#1078
      Hint = #1054#1090#1095#1077#1090' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1093' '#1087#1088#1086#1076#1072#1078
      FormName = 'TReport_MovementCheck_CrossForm'
      FormNameParam.Value = 'TReport_MovementCheck_CrossForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'isFarm'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReport_RemainsOverGoods_To: TdsdOpenForm [96]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1080#1079#1083#1080#1096#1082#1086#1074' '#1085#1072' '#1072#1087#1090#1077#1082#1091
      FormName = 'TReport_RemainsOverGoods_ToForm'
      FormNameParam.Value = 'TReport_RemainsOverGoods_ToForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MovementCheckFarm_Cross: TdsdOpenForm [97]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1060#1072#1088#1084'-'#1090#1091'  '#1086#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1077#1087#1072#1088#1072#1090#1072#1084' '#1077#1078#1077#1084#1077#1089#1103#1095'. '#1084#1072#1088#1082#1077#1090'. '#1087#1083#1072#1085#1072
      Hint = #1060#1072#1088#1084'-'#1090#1091'  '#1086#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1077#1087#1072#1088#1072#1090#1072#1084' '#1077#1078#1077#1084#1077#1089#1103#1095'. '#1084#1072#1088#1082#1077#1090'. '#1087#1083#1072#1085#1072
      FormName = 'TReport_MovementCheck_CrossForm'
      FormNameParam.Value = 'TReport_MovementCheck_CrossForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'isFarm'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReport_GoodsRemainsLight: TdsdOpenForm [98]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1057#1091#1084#1084#1072#1088#1085#1099#1077' '#1086#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1089#1077#1090#1080
      FormName = 'TReport_GoodsRemainsLightForm'
      FormNameParam.Value = 'TReport_GoodsRemainsLightForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportMovementCheckLight: TdsdOpenForm [99]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = 'C'#1091#1084#1084#1072#1088#1085#1099#1077' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1089#1077#1090#1080' '
      Hint = 'C'#1091#1084#1084#1072#1088#1085#1099#1077' '#1087#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1089#1077#1090#1080' '
      FormName = 'TReportMovementCheckLightForm'
      FormNameParam.Value = 'TReportMovementCheckLightForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportMovementCheckMiddleForm: TdsdOpenForm [100]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1057#1088#1077#1076#1085#1080#1081' '#1095#1077#1082
      FormName = 'TReportMovementCheckMiddleForm'
      FormNameParam.Value = 'TReportMovementCheckMiddleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMCS_Lite: TdsdOpenForm [101]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' '#1090#1077#1082#1091#1097#1080#1081' ('#1053#1058#1047')'
      FormName = 'TMCS_LiteForm'
      FormNameParam.Value = 'TMCS_LiteForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_PriceIntervention2: TdsdOpenForm [102]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1062#1077#1085#1086#1074#1072#1103' '#1080#1085#1090#1077#1088#1074#1077#1085#1094#1080#1103' 2'
      Hint = #1054#1090#1095#1077#1090' '#1062#1077#1085#1086#1074#1072#1103' '#1080#1085#1090#1077#1088#1074#1077#1085#1094#1080#1103' 2'
      FormName = 'TReport_PriceIntervention2Form'
      FormNameParam.Value = 'TReport_PriceIntervention2Form'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPromoCodeMovement: TdsdOpenForm [103]
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1046#1091#1088#1085#1072#1083' <'#1055#1088#1086#1084#1086'-'#1082#1086#1076#1099'>'
      FormName = 'TPromoCodeJournalForm'
      FormNameParam.Value = 'TPromoCodeJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPromo: TdsdOpenForm [104]
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1052#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090
      FormName = 'TPromoJournalForm'
      FormNameParam.Value = 'TPromoJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOrderShedule: TdsdOpenForm [105]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1072#1092#1080#1082' '#1079#1072#1082#1072#1079#1072'/'#1076#1086#1089#1090#1072#1074#1082#1080
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TOrderSheduleForm'
      FormNameParam.Value = 'TOrderSheduleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actArea: TdsdOpenForm [106]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1056#1077#1075#1080#1086#1085#1099
      Hint = #1056#1077#1075#1080#1086#1085#1099
      FormName = 'TAreaForm'
      FormNameParam.Value = 'TAreaForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actKindOutSP: TdsdOpenForm [107]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1060#1086#1088#1084#1072' '#1074#1080#1087#1091#1089#1082#1091' ('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TKindOutSPForm'
      FormNameParam.Value = 'TKindOutSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDiscountCard: TdsdOpenForm [108]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1044#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099
      Hint = #1044#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099
      FormName = 'TDiscountCardForm'
      FormNameParam.Value = 'TDiscountCardForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MovementIncome_Promo: TdsdOpenForm [109]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1080#1093#1086#1076#1072#1084' ('#1084#1072#1088#1082#1077#1090'. '#1082#1086#1085#1090#1088#1072#1082#1090')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1080#1093#1086#1076#1072#1084' ('#1084#1072#1088#1082#1077#1090'. '#1082#1086#1085#1090#1088#1072#1082#1090')'
      FormName = 'TReport_MovementIncome_PromoForm'
      FormNameParam.Value = 'TReport_MovementIncome_PromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actJuridicalArea: TdsdOpenForm [110]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1056#1077#1075#1080#1086#1085#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
      Hint = #1056#1077#1075#1080#1086#1085#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
      FormName = 'TJuridicalAreaForm'
      FormNameParam.Value = 'TJuridicalAreaForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MovementCheck_Promo: TdsdOpenForm [111]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' ('#1084#1072#1088#1082#1077#1090'. '#1082#1086#1085#1090#1088#1072#1082#1090')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' ('#1084#1072#1088#1082#1077#1090'. '#1082#1086#1085#1090#1088#1072#1082#1090')'
      FormName = 'TReport_MovementCheck_PromoForm'
      FormNameParam.Value = 'TReport_MovementCheck_PromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_PriceInterventionForm: TdsdOpenForm [112]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1062#1077#1085#1086#1074#1072#1103' '#1080#1085#1090#1077#1088#1074#1077#1085#1094#1080#1103
      Hint = #1054#1090#1095#1077#1090' '#1062#1077#1085#1086#1074#1072#1103' '#1080#1085#1090#1077#1088#1074#1077#1085#1094#1080#1103
      FormName = 'TReport_PriceInterventionForm'
      FormNameParam.Value = 'TReport_PriceInterventionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actEmailKind: TdsdOpenForm [113]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1058#1080#1087#1099' '#1091#1089#1090#1072#1085#1086#1074#1086#1082' '#1076#1083#1103' '#1087#1086#1095#1090#1099
      Hint = #1058#1080#1087#1099' '#1091#1089#1090#1072#1085#1086#1074#1086#1082' '#1076#1083#1103' '#1087#1086#1095#1090#1099
      FormName = 'TEmailKindForm'
      FormNameParam.Value = 'TEmailKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUnit_byReportBadm: TdsdOpenForm [114]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' ('#1041#1072#1044#1052')'
      FormName = 'TUnit_byReportBadmForm'
      FormNameParam.Value = 'TUnit_byReportBadmForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportMovementIncomeFarmForm: TdsdOpenForm [115]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1055#1088#1080#1093#1086#1076' '#1085#1072' '#1090#1086#1095#1082#1091' ('#1076#1083#1103' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1072')'
      Hint = #1054#1090#1095#1077#1090' '#1055#1088#1080#1093#1086#1076' '#1085#1072' '#1090#1086#1095#1082#1091' ('#1076#1083#1103' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1072')'
      FormName = 'TReport_MovementIncomeFarmForm'
      FormNameParam.Value = 'TReport_MovementIncomeFarmForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOverSettings: TdsdOpenForm [116]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1086' '#1080#1079#1083#1080#1096#1082#1072#1084
      Hint = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1086' '#1080#1079#1083#1080#1096#1082#1072#1084
      FormName = 'TOverSettingsForm'
      FormNameParam.Name = 'TOverSettingsForm'
      FormNameParam.Value = 'TOverSettingsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOver: TdsdOpenForm [117]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1048#1079#1083#1080#1096#1082#1080' ('#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084')'
      FormName = 'TOverJournalForm'
      FormNameParam.Name = 'TOverJournalForm'
      FormNameParam.Value = 'TOverJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMaker: TdsdOpenForm [118]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1080
      Hint = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
      FormName = 'TMakerForm'
      FormNameParam.Value = 'TMakerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Payment_Plan: TdsdOpenForm [119]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1043#1088#1072#1092#1080#1082' '#1087#1088#1086#1075#1085#1086#1079#1080#1088#1091#1077#1084#1099#1093' '#1087#1083#1072#1090#1077#1078#1077#1081' '#1085#1072' '#1084#1077#1089#1103#1094
      Hint = ' '#1043#1088#1072#1092#1080#1082' '#1087#1088#1086#1075#1085#1086#1079#1080#1088#1091#1077#1084#1099#1093' '#1087#1083#1072#1090#1077#1078#1077#1081' '#1085#1072' '#1084#1077#1089#1103#1094
      FormName = 'TReport_Payment_PlanForm'
      FormNameParam.Value = 'TReport_Payment_PlanForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRoleUnion: TdsdOpenForm [120]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1056#1086#1083#1080' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103' ('#1087#1086#1076#1088#1086#1073#1085#1086')'
      FormName = 'TRoleUnionForm'
      FormNameParam.Value = 'TRoleUnionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MovementCheckUnLiquid: TdsdOpenForm [121]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1053#1077#1083#1080#1082#1074#1080#1076#1085#1099#1084' '#1090#1086#1074#1072#1088#1072#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1053#1077#1083#1080#1082#1074#1080#1076#1085#1099#1084' '#1090#1086#1074#1072#1088#1072#1084
      FormName = 'TReport_MovementCheck_UnLiquidForm'
      FormNameParam.Value = 'TReport_MovementCheck_UnLiquidForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MovementCheckErrorForm: TdsdOpenForm [122]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1095#1077#1082#1072#1084' - '#1087#1088#1086#1074#1077#1088#1082#1072' '#1087#1088#1086#1074#1086#1076#1086#1082
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1095#1077#1082#1072#1084' - '#1087#1088#1086#1074#1077#1088#1082#1072' '#1087#1088#1086#1074#1086#1076#1086#1082
      FormName = 'TReport_MovementCheckErrorForm'
      FormNameParam.Value = 'TReport_MovementCheckErrorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUnitForFarmacyCash: TdsdOpenForm [123]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1089#1074#1103#1079#1080' '#1089' FarmacyCash'
      FormName = 'TUnitForFarmacyCashForm'
      FormNameParam.Value = 'TUnitForFarmacyCashForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ProfitForm: TdsdOpenForm [124]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1044#1086#1093#1086#1076#1085#1086#1089#1090#1080
      Hint = #1054#1090#1095#1077#1090' '#1044#1086#1093#1086#1076#1085#1086#1089#1090#1080
      FormName = 'TReport_ProfitForm'
      FormNameParam.Value = 'TReport_ProfitForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportPromoParams: TdsdOpenForm [125]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1083#1072#1085' '#1087#1086' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1091
      FormName = 'TReportPromoParamsForm'
      FormNameParam.Value = 'TReportPromoParamsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actEmailTools: TdsdOpenForm [126]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1091#1089#1090#1072#1085#1086#1074#1086#1082' '#1076#1083#1103' '#1087#1086#1095#1090#1099
      Hint = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1091#1089#1090#1072#1085#1086#1074#1086#1082' '#1076#1083#1103' '#1087#1086#1095#1090#1099
      FormName = 'TEmailToolsForm'
      FormNameParam.Value = 'TEmailToolsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsOnUnit_ForSite: TdsdOpenForm [127]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1076#1083#1103' '#1089#1072#1081#1090#1072
      FormName = 'TReport_GoodsOnUnit_ForSiteForm'
      FormNameParam.Value = 'TReport_GoodsOnUnit_ForSiteForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsAllRetail: TdsdOpenForm [128]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099'  '#1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
      Hint = #1058#1086#1074#1072#1088#1099'  '#1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
      FormName = 'TGoodsAllRetailForm'
      FormNameParam.Value = 'TGoodsAllRetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_RemainsOverGoods: TdsdOpenForm [129]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1080#1079#1083#1080#1096#1082#1086#1074' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084
      FormName = 'TReport_RemainsOverGoodsForm'
      FormNameParam.Value = 'TReport_RemainsOverGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportMovementIncomeForm: TdsdOpenForm [130]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1055#1088#1080#1093#1086#1076' '#1085#1072' '#1090#1086#1095#1082#1091
      Hint = #1054#1090#1095#1077#1090' '#1055#1088#1080#1093#1086#1076' '#1085#1072' '#1090#1086#1095#1082#1091
      FormName = 'TReport_MovementIncomeForm'
      FormNameParam.Value = 'TReport_MovementIncomeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsAllJuridical: TdsdOpenForm [131]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1055#1086#1089#1090#1072#1074#1097#1080#1082
      Hint = #1058#1086#1074#1072#1088#1099' '#1055#1086#1089#1090#1072#1074#1097#1080#1082
      FormName = 'TGoodsAllJuridicalForm'
      FormNameParam.Value = 'TGoodsAllJuridicalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportMovementCheckFarmForm: TdsdOpenForm [132]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093' ('#1076#1083#1103' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1072')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093' ('#1076#1083#1103' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1072')'
      FormName = 'TReportMovementCheckFarmForm'
      FormNameParam.Value = 'TReportMovementCheckFarmForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsAll: TdsdOpenForm [133]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1054#1073#1097#1080#1081
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsAllForm'
      FormNameParam.Value = 'TGoodsAllForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actColor: TdsdOpenForm [134]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1094#1074#1077#1090#1086#1074
      FormName = 'TColorForm'
      FormNameParam.Value = 'TColorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCalendar: TdsdOpenForm [135]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1050#1072#1083#1077#1085#1076#1072#1088#1100' '#1088#1072#1073#1086#1095#1080#1093' '#1076#1085#1077#1081
      Hint = #1050#1072#1083#1077#1085#1076#1072#1088#1100' '#1088#1072#1073#1086#1095#1080#1093' '#1076#1085#1077#1081
      FormName = 'TCalendarForm'
      FormNameParam.Value = 'TCalendarForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPosition: TdsdOpenForm [136]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1080
      Hint = #1044#1086#1083#1078#1085#1086#1089#1090#1080
      FormName = 'TPositionForm'
      FormNameParam.Value = 'TPositionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMember: TdsdOpenForm [137]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1060#1080#1079#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      Hint = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080
      FormName = 'TMemberForm'
      FormNameParam.Value = 'TMemberForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Wage: TdsdOpenForm [138]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1047#1055
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1047#1055
      FormName = 'TReport_WageForm'
      FormNameParam.Value = 'TReport_WageForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actWorkTimeKind: TdsdOpenForm [139]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1058#1080#1087#1099' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      Hint = #1058#1080#1087#1099' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      FormName = 'TWorkTimeKindForm'
      FormNameParam.Value = 'TWorkTimeKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actEmailSettings: TdsdOpenForm [140]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1087#1086#1095#1090#1099
      Hint = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1087#1086#1095#1090#1099
      FormName = 'TEmailSettingsForm'
      FormNameParam.Value = 'TEmailSettingsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPersonal: TdsdOpenForm [141]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080
      Hint = #1057#1086#1090#1088#1091#1076#1085#1080#1082#1080
      FormName = 'TPersonalForm'
      FormNameParam.Value = 'TPersonalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPersonalGroup: TdsdOpenForm [142]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1080' '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
      Hint = #1043#1088#1091#1087#1087#1080#1088#1086#1074#1082#1080' '#1057#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
      FormName = 'TPersonalGroupForm'
      FormNameParam.Value = 'TPersonalGroupForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actIncomePharmacy: TdsdOpenForm [143]
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076#1099' ('#1076#1083#1103' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1086#1074')'
      FormName = 'TIncomePharmacyJournalForm'
      FormNameParam.Value = 'TIncomePharmacyJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_LiquidForm: TdsdOpenForm [144]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1051#1080#1082#1074#1080#1076#1085#1086#1089#1090#1080' '#1090#1086#1095#1082#1080
      Hint = #1054#1090#1095#1077#1090' '#1051#1080#1082#1074#1080#1076#1085#1086#1089#1090#1080' '#1090#1086#1095#1082#1080
      FormName = 'TReport_LiquidForm'
      FormNameParam.Value = 'TReport_LiquidForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actEducation: TdsdOpenForm [145]
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1057#1087#1077#1094#1080#1072#1083#1100#1085#1086#1089#1090#1080
      Hint = #1057#1087#1077#1094#1080#1072#1083#1100#1085#1086#1089#1090#1080
      FormName = 'TEducationForm'
      FormNameParam.Value = 'TEducationForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actChoiceGoodsFromRemains: TdsdOpenForm [146]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1074#1089#1077#1081' '#1089#1077#1090#1080
      Hint = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1074#1089#1077#1081' '#1089#1077#1090#1080
      SecondaryShortCuts.Strings = (
        'Ctrl++')
      FormName = 'TChoiceGoodsFromRemainsForm'
      FormNameParam.Value = 'TChoiceGoodsFromRemainsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMarginCategoryLink: TdsdOpenForm [147]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1057#1074#1103#1079#1100' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082
      FormName = 'TMarginCategoryLinkForm'
      FormNameParam.Value = 'TMarginCategoryLinkForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMarginCategoryItem: TdsdOpenForm [148]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082
      FormName = 'TMarginCategoryItemForm'
      FormNameParam.Value = 'TMarginCategoryItemForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportGoodsOrder: TdsdOpenForm [149]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1079#1072#1103#1074#1082#1072#1093
      Hint = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1079#1072#1103#1074#1082#1072#1093
      ShortCut = 120
      FormName = 'TReportOrderGoodsForm'
      FormNameParam.Value = 'TReportOrderGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceList: TdsdOpenForm [150]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
      FormName = 'TPriceListJournalForm'
      FormNameParam.Value = 'TPriceListJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actLossDebt: TdsdOpenForm [151]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1079#1072#1076#1086#1083#1078#1077#1085#1085#1086#1089#1090#1080
      FormName = 'TLossDebtJournalForm'
      FormNameParam.Value = 'TLossDebtJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    inherited actExit: TFileExit
      Caption = #1042#1099#1093#1086#1076
      ShortCut = 0
    end
    object actOrderInternalLite: TdsdOpenForm [153]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Enabled = False
      Caption = #1047#1072#1103#1074#1082#1080' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1077' ('#1076#1083#1103' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1086#1074')'
      FormName = 'TOrderInternalLiteForm'
      FormNameParam.Value = 'TOrderInternalLiteForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMarginCategory: TdsdOpenForm [154]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082
      FormName = 'TMarginCategoryForm'
      FormNameParam.Value = 'TMarginCategoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMovementLoad: TdsdOpenForm [155]
      Category = #1047#1072#1075#1088#1091#1079#1082#1080
      MoveParams = <>
      Enabled = False
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1075#1088#1091#1079#1082#1080
      Hint = #1044#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1075#1088#1091#1079#1082#1080
      FormName = 'TMovementLoadForm'
      FormNameParam.Value = 'TMovementLoadForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRetail: TdsdOpenForm [156]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1058#1086#1088#1075#1086#1074#1099#1077' '#1089#1077#1090#1080
      FormName = 'TRetailForm'
      FormNameParam.Value = 'TRetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRepriceJournal: TdsdOpenForm [157]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1046#1091#1088#1085#1072#1083' '#1087#1077#1088#1077#1086#1094#1077#1085#1086#1082
      Hint = #1046#1091#1088#1085#1072#1083' '#1087#1077#1088#1077#1086#1094#1077#1085#1086#1082
      FormName = 'TRepriceJournalForm'
      FormNameParam.Value = 'TRepriceJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSetDefault: TdsdOpenForm [158]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1044#1077#1092#1086#1083#1090#1099' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
      Hint = #1044#1077#1092#1086#1083#1090#1099' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
      FormName = 'TSetUserDefaultsForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoods: TdsdOpenForm [159]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1089#1077#1090#1080
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOrderKind: TdsdOpenForm [160]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076' '#1079#1072#1082#1072#1079#1072
      Hint = #1042#1080#1076' '#1079#1072#1082#1072#1079#1072
      FormName = 'TOrderKindForm'
      FormNameParam.Value = 'TOrderKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUser: TdsdOpenForm [164]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
      FormName = 'TUserForm'
      FormNameParam.Value = 'TUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMeasure: TdsdOpenForm [168]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
      Hint = #1045#1076#1080#1085#1080#1094#1099' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
      FormName = 'TMeasureForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceChangeOnDate: TdsdOpenForm [169]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' '#1085#1072' '#1076#1072#1090#1091' ('#1094#1077#1085#1099' '#1057#1054' '#1057#1050#1048#1044#1050#1054#1049')'
      FormName = 'TPriceChangeOnDateForm'
      FormNameParam.Value = 'TPriceChangeOnDateForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceOnDate: TdsdOpenForm [170]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' '#1085#1072' '#1076#1072#1090#1091
      FormName = 'TPriceOnDateForm'
      FormNameParam.Value = 'TPriceOnDateForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actJuridicalGroup: TdsdOpenForm [171]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1093' '#1083#1080#1094
      Hint = #1043#1088#1091#1087#1087#1099' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1093' '#1083#1080#1094
      FormName = 'TJuridicalGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBusiness: TdsdOpenForm [172]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1041#1080#1079#1085#1077#1089#1099
      Hint = #1041#1080#1079#1085#1077#1089#1099
      FormName = 'TBusinessForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actForms: TdsdOpenForm [173]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1086#1081
      Hint = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1086#1081' '#1089#1080#1089#1090#1077#1084#1086#1081
      FormName = 'TFormsForm'
      FormNameParam.Value = 'TFormsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actContractKind: TdsdOpenForm [174]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
      Hint = #1042#1080#1076#1099' '#1076#1086#1075#1086#1074#1086#1088#1086#1074
      FormName = 'TContractKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUnitGroup: TdsdOpenForm [175]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
      Hint = #1043#1088#1091#1087#1087#1099' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
      FormName = 'TUnitGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUnit: TdsdOpenForm [176]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      Hint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = 'TUnitTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsGroup: TdsdOpenForm [177]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TGoodsGroupForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsMain: TdsdOpenForm [178]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1086#1073#1098#1077#1076#1080#1085#1077#1085#1085#1099#1081
      Hint = #1058#1086#1074#1072#1088#1099
      FormName = 'TGoodsMainForm'
      FormNameParam.Value = 'TGoodsMainForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actContactPerson: TdsdOpenForm [179]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1099#1077' '#1083#1080#1094#1072
      FormName = 'TContactPersonForm'
      FormNameParam.Value = 'TContactPersonForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actContract: TdsdOpenForm [180]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1044#1086#1075#1086#1074#1086#1088#1072
      Hint = #1044#1086#1075#1086#1074#1086#1088#1072
      FormName = 'TContractForm'
      FormNameParam.Value = 'TContractForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsKind: TdsdOpenForm [181]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1042#1080#1076#1099' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsProperty: TdsdOpenForm [182]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1086#1074
      Hint = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088#1099' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TGoodsPropertyForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPaidKind: TdsdOpenForm [183]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
      Hint = #1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
      FormName = 'TPaidKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportSoldParamsFormOpen: TdsdOpenForm [184]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1083#1072#1085' '#1087#1088#1086#1076#1072#1078
      FormName = 'TReportSoldParamsForm'
      FormNameParam.Value = 'TReportSoldParamsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBank: TdsdOpenForm [185]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1041#1072#1085#1082#1080
      Hint = #1041#1072#1085#1082#1080
      FormName = 'TBankForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBankAccount: TdsdOpenForm [186]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1089#1095#1077#1090#1072
      Hint = #1056#1072#1089#1095#1077#1090#1085#1099#1077' '#1089#1095#1077#1090#1072
      FormName = 'TBankAccountForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReasonDifferences: TdsdOpenForm [187]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1080#1095#1080#1085#1099' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1103
      FormName = 'TReasonDifferencesForm'
      FormNameParam.Value = 'TReasonDifferencesForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actJuridical: TdsdOpenForm [188]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      Hint = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072
      FormName = 'TJuridicalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actIncome: TdsdOpenForm [189]
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076#1085#1099#1077' '#1085#1072#1082#1083#1072#1076#1085#1099#1077
      FormName = 'TIncomeJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPartner: TdsdOpenForm [190]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      Hint = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099
      FormName = 'TPartnerForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCash: TdsdOpenForm [191]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1099
      Hint = #1050#1072#1089#1089#1099
      FormName = 'TCashForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCurrency: TdsdOpenForm [192]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1042#1072#1083#1102#1090#1099
      Hint = #1042#1072#1083#1102#1090#1099
      FormName = 'TCurrencyForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBalance: TdsdOpenForm [193]
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1041#1072#1083#1072#1085#1089
      FormName = 'TReport_BalanceForm'
      FormNameParam.Value = 'TReport_BalanceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceListLoad: TdsdOpenForm [194]
      Category = #1047#1072#1075#1088#1091#1079#1082#1080
      MoveParams = <>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1086#1074
      FormName = 'TPriceListLoadForm'
      FormNameParam.Value = 'TPriceListLoadForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOrderExternal: TdsdOpenForm [195]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1047#1072#1082#1072#1079' '#1087#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      FormName = 'TOrderExternalJournalForm'
      FormNameParam.Value = 'TOrderExternalJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOrderInternal: TdsdOpenForm [196]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1054#1073#1097#1080#1081' '#1079#1072#1082#1072#1079
      FormName = 'TOrderInternalJournalForm'
      FormNameParam.Value = 'TOrderInternalJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actNDSKind: TdsdOpenForm [197]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1042#1080#1076#1099' '#1053#1044#1057
      FormName = 'TNDSKindForm'
      FormNameParam.Value = 'TNDSKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRole: TdsdOpenForm [198]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1056#1086#1083#1080
      FormName = 'TRoleForm'
      FormNameParam.Value = 'TRoleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actAdditionalGoods: TdsdOpenForm [199]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1044#1086#1087#1086#1083#1085#1103#1102#1097#1080#1077' '#1090#1086#1074#1072#1088#1099
      FormName = 'TAdditionalGoodsForm'
      FormNameParam.Value = 'TAdditionalGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actTestFormOpen: TdsdOpenForm [200]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = 'actTestFormOpen'
      FormName = 'TTestForm'
      FormNameParam.Value = 'TTestForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsPartnerCode: TdsdOpenForm [201]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
      FormName = 'TGoodsPartnerCodeForm'
      FormNameParam.Value = 'TGoodsPartnerCodeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsPartnerCodeMaster: TdsdOpenForm [202]
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1085#1072#1096
      FormName = 'TGoodsPartnerCodeMasterForm'
      FormNameParam.Value = 'TGoodsPartnerCodeMasterForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceGroupSettings: TdsdOpenForm [203]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1094#1077#1085#1086#1074#1099#1093' '#1075#1088#1091#1087#1087
      FormName = 'TPriceGroupSettingsForm'
      FormNameParam.Value = 'TPriceGroupSettingsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceGroupSettingsTOP: TdsdOpenForm [204]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1094#1077#1085#1086#1074#1099#1093' '#1075#1088#1091#1087#1087' '#1058#1054#1055
      FormName = 'TPriceGroupSettingsTopForm'
      FormNameParam.Value = 'TPriceGroupSettingsTopForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actJuridicalSettings: TdsdOpenForm [205]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1076#1083#1103' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1080#1093' '#1083#1080#1094
      FormName = 'TJuridicalSettingsForm'
      FormNameParam.Value = 'TJuridicalSettingsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actJuridicalSettingsPriceList: TdsdOpenForm [206]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1047#1072#1082#1088#1099#1090#1080#1077' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1086#1074
      FormName = 'TJuridicalSettingsPriceListForm'
      FormNameParam.Value = 'TJuridicalSettingsPriceListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSaveData: TAction [207]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093
      OnExecute = actSaveDataExecute
    end
    object actSearchGoods: TdsdOpenForm [208]
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1087#1088#1072#1081#1089' - '#1083#1080#1089#1090#1072#1093
      ShortCut = 123
      SecondaryShortCuts.Strings = (
        'Ctrl++')
      FormName = 'TChoiceGoodsFromPriceListForm'
      FormNameParam.Value = 'TChoiceGoodsFromPriceListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    inherited actInfoMoneyGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actInfoMoneyDestination: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actInfoMoney: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actAccountGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actAccountDirection: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actProfitLossGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actProfitLossDirection: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actAccount: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    inherited actProfitLoss: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
    end
    object actReturnOut: TdsdOpenForm
      Category = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091
      FormName = 'TReturnOutJournalForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReturnType: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1080#1087#1099' '#1074#1086#1079#1074#1088#1072#1090#1072
      FormName = 'TReturnTypeForm'
      FormNameParam.Value = 'TReturnTypeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
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
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBankAccountDocument: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1056#1072#1089#1093#1086#1076' '#1087#1086' '#1088#1072#1089#1095#1077#1090#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
      FormName = 'TBankAccountJournalFarmacyForm'
      FormNameParam.Value = 'TBankAccountJournalFarmacyForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
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
      FormNameParam.MultiSelectSeparator = ','
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
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSendOnPrice: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Enabled = False
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077
      FormName = 'TSendOnPriceJournalForm'
      FormNameParam.Value = 'TSendOnPriceJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actMarginCategoryReport: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082
      FormName = 'TMarginCategoryForm'
      FormNameParam.Value = 'TMarginCategoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCheck: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1086#1074#1099#1077' '#1095#1077#1082#1080
      FormName = 'TCheckJournalForm'
      FormNameParam.Value = 'TCheckJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCashRegister: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1086#1074#1099#1077' '#1072#1087#1087#1072#1088#1072#1090#1099
      FormName = 'TCashRegisterForm'
      FormNameParam.Value = 'TCashRegisterForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodRemains: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      FormName = 'TReport_GoodsRemainsForm'
      FormNameParam.Value = 'TReport_GoodsRemainsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceChange: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' '#1090#1077#1082#1091#1097#1080#1081' ('#1094#1077#1085#1099' '#1057#1054' '#1057#1050#1048#1044#1050#1054#1049')'
      FormName = 'TPriceChangeForm'
      FormNameParam.Value = 'TPriceChangeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPrice: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' '#1090#1077#1082#1091#1097#1080#1081
      FormName = 'TPriceForm'
      FormNameParam.Value = 'TPriceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actAlternativeGroup: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1043#1088#1091#1087#1087#1099' '#1072#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074
      Hint = #1043#1088#1091#1087#1087#1099' '#1072#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074
      FormName = 'TAlternativeGroupForm'
      FormNameParam.Value = 'TAlternativeGroupForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPaidType: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1058#1080#1087#1099' '#1086#1087#1083#1072#1090#1099
      FormName = 'TPaidTypeForm'
      FormNameParam.Value = 'TPaidTypeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actInventoryJournal: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1091#1095#1077#1090#1099
      FormName = 'TInventoryJournalForm'
      FormNameParam.Value = 'TInventoryJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actLossJournal: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1057#1087#1080#1089#1072#1085#1080#1077
      FormName = 'TLossJournalForm'
      FormNameParam.Value = 'TLossJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSendJournal: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
      FormName = 'TSendJournalForm'
      FormNameParam.Value = 'TSendJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCreateOrderFromMCS: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1079#1072#1103#1074#1086#1082' '#1085#1072' '#1086#1089#1085#1086#1074#1077' '#1053#1058#1047
      FormName = 'TCreateOrderFromMCSForm'
      FormNameParam.Value = 'TCreateOrderFromMCSForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportMovementCheckForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      FormName = 'TReportMovementCheckForm'
      FormNameParam.Value = 'TReportMovementCheckForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsPartionMoveForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084' '#1090#1086#1074#1072#1088#1072
      FormName = 'TReport_GoodsPartionMoveForm'
      FormNameParam.Value = 'TReport_GoodsPartionMoveForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsPartionHistoryForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1044#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1087#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1072
      Hint = #1044#1074#1080#1078#1077#1085#1080#1077' '#1087#1086' '#1087#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1072
      FormName = 'TReport_GoodsPartionHistoryForm'
      FormNameParam.Value = 'TReport_GoodsPartionHistoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_SoldForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1083#1072#1085#1091' '#1087#1088#1086#1076#1072#1078
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1083#1072#1085#1091' '#1087#1088#1086#1076#1072#1078
      FormName = 'TReport_SoldForm'
      FormNameParam.Value = 'TReport_SoldForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Sold_DayForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1083#1072#1085#1091' '#1087#1088#1086#1076#1072#1078' ('#1076#1085#1077#1074#1085#1086#1081')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1083#1072#1085#1091' '#1087#1088#1086#1076#1072#1078' ('#1076#1085#1077#1074#1085#1086#1081')'
      FormName = 'TReport_Sold_DayForm'
      FormNameParam.Value = 'TReport_Sold_DayForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Sold_DayUserForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1083#1072#1085#1091' '#1087#1088#1086#1076#1072#1078' ('#1076#1085#1077#1074#1085#1086#1081', '#1076#1083#1103' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1086#1074')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1083#1072#1085#1091' '#1087#1088#1086#1076#1072#1078' ('#1076#1085#1077#1074#1085#1086#1081', '#1076#1083#1103' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1086#1074')'
      FormName = 'TReport_Sold_DayUserForm'
      FormNameParam.Value = 'TReport_Sold_DayUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSaleJournal: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072
      FormName = 'TSaleJournalForm'
      FormNameParam.Value = 'TSaleJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Movement_ByPartionGoodsForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1086#1080#1089#1082' '#1076#1077#1092#1077#1082#1090#1091#1088#1099
      Hint = #1055#1086#1080#1089#1082' '#1076#1077#1092#1077#1082#1090#1091#1088#1099
      FormName = 'TReport_Movement_ByPartionGoodsForm'
      FormNameParam.Value = 'TReport_Movement_ByPartionGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPaymentJournal: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1054#1087#1083#1072#1090#1099' '#1087#1088#1080#1093#1086#1076#1086#1074
      FormName = 'TPaymentJournalForm'
      FormNameParam.Value = 'TPaymentJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_UploadBaDMForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1041#1072#1044#1052')'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1041#1072#1044#1052')'
      FormName = 'TReport_UploadBaDMForm'
      FormNameParam.Value = 'TReport_UploadBaDMForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_UploadOptimaForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1054#1087#1090#1080#1084#1072')'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1054#1087#1090#1080#1084#1072')'
      FormName = 'TReport_UploadOptimaForm'
      FormNameParam.Value = 'TReport_UploadOptimaForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actChangeIncomePaymentJournal: TdsdOpenForm
      Category = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1076#1086#1083#1075#1072' '#1087#1086' '#1087#1088#1080#1093#1086#1076#1072#1084
      FormName = 'TChangeIncomePaymentJournalForm'
      FormNameParam.Value = 'TChangeIncomePaymentJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSheetWorkTime: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1058#1072#1073#1077#1083#1100' '#1091#1095#1077#1090#1072' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      Hint = #1058#1072#1073#1077#1083#1100' '#1091#1095#1077#1090#1072' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
      FormName = 'TSheetWorkTimeJournalForm'
      FormNameParam.Value = 'TSheetWorkTimeJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDiscountExternal: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1086#1077#1082#1090#1099' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099')'
      Hint = #1055#1088#1086#1077#1082#1090#1099' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099')'
      FormName = 'TDiscountExternalForm'
      FormNameParam.Value = 'TDiscountExternalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDiscountExternalTools: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1055#1088#1086#1077#1082#1090#1086#1074' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099', '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103')'
      Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1055#1088#1086#1077#1082#1090#1086#1074' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099', '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103')'
      FormName = 'TDiscountExternalToolsForm'
      FormNameParam.Value = 'TDiscountExternalToolsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsBarCodeLoad: TdsdOpenForm
      Category = #1047#1072#1075#1088#1091#1079#1082#1080
      MoveParams = <>
      Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076#1099' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1077#1081
      FormName = 'TGoodsBarCodeForm'
      FormNameParam.Value = 'TGoodsBarCodeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReportMovementCheckGrowthAndFalling: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1040#1085#1072#1083#1080#1079' '#1087#1088#1086#1076#1072#1078' '#1087#1088#1077#1087#1072#1088#1072#1090#1086#1074
      Hint = #1040#1085#1072#1083#1080#1079' '#1087#1088#1086#1076#1072#1078' '#1087#1088#1077#1087#1072#1088#1072#1090#1086#1074
      FormName = 'TReportMovementCheckGrowthAndFallingForm'
      FormNameParam.Value = 'TReportMovementCheckGrowthAndFallingForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actExportSalesForSuppClick: TAction
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
      OnExecute = actExportSalesForSuppClickExecute
    end
    object actReportMovementCheckFLForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093' '#1092#1080#1079'. '#1083#1080#1094#1072#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093' '#1092#1080#1079'. '#1083#1080#1094#1072#1084
      FormName = 'TReportMovementCheckFLForm'
      FormNameParam.Value = 'TReportMovementCheckFLForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ImplementationPlanEmployee: TAction
      Category = #1054#1090#1095#1077#1090#1099
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1102' '#1087#1083#1072#1085#1072' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
      OnExecute = actReport_ImplementationPlanEmployeeExecute
    end
    object actReport_ImplementationPlanEmployeeAll: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1102' '#1087#1083#1072#1085#1072' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1102' '#1087#1083#1072#1085#1072' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
      FormName = 'TReport_ImplementationPlanEmployeeAllForm'
      FormNameParam.Value = 'TReport_ImplementationPlanEmployeeAllForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Liquidity: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1083#1080#1082#1074#1080#1076#1085#1086#1089#1090#1080
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1083#1080#1082#1074#1080#1076#1085#1086#1089#1090#1080
      FormName = 'TReport_LiquidityForm'
      FormNameParam.Value = 'TReport_LiquidityForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_TestingUser: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1086#1074' '
      Hint = #1056#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1086#1074' '
      FormName = 'TReport_TestingUserForm'
      FormNameParam.Value = 'TReport_TestingUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actClientsByBank: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050#1083#1080#1077#1085#1090#1099' '#1087#1086' '#1073#1077#1079#1085#1072#1083#1091
      FormName = 'TClientsByBankForm'
      FormNameParam.Value = 'TClientsByBankForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUnnamedEnterprises: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1041#1077#1079#1085#1072#1083' '#1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1081
      FormName = 'TUnnamedEnterprisesJournalForm'
      FormNameParam.Value = 'TUnnamedEnterprisesJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_KPU: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1050#1055#1059
      FormName = 'TReport_KPUForm'
      FormNameParam.Value = 'TReport_KPUForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actLog_CashRemains: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = 'GUID '#1082#1072#1089#1089' '#1080' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
      FormName = 'TLog_CashRemainsForm'
      FormNameParam.Value = 'TLog_CashRemainsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRepriceUnitSheduler: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1083#1072#1085#1080#1088#1086#1074#1097#1080#1082' '#1087#1077#1088#1077#1086#1094#1077#1085#1086#1082
      Hint = #1055#1083#1072#1085#1080#1088#1086#1074#1097#1080#1082' '#1087#1077#1088#1077#1086#1094#1077#1085#1086#1082
      FormName = 'TRepriceUnitShedulerForm'
      FormNameParam.Value = 'TRepriceUnitShedulerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCheckNoCashRegister: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1072#1089#1089#1086#1074#1099#1077' '#1095#1077#1082#1080' '#1073#1077#1079' '#1085#1086#1084#1077#1088#1072' '#1082#1072#1089#1089#1086#1074#1086#1075#1086' '#1072#1087#1087#1072#1088#1072#1090#1072
      Hint = #1050#1072#1089#1089#1086#1074#1099#1077' '#1095#1077#1082#1080' '#1073#1077#1079' '#1085#1086#1084#1077#1088#1072' '#1082#1072#1089#1089#1086#1074#1086#1075#1086' '#1072#1087#1087#1072#1088#1072#1090#1072
      FormName = 'TCheckNoCashRegisterForm'
      FormNameParam.Value = 'TCheckNoCashRegisterForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCheckUnComplete: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1054#1090#1084#1077#1085#1099' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1082#1072#1089#1089#1086#1074#1099#1093' '#1095#1077#1082#1086#1074
      Hint = #1054#1090#1084#1077#1085#1099' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1082#1072#1089#1089#1086#1074#1099#1093' '#1095#1077#1082#1086#1074
      FormName = 'TCheckUnCompleteForm'
      FormNameParam.Value = 'TCheckUnCompleteForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actEmployeeSchedule: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1043#1088#1072#1092#1080#1082' '#1088#1072#1073#1086#1090#1099' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
      Hint = #1043#1088#1072#1092#1080#1082' '#1088#1072#1073#1086#1090#1099' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
      FormName = 'TEmployeeScheduleJournalForm'
      FormNameParam.Value = 'TEmployeeScheduleJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRecalcMCSSheduler: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1083#1072#1085#1080#1088#1086#1074#1097#1080#1082' '#1087#1077#1088#1077#1089#1095#1077#1090#1072' '#1053#1058#1047
      Hint = #1055#1083#1072#1085#1080#1088#1086#1074#1097#1080#1082' '#1087#1077#1088#1077#1089#1095#1077#1090#1072' '#1053#1058#1047
      FormName = 'TRecalcMCSShedulerForm'
      FormNameParam.Value = 'TRecalcMCSShedulerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBankPOSTerminal: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1041#1072#1085#1082#1080' '#1087#1088#1077#1076#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1077' POS '#1090#1077#1088#1084#1080#1085#1072#1083#1099
      FormName = 'TBankPOSTerminalForm'
      FormNameParam.Value = 'TBankPOSTerminalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUnitBankPOSTerminal: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1057#1074#1103#1079#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081' '#1089' POS '#1090#1077#1088#1084#1080#1085#1072#1083#1072#1084#1080
      FormName = 'TUnitBankPOSTerminalForm'
      FormNameParam.Value = 'TUnitBankPOSTerminalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actJackdawsChecks: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1058#1080#1087#1099' '#1075#1072#1083#1086#1082' '#1076#1083#1103' '#1095#1077#1082#1086#1074
      FormName = 'TJackdawsChecksForm'
      FormNameParam.Value = 'TJackdawsChecksForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPUSH: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = 'PUSH '#1089#1086#1086#1073#1097#1077#1085#1080#1103' '#1076#1083#1103' '#1082#1072#1089#1089#1080#1088#1086#1074
      Hint = 'PUSH '#1089#1086#1086#1073#1097#1077#1085#1080#1103' '#1076#1083#1103' '#1082#1072#1089#1089#1080#1088#1086#1074
      FormName = 'TPUSHJournalForm'
      FormNameParam.Value = 'TPUSHJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsInventory: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1093#1086#1078#1076#1077#1085#1080#1102' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1072' '#1074' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1093#1086#1078#1076#1077#1085#1080#1102' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1072' '#1074' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
      FormName = 'TReport_GoodsInventoryForm'
      FormNameParam.Value = 'TReport_GoodsInventoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCreditLimitDistributor: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1088#1077#1076#1080#1090#1085#1099#1077' '#1083#1080#1084#1080#1090#1099' '#1087#1086' '#1076#1080#1089#1090#1088#1080#1073#1100#1102#1090#1086#1088#1091
      Hint = #1050#1088#1077#1076#1080#1090#1085#1099#1077' '#1083#1080#1084#1080#1090#1099' '#1087#1086' '#1076#1080#1089#1090#1088#1080#1073#1100#1102#1090#1086#1088#1091
      FormName = 'TCreditLimitDistributorForm'
      FormNameParam.Value = 'TCreditLimitDistributorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSendMenegerJournal: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' ('#1084#1077#1085#1077#1076#1078#1077#1088#1099')'
      FormName = 'TSendMenegerJournalForm'
      FormNameParam.Value = 'TSendMenegerJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsNotSalePast: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1090#1086#1074#1072#1088#1099' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078
      Hint = #1058#1086#1074#1072#1088#1099' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078
      FormName = 'TReport_GoodsNotSalePastForm'
      FormNameParam.Value = 'TReport_GoodsNotSalePastForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object acttReport_GoodsPartionDate_Promo: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1057#1088#1086#1082#1086#1074#1099#1077' '#1090#1086#1074#1072#1088#1099' ('#1084#1072#1088#1082#1077#1090'. '#1082#1086#1085#1090#1088#1072#1082#1090')'
      Hint = #1057#1088#1086#1082#1086#1074#1099#1077' '#1090#1086#1074#1072#1088#1099' ('#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074'sq '#1082#1086#1085#1090#1088#1072#1082#1090')'
      FormName = 'TReport_GoodsPartionDate_PromoForm'
      FormNameParam.Value = 'TReport_GoodsPartionDate_PromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsPartionDate5: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1090#1086#1074#1072#1088#1099' 5 '#1082#1072#1090#1077#1075#1086#1088#1080#1080
      FormName = 'TReport_GoodsPartionDate5Form'
      FormNameParam.Value = 'TReport_GoodsPartionDate5Form'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDriver: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1042#1086#1076#1080#1090#1077#1083#1080' '#1057#1059#1053
      Hint = #1042#1086#1076#1080#1090#1077#1083#1080' '#1057#1059#1053
      FormName = 'TDriverForm'
      FormNameParam.Value = 'TDriverForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actUnitLincDriver: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1057#1074#1103#1079#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1089' '#1074#1086#1076#1080#1090#1077#1083#1077#1084' '#1057#1059#1053
      Hint = #1057#1074#1103#1079#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1089' '#1074#1086#1076#1080#1090#1077#1083#1077#1084' '#1057#1059#1053
      FormName = 'TUnitLincDriverForm'
      FormNameParam.Value = 'TUnitLincDriverForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_BalanceGoodsSUN: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1041#1072#1083#1072#1085#1089' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1057#1059#1053
      Hint = #1041#1072#1083#1072#1085#1089' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1057#1059#1053
      FormName = 'TReport_BalanceGoodsSUNForm'
      FormNameParam.Value = 'TReport_BalanceGoodsSUNForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actWages: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1047'/'#1055' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
      Hint = #1047'/'#1055' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
      FormName = 'TWagesJournalForm'
      FormNameParam.Value = 'TWagesJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPayrollType: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1058#1080#1087#1099' '#1088#1072#1089#1095#1077#1090#1072' '#1079#1072#1088#1072#1073#1086#1090#1085#1086#1081' '#1087#1083#1072#1090#1099
      Hint = #1058#1080#1087#1099' '#1088#1072#1089#1095#1077#1090#1072' '#1079#1072#1088#1072#1073#1086#1090#1085#1086#1081' '#1087#1083#1072#1090#1099
      FormName = 'TPayrollTypeForm'
      FormNameParam.Value = 'TPayrollTypeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_DiscountExternal: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1087#1088#1086#1077#1082#1090#1099')'
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1087#1088#1086#1077#1082#1090#1099')'
      FormName = 'TReport_MovementCheck_DiscountExternalForm'
      FormNameParam.Value = 'TReport_MovementCheck_DiscountExternalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Profitability: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1105#1090' '#1044#1086#1093#1086#1076#1085#1086#1089#1090#1080
      Hint = #1054#1090#1095#1105#1090' '#1044#1086#1093#1086#1076#1085#1086#1089#1090#1080
      FormName = 'TReport_ProfitabilityForm'
      FormNameParam.Value = 'TReport_ProfitabilityForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actLoyaltyJournal: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1083#1086#1103#1083#1100#1085#1086#1089#1090#1080
      Hint = #1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1083#1086#1103#1083#1100#1085#1086#1089#1090#1080
      FormName = 'TLoyaltyJournalForm'
      FormNameParam.Value = 'TLoyaltyJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRefresh: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      EnabledTimer = True
      Timer = actRefresh.Timer
      StoredProc = spGetInfo
      StoredProcList = <
        item
          StoredProc = spGetInfo
        end>
      Caption = 'actRefresh'
      ShortCut = 116
    end
    object actCashSettings: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1054#1073#1097#1080#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1082#1072#1089#1089
      Hint = #1054#1073#1097#1080#1077' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1082#1072#1089#1089
      FormName = 'TCashSettingsEditForm'
      FormNameParam.Value = 'TCashSettingsEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsPartionDate0: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1077' '#1090#1086#1074#1072#1088#1099
      Hint = #1054#1090#1095#1077#1090' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1077' '#1090#1086#1074#1072#1088#1099
      FormName = 'TReport_GoodsPartionDate0Form'
      FormNameParam.Value = 'TReport_GoodsPartionDate0Form'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_IlliquidReductionPlanAll: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1083#1072#1085' '#1087#1086' '#1091#1084#1077#1085#1100#1096#1077#1085#1080#1102' '#1082#1086#1083'-'#1074#1086' '#1085#1077#1083#1080#1082#1074#1080#1076#1072
      Hint = #1054#1090#1095#1077#1090' '#1087#1083#1072#1085' '#1087#1086' '#1091#1084#1077#1085#1100#1096#1077#1085#1080#1102' '#1082#1086#1083'-'#1074#1086' '#1085#1077#1083#1080#1082#1074#1080#1076#1072
      FormName = 'TReport_IlliquidReductionPlanAllForm'
      FormNameParam.Value = 'TReport_IlliquidReductionPlanAllForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPercentageOverdueSUN: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1088#1086#1094#1077#1085#1090' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1093' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' '#1087#1086' '#1057#1059#1053' v.1'
      Hint = #1054#1090#1095#1077#1090' '#1087#1088#1086#1094#1077#1085#1090' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1093' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' '#1087#1086' '#1057#1059#1053
      FormName = 'TReport_PercentageOverdueSUNForm'
      FormNameParam.Value = 'TReport_PercentageOverdueSUNForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPermanentDiscount: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1089#1090#1086#1103#1085#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1087#1086' '#1089#1077#1090#1080
      Hint = #1055#1086#1089#1090#1086#1103#1085#1085#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1087#1086' '#1089#1077#1090#1080
      FormName = 'TPermanentDiscountJournalForm'
      FormNameParam.Value = 'TPermanentDiscountJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_PromoDoctors: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1086#1084#1086' '#1074#1088#1072#1095#1080'  ('#1052#1077#1076#1080#1082#1072#1083' '#1055#1083#1072#1079#1072')'
      FormName = 'TReport_MovementCheck_PromoDoctorsForm'
      FormNameParam.Value = 'TReport_MovementCheck_PromoDoctorsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'FormCaption'
          Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' ('#1055#1088#1086#1084#1086' '#1074#1088#1072#1095#1080'  ('#1052#1077#1076#1080#1082#1072#1083' '#1055#1083#1072#1079#1072'))'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeID'
          Value = 16904771
          MultiSelectSeparator = ','
        end
        item
          Name = 'ChangePercent'
          Value = 2.500000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReport_PromoEntrances: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1086#1084#1086' '#1087#1086#1076#1098#1077#1079#1076#1099
      FormName = 'TReport_MovementCheck_PromoEntrancesForm'
      FormNameParam.Value = 'TReport_MovementCheck_PromoEntrancesForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actIlliquidUnitJournal: TdsdOpenForm
      Category = #1052#1072#1088#1082#1077#1090#1080#1085#1075
      MoveParams = <>
      Caption = #1047#1072#1092#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1099#1077' '#1085#1077#1083#1080#1082#1074#1080#1076#1099' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      Hint = #1047#1072#1092#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1099#1077' '#1085#1077#1083#1080#1082#1074#1080#1076#1099' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      FormName = 'TIlliquidUnitJournalForm'
      FormNameParam.Value = 'TIlliquidUnitJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actLoyaltySaveMoneyJournal: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1083#1086#1103#1083#1100#1085#1086#1089#1090#1080' '#1085#1072#1082#1086#1087#1080#1090#1077#1083#1100#1085#1072#1103
      Hint = #1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1083#1086#1103#1083#1100#1085#1086#1089#1090#1080' '#1085#1072#1082#1086#1087#1080#1090#1077#1083#1100#1085#1072#1103
      FormName = 'TLoyaltySaveMoneyJournalForm'
      FormNameParam.Value = 'TLoyaltySaveMoneyJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_IlliquidReductionPlanUser: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1083#1072#1085' '#1087#1086' '#1091#1084#1077#1085#1100#1096#1077#1085#1080#1102' '#1082#1086#1083'-'#1074#1086' '#1085#1077#1083#1080#1082#1074#1080#1076#1072'  '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
      Hint = #1054#1090#1095#1077#1090' '#1087#1083#1072#1085' '#1087#1086' '#1091#1084#1077#1085#1100#1096#1077#1085#1080#1102' '#1082#1086#1083'-'#1074#1086' '#1085#1077#1083#1080#1082#1074#1080#1076#1072'  '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
      FormName = 'TReport_IlliquidReductionPlanUserForm'
      FormNameParam.Value = 'TReport_IlliquidReductionPlanUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actBuyer: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1080
      Hint = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1080
      FormName = 'TBuyerForm'
      FormNameParam.Value = 'TBuyerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_StockTiming_RemainderForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1086#1089#1090#1072#1090#1086#1082' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072' '#1085#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1080
      Hint = #1054#1090#1095#1077#1090' '#1090#1086#1074#1072#1088#1085#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1042#1080#1090#1091#1088#1090#1091#1072#1083#1100#1085#1086#1084' '#1089#1082#1083#1072#1076#1077' '#1057#1088#1086#1082#1080
      FormName = 'TReport_StockTiming_RemainderForm'
      FormNameParam.Value = 'TReport_StockTiming_RemainderForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_InventoryErrorRemains: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080' '#1089' '#1080#1079#1084#1077#1085#1080#1074#1096#1080#1084#1089#1103' '#1086#1089#1090#1072#1090#1082#1086#1084
      Hint = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080' '#1089' '#1080#1079#1084#1077#1085#1080#1074#1096#1080#1084#1089#1103' '#1086#1089#1090#1072#1090#1082#1086#1084
      FormName = 'TReport_InventoryErrorRemainsForm'
      FormNameParam.Value = 'TReport_InventoryErrorRemainsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_SendSUNLoss: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1089#1087#1080#1089#1072#1085#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072' '#1089#1086' '#1089#1090#1072#1090#1100#1077#1081' '#1089#1087#1080#1089#1072#1085#1080#1103
      Hint = #1054#1090#1095#1077#1090' '#1089#1087#1080#1089#1072#1085#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072' '#1089#1086' '#1089#1090#1072#1090#1100#1077#1081' '#1089#1087#1080#1089#1072#1085#1080#1103
      FormName = 'TReport_SendSUNLossForm'
      FormNameParam.Value = 'TReport_SendSUNLossForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_SendSUNDelay: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = 
        #1054#1090#1095#1077#1090' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1085#1099#1081' '#1090#1086#1074#1072#1088' '#1087#1086' '#1057#1059#1053' v.1 '#1080' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1081' '#1085#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077 +
        #1085#1080#1080' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077
      Hint = 
        #1054#1090#1095#1077#1090' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1085#1099#1081' '#1090#1086#1074#1072#1088' '#1087#1086' '#1057#1059#1053' v.1 '#1080' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1081' '#1085#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077 +
        #1085#1080#1080' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1077
      FormName = 'TReport_SendSUNDelayForm'
      FormNameParam.Value = 'TReport_SendSUNDelayForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_SUNSaleDates: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1089#1088#1086#1082#1086#1074' '#1087#1086' '#1057#1059#1053' v.1 ('#1076#1083#1103' '#1076#1077#1083#1100#1090#1099')'
      Hint = #1055#1088#1086#1076#1072#1078#1072' '#1089#1088#1086#1082#1086#1074' '#1087#1086' '#1057#1059#1053' v.1 ('#1076#1083#1103' '#1076#1077#1083#1100#1090#1099')'
      FormName = 'TReport_SUNSaleDatesForm'
      FormNameParam.Value = 'TReport_SUNSaleDatesForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actTechnicalRediscount: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1058#1077#1093#1085#1080#1095#1077#1089#1082#1080#1077' '#1087#1077#1088#1077#1091#1095#1077#1090#1099
      Hint = #1058#1077#1093#1085#1080#1095#1077#1089#1082#1080#1077' '#1087#1077#1088#1077#1091#1095#1077#1090#1099
      FormName = 'TTechnicalRediscountJournalForm'
      FormNameParam.Value = 'TTechnicalRediscountJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actTechnicalRediscountCashier: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1058#1077#1093#1085#1080#1095#1077#1089#1082#1080#1077' '#1087#1077#1088#1077#1091#1095#1077#1090#1099'  ('#1076#1083#1103' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1086#1074')'
      Hint = #1058#1077#1093#1085#1080#1095#1077#1089#1082#1080#1077' '#1087#1077#1088#1077#1091#1095#1077#1090#1099' ('#1076#1083#1103' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1086#1074')'
      FormName = 'TTechnicalRediscountCashierJournalForm'
      FormNameParam.Value = 'TTechnicalRediscountCashierJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actHelsiUser: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1080' '#1087#1072#1088#1086#1083#1080' '#1045#1093#1077#1083#1089' ('#1057#1055')'
      Hint = #1054#1090#1095#1077#1090' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1080' '#1087#1072#1088#1086#1083#1080' '#1045#1093#1077#1083#1089' ('#1057#1055')'
      FormName = 'THelsiUserForm'
      FormNameParam.Value = 'THelsiUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_EntryGoodsMovement: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1042#1093#1086#1078#1076#1077#1085#1080#1077' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1072' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1042#1093#1086#1078#1076#1077#1085#1080#1077' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1072' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      FormName = 'TReport_EntryGoodsMovementForm'
      FormNameParam.Value = 'TReport_EntryGoodsMovementForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GeneralMovementGoods: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1073#1097#1080#1081' '#1086#1090#1095#1077#1090' '#1087#1086' '#1076#1074#1080#1078#1077#1085#1080#1102' '#1090#1086#1074#1072#1088#1072
      Hint = #1054#1073#1097#1080#1081' '#1086#1090#1095#1077#1090' '#1087#1086' '#1076#1074#1080#1078#1077#1085#1080#1102' '#1090#1086#1074#1072#1088#1072
      FormName = 'TReport_GeneralMovementGoodsForm'
      FormNameParam.Value = 'TReport_GeneralMovementGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSeasonalityCoefficient: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1099' '#1089#1077#1079#1086#1085#1085#1086#1089#1090#1080
      Hint = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1099' '#1089#1077#1079#1086#1085#1085#1086#1089#1090#1080
      FormName = 'TSeasonalityCoefficientEditForm'
      FormNameParam.Value = 'TSeasonalityCoefficientEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_PharmacyPerformance: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1101#1092#1092#1077#1082#1090#1080#1074#1085#1086#1089#1090#1080' '#1072#1087#1090#1077#1082
      Hint = #1054#1090#1095#1077#1090' '#1101#1092#1092#1077#1082#1090#1080#1074#1085#1086#1089#1090#1080' '#1072#1087#1090#1077#1082
      FormName = 'TReport_PharmacyPerformanceForm'
      FormNameParam.Value = 'TReport_PharmacyPerformanceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_NomenclaturePeriod: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1085#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072#1084' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1085#1086#1084#1077#1085#1082#1083#1072#1090#1091#1088#1072#1084' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      FormName = 'TReport_NomenclaturePeriodForm'
      FormNameParam.Value = 'TReport_NomenclaturePeriodForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actHardware: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1040#1087#1087#1072#1088#1072#1090#1085#1072#1103' '#1095#1072#1089#1090#1100
      Hint = #1040#1087#1087#1072#1088#1072#1090#1085#1072#1103' '#1095#1072#1089#1090#1100
      FormName = 'THardwareForm'
      FormNameParam.Value = 'THardwareForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actLossFundJournal: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1087#1080#1089#1072#1085#1080#1077' ('#1088#1072#1073#1086#1090#1072' '#1089' '#1092#1086#1085#1076#1086#1084')'
      Hint = #1057#1087#1080#1089#1072#1085#1080#1077' ('#1088#1072#1073#1086#1090#1072' '#1089' '#1092#1086#1085#1076#1086#1084')'
      FormName = 'TLossFundJournalForm'
      FormNameParam.Value = 'TLossFundJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_IncomeVATBalance: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1056#1077#1072#1083#1080#1079#1072#1094#1080#1103' '#1080' '#1086#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1087#1077#1088#1080#1086#1076' '#1073#1077#1079' '#1053#1044#1057
      FormName = 'TReport_IncomeVATBalanceForm'
      FormNameParam.Value = 'TReport_IncomeVATBalanceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actProjectsImprovements: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1088#1086#1077#1082#1090#1099'/'#1044#1086#1088#1072#1073#1086#1090#1082#1080
      FormName = 'TProjectsImprovementsJournalForm'
      FormNameParam.Value = 'TProjectsImprovementsJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ImplementationPeriod: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1092#1080#1085'.)'
      MoveParams = <>
      Caption = #1056#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      FormName = 'TReport_ImplementationPeriodForm'
      FormNameParam.Value = 'TReport_ImplementationPeriodForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSearchRemainsVIP: TdsdOpenStaticForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1086#1080#1089#1082' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1086#1074' VIP'
      ShortCut = 117
      FormName = 'TSearchRemainsVIPForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSendMenegerVIPJournal: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' (VIP)'
      FormName = 'TSendMenegerVIPJournalForm'
      FormNameParam.Value = 'TSendMenegerVIPJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Sun_Supplement: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1044#1086#1087#1086#1083#1085#1077#1085#1080#1103' '#1074' '#1057#1059#1053' v.1'
      Hint = #1054#1090#1095#1077#1090' '#1044#1086#1087#1086#1083#1085#1077#1085#1080#1103' '#1074' '#1057#1059#1053' v.1'
      FormName = 'TReport_Movement_Send_RemainsSun_SupplementForm'
      FormNameParam.Value = 'TReport_Movement_Send_RemainsSun_SupplementForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSendPartionDateChangeJournal: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1047#1072#1103#1074#1082#1080' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080
      FormName = 'TSendPartionDateChangeJournalForm'
      FormNameParam.Value = 'TSendPartionDateChangeJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actCheckSummCard: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1047#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1087#1088#1077#1076#1086#1087#1083#1072#1090#1099' '#1085#1072' '#1082#1072#1088#1090#1091
      ShortCut = 119
      FormName = 'TCheckSummCardForm'
      FormNameParam.Value = 'TCheckSummCardForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actTReport_Check_NumberChecks: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      Hint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      FormName = 'TReport_Check_NumberChecksForm'
      FormNameParam.Value = 'TReport_Check_NumberChecksForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actHouseholdInventory: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' "'#1061#1086#1079#1103#1081#1089#1090#1074#1077#1085#1085#1099#1081' '#1080#1085#1074#1077#1085#1090#1072#1088#1100'"'
      FormName = 'THouseholdInventoryForm'
      FormNameParam.Value = 'THouseholdInventoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actIncomeHouseholdInventory: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076#1099' '#1093#1086#1079#1103#1081#1089#1090#1074#1077#1085#1085#1086#1075#1086' '#1080#1085#1074#1077#1085#1090#1072#1088#1103
      FormName = 'TIncomeHouseholdInventoryJournalForm'
      FormNameParam.Value = 'TIncomeHouseholdInventoryJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actTHouseholdInventoryRemains: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1054#1089#1090#1072#1090#1082#1080' '#1093#1086#1079#1103#1081#1089#1090#1074#1077#1085#1085#1086#1075#1086' '#1080#1085#1074#1077#1085#1090#1072#1088#1103
      FormName = 'TReport_HouseholdInventoryRemainsForm'
      FormNameParam.Value = 'TReport_HouseholdInventoryRemainsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actWriteOffHouseholdInventory: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1057#1087#1080#1089#1072#1085#1080#1077' '#1093#1086#1079#1103#1081#1089#1090#1074#1077#1085#1085#1086#1075#1086' '#1080#1085#1074#1077#1085#1090#1072#1088#1103
      FormName = 'TWriteOffHouseholdInventoryJournalForm'
      FormNameParam.Value = 'TWriteOffHouseholdInventoryJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_PercentageOccupancySUN: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1055#1088#1086#1094#1077#1085#1090' '#1079#1072#1085#1091#1083#1077#1085#1080#1103' '#1057#1059#1053
      FormName = 'TReport_PercentageOccupancySUNForm'
      FormNameParam.Value = 'TReport_PercentageOccupancySUNForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actComputerAccessoriesRegister: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1086#1084#1087#1100#1102#1090#1077#1088#1085#1099#1077' '#1072#1082#1089#1077#1089#1089#1091#1072#1088#1099
      Hint = #1050#1086#1084#1087#1100#1102#1090#1077#1088#1085#1099#1077' '#1072#1082#1089#1077#1089#1089#1091#1072#1088#1099
      FormName = 'TComputerAccessoriesRegisterJournalForm'
      FormNameParam.Value = 'TComputerAccessoriesRegisterJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actInventoryHouseholdInventory: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103' '#1093#1086#1079#1103#1081#1089#1090#1074#1077#1085#1085#1086#1075#1086' '#1080#1085#1074#1077#1085#1090#1072#1088#1103
      FormName = 'TInventoryHouseholdInventoryJournalForm'
      FormNameParam.Value = 'TInventoryHouseholdInventoryJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_LeftSend: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1072#1084#1073#1101#1082#1080' '#1087#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103#1084' '#1087#1077#1088#1077#1076' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1077#1081
      Hint = #1050#1072#1084#1073#1101#1082#1080' '#1087#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103#1084' '#1087#1077#1088#1077#1076' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1077#1081
      FormName = 'TReport_LeftSendForm'
      FormNameParam.Value = 'TReport_LeftSendForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPositionsUKTVEDonSUN: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1055#1086#1079#1080#1094#1080#1080' '#1059#1050#1058#1042#1069#1044' '#1087#1086' '#1057#1059#1053#1072#1084
      FormName = 'TReport_PositionsUKTVEDonSUNForm'
      FormNameParam.Value = 'TReport_PositionsUKTVEDonSUNForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDivisionParties: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1056#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1087#1072#1088#1090#1080#1081' '#1074' '#1082#1072#1089#1089#1077' '#1076#1083#1103' '#1087#1088#1086#1076#1072#1078
      FormName = 'TDivisionPartiesForm'
      FormNameParam.Value = 'TDivisionPartiesForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actJuridicalPriorities: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090#1099' '#1087#1088#1080' '#1074#1099#1073#1086#1088#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      FormName = 'TJuridicalPrioritiesForm'
      FormNameParam.Value = 'TJuridicalPrioritiesForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_CommentSendSUN: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1055#1088#1080#1095#1080#1085#1099' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1057#1059#1053
      FormName = 'TReport_CommentSendSUNForm'
      FormNameParam.Value = 'TReport_CommentSendSUNForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ChangeCommentsSUN: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1054#1090#1095#1105#1090' '#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1082#1086#1084#1084#1077#1085#1090#1072#1088#1080#1077#1074' '#1057#1059#1053
      FormName = 'TReport_ChangeCommentsSUNForm'
      FormNameParam.Value = 'TReport_ChangeCommentsSUNForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ArrivalWithoutSales: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076#1099' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      Hint = #1055#1088#1080#1093#1086#1076#1099' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      FormName = 'TReport_ArrivalWithoutSalesForm'
      FormNameParam.Value = 'TReport_ArrivalWithoutSalesForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actLoyaltyPresentJournal: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1083#1086#1103#1083#1100#1085#1086#1089#1090#1080', '#1087#1086#1076#1072#1088#1086#1082
      Hint = #1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1083#1086#1103#1083#1100#1085#1086#1089#1090#1080', '#1087#1086#1076#1072#1088#1086#1082
      FormName = 'TLoyaltyPresentJournalForm'
      FormNameParam.Value = 'TLoyaltyPresentJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ResortsByLot: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1089#1086#1088#1090#1099' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084' '#1090#1086#1074#1072#1088#1072
      FormName = 'TReport_ResortsByLotForm'
      FormNameParam.Value = 'TReport_ResortsByLotForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_TwoVendorBindings: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1050' '#1086#1076#1085#1086#1084#1091' '#1090#1086#1074#1072#1088#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1085#1077#1089#1082#1086#1083#1100#1082#1086' '#1086#1089#1085#1086#1074#1085#1099#1093' '#1090#1086#1074#1072#1088#1086#1074
      FormName = 'TReport_TwoVendorBindingsForm'
      FormNameParam.Value = 'TReport_TwoVendorBindingsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRelatedProduct: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1057#1086#1087#1091#1090#1089#1090#1074#1091#1102#1097#1080#1077' '#1090#1086#1074#1072#1088#1099
      FormName = 'TRelatedProductJournalForm'
      FormNameParam.Value = 'TRelatedProductJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_TestingUserAttempts: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1086#1087#1099#1090#1086#1082' '#1089#1076#1072#1095#1080' '#1101#1082#1079#1072#1084#1077#1085#1086#1074' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
      FormName = 'TReport_TestingUserAttemptsForm'
      FormNameParam.Value = 'TReport_TestingUserAttemptsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object acTReport_SAUA: TdsdOpenForm
      Category = #1041#1040#1048
      MoveParams = <>
      Caption = 
        #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1080#1089#1090#1077#1084#1077' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1086#1084' ('#1089#1090#1072#1088#1099 +
        #1081')'
      FormName = 'TReport_SAUAForm'
      FormNameParam.Value = 'TReport_SAUAForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDistributionPromo: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1056#1072#1079#1076#1072#1095#1072' '#1072#1082#1094#1080#1086#1085#1085#1099#1093' '#1084#1072#1090#1077#1088#1080#1072#1083#1086#1074
      FormName = 'TDistributionPromoJournalForm'
      FormNameParam.Value = 'TDistributionPromoJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_PriceCheck: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1094#1077#1085' '#1084#1077#1078#1076#1091' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084#1080
      FormName = 'TReport_PriceCheckForm'
      FormNameParam.Value = 'TReport_PriceCheckForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_ClippedReprice_SaleForm: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088' '#1080' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1087#1077#1088#1077#1086#1094#1077#1085#1082#1080' ('#1086#1096#1080#1073#1082#1080')'
      FormName = 'TReport_ClippedReprice_SaleForm'
      FormNameParam.Value = 'TReport_ClippedReprice_SaleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_PromoDoctorsShevchenko9: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1086#1084#1086' '#1074#1088#1072#1095#1080'  ('#1064#1077#1074#1095#1077#1085#1082#1086' 9)'
      FormName = 'TReport_MovementCheck_PromoDoctorsForm'
      FormNameParam.Value = 'TReport_MovementCheck_PromoDoctorsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'FormCaption'
          Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' ('#1055#1088#1086#1084#1086' '#1074#1088#1072#1095#1080'  ('#1064#1077#1074#1095#1077#1085#1082#1086' 9))'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeID'
          Value = 21042082
          MultiSelectSeparator = ','
        end
        item
          Name = 'ChangePercent'
          Value = 2.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actCalculation_SAUA: TdsdOpenStaticForm
      Category = #1052#1072#1088#1082#1077#1090#1080#1085#1075
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1080#1089#1090#1077#1084#1077' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103' '#1072#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1086#1084
      FormName = 'TCalculation_SAUAForm'
      FormNameParam.Value = 'TCalculation_SAUAForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_MovementCheckSite: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1080' '#1095#1077#1088#1077#1079' '#1089#1072#1081#1090
      FormName = 'TReport_MovementCheckSiteForm'
      FormNameParam.Value = 'TReport_MovementCheckSiteForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actClearDefaultUnit: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1054#1095#1080#1089#1090#1082#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1074' '#1074#1072#1096#1077#1084' '#1072#1082#1082#1072#1091#1085#1090#1077
      FormName = 'TClearDefaultUnitForm'
      FormNameParam.Value = 'TClearDefaultUnitForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_QuantityComparison: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1095#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      FormName = 'TReport_Check_QuantityComparisonForm'
      FormNameParam.Value = 'TReport_Check_QuantityComparisonForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_RemainsSun_UKTZED: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1057#1059#1053' '#1087#1086' '#1059#1050#1058#1042#1069#1044' ('#1086#1090#1087#1088#1072#1074#1082#1072')'
      FormName = 'TReport_Movement_Send_RemainsSun_UKTZEDForm'
      FormNameParam.Value = 'TReport_Movement_Send_RemainsSun_UKTZEDForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsRemainsUKTZED: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1089#1090#1072#1090#1082#1080' '#1090#1086#1074#1072#1088#1072' '#1087#1086' '#1059#1050#1058#1042#1069#1044
      FormName = 'TReport_GoodsRemainsUKTZEDForm'
      FormNameParam.Value = 'TReport_GoodsRemainsUKTZEDForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_SalesOfTermDrugs: TdsdOpenForm
      Category = #1052#1072#1088#1082#1077#1090#1080#1085#1075
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1089#1088#1086#1082#1086#1074#1099#1093' '#1087#1088#1077#1087#1072#1088#1072#1090#1086#1074
      FormName = 'TReport_SalesOfTermDrugsForm'
      FormNameParam.Value = 'TReport_SalesOfTermDrugsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actFinalSUAJournal: TdsdOpenForm
      Category = #1052#1072#1088#1082#1077#1090#1080#1085#1075
      MoveParams = <>
      Caption = #1048#1090#1086#1075#1086#1074#1099#1081' '#1057#1059#1040
      FormName = 'TFinalSUAJournalForm'
      FormNameParam.Value = 'TFinalSUAJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Movement_Send_RemainsSun_SUA: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1057#1059#1053' '#1087#1086' '#1057#1059#1040
      FormName = 'TReport_Movement_Send_RemainsSun_SUAForm'
      FormNameParam.Value = 'TReport_Movement_Send_RemainsSun_SUAForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actInstructions: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1048#1085#1089#1090#1088#1091#1082#1094#1080#1080
      FormName = 'TInstructionsForm'
      FormNameParam.Value = 'TInstructionsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPromoBonus: TdsdOpenForm
      Category = #1052#1072#1088#1082#1077#1090#1080#1085#1075
      MoveParams = <>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1094#1077#1085#1099' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1089' '#1091#1095#1077#1090#1086#1084' '#1073#1086#1085#1091#1089#1072
      FormName = 'TPromoBonusJournalForm'
      FormNameParam.Value = 'TPromoBonusJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_HammerTimeSUN: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1090#1076#1072#1095#1072' '#1090#1086#1074#1072#1088#1072' '#1087#1086#1089#1083#1077' '#1087#1088#1080#1093#1086#1076#1072' '#1057#1059#1053
      FormName = 'TReport_HammerTimeSUNForm'
      FormNameParam.Value = 'TReport_HammerTimeSUNForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Check_PromoBonusLosses: TdsdOpenForm
      Category = #1052#1072#1088#1082#1077#1090#1080#1085#1075
      MoveParams = <>
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1087#1086' '#1084#1072#1088#1082#1077#1090' '#1073#1086#1085#1091#1089#1072#1084' '#1085#1086#1074#1072#1103'/'#1089#1090#1072#1088#1072#1103' '#1094#1077#1085#1072
      FormName = 'TReport_Check_PromoBonusLossesForm'
      FormNameParam.Value = 'TReport_Check_PromoBonusLossesForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Check_SP_ForDPSS: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1057#1055' '#1076#1083#1103' '#1044#1055#1057#1057
      FormName = 'TReport_Check_SP_ForDPSSForm'
      FormNameParam.Value = 'TReport_Check_SP_ForDPSSForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actDiscountExternalSupplier: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082#1080' '#1076#1083#1103' '#1087#1088#1086#1077#1082#1090#1086#1074' '#1076#1080#1089#1082#1086#1085#1090#1085#1099#1093' '#1082#1072#1088#1090
      FormName = 'TDiscountExternalSupplierForm'
      FormNameParam.Value = 'TDiscountExternalSupplierForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Check_PromoBonusEstimate: TdsdOpenForm
      Category = #1052#1072#1088#1082#1077#1090#1080#1085#1075
      MoveParams = <>
      Caption = #1055#1086#1090#1077#1085#1094#1080#1072#1083#1100#1085#1091#1102' '#1087#1088#1086#1076#1072#1078#1091' '#1089' '#1091#1095#1105#1090#1086#1084' '#1073#1086#1085#1091#1089#1086#1074
      FormName = 'TReport_Check_PromoBonusEstimateForm'
      FormNameParam.Value = 'TReport_Check_PromoBonusEstimateForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Check_CorrectMarketing: TdsdOpenForm
      Category = #1052#1072#1088#1082#1077#1090#1080#1085#1075
      MoveParams = <>
      Caption = #1063#1077#1082#1080' '#1089' '#1075#1072#1083#1086#1095#1082#1086#1081' '#1087#1086#1075#1072#1096#1077#1085#1080#1103' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072
      FormName = 'TReport_Check_CorrectMarketingForm'
      FormNameParam.Value = 'TReport_Check_CorrectMarketingForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_PromoBonusDisco: TdsdOpenForm
      Category = #1041#1040#1048
      MoveParams = <>
      Caption = #1044#1080#1089#1082#1086#1090#1077#1082#1072' '#1087#1086' '#1084#1072#1088#1082#1077#1090' '#1073#1086#1085#1091#1089#1072#1084
      FormName = 'TReport_Check_PromoBonusDiscoForm'
      FormNameParam.Value = 'TReport_Check_PromoBonusDiscoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actAccommodationLincGoods: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1088#1080#1074#1103#1079#1082#1080' '#1090#1086#1074#1072#1088#1086#1074' '#1082' '#1088#1072#1079#1084#1077#1097#1077#1085#1080#1102
      FormName = 'TAccommodationLincGoodsForm'
      FormNameParam.Value = 'TAccommodationLincGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_KilledCodeRecovery: TdsdOpenForm
      Category = #1052#1072#1088#1082#1077#1090#1080#1085#1075
      MoveParams = <>
      Caption = 'C'#1080#1089#1090#1077#1084#1072' '#1074#1086#1089#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1103' '#1091#1073#1080#1090#1086#1075#1086' '#1082#1086#1076#1072
      FormName = 'TReport_KilledCodeRecoveryForm'
      FormNameParam.Value = 'TReport_KilledCodeRecoveryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsDivisionLock: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1041#1083#1086#1082#1080#1088#1086#1074#1082#1072' '#1076#1077#1083#1077#1085#1080#1103' '#1090#1086#1074#1072#1088#1072' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      FormName = 'TGoodsDivisionLockForm'
      FormNameParam.Value = 'TGoodsDivisionLockForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRepriceUnit: TdsdOpenStaticForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1082#1072
      FormName = 'TRepriceUnitForm'
      FormNameParam.Value = 'TRepriceUnitForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRepriceСhangeRetail: TdsdOpenStaticForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1082#1072' '#1094#1077#1085' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
      FormName = 'TReprice'#1057'hangeRetailForm'
      FormNameParam.Value = 'TReprice'#1057'hangeRetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_Analysis_Remains_Selling: TdsdOpenStaticForm
      Category = #1052#1072#1088#1082#1077#1090#1080#1085#1075
      MoveParams = <>
      Caption = #1056#1077#1072#1083#1080#1079#1072#1094#1080#1103' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1086#1089#1090#1072#1090#1082#1086#1084' '#1085#1072' '#1082#1086#1085#1077#1094' '#1087#1077#1088#1080#1086#1076#1072
      FormName = 'TReport_Analysis_Remains_SellingForm'
      FormNameParam.Value = 'TReport_Analysis_Remains_SellingForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_IncomeConsumptionBalance: TdsdOpenStaticForm
      Category = #1052#1072#1088#1082#1077#1090#1080#1085#1075
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1088#1080#1093#1086#1076' '#1088#1072#1089#1093#1086#1076' '#1086#1089#1090#1072#1090#1086#1082
      FormName = 'TReport_IncomeConsumptionBalanceForm'
      FormNameParam.Value = 'TReport_IncomeConsumptionBalanceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_SalesGoods_SUA: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099' ('#1057#1059#1053')'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1090#1086#1074#1072#1088#1072' '#1087#1086' '#1057#1059#1040
      FormName = 'TReport_SalesGoods_SUAForm'
      FormNameParam.Value = 'TReport_SalesGoods_SUAForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actTestingTuning: TdsdOpenForm
      Category = #1055#1077#1088#1089#1086#1085#1072#1083
      MoveParams = <>
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1090#1077#1089#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1060#1072#1088#1084#1072#1094#1077#1074#1090#1086#1074
      FormName = 'TTestingTuningForm'
      FormNameParam.Value = 'TTestingTuningForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRepriceSite: TdsdOpenForm
      Category = #1057#1083#1091#1078#1077#1073#1085#1099#1077
      MoveParams = <>
      Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1082#1072' '#1076#1083#1103' '#1089#1072#1081#1090#1072
      FormName = 'TRepriceSiteForm'
      FormNameParam.Value = 'TRepriceSiteForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPriceSite: TdsdOpenForm
      Category = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      MoveParams = <>
      Caption = #1055#1088#1072#1081#1089' - '#1083#1080#1089#1090' '#1076#1083#1103' '#1089#1072#1081#1090#1072
      FormName = 'TPriceSiteForm'
      FormNameParam.Value = 'TPriceSiteForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 496
    Top = 24
  end
  inherited StoredProc: TdsdStoredProc
    Left = 48
  end
  inherited ClientDataSet: TClientDataSet
    Left = 104
    Top = 104
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
    Left = 200
    Top = 72
  end
  inherited MainMenu: TMainMenu
    Left = 488
    Top = 88
    inherited miGuide: TMenuItem
      object miCommon: TMenuItem
        Action = actGoods
      end
      object miGoods_NDS_diff: TMenuItem
        Action = actGoods_NDS_diff
      end
      object N142: TMenuItem
        Action = actGoods_BarCode
      end
      object miGoodsRetail: TMenuItem
        Action = actGoodsRetail
      end
      object N88: TMenuItem
        Caption = #1058#1086#1074#1072#1088#1099' '#1042#1057#1045
        Hint = #1058#1086#1074#1072#1088#1099
        object N89: TMenuItem
          Action = actGoodsAll
        end
        object N90: TMenuItem
          Action = actGoodsAllRetail
        end
        object N91: TMenuItem
          Action = actGoodsAllJuridical
        end
        object N260: TMenuItem
          Action = actRelatedProduct
        end
        object N192: TMenuItem
          Caption = '-'
        end
        object miGoodsAll_Tab: TMenuItem
          Action = actGoodsAll_Tab
        end
        object miGoodsAllRetail_Tab: TMenuItem
          Action = actGoodsAllRetail_Tab
        end
        object N196: TMenuItem
          Caption = '-'
        end
        object miGoodsMainTab_Error: TMenuItem
          Action = actGoodsMainTab_Error
        end
        object miGoodsRetailTab_Error: TMenuItem
          Action = actGoodsRetailTab_Error
        end
        object N258: TMenuItem
          Caption = '-'
        end
        object N259: TMenuItem
          Action = actReport_TwoVendorBindings
        end
      end
      object miAdditionalGoods: TMenuItem
        Action = actAdditionalGoods
      end
      object N1: TMenuItem
        Caption = #1050#1086#1076#1099' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
        object miGoodsPartnerCode: TMenuItem
          Action = actGoodsPartnerCode
        end
        object miGoodsPartnerCodeMaster: TMenuItem
          Action = actGoodsPartnerCodeMaster
        end
      end
      object miGoodsCategory: TMenuItem
        Action = actGoodsCategory
        Hint = #1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1085#1072#1103' '#1084#1072#1090#1088#1080#1094#1072' ('#1050#1072#1090#1077#1075#1086#1088#1080#1080')'
      end
      object miGoodsReprice: TMenuItem
        Action = actGoodsReprice
      end
      object N119: TMenuItem
        Caption = '-'
      end
      object N111: TMenuItem
        Caption = #1057#1086#1094'. '#1087#1088#1086#1077#1082#1090
        object N115: TMenuItem
          Action = actGoodsSP
        end
        object N112: TMenuItem
          Action = actKindOutSP
        end
        object N113: TMenuItem
          Action = actBrandSP
        end
        object N114: TMenuItem
          Action = actIntenalSP
        end
        object N120: TMenuItem
          Action = actPartnerMedical
        end
        object N41: TMenuItem
          Action = actMedicSP
        end
        object N129: TMenuItem
          Action = actMemberSP
        end
        object N139: TMenuItem
          Action = actSPKind
        end
        object N118: TMenuItem
          Caption = '-'
        end
        object N117: TMenuItem
          Action = actReport_CheckSP
        end
        object N281: TMenuItem
          Action = actReport_Check_SP_ForDPSS
        end
        object N13031: TMenuItem
          Action = actReport_SaleSP
        end
        object miReport_SummSP: TMenuItem
          Action = actReport_SummSP
        end
        object N134: TMenuItem
          Caption = '-'
        end
        object N70: TMenuItem
          Action = actInvoice
        end
        object miGoodsSPJournal: TMenuItem
          Action = actGoodsSPJournal
        end
      end
      object N103: TMenuItem
        Caption = '-'
      end
      object miUnit: TMenuItem
        Action = actUnit
      end
      object N149: TMenuItem
        Action = actUnit_Object
      end
      object N152: TMenuItem
        Action = actUnit_JuridicalArea
      end
      object N125: TMenuItem
        Action = actUnit_byReportBadm
      end
      object miUnit_MCS: TMenuItem
        Action = actUnit_MCS
      end
      object miUnitForOrderInternalPromo: TMenuItem
        Action = actUnitForOrderInternalPromo
      end
      object miRetail: TMenuItem
        Action = actRetail
      end
      object N145: TMenuItem
        Action = actProvinceCity
      end
      object N150: TMenuItem
        Action = actArea
      end
      object N151: TMenuItem
        Action = actJuridicalArea
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object miJuridical: TMenuItem
        Action = actJuridical
      end
      object miContract: TMenuItem
        Action = actContract
      end
      object miContactPerson: TMenuItem
        Action = actContactPerson
      end
      object N169: TMenuItem
        Action = actClientsByBank
      end
      object N64: TMenuItem
        Action = actMaker
        Hint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1080
      end
      object N107: TMenuItem
        Action = actOrderShedule
      end
      object miPlanIventory: TMenuItem
        Action = actPlanIventory
      end
      object N16: TMenuItem
        Caption = '-'
      end
      object N17: TMenuItem
        Action = actBank
      end
      object N18: TMenuItem
        Action = actBankAccount
      end
      object N19: TMenuItem
        Action = actReturnType
      end
      object N52: TMenuItem
        Action = actPrice
      end
      object miMCS_Lite: TMenuItem
        Action = actMCS_Lite
      end
      object N96: TMenuItem
        Action = actPriceOnDate
      end
      object N287: TMenuItem
        Action = actPriceSite
      end
      object N53: TMenuItem
        Action = actAlternativeGroup
      end
      object N54: TMenuItem
        Action = actPaidType
      end
      object N62: TMenuItem
        Action = actReportSoldParamsFormOpen
      end
      object N68: TMenuItem
        Action = actReasonDifferences
      end
      object N165: TMenuItem
        Caption = #1062#1077#1085#1099' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
        object miPriceChange: TMenuItem
          Action = actPriceChange
        end
        object miPriceChangeOnDate: TMenuItem
          Action = actPriceChangeOnDate
        end
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object N99: TMenuItem
        Caption = #1044#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
        object miDiscountExternalTools: TMenuItem
          Action = actDiscountExternalTools
        end
        object miDiscountExternalJuridical: TMenuItem
          Action = actDiscountExternalJuridical
        end
        object miDiscountExternal: TMenuItem
          Action = actDiscountExternal
        end
        object N101: TMenuItem
          Action = actDiscountCard
        end
        object N100: TMenuItem
          Action = actBarCode
        end
        object N282: TMenuItem
          Action = actDiscountExternalSupplier
        end
      end
      object N209: TMenuItem
        Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1099' '#1083#1086#1103#1083#1100#1085#1086#1089#1090#1080
        object N195: TMenuItem
          Action = actLoyaltyJournal
        end
        object N210: TMenuItem
          Action = actLoyaltySaveMoneyJournal
        end
        object N256: TMenuItem
          Action = actLoyaltyPresentJournal
        end
        object N205: TMenuItem
          Action = actPermanentDiscount
        end
        object N212: TMenuItem
          Caption = '-'
        end
        object N213: TMenuItem
          Action = actBuyer
        end
      end
    end
    object miPersonal: TMenuItem [1]
      Caption = #1055#1077#1088#1089#1086#1085#1072#1083
      object N75: TMenuItem
        Action = actEducation
      end
      object N78: TMenuItem
        Action = actPosition
      end
      object N77: TMenuItem
        Action = actPersonal
      end
      object N76: TMenuItem
        Action = actPersonalGroup
      end
      object N81: TMenuItem
        Action = actMember
      end
      object N140: TMenuItem
        Action = actMemberIncomeCheck
      end
      object N223: TMenuItem
        Action = actHelsiUser
      end
      object N80: TMenuItem
        Caption = '-'
      end
      object N79: TMenuItem
        Action = actCalendar
      end
      object N82: TMenuItem
        Action = actWorkTimeKind
      end
      object N83: TMenuItem
        Action = actSheetWorkTime
      end
      object N240: TMenuItem
        Caption = #1061#1086#1079#1103#1081#1089#1090#1074#1077#1085#1085#1099#1081' '#1080#1085#1074#1077#1085#1090#1072#1088#1100
        object N241: TMenuItem
          Action = actHouseholdInventory
        end
        object N242: TMenuItem
          Caption = '-'
        end
        object N243: TMenuItem
          Action = actIncomeHouseholdInventory
        end
        object N246: TMenuItem
          Action = actWriteOffHouseholdInventory
        end
        object N248: TMenuItem
          Action = actInventoryHouseholdInventory
        end
        object N244: TMenuItem
          Caption = '-'
        end
        object N245: TMenuItem
          Action = actTHouseholdInventoryRemains
        end
      end
      object N297: TMenuItem
        Action = actTestingTuning
      end
      object N87: TMenuItem
        Caption = '-'
      end
      object N86: TMenuItem
        Action = actReport_Wage
      end
      object N177: TMenuItem
        Action = actEmployeeSchedule
      end
      object N167: TMenuItem
        Action = actReport_TestingUser
      end
      object N172: TMenuItem
        Action = actReport_KPU
      end
      object actPUSH1: TMenuItem
        Action = actPUSH
      end
      object N190: TMenuItem
        Action = actWages
      end
    end
    object miLoad: TMenuItem [2]
      Caption = #1047#1072#1075#1088#1091#1079#1082#1080
      object miImportGroup: TMenuItem
        Action = actImportGroup
      end
      object miMovementLoad: TMenuItem
        Action = actMovementLoad
        Visible = False
      end
      object miPriceListLoad: TMenuItem
        Action = actPriceListLoad
      end
      object N15: TMenuItem
        Action = actPriceList
      end
      object N141: TMenuItem
        Action = actGoodsBarCodeLoad
      end
      object N170: TMenuItem
        Caption = '-'
      end
      object miPriceListLoad_Add: TMenuItem
        Action = actPriceListLoad_Add
      end
    end
    object miDocuments: TMenuItem [3]
      Caption = #1058#1086#1074#1072#1088#1085#1099#1081' '#1091#1095#1077#1090
      object N11: TMenuItem
        Action = actIncome
      end
      object N48: TMenuItem
        Action = actIncomePharmacy
      end
      object N293: TMenuItem
        Caption = '-'
      end
      object miRecalcMCSSheduler: TMenuItem
        Action = actRecalcMCSSheduler
      end
      object N58: TMenuItem
        Action = actCreateOrderFromMCS
      end
      object N13: TMenuItem
        Action = actOrderInternal
      end
      object N14: TMenuItem
        Action = actOrderInternalLite
        Visible = False
      end
      object N12: TMenuItem
        Action = actOrderExternal
      end
      object N294: TMenuItem
        Caption = '-'
      end
      object N168: TMenuItem
        Action = actListDiff
      end
      object miReport_Movement_ListDiff: TMenuItem
        Action = actReport_Movement_ListDiff
      end
      object N33: TMenuItem
        Caption = '-'
      end
      object N44: TMenuItem
        Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082
        object N45: TMenuItem
          Action = actMarginCategory
        end
        object N46: TMenuItem
          Action = actMarginCategoryItem
        end
        object N47: TMenuItem
          Action = actMarginCategoryLink
        end
        object N127: TMenuItem
          Action = actMarginCategory_Cross
          Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1086#1082' ('#1054#1073#1097#1080#1081')'
        end
        object miMarginCategory_All: TMenuItem
          Action = actMarginCategory_All
        end
        object N252: TMenuItem
          Action = actJuridicalPriorities
        end
      end
      object N173: TMenuItem
        Action = actRepriceUnitSheduler
      end
      object miReprice: TMenuItem
        Action = actRepriceUnit
      end
      object N265: TMenuItem
        Action = actReport_PriceCheck
      end
      object N72: TMenuItem
        Action = actRepriceJournal
      end
      object N295: TMenuItem
        Caption = '-'
      end
      object N57: TMenuItem
        Action = actSendJournal
      end
      object VIP1: TMenuItem
        Action = actSendMenegerVIPJournal
      end
      object N185: TMenuItem
        Action = actSendMenegerJournal
      end
      object N42: TMenuItem
        Caption = '-'
      end
      object N171: TMenuItem
        Action = actUnnamedEnterprises
      end
      object N66: TMenuItem
        Action = actSaleJournal
      end
      object N289: TMenuItem
        Caption = '-'
      end
      object N35: TMenuItem
        Action = actReturnOut
      end
      object miReturnOutPharmacy: TMenuItem
        Action = actReturnOutPharmacy
      end
      object miReport_Movement_ReturnOut: TMenuItem
        Action = actReport_Movement_ReturnOut
      end
      object N290: TMenuItem
        Caption = '-'
      end
      object N56: TMenuItem
        Action = actLossJournal
      end
      object N234: TMenuItem
        Action = actLossFundJournal
      end
      object N292: TMenuItem
        Caption = '-'
      end
      object N55: TMenuItem
        Action = actInventoryJournal
      end
      object N220: TMenuItem
        Action = actTechnicalRediscount
      end
      object N221: TMenuItem
        Action = actTechnicalRediscountCashier
      end
      object N237: TMenuItem
        Action = actSendPartionDateChangeJournal
      end
      object miSendPartionDate: TMenuItem
        Action = actSendPartionDate
      end
      object miReport_GoodsPartionDate: TMenuItem
        Action = actReport_GoodsPartionDate
      end
      object N291: TMenuItem
        Caption = '-'
      end
      object N49: TMenuItem
        Action = actCheck
      end
      object N238: TMenuItem
        Action = actCheckSummCard
      end
      object miReturnInJournal: TMenuItem
        Action = actReturnInJournal
      end
      object N43: TMenuItem
        Action = actSendOnPrice
        Visible = False
      end
    end
    object miReports: TMenuItem [4]
      Caption = #1054#1090#1095#1077#1090#1099
      object miBalance: TMenuItem
        Action = actBalance
      end
      object miReportGoodsOrder: TMenuItem
        Action = actReportGoodsOrder
        Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1086#1090' '#1079#1072#1082#1072#1079#1072' '#1076#1086' '#1087#1088#1086#1076#1072#1078#1080
      end
      object miSearchGoods: TMenuItem
        Action = actSearchGoods
      end
      object N60: TMenuItem
        Action = actChoiceGoodsFromRemains
      end
      object mniReport_Movement_ByPartionGoodsForm: TMenuItem
        Action = actReport_Movement_ByPartionGoodsForm
      end
      object actSearchRemainsVIP1: TMenuItem
        Action = actSearchRemainsVIP
      end
      object N39: TMenuItem
        Caption = '-'
      end
      object miReport_GoodRemains: TMenuItem
        Action = actReport_GoodRemains
      end
      object N144: TMenuItem
        Action = actReport_GoodsRemainsLight
      end
      object miReport_GoodsRemainsCurrent: TMenuItem
        Action = actReport_GoodsRemainsCurrent
      end
      object miReportMovementCheckForm: TMenuItem
        Action = actReportMovementCheckForm
      end
      object miReportMovementCheckFarmForm: TMenuItem
        Action = actReportMovementCheckFarmForm
      end
      object miReportMovementCheckFLForm: TMenuItem
        Action = actReportMovementCheckFLForm
      end
      object N194: TMenuItem
        Action = actReport_Profitability
      end
      object N143: TMenuItem
        Action = actReportMovementCheckLight
      end
      object N146: TMenuItem
        Action = actReport_Check_Assortment
      end
      object N147: TMenuItem
        Action = actReport_OverOrder
      end
      object N106: TMenuItem
        Action = actReport_MovementCheckErrorForm
      end
      object miReport_Check_Count: TMenuItem
        Action = actReport_Check_Count
      end
      object miReportMovementIncomeForm: TMenuItem
        Action = actReportMovementIncomeForm
      end
      object N51: TMenuItem
        Action = actReportMovementIncomeFarmForm
      end
      object miReport_GoodsPartionMoveForm: TMenuItem
        Action = actReport_GoodsPartionMoveForm
      end
      object miReport_GoodsPartionHistoryForm: TMenuItem
        Action = actReport_GoodsPartionHistoryForm
      end
      object miReport_SoldForm: TMenuItem
        Action = actReport_SoldForm
      end
      object miReport_Sold_DayForm: TMenuItem
        Action = actReport_Sold_DayForm
      end
      object miReport_Sold_DayUserForm: TMenuItem
        Action = actReport_Sold_DayUserForm
      end
      object miReport_LiquidForm: TMenuItem
        Action = actReport_LiquidForm
      end
      object N226: TMenuItem
        Action = actReport_GeneralMovementGoods
      end
      object N231: TMenuItem
        Action = actReport_NomenclaturePeriod
      end
      object miReport_IncomeSale_UseNDSKind: TMenuItem
        Action = actReport_IncomeSale_UseNDSKind
      end
      object N269: TMenuItem
        Action = actReport_MovementCheckSite
      end
      object N271: TMenuItem
        Action = actReport_QuantityComparison
      end
      object N273: TMenuItem
        Action = actReport_GoodsRemainsUKTZED
      end
      object N178: TMenuItem
        Caption = '-'
      end
      object N179: TMenuItem
        Caption = #1056#1086#1076#1078#1077#1088#1089
        object N181: TMenuItem
          Action = actReportRogersMovementCheck
        end
        object N180: TMenuItem
          Action = actRepriceRogersJournal
        end
      end
      object miReport_PriceProtocol: TMenuItem
        Action = actReport_PriceProtocol
      end
      object N267: TMenuItem
        Caption = #1055#1088#1086#1084#1086' '#1074#1088#1072#1095#1080
        object N206: TMenuItem
          Action = actReport_PromoDoctors
        end
        object N910: TMenuItem
          Action = actReport_PromoDoctorsShevchenko9
        end
      end
      object N207: TMenuItem
        Action = actReport_PromoEntrances
      end
      object N255: TMenuItem
        Action = actReport_ArrivalWithoutSales
      end
      object N266: TMenuItem
        Action = actReport_ClippedReprice_SaleForm
      end
    end
    object N36: TMenuItem [5]
      Caption = #1060#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1091#1095#1077#1090
      object N32: TMenuItem
        Action = actBankAccountDocument
      end
      object N37: TMenuItem
        Action = actBankLoad
      end
      object N67: TMenuItem
        Action = actPaymentJournal
      end
      object N38: TMenuItem
        Caption = '-'
      end
      object N34: TMenuItem
        Action = actLossDebt
      end
      object N73: TMenuItem
        Action = actChangeIncomePaymentJournal
      end
      object N135: TMenuItem
        Caption = '-'
      end
      object N105: TMenuItem
        Action = actReport_Payment_Plan
        Caption = #1043#1088#1072#1092#1080#1082' '#1087#1088#1086#1075#1085#1086#1079#1080#1088#1091#1077#1084#1099#1093' '#1087#1083#1072#1090#1077#1078#1077#1081
        Hint = ' '#1043#1088#1072#1092#1080#1082' '#1087#1088#1086#1075#1085#1086#1079#1080#1088#1091#1077#1084#1099#1093' '#1087#1083#1072#1090#1077#1078#1077#1081
      end
      object N199: TMenuItem
        Caption = '-'
      end
      object miReport_JuridicalSold: TMenuItem
        Action = actReport_JuridicalSold
      end
      object miReport_JuridicalCollation: TMenuItem
        Action = actReport_JuridicalCollation
      end
      object N224: TMenuItem
        Caption = '-'
      end
      object miReport_JuridicalRemains: TMenuItem
        Action = actReport_JuridicalRemains
      end
      object miReport_JuridicalSales: TMenuItem
        Action = actReport_JuridicalSales
      end
      object N235: TMenuItem
        Action = actReport_IncomeVATBalance
      end
      object N236: TMenuItem
        Action = actReport_ImplementationPeriod
      end
    end
    object N200: TMenuItem [6]
      Caption = #1057#1059#1053
      object N189: TMenuItem
        Action = actReport_BalanceGoodsSUN
      end
      object miReport_CheckSUN: TMenuItem
        Action = actReport_CheckSUN
      end
      object miReport_Movement_Send_RemainsSun: TMenuItem
        Action = actReport_Movement_Send_RemainsSun
      end
      object N222: TMenuItem
        Action = actReport_Movement_Send_RemainsSunOut
      end
      object miReport_GoodsSendSUN_over: TMenuItem
        Action = actReport_Send_RemainsSun_over
      end
      object miReport_CheckSendSUN_InOut: TMenuItem
        Action = actReport_CheckSendSUN_InOut
      end
      object miReport_GoodsSendSUN: TMenuItem
        Action = actReport_GoodsSendSUN
      end
      object miReport_SendSUN_SUNv2: TMenuItem
        Action = actReport_SendSUN_SUNv2
      end
      object N217: TMenuItem
        Action = actReport_SendSUNDelay
      end
      object v11: TMenuItem
        Action = actReport_Sun_Supplement
      end
      object N272: TMenuItem
        Action = actReport_RemainsSun_UKTZED
      end
      object N276: TMenuItem
        Action = actReport_Movement_Send_RemainsSun_SUA
      end
      object N202: TMenuItem
        Caption = '-'
      end
      object mmReport_Send_RemainsSun_express: TMenuItem
        Action = actReport_Movement_Send_RemainsSun_express
      end
      object miReport_Send_RemainsSunOut_express: TMenuItem
        Action = actReport_Movement_Send_RemainsSunOut_express
      end
      object miReport_Send_RemainsSunOut_expressV2: TMenuItem
        Action = actReport_Movement_Send_RemainsSunOut_expressV2
      end
      object N228: TMenuItem
        Caption = '-'
      end
      object miReport_Movement_Send_RemainsSun_pi: TMenuItem
        Action = actReport_Movement_Send_RemainsSun_pi
      end
      object N233: TMenuItem
        Caption = '-'
      end
      object miSunExclusion: TMenuItem
        Action = actSunExclusion
      end
      object N230: TMenuItem
        Caption = '-'
      end
      object miReport_CheckPartionDate: TMenuItem
        Action = actReport_CheckPartionDate
      end
      object N510: TMenuItem
        Action = actReport_GoodsPartionDate5
      end
      object N198: TMenuItem
        Action = actReport_GoodsPartionDate0
      end
      object N204: TMenuItem
        Action = actPercentageOverdueSUN
        Hint = #1054#1090#1095#1077#1090' '#1087#1088#1086#1094#1077#1085#1090' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1093' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' '#1087#1086' '#1057#1059#1053' v.1'
      end
      object N203: TMenuItem
        Caption = '-'
      end
      object N104: TMenuItem
        Action = actReport_MovementCheckUnLiquid
      end
      object N175: TMenuItem
        Action = actReportUnLiquid_Movement
      end
      object actReportGoodsNotSalePast1: TMenuItem
        Action = actReport_GoodsNotSalePast
      end
      object miReport_RemainsOverGoods: TMenuItem
        Action = actReport_RemainsOverGoods
      end
      object miReport_RemainsOverGoods_test: TMenuItem
        Action = actReport_RemainsOverGoods_test
        Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1080#1079#1083#1080#1096#1082#1086#1074' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084'  ('#1087#1077#1088#1077#1084#1077#1097#1072#1090#1100' '#1074#1089#1077')'
      end
      object N130: TMenuItem
        Action = actReport_RemainsOverGoods_To
      end
      object N84: TMenuItem
        Action = actOver
      end
      object miOverSettings: TMenuItem
        Action = actOverSettings
      end
      object N218: TMenuItem
        Action = actReport_CheckSUN
      end
      object N219: TMenuItem
        Action = actReport_SUNSaleDates
      end
      object actReportPercentageOccupancySUN1: TMenuItem
        Action = actReport_PercentageOccupancySUN
      end
      object N250: TMenuItem
        Action = actPositionsUKTVEDonSUN
      end
      object N253: TMenuItem
        Action = actReport_CommentSendSUN
      end
      object N254: TMenuItem
        Action = actReport_ChangeCommentsSUN
      end
      object N279: TMenuItem
        Action = actReport_HammerTimeSUN
      end
      object N296: TMenuItem
        Action = actReport_SalesGoods_SUA
      end
    end
    object N40: TMenuItem [7]
      Caption = #1041#1040#1048
      Hint = #1041#1083#1086#1082' '#1072#1085#1072#1083#1080#1090#1080#1095#1077#1089#1082#1080#1093' '#1080#1089#1089#1083#1077#1076#1086#1074#1072#1085#1080#1081
      object miReport_ProfitForm: TMenuItem
        Action = actReport_ProfitForm
      end
      object miReport_PriceInterventionForm: TMenuItem
        Action = actReport_PriceInterventionForm
      end
      object N59: TMenuItem
        Action = actReport_PriceIntervention2
      end
      object N63: TMenuItem
        Action = actReportMovementCheckMiddleForm
      end
      object N153: TMenuItem
        Action = actReport_CheckMiddle_Detail
      end
      object N229: TMenuItem
        Action = actReport_PharmacyPerformance
      end
      object N285: TMenuItem
        Action = actReport_PromoBonusDisco
      end
      object N138: TMenuItem
        Caption = '-'
      end
      object N137: TMenuItem
        Action = actReport_MovementPriceList_Cross
      end
      object N148: TMenuItem
        Caption = '-'
      end
      object miReportMovementCheckGrowthAndFalling: TMenuItem
        Action = actReportMovementCheckGrowthAndFalling
      end
      object N156: TMenuItem
        Action = actReport_Check_UKTZED
      end
      object N263: TMenuItem
        Action = acTReport_SAUA
      end
      object N155: TMenuItem
        Caption = '-'
      end
      object N154: TMenuItem
        Action = actMarginCategory_Movement
      end
      object N164: TMenuItem
        Action = actReport_Liquidity
      end
      object miReport_Check_PriceChange: TMenuItem
        Action = actReport_Check_PriceChange
      end
      object N166: TMenuItem
        Caption = '-'
      end
      object miMarginCategoryJournal2: TMenuItem
        Action = actMarginCategoryJournal2
      end
    end
    object N131: TMenuItem [8]
      Caption = #1052#1072#1088#1082#1077#1090#1080#1085#1075
      object miReport_MovementCheck_Cross: TMenuItem
        Action = actReport_MovementCheck_Cross
      end
      object miReport_MovementCheckFarm_Cross: TMenuItem
        Action = actReport_MovementCheckFarm_Cross
      end
      object N108: TMenuItem
        Action = actReport_MovementIncome_Promo
      end
      object N109: TMenuItem
        Action = actReport_MovementCheck_Promo
      end
      object N110: TMenuItem
        Action = actReport_CheckPromo
      end
      object N136: TMenuItem
        Action = actReport_CheckPromoFarm
      end
      object N2: TMenuItem
        Action = actReport_Analysis_Remains_Selling
      end
      object N116: TMenuItem
        Action = actReport_IncomeConsumptionBalance
      end
      object N163: TMenuItem
        Action = actReport_ImplementationPlanEmployeeAll
      end
      object N3: TMenuItem
        Action = actReport_ImplementationPlanEmployee
      end
      object N201: TMenuItem
        Action = actReport_IlliquidReductionPlanAll
      end
      object N211: TMenuItem
        Action = actReport_IlliquidReductionPlanUser
      end
      object miReport_IncomeSample: TMenuItem
        Action = actReport_IncomeSample
      end
      object N193: TMenuItem
        Action = actReport_DiscountExternal
      end
      object N214: TMenuItem
        Action = actReport_StockTiming_RemainderForm
      end
      object N268: TMenuItem
        Action = actCalculation_SAUA
      end
      object N275: TMenuItem
        Action = actFinalSUAJournal
      end
      object miReport_Check_GoodsPriceChange: TMenuItem
        Action = actReport_Check_GoodsPriceChange
      end
      object N186: TMenuItem
        Action = acttReport_GoodsPartionDate_Promo
      end
      object miOrderInternalPromo: TMenuItem
        Action = actOrderInternalPromo
      end
      object N132: TMenuItem
        Caption = '-'
      end
      object N65: TMenuItem
        Action = actPromo
      end
      object miLayoutJournal: TMenuItem
        Action = actLayoutJournal
      end
      object N278: TMenuItem
        Action = actPromoBonus
      end
      object N128: TMenuItem
        Action = actPromoUnit
      end
      object N122: TMenuItem
        Action = actReportPromoParams
      end
      object N124: TMenuItem
        Action = actReport_Check_Rating
      end
      object N208: TMenuItem
        Action = actIlliquidUnitJournal
      end
      object N264: TMenuItem
        Action = actDistributionPromo
      end
      object N216: TMenuItem
        Action = actReport_SendSUNLoss
      end
      object N274: TMenuItem
        Action = actReport_SalesOfTermDrugs
      end
      object N280: TMenuItem
        Action = actReport_Check_PromoBonusLosses
      end
      object N283: TMenuItem
        Action = actReport_Check_PromoBonusEstimate
        Caption = #1055#1086#1090#1077#1085#1094#1080#1072#1083#1100#1085#1099#1077' '#1087#1088#1086#1076#1072#1078#1099' '#1089' '#1091#1095#1105#1090#1086#1084' '#1073#1086#1085#1091#1089#1086#1074
      end
      object N284: TMenuItem
        Action = actReport_Check_CorrectMarketing
      end
      object C1: TMenuItem
        Action = actReport_KilledCodeRecovery
      end
      object N133: TMenuItem
        Caption = '-'
      end
      object N157: TMenuItem
        Caption = #1055#1088#1086#1084#1086' '#1082#1086#1076#1099
        Hint = #1055#1088#1086#1084#1086' '#1082#1086#1076#1099
        object N159: TMenuItem
          Action = actPromoCode
        end
        object N161: TMenuItem
          Caption = '-'
        end
        object N160: TMenuItem
          Action = actPromoCodeMovement
        end
      end
      object N158: TMenuItem
        Caption = '-'
      end
      object N123: TMenuItem
        Action = actReport_MinPrice_onGoods
      end
      object N69: TMenuItem
        Caption = '-'
      end
      object miReport_UploadBaDMForm: TMenuItem
        Action = actReport_UploadBaDMForm
      end
      object miReport_UploadOptimaForm: TMenuItem
        Action = actReport_UploadOptimaForm
      end
      object N126: TMenuItem
        Action = actReport_Badm
      end
    end
    inherited miService: TMenuItem
      inherited miServiceGuide: TMenuItem
        object miNDSKind: TMenuItem [0]
          Action = actNDSKind
        end
        object miOrderKind: TMenuItem [1]
          Action = actOrderKind
        end
        object miMeasure: TMenuItem [2]
          Action = actMeasure
        end
        object N121: TMenuItem [3]
          Action = actConditionsKeep
        end
        object miDiffKind: TMenuItem [4]
          Action = actDiffKind
        end
        object N184: TMenuItem [5]
          Action = actPartionDateKind
        end
        object miRetailCostCredit: TMenuItem [6]
          Action = actRetailCostCredit
        end
        object N8: TMenuItem [7]
          Caption = '-'
        end
        object N50: TMenuItem [8]
          Action = actCashRegister
        end
        object POS1: TMenuItem [9]
          Action = actBankPOSTerminal
        end
        object POS2: TMenuItem [10]
          Action = actUnitBankPOSTerminal
        end
        object N20: TMenuItem [11]
          Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
          object N21: TMenuItem
            Action = actAccountGroup
          end
          object N22: TMenuItem
            Action = actAccountDirection
          end
          object N23: TMenuItem
            Action = actAccount
          end
          object N24: TMenuItem
            Caption = '-'
          end
          object N25: TMenuItem
            Action = actInfoMoneyGroup
          end
          object N26: TMenuItem
            Action = actInfoMoneyDestination
          end
          object N27: TMenuItem
            Action = actInfoMoney
          end
          object N28: TMenuItem
            Caption = '-'
          end
          object N29: TMenuItem
            Action = actProfitLossGroup
          end
          object N30: TMenuItem
            Action = actProfitLossDirection
          end
          object N31: TMenuItem
            Action = actProfitLoss
          end
        end
        object N6: TMenuItem [12]
          Caption = '-'
        end
        object N97: TMenuItem [13]
          Action = actColor
        end
        object N74: TMenuItem [14]
          Action = actForms
        end
        object miTest: TMenuItem
          Action = actTestFormOpen
        end
        object N162: TMenuItem
          Caption = '-'
        end
        object actJackdawsChecks1: TMenuItem
          Action = actJackdawsChecks
        end
        object N187: TMenuItem
          Action = actDriver
        end
        object N188: TMenuItem
          Action = actUnitLincDriver
        end
        object N191: TMenuItem
          Action = actPayrollType
        end
        object N197: TMenuItem
          Action = actCashSettings
        end
        object N227: TMenuItem
          Action = actSeasonalityCoefficient
        end
        object N251: TMenuItem
          Action = actDivisionParties
          Caption = #1058#1080#1087#1099' '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081' '#1087#1072#1088#1090#1080#1081' '#1074' '#1082#1072#1089#1089#1077' '#1076#1083#1103' '#1087#1088#1086#1076#1072#1078
        end
        object N286: TMenuItem
          Action = actAccommodationLincGoods
        end
        object N288: TMenuItem
          Action = actGoodsDivisionLock
        end
      end
      object mmServiceFunctions: TMenuItem [1]
        Caption = #1057#1077#1088#1074#1080#1089#1085#1099#1077' '#1092#1091#1085#1082#1094#1080#1080
        object GUID1: TMenuItem
          Action = actLog_CashRemains
        end
        object N174: TMenuItem
          Action = actCheckNoCashRegister
        end
        object N182: TMenuItem
          Action = actGoodsInventory
        end
        object N215: TMenuItem
          Action = actReport_InventoryErrorRemains
        end
        object N225: TMenuItem
          Action = actReport_EntryGoodsMovement
        end
        object N232: TMenuItem
          Action = actHardware
        end
        object N239: TMenuItem
          Action = actTReport_Check_NumberChecks
        end
        object N249: TMenuItem
          Action = actReport_LeftSend
        end
        object N257: TMenuItem
          Action = actReport_ResortsByLot
        end
        object N262: TMenuItem
          Action = actReport_TestingUserAttempts
        end
      end
      object miTaxUnit: TMenuItem [2]
        Action = actTaxUnit
      end
      object miUser: TMenuItem [3]
        Action = actUser
      end
      object miRole: TMenuItem [4]
        Action = actRole
      end
      object N85: TMenuItem [5]
        Action = actRoleUnion
      end
      object N176: TMenuItem [6]
        Action = actCheckUnComplete
      end
      object miSetDefault: TMenuItem [7]
        Action = actSetDefault
      end
      object N92: TMenuItem [8]
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1055#1086#1095#1090#1099
        object N93: TMenuItem
          Action = actEmailSettings
        end
        object N94: TMenuItem
          Action = actEmailKind
        end
        object N95: TMenuItem
          Action = actEmailTools
        end
        object N71: TMenuItem
          Action = actEmail
        end
      end
      object miGoodsCommon: TMenuItem [9]
        Action = actGoodsMain
      end
      object N61: TMenuItem [10]
        Action = actGoodsOnUnit_ForSite
      end
      object N98: TMenuItem [11]
        Action = actConfirmedKind
      end
      object ID1: TMenuItem [12]
        Action = actReport_GoodsRemains_AnotherRetail
      end
      object N183: TMenuItem [13]
        Action = actCreditLimitDistributor
      end
      object actProjectsImprovements1: TMenuItem [14]
        Action = actProjectsImprovements
      end
      object N247: TMenuItem [15]
        Action = actComputerAccessoriesRegister
      end
      object N277: TMenuItem [16]
        Action = actInstructions
      end
      object N7: TMenuItem [17]
        Caption = '-'
      end
      object miSaveData: TMenuItem [18]
        Action = actSaveData
      end
      object miPriceGroupSettings: TMenuItem [19]
        Action = actPriceGroupSettings
      end
      object N102: TMenuItem [20]
        Action = actPriceGroupSettingsTOP
      end
      object miJuridicalSettings: TMenuItem [21]
        Action = actJuridicalSettings
      end
      object N9: TMenuItem [22]
        Caption = '-'
      end
      object miImportType: TMenuItem [23]
        Action = actImportType
      end
      object miImportSettings: TMenuItem [24]
        Action = actImportSettings
      end
      object miImportExportLink: TMenuItem [25]
        Action = actImportExportLink
      end
      object miGlobalConst: TMenuItem [26]
        Action = actGlobalConst
      end
      object FarmacyCash1: TMenuItem [28]
        Action = actUnitForFarmacyCash
      end
      object N10: TMenuItem [30]
        Caption = '-'
      end
      object miRepriceChange: TMenuItem [31]
        Action = actRepriceСhangeRetail
      end
      object miReprice_test: TMenuItem [32]
        Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1082#1072' ('#1090#1077#1089#1090')'
        OnClick = miReprice_testClick
      end
      object miRepricePromo: TMenuItem [33]
        Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1082#1072' '#1087#1086' '#1089#1088#1077#1076#1085#1080#1084' '#1094#1077#1085#1072#1084' '#1080' '#1084#1072#1088#1082'. '#1082#1086#1085#1090#1088#1072#1082#1090#1072#1084
        OnClick = miRepricePromoClick
      end
      object miExportSalesForSupp: TMenuItem [34]
        Action = actExportSalesForSuppClick
      end
      object miRepriceChangeJournal: TMenuItem [35]
        Action = actRepriceChangeJournal
      end
      object N298: TMenuItem [36]
        Action = actRepriceSite
      end
      object N261: TMenuItem [39]
        Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1085#1072#1079#1074#1072#1085#1080#1103#1084' '#1074' '#1084#1077#1085#1102
        OnClick = N261Click
      end
      object N270: TMenuItem [40]
        Action = actClearDefaultUnit
      end
    end
  end
  object DSGetInfo: TDataSource
    DataSet = CDSGetInfo
    Left = 592
    Top = 112
  end
  object CDSGetInfo: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 592
    Top = 64
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
        Name = 'inIP'
        Value = Null
        ComponentItem = 'IP_str'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 592
    Top = 16
  end
  object TimerPUSH: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = TimerPUSHTimer
    Left = 40
    Top = 8
  end
  object spGet_PUSH_Farmacy: TdsdStoredProc
    StoredProcName = 'gpGet_PUSH_Farmacy'
    DataSet = PUSHDS
    DataSets = <
      item
        DataSet = PUSHDS
      end>
    Params = <
      item
        Name = 'inNumberPUSH'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 128
    Top = 8
  end
  object PUSHDS: TClientDataSet
    Aggregates = <>
    Filtered = True
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'Id'
    Params = <>
    StoreDefs = True
    Left = 216
    Top = 8
  end
end
