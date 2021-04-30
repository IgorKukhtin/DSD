inherited PriceChangeForm: TPriceChangeForm
  Caption = #1055#1088#1072#1081#1089' - '#1083#1080#1089#1090' '#1090#1077#1082#1091#1097#1080#1081' ('#1094#1077#1085#1099' '#1057#1054' '#1057#1050#1048#1044#1050#1054#1049')'
  ClientHeight = 413
  ClientWidth = 866
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 882
  ExplicitHeight = 452
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TPanel [0]
    Left = 0
    Top = 0
    Width = 866
    Height = 56
    Align = alTop
    TabOrder = 6
    ExplicitWidth = 767
    object deOperDate: TcxDateEdit
      Left = 750
      Top = 6
      EditValue = 42460d
      Properties.DateOnError = deToday
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Visible = False
      Width = 42
    end
    object cxLabel3: TcxLabel
      Left = 9
      Top = 6
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100':'
    end
    object cxLabel1: TcxLabel
      Left = 710
      Top = 6
      Caption = #1094#1077#1085#1072' '#1085#1072':'
      Visible = False
    end
    object cxLabel2: TcxLabel
      Left = 276
      Top = 6
      Caption = #1058#1086#1074#1072#1088':'
    end
    object cxLabel4: TcxLabel
      Left = 2
      Top = 32
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
  end
  inherited PageControl: TcxPageControl
    Top = 82
    Width = 866
    Height = 331
    ExplicitTop = 82
    ExplicitWidth = 767
    ExplicitHeight = 331
    ClientRectBottom = 331
    ClientRectRight = 866
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 767
      ExplicitHeight = 331
      inherited cxGrid: TcxGrid
        Width = 866
        Height = 331
        ExplicitWidth = 767
        ExplicitHeight = 331
        inherited cxGridDBTableView: TcxGridDBTableView
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
              Column = Remains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummaRemains
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
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
              Column = SummaRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.CellEndEllipsis = True
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object BarCode: TcxGridDBColumn
            Caption = #1064'/'#1050' '#1087#1088#1086#1080#1079#1074'.'
            DataBinding.FieldName = 'BarCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1064'/'#1050' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1103
            Options.Editing = False
            Width = 70
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 234
          end
          object NDS: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object Multiplicity: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1086#1090#1087#1091#1089#1082#1072
            DataBinding.FieldName = 'Multiplicity'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object StartDate: TcxGridDBColumn
            Caption = #1048#1089#1090#1086#1088#1080#1103' '#1089
            DataBinding.FieldName = 'StartDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object DateChange: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1086#1089#1083'. '#1080#1079#1084'. '#1094#1077#1085#1099
            DataBinding.FieldName = 'DateChange'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object PriceChange: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' ('#1089#1082'.)'
            DataBinding.FieldName = 'PriceChange'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.MinValue = True
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1072#1103' '#1094#1077#1085#1072' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            Options.Editing = False
            Width = 56
          end
          object PercentMarkup: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080' ('#1089#1082'.)'
            DataBinding.FieldName = 'PercentMarkup'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1085#1072#1094#1077#1085#1082#1080' '#1076#1083#1103' '#1094#1077#1085#1099' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            Width = 70
          end
          object FixValue: TcxGridDBColumn
            Caption = #1060#1080#1082#1089'. '#1094#1077#1085#1072' ('#1089#1082'.)'
            DataBinding.FieldName = 'FixValue'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1072#1103' '#1094#1077#1085#1072' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            Width = 53
          end
          object FixPercent: TcxGridDBColumn
            Caption = #1060#1080#1082#1089'. % ('#1089#1082'.)'
            DataBinding.FieldName = 'FixPercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1092#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1099#1081' % '#1089#1082#1080#1076#1082#1080
            Width = 53
          end
          object FixDiscount: TcxGridDBColumn
            Caption = #1060#1080#1082#1089'. '#1089#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' ('#1089#1082')'
            DataBinding.FieldName = 'FixDiscount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object FixEndDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1076#1077#1081#1089#1090#1074#1080#1103' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'FixEndDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 83
          end
          object Goods_PercentMarkup: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080' ('#1087#1086' '#1089#1077#1090#1080')'
            DataBinding.FieldName = 'Goods_PercentMarkup'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1085#1072#1094#1077#1085#1082#1080
            Options.Editing = False
            Width = 70
          end
          object Goods_isTop: TcxGridDBColumn
            Caption = #1058#1054#1055' ('#1087#1086' '#1089#1077#1090#1080')'
            DataBinding.FieldName = 'Goods_isTop'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
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
          object Remains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object SummaRemains: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1086#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'SummaRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object MinExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1086#1089#1090#1072#1090#1082#1072
            DataBinding.FieldName = 'MinExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 112
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
          object isErased: TcxGridDBColumn
            AlternateCaption = #1058#1086#1074#1072#1088' '#1091#1076#1072#1083#1077#1085
            Caption = #1061
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1086#1074#1072#1088' '#1091#1076#1072#1083#1077#1085
            Options.Editing = False
            Width = 27
          end
          object Color_ExpirationDate: TcxGridDBColumn
            DataBinding.FieldName = 'Color_ExpirationDate'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
        end
      end
    end
  end
  object edRetail: TcxButtonEdit [2]
    Left = 96
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
    Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1086#1088#1075#1086#1074#1091#1102' '#1089#1077#1090#1100'>'
    Width = 169
  end
  object ceGoods: TcxButtonEdit [3]
    Left = 315
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1086#1074#1072#1088'>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 7
    Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1090#1086#1074#1072#1088'>'
    Width = 285
  end
  object edUnit: TcxButtonEdit [4]
    Left = 96
    Top = 31
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 8
    Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
    Width = 504
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Component = GuidesRetail
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GoodsGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      PostDataSetAfterExecute = True
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1090#1086#1074#1072#1088#1099' '#1073#1077#1079' '#1094#1077#1085#1099
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1090#1086#1074#1072#1088#1099' '#1073#1077#1079' '#1094#1077#1085#1099
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1090#1086#1074#1072#1088#1099' '#1089' '#1094#1077#1085#1072#1084#1080
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1090#1086#1074#1072#1088#1099' '#1073#1077#1079' '#1094#1077#1085#1099
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1090#1086#1074#1072#1088#1099' '#1089' '#1094#1077#1085#1072#1084#1080
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1090#1086#1074#1072#1088#1099' '#1073#1077#1079' '#1094#1077#1085#1099
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actShowDel: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1090#1086#1074#1072#1088#1099
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1090#1086#1074#1072#1088#1099
      ImageIndex = 65
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1088#1072#1073#1086#1095#1080#1077' '#1090#1086#1074#1072#1088#1099
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1090#1086#1074#1072#1088#1099
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1088#1072#1073#1086#1095#1080#1077' '#1090#1086#1074#1072#1088#1099
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1072#1082' '#1078#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1090#1086#1074#1072#1088#1099
      ImageIndexTrue = 64
      ImageIndexFalse = 65
    end
    object dsdUpdatePrice: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'dsdUpdatePrice'
      DataSource = MasterDS
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
    object actDoLoadMCS: TExecuteImportSettingsAction
      Category = 'LoadMCS'
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId_MCS'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inUnitId'
          Value = Null
          Component = FormParams
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end>
    end
    object actStartLoadPrice: TMultiAction
      Category = 'LoadPrice'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_Price
        end
        item
          Action = actDoLoadPrice
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1094#1077#1085' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1086#1084#1091' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1094#1077#1085#1099
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1094#1077#1085#1099
      ImageIndex = 75
    end
    object actGetImportSetting_Price: TdsdExecStoredProc
      Category = 'LoadPrice'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting_Price
      StoredProcList = <
        item
          StoredProc = spGetImportSetting_Price
        end>
      Caption = 'actGetImportSetting_Price'
    end
    object actDoLoadPrice: TExecuteImportSettingsAction
      Category = 'LoadPrice'
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId_Price'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inUnitId'
          Value = Null
          Component = FormParams
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end>
    end
    object actRecalcMCS: TdsdExecStoredProc
      Category = 'RecalcMCS'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spRecalcMCS
      StoredProcList = <
        item
          StoredProc = spRecalcMCS
        end>
      Caption = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1053#1058#1047
      Hint = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1053#1058#1047
    end
    object actStartRecalcMCS: TMultiAction
      Category = 'RecalcMCS'
      MoveParams = <>
      ActionList = <
        item
          Action = actRecalcMCSDialog
        end
        item
          Action = actRecalcMCS
        end
        item
          Action = actRefresh
        end>
      Caption = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1053#1058#1047
      Hint = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1053#1058#1047
      ImageIndex = 38
    end
    object actRecalcMCSDialog: TExecuteDialog
      Category = 'RecalcMCS'
      MoveParams = <>
      Caption = 'actRecalcMCSDialog'
      FormName = 'TRecalcMCS_DialogForm'
      FormNameParam.Name = 'TRecalcMCS_DialogForm'
      FormNameParam.Value = 'TRecalcMCS_DialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'RecalcMCS_Period'
          Value = Null
          Component = FormParams
          ComponentItem = 'RecalcMCS_Period'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RecalcMCS_Day'
          Value = Null
          Component = FormParams
          ComponentItem = 'RecalcMCS_Day'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actDelete_Object_MCS: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_Object_MCS
      StoredProcList = <
        item
          StoredProc = spDelete_Object_MCS
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1053#1058#1047
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1053#1058#1047
      ImageIndex = 52
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1053#1058#1047' '#1076#1083#1103' '#1074#1099#1073#1088#1072#1085#1085#1086#1075#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1087#1086' '#1053#1058#1047' '#1076#1083#1103' '#1074#1099#1073#1088#1072#1085#1085#1086#1075#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1073#1099#1083#1080' '#1091#1089#1087#1077#1096#1085#1086' '#1086#1095#1080#1097#1077#1085#1099'.'
    end
    object actPriceHistoryOpen: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1089#1090#1086#1088#1080#1103' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1094#1077#1085
      Hint = #1048#1089#1090#1086#1088#1080#1103' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1094#1077#1085
      ImageIndex = 35
      FormName = 'TPriceChangeHistoryForm'
      FormNameParam.Value = 'TPriceChangeHistoryForm'
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
        end>
      isShowModal = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      FormName = 'TPriceChangeGoodsDialogForm'
      FormNameParam.Value = 'TPriceChangeGoodsDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'OperDate'
          Value = 42430d
          Component = deOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailId'
          Value = 42370d
          Component = GuidesRetail
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailName'
          Value = Null
          Component = GuidesRetail
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = GoodsGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = GoodsGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object dsdOpenForm: TdsdOpenForm
      Category = #1055#1088#1086#1090#1086#1082#1086#1083
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
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = GuidesRetail
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdate_CheckPrice: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CheckPrice
      StoredProcList = <
        item
          StoredProc = spUpdate_CheckPrice
        end>
      Caption = 'actUpdate_CheckPrice'
      ImageIndex = 27
    end
    object macUpdate_CheckPriceList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_CheckPrice
        end>
      View = cxGridDBTableView
      Caption = #1047#1072#1092#1080#1082#1089#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1082#1086#1075#1076#1072' '#1055#1086#1103#1074#1080#1083#1089#1103' '#1085#1072' '#1088#1099#1085#1082#1077
      Hint = #1047#1072#1092#1080#1082#1089#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1082#1086#1075#1076#1072' '#1055#1086#1103#1074#1080#1083#1089#1103' '#1085#1072' '#1088#1099#1085#1082#1077
      ImageIndex = 27
    end
    object macUpdate_CheckPrice: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_CheckPriceList
        end>
      QuestionBeforeExecute = #1047#1072#1092#1080#1082#1089#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1082#1086#1075#1076#1072' '#1055#1086#1103#1074#1080#1083#1089#1103' '#1085#1072' '#1088#1099#1085#1082#1077'?'
      InfoAfterExecute = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1082#1086#1075#1076#1072' '#1055#1086#1103#1074#1080#1083#1089#1103' '#1085#1072' '#1088#1099#1085#1082#1077' '#1047#1072#1092#1080#1082#1089#1080#1088#1086#1074#1072#1085#1072'.'
      Caption = #1047#1072#1092#1080#1082#1089#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1082#1086#1075#1076#1072' '#1055#1086#1103#1074#1080#1083#1089#1103' '#1085#1072' '#1088#1099#1085#1082#1077
      Hint = #1047#1072#1092#1080#1082#1089#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1082#1086#1075#1076#1072' '#1055#1086#1103#1074#1080#1083#1089#1103' '#1085#1072' '#1088#1099#1085#1082#1077
      ImageIndex = 27
    end
    object macUpdateFixDateEnd: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actExecuteDialogFixDateEnd
      ActionList = <
        item
          Action = actUpdateFixDateEnd
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1072#1082#1094#1080#1080
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1072#1082#1094#1080#1080
      ImageIndex = 43
    end
    object actUpdateFixDateEnd: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_FixDateEnd
      StoredProcList = <
        item
          StoredProc = spUpdate_FixDateEnd
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1072#1082#1094#1080#1080
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1072#1082#1094#1080#1080
    end
    object macClearFixDateEnd: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actClearFixDateEnd
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1054#1095#1080#1089#1090#1080#1090#1100' '#1076#1072#1090#1091' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1072#1082#1094#1080#1080'?'
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1076#1072#1090#1091' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1072#1082#1094#1080#1080
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1076#1072#1090#1091' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1072#1082#1094#1080#1080
      ImageIndex = 76
    end
    object actClearFixDateEnd: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spClear_FixDateEnd
      StoredProcList = <
        item
          StoredProc = spClear_FixDateEnd
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1072#1082#1094#1080#1080
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1072#1082#1094#1080#1080
    end
    object actExecuteDialogFixDateEnd: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDialogFixDateEnd'
      FormName = 'TDataDialogForm'
      FormNameParam.Value = 'TDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'FixEndDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 144
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_PriceChange'
    Params = <
      item
        Name = 'inRetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowDel'
        Value = Null
        Component = actShowDel
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 184
  end
  inherited BarManager: TdxBarManager
    Left = 184
    Top = 176
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
          ItemName = 'bbChoice'
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
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
          UserDefine = [udPaintStyle]
          UserPaintStyle = psCaptionGlyph
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
          UserDefine = [udPaintStyle]
          UserPaintStyle = psCaptionGlyph
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bb'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
        end
        item
          Visible = True
          ItemName = 'dxBarButton9'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenForm'
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
    object dxBarControlContainerItemUnit: TdxBarControlContainerItem
      Caption = #1042#1099#1073#1086#1088' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      Category = 0
      Hint = #1042#1099#1073#1086#1088' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
      Visible = ivAlways
      Control = edRetail
    end
    object dxBarButton1: TdxBarButton
      Action = actShowAll
      Category = 0
      AllowAllUp = True
    end
    object dxBarButton2: TdxBarButton
      Action = actShowDel
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actStartLoadMCS
      Category = 0
      Visible = ivNever
    end
    object dxBarButton4: TdxBarButton
      Action = actStartLoadPrice
      Category = 0
      Visible = ivNever
    end
    object dxBarButton5: TdxBarButton
      Action = actStartRecalcMCS
      Category = 0
      Visible = ivNever
    end
    object dxBarButton6: TdxBarButton
      Action = actDelete_Object_MCS
      Category = 0
      Visible = ivNever
    end
    object dxBarButton7: TdxBarButton
      Action = actPriceHistoryOpen
      Category = 0
    end
    object bbOpenForm: TdxBarButton
      Action = dsdOpenForm
      Category = 0
    end
    object bb: TdxBarButton
      Action = macUpdate_CheckPrice
      Category = 0
      Visible = ivNever
    end
    object dxBarButton8: TdxBarButton
      Action = macUpdateFixDateEnd
      Category = 0
    end
    object dxBarButton9: TdxBarButton
      Action = macClearFixDateEnd
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    DateEdit = deOperDate
    ColorRuleList = <
      item
        ColorColumn = DateChange
        ValueColumn = Color_ExpirationDate
        ColorValueList = <>
      end
      item
        ColorColumn = StartDate
        ValueColumn = Color_ExpirationDate
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsCode
        ValueColumn = Color_ExpirationDate
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsGroupName
        ValueColumn = Color_ExpirationDate
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsName
        ValueColumn = Color_ExpirationDate
        ColorValueList = <>
      end
      item
        ColorColumn = NDS
        ValueColumn = Color_ExpirationDate
        ColorValueList = <>
      end
      item
        ColorColumn = Goods_isTop
        ValueColumn = Color_ExpirationDate
        ColorValueList = <>
      end
      item
        ColorColumn = Goods_PercentMarkup
        ValueColumn = Color_ExpirationDate
        ColorValueList = <>
      end
      item
        ColorColumn = isClose
        ValueColumn = Color_ExpirationDate
        ColorValueList = <>
      end
      item
        ColorColumn = isFirst
        ValueColumn = Color_ExpirationDate
        ColorValueList = <>
      end
      item
        ColorColumn = isSecond
        ValueColumn = Color_ExpirationDate
        ColorValueList = <>
      end
      item
        ColorColumn = isErased
        ValueColumn = Color_ExpirationDate
        ColorValueList = <>
      end
      item
        ColorColumn = PriceChange
        ValueColumn = Color_ExpirationDate
        ColorValueList = <>
      end
      item
        ColorColumn = PercentMarkup
        ValueColumn = Color_ExpirationDate
        ColorValueList = <>
      end
      item
        ColorColumn = FixValue
        ValueColumn = Color_ExpirationDate
        ColorValueList = <>
      end
      item
        ColorColumn = MinExpirationDate
        ValueColumn = Color_ExpirationDate
        ColorValueList = <>
      end
      item
        ColorColumn = Remains
        ValueColumn = Color_ExpirationDate
        ColorValueList = <>
      end
      item
        ColorColumn = SummaRemains
        ValueColumn = Color_ExpirationDate
        ColorValueList = <>
      end>
  end
  object GuidesRetail: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 65528
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId_MCS'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId_Price'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'RecalcMCS_Period'
        Value = '40'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RecalcMCS_Day'
        Value = '5'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FixEndDate'
        Value = Null
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 104
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_PriceChange'
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
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioStartDate'
        Value = 73051d
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDateChange'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DateChange'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStartDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPriceChange'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceChange'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFixValue'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FixValue'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFixPercent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FixPercent'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFixDiscount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FixDiscount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercentMarkup'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PercentMarkup'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMultiplicity'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Multiplicity'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFixEndDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FixEndDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 272
    Top = 192
  end
  object rdUnit: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesRetail
      end>
    Left = 176
    Top = 224
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
    Left = 704
    Top = 264
  end
  object spGetImportSetting_Price: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TPriceForm;zc_Object_ImportSetting_Price'
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
        ComponentItem = 'ImportSettingId_Price'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 264
  end
  object spRecalcMCS: TdsdStoredProc
    StoredProcName = 'gpRecalcMCS'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriod'
        Value = Null
        Component = FormParams
        ComponentItem = 'RecalcMCS_Period'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay'
        Value = Null
        Component = FormParams
        ComponentItem = 'RecalcMCS_Day'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 200
  end
  object spDelete_Object_MCS: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_MCS'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = ''
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 208
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoods
    FormNameParam.Value = 'TGoodsLiteForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsLiteForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 496
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GoodsGuides
      end
      item
        Component = GuidesRetail
      end
      item
        Component = GuidesUnit
      end>
    Left = 632
    Top = 216
  end
  object spUpdate_CheckPrice: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Price_CheckPrice'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = ''
        Component = FormParams
        ComponentItem = 'UnitId'
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
        Name = 'inisCorrectMCS'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isCorrectMCS'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCheckPriceDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CheckPriceDate'
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 448
    Top = 304
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
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
    Left = 288
    Top = 24
  end
  object spUpdate_FixDateEnd: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_PriceChange_FixDateEnd'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFixEndDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'FixEndDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 176
    Top = 312
  end
  object spClear_FixDateEnd: TdsdStoredProc
    StoredProcName = 'gpClear_Object_PriceChange_FixDateEnd'
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
      end>
    PackSize = 1
    Left = 280
    Top = 312
  end
end
