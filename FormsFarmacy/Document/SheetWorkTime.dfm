object SheetWorkTimeForm: TSheetWorkTimeForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1058#1072#1073#1077#1083#1100' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080'>'
  ClientHeight = 504
  ClientWidth = 971
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object DataPanel: TPanel
    Left = 0
    Top = 0
    Width = 971
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object edOperDate: TcxDateEdit
      Left = 1
      Top = 20
      EditValue = 42335d
      Properties.DisplayFormat = 'mmmm yyyy'
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 108
    end
    object cxLabel2: TcxLabel
      Left = 1
      Top = 2
      Caption = #1044#1072#1090#1072
    end
    object edUnit: TcxButtonEdit
      Left = 115
      Top = 20
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 0
      Width = 278
    end
    object cxLabel4: TcxLabel
      Left = 115
      Top = 2
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 75
    Width = 971
    Height = 201
    Align = alTop
    TabOrder = 0
    object cxGridDBBandedTableView: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = MasterDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Options = [dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoGroupsAlwaysExpanded]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.BandHiding = True
      OptionsCustomize.BandsQuickCustomization = True
      OptionsCustomize.ColumnVertSizing = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridBandedTableViewStyleSheet
      Styles.BandHeader = dmMain.cxHeaderStyle
      Bands = <
        item
          Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
          FixedKind = fkLeft
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
        end
        item
          Caption = #1055#1077#1088#1080#1086#1076
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
          Width = 50
        end>
      object BandcolPersonalCode: TcxGridDBBandedColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'PersonalCode'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Options.Moving = False
        Width = 34
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object BandcolPersonalName: TcxGridDBBandedColumn
        Caption = #1060#1048#1054
        DataBinding.FieldName = 'PersonalName'
        HeaderAlignmentVert = vaCenter
        MinWidth = 67
        Options.Editing = False
        Options.Moving = False
        Width = 109
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object BandcolPositionName: TcxGridDBBandedColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        DataBinding.FieldName = 'PositionName'
        HeaderAlignmentVert = vaCenter
        MinWidth = 64
        Options.Editing = False
        Options.Moving = False
        Width = 87
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object BandcolPersonalGroupName: TcxGridDBBandedColumn
        Caption = #1041#1088#1080#1075#1072#1076#1072
        DataBinding.FieldName = 'PersonalGroupName'
        Visible = False
        GroupIndex = 0
        HeaderAlignmentVert = vaCenter
        MinWidth = 64
        Options.Editing = False
        Options.Moving = False
        Width = 73
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object TemplateColumn: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Value'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = OpenWorkTimeKindForm
            Default = True
            Kind = bkEllipsis
          end>
        Visible = False
        MinWidth = 40
        Width = 40
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object isErased: TcxGridDBBandedColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        Visible = False
        Options.Editing = False
        Width = 50
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBBandedTableView
    end
  end
  object cxSplitter1: TcxSplitter
    Left = 0
    Top = 276
    Width = 971
    Height = 8
    AlignSplitter = salTop
    Control = cxGrid
  end
  object cxGrid1: TcxGrid
    Left = 0
    Top = 284
    Width = 971
    Height = 220
    Align = alClient
    TabOrder = 7
    ExplicitLeft = -8
    ExplicitTop = 290
    object cxGridDBBandedTableView1: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ChildDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Options = [dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoGroupsAlwaysExpanded]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.BandHiding = True
      OptionsCustomize.BandsQuickCustomization = True
      OptionsCustomize.ColumnVertSizing = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridBandedTableViewStyleSheet
      Styles.BandHeader = dmMain.cxHeaderStyle
      Bands = <
        item
          Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
          FixedKind = fkLeft
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
        end
        item
          Caption = #1055#1077#1088#1080#1086#1076
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
          Width = 50
        end>
      object ColPersonalCode: TcxGridDBBandedColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'PersonalCode'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Options.Moving = False
        Width = 34
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object ColPersonalName: TcxGridDBBandedColumn
        Caption = #1060#1048#1054
        DataBinding.FieldName = 'PersonalName'
        HeaderAlignmentVert = vaCenter
        MinWidth = 67
        Options.Editing = False
        Options.Moving = False
        Width = 109
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object ColPositionName: TcxGridDBBandedColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        DataBinding.FieldName = 'PositionName'
        HeaderAlignmentVert = vaCenter
        MinWidth = 64
        Options.Editing = False
        Options.Moving = False
        Width = 87
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object ColPersonalGroupName: TcxGridDBBandedColumn
        Caption = #1041#1088#1080#1075#1072#1076#1072
        DataBinding.FieldName = 'PersonalGroupName'
        Visible = False
        GroupIndex = 0
        HeaderAlignmentVert = vaCenter
        MinWidth = 64
        Options.Editing = False
        Options.Moving = False
        Width = 73
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object TemplateColumn1: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Value'
        PropertiesClassName = 'TcxDateEditProperties'
        Properties.Kind = ckDateTime
        Visible = False
        MinWidth = 40
        Width = 40
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object ColisErased: TcxGridDBBandedColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        Visible = False
        Options.Editing = False
        Width = 50
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
    end
    object cxGridLevel1: TcxGridLevel
      GridView = cxGridDBBandedTableView1
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
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
      end>
    Left = 158
    Top = 119
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_SheetWorkTime'
    DataSet = HeaderCDS
    DataSets = <
      item
        DataSet = HeaderCDS
      end
      item
        DataSet = MasterCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inDate'
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
        Name = 'inisErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 448
    Top = 151
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 14
    Top = 119
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar: TdxBar
      AllowClose = False
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 409
      FloatTop = 390
      FloatClientWidth = 51
      FloatClientHeight = 93
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbUpdate'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbMISetErased'
        end
        item
          Visible = True
          ItemName = 'bbMISetUnErased'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
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
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbGridToExel: TdxBarButton
      Action = GridToExcel
      Category = 0
    end
    object bbInsert: TdxBarButton
      Action = InsertAction
      Category = 0
    end
    object bbUpdate: TdxBarButton
      Action = UpdateAction
      Category = 0
    end
    object bbLoadFromTransport: TdxBarButton
      Action = actInsertUpdate_SheetWorkTime_FromTransport
      Category = 0
    end
    object bbMISetErased: TdxBarButton
      Action = actMISetErased
      Category = 0
    end
    object bbMISetUnErased: TdxBarButton
      Action = actMISetUnErased
      Category = 0
    end
    object bbShowErased: TdxBarButton
      Action = actShowErased
      Category = 0
    end
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 41
    Top = 192
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 51
    Top = 119
    object actUpdateChildDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMI_Child
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMI_Child
        end>
      Caption = 'actUpdateChildDS'
      DataSource = ChildDS
    end
    object actUpdateMasterDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMI
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMI
        end>
      Caption = 'actUpdateMasterDS'
      DataSource = MasterDS
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDataset'
        end>
      Params = <
        item
          Name = 'InvNumber'
          Value = ''
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'From'
          Value = ''
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'OperDate'
          Value = 0d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
        end>
      ReportName = #1055#1088#1080#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = ''
      ReportNameParam.DataType = ftString
    end
    object GridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object OpenWorkTimeKindForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      FormName = 'TWorkTimeKind_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = CrossDBViewAddOn
          ComponentItem = 'TypeId'
        end
        item
          Name = 'Value'
          Value = Null
          Component = CrossDBViewAddOn
          ComponentItem = 'Value'
          DataType = ftString
        end>
      isShowModal = True
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectMI_Child
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object MultiAction: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = OpenWorkTimeKindForm
        end
        item
          Action = actUpdateMasterDS
        end>
    end
    object InsertAction: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072' '#1074' '#1090#1072#1073#1077#1083#1100
      ImageIndex = 0
      FormName = 'TSheetWorkTimeAddRecordForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'PersonalId'
          Value = '0'
        end
        item
          Name = 'PositionId'
          Value = 0
        end
        item
          Name = 'PersonalGroupId'
          Value = '0'
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
        end
        item
          Name = 'OperDate'
          Value = 0d
          Component = edOperDate
          DataType = ftDateTime
        end>
      isShowModal = True
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object UpdateAction: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
      ImageIndex = 1
      FormName = 'TSheetWorkTimeAddRecordForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'PersonalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalId'
        end
        item
          Name = 'PositionId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PositionId'
        end
        item
          Name = 'PersonalGroupId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalGroupId'
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
        end
        item
          Name = 'OperDate'
          Value = 0d
          Component = edOperDate
          DataType = ftDateTime
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsertUpdate_SheetWorkTime_FromTransport: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_SheetWorkTime_FromTransport
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_SheetWorkTime_FromTransport
        end
        item
          StoredProc = spSelectMI
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1087#1091#1090#1077#1074#1099#1093' '#1083#1080#1089#1090#1086#1074
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1087#1091#1090#1077#1074#1099#1093' '#1083#1080#1089#1090#1086#1074
      ImageIndex = 27
      QuestionBeforeExecute = #1042#1099' '#1076#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1093#1086#1090#1080#1090#1077' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1091#1090#1077#1074#1099#1093' '#1083#1080#1089#1090#1086#1074'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
    end
    object actMISetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actMISetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
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
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 454
    Top = 95
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 408
    Top = 95
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
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
    Left = 200
    Top = 8
  end
  object spInsertUpdateMI: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_SheetWorkTime'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inPersonalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalId'
        ParamType = ptInput
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionId'
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
        Name = 'inPersonalGroupId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalGroupId'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = HeaderCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'ioValue'
        Value = Null
        Component = CrossDBViewAddOn
        ComponentItem = 'Value'
        DataType = ftString
        ParamType = ptInputOutput
      end
      item
        Name = 'ioTypeId'
        Value = Null
        Component = CrossDBViewAddOn
        ComponentItem = 'TypeId'
        ParamType = ptInputOutput
      end>
    PackSize = 1
    Left = 542
    Top = 151
  end
  object CrossDBViewAddOn: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = TemplateColumn
    Left = 680
    Top = 112
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 552
    Top = 88
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = edOperDate
      end
      item
        Component = GuidesUnit
      end>
    Left = 344
    Top = 16
  end
  object spInsertUpdate_SheetWorkTime_FromTransport: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_SheetWorkTime_FromTransport'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 200
    Top = 160
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMI_SheetWorkTime_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inPersonalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalId'
        ParamType = ptInput
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionId'
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
        Name = 'inPersonalGroupId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalGroupId'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'ioIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        ParamType = ptInputOutput
      end>
    PackSize = 1
    Left = 518
    Top = 207
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 352
    Top = 295
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 398
    Top = 295
  end
  object spSelectMI_Child: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_SheetWorkTime_Child'
    DataSet = HeaderCDS_Child
    DataSets = <
      item
        DataSet = HeaderCDS_Child
      end
      item
        DataSet = ChildCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inDate'
        Value = 42335d
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
        Name = 'inisErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 480
    Top = 375
  end
  object CrossDBViewAddOn_Child: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    HeaderDataSet = HeaderCDS_Child
    HeaderColumnName = 'ValueField'
    TemplateColumn = TemplateColumn1
    Left = 600
    Top = 352
  end
  object HeaderCDS_Child: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 488
    Top = 304
  end
  object spInsertUpdateMI_Child: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_SheetWorkTime_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inPersonalId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'PersonalId'
        ParamType = ptInput
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'PositionId'
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
        Name = 'inPersonalGroupId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'PersonalGroupId'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = HeaderCDS_Child
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'ioValue'
        Value = 'NULL'
        Component = CrossDBViewAddOn_Child
        ComponentItem = 'Value'
        DataType = ftDateTime
        ParamType = ptInputOutput
      end>
    PackSize = 1
    Left = 254
    Top = 351
  end
end
