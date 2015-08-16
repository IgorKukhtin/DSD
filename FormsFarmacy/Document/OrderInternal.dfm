inherited OrderInternalForm: TOrderInternalForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1047#1072#1103#1074#1082#1072' '#1074#1085#1091#1090#1088#1077#1085#1085#1103#1103'>'
  ClientHeight = 532
  ClientWidth = 1229
  ExplicitLeft = -431
  ExplicitWidth = 1237
  ExplicitHeight = 559
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 75
    Width = 1229
    Height = 457
    ExplicitTop = 75
    ExplicitWidth = 1229
    ExplicitHeight = 457
    ClientRectBottom = 457
    ClientRectRight = 1229
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1229
      ExplicitHeight = 433
      inherited cxGrid: TcxGrid
        Width = 1229
        Height = 205
        ExplicitWidth = 1229
        ExplicitHeight = 205
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSumm
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSumm
            end>
          OptionsBehavior.IncSearch = True
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 43
          end
          object colName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 206
          end
          object clCalcAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1089' '#1082#1088#1072#1090#1085#1086#1089#1090#1100#1102
            DataBinding.FieldName = 'CalcAmount'
            Options.Editing = False
            Width = 87
          end
          object colAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            Options.IncSearch = False
            Width = 48
          end
          object colSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1079#1072#1082#1072#1079#1072
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 60
          end
          object colPartnerGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1091' '#1087#1088#1086#1076#1072#1074#1094#1072
            DataBinding.FieldName = 'PartnerGoodsCode'
            Width = 65
          end
          object colPartnerGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091' '#1087#1088#1086#1076#1072#1074#1094#1072
            DataBinding.FieldName = 'PartnerGoodsName'
            Options.Editing = False
            Width = 80
          end
          object clMakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            Width = 65
          end
          object coJuridicalName: TcxGridDBColumn
            Caption = #1070#1088' '#1083#1080#1094#1086' '#1087#1086#1089#1090'-'#1082
            DataBinding.FieldName = 'JuridicalName'
            Options.Editing = False
            Width = 77
          end
          object coPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            Options.Editing = False
            Width = 40
          end
          object coContractName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072' '#1087#1086#1089#1090'-'#1082#1072
            DataBinding.FieldName = 'ContractName'
            Visible = False
            Options.Editing = False
            Width = 60
          end
          object coSuperFinalPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089#1088#1072#1074#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'SuperFinalPrice'
            Visible = False
            Options.Editing = False
            Width = 60
          end
          object colisCalculated: TcxGridDBColumn
            Caption = #1040#1074#1090#1086
            DataBinding.FieldName = 'isCalculated'
            HeaderAlignmentHorz = taCenter
            Width = 43
          end
          object clPartionGoodsDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'PartionGoodsDate'
            Width = 75
          end
          object clPartionGoodsDateColor: TcxGridDBColumn
            DataBinding.FieldName = 'PartionGoodsDateColor'
            Visible = False
            VisibleForCustomization = False
          end
          object colMultiplicity: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'Multiplicity'
            Options.Editing = False
            Width = 78
          end
          object clMinimumLot: TcxGridDBColumn
            Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1086#1077' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'MinimumLot'
            Options.Editing = False
            Width = 88
          end
          object colComment: TcxGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'Comment'
            Width = 94
          end
          object colisTopColor: TcxGridDBColumn
            DataBinding.FieldName = 'isTopColor'
            Visible = False
            VisibleForCustomization = False
          end
          object colTop: TcxGridDBColumn
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'IsTop'
            Options.Editing = False
            Width = 48
          end
          object colRemainsInUnit: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'RemainsInUnit'
            HeaderHint = #1058#1077#1082#1091#1097#1080#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1080
            Width = 47
          end
          object colMCS: TcxGridDBColumn
            Caption = #1053#1058#1047
            DataBinding.FieldName = 'MCS'
            Width = 37
          end
          object colGoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074
            DataBinding.FieldName = 'GoodsGroupName'
            Options.Editing = False
            Width = 104
          end
          object colNDSKindName: TcxGridDBColumn
            Caption = #1057#1090#1072#1074#1082#1072' '#1053#1044#1057
            DataBinding.FieldName = 'NDSKindName'
            Options.Editing = False
            Width = 71
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 208
        Width = 1229
        Height = 225
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
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
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.IncSearch = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object colJuridicalName: TcxGridDBColumn
            Caption = #1070#1088' '#1083#1080#1094#1086' '#1087#1086#1089#1090'-'#1082
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 189
          end
          object colMakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            Width = 105
          end
          object colBonus: TcxGridDBColumn
            Caption = #1041#1086#1085#1091#1089
            DataBinding.FieldName = 'Bonus'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.## %; ; '
            Options.Editing = False
            Width = 59
          end
          object colContractName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072' '#1087#1086#1089#1090'-'#1082#1072
            DataBinding.FieldName = 'ContractName'
            Options.Editing = False
            Width = 109
          end
          object colDeferment: TcxGridDBColumn
            Caption = #1054#1090#1089#1088'.'
            DataBinding.FieldName = 'Deferment'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0; ; '
            Options.Editing = False
            Width = 54
          end
          object coCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            Options.Editing = False
            Width = 79
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 132
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            Options.Editing = False
            Width = 69
          end
          object colPercent: TcxGridDBColumn
            Caption = '% '#1079#1072' '#1086#1090#1089#1088'.'
            DataBinding.FieldName = 'Percent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.## %; ; '
            Options.Editing = False
            Width = 61
          end
          object colSuperFinalPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089#1088#1072#1074#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'SuperFinalPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            Options.Editing = False
            Width = 145
          end
          object colPartionGoodsDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'PartionGoodsDate'
            Width = 80
          end
          object colPartionGoodsDateColor: TcxGridDBColumn
            DataBinding.FieldName = 'PartionGoodsDateColor'
            Visible = False
            VisibleForCustomization = False
            IsCaptionAssigned = True
          end
          object colMinimumLot: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'MinimumLot'
            Width = 83
          end
          object colRemains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Remains'
            Width = 43
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 205
        Width = 1229
        Height = 3
        AlignSplitter = salBottom
        Control = cxGrid
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1229
    Height = 49
    ParentBackground = False
    TabOrder = 3
    ExplicitWidth = 1229
    ExplicitHeight = 49
    inherited edInvNumber: TcxTextEdit
      Left = 155
      Top = 22
      ExplicitLeft = 155
      ExplicitTop = 22
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 155
      Top = 4
      ExplicitLeft = 155
      ExplicitTop = 4
    end
    inherited edOperDate: TcxDateEdit
      Left = 238
      Top = 22
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 238
      ExplicitTop = 22
    end
    inherited cxLabel2: TcxLabel
      Left = 239
      Top = 4
      ExplicitLeft = 239
      ExplicitTop = 4
    end
    inherited cxLabel15: TcxLabel
      Left = 5
      Top = 4
      ExplicitLeft = 5
      ExplicitTop = 4
    end
    inherited ceStatus: TcxButtonEdit
      Left = 5
      Top = 22
      ExplicitLeft = 5
      ExplicitTop = 22
      ExplicitWidth = 142
      ExplicitHeight = 22
      Width = 142
    end
    object edUnit: TcxButtonEdit
      Left = 347
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 6
      Width = 270
    end
    object cxLabel4: TcxLabel
      Left = 347
      Top = 3
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object cxLabel3: TcxLabel
      Left = 624
      Top = 4
      Caption = #1042#1080#1076' '#1079#1072#1082#1072#1079#1072
    end
    object edOrderKind: TcxButtonEdit
      Left = 624
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 9
      Width = 137
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 155
    Top = 416
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = actAddMask
        Properties.Strings = (
          'CancelAction'
          'Caption'
          'Category'
          'Enabled'
          'Hint'
          'ImageIndex'
          'InfoAfterExecute'
          'MoveParams'
          'Name'
          'QuestionBeforeExecute'
          'SecondaryShortCuts'
          'ShortCut'
          'StoredProc'
          'StoredProcList'
          'TabSheet'
          'Tag')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    Left = 48
    Top = 120
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    object mactDeleteLinkGroup: TMultiAction [0]
      Category = 'DeleteLink'
      MoveParams = <>
      ActionList = <
        item
          Action = mactDeleteLinkDS
        end
        item
          Action = actRefresh
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100
      ImageIndex = 72
    end
    object mactDeleteLinkDS: TMultiAction [1]
      Category = 'DeleteLink'
      MoveParams = <>
      ActionList = <
        item
          Action = actDeleteLink
        end>
      DataSource = ChildDS
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100
      ImageIndex = 72
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end>
      RefreshOnTabSetChanges = True
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
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
        end>
      ReportName = 'PrintMovement_Sale2'
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = 'PrintMovement_Sale2'
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
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
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
    object actUpdatePrioritetPartner: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdatePrioritetPartner
      StoredProcList = <
        item
          StoredProc = spUpdatePrioritetPartner
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1086#1088#1080#1090#1077#1090#1085#1091#1102' '#1094#1077#1085#1091
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1086#1088#1080#1090#1077#1090#1085#1091#1102' '#1094#1077#1085#1091
      ImageIndex = 55
      ShortCut = 114
    end
    object actSetLinkGoodsForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1103#1079#1100
      ShortCut = 9
      FormName = 'TChoiceGoodsFromPriceListForm'
      FormNameParam.Value = 'TChoiceGoodsFromPriceListForm'
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
    object mactDeleteLink: TMultiAction
      Category = 'DeleteLink'
      MoveParams = <>
      ActionList = <
        item
          Action = actDeleteLink
        end
        item
          Action = actRefresh
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1074#1103#1079#1100
      ImageIndex = 72
    end
    object actDeleteLink: TdsdExecStoredProc
      Category = 'DeleteLink'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_Object_LinkGoodsByGoods
      StoredProcList = <
        item
          StoredProc = spDelete_Object_LinkGoodsByGoods
        end>
      Caption = 'actDeleteLink'
    end
  end
  inherited MasterDS: TDataSource
    Left = 16
    Top = 376
  end
  inherited MasterCDS: TClientDataSet
    Left = 72
    Top = 376
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_OrderInternal'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ChildCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
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
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddMask'
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrioritetPartner'
        end
        item
          Visible = True
          ItemName = 'bbSetGoodsLink'
        end
        item
          Visible = True
          ItemName = 'bbDeleteLink'
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
          ItemName = 'bbGridToExcel'
        end>
    end
    inherited bbPrint: TdxBarButton
      Visible = ivNever
    end
    object bbPrint_Bill: TdxBarButton [5]
      Caption = #1057#1095#1077#1090
      Category = 0
      Hint = #1057#1095#1077#1090
      Visible = ivAlways
      ImageIndex = 21
    end
    object bbPrintTax: TdxBarButton [6]
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbPrintTax_Client: TdxBarButton [7]
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Visible = ivAlways
      ImageIndex = 18
    end
    inherited bbAddMask: TdxBarButton
      Visible = ivNever
    end
    object bbTax: TdxBarButton
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Category = 0
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Visible = ivAlways
      ImageIndex = 41
    end
    object bbPrioritetPartner: TdxBarButton
      Action = actUpdatePrioritetPartner
      Category = 0
    end
    object bbSetGoodsLink: TdxBarButton
      Action = actSetLinkGoodsForm
      Category = 0
    end
    object bbDeleteLink: TdxBarButton
      Action = mactDeleteLink
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ValueColumn = colisTopColor
        ColorValueList = <>
      end
      item
        ColorColumn = clPartionGoodsDate
        ValueColumn = clPartionGoodsDateColor
        ColorValueList = <>
      end>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        DataSummaryItemIndex = 5
      end>
    SearchAsFilter = False
    Left = 478
    Top = 137
  end
  inherited PopupMenu: TPopupMenu
    Left = 40
    Top = 168
    object N3: TMenuItem [0]
      Action = mactDeleteLinkGroup
    end
    object N2: TMenuItem [1]
      Caption = '-'
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
      end
      item
        Name = 'ReportNameOrderInternal'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ReportNameOrderInternalTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ReportNameOrderInternalBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 264
    Top = 416
  end
  inherited StatusGuides: TdsdGuides
    Left = 80
    Top = 80
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_OrderInternal'
    Left = 128
    Top = 88
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderInternal'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'OrderKindId'
        Value = Null
        Component = GuidesOrderKind
        ComponentItem = 'Key'
      end
      item
        Name = 'OrderKindName'
        Value = Null
        Component = GuidesOrderKind
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_OrderInternal'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'OrderKindId'
        Value = ''
        Component = GuidesOrderKind
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
      end
      item
        Guides = GuidesUnit
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
        Control = edUnit
      end
      item
        Control = edOrderKind
      end>
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    FormName = 'OrderInternalJournalForm'
    DataSet = 'MasterCDS'
    Left = 121
    Top = 137
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderInternal_SetErased'
    Left = 710
    Top = 360
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderInternal_SetUnErased'
    Left = 710
    Top = 312
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_OrderInternal'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'ioPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inPartnerGoodsCode'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ioPartnerGoodsName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartnerGoodsName'
        DataType = ftString
        ParamType = ptInputOutput
      end
      item
        Name = 'ioJuridicalName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalName'
        DataType = ftString
        ParamType = ptInputOutput
      end
      item
        Name = 'ioContractName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractName'
        DataType = ftString
        ParamType = ptInputOutput
      end
      item
        Name = 'outSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summ'
        DataType = ftFloat
      end
      item
        Name = 'outCalcAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CalcAmount'
        DataType = ftFloat
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 420
    Top = 188
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
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
    StoredProcName = 'gpSelect_Movement_Sale_Print'
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
      end>
    PackSize = 1
    Left = 319
    Top = 208
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 336
    Top = 112
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 888
    Top = 184
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'MovementItemId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 944
    Top = 184
  end
  object DBViewChildAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <
      item
        ColorColumn = colPartionGoodsDate
        ValueColumn = colPartionGoodsDateColor
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        DataSummaryItemIndex = 5
      end>
    SearchAsFilter = False
    Left = 926
    Top = 145
  end
  object spUpdatePrioritetPartner: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_OrderInternal_PrioritetPartner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalName'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'JuridicalName'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
      end
      item
        Name = 'inContractName'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ContractName'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsCode'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsCode'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsName'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsName'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inSuperPrice'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'SuperFinalPrice'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalName'
        DataType = ftString
      end
      item
        Name = 'ContractName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractName'
        DataType = ftString
      end
      item
        Name = 'GoodsCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartnerGoodsCode'
        DataType = ftString
      end
      item
        Name = 'GoodsName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartnerGoodsName'
        DataType = ftString
      end
      item
        Name = 'SuperPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SuperFinalPrice'
        DataType = ftFloat
      end
      item
        Name = 'Price'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
      end>
    PackSize = 1
    Left = 944
    Top = 240
  end
  object spDelete_Object_LinkGoodsByGoods: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_LinkGoodsByGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 592
    Top = 144
  end
  object GuidesOrderKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edOrderKind
    FormNameParam.Value = 'TOrderKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TOrderKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesOrderKind
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesOrderKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 664
    Top = 40
  end
end
