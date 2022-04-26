inherited RecalcMCSShedulerForm: TRecalcMCSShedulerForm
  Caption = #1055#1083#1072#1085#1080#1088#1086#1074#1097#1080#1082' '#1087#1077#1088#1077#1097#1077#1090#1072' '#1053#1058#1047
  ClientHeight = 339
  ClientWidth = 691
  AddOnFormData.isAlwaysRefresh = False
  ExplicitWidth = 707
  ExplicitHeight = 378
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 691
    Height = 280
    ExplicitTop = 59
    ExplicitWidth = 691
    ExplicitHeight = 280
    ClientRectBottom = 280
    ClientRectRight = 691
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 691
      ExplicitHeight = 280
      inherited cxGrid: TcxGrid
        Left = 3
        Width = 688
        Height = 280
        ExplicitLeft = 3
        ExplicitWidth = 688
        ExplicitHeight = 280
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsBehavior.FocusCellOnCycle = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsSelection.InvertSelect = False
          OptionsView.Footer = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Ord: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Ord'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 36
          end
          object PharmacyItem: TcxGridDBColumn
            Caption = #1040#1087#1090'. '#1087#1091#1085#1082#1090
            DataBinding.FieldName = 'PharmacyItem'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UnitCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 34
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 177
          end
          object AllRetail: TcxGridDBColumn
            Caption = #1055#1086' '#1074#1089#1077#1081' '#1089#1077#1090#1080
            DataBinding.FieldName = 'AllRetail'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 54
          end
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1099#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 82
          end
          object AreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085
            DataBinding.FieldName = 'AreaName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 97
          end
          object ProvinceCityName: TcxGridDBColumn
            Caption = #1056#1072#1081#1086#1085
            DataBinding.FieldName = 'ProvinceCityName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object UserName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'UserName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 113
          end
          object DateRun: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1077#1088#1077#1097#1077#1090#1072
            DataBinding.FieldName = 'DateRun'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm.yy hh:nn'
            Properties.Kind = ckDateTime
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 93
          end
          object UserRun: TcxGridDBColumn
            Caption = #1050#1090#1086' '#1087#1077#1088#1077#1089#1095#1080#1090#1072#1083
            DataBinding.FieldName = 'UserRun'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 97
          end
          object DateRunSun: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1077#1088#1077#1097#1077#1090#1072' '#1057#1059#1053
            DataBinding.FieldName = 'DateRunSun'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm.yy hh:nn'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 92
          end
          object SelectRun: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100
            DataBinding.FieldName = 'SelectRun'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 52
          end
          object Period: TcxGridDBColumn
            Caption = #1055#1088#1072#1079#1076#1085#1080#1082
            DataBinding.FieldName = 'Period'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Period1: TcxGridDBColumn
            Caption = #1055#1086#1085#1077#1076#1077#1083#1100#1085#1080#1082
            DataBinding.FieldName = 'Period1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Period2: TcxGridDBColumn
            Caption = #1042#1090#1086#1088#1085#1080#1082
            DataBinding.FieldName = 'Period2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Period3: TcxGridDBColumn
            Caption = #1057#1088#1077#1076#1072
            DataBinding.FieldName = 'Period3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Period4: TcxGridDBColumn
            Caption = #1063#1077#1090#1074#1077#1088#1075
            DataBinding.FieldName = 'Period4'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Period5: TcxGridDBColumn
            Caption = #1055#1103#1090#1085#1080#1094#1072
            DataBinding.FieldName = 'Period5'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Period6: TcxGridDBColumn
            Caption = #1057#1091#1073#1073#1086#1090#1072
            DataBinding.FieldName = 'Period6'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Period7: TcxGridDBColumn
            Caption = #1042#1086#1089#1082#1088#1077#1089#1077#1085#1100#1077
            DataBinding.FieldName = 'Period7'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object PeriodSun1: TcxGridDBColumn
            Caption = #1055#1086#1085#1077#1076#1077#1083#1100#1085#1080#1082' '#1057#1059#1053
            DataBinding.FieldName = 'PeriodSun1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object PeriodSun2: TcxGridDBColumn
            Caption = #1042#1090#1086#1088#1085#1080#1082' '#1057#1059#1053
            DataBinding.FieldName = 'PeriodSun2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object PeriodSun3: TcxGridDBColumn
            Caption = #1057#1088#1077#1076#1072' '#1057#1059#1053
            DataBinding.FieldName = 'PeriodSun3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object PeriodSun4: TcxGridDBColumn
            Caption = #1063#1077#1090#1074#1077#1088#1075' '#1057#1059#1053
            DataBinding.FieldName = 'PeriodSun4'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object PeriodSun5: TcxGridDBColumn
            Caption = #1055#1103#1090#1085#1080#1094#1072' '#1057#1059#1053
            DataBinding.FieldName = 'PeriodSun5'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object PeriodSun6: TcxGridDBColumn
            Caption = #1057#1091#1073#1073#1086#1090#1072' '#1057#1059#1053
            DataBinding.FieldName = 'PeriodSun6'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object PeriodSun7: TcxGridDBColumn
            Caption = #1042#1086#1089#1082#1088#1077#1089#1077#1085#1100#1077' '#1057#1059#1053
            DataBinding.FieldName = 'PeriodSun7'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isErased: TcxGridDBColumn
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
          end
          object Color_cal: TcxGridDBColumn
            DataBinding.FieldName = 'Color_cal'
            Visible = False
            Options.Editing = False
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 0
        Width = 3
        Height = 280
        Control = cxGrid
      end
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 691
    Height = 33
    Align = alTop
    ShowCaption = False
    TabOrder = 5
    object edBeginHolidays: TcxDateEdit
      Left = 188
      Top = 7
      EditValue = 32874d
      TabOrder = 0
      Width = 100
    end
    object cxLabel2: TcxLabel
      Left = 14
      Top = 8
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1087#1088#1072#1079#1076#1085#1080#1095#1085#1099#1093' '#1076#1085#1077#1081
    end
    object edEndHolidays: TcxDateEdit
      Left = 458
      Top = 7
      EditValue = 32874d
      TabOrder = 2
      Width = 100
    end
    object cxLabel1: TcxLabel
      Left = 302
      Top = 8
      Caption = #1055#1086#1089#1083#1077#1076#1085#1080#1081' '#1076#1077#1085#1100' '#1087#1088#1072#1079#1076#1085#1080#1082#1086#1074
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
      end>
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spGetHolidays
        end>
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TRecalcMCSShedulerEditForm'
      FormNameParam.Value = 'TRecalcMCSShedulerEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TRecalcMCSShedulerEditForm'
      FormNameParam.Value = 'TRecalcMCSShedulerEditForm'
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
          Name = 'UnitId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actAddUnit: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenUnitTree
        end
        item
          Action = actRefresh
        end
        item
          Action = actOpenRecalcMCSShedulerEdit
        end>
      Caption = 'actAddUnit'
      ImageIndex = 0
    end
    object actOpenUnitTree: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenUnitTree'
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = 'TUnitTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'UnitID'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenRecalcMCSShedulerEdit: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actOpenRecalcMCSShedulerEdit'
      FormName = 'TRecalcMCSShedulerEditForm'
      FormNameParam.Value = 'TRecalcMCSShedulerEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitID'
          Value = Null
          Component = FormParams
          ComponentItem = 'UnitID'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object spInsertUpdateMovement: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateHolidays
      StoredProcList = <
        item
          StoredProc = spUpdateHolidays
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1077#1085#1080#1103' '#1087#1077#1088#1080#1086#1076#1072' '#1087#1088#1072#1079#1076#1085#1080#1082#1086#1074
      Hint = #1057#1086#1093#1088#1072#1085#1077#1085#1077#1085#1080#1103' '#1087#1077#1088#1080#1086#1076#1072' '#1087#1088#1072#1079#1076#1085#1080#1082#1086#1074
      ImageIndex = 14
      ShortCut = 113
    end
    object actRecalcMCSSheduler: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spRecalcMCSSheduler
      StoredProcList = <
        item
          StoredProc = spRecalcMCSSheduler
        end>
      Caption = #1055#1077#1088#1077#1089#1095#1077#1090' '#1053#1058#1047' '#1086' '#1074#1089#1077#1084' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      Hint = #1055#1077#1088#1077#1089#1095#1077#1090' '#1053#1058#1047' '#1086' '#1074#1089#1077#1084' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      ImageIndex = 38
      QuestionBeforeExecute = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1087#1077#1088#1077#1089#1095#1077#1090' '#1053#1058#1047' '#1086' '#1074#1089#1077#1084' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
    end
    object actRecalcMCSShedulerSelect: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spRecalcMCSShedulerSelect
      StoredProcList = <
        item
          StoredProc = spRecalcMCSShedulerSelect
        end>
      Caption = #1055#1077#1088#1077#1089#1095#1077#1090' '#1053#1058#1047' '#1087#1086' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1084' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      Hint = #1055#1077#1088#1077#1089#1095#1077#1090' '#1053#1058#1047' '#1087#1086' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1084' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      ImageIndex = 79
      QuestionBeforeExecute = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1100' '#1087#1077#1088#1077#1089#1095#1077#1090' '#1053#1058#1047' '#1087#1086' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1084' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SelectRun
      StoredProcList = <
        item
          StoredProc = spUpdate_SelectRun
        end>
      Caption = 'actUpdateDataSet'
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
    object actExecuteSunDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteSunDialog'
      FormName = 'TRecalcMCSShedulerSunDialogForm'
      FormNameParam.Value = 'TRecalcMCSShedulerSunDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodSun1'
          Value = '0'
          Component = FormParams
          ComponentItem = 'PeriodSun1'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodSun2'
          Value = '0'
          Component = FormParams
          ComponentItem = 'PeriodSun2'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodSun3'
          Value = '0'
          Component = FormParams
          ComponentItem = 'PeriodSun3'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodSun4'
          Value = '0'
          Component = FormParams
          ComponentItem = 'PeriodSun4'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodSun5'
          Value = '0'
          Component = FormParams
          ComponentItem = 'PeriodSun5'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodSun6'
          Value = '0'
          Component = FormParams
          ComponentItem = 'PeriodSun6'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodSun7'
          Value = '0'
          Component = FormParams
          ComponentItem = 'PeriodSun7'
          MultiSelectSeparator = ','
        end
        item
          Name = 'DaySun1'
          Value = '0'
          Component = FormParams
          ComponentItem = 'DaySun1'
          MultiSelectSeparator = ','
        end
        item
          Name = 'DaySun2'
          Value = '0'
          Component = FormParams
          ComponentItem = 'DaySun2'
          MultiSelectSeparator = ','
        end
        item
          Name = 'DaySun3'
          Value = '0'
          Component = FormParams
          ComponentItem = 'DaySun3'
          MultiSelectSeparator = ','
        end
        item
          Name = 'DaySun4'
          Value = '0'
          Component = FormParams
          ComponentItem = 'DaySun4'
          MultiSelectSeparator = ','
        end
        item
          Name = 'DaySun5'
          Value = '0'
          Component = FormParams
          ComponentItem = 'DaySun5'
          MultiSelectSeparator = ','
        end
        item
          Name = 'DaySun6'
          Value = '0'
          Component = FormParams
          ComponentItem = 'DaySun6'
          MultiSelectSeparator = ','
        end
        item
          Name = 'DaySun7'
          Value = '0'
          Component = FormParams
          ComponentItem = 'DaySun7'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdateSun: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actExecuteSunDialog
      ActionList = <
        item
          Action = actExecSPUpdateactSun
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1076#1083#1103' '#1087#1077#1088#1077#1089#1095#1077#1090#1072' '#1087#1086' '#1057#1059#1053
      Hint = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1076#1083#1103' '#1087#1077#1088#1077#1089#1095#1077#1090#1072' '#1087#1086' '#1057#1059#1053
      ImageIndex = 42
    end
    object actExecSPUpdateactSun: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateactSun
      StoredProcList = <
        item
          StoredProc = spUpdateactSun
        end>
      Caption = 'actExecSPUpdateactSun'
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
    object actExecuteDialogMain: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDialogMain'
      FormName = 'TRecalcMCSShedulerMainDialogForm'
      FormNameParam.Value = 'TRecalcMCSShedulerMainDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Period1'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Period1'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Period2'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Period2'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Period3'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Period3'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Period4'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Period4'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Period5'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Period5'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Period6'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Period6'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Period7'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Period7'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Day1'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Day1'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Day2'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Day2'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Day3'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Day3'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Day4'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Day4'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Day5'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Day5'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Day6'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Day6'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Day7'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Day7'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdateMain: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actExecuteDialogMain
      ActionList = <
        item
          Action = actExecSPUpdateactMain
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1076#1083#1103' '#1086#1089#1085#1086#1074#1085#1086#1075#1086' '#1087#1077#1088#1077#1089#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1076#1083#1103' '#1086#1089#1085#1086#1074#1085#1086#1075#1086' '#1087#1077#1088#1077#1089#1095#1077#1090#1072
      ImageIndex = 42
    end
    object actExecSPUpdateactMain: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateactMain
      StoredProcList = <
        item
          StoredProc = spUpdateactMain
        end>
      Caption = 'actExecSPUpdateactSun'
    end
    object actReport_RecalcMCS: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1088#1086#1074#1077#1088#1082#1072' '#1088#1072#1089#1095#1077#1090#1072' '#1053#1058#1047
      Hint = #1054#1090#1095#1077#1090' '#1087#1088#1086#1074#1077#1088#1082#1072' '#1088#1072#1089#1095#1077#1090#1072' '#1053#1058#1047
      ImageIndex = 3
      FormName = 'TReport_RecalcMCSForm'
      FormNameParam.Value = 'TReport_RecalcMCSForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = '0'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 72
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Top = 96
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_RecalcMCSSheduler'
    Params = <
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
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
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton9'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton11'
        end
        item
          Visible = True
          ItemName = 'dxBarButton10'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReport_RecalcMCS'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      Left = 368
      Top = 112
    end
    object bbSetErased: TdxBarButton
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      Category = 0
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1077#1088#1077#1097#1077#1090#1072' '#1053#1058#1047
      Visible = ivAlways
      ImageIndex = 2
      ShortCut = 46
    end
    object bbUnErased: TdxBarButton
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1077#1088#1077#1097#1077#1090#1072' '#1053#1058#1047
      Visible = ivAlways
      ImageIndex = 8
      ShortCut = 32776
    end
    object bbSetErasedChild: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 2
      ShortCut = 46
    end
    object bbUnErasedChild: TdxBarButton
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088
      Category = 0
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 8
      ShortCut = 32776
    end
    object bbdsdChoiceGuides: TdxBarButton
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Category = 0
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Visible = ivAlways
      ImageIndex = 7
    end
    object dxBarButton1: TdxBarButton
      Action = actAddUnit
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Caption = 'MultiAction1'
      Category = 0
      Visible = ivAlways
      ImageIndex = 2
    end
    object dxBarButton4: TdxBarButton
      Caption = 'MultiAction2'
      Category = 0
      Visible = ivAlways
      ImageIndex = 8
    end
    object dxBarButton5: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object bbInsertUpdateMovement: TdxBarButton
      Action = spInsertUpdateMovement
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actRecalcMCSSheduler
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = actRecalcMCSShedulerSelect
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
    end
    object dxBarButton9: TdxBarButton
      Action = dsdSetErased
      Category = 0
    end
    object dxBarButton10: TdxBarButton
      Action = actUpdateSun
      Category = 0
    end
    object bbShowErased: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object dxBarButton11: TdxBarButton
      Action = actUpdateMain
      Category = 0
    end
    object bbReport_RecalcMCS: TdxBarButton
      Action = actReport_RecalcMCS
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actUpdate
      end>
    ColorRuleList = <
      item
        BackGroundValueColumn = Color_cal
        ColorValueList = <>
      end>
    Left = 280
    Top = 192
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitID'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IdAdd'
        Value = '1'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period1'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period2'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period3'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period4'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period5'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period6'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period7'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day1'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day2'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day3'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day4'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day5'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day6'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day7'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PeriodSun1'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PeriodSun2'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PeriodSun3'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PeriodSun4'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PeriodSun5'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PeriodSun6'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PeriodSun7'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DaySun1'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DaySun2'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DaySun3'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DaySun4'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DaySun5'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DaySun6'
        Value = '0'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DaySun7'
        Value = '0'
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 72
  end
  object spGetHolidays: TdsdStoredProc
    StoredProcName = 'gpGet_Object_RecalcMCSSheduler_Holidays'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'BeginHolidays'
        Value = Null
        Component = edBeginHolidays
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndHolidays'
        Value = Null
        Component = edEndHolidays
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 104
  end
  object spUpdateHolidays: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_RecalcMCSSheduler_Holidays'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inBeginHolidays'
        Value = 42132d
        Component = edBeginHolidays
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndHolidays'
        Value = 42132d
        Component = edEndHolidays
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 152
  end
  object HeaderSaver: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'IdAdd'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spUpdateHolidays
    ControlList = <
      item
        Control = edBeginHolidays
      end
      item
        Control = edEndHolidays
      end>
    GetStoredProc = spGetHolidays
    Left = 448
    Top = 105
  end
  object spRecalcMCSSheduler: TdsdStoredProc
    StoredProcName = 'gpRun_Object_RecalcMCSSheduler'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inCalcType'
        Value = '3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 544
    Top = 112
  end
  object spRecalcMCSShedulerSelect: TdsdStoredProc
    StoredProcName = 'gpRun_Object_RecalcMCSShedulerSelect'
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 544
    Top = 168
  end
  object spUpdate_SelectRun: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_RecalcMCSSheduler'
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
        Name = 'inSelectRun'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SelectRun'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSelectRun'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SelectRun'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 544
    Top = 232
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
    Left = 176
    Top = 152
  end
  object spUpdateactSun: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_RecalcMCSSheduler_Sun'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriodSun1'
        Value = Null
        Component = FormParams
        ComponentItem = 'PeriodSun1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriodSun2'
        Value = Null
        Component = FormParams
        ComponentItem = 'PeriodSun2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriodSun3'
        Value = Null
        Component = FormParams
        ComponentItem = 'PeriodSun3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriodSun4'
        Value = Null
        Component = FormParams
        ComponentItem = 'PeriodSun4'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriodSun5'
        Value = Null
        Component = FormParams
        ComponentItem = 'PeriodSun5'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriodSun6'
        Value = Null
        Component = FormParams
        ComponentItem = 'PeriodSun6'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriodSun7'
        Value = Null
        Component = FormParams
        ComponentItem = 'PeriodSun7'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDaySun1'
        Value = Null
        Component = FormParams
        ComponentItem = 'DaySun1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDaySun2'
        Value = Null
        Component = FormParams
        ComponentItem = 'DaySun2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDaySun3'
        Value = Null
        Component = FormParams
        ComponentItem = 'DaySun3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDaySun4'
        Value = Null
        Component = FormParams
        ComponentItem = 'DaySun4'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDaySun5'
        Value = Null
        Component = FormParams
        ComponentItem = 'DaySun5'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDaySun6'
        Value = Null
        Component = FormParams
        ComponentItem = 'DaySun6'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDaySun7'
        Value = Null
        Component = FormParams
        ComponentItem = 'DaySun7'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 360
    Top = 224
  end
  object spUpdateactMain: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_RecalcMCSSheduler_Main'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod1'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Period1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod2'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Period2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod3'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Period3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod4'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Period4'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod5'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Period5'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod6'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Period6'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod7'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Period7'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay1'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Day1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay2'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Day2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay3'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Day3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay4'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Day4'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay5'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Day5'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay6'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Day6'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay7'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Day7'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 360
    Top = 280
  end
end
