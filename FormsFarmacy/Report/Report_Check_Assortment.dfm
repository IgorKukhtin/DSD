inherited Report_Check_AssortmentForm: TReport_Check_AssortmentForm
  Caption = #1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090' '#1089#1077#1090#1080
  ClientHeight = 477
  ClientWidth = 1251
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1267
  ExplicitHeight = 515
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 1251
    Height = 418
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 1251
    ExplicitHeight = 418
    ClientRectBottom = 418
    ClientRectRight = 1251
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1251
      ExplicitHeight = 418
      inherited cxGrid: TcxGrid
        Width = 1251
        Height = 418
        ExplicitWidth = 1251
        ExplicitHeight = 418
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummaSale
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
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
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummaSale
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
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
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object CountUnit: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1090#1086#1095#1077#1082
            DataBinding.FieldName = 'CountUnit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1090#1086#1095#1077#1082', '#1085#1072' '#1082#1086#1090#1086#1088#1099#1093' '#1087#1088#1086#1076#1072#1077#1090#1089#1103' '#1087#1088#1077#1087#1072#1088#1072#1090
            Options.Editing = False
            Width = 56
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 108
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsId: TcxGridDBColumn
            Caption = #1048#1044' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsId'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 27
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 151
          end
          object NDS: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object MCS_Value: TcxGridDBColumn
            Caption = #1053#1058#1047' ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'MCS_Value'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object PriceSale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'PriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object SummaSale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'SummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ConditionsKeepName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'ConditionsKeepName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object isClose: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090' '#1082#1086#1076' '#1087#1086' '#1074#1089#1077#1081' '#1089#1077#1090#1080
            DataBinding.FieldName = 'IsClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 67
          end
          object MCSNotRecalc: TcxGridDBColumn
            Caption = #1057#1087#1077#1094#1082#1086#1085#1090#1088#1086#1083#1100' '#1082#1086#1076#1072
            DataBinding.FieldName = 'MCSNotRecalc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'. '#1090#1086#1074#1072#1088#1072')'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object MCSIsClose: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' '#1082#1086#1076
            DataBinding.FieldName = 'MCSIsClose'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 50
          end
          object MCSIsCloseDateChange: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' "'#1091#1076#1072#1083#1077#1085' '#1082#1086#1076'"'
            DataBinding.FieldName = 'MCSIsCloseDateChange'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 58
          end
          object isFirst: TcxGridDBColumn
            Caption = '1-'#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isFirst'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 60
          end
          object isSecond: TcxGridDBColumn
            Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isSecond'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 60
          end
          object isPromo: TcxGridDBColumn
            Caption = #1052#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090
            DataBinding.FieldName = 'isPromo'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Properties.AllowGrayed = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object isSp: TcxGridDBColumn
            Caption = #1057#1086#1094'. '#1087#1088#1086#1077#1082#1090
            DataBinding.FieldName = 'isSp'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042' '#1089#1087#1080#1089#1082#1077' '#1087#1088#1086#1077#1082#1090#1072' '#171#1044#1086#1089#1090#1091#1087#1085#1099#1077' '#1083#1077#1082#1072#1088#1089#1090#1074#1072#187
            Options.Editing = False
            Width = 60
          end
          object isTop: TcxGridDBColumn
            Caption = #1058#1054#1055' ('#1087#1086' '#1089#1077#1090#1080')'
            DataBinding.FieldName = 'isTop'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 60
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1251
    Height = 33
    ExplicitWidth = 1251
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 21
      EditValue = 42979d
      ExplicitLeft = 21
      ExplicitWidth = 78
      Width = 78
    end
    inherited deEnd: TcxDateEdit
      Left = 126
      EditValue = 42979d
      ExplicitLeft = 126
      ExplicitWidth = 79
      Width = 79
    end
    inherited cxLabel1: TcxLabel
      Left = 2
      Caption = #1057':'
      ExplicitLeft = 2
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 105
      Caption = #1087#1086':'
      ExplicitLeft = 105
      ExplicitWidth = 20
    end
    object cxLabel3: TcxLabel
      Left = 212
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object ceUnit: TcxButtonEdit
      Left = 299
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 5
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Width = 188
    end
    object cbList: TcxCheckBox
      Left = 488
      Top = 5
      Action = actRefreshList
      TabOrder = 6
      Width = 129
    end
    object cxLabel4: TcxLabel
      Left = 628
      Top = 6
      Caption = #1053#1058#1047' '#1076#1083#1103' '#1087#1077#1088#1080#1086#1076#1072
    end
    object cbisMCSAuto: TcxCheckBox
      Left = 718
      Top = 5
      Properties.ReadOnly = False
      TabOrder = 8
      Width = 22
    end
    object cxLabel8: TcxLabel
      Left = 746
      Top = 6
      Caption = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1087#1077#1088#1080#1086#1076#1072
    end
    object ceDays: TcxCurrencyEdit
      Left = 858
      Top = 5
      EditValue = 7.000000000000000000
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      TabOrder = 10
      Width = 26
    end
    object ceMCSValue: TcxCurrencyEdit
      Left = 959
      Top = 5
      EditValue = 0.000000000000000000
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      TabOrder = 11
      Width = 23
    end
  end
  object cxLabel5: TcxLabel [2]
    Left = 897
    Top = 6
    Caption = #1050#1086#1083'-'#1074#1086' '#1053#1058#1047
  end
  inherited ActionList: TActionList
    object actGetImportSetting_MCSExcel: TdsdExecStoredProc [0]
      Category = 'LoadMCS'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting_MCSExcel
      StoredProcList = <
        item
          StoredProc = spGetImportSetting_MCSExcel
        end>
      Caption = 'actGetImportSetting_MCS'
    end
    object macDeleteDataExcel: TMultiAction [1]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actDeleteDataExcel
        end>
      QuestionBeforeExecute = #1054#1095#1080#1089#1090#1080#1090#1100' '#1089#1086#1093#1088#1072#1085#1077#1085#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1053#1058#1047'?'
      InfoAfterExecute = #1057#1086#1093#1088#1072#1085#1077#1085#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1053#1058#1047' '#1086#1095#1080#1097#1077#1085#1099
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1089#1086#1093#1088#1072#1085#1077#1085#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1053#1058#1047
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1089#1086#1093#1088#1072#1085#1077#1085#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1053#1058#1047
      ImageIndex = 46
    end
    object actDoLoadMCSExcel: TExecuteImportSettingsAction [2]
      Category = 'LoadMCS'
      MoveParams = <>
      ImportSettingsId.Value = '0'
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId_MCSExcel'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inUnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end>
    end
    object actDeleteDataExcel: TdsdExecStoredProc [3]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDeleteDataExcel
      StoredProcList = <
        item
          StoredProc = spDeleteDataExcel
        end>
      Caption = 'actDeleteDataExcel'
    end
    object macStartLoadMCSExcel: TMultiAction [5]
      Category = 'LoadMCS'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_MCSExcel
        end
        item
          Action = actDoLoadMCSExcel
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1053#1058#1047' '#1080#1079' Excel '#1074' '#1090#1072#1073#1083#1080#1094#1091' '#1086#1090#1095#1077#1090#1072'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1053#1058#1047'  '#1080#1079' Excel '
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1053#1058#1047'  '#1080#1079' Excel '
      ImageIndex = 30
    end
    object actDoLoadMCS: TExecuteImportSettingsAction [6]
      Category = 'LoadMCS'
      MoveParams = <>
      ImportSettingsId.Value = '0'
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId_MCS'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inUnitId'
          Value = '0'
          Component = GuidesUnit
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end>
    end
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshList: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1058#1054#1051#1068#1050#1054' '#1055#1054' '#1057#1055#1048#1057#1050#1059
      Hint = #1058#1054#1051#1068#1050#1054' '#1055#1054' '#1057#1055#1048#1057#1050#1059
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshJuridical: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      Hint = #1087#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshPartionPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1072#1088#1090#1080#1080' '#1094#1077#1085#1099
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1072#1088#1090#1080#1080' '#1094#1077#1085#1099
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshIsPartion: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Check_AssortmentDialogForm'
      FormNameParam.Value = 'TReport_Check_AssortmentDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisList'
          Value = Null
          Component = cbList
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'JuridicalName;GoodsName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actInsert_MCS: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_MCS_byReport
      StoredProcList = <
        item
          StoredProc = spInsert_MCS_byReport
        end>
      Caption = 'actInsert_MCS'
      ImageIndex = 74
    end
    object macInsert_MCS_List: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsert_MCS
        end>
      View = cxGridDBTableView
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1053#1058#1047' '#1074' '#1090#1072#1073#1083#1080#1094#1091
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1053#1058#1047' '#1074' '#1090#1072#1073#1083#1080#1094#1091
      ImageIndex = 74
    end
    object macInsert_MCS: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macInsert_MCS_List
        end>
      QuestionBeforeExecute = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1053#1058#1047' '#1074' '#1090#1072#1073#1083#1080#1094#1091'?'
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' '#1053#1058#1047' '#1087#1077#1088#1077#1085#1077#1089#1077#1085#1086' '#1074' '#1090#1072#1073#1083#1080#1094#1091
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1053#1058#1047' '#1074' '#1090#1072#1073#1083#1080#1094#1091
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1053#1058#1047' '#1074' '#1090#1072#1073#1083#1080#1094#1091
      ImageIndex = 74
    end
    object actUpdate_Price_MCS: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Price_MCS
      StoredProcList = <
        item
          StoredProc = spUpdate_Price_MCS
        end>
      Caption = 'actUpdate_Price_MCS'
      ImageIndex = 27
    end
    object macUpdate_Price_MCS_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Price_MCS
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1053#1058#1047
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1053#1058#1047
      ImageIndex = 27
    end
    object macUpdate_Price_MCS: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_Price_MCS_list
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1103' '#1053#1058#1047'?'
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' '#1053#1058#1047' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1053#1058#1047
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1053#1058#1047
      ImageIndex = 27
    end
    object actGetImportSetting_MCS: TdsdExecStoredProc
      Category = 'LoadMCS'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting_MCS
      StoredProcList = <
        item
          StoredProc = spGetImportSetting_MCS
        end>
      Caption = 'actGetImportSetting_MCS'
    end
    object actStartLoadMCS: TMultiAction
      Category = 'LoadMCS'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_MCS
        end
        item
          Action = actDoLoadMCS
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1053#1058#1047' '#1085#1072' '#1074#1099#1073#1088#1072#1085#1085#1086#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1053#1058#1047
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1053#1058#1047
      ImageIndex = 41
    end
  end
  inherited MasterDS: TDataSource
    Left = 48
    Top = 160
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 160
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Check_Assortment'
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateStart'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateFinal'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisUnitList'
        Value = Null
        Component = cbList
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 200
  end
  inherited BarManager: TdxBarManager
    Left = 144
    Top = 160
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
          ItemName = 'bbExecuteDialog'
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
          ItemName = 'bbInsert_MCS'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Price_MCS'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStartLoadMCSExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbbdxBarButton2'
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
          ItemName = 'bbGridToExcel'
        end>
    end
    object dxBarButton1: TdxBarButton
      Caption = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Category = 0
      Hint = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Visible = ivAlways
      ImageIndex = 38
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbUpdate_Price_MCS: TdxBarButton
      Action = macUpdate_Price_MCS
      Category = 0
    end
    object bbInsert_MCS: TdxBarButton
      Action = macInsert_MCS
      Category = 0
    end
    object bbStartLoad: TdxBarButton
      Action = actStartLoadMCS
      Category = 0
    end
    object bbStartLoadMCSExcel: TdxBarButton
      Action = macStartLoadMCSExcel
      Category = 0
    end
    object bbbdxBarButton2: TdxBarButton
      Action = macDeleteDataExcel
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 496
    Top = 152
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 224
    Top = 128
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesUnit
      end
      item
      end>
    Left = 464
    Top = 208
  end
  object rdUnit: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesUnit
      end>
    Left = 208
    Top = 240
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 320
    Top = 168
  end
  object spGet_UserUnit: TdsdStoredProc
    StoredProcName = 'gpGet_UserUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 376
    Top = 208
  end
  object spUpdate_Price_MCS: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Price_MCS_byReport'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCSValue'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MCS_Value'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDays'
        Value = Null
        Component = ceDays
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMCSAuto'
        Value = Null
        Component = cbisMCSAuto
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 328
  end
  object spInsert_MCS_byReport: TdsdStoredProc
    StoredProcName = 'gpInsert_MCS_byReport'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMCSValue'
        Value = 7.000000000000000000
        Component = ceMCSValue
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMCSValue'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MCS_Value'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 456
    Top = 320
  end
  object HeaderChanger: THeaderChanger
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    ChangerList = <
      item
      end>
    Left = 704
    Top = 200
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId_MCSExcel'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 544
    Top = 240
  end
  object spGetImportSetting_MCS: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TPriceForm;zc_Object_ImportSetting_MCS'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId_MCS'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 184
    Top = 320
  end
  object spGetImportSetting_MCSExcel: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TReport_Check_AssortmentForm;zc_Object_ImportSetting_MCSExcel'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId_MCSExcel'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 88
    Top = 368
  end
  object spDeleteDataExcel: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_DataExcel_byUser'
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 688
    Top = 328
  end
end
