inherited GoodsSPInform_1303Form: TGoodsSPInform_1303Form
  Caption = #1056#1077#1077#1089#1090#1088' '#1055#1086#1089#1090'. 1303 ('#1055#1088#1080#1082#1072#1079' 408)'
  ClientHeight = 554
  ClientWidth = 1043
  AddOnFormData.AddOnFormRefresh.ParentList = 'Loss'
  ExplicitWidth = 1061
  ExplicitHeight = 601
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1043
    Height = 467
    ExplicitTop = 87
    ExplicitWidth = 1043
    ExplicitHeight = 467
    ClientRectBottom = 467
    ClientRectRight = 1043
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1043
      ExplicitHeight = 443
      inherited cxGrid: TcxGrid
        Width = 1043
        Height = 443
        ExplicitWidth = 1043
        ExplicitHeight = 443
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = #1057#1090#1088#1086#1082' 0'
              Kind = skCount
              Column = GoodsName
            end>
          OptionsBehavior.IncSearch = True
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.CellAutoHeight = True
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Col: TcxGridDBColumn [0]
            Caption = #8470' '#1087'.'#1087
            DataBinding.FieldName = 'Col'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0;-,0;  '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 48
          end
          object GoodsCode: TcxGridDBColumn [1]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsMainEdit
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 63
          end
          object MorionCode: TcxGridDBColumn [2]
            Caption = #1050#1086#1076' '#1084#1086#1088#1080#1086#1085#1072
            DataBinding.FieldName = 'MorionCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object GoodsName: TcxGridDBColumn [3]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 228
          end
          object IntenalSP_1303Name: TcxGridDBColumn [4]
            Caption = #1052#1110#1078#1085#1072#1088#1086#1076#1085#1072' '#1085#1077#1087#1072#1090#1077#1085#1090#1086#1074#1072#1085#1072' '#1085#1072#1079#1074#1072
            DataBinding.FieldName = 'IntenalSP_1303Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 151
          end
          object KindOutSP_1303Name: TcxGridDBColumn [5]
            Caption = #1060#1086#1088#1084#1072' '#1074#1080#1087#1091#1089#1082#1091' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091
            DataBinding.FieldName = 'KindOutSP_1303Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 129
          end
          object Dosage_1303Name: TcxGridDBColumn [6]
            Caption = #1044#1086#1079#1091#1074#1072#1085#1085#1103' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091
            DataBinding.FieldName = 'Dosage_1303Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 124
          end
          object PriceMargSP: TcxGridDBColumn [7]
            Caption = #1054#1087#1090#1086#1074#1086'-'#1074#1110#1076#1087#1091#1089#1082#1085#1072' '#1094#1110#1085#1072' '#1079#1072#160#1086#1076#1080#1085#1080#1094#1102' '#1075#1088#1085
            DataBinding.FieldName = 'PriceMargSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1043#1088#1072#1085#1080#1095#1085#1072' '#1086#1087#1090#1086#1074#1086'-'#1074#1110#1076#1087#1091#1089#1082#1085#1072' '#1094#1110#1085#1072' '#1074#160#1087#1077#1088#1077#1088#1072#1093#1091#1085#1082#1091' '#1085#1072#160#1086#1076#1080#1085#1080#1094#1102' '#1083#1110#1082#1072#1088#1089#1100#1082 +
              #1086#1111' '#1092#1086#1088#1084#1080', '#1075#1088#1085
            Options.Editing = False
            Width = 102
          end
          object PriceOptSP: TcxGridDBColumn [8]
            Caption = #1047#1072#1076#1077#1082#1083#1072#1088#1086#1074#1072#1085#1072' '#1086#1087#1090#1086#1074#1086'-'#1074#1110#1076#1087#1091#1089#1082#1085#1072' '#1094#1110#1085#1072
            DataBinding.FieldName = 'PriceOptSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object Referral: TcxGridDBColumn [9]
            Caption = #1056#1077#1092#1077#1088#1091#1074#1072#1085#1085#1103
            DataBinding.FieldName = 'Referral'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1086#1074#1085#1110#1096#1085#1108'/'#1074#1085#1091#1090#1088#1110#1096#1085#1108' '#1088#1077#1092#1077#1088#1091#1074#1072#1085#1085#1103'/'#1076#1077#1082#1083#1072#1088#1091#1074#1072#1085#1085#1103
            Options.Editing = False
            Width = 65
          end
          object NDS: TcxGridDBColumn [10]
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 37
          end
          object PriceSale: TcxGridDBColumn [11]
            Caption = #1056#1086#1079#1085'. '#1094#1077#1085#1072
            DataBinding.FieldName = 'PriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          inherited colIsErased: TcxGridDBColumn
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
          end
          object Color_Count: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Count'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
          end
          object isSale: TcxGridDBColumn
            Caption = #1054#1090#1087#1091#1097#1077#1085#1086' '
            DataBinding.FieldName = 'isSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object DoubleId: TcxGridDBColumn
            Caption = #1044#1091#1073#1083#1100
            DataBinding.FieldName = 'DoubleId'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1043
    TabOrder = 3
    ExplicitWidth = 1043
    inherited edInvNumber: TcxTextEdit
      Left = 182
      ExplicitLeft = 182
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 182
      ExplicitLeft = 182
    end
    inherited edOperDate: TcxDateEdit
      Left = 266
      EditValue = 42951d
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 266
      ExplicitWidth = 86
      Width = 86
    end
    inherited cxLabel2: TcxLabel
      Left = 266
      ExplicitLeft = 266
    end
    inherited ceStatus: TcxButtonEdit
      ExplicitWidth = 166
      ExplicitHeight = 22
      Width = 166
    end
    object edOperDateEnd: TcxDateEdit
      Left = 472
      Top = 23
      EditValue = 43326d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 6
      Width = 103
    end
    object cxLabel4: TcxLabel
      Left = 472
      Top = 5
      Caption = #1054#1082#1086#1085'. '#1089#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
    end
  end
  object edOperDateStart: TcxDateEdit [2]
    Left = 373
    Top = 23
    EditValue = 43326d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 6
    Width = 93
  end
  object cxLabel3: TcxLabel [3]
    Left = 373
    Top = 5
    Caption = #1053#1072#1095'.'#1089#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 387
    Top = 416
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 296
    Top = 352
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    object actRefreshMI: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object actGetImportSettingDel: TdsdExecStoredProc [1]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_del
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_del
        end>
      Caption = 'actGetImportSetting'
      Hint = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091'  '#1080#1079' '#1092#1072#1081#1083#1072
    end
    object actDoLoadDel: TExecuteImportSettingsAction [2]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    inherited actRefresh: TdsdDataSetRefresh
      RefreshOnTabSetChanges = True
    end
    object macStartLoadDel: TMultiAction [5]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingDel
        end
        item
          Action = actDoLoadDel
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1044#1072#1085#1085#1099'e '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1091#1076#1072#1083#1077#1085#1099'?'
      Caption = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091'  '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1048#1089#1082#1083#1102#1095#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091'  '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 37
      WithoutNext = True
    end
    object actInsertMI: TdsdExecStoredProc [9]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertMI
      StoredProcList = <
        item
          StoredProc = spInsertMI
        end>
      Caption = 'actInsertMI'
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProc = spUpdate_Goods
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods
        end
        item
          StoredProc = spGetTotalSumm
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint_GoodsSP
      StoredProcList = <
        item
          StoredProc = spSelectPrint_GoodsSP
        end>
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
      ReportName = #1057#1087#1080#1089#1072#1085#1080#1077
      ReportNameParam.Value = #1057#1087#1080#1089#1072#1085#1080#1077
      ReportNameParam.ParamType = ptInput
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
          StoredProc = spGet
        end>
    end
    object actGoodsKindChoice: TOpenChoiceForm [18]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actRefreshPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actComplete: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementComplete
      StoredProcList = <
        item
          StoredProc = spMovementComplete
        end
        item
          StoredProc = spGet
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1076#1085#1080#1084' '#1095#1080#1089#1083#1086#1084
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1076#1085#1080#1084' '#1095#1080#1089#1083#1086#1084
      ImageIndex = 12
    end
    object actChoiceMovGoodsSP: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TBrandSPForm'
      FormName = 'TGoodsSPJournalChoiceForm'
      FormNameParam.Value = 'TGoodsSPJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'MovementId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actIntenalSPChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TIntenalSPForm'
      FormName = 'TIntenalSPForm'
      FormNameParam.Value = 'TIntenalSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'IntenalSPId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'IntenalSPName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actBrandSPChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TBrandSPForm'
      FormName = 'TBrandSPForm'
      FormNameParam.Value = 'TBrandSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BrandSPId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BrandSPName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actKindOutSP_1303Choice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actKindOutSP_1303Choice'
      FormName = 'TKindOutSP_1303Form'
      FormNameParam.Value = 'TKindOutSP_1303Form'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'KindOutSP_1303Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'KindOutSP_1303Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object macInsertMI: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actChoiceMovGoodsSP
        end
        item
          Action = actInsertMI
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1076#1086#1073#1072#1074#1080#1090#1100' '#1090#1086#1074#1072#1088#1099' '#1080#1079' '#1076#1088#1091#1075#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1076#1086#1073#1072#1074#1083#1077#1085#1099
      Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1076#1088#1091#1075#1086#1075#1086' '#1076#1086#1082'-'#1090#1072
      Hint = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1076#1088#1091#1075#1086#1075#1086' '#1076#1086#1082'-'#1090#1072
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = '0'
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actGetImportSetting: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSetting'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091'  '#1080#1079' '#1092#1072#1081#1083#1072
    end
    object actSetErasedGoodsSp: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isSp_SetErased
      StoredProcList = <
        item
          StoredProc = spUpdate_isSp_SetErased
        end>
      Caption = 'actGetImportSetting'
    end
    object macStartLoad: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1044#1072#1085#1085#1099#1093' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091'  '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091'  '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091'  '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 41
      WithoutNext = True
    end
    object actChoiceGoodsSPInform_1303: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1055#1086#1089#1090'. 1303 ('#1056#1054#1054#1062')'
      Hint = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1055#1086#1089#1090'. 1303 ('#1056#1054#1054#1062')'
      ImageIndex = 26
      FormName = 'TChoiceGoodsSPInform_1303Form'
      FormNameParam.Value = 'TChoiceGoodsSPInform_1303Form'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsMain: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TIntenalSPForm'
      FormName = 'TGoodsMainForm'
      FormNameParam.Value = 'TGoodsMainForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'GoodsID'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actClearGoods: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spClearGoods
      StoredProcList = <
        item
          StoredProc = spClearGoods
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100' '#1089' '#1090#1086#1074#1072#1088#1086#1084
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100' '#1089' '#1090#1086#1074#1072#1088#1086#1084
      ImageIndex = 52
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100' '#1089' '#1090#1086#1074#1072#1088#1086#1084'?'
    end
    object actSetGoods: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actGoodsMain
      PostDataSetBeforeExecute = False
      StoredProc = spSetGoods
      StoredProcList = <
        item
          StoredProc = spSetGoods
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1103#1079#1100' '#1089' '#1090#1086#1074#1072#1088#1086#1084
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1103#1079#1100' '#1089' '#1090#1086#1074#1072#1088#1086#1084
      ImageIndex = 79
    end
    object actGoodsMainEdit: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TIntenalSPForm'
      FormName = 'TGoodsMainForm'
      FormNameParam.Value = 'TGoodsMainForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 192
    Top = 432
  end
  inherited MasterCDS: TClientDataSet
    Left = 256
    Top = 432
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_GoodsSPInform_1303'
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
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
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
      end>
    Left = 160
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 80
    Top = 207
    DockControlHeights = (
      0
      0
      27
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
          ItemName = 'bbStatic'
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
          ItemName = 'bbStartLoad'
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
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    object bbComplete: TdxBarButton
      Action = actComplete
      Category = 0
    end
    object bbInsertMI: TdxBarButton
      Action = macInsertMI
      Category = 0
      ImageIndex = 27
    end
    object bbStartLoad: TdxBarButton
      Action = macStartLoad
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091' '#1080#1079' '#1092#1072#1081#1083#1072
      Category = 0
    end
    object bbStartLoadDop: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100'  '#1044#1086#1087'. '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091' '#1080#1079' '#1092#1072#1081#1083#1072
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1086#1087'. '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091' '#1080#1079' '#1092#1072#1081#1083#1072
      Visible = ivAlways
      ImageIndex = 48
    end
    object bbStartLoadHelsi: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100'  '#1044#1086#1087'. '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091' '#1080#1079' '#1092#1072#1081#1083#1072' ('#1061#1077#1083#1089#1080')'
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1086#1087'. '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091' '#1080#1079' '#1092#1072#1081#1083#1072' ('#1061#1077#1083#1089#1080')'
      Visible = ivAlways
      ImageIndex = 30
    end
    object dxBarButton1: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100' '#1089' '#1090#1086#1074#1072#1088#1086#1084
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100' '#1089' '#1090#1086#1074#1072#1088#1086#1084
      Visible = ivAlways
      ImageIndex = 52
    end
    object dxBarButton2: TdxBarButton
      Action = actChoiceGoodsSPInform_1303
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actClearGoods
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actSetGoods
      Category = 0
    end
    object bbStartLoadDel: TdxBarButton
      Action = macStartLoadDel
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        BackGroundValueColumn = Color_Count
        ColorValueList = <>
      end>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    SearchAsFilter = False
    Left = 694
    Top = 185
  end
  inherited PopupMenu: TPopupMenu
    Left = 712
    Top = 408
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = '0'
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
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameLoss'
        Value = 'PrintMovement_Sale1'
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
        Name = 'ReportNameLossBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMask'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingDopId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingIsSpecConditionId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingHelsiId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsID'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 808
    Top = 240
  end
  inherited StatusGuides: TdsdGuides
    Left = 57
    Top = 16
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_GoodsSP'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 120
    Top = 16
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_GoodsSPInform_1303'
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
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateStart'
        Value = Null
        Component = edOperDateStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateEnd'
        Value = Null
        Component = edOperDateEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_GoodsSPInform_1303'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateStart'
        Value = Null
        Component = edOperDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateEnd'
        Value = Null
        Component = edOperDateEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
      end
      item
      end
      item
      end>
    Left = 160
    Top = 192
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = edOperDateEnd
      end
      item
        Control = edOperDateStart
      end
      item
      end
      item
      end>
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 696
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_GoodsSP_SetErased'
    Left = 598
    Top = 464
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_GoodsSP_SetUnErased'
    Left = 718
    Top = 464
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_GoodsSPInform_1303'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCol'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Col'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIntenalSP_1303Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IntenalSP_1303Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKindOutSP_1303Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'KindOutSP_1303Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDosage_1303Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Dosage_1303Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceMargSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceMargSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceOptSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceOptSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReferral'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Referral'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_GoodsSPInform_1303'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIntenalSPId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IntenalSPId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBrandSPId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BrandSPId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKindOutSP_1303Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'KindOutSP_1303Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDosage_1303Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'inDosage_1303Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountSP_1303Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountSP_1303Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMakerSP_1303Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MakerSP_1303Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountry_1303Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Country_1303Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCodeATX'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CodeATX'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReestrSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReestrSP'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReestrDateSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReestrDateSP'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValiditySP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ValiditySP'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceOptSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceOptSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CurrencyId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inExchangeRate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ExchangeRate'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOrderNumberSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OrderNumberSP'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOrderDateSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OrderDateSP'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inID_MED_FORM'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ID_MED_FORM'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMorionSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MorionSP'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 420
    Top = 188
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshPrice
    ComponentList = <
      item
      end>
    Left = 512
    Top = 328
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 193
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 246
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 644
    Top = 334
  end
  object spSelectPrint_GoodsSP: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_GoodsSP_Print'
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
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 319
    Top = 208
  end
  object spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_GoodsSP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = False
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 56
    Top = 384
  end
  object spInsertMI: TdsdStoredProc
    StoredProcName = 'gpInsert_MI_GoodsSP_Mask'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Mask'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    Left = 767
    Top = 312
  end
  object spUpdate_isSp_SetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_GoodsSP'
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 835
    Top = 414
  end
  object spGetImportSettingId: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TGoodsSPInform_1303Form;zc_Object_ImportSetting_GoodsSPInform_13' +
          '03'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 888
    Top = 224
  end
  object spClearGoods: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_GoodsSPInform_1303_ClearGoods'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = 
          'TGoodsSPInform_1303Form;zc_Object_ImportSetting_GoodsSPRegistry_' +
          '1303'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCol'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Col'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 912
    Top = 296
  end
  object spSetGoods: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_GoodsSPInform_1303_Goods'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsID'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCol'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Col'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 912
    Top = 352
  end
  object spUpdate_Goods: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_GoodsSPInform_1303_Goods'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsID'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCol'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Col'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 392
    Top = 344
  end
  object spGetImportSettingId_del: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TGoodsSPInform_1303DelForm;zc_Object_ImportSetting_GoodsSPSearch' +
          '_1303Del'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 984
    Top = 224
  end
end
