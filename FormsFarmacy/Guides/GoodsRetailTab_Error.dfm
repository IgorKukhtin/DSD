inherited GoodsRetailTab_ErrorForm: TGoodsRetailTab_ErrorForm
  Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072' '#1090#1086#1074#1072#1088#1086#1074' '#1089#1077#1090#1080
  ClientHeight = 535
  ClientWidth = 1079
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 1095
  ExplicitHeight = 573
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1079
    Height = 509
    ExplicitWidth = 1079
    ExplicitHeight = 509
    ClientRectBottom = 509
    ClientRectRight = 1079
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1079
      ExplicitHeight = 509
      inherited cxGrid: TcxGrid
        Width = 1079
        Height = 243
        Align = alTop
        LookAndFeel.NativeStyle = True
        LookAndFeel.SkinName = ''
        ExplicitWidth = 1079
        ExplicitHeight = 243
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = Name_1
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Id_1: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 4
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Code_1: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'ObjectCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 4
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object Name_1: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1054#1073#1097#1077#1077
            DataBinding.FieldName = 'Name'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsMainId_1: TcxGridDBColumn
            DataBinding.FieldName = 'GoodsMainId'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 55
          end
          object isErased_1: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isTOP_1: TcxGridDBColumn
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'isTOP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isFirst_1: TcxGridDBColumn
            Caption = '1-'#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isFirst'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isSecond_1: TcxGridDBColumn
            Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isSecond'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object MinimumLot_1: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'MinimumLot'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object PercentMarkup_1: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'PercentMarkup'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object Price_1: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object RetailName_1: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object UserInsertName_1: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'UserInsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object UserUpdateName_1: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UserUpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object DateInsert_1: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'DateInsert'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object DateUpdate_1: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'DateUpdate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 44
          end
          object Color_GoodsMainId: TcxGridDBColumn
            DataBinding.FieldName = 'Color_GoodsMainId'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_isTOP: TcxGridDBColumn
            DataBinding.FieldName = 'Color_isTOP'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_isFirst: TcxGridDBColumn
            DataBinding.FieldName = 'Color_isFirst'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_isSecond: TcxGridDBColumn
            DataBinding.FieldName = 'Color_isSecond'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_MinimumLot: TcxGridDBColumn
            DataBinding.FieldName = 'Color_MinimumLot'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_PercentMarkup: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PercentMarkup'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_Price: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Price'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_RetailId: TcxGridDBColumn
            DataBinding.FieldName = 'Color_RetailId'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_UserInsertId: TcxGridDBColumn
            DataBinding.FieldName = 'Color_UserInsertId'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_UserUpdateId: TcxGridDBColumn
            DataBinding.FieldName = 'Color_UserUpdateId'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_DateInsert: TcxGridDBColumn
            DataBinding.FieldName = 'Color_DateInsert'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object Color_DateUpdate: TcxGridDBColumn
            DataBinding.FieldName = 'Color_DateUpdate'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object isErr_GoodsMainId: TcxGridDBColumn
            Caption = 'GoodsMainId '#1086#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isErr_GoodsMainId'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isErr_isTOP: TcxGridDBColumn
            Caption = #1058#1054#1055' '#1086#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isErr_isTOP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isErr_isFirst: TcxGridDBColumn
            Caption = '1-'#1074#1099#1073#1086#1088' '#1086#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isErr_isFirst'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isErr_isSecond: TcxGridDBColumn
            Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088' '#1086#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isErr_isSecond'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isErr_MinimumLot: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1086#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isErr_MinimumLot'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isErr_PercentMarkup: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080' '#1086#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isErr_PercentMarkup'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isErr_Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1086#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isErr_Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isErr_RetailId: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' '#1086#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isErr_RetailId'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isErr_UserUpdateId: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.) '#1086#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isErr_UserUpdateId'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isErr_UserInsertId: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.) '#1086#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isErr_UserInsertId'
            Width = 700
          end
          object isErr_DateUpdate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'isErr_DateUpdate'
            Width = 70
          end
          object isErr_DateInsert: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.) '#1086#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isErr_DateInsert'
            Width = 70
          end
        end
        object cxGridLevel1: TcxGridLevel
        end
      end
      object cxGridGChild1: TcxGrid
        Left = 0
        Top = 252
        Width = 1079
        Height = 257
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 1
        LookAndFeel.NativeStyle = True
        LookAndFeel.SkinName = ''
        object cxGridDBTableViewChild1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS_1
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object Id_2: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 4
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object GoodsMainId_2: TcxGridDBColumn
            DataBinding.FieldName = 'GoodsMainId'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object isTOP_2: TcxGridDBColumn
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'isTOP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isFirst_2: TcxGridDBColumn
            Caption = '1-'#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isFirst'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object isSecond_2: TcxGridDBColumn
            Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isSecond'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object MinimumLot_2: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'MinimumLot'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object PercentMarkup_2: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'PercentMarkup'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object Price_2: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object RetailName_2: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object UserInsertName_2: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'UserInsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object UserUpdateName_2: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UserUpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object DateInsert_2: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'DateInsert'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object DateUpdate_2: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'DateUpdate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 44
          end
        end
        object cxGridLevelChild1: TcxGridLevel
          GridView = cxGridDBTableViewChild1
        end
      end
      object cxSplitter: TcxSplitter
        Left = 0
        Top = 243
        Width = 1079
        Height = 9
        AlignSplitter = salTop
        Control = cxGrid
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 467
    Top = 128
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 624
    Top = 128
  end
  inherited ActionList: TActionList
    Left = 199
    Top = 127
    object DataSetDelete: TDataSetDelete [0]
      Category = 'Delete'
      Caption = '&Delete'
      Hint = 'Delete'
      DataSource = ChildDS_1
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end
        item
        end>
    end
    object mactListDelete: TMultiAction [2]
      Category = 'Delete'
      MoveParams = <>
      ActionList = <
        item
          Action = dsdExecStoredProc1
        end>
      DataSource = ChildDS_1
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1089#1074#1079#1080'? '
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1082#1086#1076#1086#1074
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      WithoutNext = True
    end
    inherited actInsert: TInsertUpdateChoiceAction
      Enabled = False
      ShortCut = 0
      FormName = 'TGoodsMainEditForm'
      FormNameParam.Value = 'TGoodsMainEditForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      Enabled = False
      ShortCut = 0
      FormName = 'TGoodsMainEditForm'
      FormNameParam.Value = 'TGoodsMainEditForm'
      isShowModal = True
    end
    inherited dsdSetUnErased: TdsdUpdateErased
      Enabled = False
      ShortCut = 0
    end
    inherited dsdSetErased: TdsdUpdateErased
      Category = 'Delete'
      StoredProc = dsdStoredProc1
      StoredProcList = <
        item
          StoredProc = dsdStoredProc1
        end>
      ImageIndex = -1
      ShortCut = 0
    end
    inherited dsdChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end>
    end
    inherited ProtocolOpenForm: TdsdOpenForm
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072'1'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072'1'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsMainId'
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
    end
    object actGoodsLinkRefresh: TdsdDataSetRefresh
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
    object mactDelete: TMultiAction
      Category = 'Delete'
      MoveParams = <>
      ActionList = <
        item
          Action = dsdExecStoredProc1
        end
        item
          Action = DataSetDelete
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1089#1074#1079#1080'? '
      Caption = #1059#1076#1072#1083#1077#1085#1080#1077
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
    end
    object dsdExecStoredProc1: TdsdExecStoredProc
      Category = 'Delete'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = dsdStoredProc1
      StoredProcList = <
        item
          StoredProc = dsdStoredProc1
        end>
      Caption = 'dsdExecStoredProc1'
    end
    object Protocol2OpenForm: TdsdOpenForm
      Category = #1055#1088#1086#1090#1086#1082#1086#1083
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072'2'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072'2'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ChildCDS_1
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildCDS_1
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object Protocol3OpenForm: TdsdOpenForm
      Category = #1055#1088#1086#1090#1086#1082#1086#1083
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072'3'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072'3'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 104
    Top = 64
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Left = 32
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsRetail_ErrorTab'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ChildCDS_1
      end>
    OutputType = otMultiDataSet
    Left = 216
    Top = 184
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 136
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
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    inherited bbInsert: TdxBarButton
      Visible = ivNever
    end
    inherited bbEdit: TdxBarButton
      Visible = ivNever
    end
    inherited bbErased: TdxBarButton
      Action = mactDelete
    end
    inherited bbUnErased: TdxBarButton
      Visible = ivNever
    end
    object bbProtocol2OpenForm: TdxBarButton
      Action = Protocol2OpenForm
      Category = 0
    end
    object bbProtocol3OpenForm: TdxBarButton
      Action = Protocol3OpenForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
      end
      item
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
    ColorRuleList = <
      item
        ColorColumn = GoodsMainId_1
        BackGroundValueColumn = Color_GoodsMainId
        ColorValueList = <>
      end
      item
        ColorColumn = isTOP_1
        BackGroundValueColumn = Color_isTOP
        ColorValueList = <>
      end
      item
        ColorColumn = isFirst_1
        BackGroundValueColumn = Color_isFirst
        ColorValueList = <>
      end
      item
        ColorColumn = isSecond_1
        BackGroundValueColumn = Color_isSecond
        ColorValueList = <>
      end
      item
        ColorColumn = MinimumLot_1
        BackGroundValueColumn = Color_MinimumLot
        ColorValueList = <>
      end
      item
        ColorColumn = Price_1
        BackGroundValueColumn = Color_Price
        ColorValueList = <>
      end
      item
        ColorColumn = PercentMarkup_1
        BackGroundValueColumn = Color_PercentMarkup
        ColorValueList = <>
      end
      item
        ColorColumn = RetailName_1
        BackGroundValueColumn = Color_RetailId
        ColorValueList = <>
      end
      item
        ColorColumn = UserUpdateName_1
        BackGroundValueColumn = Color_UserUpdateId
        ColorValueList = <>
      end
      item
        ColorColumn = DateUpdate_1
        BackGroundValueColumn = Color_DateUpdate
        ColorValueList = <>
      end
      item
        ColorColumn = UserInsertName_1
        BackGroundValueColumn = Color_UserInsertId
        ColorValueList = <>
      end
      item
        ColorColumn = DateInsert_1
        BackGroundValueColumn = Color_DateInsert
        ColorValueList = <>
      end>
    Left = 296
    Top = 112
  end
  inherited PopupMenu: TPopupMenu
    Left = 696
    Top = 120
    object N9: TMenuItem [5]
      Action = mactListDelete
    end
    object N8: TMenuItem [6]
      Caption = '-'
    end
  end
  inherited spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_LinkGoods'
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ChildCDS_1
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 776
    Top = 96
  end
  object ChildCDS_1: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'Id'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 32
    Top = 256
  end
  object ChildDS_1: TDataSource
    DataSet = ChildCDS_1
    Left = 96
    Top = 248
  end
  object DBViewAddOnChild1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewChild1
    OnDblClickActionList = <
      item
      end
      item
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
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 272
    Top = 248
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actGoodsLinkRefresh
    ComponentList = <
      item
      end>
    Left = 568
    Top = 104
  end
  object dsdStoredProc1: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_LinkGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ChildCDS_1
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 856
    Top = 64
  end
end
