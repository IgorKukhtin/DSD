inherited LoadSaleFrom1CForm: TLoadSaleFrom1CForm
  Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1085#1072#1082#1083#1072#1076#1085#1099#1093' '#1087#1088#1086#1076#1072#1078' '#1080#1079' 1'#1057
  ClientHeight = 416
  ClientWidth = 777
  ExplicitWidth = 785
  ExplicitHeight = 443
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 777
    Height = 359
    TabOrder = 3
    ExplicitWidth = 777
    ExplicitHeight = 359
    ClientRectBottom = 359
    ClientRectRight = 777
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 777
      ExplicitHeight = 359
      inherited cxGrid: TcxGrid
        Top = 132
        Width = 777
        Height = 227
        ExplicitTop = 132
        ExplicitWidth = 777
        ExplicitHeight = 227
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.DataSource = ChildDS
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colSuma
            end>
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object colGoodsGoodsKind: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1099#1081
            DataBinding.FieldName = 'GoodsGoodsKindName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 139
          end
          object colOperCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'OperCount'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 41
          end
          object colOperPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'OperPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 39
          end
          object colSuma: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Suma'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 41
          end
        end
      end
      object cxMasterGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 777
        Height = 129
        Align = alTop
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
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
          object colInvNumber: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 64
          end
          object colBranch: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colDocType: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1076#1086#1082
            DataBinding.FieldName = 'DocType'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object colClientCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1082#1083#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'ClientCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object colClientName: TcxGridDBColumn
            Caption = #1048#1084#1103' '#1082#1083#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'ClientName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object colDeliveryPoint: TcxGridDBColumn
            Caption = #1058#1086#1095#1082#1080' '#1076#1086#1089#1090#1072#1074#1082#1080
            DataBinding.FieldName = 'DeliveryPointName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object colContract: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractNumber'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colClientINN: TcxGridDBColumn
            Caption = #1048#1053#1053
            DataBinding.FieldName = 'ClientINN'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 38
          end
          object colClientOKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'ClientOKPO'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 41
          end
          object colisSync: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'Synchronize'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 129
        Width = 777
        Height = 3
        AlignSplitter = salTop
        Control = cxMasterGrid
      end
    end
  end
  inherited Panel: TPanel
    Width = 777
    ExplicitWidth = 777
    inherited deStart: TcxDateEdit
      EditValue = 41640d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 41640d
      Properties.SaveTime = False
    end
    object edBranch: TcxButtonEdit
      Left = 467
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 4
      Width = 177
    end
    object cxLabel3: TcxLabel
      Left = 421
      Top = 6
      Caption = #1060#1080#1083#1080#1072#1083':'
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cxGrid
        Properties.Strings = (
          'Height')
      end
      item
        Component = cxMasterGrid
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
      end>
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spMasterSelect
      StoredProcList = <
        item
          StoredProc = spMasterSelect
        end
        item
          StoredProc = spSelect
        end>
    end
    object actMoveToDoc: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spMoveSale
      StoredProcList = <
        item
          StoredProc = spMoveSale
        end>
      Caption = #1055#1077#1088#1077#1085#1086#1089#1080#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1074' '#1087#1088#1086#1076#1072#1078#1080
    end
    object actTrancateTable: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spDelete1CLoad
      StoredProcList = <
        item
          StoredProc = spDelete1CLoad
        end>
      Caption = 'actTrancateTable'
    end
    object actSale1CLoadAction: TSale1CLoadAction
      Category = 'DSDLib'
      MoveParams = <>
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
      Branch.Value = ''
      Branch.Component = BranchGuides
      Branch.ComponentItem = 'Key'
      Branch.ParamType = ptInput
    end
    object actLoad1C: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actTrancateTable
        end
        item
          Action = actSale1CLoadAction
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1088#1072#1089#1093#1086#1076#1086#1074' '#1080#1079' 1'#1057
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1088#1072#1089#1093#1086#1076#1086#1074' '#1080#1079' 1'#1057
      ImageIndex = 50
    end
    object actMoveDoc: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actBeforeMove
        end
        item
          Action = actMoveAllDoc
        end>
      QuestionBeforeExecute = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080'? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1077#1088#1077#1085#1077#1089#1077#1085#1099
      Caption = #1055#1077#1088#1077#1085#1086#1089#1080#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1074' '#1087#1088#1086#1076#1072#1078#1080
      Hint = #1055#1077#1088#1077#1085#1086#1089#1080#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1074' '#1087#1088#1086#1076#1072#1078#1080
      ImageIndex = 30
    end
    object actMoveAllDoc: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actMoveToDoc
        end>
      View = cxGridDBTableView1
      Caption = 'actMoveAllDoc'
    end
    object actBeforeMove: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spCheckLoad
      StoredProcList = <
        item
          StoredProc = spCheckLoad
        end
        item
          StoredProc = spErased
        end>
      Caption = 'actBeforeMove'
    end
  end
  inherited MasterDS: TDataSource
    Left = 136
    Top = 112
  end
  inherited MasterCDS: TClientDataSet
    Left = 104
    Top = 112
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_1CSaleLoad'
    DataSet = ChildCDS
    DataSets = <
      item
        DataSet = ChildCDS
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
      end
      item
        Name = 'inBranchId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 208
    Top = 336
  end
  inherited BarManager: TdxBarManager
    Left = 216
    Top = 280
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbRefresh'
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
          ItemName = 'bbLoad1c'
        end
        item
          Visible = True
          ItemName = 'bbMoveSale'
        end>
    end
    object bbMoveSale: TdxBarButton
      Action = actMoveDoc
      Category = 0
    end
    object bbLoad1c: TdxBarButton
      Action = actLoad1C
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 184
    Top = 0
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = BranchGuides
      end>
    Left = 248
    Top = 8
  end
  object spMoveSale: TdsdStoredProc
    StoredProcName = 'gpLoadSaleFrom1C'
    DataSets = <>
    OutputType = otResult
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
      end
      item
        Name = 'inOperDate'
        Component = MasterCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inInvNumber'
        Component = MasterCDS
        ComponentItem = 'InvNumber'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inBranchId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 320
    Top = 264
  end
  object spDelete1CLoad: TdsdStoredProc
    StoredProcName = 'gpDelete_1CSale'
    DataSets = <>
    OutputType = otResult
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
      end
      item
        Name = 'inBranchId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 288
    Top = 112
  end
  object BranchGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    FormNameParam.Value = 'TBranchForm'
    FormNameParam.DataType = ftString
    FormName = 'TBranchForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 576
    Top = 16
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'InvNumber;OperDate;BranchName'
    MasterFields = 'InvNumber;OperDate;BranchName'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 72
    Top = 336
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 104
    Top = 336
  end
  object spMasterSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_1CSaleLoadMaster'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
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
      end
      item
        Name = 'inBranchId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 192
    Top = 120
  end
  object spErased: TdsdStoredProc
    StoredProcName = 'gpErasedSaleFrom1C'
    DataSets = <>
    OutputType = otResult
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
      end
      item
        Name = 'inBranchId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 336
    Top = 216
  end
  object spCheckLoad: TdsdStoredProc
    StoredProcName = 'gpCheckLoadSaleFrom1C'
    DataSets = <>
    OutputType = otResult
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
      end
      item
        Name = 'inBranchId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 296
    Top = 216
  end
end
