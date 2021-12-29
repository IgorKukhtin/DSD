inherited JuridicalSettingsForm: TJuridicalSettingsForm
  Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1102#1088' '#1083#1080#1094
  ClientHeight = 431
  ClientWidth = 916
  ExplicitWidth = 932
  ExplicitHeight = 470
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 916
    Height = 405
    ExplicitWidth = 916
    ExplicitHeight = 405
    ClientRectBottom = 405
    ClientRectRight = 916
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 916
      ExplicitHeight = 405
      inherited cxGrid: TcxGrid
        Width = 677
        Height = 405
        ExplicitWidth = 677
        ExplicitHeight = 405
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = JuridicalName
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Name: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MainJuridicalName: TcxGridDBColumn
            Caption = #1053#1072#1096#1077' '#1102#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'MainJuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 122
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 162
          end
          object ContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 158
          end
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 133
          end
          object AreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085
            DataBinding.FieldName = 'AreaName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 97
          end
          object isPriceClose: TcxGridDBColumn
            Caption = #1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' '#1076#1083#1103' '#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'isPriceClose'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' '#1076#1083#1103' '#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094#1077#1085#1082#1080
            Width = 115
          end
          object isPriceCloseOrder: TcxGridDBColumn
            Caption = #1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072
            DataBinding.FieldName = 'isPriceCloseOrder'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072
            Width = 108
          end
          object isBonusClose: TcxGridDBColumn
            Caption = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1073#1086#1085#1091#1089#1099
            DataBinding.FieldName = 'isBonusClose'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1073#1086#1085#1091#1089#1099
            Width = 92
          end
          object Bonus: TcxGridDBColumn
            Caption = #1041#1086#1085#1091#1089
            DataBinding.FieldName = 'Bonus'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object PriceLimit: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1076#1086
            DataBinding.FieldName = 'PriceLimit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' "'#1062#1077#1085#1072' '#1076#1086'"'
            Options.Editing = False
            Width = 70
          end
          object StartDate: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1089
            DataBinding.FieldName = 'StartDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 65
          end
          object EndDate: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1076#1086
            DataBinding.FieldName = 'EndDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object СonditionalPercent: TcxGridDBColumn
            Caption = #1044#1086#1087'. % '#1087#1086' '#1087#1088#1072#1081#1089#1091
            DataBinding.FieldName = 'ConditionalPercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1087'. '#1091#1089#1083#1086#1074#1080#1103' '#1087#1086' '#1087#1088#1072#1081#1089#1091', %'
            Width = 65
          end
          object isSite: TcxGridDBColumn
            Caption = #1044#1083#1103' '#1089#1072#1081#1090#1072
            DataBinding.FieldName = 'isSite'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object isBonusVirtual: TcxGridDBColumn
            Caption = #1042#1080#1088#1090'. '#1073#1086#1085#1091#1089
            DataBinding.FieldName = 'isBonusVirtual'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1088#1090#1091#1072#1083#1100#1085#1099#1081' '#1073#1086#1085#1091#1089
            Width = 51
          end
          object InsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object UpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object isErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 677
        Top = 0
        Width = 3
        Height = 405
        AlignSplitter = salRight
        AutoPosition = False
        PositionAfterOpen = 50
        Control = cxGrid1
      end
      object cxGrid1: TcxGrid
        Left = 680
        Top = 0
        Width = 236
        Height = 405
        Align = alRight
        PopupMenu = PopupMenu
        TabOrder = 2
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ItemDS
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
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object clPriceLimit_min: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089
            DataBinding.FieldName = 'PriceLimit_min'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Options.Editing = False
            Width = 50
          end
          object clPriceLimit: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1076#1086
            DataBinding.FieldName = 'PriceLimit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 87
          end
          object clisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            Options.Editing = False
            Width = 50
          end
          object clBonus: TcxGridDBColumn
            Caption = '% '#1073#1086#1085#1091#1089
            DataBinding.FieldName = 'Bonus'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderHint = '% '#1073#1086#1085#1091#1089#1080#1088#1086#1074#1072#1085#1080#1103
            Width = 64
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_JuridicalSettingsItem
        end>
    end
    object UpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'UpdateDataSet'
      DataSource = MasterDS
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object dsdSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object actLinkRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object spUpdateisPriceCloseOrderNo: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isPriceCloseOrder_No
      StoredProcList = <
        item
          StoredProc = spUpdate_isPriceCloseOrder_No
        end>
      Caption = #1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' ('#1079#1072#1082#1072#1079') - '#1053#1077#1090
      Hint = #1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' ('#1079#1072#1082#1072#1079') - '#1053#1077#1090
    end
    object spUpdateisPriceCloseOrderYes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isPriceCloseOrder_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_isPriceCloseOrder_Yes
        end>
      Caption = #1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' ('#1079#1072#1082#1072#1079') - '#1044#1072
      Hint = #1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' ('#1079#1072#1082#1072#1079') - '#1044#1072
    end
    object spUpdateisisPriceCloseNo: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isPriceClose_No
      StoredProcList = <
        item
          StoredProc = spUpdate_isPriceClose_No
        end>
      Caption = #1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' - '#1053#1077#1090
      Hint = #1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' - '#1053#1077#1090
    end
    object spUpdateisisPriceCloseYes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isPriceClose_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_isPriceClose_Yes
        end>
      Caption = #1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' - '#1044#1072
      Hint = #1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' - '#1044#1072
    end
    object macUpdateisPriceCloseOrderYes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateisPriceCloseOrderYes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' ('#1079#1072#1082#1072#1079') - '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' ('#1079#1072#1082#1072#1079') - '#1044#1072
      ImageIndex = 76
    end
    object macUpdateisPriceCloseOrder_No: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateisPriceCloseOrderNo
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1099#1084' '#1089#1090#1088#1086#1082#1072#1084' '#1055#1088#1072#1081#1089' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072' '#1079#1072#1082#1088#1099#1090' - '#1053#1077#1090'?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' ('#1079#1072#1082#1072#1079') - '#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' ('#1079#1072#1082#1072#1079') - '#1053#1077#1090
      ImageIndex = 77
    end
    object macUpdateisPriceCloseOrder_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateisPriceCloseOrderYes
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1099#1084' '#1089#1090#1088#1086#1082#1072#1084' '#1055#1088#1072#1081#1089' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072' '#1079#1072#1082#1088#1099#1090' - '#1044#1072'?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' ('#1079#1072#1082#1072#1079') - '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' ('#1079#1072#1082#1072#1079') - '#1044#1072
      ImageIndex = 76
    end
    object macUpdateisPriceCloseOrderNo: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateisPriceCloseOrderNo
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' ('#1079#1072#1082#1072#1079') - '#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' ('#1079#1072#1082#1072#1079') - '#1053#1077#1090
      ImageIndex = 77
    end
    object macUpdateisisPriceCloseNo: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateisisPriceCloseNo
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' ('#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094#1077#1085#1082#1072') - '#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' ('#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094#1077#1085#1082#1072') - '#1053#1077#1090
      ImageIndex = 58
    end
    object macUpdateisisPriceCloseYes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateisisPriceCloseYes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' ('#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094#1077#1085#1082#1072') - '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090' ('#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094#1077#1085#1082#1072') - '#1044#1072
      ImageIndex = 52
    end
    object dsdUpdateChild: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateItem
      StoredProcList = <
        item
          StoredProc = spInsertUpdateItem
        end
        item
          StoredProc = spSelect_JuridicalSettingsItem
        end>
      Caption = 'dsdUpdateChild'
      DataSource = ItemDS
    end
    object dsdSetErasedChild: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedChild
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedChild
        end
        item
          StoredProc = spSelect_JuridicalSettingsItem
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1101#1083#1077#1084#1077#1085#1090
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1101#1083#1077#1084#1077#1085#1090
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ItemDS
    end
    object dsdUnErasedChild: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedChild
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedChild
        end
        item
          StoredProc = spSelect_JuridicalSettingsItem
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ItemDS
    end
    object InsertRecord1: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView1
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1101#1083#1077#1084#1077#1085#1090
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1101#1083#1077#1084#1077#1085#1090
      ImageIndex = 0
    end
    object macUpdateisBonusClose_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateisBonusClose_Yes_list
        end
        item
          Action = actRefresh
        end>
      Caption = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1073#1086#1085#1091#1089#1099
      Hint = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1073#1086#1085#1091#1089#1099
      ImageIndex = 52
    end
    object macUpdateisBonusClose_Yes_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateisBonusClose_Yes
        end>
      View = cxGridDBTableView
      Caption = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1073#1086#1085#1091#1089#1099
      Hint = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1073#1086#1085#1091#1089#1099
      ImageIndex = 52
    end
    object macUpdateisBonusClose_No: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateisBonusClose_No_list
        end
        item
          Action = actRefresh
        end>
      Caption = #1059#1095#1080#1090#1099#1074#1072#1090#1100' '#1073#1086#1085#1091#1089#1099
      Hint = #1059#1095#1080#1090#1099#1074#1072#1090#1100' '#1073#1086#1085#1091#1089#1099
      ImageIndex = 58
    end
    object macUpdateisBonusClose_No_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateisBonusClose_No
        end>
      View = cxGridDBTableView
      Caption = #1059#1095#1080#1090#1099#1074#1072#1090#1100' '#1073#1086#1085#1091#1089#1099
      Hint = #1059#1095#1080#1090#1099#1074#1072#1090#1100' '#1073#1086#1085#1091#1089#1099
      ImageIndex = 58
    end
    object actUpdateisBonusClose_Yes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isBonusClose_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_isBonusClose_Yes
        end>
      Caption = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1073#1086#1085#1091#1089#1099
      Hint = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1073#1086#1085#1091#1089#1099
    end
    object actUpdateisBonusClose_No: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isBonusClose_No
      StoredProcList = <
        item
          StoredProc = spUpdate_isBonusClose_No
        end>
      Caption = #1059#1095#1080#1090#1099#1074#1072#1090#1100' '#1073#1086#1085#1091#1089#1099
      Hint = #1059#1095#1080#1090#1099#1074#1072#1090#1100' '#1073#1086#1085#1091#1089#1099
    end
    object actProtocolEraseOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1091#1076#1072#1083#1077#1085#1080#1081
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1091#1076#1072#1083#1077#1085#1080#1081
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractSettingsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 88
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_JuridicalSettings'
    Params = <
      item
        Name = 'inIsShowErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 64
  end
  inherited BarManager: TdxBarManager
    Left = 384
    Top = 72
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
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
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecord1'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedChild'
        end
        item
          Visible = True
          ItemName = 'bbUnErasedChild'
        end
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
          ItemName = 'bbUpdateisisPriceCloseYes'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisisPriceCloseNo'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisRePriceCloseYes'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisRePriceCloseNo'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisBonusClose_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisBonusClose_No'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpen'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
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
    object bbShowAll: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object bbSetErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
    end
    object bbSetUnErased: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
    end
    object bbProtocolOpen: TdxBarButton
      Action = actProtocolOpenForm
      Category = 0
    end
    object bbUpdateisisPriceCloseYes: TdxBarButton
      Action = macUpdateisisPriceCloseYes
      Category = 0
    end
    object bbUpdateisisPriceCloseNo: TdxBarButton
      Action = macUpdateisisPriceCloseNo
      Category = 0
    end
    object bbUpdateisRePriceCloseYes: TdxBarButton
      Action = macUpdateisPriceCloseOrder_Yes
      Category = 0
    end
    object bbUpdateisRePriceCloseNo: TdxBarButton
      Action = macUpdateisPriceCloseOrder_No
      Category = 0
    end
    object bbSetErasedChild: TdxBarButton
      Action = dsdSetErasedChild
      Category = 0
    end
    object bbUnErasedChild: TdxBarButton
      Action = dsdUnErasedChild
      Category = 0
    end
    object bbInsertRecord1: TdxBarButton
      Action = InsertRecord1
      Category = 0
    end
    object bbUpdateisBonusClose_Yes: TdxBarButton
      Action = macUpdateisBonusClose_Yes
      Category = 0
    end
    object bbUpdateisBonusClose_No: TdxBarButton
      Action = macUpdateisBonusClose_No
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actProtocolEraseOpenForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 208
    Top = 256
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_JuridicalSettings'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMainJuridicalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MainJuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisBonusVirtual'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isBonusVirtual'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPriceClose'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPriceClose'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPriceCloseOrder'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPriceCloseOrder'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSite'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSite'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisBonusClose'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isBonusClose'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBonus'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Bonus'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceLimit'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceLimit'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inConditionalPercent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ConditionalPercent'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InStartDate'
        Value = 'Null'
        Component = MasterCDS
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'EndDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 152
    Top = 152
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'lpInsertUpdate_Object_ContractSettings'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMainJuridicalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MainJuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAreaId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AreaId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 264
    Top = 152
  end
  object spUpdate_isPriceClose_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_JuridicalSettings_isPriceClose'
    DataSets = <>
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
        Name = 'inisPriceClose'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisPriceClose'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPriceClose'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 336
    Top = 203
  end
  object spUpdate_isPriceClose_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_JuridicalSettings_isPriceClose'
    DataSets = <>
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
        Name = 'inisPriceClose'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisPriceClose'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPriceClose'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 264
    Top = 203
  end
  object spUpdate_isPriceCloseOrder_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_JuridicalSettings_isPriceCloseOrder'
    DataSets = <>
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
        Name = 'inisPriceCloseOrder'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 123
  end
  object spUpdate_isPriceCloseOrder_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_JuridicalSettings_isPriceCloseOrder'
    DataSets = <>
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
        Name = 'inisPriceCloseOrder'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 312
    Top = 251
  end
  object spErasedUnErasedChild: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSet = ItemCDS
    DataSets = <
      item
        DataSet = ItemCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ItemCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 840
    Top = 216
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actLinkRefresh
    ComponentList = <
      item
        Component = MasterCDS
      end>
    Left = 480
    Top = 104
  end
  object ItemCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'JuridicalSettingsId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 800
    Top = 80
  end
  object ItemDS: TDataSource
    DataSet = ItemCDS
    Left = 864
    Top = 88
  end
  object spSelect_JuridicalSettingsItem: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_JuridicalSettingsItem'
    DataSet = ItemCDS
    DataSets = <
      item
        DataSet = ItemCDS
      end>
    Params = <
      item
        Name = 'inObjectId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 792
    Top = 152
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <
      item
      end
      item
      end>
    ActionItemList = <
      item
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 768
    Top = 248
  end
  object spInsertUpdateItem: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_JuridicalSettingsItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ItemCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalSettingsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBonus'
        Value = Null
        Component = ItemCDS
        ComponentItem = 'Bonus'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceLimit'
        Value = Null
        Component = ItemCDS
        ComponentItem = 'PriceLimit'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 720
    Top = 123
  end
  object spUpdate_isBonusClose_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_JuridicalSettings_isBonusClose'
    DataSets = <>
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
        Name = 'inisBonusClose'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 192
    Top = 339
  end
  object spUpdate_isBonusClose_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_JuridicalSettings_isBonusClose'
    DataSets = <>
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
        Name = 'inisBonusClose'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 304
    Top = 323
  end
end
