inherited CompetitorMarkupsForm: TCompetitorMarkupsForm
  Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077' '#1085#1072#1094#1077#1085#1086#1082' '#1089' '#1082#1086#1085#1082#1091#1088#1077#1085#1090#1072#1084#1080
  ClientHeight = 580
  ClientWidth = 1185
  AddOnFormData.AddOnFormRefresh.ParentList = 'Sale'
  ExplicitWidth = 1201
  ExplicitHeight = 619
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 75
    Width = 1185
    Height = 505
    ExplicitTop = 75
    ExplicitWidth = 1185
    ExplicitHeight = 505
    ClientRectBottom = 505
    ClientRectRight = 1185
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1185
      ExplicitHeight = 481
      inherited cxGrid: TcxGrid
        Width = 1185
        Height = 473
        ExplicitWidth = 1185
        ExplicitHeight = 473
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
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
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = #1057#1090#1088#1086#1082' 0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = Price
            end>
          OptionsBehavior.IncSearch = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GroupsName: TcxGridDBColumn [0]
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GroupsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 122
          end
          object SubGroupsName: TcxGridDBColumn [1]
            Caption = #1055#1086#1076#1075#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'SubGroupsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object GoodsCode: TcxGridDBColumn [2]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object GoodsName: TcxGridDBColumn [3]
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 360
          end
          object Price: TcxGridDBColumn [4]
            Caption = #1057#1088#1077#1076#1085#1103#1103' '#1094#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object Value: TcxGridDBColumn [5]
            DataBinding.FieldName = 'Value'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 70
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 473
        Width = 1185
        Height = 8
        Touch.ParentTabletOptions = False
        Touch.TabletOptions = [toPressAndHold]
        AlignSplitter = salBottom
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1185
    Height = 49
    TabOrder = 3
    ExplicitWidth = 1185
    ExplicitHeight = 49
    inherited edInvNumber: TcxTextEdit
      Left = 8
      Top = 20
      ExplicitLeft = 8
      ExplicitTop = 20
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      Top = 2
      ExplicitLeft = 8
      ExplicitTop = 2
    end
    inherited edOperDate: TcxDateEdit
      Left = 108
      Top = 20
      EditValue = 42767d
      Properties.AssignedValues.DisplayFormat = True
      ExplicitLeft = 108
      ExplicitTop = 20
    end
    inherited cxLabel2: TcxLabel
      Left = 108
      Top = 2
      ExplicitLeft = 108
      ExplicitTop = 2
    end
    inherited cxLabel15: TcxLabel
      Left = 232
      Top = 3
      ExplicitLeft = 232
      ExplicitTop = 3
    end
    inherited ceStatus: TcxButtonEdit
      Left = 232
      Top = 20
      ExplicitLeft = 232
      ExplicitTop = 20
      ExplicitWidth = 200
      ExplicitHeight = 22
      Width = 200
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 67
    Top = 272
  end
  inherited ActionList: TActionList
    Left = 215
    Top = 319
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end
        item
        end
        item
        end>
    end
    inherited actMISetErased: TdsdUpdateErased
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end
        item
        end>
    end
    inherited actMISetUnErased: TdsdUpdateErased
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end
        item
        end>
    end
    inherited actShowAll: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProcList = <
        item
        end>
      DataSets = <
        item
          UserName = 'frxDBDHeader'
        end
        item
          UserName = 'frxDBDMaster'
        end>
      ReportName = #1055#1088#1086#1076#1072#1078#1072
      ReportNameParam.Value = #1055#1088#1086#1076#1072#1078#1072
    end
    inherited actAddMask: TdsdExecStoredProc
      StoredProc = spInsertUpdateMIMaster
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1077#1082#1091#1097#1091#1102' '#1089#1090#1088#1086#1082#1091' '#1082' '#1072#1085#1072#1083#1080#1079#1091' '
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1077#1082#1091#1097#1091#1102' '#1089#1090#1088#1086#1082#1091' '#1082' '#1072#1085#1072#1083#1080#1079#1091' '
    end
    object mactLoadGoods: TMultiAction
      Category = 'LoadGoods'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_LoadGoods
        end
        item
          Action = actExecuteImportSettings_LoadGoods
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1090#1086#1074#1072#1088#1072'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1090#1086#1074#1072#1088#1099
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1090#1086#1074#1072#1088#1099
      ImageIndex = 27
    end
    object actGetImportSetting_LoadGoods: TdsdExecStoredProc
      Category = 'LoadGoods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting_LoadGoods
      StoredProcList = <
        item
          StoredProc = spGetImportSetting_LoadGoods
        end>
      Caption = 'actGetImportSetting_LoadGoods'
    end
    object actExecuteImportSettings_LoadGoods: TExecuteImportSettingsAction
      Category = 'LoadGoods'
      MoveParams = <>
      ImportSettingsId.Value = '0'
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId_LoadGoods'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
    end
    object actOpenChoiceCompetitor: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenChoiceCompetitor'
      FormName = 'TCompetitorForm'
      FormNameParam.Value = 'TCompetitorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'CompetitorId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actExecuteSummaDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteSummaDialog'
      FormName = 'TSummaDialogForm'
      FormNameParam.Value = 'TSummaDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Summa'
          Value = Null
          Component = FormParams
          ComponentItem = 'Price'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1062#1077#1085#1072' '#1082#1086#1085#1082#1091#1088#1077#1085#1090#1072
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actInsertUpdateMIMasterAdd: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIMasterAdd
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMasterAdd
        end>
      Caption = 'actInsertUpdateMIMasterAdd'
    end
    object mactInsertUpdateMIMasterAdd: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenChoiceCompetitor
        end
        item
          Action = actExecuteSummaDialog
        end
        item
          Action = actInsertUpdateMIMasterAdd
        end
        item
          Action = actRefresh
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1094#1077#1085#1091' '#1085#1086#1074#1086#1075#1086' '#1082#1086#1085#1082#1091#1088#1077#1085#1090#1072' '#1087#1086' '#1089#1090#1088#1086#1082#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1094#1077#1085#1091' '#1085#1086#1074#1086#1075#1086' '#1082#1086#1085#1082#1091#1088#1077#1085#1090#1072' '#1087#1086' '#1089#1090#1088#1086#1082#1077
      ImageIndex = 75
    end
    object MovementItemProtocolParentOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = CrossDBViewAddOn
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenCompetitor: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1082#1086#1085#1082#1091#1088#1077#1085#1090#1086#1074
      Hint = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1082#1086#1085#1082#1091#1088#1077#1085#1090#1086#1074
      ImageIndex = 24
      FormName = 'TCompetitorForm'
      FormNameParam.Value = 'TCompetitorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOpenPriceSubgroups: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1080#1072#1087#1072#1079#1086#1085#1099' '#1094#1077#1085' '#1076#1083#1103' '#1076#1077#1083#1077#1085#1080#1077' '#1087#1086' '#1087#1086#1076#1075#1088#1091#1087#1087#1072#1084
      Hint = #1044#1080#1072#1087#1072#1079#1086#1085#1099' '#1094#1077#1085' '#1076#1083#1103' '#1076#1077#1083#1077#1085#1080#1077' '#1087#1086' '#1087#1086#1076#1075#1088#1091#1087#1087#1072#1084
      ImageIndex = 25
      FormName = 'TPriceSubgroupsForm'
      FormNameParam.Value = 'TPriceSubgroupsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object mactUpdate_PriceAverage: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecuteDataChoiceDialog
        end
        item
          Action = actExecuteIntegerDialog
        end
        item
          Action = actExecUpdate_PriceAverage
        end
        item
          Action = actRefresh
        end>
      Caption = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1089#1088#1077#1076#1085#1102#1102' '#1094#1077#1085#1091
      Hint = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1089#1088#1077#1076#1085#1102#1102' '#1094#1077#1085#1091
      ImageIndex = 38
    end
    object actExecuteDataChoiceDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDataChoiceDialog'
      FormName = 'TDataChoiceDialogForm'
      FormNameParam.Value = 'TDataChoiceDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'OperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1041#1088#1072#1090#1100' '#1087#1088#1086#1076#1072#1078#1080' '#1076#1086' '#1076#1072#1090#1099' '#1074#1082#1083#1102#1095#1080#1090#1077#1083#1100#1085#1086
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actExecuteIntegerDialog: TExecuteDialog
      MoveParams = <>
      Caption = 'actExecuteIntegerDialog'
      FormName = 'TIntegerDialogForm'
      FormNameParam.Value = 'TIntegerDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Values'
          Value = Null
          Component = FormParams
          ComponentItem = 'Day'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1087#1088#1086#1076#1072#1078#1080
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actExecUpdate_PriceAverage: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_PriceAverage
      StoredProcList = <
        item
          StoredProc = spUpdate_PriceAverage
        end>
      Caption = 'actExecUpdate_PriceAverage'
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_CompetitorMarkups'
    DataSet = CompetitorCDS
    DataSets = <
      item
        DataSet = CompetitorCDS
      end
      item
        DataSet = MasterCDS
      end>
    OutputType = otMultiDataSet
  end
  inherited BarManager: TdxBarManager
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
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
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
          ItemName = 'bbRefresh'
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
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_PriceAverage'
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
          ItemName = 'dxBarButton6'
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
    inherited bbMovementItemProtocol: TdxBarButton
      UnclickAfterDoing = False
    end
    object bbactStartLoad: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 41
    end
    object dxBarButton1: TdxBarButton
      Caption = #1056#1072#1089#1095#1080#1090#1072#1090#1100' '#1079#1072#1088#1072#1073#1086#1090#1085#1091#1102' '#1087#1083#1072#1090#1091' '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
      Category = 0
      Hint = #1056#1072#1089#1095#1080#1090#1072#1090#1100' '#1079#1072#1088#1072#1073#1086#1090#1085#1091#1102' '#1087#1083#1072#1090#1091' '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
      Visible = ivAlways
      ImageIndex = 38
    end
    object dxBarButton2: TdxBarButton
      Caption = #1056#1072#1089#1095#1080#1090#1072#1090#1100' '#1079#1072#1088#1072#1073#1086#1090#1085#1091#1102' '#1087#1083#1072#1090#1091' '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084' ('#1088#1072#1089#1095#1077#1090' '#1087#1086' '#1076#1085#1103#1084')'
      Category = 0
      Hint = #1056#1072#1089#1095#1080#1090#1072#1090#1100' '#1079#1072#1088#1072#1073#1086#1090#1085#1091#1102' '#1087#1083#1072#1090#1091' '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084' ('#1088#1072#1089#1095#1077#1090' '#1087#1086' '#1076#1085#1103#1084')'
      Visible = ivAlways
      ImageIndex = 38
    end
    object bbReport_CalcMonthForm: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1088#1077#1077#1089#1090#1088#1072
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1088#1077#1077#1089#1090#1088#1072
      Visible = ivAlways
      ImageIndex = 3
    end
    object dxBarButton3: TdxBarButton
      Action = actAddMask
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = mactLoadGoods
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = mactInsertUpdateMIMasterAdd
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = MovementItemProtocolParentOpenForm
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1094#1077#1085'  '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = actOpenCompetitor
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = actOpenPriceSubgroups
      Category = 0
    end
    object bbUpdate_PriceAverage: TdxBarButton
      Action = mactUpdate_PriceAverage
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    View = nil
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 11
      end>
    SearchAsFilter = False
    Top = 369
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
        Name = 'CompetitorId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Price'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId_LoadGoods'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 312
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_CompetitorMarkups'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 176
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_CompetitorMarkups'
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
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
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
        Name = 'TotalSummPhone'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummSale'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummSaleNP'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'HoursWork'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateCalculation'
        Value = Null
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 224
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_CompetitorMarkups'
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
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 202
    Top = 248
  end
  inherited GuidesFiller: TGuidesFiller
    ActionItemList = <
      item
      end
      item
        Action = actInsertUpdateMovement
      end>
    Left = 288
    Top = 216
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edOperDate
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
    Top = 177
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 216
    Top = 376
  end
  inherited spErasedMIMaster: TdsdStoredProc
    Left = 414
    Top = 184
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Left = 654
    Top = 248
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_CompetitorMarkups'
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
        Name = 'inGoodsID'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCompetitorId'
        Value = Null
        Component = CrossDBViewAddOn
        ComponentItem = 'TypeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue'
        Value = Null
        Component = CrossDBViewAddOn
        ComponentItem = 'Value'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 320
    Top = 288
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 464
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_CompetitorMarkups_TotalSumm'
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
        Name = 'TotalCount'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalCount'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSumm'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPrimeCost'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSummPrimeCost'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 652
    Top = 196
  end
  object spCalculationAllDay: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_CompetitorMarkups_CalculationAllDay'
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
      end>
    PackSize = 1
    NeedResetData = True
    Left = 552
    Top = 256
  end
  object CompetitorCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 32
    Top = 376
  end
  object CrossDBViewAddOn: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    HeaderDataSet = CompetitorCDS
    HeaderColumnName = 'CompetitorName'
    TemplateColumn = Value
    Left = 464
    Top = 368
  end
  object spGetImportSetting_LoadGoods: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TCompetitorMarkupsForm;zc_Object_ImportSetting_CompetitorMarkups' +
          '_LoadGoods'
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
        ComponentItem = 'ImportSettingId_LoadGoods'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 328
  end
  object spInsertUpdateMIMasterAdd: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_CompetitorMarkups'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
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
        Name = 'inGoodsID'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCompetitorId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CompetitorId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 648
    Top = 392
  end
  object spUpdate_PriceAverage: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_PriceAverage'
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
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay'
        Value = Null
        Component = FormParams
        ComponentItem = 'inDay'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    Left = 544
    Top = 184
  end
end
