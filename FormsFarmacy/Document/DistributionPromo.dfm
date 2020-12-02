inherited DistributionPromoForm: TDistributionPromoForm
  Caption = #1056#1072#1079#1076#1072#1095#1072' '#1072#1082#1094#1080#1086#1085#1085#1099#1093' '#1084#1072#1090#1077#1088#1080#1072#1083#1086#1074
  ClientHeight = 658
  ClientWidth = 1004
  AddOnFormData.AddOnFormRefresh.ParentList = 'Sale'
  ExplicitWidth = 1020
  ExplicitHeight = 697
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 159
    Width = 1004
    Height = 499
    ExplicitTop = 159
    ExplicitWidth = 1004
    ExplicitHeight = 499
    ClientRectBottom = 499
    ClientRectRight = 1004
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1004
      ExplicitHeight = 475
      inherited cxGrid: TcxGrid
        Width = 1004
        Height = 257
        ExplicitWidth = 1004
        ExplicitHeight = 257
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.DataSource = SignDS
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0; -,0; ;'
              Kind = skSum
              Column = sqNumberRequests
            end
            item
              Format = ',0; -,0; ;'
              Kind = skSum
              Column = sgNumberIssued
            end>
          OptionsBehavior.IncSearch = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object sqUnitName: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082#1072
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 192
          end
          object sqJuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 156
          end
          object sqRetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 106
          end
          object sqNumberRequests: TcxGridDBColumn
            Caption = #1055#1088#1077#1076#1083#1072#1078#1077#1085#1080#1081
            DataBinding.FieldName = 'NumberRequests'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0; -,0; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 109
          end
          object sgNumberIssued: TcxGridDBColumn
            Caption = #1042#1099#1076#1072#1095
            DataBinding.FieldName = 'NumberIssued'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0; -,0; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1086#1084#1086' '#1082#1086#1076
            Options.Editing = False
            Width = 105
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 257
        Width = 1004
        Height = 8
        Touch.ParentTabletOptions = False
        Touch.TabletOptions = [toPressAndHold]
        AlignSplitter = salBottom
        Control = Panel1
      end
      object Panel1: TPanel
        Left = 0
        Top = 265
        Width = 1004
        Height = 210
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 2
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 535
          Height = 210
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel2'
          ShowCaption = False
          TabOrder = 0
          object cxGrid2: TcxGrid
            Left = 0
            Top = 0
            Width = 535
            Height = 202
            Align = alClient
            PopupMenu = PopupMenu
            TabOrder = 0
            object cxGridDBTableView2: TcxGridDBTableView
              Navigator.Buttons.CustomButtons = <>
              DataController.DataSource = MasterDS
              DataController.Summary.DefaultGroupSummaryItems = <>
              DataController.Summary.FooterSummaryItems = <>
              DataController.Summary.SummaryGroups = <>
              OptionsBehavior.IncSearch = True
              OptionsData.Deleting = False
              OptionsData.DeletingConfirmation = False
              OptionsView.ColumnAutoWidth = True
              OptionsView.GroupByBox = False
              Styles.Content = dmMain.cxContentStyle
              Styles.Inactive = dmMain.cxSelection
              Styles.Selection = dmMain.cxSelection
              Styles.Footer = dmMain.cxFooterStyle
              Styles.Header = dmMain.cxHeaderStyle
              Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
              object MasterErased: TcxGridDBColumn
                DataBinding.FieldName = 'isErased'
                Visible = False
              end
              object MasterIsChecked: TcxGridDBColumn
                Caption = #1054#1090#1084'.'
                DataBinding.FieldName = 'IsChecked'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Width = 56
              end
              object MasterGoodsGroupCode: TcxGridDBColumn
                Caption = #1050#1086#1076
                DataBinding.FieldName = 'GoodsGroupCode'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 67
              end
              object MasterGoodsGroupName: TcxGridDBColumn
                Caption = #1043#1088#1091#1087#1087#1099' '#1090#1086#1074#1072#1088#1086#1074
                DataBinding.FieldName = 'GoodsGroupName'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 326
              end
            end
            object cxGridLevel2: TcxGridLevel
              GridView = cxGridDBTableView2
            end
          end
          object cxSplitter2: TcxSplitter
            Left = 0
            Top = 202
            Width = 535
            Height = 8
            Touch.ParentTabletOptions = False
            Touch.TabletOptions = [toPressAndHold]
            AlignSplitter = salBottom
            Control = cxGrid1
          end
        end
        object Panel3: TPanel
          Left = 543
          Top = 0
          Width = 461
          Height = 210
          Align = alRight
          BevelOuter = bvNone
          Caption = 'Panel3'
          ShowCaption = False
          TabOrder = 1
          object cxGrid1: TcxGrid
            Left = 0
            Top = 0
            Width = 461
            Height = 210
            Align = alClient
            PopupMenu = PopupMenu
            TabOrder = 0
            object cxGridDBTableView1: TcxGridDBTableView
              Navigator.Buttons.CustomButtons = <>
              DataController.DataSource = DetailDS
              DataController.Filter.Options = [fcoCaseInsensitive]
              DataController.Summary.DefaultGroupSummaryItems = <>
              DataController.Summary.FooterSummaryItems = <>
              DataController.Summary.SummaryGroups = <>
              Images = dmMain.SortImageList
              OptionsBehavior.GoToNextCellOnEnter = True
              OptionsBehavior.IncSearch = True
              OptionsBehavior.FocusCellOnCycle = True
              OptionsCustomize.ColumnHiding = True
              OptionsCustomize.ColumnsQuickCustomization = True
              OptionsCustomize.DataRowSizing = True
              OptionsData.CancelOnExit = False
              OptionsData.Deleting = False
              OptionsData.DeletingConfirmation = False
              OptionsData.Inserting = False
              OptionsView.ColumnAutoWidth = True
              OptionsView.GroupByBox = False
              OptionsView.GroupSummaryLayout = gslAlignWithColumns
              OptionsView.HeaderAutoHeight = True
              OptionsView.Indicator = True
              Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
              object chIsChecked: TcxGridDBColumn
                Caption = #1054#1090#1084'.'
                DataBinding.FieldName = 'IsChecked'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                HeaderHint = #1054#1090#1084#1077#1095#1077#1085' '#1076#1072'/'#1085#1077#1090
                Width = 43
              end
              object chUnitCode: TcxGridDBColumn
                Caption = #1050#1086#1076
                DataBinding.FieldName = 'UnitCode'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 32
              end
              object chUnitName: TcxGridDBColumn
                Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
                DataBinding.FieldName = 'UnitName'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 197
              end
              object chJuridicalName: TcxGridDBColumn
                Caption = #1070#1088'.'#1083#1080#1094#1086' ('#1072#1087#1090#1077#1082#1080')'
                DataBinding.FieldName = 'JuridicalName'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 80
              end
              object chRetailName: TcxGridDBColumn
                Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
                DataBinding.FieldName = 'RetailName'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 99
              end
              object IsErased: TcxGridDBColumn
                Caption = #1059#1076#1072#1083#1077#1085
                DataBinding.FieldName = 'IsErased'
                Visible = False
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
        object cxSplitter3: TcxSplitter
          Left = 535
          Top = 0
          Width = 8
          Height = 210
          Touch.ParentTabletOptions = False
          Touch.TabletOptions = [toPressAndHold]
          AlignSplitter = salRight
          Control = Panel3
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1004
    Height = 133
    TabOrder = 3
    ExplicitWidth = 1004
    ExplicitHeight = 133
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 108
      EditValue = 43060d
      ExplicitLeft = 108
    end
    inherited cxLabel2: TcxLabel
      Left = 108
      ExplicitLeft = 108
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 62
      ExplicitTop = 62
      ExplicitWidth = 200
      ExplicitHeight = 22
      Width = 200
    end
    object cxLabel7: TcxLabel
      Left = 8
      Top = 83
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object edComment: TcxTextEdit
      Left = 8
      Top = 101
      Properties.ReadOnly = False
      TabOrder = 7
      Width = 196
    end
    object edEndPromo: TcxDateEdit
      Left = 332
      Top = 62
      EditValue = 42485d
      TabOrder = 8
      Width = 100
    end
    object edStartPromo: TcxDateEdit
      Left = 220
      Top = 62
      EditValue = 42485d
      TabOrder = 9
      Width = 100
    end
    object cxLabel3: TcxLabel
      Left = 220
      Top = 45
      Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '#1074#1099#1076
    end
    object cxLabel6: TcxLabel
      Left = 332
      Top = 45
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085'. '#1074#1099#1076'.'
    end
    object cxLabel19: TcxLabel
      Left = 225
      Top = 5
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100':'
    end
    object edRetail: TcxButtonEdit
      Left = 220
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 13
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1086#1088#1075#1086#1074#1091#1102' '#1089#1077#1090#1100'>'
      Width = 212
    end
    object cbisElectron: TcxCheckBox
      Left = 108
      Top = 43
      Caption = #1076#1083#1103' '#1057#1072#1081#1090#1072
      TabOrder = 14
      Width = 78
    end
    object edSummRepay: TcxCurrencyEdit
      Left = 332
      Top = 101
      Hint = #1055#1086#1075#1072#1096#1072#1090#1100' '#1086#1090' '#1089#1091#1084#1084#1099' '#1095#1077#1082#1072
      ParentShowHint = False
      Properties.DisplayFormat = ',0.00'
      Properties.ReadOnly = False
      ShowHint = True
      TabOrder = 15
      Width = 87
    end
    object cxLabel20: TcxLabel
      Left = 332
      Top = 83
      Hint = #1055#1086#1075#1072#1096#1072#1090#1100' '#1086#1090' '#1089#1091#1084#1084#1099' '#1095#1077#1082#1072
      Caption = #1054#1090' '#1089#1091#1084#1084#1099' '#1090#1086#1074#1072#1088#1072
      ParentShowHint = False
      ShowHint = True
    end
    object edAmount: TcxCurrencyEdit
      Left = 220
      Top = 101
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.ReadOnly = False
      TabOrder = 17
      Width = 87
    end
    object cxLabel14: TcxLabel
      Left = 220
      Top = 83
      Caption = #1054#1090' '#1082#1086#1083'-'#1074#1072' '#1090#1086#1074#1072#1088#1072
    end
    object edMessage: TcxMemo
      Left = 438
      Top = 23
      Lines.Strings = (
        'edMessage')
      TabOrder = 19
      Height = 99
      Width = 532
    end
    object cxLabel4: TcxLabel
      Left = 438
      Top = 5
      Caption = #1058#1077#1082#1089#1090' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
    end
  end
  inherited ActionList: TActionList
    Left = 207
    Top = 319
    object spUpdateSignIsCheckedNo: TdsdExecStoredProc [0]
      Category = 'Checked'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = #1054#1090#1084#1077#1090#1080#1090#1100' '#1053#1077#1090
      Hint = #1054#1090#1084#1077#1090#1080#1090#1100' '#1053#1077#1090
    end
    object actRefreshDistributionPromoChild: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect_MovementItem_DistributionPromoChild
      StoredProcList = <
        item
          StoredProc = spSelect_MovementItem_DistributionPromoChild
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object spUpdateSignIsCheckedYes: TdsdExecStoredProc [2]
      Category = 'Checked'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = #1054#1090#1084#1077#1090#1080#1090#1100' '#1044#1072
      Hint = #1054#1090#1084#1077#1090#1080#1090#1100' '#1044#1072
    end
    object actRefreshDistributionPromoGoods: TdsdDataSetRefresh [3]
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
      RefreshOnTabSetChanges = False
    end
    object actRefreshDistributionPromoSign: TdsdDataSetRefresh [4]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPromoDistributionPromoSign
      StoredProcList = <
        item
          StoredProc = spSelectPromoDistributionPromoSign
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelectPromoDistributionPromoSign
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MovementItem_DistributionPromoChild
        end>
    end
    object actMISetErasedChild: TdsdUpdateErased [7]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMIChild
      StoredProcList = <
        item
          StoredProc = spErasedMIChild
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = DetailDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actMISetUnErasedChild: TdsdUpdateErased [9]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErasedMIChild
      StoredProcList = <
        item
          StoredProc = spUnErasedMIChild
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DetailDS
    end
    inherited actShowErased: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectPromoDistributionPromoSign
        end>
    end
    inherited actShowAll: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MovementItem_DistributionPromoChild
        end>
    end
    object dsdUpdateSignDS: TdsdUpdateDataSet [14]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actUpdateSignDS'
      DataSource = SignDS
    end
    object actUpdateChildDS: TdsdUpdateDataSet [15]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = 'actUpdateChildDS'
      DataSource = DetailDS
    end
    object actDoLoad: TExecuteImportSettingsAction [16]
      Category = 'Load'
      MoveParams = <>
      ImportSettingsId.Value = '0'
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
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
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      ReportName = #1055#1088#1086#1076#1072#1078#1072
      ReportNameParam.Value = #1055#1088#1086#1076#1072#1078#1072
    end
    object JuridicalChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'JuridicalChoiceForm'
      FormName = 'TJuridical_Unit_ObjectForm'
      FormNameParam.Value = 'TJuridical_Unit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = DetailDCS
          ComponentItem = 'ObjectId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = DetailDCS
          ComponentItem = 'ObjectName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescName'
          Value = Null
          Component = DetailDCS
          ComponentItem = 'DescName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actInsertUpdate_MovementItem_Promo_Set_Zero: TdsdExecStoredProc
      Category = 'Load'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actInsertUpdate_MovementItem_Promo_Set_Zero'
    end
    object actGetImportSettingId: TdsdExecStoredProc
      Category = 'Load'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSettingId'
    end
    object actLinkWithChecks: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actChoiceDistributionPromoCheck
        end
        item
          Action = actExecDistributionPromoCheck
        end
        item
          Action = actRefresh
        end>
      Caption = #1057#1074#1103#1079#1072#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1089' '#1095#1077#1082#1086#1084
      Hint = #1057#1074#1103#1079#1072#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1089' '#1095#1077#1082#1086#1084
      ImageIndex = 29
    end
    object actChoiceDistributionPromoCheck: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceDistributionPromoCheck'
      FormName = 'TChoiceDistributionPromoCheckForm'
      FormNameParam.Value = 'TChoiceDistributionPromoCheckForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitID'
          Value = ''
          Component = SignDCS
          ComponentItem = 'UnitID'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 'NULL'
          Component = SignDCS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartSummCash'
          Value = Null
          DataType = ftFloat
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId'
          Value = Null
          Component = SignDCS
          ComponentItem = 'ID_Check'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'CheckID'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actExecDistributionPromoCheck: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actExecDistributionPromoCheck'
    end
    object actInsertPromoCode: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecuteDialogPromoCode
        end
        item
          Action = actExecSPInsertPromoCode
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099'?'
      InfoAfterExecute = #1055#1088#1086#1084#1086' - '#1082#1086#1076#1099' '#1089#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1085#1099
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099
      Hint = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099
      ImageIndex = 27
    end
    object actExecSPInsertPromoCode: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      StoredProcList = <
        item
        end>
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076#1099
      Hint = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076#1099
    end
    object actExecuteDialogPromoCode: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076
      Hint = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076
      FormName = 'TIntegerDialogForm'
      FormNameParam.Value = 'TIntegerDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Values'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Count'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076#1086#1074
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actPrintSticker: TdsdExportToXLS
      Category = 'DSDLibExport'
      MoveParams = <>
      BeforeAction = ExecSPPrintSticker
      ItemsDataSet = PrintItemsCDS
      FileName = 'PrintSticker'
      FileNameParam.Value = 'PrintSticker'
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      TitleHeight = 1.000000000000000000
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Tahoma'
      HeaderFont.Style = []
      Footer = False
      ColumnParams = <
        item
          FieldName = 'Column1'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 25
          WrapText = True
          CalcColumnLists = <>
          DetailedTexts = <
            item
              FieldName = 'GUID1'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
            end
            item
              FieldName = 'SITE1'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
            end>
        end
        item
          FieldName = 'Column2'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 25
          WrapText = True
          CalcColumnLists = <>
          DetailedTexts = <
            item
              FieldName = 'GUID2'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
            end
            item
              FieldName = 'SITE2'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
            end>
        end
        item
          FieldName = 'Column3'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 25
          WrapText = True
          CalcColumnLists = <>
          DetailedTexts = <
            item
              FieldName = 'GUID3'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
            end
            item
              FieldName = 'SITE3'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
            end>
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1086#1074' '#1076#1083#1103' '#1088#1072#1079#1076#1072#1095#1080' '#1087#1088#1086#1084#1086#1082#1086#1076#1086#1074
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1086#1074' '#1076#1083#1103' '#1088#1072#1079#1076#1072#1095#1080' '#1087#1088#1086#1084#1086#1082#1086#1076#1086#1074
      ImageIndex = 29
    end
    object ExecSPPrintSticker: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = ExecutePromoCodeSignUnitName
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'ExecSPPrintSticker'
    end
    object ExecutePromoCodeSignUnitName: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'ExecutePromoCodeSignUnitName'
      FormName = 'TPromoCodeSignUnitNameDialogForm'
      FormNameParam.Value = 'TPromoCodeSignUnitNameDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitName'
          Value = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1085#1072' '#1089#1072#1081#1090#1077
          Component = FormParams
          ComponentItem = 'UnitName'
          DataType = ftWideString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actInsertPromoCodeScales: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecuteDialogPromoCodeScales
        end
        item
          Action = actExecSPInsertPromoCodeScales
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099'  '#1089#1086#1075#1083#1072#1089#1085#1086' '#1096#1082#1072#1083#1099'?'
      InfoAfterExecute = #1055#1088#1086#1084#1086' - '#1082#1086#1076#1099' '#1089#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1085#1099
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1096#1082#1072#1083#1099
      Hint = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1096#1082#1072#1083#1099
      ImageIndex = 54
    end
    object actExecSPInsertPromoCodeScales: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      StoredProcList = <
        item
        end>
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076#1099
      Hint = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076#1099
    end
    object actExecuteDialogPromoCodeScales: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076
      Hint = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' '#1082#1086#1076
      FormName = 'TPromoCodeSignDialogForm'
      FormNameParam.Value = 'TPromoCodeSignDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inCount_GUID'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Count'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actOpenCheckSale: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TCheckForm'
      FormNameParam.Value = 'TCheckForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = SignDCS
          ComponentItem = 'ID_CheckSale'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 42370d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      CheckIDRecords = True
      ActionType = acUpdate
      DataSource = SignDS
      DataSetRefresh = actRefresh
      IdFieldName = 'ID_CheckSale'
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_DistributionPromo'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMISetErasedChild'
        end
        item
          Visible = True
          ItemName = 'bbMISetUnErasedChild'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenCheckSale'
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
          ItemName = 'dxBarStatic'
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
    inherited bbMovementItemProtocol: TdxBarButton
      UnclickAfterDoing = False
    end
    object bbMISetErasedChild: TdxBarButton
      Action = actMISetErasedChild
      Category = 0
    end
    object bbMISetUnErasedChild: TdxBarButton
      Action = actMISetUnErasedChild
      Category = 0
    end
    object bbactStartLoad: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 41
    end
    object bbInsertRecordChild: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' /'#1070#1088'. '#1083#1080#1094#1086'>'
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' /'#1070#1088'. '#1083#1080#1094#1086'>'
      Visible = ivAlways
      ImageIndex = 0
    end
    object bbOpenReportForm: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1094#1077#1085#1072#1084' '#1087#1088#1080#1093#1086#1076#1072'>'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' <'#1055#1086' '#1094#1077#1085#1072#1084' '#1087#1088#1080#1093#1086#1076#1072' '#1090#1086#1074#1072#1088#1086#1074' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072'>'
      Visible = ivAlways
      ImageIndex = 25
    end
    object bbInsertRecordPartner: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1088#1086#1094#1077#1085#1090' '#1089#1082#1080#1076#1082#1080'>'
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1088#1086#1094#1077#1085#1090' '#1089#1082#1080#1076#1082#1080'>'
      Visible = ivAlways
      ImageIndex = 0
    end
    object bbSetErasedPromoPartner: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1088#1086#1094#1077#1085#1090' '#1089#1082#1080#1076#1082#1080'>'
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1088#1086#1094#1077#1085#1090' '#1089#1082#1080#1076#1082#1080'>'
      Visible = ivAlways
      ImageIndex = 2
      ShortCut = 46
    end
    object bbSetUnErasedPromoPartner: TdxBarButton
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 8
      ShortCut = 46
    end
    object bbInsertDistributionPromoSign: TdxBarButton
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099
      Category = 0
      Hint = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099
      Visible = ivAlways
      ImageIndex = 27
    end
    object bbReportMinPriceForm: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' <'#1052#1080#1085'. '#1094#1077#1085#1072' '#1076#1080#1089#1090#1088#1080#1073#1100#1102#1090#1077#1088#1072' ('#1084#1072#1088#1082#1077#1090#1080#1085#1075')>'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' <'#1052#1080#1085'. '#1094#1077#1085#1072' '#1076#1080#1089#1090#1088#1080#1073#1100#1102#1090#1077#1088#1072' ('#1084#1072#1088#1082#1077#1090#1080#1085#1075')>'
      Visible = ivAlways
      ImageIndex = 26
    end
    object bbOpenReportMinPrice_All: TdxBarButton
      Caption = #1048#1090#1086#1075#1080' '#1087#1086' '#1076#1085#1103#1084' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1083#1086#1103#1083#1100#1085#1086#1095#1090#1080
      Category = 0
      Hint = #1048#1090#1086#1075#1080' '#1087#1086' '#1076#1085#1103#1084' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1083#1086#1103#1083#1100#1085#1086#1095#1090#1080
      Visible = ivAlways
      ImageIndex = 24
    end
    object bbGoodsIsCheckedYes: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      Visible = ivAlways
      ImageIndex = 76
    end
    object bbGoodsIsCheckedNo: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      Visible = ivAlways
      ImageIndex = 77
    end
    object bbChildIsCheckedNo: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      Visible = ivAlways
      ImageIndex = 77
    end
    object bbChildIsCheckedYes: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      Visible = ivAlways
      ImageIndex = 76
    end
    object bbSignIsCheckedNo: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1053#1077#1090
      Visible = ivAlways
      ImageIndex = 77
    end
    object bbSignIsCheckedYes: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1084#1077#1095#1077#1085' - '#1044#1072
      Visible = ivAlways
      ImageIndex = 76
    end
    object dxBarButton1: TdxBarButton
      Action = actLinkWithChecks
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Caption = #1054#1090#1095#1105#1090' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1085#1099#1077' '#1087#1088#1086#1084#1086#1082#1086#1076#1099
      Category = 0
      Hint = #1054#1090#1095#1105#1090' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1085#1099#1077' '#1087#1088#1086#1084#1086#1082#1086#1076#1099
      Visible = ivAlways
      ImageIndex = 26
    end
    object dxBarButton3: TdxBarButton
      Caption = #1054#1090#1095#1105#1090' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1085#1099#1077' '#1087#1088#1086#1084#1086#1082#1086#1076#1099
      Category = 0
      Hint = #1054#1090#1095#1105#1090' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1085#1099#1077' '#1087#1088#1086#1084#1086#1082#1086#1076#1099
      Visible = ivAlways
      ImageIndex = 25
    end
    object dxBarButton4: TdxBarButton
      Caption = #1054#1090#1082#1088#1077#1087#1080#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1086#1090' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
      Category = 0
      Hint = #1054#1090#1082#1088#1077#1087#1080#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1086#1090' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
      Visible = ivAlways
      ImageIndex = 52
    end
    object dxBarButton5: TdxBarButton
      Caption = #1054#1090#1082#1088#1077#1087#1080#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1086#1090' '#1095#1077#1082#1072' '#1087#1086#1075#1072#1096#1077#1085#1080#1103
      Category = 0
      Hint = #1054#1090#1082#1088#1077#1087#1080#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1086#1090' '#1095#1077#1082#1072' '#1087#1086#1075#1072#1096#1077#1085#1080#1103
      Visible = ivAlways
      ImageIndex = 76
    end
    object bbInsertPromoCode: TdxBarButton
      Action = actInsertPromoCode
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actPrintSticker
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = actInsertPromoCodeScales
      Category = 0
    end
    object bbOpenCheckCreate: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082' '#1089#1086#1079#1076#1072#1085#1080#1103
      Category = 0
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082' '#1089#1086#1079#1076#1072#1085#1080#1103
      Visible = ivAlways
      ImageIndex = 1
      ShortCut = 115
    end
    object bbOpenCheckSale: TdxBarButton
      Action = actOpenCheckSale
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 10
      end>
    SearchAsFilter = False
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
        Name = 'TotalCount'
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
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'CheckID'
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate'
        Value = 42370d
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 42400d
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentUsed'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Count'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount'
        Value = '0'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1085#1072' '#1089#1072#1081#1090#1077
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 312
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_DistributionPromo'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_DistributionPromo'
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
        Value = 'NULL'
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
        Name = 'RetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailName'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartPromo'
        Value = 'NULL'
        Component = edStartPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndPromo'
        Value = 'NULL'
        Component = edEndPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount'
        Value = Null
        Component = edAmount
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummRepay'
        Value = Null
        Component = edSummRepay
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Message'
        Value = Null
        Component = edMessage
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Insertdate'
        Value = 'NULL'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateDate'
        Value = 'NULL'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 224
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_DistributionPromo'
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
        Value = 42132d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailID'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartPromo'
        Value = 'NULL'
        Component = edStartPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndPromo'
        Value = 'NULL'
        Component = edEndPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = edAmount
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummRepay'
        Value = Null
        Component = edSummRepay
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMessage'
        Value = Null
        Component = edMessage
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 202
    Top = 248
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
      end
      item
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end
      item
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
        Control = edComment
      end
      item
      end
      item
      end
      item
        Control = edStartPromo
      end
      item
        Control = edEndPromo
      end
      item
      end
      item
      end
      item
        Control = cbisElectron
      end
      item
      end
      item
      end>
    Left = 224
    Top = 177
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 120
    Top = 320
  end
  inherited spErasedMIMaster: TdsdStoredProc
    Params = <
      item
        Name = 'inMovementItemId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 550
    Top = 224
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Params = <
      item
        Name = 'inMovementItemId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 654
    Top = 248
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_DistributionPromo'
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
        Name = 'inGoodsGroupId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsGroupId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsChecked'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IsChecked'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 360
    Top = 488
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 872
    Top = 280
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Sale_TotalSumm'
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
    Left = 628
    Top = 172
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 396
    Top = 302
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 396
    Top = 249
  end
  object DetailDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 32
    Top = 392
  end
  object DetailDS: TDataSource
    DataSet = DetailDCS
    Left = 88
    Top = 408
  end
  object spSelect_MovementItem_DistributionPromoChild: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_DistributionPromoChild'
    DataSet = DetailDCS
    DataSets = <
      item
        DataSet = DetailDCS
      end>
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
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 512
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = 0.000000000000000000
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = -1
      end>
    ShowFieldImageList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 238
    Top = 497
  end
  object spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_DistributionPromoChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = DetailDCS
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
        Name = 'inUnitId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsChecked'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'IsChecked'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 640
    Top = 576
  end
  object spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpSetErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 822
    Top = 384
  end
  object spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpSetUnErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 734
    Top = 384
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
        Value = 'TPromoForm;zc_Object_ImportSetting_Promo'
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
    Left = 736
    Top = 216
  end
  object SignDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 40
    Top = 488
  end
  object SignDS: TDataSource
    DataSet = SignDCS
    Left = 96
    Top = 488
  end
  object dsdDBViewAddOn2: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView2
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = 0.000000000000000000
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = -1
      end>
    ShowFieldImageList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 758
    Top = 273
  end
  object spSelectPromoDistributionPromoSign: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_DistributionPromoSign'
    DataSet = SignDCS
    DataSets = <
      item
        DataSet = SignDCS
      end>
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
      end>
    PackSize = 1
    Left = 104
    Top = 552
  end
  object spUpErasedMISign: TdsdStoredProc
    StoredProcName = 'gpSetUnErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = SignDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = SignDCS
        ComponentItem = 'IsErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 676
    Top = 440
  end
  object spErasedMISign: TdsdStoredProc
    StoredProcName = 'gpSetErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = SignDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = SignDCS
        ComponentItem = 'IsErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 616
    Top = 432
  end
  object spSelectPrintDistributionPromoDay: TdsdStoredProc
    StoredProcName = 'gpReport_MovementItem_DistributionPromoSecondDay'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
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
    Left = 831
    Top = 208
  end
  object PrintTitleCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 396
    Top = 201
  end
  object dsdDBViewAddOn3: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    OnDblClickActionList = <>
    ActionItemList = <>
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'PercentUsed'
        Param.DataType = ftFloat
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 544
    Top = 304
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
    Left = 264
    Top = 16
  end
  object spUnhook_Movement: TdsdStoredProc
    StoredProcName = 'gpUnhook_Movement_DistributionPromo_CheckSale'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = SignDCS
        ComponentItem = 'ID_CheckSale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 632
    Top = 360
  end
end
