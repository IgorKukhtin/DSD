inherited ImportSettingsForm: TImportSettingsForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1080#1084#1087#1086#1088#1090#1072'>'
  ClientHeight = 339
  ClientWidth = 1184
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 1200
  ExplicitHeight = 377
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1184
    Height = 313
    ExplicitWidth = 1184
    ExplicitHeight = 313
    ClientRectBottom = 313
    ClientRectRight = 1184
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1184
      ExplicitHeight = 313
      inherited cxGrid: TcxGrid
        Width = 697
        Height = 313
        Align = alLeft
        ExplicitWidth = 697
        ExplicitHeight = 313
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Inserting = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Width = 34
          end
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            Width = 97
          end
          object clDirectory: TcxGridDBColumn
            Caption = #1057#1090#1088#1086#1082#1072' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'Directory'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = FileDialogAction
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            Width = 84
          end
          object clJuridicalName: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1082#1090
            DataBinding.FieldName = 'JuridicalName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = LoadObjectChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            Width = 67
          end
          object clContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ContractChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            Width = 61
          end
          object clFileTypeName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1087#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'FileTypeName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = FileTypeKindChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            Width = 90
          end
          object clImportTypeName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1080#1084#1087#1086#1088#1090#1072
            DataBinding.FieldName = 'ImportTypeName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ImportType
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            Width = 56
          end
          object clStartRow: TcxGridDBColumn
            Caption = #8470' '#1089#1090#1088#1086#1082#1080' '#1076#1083#1103' Excel'
            DataBinding.FieldName = 'StartRow'
            HeaderAlignmentHorz = taCenter
            Width = 71
          end
          object clQuery: TcxGridDBColumn
            Caption = #1047#1072#1087#1088#1086#1089
            DataBinding.FieldName = 'Query'
            PropertiesClassName = 'TcxBlobEditProperties'
            Properties.BlobPaintStyle = bpsText
            HeaderAlignmentHorz = taCenter
            Width = 58
          end
          object clHDR: TcxGridDBColumn
            DataBinding.FieldName = 'HDR'
            HeaderAlignmentHorz = taCenter
            Width = 46
          end
          object clStartTime: TcxGridDBColumn
            Caption = #1042#1088#1077#1084#1103' '#1085#1072#1095'.  '#1087#1088#1086#1074#1077#1088#1082#1080
            DataBinding.FieldName = 'StartTime'
            PropertiesClassName = 'TcxTimeEditProperties'
            Properties.TimeFormat = tfHourMin
            Properties.UseLeftAlignmentOnEditing = False
            HeaderAlignmentHorz = taCenter
            HeaderHint = #1042#1088#1077#1084#1103' '#1085#1072#1095#1072#1083#1072' '#1072#1082#1090#1080#1074#1085#1086#1081' '#1087#1088#1086#1074#1077#1088#1082#1080
            Width = 77
          end
          object clEndTime: TcxGridDBColumn
            Caption = #1042#1088#1077#1084#1103' '#1086#1082#1086#1085'. '#1087#1088#1086#1074#1077#1088#1082#1080
            DataBinding.FieldName = 'EndTime'
            PropertiesClassName = 'TcxTimeEditProperties'
            Properties.TimeFormat = tfHourMin
            HeaderAlignmentHorz = taCenter
            HeaderHint = #1042#1088#1077#1084#1103' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1072#1082#1090#1080#1074#1085#1086#1081' '#1087#1088#1086#1074#1077#1088#1082#1080
            Width = 83
          end
          object clCheckTime: TcxGridDBColumn
            Caption = #1055#1077#1088#1080#1086#1076#1080#1095#1085#1086#1089#1100' ('#1084#1080#1085'.)'
            DataBinding.FieldName = 'CheckTime'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderHint = #1057' '#1082#1072#1082#1086#1081' '#1087#1077#1088#1080#1086#1076#1080#1095#1085#1086#1089#1090#1100#1102' '#1087#1088#1086#1074#1077#1088#1103#1090#1100' '#1087#1086#1095#1090#1091' '#1074' '#1072#1082#1090#1080#1074#1085#1086#1084' '#1087#1077#1088#1080#1086#1076#1077', '#1084#1080#1085
            Width = 99
          end
          object clContactPersonName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1072#1082#1090#1085#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'ContactPersonName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ContactPersonChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            Width = 70
          end
          object clContactPersonMail: TcxGridDBColumn
            Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1087#1086#1095#1090#1072
            DataBinding.FieldName = 'ContactPersonMail'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 70
          end
          object clEmailName: TcxGridDBColumn
            Caption = #1055#1086#1095#1090#1086#1074#1099#1081' '#1103#1097#1080#1082
            DataBinding.FieldName = 'EmailName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = EmailChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            Width = 80
          end
          object clEmailKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1087#1086#1095#1090#1099
            DataBinding.FieldName = 'EmailKindName'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 80
          end
          object isMultiLoad: TcxGridDBColumn
            Caption = #1047#1072#1075#1088#1091#1078#1072#1090#1100' '#1055#1088#1072#1081#1089' > 1 '#1088#1072#1079#1072
            DataBinding.FieldName = 'isMultiLoad'
            HeaderAlignmentHorz = taCenter
            Width = 80
          end
          object clisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Width = 53
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 700
        Top = 0
        Width = 484
        Height = 313
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
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
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object colParamNumber: TcxGridDBColumn
            Caption = #8470' '#1087#1087
            DataBinding.FieldName = 'ParamNumber'
            Options.Editing = False
            SortIndex = 0
            SortOrder = soAscending
            Width = 47
          end
          object clParamName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
            DataBinding.FieldName = 'ParamName'
            Visible = False
            Options.Editing = False
            Width = 101
          end
          object colUserParamName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
            DataBinding.FieldName = 'UserParamName'
            Options.Editing = False
            Width = 129
          end
          object colParamValue: TcxGridDBColumn
            Caption = #1048#1089#1090#1086#1095#1085#1080#1082' '#1076#1072#1085#1085#1099#1093
            DataBinding.FieldName = 'ParamValue'
            PropertiesClassName = 'TcxComboBoxProperties'
            Properties.DropDownAutoWidth = False
            Properties.Items.Strings = (
              '%OBJECT%'
              '%CONTRACT%'
              '%LASTRECORD%'
              '%EXTERNALPARAM%')
            Width = 113
          end
          object colDefaultValue: TcxGridDBColumn
            Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
            DataBinding.FieldName = 'DefaultValue'
            Width = 95
          end
          object clIisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Options.Editing = False
            Width = 48
          end
          object colConvertFormatInExcel: TcxGridDBColumn
            Caption = #1050#1086#1085#1074#1077#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1092#1086#1088#1084#1072#1090' '#1074' Excel'
            DataBinding.FieldName = 'ConvertFormatInExcel'
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 697
        Top = 0
        Width = 3
        Height = 313
        AutoPosition = False
        Control = cxGrid
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 67
    Top = 168
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cxGrid
        Properties.Strings = (
          'Width')
      end
      item
        Component = cxGrid1
        Properties.Strings = (
          'Width')
      end>
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
    end
    object dsdUpdateMaster: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateImportType
      StoredProcList = <
        item
          StoredProc = spInsertUpdateImportType
        end>
      Caption = 'dsdUpdate'
      DataSource = MasterDS
    end
    object dsdUpdateChild: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateImportTypeItems
      StoredProcList = <
        item
          StoredProc = spInsertUpdateImportTypeItems
        end>
      Caption = 'dsdUpdateChild'
      DataSource = ChildDS
    end
    object dsdSetErasedChild: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedChild
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedChild
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ChildDS
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
    object dsdUnErasedChild: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedChild
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedChild
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ChildDS
    end
    object dsdUnErased: TdsdUpdateErased
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
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
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
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
    end
    object FileTypeKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'FileTypeKindChoiceForm'
      FormName = 'TFileTypeKindForm'
      FormNameParam.Value = 'TFileTypeKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FileTypeId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FileTypeName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object ContactPersonChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContactPersonChoiceForm'
      FormName = 'TContactPersonForm'
      FormNameParam.Value = 'TContactPersonForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContactPersonId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContactPersonName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Mail'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContactPersonMail'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object ContractChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'JuridicalChoiceForm'
      FormName = 'TContractForm'
      FormNameParam.Value = 'TContractForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object LoadObjectChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'JuridicalChoiceForm'
      FormName = 'TLoadObjectForm'
      FormNameParam.Value = 'TLoadObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object FileDialogAction: TFileDialogAction
      Category = 'DSDLib'
      MoveParams = <>
      FileOpenDialog.FavoriteLinks = <>
      FileOpenDialog.FileTypes = <>
      FileOpenDialog.Options = [fdoPickFolders]
      Param.Value = Null
      Param.Component = MasterCDS
      Param.ComponentItem = 'Directory'
      Param.DataType = ftString
      Param.MultiSelectSeparator = ','
    end
    object ImportType: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ImportType'
      FormName = 'TImportTypeForm'
      FormNameParam.Value = 'TImportTypeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ImportTypeId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ImportTypeName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actAfterScroll: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectItems
      StoredProcList = <
        item
          StoredProc = spSelectItems
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
      DataSet = MasterCDS
    end
    object actProtocolChild: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083' <'#1053#1072#1079#1074#1072#1085#1080#1103'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083' <'#1053#1072#1079#1074#1072#1085#1080#1103'>'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'UserParamName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actProtocolMaster: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083' <'#1053#1072#1079#1074#1072#1085#1080#1103'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083' <'#1053#1072#1079#1074#1072#1085#1080#1103'>'
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
    object EmailChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'EmailForm'
      FormName = 'TEmailForm'
      FormNameParam.Value = 'TEmailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'EmailId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'EmailName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'EmailKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'EmailKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'EmailKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'EmailKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
  end
  inherited MasterDS: TDataSource
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Top = 96
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ImportSettings'
    Left = 104
    Top = 64
  end
  inherited BarManager: TdxBarManager
    Left = 176
    Top = 80
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
          ItemName = 'bbSetErased'
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolMaster'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolChild'
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
    object bbSetErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1058#1080#1087' '#1080#1084#1087#1086#1088#1090#1072
    end
    object bbUnErased: TdxBarButton
      Action = dsdUnErased
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1058#1080#1087' '#1080#1084#1087#1086#1088#1090#1072
    end
    object bbSetErasedChild: TdxBarButton
      Action = dsdSetErasedChild
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      Category = 0
    end
    object bbUnErasedChild: TdxBarButton
      Action = dsdUnErasedChild
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      Category = 0
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbProtocolMaster: TdxBarButton
      Action = actProtocolMaster
      Category = 0
    end
    object bbProtocolChild: TdxBarButton
      Action = actProtocolChild
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083' <'#1076#1077#1090#1072#1083#1080'>'
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 280
    Top = 192
  end
  object spInsertUpdateImportType: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ImportSettings'
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
        Name = 'inCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Code'
        ParamType = ptInput
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
        Name = 'inContractId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFileTypeId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FileTypeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inImportTypeId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ImportTypeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmailId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'EmailId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContactPersonId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContactPersonId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartRow'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StartRow'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHDR'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'HDR'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDirectory'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Directory'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inQuery'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Query'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartTime'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StartTime'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndTime'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'EndTime'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTime'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CheckTime'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsMultiLoad'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isMultiLoad'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 232
    Top = 123
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 632
    Top = 64
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 688
    Top = 72
  end
  object spSelectItems: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ImportSettingsItems'
    DataSet = ChildCDS
    DataSets = <
      item
        DataSet = ChildCDS
      end>
    Params = <
      item
        Name = 'inImportSettingsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 784
    Top = 80
  end
  object spInsertUpdateImportTypeItems: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ImportSettingsItems'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ParamValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inImportSettingsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inImportTypeItemsId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ImportTypeItemsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDefaultValue'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'DefaultValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inConvertFormatInExcel'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'ConvertFormatInExcel'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 792
    Top = 155
  end
  object dsdDBViewAddOnItems: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 648
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
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 192
    Top = 192
  end
  object spErasedUnErasedChild: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 632
    Top = 136
  end
end
