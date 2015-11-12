object StaffListDataForm: TStaffListDataForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1064#1090#1072#1090#1085#1086#1077' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077' ('#1076#1072#1085#1085#1099#1077')>'
  ClientHeight = 599
  ClientWidth = 937
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  PixelsPerInch = 96
  TextHeight = 13
  object cxGridStaffList: TcxGrid
    Left = 0
    Top = 49
    Width = 937
    Height = 262
    Align = alClient
    TabOrder = 0
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    ExplicitHeight = 208
    object cxGridDBTableViewStaffLis: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = StaffListDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.Footer = True
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clslCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentVert = vaCenter
        Width = 35
      end
      object clUnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'UnitName'
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object clPositionName: TcxGridDBColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        DataBinding.FieldName = 'PositionName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = PositionChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        FooterAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Width = 100
      end
      object clPositionLevelName: TcxGridDBColumn
        Caption = #1056#1072#1079#1088#1103#1076
        DataBinding.FieldName = 'PositionLevelName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = PositionLevelChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object clHoursPlan: TcxGridDBColumn
        Caption = '1.'#1054#1073#1097'.'#1087#1083'.'#1095'.'#1074' '#1084#1077#1089'. '#1085#1072' '#1095#1077#1083#1086#1074#1077#1082#1072
        DataBinding.FieldName = 'HoursPlan'
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object clHoursDay: TcxGridDBColumn
        Caption = '2.'#1044#1085#1077#1074#1085#1086#1081' '#1087#1083'.'#1095'. '#1085#1072' '#1095#1077#1083#1086#1074#1077#1082#1072
        DataBinding.FieldName = 'HoursDay'
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object clPersonalCount: TcxGridDBColumn
        Caption = '3.'#1050#1086#1083'. '#1095#1077#1083#1086#1074#1077#1082
        DataBinding.FieldName = 'PersonalCount'
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object clComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object clsfIsErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 46
      end
    end
    object cxGridLevel1: TcxGridLevel
      GridView = cxGridDBTableViewStaffLis
    end
  end
  object cxGridStaffListCost: TcxGrid
    Left = 0
    Top = 311
    Width = 937
    Height = 144
    Align = alBottom
    TabOrder = 1
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    ExplicitTop = 257
    object cxGridDBTableViewStaffListCost: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = StaffListCostDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = clsfcComment
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clModelServiceName: TcxGridDBColumn
        Caption = #1052#1086#1076#1077#1083#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
        DataBinding.FieldName = 'ModelServiceName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = ModelServiceChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 301
      end
      object clPrice: TcxGridDBColumn
        Caption = #1056#1072#1089#1094#1077#1085#1082#1072' '#1075#1088#1085'./'#1082#1075'.'
        DataBinding.FieldName = 'Price'
        HeaderAlignmentVert = vaCenter
        Width = 257
      end
      object clsfcComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentVert = vaCenter
        Width = 283
      end
      object clsfcisErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        Visible = False
        Width = 60
      end
    end
    object cxGridLevel2: TcxGridLevel
      GridView = cxGridDBTableViewStaffListCost
    end
  end
  object cxGridStaffListSumm: TcxGrid
    Left = 0
    Top = 455
    Width = 937
    Height = 144
    Align = alBottom
    TabOrder = 2
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    ExplicitTop = 401
    object cxGridDBTableStaffListSumm: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = StaffListSummDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = clslsummComment
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clStaffListSummKindName: TcxGridDBColumn
        Caption = #1058#1080#1087' '#1089#1091#1084#1084#1099
        DataBinding.FieldName = 'StaffListSummKindName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = StaffListSummKindChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentVert = vaCenter
        Width = 150
      end
      object clValue: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072
        DataBinding.FieldName = 'Value'
        HeaderAlignmentVert = vaCenter
        Width = 50
      end
      object clStaffListMasterCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1096#1090'.'#1088'. ('#1073#1072#1079#1086#1074#1086#1077')'
        DataBinding.FieldName = 'StaffListMasterCode'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = StaffListChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentVert = vaCenter
        Width = 90
      end
      object clslsummComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object clcsummSummKindComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1072#1083#1075#1086#1088#1080#1090#1084')'
        DataBinding.FieldName = 'SummKindComment'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 250
      end
      object clslsummisErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        Visible = False
        Width = 38
      end
    end
    object cxGridLevel3: TcxGridLevel
      GridView = cxGridDBTableStaffListSumm
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 26
    Width = 937
    Height = 23
    Align = alTop
    TabOrder = 7
    object ceUnit: TcxButtonEdit
      Left = 471
      Top = 0
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 0
      Width = 258
    end
    object cxLabel5: TcxLabel
      Left = 353
      Top = 1
      Align = alCustom
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
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
    Left = 288
    Top = 104
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
    Left = 176
    Top = 128
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
          ItemName = 'bbInsertSL'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
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
          ItemName = 'bbModelServise'
        end
        item
          Visible = True
          ItemName = 'bbErasedCost'
        end
        item
          Visible = True
          ItemName = 'bbUnErasedCost'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStaffListSummKind'
        end
        item
          Visible = True
          ItemName = 'bbErasedSumm'
        end
        item
          Visible = True
          ItemName = 'bbUnErasedSumm'
        end
        item
          BeginGroup = True
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
          ItemName = 'bbChoiceGuides'
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
    object bbInsert: TdxBarButton
      Action = InsertRecord
      Category = 0
    end
    object bbEdit: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object bbErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
    end
    object bbUnErased: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
    end
    object bbGridToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbModelServise: TdxBarButton
      Action = InsertRecordSLC
      Category = 0
    end
    object bbStaffListSummKind: TdxBarButton
      Action = InsertRecordSLS
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1080#1087' '#1089#1091#1084#1084#1099' '#1096#1090#1072#1090#1085#1086#1075#1086' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1103
    end
    object bbInsertSL: TdxBarButton
      Action = actInsert
      Category = 0
    end
    object bbErasedCost: TdxBarButton
      Action = dsdSetErasedCost
      Category = 0
    end
    object bbUnErasedCost: TdxBarButton
      Action = dsdSetUnErasedCost
      Category = 0
    end
    object bbErasedSumm: TdxBarButton
      Action = dsdSetErasedSumm
      Category = 0
    end
    object bbUnErasedSumm: TdxBarButton
      Action = dsdSetUnErasedSumm
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 296
    Top = 160
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectStaffList
      StoredProcList = <
        item
          StoredProc = spSelectStaffList
        end
        item
          StoredProc = spSelectStaffListCost
        end
        item
          StoredProc = spSelectStaffListSumm
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
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
      DataSource = StaffListDS
    end
    object dsdSetErasedCost: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedCost
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedCost
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1084#1086#1076#1077#1083#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = StaffListCostDS
    end
    object dsdSetErasedSumm: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedSumm
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedSumm
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1090#1080#1087#1099' '#1089#1091#1084#1084
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = StaffListSummDS
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
      DataSource = StaffListDS
    end
    object dsdSetUnErasedCost: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedCost
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedCost
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = StaffListCostDS
    end
    object dsdSetUnErasedSumm: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedSumm
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedSumm
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = StaffListSummDS
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          DataType = ftString
        end
        item
          Name = 'TextValue'
          Value = Null
          DataType = ftString
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object InsertRecord: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewStaffLis
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1096#1090'.'#1077#1076'.'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1096#1090'.'#1077#1076'.'
      ShortCut = 45
      ImageIndex = 0
    end
    object PositionChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PositionChoiceForm'
      FormName = 'TPositionForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = StaffListCDS
          ComponentItem = 'Positionid'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = StaffListCDS
          ComponentItem = 'PositionName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object actUpdateStaffList: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateObject
      StoredProcList = <
        item
          StoredProc = spInsertUpdateObject
        end>
      Caption = 'dsdUpdateStaffList'
      DataSource = StaffListDS
    end
    object PositionLevelChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PositionLevelChoiceForm'
      FormName = 'TPositionLevelForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = StaffListCDS
          ComponentItem = 'PositionLevelId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = StaffListCDS
          ComponentItem = 'PositionLevelName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object InsertRecordSLC: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewStaffListCost
      Action = ModelServiceChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1084#1086#1076#1077#1083#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1084#1086#1076#1077#1083#1100
      ImageIndex = 0
    end
    object ModelServiceChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ModelServiceChoiceForm'
      FormName = 'TModelServiceForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = StaffListCostCDS
          ComponentItem = 'ModelServiceId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = StaffListCostCDS
          ComponentItem = 'ModelServiceName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object actUpdateStaffListCost: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateObjectSLCost
      StoredProcList = <
        item
          StoredProc = spInsertUpdateObjectSLCost
        end>
      Caption = 'actUpdateStaffListCost'
      DataSource = StaffListCostDS
    end
    object StaffListChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StaffListChoiceForm'
      FormName = 'TStaffListForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = StaffListSummCDS
          ComponentItem = 'StaffListMasterId'
        end
        item
          Name = 'Code'
          Value = Null
          Component = StaffListSummCDS
          ComponentItem = 'StaffListMasterCode'
        end>
      isShowModal = True
    end
    object StaffListSummKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StaffListSummKindChoiceForm'
      FormName = 'TStaffListSummKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = StaffListSummCDS
          ComponentItem = 'StaffListSummKindId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = StaffListSummCDS
          ComponentItem = 'StaffListSummKindName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object InsertRecordSLS: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableStaffListSumm
      Action = StaffListSummKindChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1080#1087' '#1089#1091#1084#1084#1099
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1080#1087' '#1089#1091#1084#1084#1099
      ImageIndex = 0
    end
    object actStaffListSumm: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateObjectSLSumm
      StoredProcList = <
        item
          StoredProc = spInsertUpdateObjectSLSumm
        end>
      Caption = 'actStaffListSumm'
      DataSource = StaffListSummDS
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TStaffListEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
      DataSource = StaffListDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actUpdate'
      ImageIndex = 1
      FormName = 'TStaffListEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = StaffListCDS
          ComponentItem = 'Id'
          ParamType = ptInput
        end>
      isShowModal = False
      DataSource = StaffListDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 168
    Top = 192
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewStaffLis
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 456
    Top = 192
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 288
    Top = 208
  end
  object StaffListCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 497
    Top = 141
  end
  object StaffListDS: TDataSource
    DataSet = StaffListCDS
    Left = 422
    Top = 133
  end
  object spSelectStaffList: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_StaffList'
    DataSet = StaffListCDS
    DataSets = <
      item
        DataSet = StaffListCDS
      end>
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'inUnitId'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 578
    Top = 125
  end
  object spInsertUpdateObject: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_StaffList'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = StaffListCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'ioCode'
        Value = Null
        Component = StaffListCDS
        ComponentItem = 'Code'
        ParamType = ptInputOutput
      end
      item
        Name = 'inHoursPlan'
        Value = Null
        Component = StaffListCDS
        ComponentItem = 'HoursPlan'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inHoursDay'
        Value = Null
        Component = StaffListCDS
        ComponentItem = 'HoursDay'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPersonalCount'
        Value = Null
        Component = StaffListCDS
        ComponentItem = 'PersonalCount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = Null
        Component = StaffListCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = StaffListCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = StaffListCDS
        ComponentItem = 'PositionId'
        ParamType = ptInput
      end
      item
        Name = 'inPositionLevelId'
        Value = Null
        Component = StaffListCDS
        ComponentItem = 'PositionLevelId'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 672
    Top = 128
  end
  object StaffListCostCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'StaffListId'
    MasterFields = 'Id'
    MasterSource = StaffListDS
    PacketRecords = 0
    Params = <>
    Left = 209
    Top = 405
  end
  object StaffListCostDS: TDataSource
    DataSet = StaffListCostCDS
    Left = 102
    Top = 389
  end
  object spSelectStaffListCost: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_StaffListCost'
    DataSet = StaffListCostCDS
    DataSets = <
      item
        DataSet = StaffListCostCDS
      end>
    Params = <>
    PackSize = 1
    Left = 514
    Top = 397
  end
  object spInsertUpdateObjectSLCost: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_StaffListCost'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = StaffListCostCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = StaffListCostCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = Null
        Component = StaffListCostCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inStaffListId'
        Value = Null
        Component = StaffListCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inModelServiceId'
        Value = Null
        Component = StaffListCostCDS
        ComponentItem = 'ModelServiceId'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 376
    Top = 392
  end
  object StaffListSummDS: TDataSource
    DataSet = StaffListSummCDS
    Left = 94
    Top = 541
  end
  object StaffListSummCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'StaffListId'
    MasterFields = 'Id'
    MasterSource = StaffListDS
    PacketRecords = 0
    Params = <>
    Left = 209
    Top = 541
  end
  object spInsertUpdateObjectSLSumm: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_StaffListSumm'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = StaffListSummCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inValue'
        Value = Null
        Component = StaffListSummCDS
        ComponentItem = 'Value'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = Null
        Component = StaffListSummCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inStaffListId'
        Value = Null
        Component = StaffListCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inStaffListMasterId'
        Value = Null
        Component = StaffListSummCDS
        ComponentItem = 'StaffListMasterId'
        ParamType = ptInput
      end
      item
        Name = 'inStaffListSummKindId'
        Value = Null
        Component = StaffListSummCDS
        ComponentItem = 'StaffListSummKindId'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 336
    Top = 544
  end
  object spSelectStaffListSumm: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_StaffListSumm'
    DataSet = StaffListSummCDS
    DataSets = <
      item
        DataSet = StaffListSummCDS
      end>
    Params = <>
    PackSize = 1
    Left = 506
    Top = 541
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 743
    Top = 15
  end
  object dsdDBViewAddOnStaffListCost: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewStaffListCost
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 560
    Top = 336
  end
  object dsdDBViewAddOnStaffListSumm: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableStaffListSumm
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 560
    Top = 488
  end
  object spErasedUnErasedCost: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = StaffListCostCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 296
    Top = 344
  end
  object spErasedUnErasedSumm: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = StaffListSummCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 304
    Top = 472
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = UnitGuides
      end>
    Left = 40
    Top = 136
  end
end
