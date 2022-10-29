inherited ProfitLossResultForm: TProfitLossResultForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1087#1086' '#1087#1088#1080#1073#1099#1083#1080' ('#1092#1080#1085#1072#1085#1089#1086#1074#1099#1081' '#1088#1077#1079#1091#1083#1100#1090#1072#1090')>'
  ClientHeight = 470
  ClientWidth = 823
  AddOnFormData.isSingle = True
  ExplicitWidth = 839
  ExplicitHeight = 509
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 116
    Width = 823
    Height = 354
    ExplicitTop = 116
    ExplicitWidth = 823
    ExplicitHeight = 354
    ClientRectBottom = 354
    ClientRectRight = 823
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 823
      ExplicitHeight = 330
      inherited cxGrid: TcxGrid
        Width = 823
        Height = 330
        ExplicitWidth = 823
        ExplicitHeight = 330
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_kredit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_debet
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = AccountName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_kredit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_debet
            end>
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object AccountCode: TcxGridDBColumn [0]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'AccountCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object AccountName: TcxGridDBColumn [1]
            Caption = #1057#1095#1077#1090
            DataBinding.FieldName = 'AccountName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 300
          end
          object ContainerId: TcxGridDBColumn [2]
            DataBinding.FieldName = 'ContainerId'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 149
          end
          object Amount_kredit: TcxGridDBColumn [3]
            Caption = #1050#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'Amount_kredit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Amount_debet: TcxGridDBColumn [4]
            Caption = #1044#1077#1073#1077#1090
            DataBinding.FieldName = 'Amount_debet'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Amount: TcxGridDBColumn [5]
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object BranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 109
          end
          object JuridicalBasisName: TcxGridDBColumn
            Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalBasisName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            Options.Editing = False
            Width = 129
          end
          object BusinessName: TcxGridDBColumn
            Caption = #1041#1080#1079#1085#1077#1089#1089
            DataBinding.FieldName = 'BusinessName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 109
          end
          object ProfitLossCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1057#1090#1072#1090#1100#1080
            DataBinding.FieldName = 'ProfitLossCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 149
          end
          object ProfitLossName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'ProfitLossName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 149
          end
          object ProfitLossGroupCode: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1075#1088#1091#1087#1087#1072')'
            DataBinding.FieldName = 'ProfitLossGroupCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ProfitLossGroupName: TcxGridDBColumn
            Caption = #1054#1055#1080#1059' '#1075#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'ProfitLossGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 155
          end
          object ProfitLossDirectionCode: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077')'
            DataBinding.FieldName = 'ProfitLossDirectionCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ProfitLossDirectionName: TcxGridDBColumn
            Caption = #1054#1055#1080#1059' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'ProfitLossDirectionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 167
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 823
    Height = 90
    TabOrder = 3
    ExplicitWidth = 823
    ExplicitHeight = 90
    inherited edInvNumber: TcxTextEdit
      Left = 16
      Top = 24
      ExplicitLeft = 16
      ExplicitTop = 24
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 16
      Top = 6
      ExplicitLeft = 16
      ExplicitTop = 6
    end
    inherited edOperDate: TcxDateEdit
      Left = 97
      Top = 24
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 97
      ExplicitTop = 24
      ExplicitWidth = 84
      Width = 84
    end
    inherited cxLabel2: TcxLabel
      Left = 97
      Top = 6
      Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
      ExplicitLeft = 97
      ExplicitTop = 6
      ExplicitWidth = 71
    end
    inherited cxLabel15: TcxLabel
      Left = 16
      Top = 45
      ExplicitLeft = 16
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Left = 16
      Top = 62
      ExplicitLeft = 16
      ExplicitTop = 62
      ExplicitWidth = 165
      ExplicitHeight = 22
      Width = 165
    end
    object cxLabel3: TcxLabel
      Left = 189
      Top = 6
      Caption = #1057#1095#1077#1090
    end
    object edAccount: TcxButtonEdit
      Left = 189
      Top = 24
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 204
    end
    object cxLabel22: TcxLabel
      Left = 189
      Top = 44
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 189
      Top = 62
      TabOrder = 9
      Width = 444
    end
    object cbisCorrective: TcxCheckBox
      Left = 407
      Top = 24
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1087#1088#1077#1076#1099#1076#1091#1097#1077#1075#1086' '#1087#1077#1088#1080#1086#1076#1072' ('#1076#1072'/'#1085#1077#1090')'
      Caption = #1050#1086#1088#1088'. '#1087#1088#1077#1076#1099#1076#1091#1097#1077#1075#1086' '#1087#1077#1088#1080#1086#1076#1072' ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = False
      TabOrder = 10
      Width = 226
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 259
    Top = 392
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 640
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    object actRefreshMI: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
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
    inherited actRefresh: TdsdDataSetRefresh
      RefreshOnTabSetChanges = True
    end
    object actPrintNoGroup: TdsdPrintAction [9]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      ImageIndex = 16
      ShortCut = 16464
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
      ReportName = 'PrintMovement_Send'
      ReportNameParam.Value = 'PrintMovement_Send'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
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
      ReportName = 'PrintMovement_SendAsset'
      ReportNameParam.Value = 'PrintMovement_SendAsset'
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
        end>
    end
    object actGoodsKindChoice: TOpenChoiceForm [15]
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
    object actStorageChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StorageForm'
      FormName = 'TStorage_ObjectForm'
      FormNameParam.Value = 'TStorage_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUnitChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'UnitForm'
      FormName = 'TUnit_ObjectForm'
      FormNameParam.Value = 'TUnit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPartionGoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartionGoodsForm'
      FormName = 'TPartionGoodsChoiceForm'
      FormNameParam.Value = 'TPartionGoodsChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inGoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitId'
          Value = ''
          Component = GuidesAccount
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitName'
          Value = Null
          Component = GuidesAccount
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Price'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StorageName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageName_Partion'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDatePartion'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsOperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actAssetGoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsForm'
      FormName = 'TAssetGoods_ObjectForm'
      FormNameParam.Value = 'TAssetGoods_ObjectForm'
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
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsKindCompleteChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsKindCompleteChoiceMaster'
      FormName = 'TGoodsKind_ObjectForm'
      FormNameParam.Value = 'TGoodsKind_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId_Complete'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName_Complete'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actAssetChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'AssetForm'
      FormName = 'TAsset_ObjectForm'
      FormNameParam.Value = 'TAsset_ObjectForm'
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
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
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
          Name = 'AmountRemains'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AmountRemains'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterUnitId'
          Value = Null
          Component = GuidesAccount
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterUnitName'
          Value = Null
          Component = GuidesAccount
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContainerId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContainerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'SerialNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SerialNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PassportNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PassportNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Release'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Release'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'MakerName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MakerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'CarName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CarName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'CarModelName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CarModelName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodUse'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PeriodUse'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPrintSaleOrder: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072
      Hint = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072
      ImageIndex = 21
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Sale_Order'
      ReportNameParam.Value = 'PrintMovement_Sale_Order'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintSaleOrderTax: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1085#1072' %'
      Hint = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1085#1072' %'
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Sale_Order'
      ReportNameParam.Value = 'PrintMovement_Sale_Order'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object InsertRecordGoods: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGridDBTableView
      Action = actAssetChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1054#1057'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1054#1057'>'
      ShortCut = 45
      ImageIndex = 0
    end
    object actInsert_MI: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_MI
      StoredProcList = <
        item
          StoredProc = spInsert_MI
        end>
      Caption = 'actInsert_MI'
    end
    object macInsert_MI: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsert_MI
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1089#1090#1088#1086#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1087#1086#1083#1085#1077#1085#1099
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1089#1090#1088#1086#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1089#1090#1088#1086#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 27
    end
  end
  inherited MasterDS: TDataSource
    Left = 16
    Top = 368
  end
  inherited MasterCDS: TClientDataSet
    Left = 80
    Top = 368
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_ProfitLossResult'
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptUnknown
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
      26
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
          BeginGroup = True
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
          ItemName = 'bbInsertRecordGoods'
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
          ItemName = 'bbRefresh'
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
          ItemName = 'bbStatic'
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
          ItemName = 'bbMovementItemProtocol'
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
    object bbPrintNoGroup: TdxBarButton
      Action = actPrintNoGroup
      Category = 0
    end
    object bbPrintSaleOrder: TdxBarButton
      Action = actPrintSaleOrder
      Category = 0
    end
    object bbPrintSaleOrderTax: TdxBarButton
      Action = actPrintSaleOrderTax
      Category = 0
    end
    object bbInsertRecordGoods: TdxBarButton
      Action = macInsert_MI
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    Left = 590
    Top = 209
  end
  inherited PopupMenu: TPopupMenu
    Left = 544
    Top = 384
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
        Value = Null
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
        Name = 'ReportNameSend'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 544
    Top = 176
  end
  inherited StatusGuides: TdsdGuides
    Left = 48
    Top = 0
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_ProfitLossResult'
    Left = 128
    Top = 8
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ProfitLossResult'
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
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
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
        Name = 'AccountId'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountName'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCorrective'
        Value = ''
        Component = cbisCorrective
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = 0.000000000000000000
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'fff'
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_ProfitLossResult'
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
        Name = 'inAccountId'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCorrective'
        Value = ''
        Component = cbisCorrective
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = 'False'
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
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
      end
      item
      end
      item
        Control = edOperDate
      end
      item
      end
      item
        Control = edAccount
      end
      item
      end
      item
      end
      item
        Control = ceComment
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
      end
      item
      end>
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 584
    Top = 264
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProfitLossResult_SetErased'
    Left = 654
    Top = 264
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProfitLossResult_SetUnErased'
    Left = 462
    Top = 392
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_ProfitLossResult'
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
        Name = 'inAccountId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AccountId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContainerId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContainerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 168
    Top = 360
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_ProfitLossResult'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
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
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHeadCount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindCompleteId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId_Complete'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAssetId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsId'
        Value = 0
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
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProfitLossResult_Print'
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
      end
      item
        Name = 'inisItem'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 367
    Top = 376
  end
  object GuidesAccount: TdsdGuides
    KeyField = 'Id'
    LookupControl = edAccount
    DisableGuidesOpen = True
    FormNameParam.Value = 'TAccount_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAccount_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 288
    Top = 16
  end
  object spInsert_MI: TdsdStoredProc
    StoredProcName = 'gpInsert_MI_ProfitLossResult'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inAccountId'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 250
    Top = 304
  end
end
