object Unit_PersonalForm: TUnit_PersonalForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103'> - '#1040#1074#1090#1086' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1047#1055
  ClientHeight = 388
  ClientWidth = 980
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  PixelsPerInch = 96
  TextHeight = 13
  object cxSplitter1: TcxSplitter
    Left = 0
    Top = 58
    Width = 8
    Height = 330
  end
  object cxGrid: TcxGrid
    Left = 8
    Top = 58
    Width = 972
    Height = 330
    Align = alClient
    TabOrder = 1
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = GridDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.HeaderHeight = 50
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object isPersonalService: TcxGridDBColumn
        Caption = #1040#1074#1090#1086' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1047#1055
        DataBinding.FieldName = 'isPersonalService'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1100' '#1040#1074#1090#1086' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1047#1055
        Width = 80
      end
      object PersonalServiceDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1040#1074#1090#1086' '#1047#1055
        DataBinding.FieldName = 'PersonalServiceDate'
        PropertiesClassName = 'TcxDateEditProperties'
        Properties.Kind = ckDateTime
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1087#1086#1089#1083#1077#1076#1085#1077#1075#1086' '#1040#1074#1090#1086' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1047#1055
        Options.Editing = False
        Width = 93
      end
      object ParentName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072
        DataBinding.FieldName = 'ParentName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object Name: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        SortIndex = 0
        SortOrder = soAscending
        Width = 200
      end
      object DepartmentName: TcxGridDBColumn
        Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090' 1 '#1088#1110#1074#1085#1103
        DataBinding.FieldName = 'DepartmentName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 150
      end
      object Department_twoName: TcxGridDBColumn
        Caption = #1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090' 2 '#1088#1110#1074#1085#1103
        DataBinding.FieldName = 'Department_twoName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 88
      end
      object PersonalServiceListName: TcxGridDBColumn
        Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100
        DataBinding.FieldName = 'PersonalServiceListName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 150
      end
      object isError_psl: TcxGridDBColumn
        Caption = #1055#1088#1086#1074#1077#1088#1082#1072
        DataBinding.FieldName = 'isError_psl'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1088#1086#1074#1077#1088#1082#1072' ('#1073#1086#1083#1077#1077' 1 '#1074#1077#1076#1086#1084#1086#1089#1090#1080') '#1044#1072' / '#1053#1077#1090
        Options.Editing = False
        Width = 50
      end
      object AreaName: TcxGridDBColumn
        Caption = #1056#1077#1075#1080#1086#1085
        DataBinding.FieldName = 'AreaName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object BranchName: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083
        DataBinding.FieldName = 'BranchName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 95
      end
      object BusinessName: TcxGridDBColumn
        Caption = #1041#1080#1079#1085#1077#1089
        DataBinding.FieldName = 'BusinessName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 76
      end
      object ProfitLossGroupCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1054#1055#1080#1059' '#1075#1088'.'
        DataBinding.FieldName = 'ProfitLossGroupCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        VisibleForCustomization = False
        Width = 50
      end
      object ProfitLossGroupName: TcxGridDBColumn
        Caption = #1054#1055#1080#1059' '#1075#1088#1091#1087#1087#1072
        DataBinding.FieldName = 'ProfitLossGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        VisibleForCustomization = False
        Width = 80
      end
      object ProfitLossDirectionCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1054#1055#1080#1059' '#1085#1072#1087#1088'.'
        DataBinding.FieldName = 'ProfitLossDirectionCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        VisibleForCustomization = False
        Width = 50
      end
      object ProfitLossDirectionName: TcxGridDBColumn
        Caption = #1054#1055#1080#1059' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'ProfitLossDirectionName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        VisibleForCustomization = False
        Width = 76
      end
      object PartnerCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
        DataBinding.FieldName = 'PartnerCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object PartnerName: TcxGridDBColumn
        Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
        DataBinding.FieldName = 'PartnerName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object PersonalHeadName: TcxGridDBColumn
        Caption = #1056#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
        DataBinding.FieldName = 'PersonalHeadName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
      object UnitName_Head: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1088#1091#1082#1086#1074'.)'
        DataBinding.FieldName = 'UnitName_Head'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1103')'
        Options.Editing = False
        Width = 100
      end
      object BranchName_Head: TcxGridDBColumn
        Caption = #1060#1080#1083#1080#1072#1083' ('#1088#1091#1082#1086#1074'.)'
        DataBinding.FieldName = 'BranchName_Head'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1060#1080#1083#1080#1072#1083' ('#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1103')'
        Options.Editing = False
        Width = 80
      end
      object SheetWorkTimeName: TcxGridDBColumn
        Caption = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099' ('#1064#1072#1073#1083#1086#1085' '#1090#1072#1073#1077#1083#1103' '#1088'.'#1074#1088'.)'
        DataBinding.FieldName = 'SheetWorkTimeName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1056#1077#1078#1080#1084' '#1088#1072#1073#1086#1090#1099' ('#1064#1072#1073#1083#1086#1085' '#1090#1072#1073#1077#1083#1103' '#1088'.'#1074#1088'.)'
        Options.Editing = False
        Width = 149
      end
      object Address: TcxGridDBColumn
        Caption = #1040#1076#1088#1077#1089
        DataBinding.FieldName = 'Address'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object Comment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object isIrna: TcxGridDBColumn
        Caption = #1048#1088#1085#1072
        DataBinding.FieldName = 'isIrna'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1048#1088#1085#1072' ('#1044#1072'/'#1053#1077#1090')'
        Options.Editing = False
        Width = 45
      end
      object IsErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 980
    Height = 32
    Align = alTop
    TabOrder = 6
    object deStart: TcxDateEdit
      Left = 107
      Top = 5
      EditValue = 45658d
      Properties.ShowTime = False
      TabOrder = 0
      Width = 82
    end
    object deEnd: TcxDateEdit
      Left = 314
      Top = 5
      EditValue = 45658d
      Properties.ShowTime = False
      TabOrder = 1
      Width = 82
    end
    object cxLabel1: TcxLabel
      Left = 10
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel2: TcxLabel
      Left = 198
      Top = 6
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel3: TcxLabel
      Left = 412
      Top = 6
      Caption = #8470' '#1089#1077#1089#1089#1080#1080':'
    end
    object edSessionCode: TcxCurrencyEdit
      Left = 473
      Top = 5
      EditValue = 0.000000000000000000
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      TabOrder = 5
      Width = 109
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
    Left = 232
    Top = 96
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
    Left = 152
    Top = 88
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
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
          ItemName = 'bbChoice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdate_PersonalService'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMessagePersonalServiceForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocol'
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
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
      ImageIndex = 4
    end
    object bbInsert: TdxBarButton
      Action = actInsert
      Category = 0
      ImageIndex = 0
    end
    object bbEdit: TdxBarButton
      Action = actUpdate
      Category = 0
      ImageIndex = 1
    end
    object bbErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
      ImageIndex = 2
    end
    object bbUnErased: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
      ImageIndex = 8
    end
    object bbChoice: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbGridToExcel: TdxBarButton
      Action = actGridToExcel
      Category = 0
    end
    object bbProtocol: TdxBarButton
      Action = actProtocol
      Category = 0
    end
    object bbInsertUpdate_PersonalService: TdxBarButton
      Action = macInsertUpdate_PersonalService
      Category = 0
    end
    object dxLabel3: TdxBarControlContainerItem
      Caption = 'edSessionCode_text'
      Category = 0
      Hint = 'edSessionCode_text'
      Visible = ivAlways
    end
    object bbSessionCode: TdxBarControlContainerItem
      Caption = 'edSessionCode'
      Category = 0
      Hint = 'edSessionCode'
      Visible = ivAlways
    end
    object bbMessagePersonalServiceForm: TdxBarButton
      Action = actOpenMessagePersonalServiceForm
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 232
    Top = 144
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_Param
      StoredProcList = <
        item
          StoredProc = spGet_Param
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_Param_next
      StoredProcList = <
        item
          StoredProc = spGet_Param_next
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      FormName = 'TUnitEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = GridDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      FormName = 'TUnitEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSource = GridDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 46
      ErasedFieldName = 'isErased'
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ParentId'
          Value = Null
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = GridDS
    end
    object dsdSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
    end
    object actGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actUnitChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'UnitChoiceForm'
      FormName = 'TUnit_ObjectForm'
      FormNameParam.Value = 'TUnit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'UnitId_HistoryCost'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'UnitName_HistoryCost'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'UnitCode_HistoryCost'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdate_HistoryCost: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actUpdate_HistoryCost'
      ImageIndex = 76
      DataSource = GridDS
    end
    object actProtocol: TdsdOpenForm
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
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macInsertUpdate_PersonalService_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdate_PersonalService
        end>
      View = cxGridDBTableView
      Caption = 'macInsertUpdate_PersonalService_list'
      ImageIndex = 41
    end
    object macInsertUpdate_PersonalService: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Param_next
        end
        item
          Action = macInsertUpdate_PersonalService_list
        end
        item
          Action = actComplete_Mov
        end
        item
          Action = actOpenMessagePersonalServiceForm
        end>
      QuestionBeforeExecute = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'>?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099
      Caption = #1040#1074#1090#1086' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1047#1055' '#1057#1090#1072#1088#1090
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103#1084' '#1047#1055
    end
    object actComplete_Mov: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spComplete_Mov
      StoredProcList = <
        item
          StoredProc = spComplete_Mov
        end>
      Caption = 'actComplete_Mov'
      ImageIndex = 66
    end
    object actGet_Param_next: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Param_next
      StoredProcList = <
        item
          StoredProc = spGet_Param_next
        end>
      Caption = 'actInsertUpdate_PersonalService'
      ImageIndex = 41
    end
    object actInsertUpdate_PersonalService: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = gpInsertUpdate_PersonalService_byUnit
      StoredProcList = <
        item
          StoredProc = gpInsertUpdate_PersonalService_byUnit
        end>
      Caption = 'actInsertUpdate_PersonalService'
      ImageIndex = 41
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_Personal
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_Personal
        end>
      Caption = 'actUpdateDataSet'
      DataSource = GridDS
    end
    object actInsert_MessagePersonalService: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_MessagePersonalService
      StoredProcList = <
        item
          StoredProc = spInsert_MessagePersonalService
        end>
      Caption = 'actInsert_MessagePersonalService'
      ImageIndex = 52
    end
    object actOpenMessagePersonalServiceForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1096#1080#1073#1082#1072#1084
      Hint = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1054#1090#1095#1077#1090' '#1087#1086' '#1086#1096#1080#1073#1082#1072#1084' '#1040#1074#1090#1086' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1047#1055'>'
      FormName = 'TMessagePersonalServiceLastForm'
      FormNameParam.Value = 'TMessagePersonalServiceLastForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
  end
  object GridDS: TDataSource
    DataSet = ClientDataSet
    Left = 360
    Top = 104
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    PacketRecords = 0
    Params = <>
    Left = 320
    Top = 152
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Unit_Personal'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <>
    PackSize = 1
    Left = 72
    Top = 152
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 232
    Top = 288
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
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
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 176
    Top = 200
  end
  object spUpdate_Unit_Personal: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Unit_Personal'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalServiceDate'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PersonalServiceDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPersonalService'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isPersonalService'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 528
    Top = 168
  end
  object gpInsertUpdate_PersonalService_byUnit: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_PersonalService_Child_byUnit_mes'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSessionCode'
        Value = Null
        Component = edSessionCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPersonalService'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isPersonalService'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPersonalServiceDate'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PersonalServiceDate'
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 760
    Top = 160
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 24
    Top = 208
  end
  object spInsert_MessagePersonalService: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_MessagePersonalService'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCode'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCode'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalServiceListId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = #1089#1090#1072#1088#1090
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 528
    Top = 248
  end
  object spGet_Param: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Unit_PersonalParam'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'SessionCode'
        Value = Null
        Component = edSessionCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 72
    Top = 256
  end
  object spGet_Param_next: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Unit_PersonalParam'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'SessionCode'
        Value = 0.000000000000000000
        Component = edSessionCode
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 56
    Top = 312
  end
  object spComplete_Mov: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_PersonalService_byMessage_auto'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inStartDate'
        Value = 45658d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 45658d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSessionCode'
        Value = 0.000000000000000000
        Component = edSessionCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 352
    Top = 272
  end
end
