inherited EDIJournalForm: TEDIJournalForm
  Caption = 'EDI '#1078#1091#1088#1085#1072#1083
  ClientHeight = 424
  ClientWidth = 834
  AddOnFormData.OnLoadAction = actSetDefaults
  ExplicitWidth = 842
  ExplicitHeight = 451
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 57
    Width = 834
    Height = 367
    ExplicitTop = 57
    ExplicitWidth = 834
    ExplicitHeight = 367
    ClientRectBottom = 367
    ClientRectRight = 834
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 834
      ExplicitHeight = 367
      inherited cxGrid: TcxGrid
        Width = 834
        Height = 209
        Align = alTop
        ExplicitWidth = 834
        ExplicitHeight = 209
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsView.GroupByBox = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colIsOrder: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colIsSale: TcxGridDBColumn
            Caption = #1056#1077#1072#1083#1080#1079
            DataBinding.FieldName = 'isSaleLink'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
          end
          object colIsTax: TcxGridDBColumn
            Caption = #1053#1072#1083#1086#1075
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 49
          end
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1079#1072#1082#1072#1079#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object colInvNumber: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1079#1072#1082#1072#1079#1072
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object colSaleOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'SaleOperDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object colSaleInvNumber: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'SaleInvNumber'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object colGLNPlaceCode: TcxGridDBColumn
            Caption = 'GLN '#1090#1086#1095#1082#1080' '#1076#1086#1089#1090#1072#1074#1082#1080
            DataBinding.FieldName = 'GLNPlaceCode'
            Width = 80
          end
          object colPartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object colOKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object colGLNCode: TcxGridDBColumn
            Caption = 'GLN '#1050#1086#1076
            DataBinding.FieldName = 'GLNCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colLoadJuridicalName: TcxGridDBColumn
            Caption = #1047#1072#1075#1088'. '#1070#1088' '#1083#1080#1094#1086
            DataBinding.FieldName = 'LoadJuridicalName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
        end
      end
      object Splitter: TcxSplitter
        Left = 0
        Top = 209
        Width = 834
        Height = 3
        AlignSplitter = salTop
        Control = cxGrid
      end
      object BottomPanel: TPanel
        Left = 0
        Top = 212
        Width = 834
        Height = 155
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        object cxChildGrid: TcxGrid
          Left = 0
          Top = 0
          Width = 601
          Height = 155
          Align = alLeft
          PopupMenu = PopupMenu
          TabOrder = 0
          object cxChildGridDBTableView: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = ClientDS
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <
              item
                Format = ',0.00'
                Kind = skSum
                Column = colSummPartner
              end>
            DataController.Summary.SummaryGroups = <>
            Images = dmMain.SortImageList
            OptionsBehavior.GoToNextCellOnEnter = True
            OptionsBehavior.FocusCellOnCycle = True
            OptionsCustomize.ColumnHiding = True
            OptionsCustomize.ColumnsQuickCustomization = True
            OptionsCustomize.DataRowSizing = True
            OptionsData.CancelOnExit = False
            OptionsData.Inserting = False
            OptionsView.ColumnAutoWidth = True
            OptionsView.Footer = True
            OptionsView.GroupByBox = False
            OptionsView.GroupSummaryLayout = gslAlignWithColumns
            OptionsView.HeaderAutoHeight = True
            OptionsView.Indicator = True
            Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
            object colGoodsGLNCode: TcxGridDBColumn
              Caption = 'GLN '#1082#1086#1076
              DataBinding.FieldName = 'GLNCode'
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 78
            end
            object colEDIGoodsName: TcxGridDBColumn
              Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' '#1080#1079' EDI'
              DataBinding.FieldName = 'EDIGoodsName'
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 77
            end
            object colGoodsCode: TcxGridDBColumn
              Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
              DataBinding.FieldName = 'GoodsCode'
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 78
            end
            object colGoodsName: TcxGridDBColumn
              Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
              DataBinding.FieldName = 'GoodsName'
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 78
            end
            object colGoodsKind: TcxGridDBColumn
              Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
              DataBinding.FieldName = 'GoodsKindName'
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 76
            end
            object colAmountOrder: TcxGridDBColumn
              Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1079#1072#1082#1072#1079#1072
              DataBinding.FieldName = 'AmountOrder'
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 78
            end
            object colAmountPartner: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1082'-'#1083#1103
              DataBinding.FieldName = 'AmountPartner'
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 51
            end
            object colPricePartner: TcxGridDBColumn
              Caption = #1062#1077#1085#1072' '#1087#1086#1082'-'#1083#1103
              DataBinding.FieldName = 'PricePartner'
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 61
            end
            object colSummPartner: TcxGridDBColumn
              Caption = #1057#1091#1084#1084#1072' '#1087#1086#1082'-'#1083#1103
              DataBinding.FieldName = 'SummPartner'
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 66
            end
          end
          object cxGridLevel1: TcxGridLevel
            GridView = cxChildGridDBTableView
          end
        end
        object cxProtocolGrid: TcxGrid
          Left = 604
          Top = 0
          Width = 230
          Height = 155
          Align = alClient
          PopupMenu = PopupMenu
          TabOrder = 1
          object cxProtocolGridView: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = ProtocolDS
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <
              item
                Format = ',0.00'
                Kind = skSum
              end>
            DataController.Summary.SummaryGroups = <>
            Images = dmMain.SortImageList
            OptionsBehavior.GoToNextCellOnEnter = True
            OptionsBehavior.FocusCellOnCycle = True
            OptionsCustomize.ColumnHiding = True
            OptionsCustomize.ColumnsQuickCustomization = True
            OptionsCustomize.DataRowSizing = True
            OptionsData.CancelOnExit = False
            OptionsData.Inserting = False
            OptionsView.ColumnAutoWidth = True
            OptionsView.Footer = True
            OptionsView.GroupByBox = False
            OptionsView.GroupSummaryLayout = gslAlignWithColumns
            OptionsView.HeaderAutoHeight = True
            OptionsView.Indicator = True
            Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
            object colProtocolOperDate: TcxGridDBColumn
              Caption = #1044#1072#1090#1072
              DataBinding.FieldName = 'OperDate'
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 60
            end
            object colProtocolText: TcxGridDBColumn
              Caption = #1054#1087#1080#1089#1072#1085#1080#1077
              DataBinding.FieldName = 'ProtocolText'
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 60
            end
            object colProtocolUserName: TcxGridDBColumn
              Caption = #1055#1086#1083'-'#1083#1100
              DataBinding.FieldName = 'UserName'
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 60
            end
          end
          object cxGridProtocolLevel: TcxGridLevel
            GridView = cxProtocolGridView
          end
        end
        object cxVerticalSplitter: TcxSplitter
          Left = 601
          Top = 0
          Width = 3
          Height = 155
          Control = cxChildGrid
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 834
    Height = 31
    Align = alTop
    TabOrder = 5
    object deStart: TcxDateEdit
      Left = 107
      Top = 5
      EditValue = 41640d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 310
      Top = 5
      EditValue = 41640d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 10
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel2: TcxLabel
      Left = 200
      Top = 6
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 184
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = BottomPanel
        Properties.Strings = (
          'Height'
          'Left'
          'Width')
      end
      item
        Component = cxChildGrid
        Properties.Strings = (
          'Height'
          'Width')
      end
      item
        Component = cxGrid
        Properties.Strings = (
          'Height')
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
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Component = Splitter
        Properties.Strings = (
          'Top')
      end>
    Top = 184
  end
  inherited ActionList: TActionList
    Top = 183
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spClient
        end
        item
          StoredProc = spProtocol
        end>
    end
    object EDIActionComdocLoad: TEDIAction
      Category = 'EDI'
      MoveParams = <>
      EDI = EDI
      EDIDocType = ediComDoc
      spHeader = spHeaderComDoc
      spList = spListComDoc
      Directory = '/inbox'
    end
    object maEDIComDocLoad: TMultiAction
      Category = 'EDI'
      MoveParams = <>
      ActionList = <
        item
          Action = EDIActionComdocLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1079#1072#1075#1088#1091#1079#1082#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'?'
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1091#1089#1087#1077#1096#1085#1086' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1085#1072#1082#1083#1072#1076#1085#1099#1093
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1085#1072#1082#1083#1072#1076#1085#1099#1093
      ImageIndex = 30
    end
    object maEDIOrdersLoad: TMultiAction
      Category = 'EDI'
      MoveParams = <>
      ActionList = <
        item
          Action = EDIActionOrdersLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1079#1072#1075#1088#1091#1079#1082#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'?'
      InfoAfterExecute = #1047#1072#1082#1072#1079#1099' '#1091#1089#1087#1077#1096#1085#1086' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1079#1072#1082#1072#1079#1072
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1079#1072#1082#1072#1079#1072
      ImageIndex = 27
    end
    object EDIActionOrdersLoad: TEDIAction
      Category = 'EDI'
      MoveParams = <>
      EDI = EDI
      EDIDocType = ediOrder
      spHeader = spHeaderOrder
      spList = spListOrder
      Directory = '/inbox'
    end
    object actSetDefaults: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGetDefaultEDI
      StoredProcList = <
        item
          StoredProc = spGetDefaultEDI
        end>
      Caption = 'actSetDefaults'
    end
    object actOpenSaleForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actOpenSaleForm'
      FormName = 'TSaleForm'
      FormNameParam.Value = 'TSaleForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Component = MasterCDS
          ComponentItem = 'SaleMovementId'
        end
        item
          Name = 'ShowAll'
          Value = 'false'
          DataType = ftBoolean
        end
        item
          Name = 'inOperDate'
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
        end>
      isShowModal = False
    end
    object dsdOpenForm2: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'dsdOpenForm2'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 56
  end
  inherited MasterCDS: TClientDataSet
    Top = 56
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_EDI'
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
      end>
    Top = 56
  end
  inherited BarManager: TdxBarManager
    Top = 56
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbLoadOrder'
        end
        item
          Visible = True
          ItemName = 'bbLoadComDoc'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGotoSale'
        end>
    end
    object bbLoadComDoc: TdxBarButton
      Action = maEDIComDocLoad
      Category = 0
    end
    object bbLoadOrder: TdxBarButton
      Action = maEDIOrdersLoad
      Category = 0
    end
    object bbGotoSale: TdxBarButton
      Action = actOpenSaleForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 448
    Top = 120
  end
  inherited PopupMenu: TPopupMenu
    Top = 184
  end
  object spHeaderOrder: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_EDIOrder'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOrderInvNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOrderOperDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inGLN'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGLNPlace'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'MovementId'
        Value = Null
      end
      item
        Name = 'GoodsPropertyId'
        Value = Null
      end>
    Left = 168
    Top = 120
  end
  object spListOrder: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_EDIOrder'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inGoodsPropertyId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inGoodsName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGLNCode'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inAmountOrder'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end>
    Left = 168
    Top = 168
  end
  object spClient: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_EDI'
    DataSet = ClientCDS
    DataSets = <
      item
        DataSet = ClientCDS
      end>
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
      end>
    Left = 96
    Top = 312
  end
  object ClientDS: TDataSource
    DataSet = ClientCDS
    Left = 64
    Top = 312
  end
  object ClientCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'MovementId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 32
    Top = 312
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 304
    Top = 40
  end
  object RefreshDispatcher: TRefreshDispatcher
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end>
    Left = 304
    Top = 96
  end
  object EDI: TEDI
    ConnectionParams.Host.Value = Null
    ConnectionParams.Host.Component = FormParams
    ConnectionParams.Host.ComponentItem = 'Host'
    ConnectionParams.Host.DataType = ftString
    ConnectionParams.User.Value = Null
    ConnectionParams.User.Component = FormParams
    ConnectionParams.User.ComponentItem = 'UserName'
    ConnectionParams.User.DataType = ftString
    ConnectionParams.Password.Value = Null
    ConnectionParams.Password.Component = FormParams
    ConnectionParams.Password.ComponentItem = 'Password'
    ConnectionParams.Password.DataType = ftString
    Left = 416
    Top = 32
  end
  object spHeaderComDoc: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_EDIComdoc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOrderInvNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOrderOperDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inSaleInvNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inSaleOperDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inOKPO'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'MovementId'
        Value = Null
      end
      item
        Name = 'GoodsPropertyId'
        Value = Null
      end>
    Left = 200
    Top = 104
  end
  object spListComDoc: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_EDIComDoc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inGoodsPropertyId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inGoodsName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGLNCode'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inAmountPartner'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPricePartner'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inSummPartner'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end>
    Left = 192
    Top = 160
  end
  object DBChildViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxChildGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 168
    Top = 344
  end
  object ProtocolCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'MovementId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 616
    Top = 296
  end
  object ProtocolDS: TDataSource
    DataSet = ProtocolCDS
    Left = 648
    Top = 296
  end
  object spProtocol: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_EDIProtocol'
    DataSet = ProtocolCDS
    DataSets = <
      item
        DataSet = ProtocolCDS
      end>
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
      end>
    Left = 680
    Top = 296
  end
  object DBProtocolViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxProtocolGridView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 752
    Top = 328
  end
  object spGetDefaultEDI: TdsdStoredProc
    StoredProcName = 'gpGetDefaultEDI'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Host'
        Value = Null
        Component = FormParams
        ComponentItem = 'Host'
        DataType = ftString
      end
      item
        Name = 'UserName'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserName'
        DataType = ftString
      end
      item
        Name = 'Password'
        Value = Null
        Component = FormParams
        ComponentItem = 'Password'
        DataType = ftString
      end>
    Left = 464
    Top = 32
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Host'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'UserName'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'Password'
        Value = Null
        DataType = ftString
      end>
    Left = 520
    Top = 40
  end
end
