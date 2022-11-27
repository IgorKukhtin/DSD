inherited SalePromoGoodsForm: TSalePromoGoodsForm
  Caption = #1054#1090#1087#1091#1089#1082' '#1072#1082#1094#1080#1086#1085#1085#1099#1093' '#1090#1086#1074#1072#1088#1086#1074
  ClientHeight = 658
  ClientWidth = 918
  AddOnFormData.AddOnFormRefresh.ParentList = 'Sale'
  ExplicitWidth = 934
  ExplicitHeight = 697
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 115
    Width = 918
    Height = 543
    ExplicitTop = 115
    ExplicitWidth = 918
    ExplicitHeight = 543
    ClientRectBottom = 543
    ClientRectRight = 918
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 918
      ExplicitHeight = 519
      inherited cxGrid: TcxGrid
        Width = 446
        Height = 519
        ExplicitWidth = 446
        ExplicitHeight = 519
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00; -,0.00; ;'
              Kind = skSum
            end>
          OptionsBehavior.IncSearch = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.ColumnAutoWidth = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object sgGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 64
          end
          object sgGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 262
          end
          object sqAmount: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 83
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 446
        Top = 0
        Width = 8
        Height = 519
        Touch.ParentTabletOptions = False
        Touch.TabletOptions = [toPressAndHold]
        AlignSplitter = salRight
        Control = Panel1
      end
      object Panel1: TPanel
        Left = 454
        Top = 0
        Width = 464
        Height = 519
        Align = alRight
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 2
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 464
          Height = 519
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel2'
          ShowCaption = False
          TabOrder = 0
          object cxGrid1: TcxGrid
            Left = 0
            Top = 288
            Width = 464
            Height = 231
            Align = alBottom
            PopupMenu = PopupMenu
            TabOrder = 0
            object cxGridDBTableView1: TcxGridDBTableView
              Navigator.Buttons.CustomButtons = <>
              DataController.DataSource = SignDS
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
                Width = 45
              end
              object chUnitCode: TcxGridDBColumn
                Caption = #1050#1086#1076
                DataBinding.FieldName = 'UnitCode'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 34
              end
              object chUnitName: TcxGridDBColumn
                Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1077#1089#1083#1080' '#1085#1077' '#1079#1072#1087#1086#1083#1085#1077#1085#1086' '#1090#1086' '#1074#1089#1077' '#1072#1087#1090#1077#1082#1080')'
                DataBinding.FieldName = 'UnitName'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 205
              end
              object chJuridicalName: TcxGridDBColumn
                Caption = #1070#1088'.'#1083#1080#1094#1086' ('#1072#1087#1090#1077#1082#1080')'
                DataBinding.FieldName = 'JuridicalName'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 97
              end
              object chRetailName: TcxGridDBColumn
                Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
                DataBinding.FieldName = 'RetailName'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 69
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
          object cxGrid2: TcxGrid
            Left = 0
            Top = 0
            Width = 464
            Height = 280
            Align = alClient
            PopupMenu = PopupMenu
            TabOrder = 1
            object cxGridDBTableView2: TcxGridDBTableView
              Navigator.Buttons.CustomButtons = <>
              DataController.DataSource = ChildDS
              DataController.Summary.DefaultGroupSummaryItems = <>
              DataController.Summary.FooterSummaryItems = <>
              DataController.Summary.SummaryGroups = <>
              OptionsBehavior.IncSearch = True
              OptionsData.Deleting = False
              OptionsData.DeletingConfirmation = False
              OptionsView.ColumnAutoWidth = True
              OptionsView.GroupByBox = False
              OptionsView.HeaderAutoHeight = True
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
              object MasterGoodsCode: TcxGridDBColumn
                Caption = #1050#1086#1076
                DataBinding.FieldName = 'GoodsCode'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 60
              end
              object MasterGoodsName: TcxGridDBColumn
                Caption = #1058#1086#1074#1072#1088' '#1072#1082#1094#1080#1086#1085#1085#1099#1081
                DataBinding.FieldName = 'GoodsName'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Options.Editing = False
                Width = 242
              end
              object MasterAmount: TcxGridDBColumn
                Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
                DataBinding.FieldName = 'Amount'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DecimalPlaces = 3
                Properties.DisplayFormat = ',0.000;-,0.000; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Width = 78
              end
              object MasterPrice: TcxGridDBColumn
                Caption = #1062#1077#1085#1072' (0 '#1087#1086' '#1087#1088#1072#1081#1089#1091')'
                DataBinding.FieldName = 'Price'
                PropertiesClassName = 'TcxCurrencyEditProperties'
                Properties.DisplayFormat = ',0.00;-,0.00; ;'
                HeaderAlignmentHorz = taCenter
                HeaderAlignmentVert = vaCenter
                Width = 74
              end
            end
            object cxGridLevel2: TcxGridLevel
              GridView = cxGridDBTableView2
            end
          end
          object cxSplitter2: TcxSplitter
            Left = 0
            Top = 280
            Width = 464
            Height = 8
            Touch.ParentTabletOptions = False
            Touch.TabletOptions = [toPressAndHold]
            AlignSplitter = salBottom
            Control = cxGrid1
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 918
    Height = 89
    TabOrder = 3
    ExplicitWidth = 918
    ExplicitHeight = 89
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
      Left = 225
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object edComment: TcxTextEdit
      Left = 225
      Top = 62
      Properties.ReadOnly = False
      TabOrder = 7
      Width = 300
    end
    object cxLabel10: TcxLabel
      Left = 642
      Top = 5
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1089#1086#1079#1076'.'
    end
    object edInsertName: TcxButtonEdit
      Left = 642
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 133
    end
    object cxLabel11: TcxLabel
      Left = 642
      Top = 45
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1082#1086#1088#1088'.'
    end
    object edUpdateName: TcxButtonEdit
      Left = 642
      Top = 62
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 133
    end
    object cxLabel13: TcxLabel
      Left = 787
      Top = 45
      Caption = #1044#1072#1090#1072' '#1082#1086#1088#1088'.'
    end
    object edUpdateDate: TcxDateEdit
      Left = 787
      Top = 62
      EditValue = 42485d
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 120
    end
    object edEndPromo: TcxDateEdit
      Left = 533
      Top = 23
      EditValue = 42485d
      TabOrder = 14
      Width = 100
    end
    object edStartPromo: TcxDateEdit
      Left = 425
      Top = 23
      EditValue = 42485d
      TabOrder = 15
      Width = 100
    end
    object edInsertdate: TcxDateEdit
      Left = 787
      Top = 23
      EditValue = 42485d
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 16
      Width = 120
    end
    object cxLabel12: TcxLabel
      Left = 783
      Top = 5
      Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076'.'
    end
    object cxLabel3: TcxLabel
      Left = 425
      Top = 6
      Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '#1072#1082#1094#1080#1080
    end
    object cxLabel6: TcxLabel
      Left = 533
      Top = 6
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085'. '#1072#1082#1094#1080#1080
    end
    object cxLabel19: TcxLabel
      Left = 225
      Top = 5
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100':'
    end
    object edRetail: TcxButtonEdit
      Left = 225
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 21
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1086#1088#1075#1086#1074#1091#1102' '#1089#1077#1090#1100'>'
      Width = 196
    end
    object cbAmountCheck: TcxCheckBox
      Left = 64
      Top = 42
      Caption = #1040#1082#1094#1080#1103' '#1086#1090' '#1089#1091#1084#1084#1099' '#1095#1077#1082#1072
      TabOrder = 22
      Width = 132
    end
    object ceAmountCheck: TcxCurrencyEdit
      Left = 533
      Top = 62
      Properties.DisplayFormat = ',0.00;-,0.00; ;'
      TabOrder = 23
      Width = 100
    end
    object cxLabel4: TcxLabel
      Left = 533
      Top = 45
      Caption = #1054#1090' '#1089#1091#1084#1084#1099' '#1095#1077#1082#1072
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
    object actRefreshSalePromoGoodsChild: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect_MovementItem_SalePromoGoodsChild
      StoredProcList = <
        item
          StoredProc = spSelect_MovementItem_SalePromoGoodsChild
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
    object actRefreshSalePromoGoodsGoods: TdsdDataSetRefresh [3]
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
    object actRefreshSalePromoGoodsSign: TdsdDataSetRefresh [4]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect_MovementItem_SalePromoGoodsSign
      StoredProcList = <
        item
          StoredProc = spSelect_MovementItem_SalePromoGoodsSign
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
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MovementItem_SalePromoGoodsSign
        end
        item
          StoredProc = spSelect_MovementItem_SalePromoGoodsChild
        end>
    end
    object actSetErasedSalePromoGoodsSign: TdsdUpdateErased [7]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMISign
      StoredProcList = <
        item
          StoredProc = spErasedMISign
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1088#1086#1094#1077#1085#1090' '#1089#1082#1080#1076#1082#1080'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1088#1086#1094#1077#1085#1090' '#1089#1082#1080#1076#1082#1080'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = SignDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actMISetErasedChild: TdsdUpdateErased [8]
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
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1070#1088'.'#1083#1080#1094#1086'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1070#1088'.'#1083#1080#1094#1086'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ChildDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actSetUnErasedSalePromoGoodsSign: TdsdUpdateErased [10]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpErasedMISign
      StoredProcList = <
        item
          StoredProc = spUpErasedMISign
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = SignDS
    end
    object actMISetUnErasedChild: TdsdUpdateErased [11]
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
      DataSource = ChildDS
    end
    inherited actShowErased: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MovementItem_SalePromoGoodsSign
        end>
    end
    inherited actShowAll: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MovementItem_SalePromoGoodsChild
        end
        item
          StoredProc = spSelect_MovementItem_SalePromoGoodsSign
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
    object actUpdateChildDS: TdsdUpdateDataSet [17]
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
      DataSource = ChildDS
    end
    object dsdUpdateSignDS: TdsdUpdateDataSet [18]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateSalePromoGoodsSign
      StoredProcList = <
        item
          StoredProc = spInsertUpdateSalePromoGoodsSign
        end>
      Caption = 'actUpdateSignDS'
      DataSource = SignDS
    end
    object actDoLoad: TExecuteImportSettingsAction [19]
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
          Component = ChildDCS
          ComponentItem = 'ObjectId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildDCS
          ComponentItem = 'ObjectName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescName'
          Value = Null
          Component = ChildDCS
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
    object actStartLoad: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingId
        end
        item
          Action = actInsertUpdate_MovementItem_Promo_Set_Zero
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1076#1072#1085#1085#1099#1093' '#1074' '#1090#1077#1082#1091#1097#1080#1081' '#1076#1086#1082#1091#1084#1077#1085#1090'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      ImageIndex = 41
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_SalePromoGoods'
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
          ItemName = 'bbSetErasedPromoPartner'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedPromoPartner'
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
      Action = actStartLoad
      Category = 0
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
      Action = actSetErasedSalePromoGoodsSign
      Category = 0
    end
    object bbSetUnErasedPromoPartner: TdxBarButton
      Action = actSetUnErasedSalePromoGoodsSign
      Category = 0
    end
    object bbInsertSalePromoGoodsSign: TdxBarButton
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
      Caption = #1057#1074#1103#1079#1072#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1089' '#1095#1077#1082#1086#1084
      Category = 0
      Hint = #1057#1074#1103#1079#1072#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' '#1089' '#1095#1077#1082#1086#1084
      Visible = ivAlways
      ImageIndex = 29
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
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099
      Category = 0
      Hint = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099
      Visible = ivAlways
      ImageIndex = 27
    end
    object dxBarButton6: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1086#1074' '#1076#1083#1103' '#1088#1072#1079#1076#1072#1095#1080' '#1087#1088#1086#1084#1086#1082#1086#1076#1086#1074
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1086#1074' '#1076#1083#1103' '#1088#1072#1079#1076#1072#1095#1080' '#1087#1088#1086#1084#1086#1082#1086#1076#1086#1074
      Visible = ivAlways
      ImageIndex = 29
    end
    object dxBarButton7: TdxBarButton
      Caption = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1096#1082#1072#1083#1099
      Category = 0
      Hint = #1057#1075#1077#1085#1077#1088#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1086#1084#1086' - '#1082#1086#1076#1099' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1096#1082#1072#1083#1099
      Visible = ivAlways
      ImageIndex = 54
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
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082' '#1087#1086#1075#1072#1096#1077#1085#1080#1103
      Category = 0
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1082' '#1087#1086#1075#1072#1096#1077#1085#1080#1103
      Visible = ivAlways
      ImageIndex = 1
      ShortCut = 115
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
        Value = 0.000000000000000000
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
    StoredProcName = 'gpUpdate_Status_SalePromoGoods'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_SalePromoGoods'
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
        Value = Null
        Component = edStartPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndPromo'
        Value = Null
        Component = edEndPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertId'
        Value = Null
        Component = GuidesInsert
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertName'
        Value = Null
        Component = GuidesInsert
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Insertdate'
        Value = Null
        Component = edInsertdate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateId'
        Value = Null
        Component = GuidesUpdate
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateName'
        Value = Null
        Component = GuidesUpdate
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UpdateDate'
        Value = Null
        Component = edUpdateDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAmountCheck'
        Value = Null
        Component = cbAmountCheck
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountCheck'
        Value = Null
        Component = ceAmountCheck
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 224
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_SalePromoGoods'
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
        Value = Null
        Component = edStartPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndPromo'
        Value = Null
        Component = edEndPromo
        DataType = ftDateTime
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
        Name = 'inisAmountCheck'
        Value = Null
        Component = cbAmountCheck
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountCheck'
        Value = Null
        Component = ceAmountCheck
        DataType = ftFloat
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
        Control = cbAmountCheck
      end
      item
        Control = ceAmountCheck
      end
      item
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
    Left = 550
    Top = 224
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Left = 654
    Top = 248
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_SalePromoGoods'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 128
    Top = 408
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 96
    Top = 488
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
  object ChildDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 576
    Top = 336
  end
  object ChildDS: TDataSource
    DataSet = ChildDCS
    Left = 632
    Top = 352
  end
  object spSelect_MovementItem_SalePromoGoodsChild: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_SalePromoGoodsChild'
    DataSet = ChildDCS
    DataSets = <
      item
        DataSet = ChildDCS
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
    Left = 552
    Top = 296
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
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
    Left = 190
    Top = 545
  end
  object spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_SalePromoGoodsChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ChildDCS
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
        Component = ChildDCS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ChildDCS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = ChildDCS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 824
    Top = 200
  end
  object spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpSetErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildDCS
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
        Component = ChildDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildDCS
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
    Left = 544
    Top = 576
  end
  object SignDS: TDataSource
    DataSet = SignDCS
    Left = 616
    Top = 576
  end
  object dsdDBViewAddOn2: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView2
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
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
  object spSelect_MovementItem_SalePromoGoodsSign: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_SalePromoGoodsSign'
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
        Name = 'inShowAll'
        Value = Null
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
    PackSize = 1
    Left = 552
    Top = 512
  end
  object spInsertUpdateSalePromoGoodsSign: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_SalePromoGoodsSign'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = SignDCS
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
        Component = SignDCS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsChecked'
        Value = Null
        Component = SignDCS
        ComponentItem = 'IsChecked'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 824
    Top = 544
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
    Left = 788
    Top = 480
  end
  object GuidesInsert: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInsertName
    Key = '0'
    FormNameParam.Value = 'TUserForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesInsert
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInsert
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 81178
        MultiSelectSeparator = ','
      end>
    Left = 706
    Top = 6
  end
  object GuidesUpdate: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUpdateName
    Key = '0'
    FormNameParam.Value = 'TUserForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesUpdate
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUpdate
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 81178
        MultiSelectSeparator = ','
      end>
    Left = 706
    Top = 46
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
    Left = 680
    Top = 448
  end
  object spSelectSalePromoGoodsInfo: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_SalePromoGoodsSecond'
    DataSets = <
      item
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
    Left = 376
    Top = 392
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
    ChartList = <>
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
    Left = 384
    Top = 32
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
end
