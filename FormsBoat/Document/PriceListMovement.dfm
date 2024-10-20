inherited PriceListMovementForm: TPriceListMovementForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1072#1081#1089'-'#1083#1080#1089#1090'>'
  ClientHeight = 668
  ClientWidth = 1069
  ExplicitWidth = 1085
  ExplicitHeight = 707
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 119
    Width = 1069
    Height = 549
    ExplicitTop = 119
    ExplicitWidth = 1069
    ExplicitHeight = 549
    ClientRectBottom = 549
    ClientRectRight = 1069
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1069
      ExplicitHeight = 525
      inherited cxGrid: TcxGrid
        Width = 1069
        Height = 525
        ExplicitWidth = 1069
        ExplicitHeight = 525
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
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
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
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end>
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsGroupNameFull: TcxGridDBColumn [0]
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Article: TcxGridDBColumn [1]
            Caption = 'Artikel Nr'
            DataBinding.FieldName = 'Article'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Article_all: TcxGridDBColumn [2]
            Caption = '***Artikel Nr'
            DataBinding.FieldName = 'Article_all'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            Width = 70
          end
          object GoodsCode: TcxGridDBColumn [3]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
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
            Width = 63
          end
          object GoodsName: TcxGridDBColumn [4]
            Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 206
          end
          object GoodsName_translate: TcxGridDBColumn [5]
            Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077' ('#1087#1077#1088#1077#1074#1086#1076')'
            DataBinding.FieldName = 'GoodsName_translate'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 131
          end
          object DiscountPartnerName: TcxGridDBColumn [6]
            Caption = #1043#1088#1091#1087#1087#1072' '#1089#1082'. '#1091' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'DiscountPartnerName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actDiscountPartnerChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1043#1088#1091#1087#1087#1072' '#1089#1082#1080#1076#1082#1080' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Width = 97
          end
          object MeasureName: TcxGridDBColumn [7]
            Caption = #1045#1076'.'#1080#1079#1084
            DataBinding.FieldName = 'MeasureName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actMeasureChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object MeasureParentName: TcxGridDBColumn [8]
            Caption = #1045#1076'.'#1080#1079#1084' ('#1091#1087#1072#1082#1086#1074#1082#1080')'
            DataBinding.FieldName = 'MeasureParentName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actMeasureParentChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 78
          end
          object MeasureName_translate: TcxGridDBColumn [9]
            Caption = #1045#1076'.'#1080#1079#1084' ('#1087#1077#1088#1077#1074#1086#1076')'
            DataBinding.FieldName = 'MeasureName_translate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 69
          end
          object MeasureParentName_translate: TcxGridDBColumn [10]
            Caption = #1045#1076'.'#1080#1079#1084' ('#1091#1087#1072#1082#1086#1074#1082#1080') ('#1087#1077#1088#1077#1074#1086#1076')'
            DataBinding.FieldName = 'MeasureParentName_translate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object isOutlet: TcxGridDBColumn [11]
            Caption = 'Outlet'
            DataBinding.FieldName = 'isOutlet'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 62
          end
          object Amount: TcxGridDBColumn [12]
            Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1085#1076#1089
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 77
          end
          object PriceParent: TcxGridDBColumn [13]
            Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1085#1076#1089' ('#1091#1087#1072#1082#1086#1074#1082#1080')'
            DataBinding.FieldName = 'PriceParent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1073#1077#1079' '#1085#1076#1089' ('#1091#1087#1072#1082#1086#1074#1082#1080')'
            Width = 77
          end
          object MeasureMult: TcxGridDBColumn [14]
            Caption = #1042#1083#1086#1078#1077#1085#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'MeasureMult'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 57
          end
          object EmpfPriceParent: TcxGridDBColumn [15]
            Caption = #1056#1077#1082#1086#1084#1077#1085'. '#1094#1077#1085#1072' '#1073#1077#1079' '#1085#1076#1089' ('#1091#1087'.)'
            DataBinding.FieldName = 'EmpfPriceParent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1082#1086#1084#1077#1085#1076#1086#1074#1072#1085#1085#1072#1103' '#1094#1077#1085#1072' '#1073#1077#1079' '#1085#1076#1089' ('#1091#1087#1072#1082#1086#1074#1082#1080')'
            Width = 57
          end
          object MinCount: TcxGridDBColumn [16]
            Caption = #1052#1080#1085' '#1082#1086#1083'-'#1074#1086' '#1079#1072#1082#1091#1087#1082#1080
            DataBinding.FieldName = 'MinCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1084#1080#1085' '#1082#1086#1083'-'#1074#1086' '#1079#1072#1082#1091#1087#1082#1080
            Width = 57
          end
          object MinCountMult: TcxGridDBColumn [17]
            Caption = #1056#1077#1082#1086#1084'. '#1082#1086#1083'-'#1074#1086' '#1079#1072#1082#1091#1087#1082#1080
            DataBinding.FieldName = 'MinCountMult'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1077#1082#1086#1084#1077#1085#1076#1091#1077#1084#1086#1077' '#1082#1086#1083'-'#1074#1086' '#1079#1072#1082#1091#1087#1082#1080
            Width = 57
          end
          object WeightParent: TcxGridDBColumn [18]
            DataBinding.FieldName = 'WeightParent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 57
          end
          object CatalogPage: TcxGridDBColumn [19]
            DataBinding.FieldName = 'CatalogPage'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 171
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1069
    Height = 93
    TabOrder = 3
    ExplicitWidth = 1069
    ExplicitHeight = 93
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 89
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 89
      ExplicitWidth = 80
      Width = 80
    end
    inherited cxLabel2: TcxLabel
      Left = 89
      ExplicitLeft = 89
    end
    inherited cxLabel15: TcxLabel
      Left = 175
      ExplicitLeft = 175
    end
    inherited ceStatus: TcxButtonEdit
      Left = 175
      Top = 22
      ExplicitLeft = 175
      ExplicitTop = 22
      ExplicitWidth = 153
      ExplicitHeight = 22
      Width = 153
    end
    object edPartner: TcxButtonEdit
      Left = 8
      Top = 66
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 320
    end
    object cxLabel4: TcxLabel
      Left = 8
      Top = 48
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
    end
    object cxLabel16: TcxLabel
      Left = 354
      Top = 48
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 354
      Top = 66
      TabOrder = 9
      Width = 248
    end
    object cxLabel3: TcxLabel
      Left = 610
      Top = 49
      Caption = #1071#1079#1099#1082' '#1087#1077#1088#1077#1074#1086#1076#1072':'
    end
    object edLanguage: TcxButtonEdit
      Left = 610
      Top = 66
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 124
    end
    object Panel1: TPanel
      Left = 354
      Top = 5
      Width = 380
      Height = 41
      TabOrder = 12
      object cxLabel6: TcxLabel
        Left = 188
        Top = 1
        Caption = #1057#1082#1072#1085#1080#1088#1091#1077#1090#1089#1103' <BarCode> '#1080#1083#1080' '#1074#1074#1086#1076
      end
      object edBarCode1: TcxTextEdit
        Left = 189
        Top = 18
        TabOrder = 0
        Width = 179
      end
      object cxLabel8: TcxLabel
        Left = 6
        Top = 9
        Caption = '1.'
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clBlue
        Style.Font.Height = -19
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = []
        Style.IsFontAssigned = True
      end
    end
  end
  object lbSearchArticle: TcxLabel [2]
    Left = 155
    Top = 221
    Caption = #1055#1086#1080#1089#1082' Artikel Nr : '
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
  end
  object edSearchArticle: TcxTextEdit [3]
    Left = 152
    Top = 247
    TabOrder = 7
    DesignSize = (
      125
      21)
    Width = 125
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 171
    Top = 552
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
      end>
    Left = 24
    Top = 200
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    object actRefreshMI: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end>
      RefreshOnTabSetChanges = True
    end
    object actDoLoad_Gotthardt: TExecuteImportSettingsAction [2]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId_Gotthardt'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inOperDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actDoLoad_Uflex3: TExecuteImportSettingsAction [3]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId_Uflex3'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inOperDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actGetImportSettingId_ASGEMEA: TdsdExecStoredProc [4]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_ASG_EMEA
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_ASG_EMEA
        end>
      Caption = 'actGetImportSetting_GoodsASGEMEA'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '
    end
    object actGetImportSettingId_Uflex1: TdsdExecStoredProc [5]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_Uflex1
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_Uflex1
        end>
      Caption = 'actGetImportSetting_SkiDoo'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1055#1088#1080#1093#1086#1076#1072' '#1080#1079' '#1092#1072#1081#1083#1072
    end
    object actGetImportSettingId_Uflex3: TdsdExecStoredProc [6]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_GoodsArticle
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_GoodsArticle
        end>
      Caption = 'actGetImportSetting_GoodsArticle'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '
    end
    object actDoLoad_Uflex2: TExecuteImportSettingsAction [7]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId_Uflex2'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inOperDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object ExecuteImportSettingsAction1: TExecuteImportSettingsAction [8]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId_Uflex1'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inOperDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actGetImportSettingId_Uflex2: TdsdExecStoredProc [9]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_Uflex2
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_Uflex2
        end>
      Caption = 'actGetImportSetting__Uflex2'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1055#1088#1080#1093#1086#1076#1072' '#1080#1079' '#1092#1072#1081#1083#1072
    end
    object actGetImportSetting_RapidMarine: TdsdExecStoredProc [10]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_RapidMarine
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_RapidMarine
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Rapid Marine '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Rapid Marine '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 48
    end
    object actDoLoad_RapidMarine: TExecuteImportSettingsAction [11]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inOperDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object mactStartLoad_RapidMarine: TMultiAction [12]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_RapidMarine
        end
        item
          Action = actDoLoad_RapidMarine
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Rapid Marine '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Rapid Marine '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Rapid Marine '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Rapid Marine '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 48
      WithoutNext = True
    end
    object mactStartLoad_ASGEMEA: TMultiAction [13]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingId_ASGEMEA
        end
        item
          Action = actDoLoad_ASGEMEA
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090'ASG EMEA '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1076#1086#1082#1091#1084#1077#1085#1090' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090' '#1079#1072#1075#1088#1091#1078#1077#1085
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090' ASG EMEA '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090' ASG EMEA '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 47
      WithoutNext = True
    end
    object actDoLoad_Uflex1: TExecuteImportSettingsAction [15]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId_Uflex1'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inOperDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    inherited actMISetErased: TdsdUpdateErased
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end>
      ShortCut = 49220
    end
    object mactStartLoad_Uflex3: TMultiAction [17]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingId_Uflex3
        end
        item
          Action = actDoLoad_Uflex3
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' '#1080'  GoodsArticle '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' '#1080'  GoodsArticle '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' '#1080'  GoodsArticle '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' '#1080'  GoodsArticle '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 50
      WithoutNext = True
    end
    object mactAdd_limit: TMultiAction [18]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actAdd_limit
        end
        item
          Action = actRefreshMI
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'> ('#1083#1080#1084#1080#1090')'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'> ('#1083#1080#1084#1080#1090')'
      ImageIndex = 0
      WithoutNext = True
    end
    object actAdd_limit: TdsdInsertUpdateAction [19]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'> ('#1083#1080#1084#1080#1090')'
      ImageIndex = 0
      FormName = 'TPriceListItemEdit_limitForm'
      FormNameParam.Value = 'TPriceListItemEdit_limitForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inAmount'
          Value = 1.000000000000000000
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = '-1'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = '0'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = MasterDS
      IdFieldName = 'Id'
    end
    object actGetImportSetting_Gotthardt: TdsdExecStoredProc [20]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_Gotthardt
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_Gotthardt
        end>
    end
    inherited actMISetUnErased: TdsdUpdateErased
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end>
      ShortCut = 49220
    end
    object actDoLoad_ASGEMEA: TExecuteImportSettingsAction [22]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId_ASGEMEA'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inOperDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = ''
          Component = GuidesPartner
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object mactStartLoad_Gotthardt: TMultiAction [23]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_Gotthardt
        end
        item
          Action = actDoLoad_Gotthardt
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Gotthardt '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Gotthardt'#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Gotthardt '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Gotthardt '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 27
      WithoutNext = True
    end
    object mactStartLoad_Uflex1: TMultiAction [25]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingId_Uflex1
        end
        item
          Action = actDoLoad_Uflex1
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Uflex-1 '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Uflex-1 '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Uflex-1 '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Uflex-1 '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 79
      WithoutNext = True
    end
    object mactStartLoad_Uflex2: TMultiAction [26]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingId_Uflex2
        end
        item
          Action = actDoLoad_Uflex2
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Uflex-2 '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Uflex-2 '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Uflex-2 '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Uflex-2 '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 80
      WithoutNext = True
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Sale2'
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = 'PrintMovement_Sale2'
      ReportNameParam.ParamType = ptInput
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    object mactAdd: TMultiAction [34]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actAdd
        end
        item
          Action = actRefreshMI
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
      ImageIndex = 0
      WithoutNext = True
    end
    object actAdd: TdsdInsertUpdateAction [35]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1091#1102#1097#1080#1077'>'
      ImageIndex = 0
      FormName = 'TPriceListItemEditForm'
      FormNameParam.Value = 'TPriceListItemEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inAmount'
          Value = 1.000000000000000000
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = '-1'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = '0'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = MasterDS
      IdFieldName = 'Id'
    end
    object actMeasureParentChoice: TOpenChoiceForm [37]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'MeasureForm'
      FormName = 'TMeasureForm'
      FormNameParam.Value = 'TMeasureForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureParentId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureParentName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actMeasureChoice: TOpenChoiceForm [38]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'MeasureForm'
      FormName = 'TMeasureForm'
      FormNameParam.Value = 'TMeasureForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actDiscountPartnerChoice: TOpenChoiceForm [39]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'DiscountPartnerForm'
      FormName = 'TDiscountPartnerForm'
      FormNameParam.Value = 'TDiscountPartnerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DiscountPartnerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DiscountPartnerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsChoice: TOpenChoiceForm [40]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsForm'
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Article'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Article'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupNameFull'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupNameFull'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actRefreshPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actOpenPriceListLoad: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1047#1072#1075#1088#1091#1079#1082#1072' '#1087#1088#1072#1081#1089#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1047#1072#1075#1088#1091#1079#1082#1072' '#1087#1088#1072#1081#1089#1072'>'
      ShortCut = 8205
      ImageIndex = 28
      FormName = 'TPriceListItemsLoadForm'
      FormNameParam.Value = 'TPriceListItemsLoadForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'PriceListId'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      IdFieldName = 'Id'
    end
    object actUpdatePrice: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Price
      StoredProcList = <
        item
          StoredProc = spUpdate_Price
        end>
      Caption = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1094#1077#1085#1091' '#1087#1088#1072#1081#1089#1072
      Hint = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1094#1077#1085#1091' '#1087#1088#1072#1081#1089#1072
    end
    object macUpdatePrice: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdatePrice
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1077#1088#1077#1089#1095#1077#1090#1077' '#1094#1077#1085' '#1087#1088#1072#1081#1089#1072'?'
      InfoAfterExecute = #1062#1077#1085#1099' '#1080#1079#1084#1077#1085#1077#1085#1099
      Caption = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1094#1077#1085#1091' '#1087#1088#1072#1081#1089#1072
      Hint = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1094#1077#1085#1091' '#1087#1088#1072#1081#1089#1072
      ImageIndex = 41
    end
    object actDoLoad_SkiDoo: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inOperDate'
          Value = 42370d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = Null
          Component = GuidesPartner
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actDoLoad_Osculati: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId_Osculati'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inOperDate'
          Value = 42370d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = Null
          Component = GuidesPartner
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actGetImportSetting_Osculati: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_Osculati
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_Osculati
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1055#1088#1080#1093#1086#1076#1072' '#1080#1079' '#1092#1072#1081#1083#1072' '#1089' S/N'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1055#1088#1080#1093#1086#1076#1072' '#1080#1079' '#1092#1072#1081#1083#1072' '#1089' S/N'
    end
    object actGetImportSetting_SkiDoo: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_SkiDoo
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_SkiDoo
        end>
      Caption = 'actGetImportSetting_SkiDoo'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1055#1088#1080#1093#1086#1076#1072' '#1080#1079' '#1092#1072#1081#1083#1072
    end
    object mactStartLoad_Osculati: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_Osculati
        end
        item
          Action = actDoLoad_Osculati
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Osculati '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Osculati '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Osculati '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Osculati '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 74
      WithoutNext = True
    end
    object mactStartLoad_SkiDoo: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_SkiDoo
        end
        item
          Action = actDoLoad_SkiDoo
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' SkiDoo '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' SkiDoo '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' SkiDoo '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' SkiDoo '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 41
      WithoutNext = True
    end
    object InsertRecord: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actGoodsChoice
      Params = <>
      Caption = 'InsertRecord'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1086#1074#1072#1088
      ImageIndex = 0
    end
    object actChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          DataType = ftString
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
      DataSource = MasterDS
    end
    object macGoodsItem1: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGoodsItemGet1
        end
        item
          Action = actGoodsItem1
        end
        item
          Action = actRefreshMI
        end>
      Caption = 'macGoodsItem1'
    end
    object actGoodsItemGet1: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_dop1
      StoredProcList = <
        item
          StoredProc = spGet_dop1
        end>
      Caption = 'actGoodsItemGet1'
    end
    object actGoodsItem1: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      FormName = 'TPriceListItemEditForm'
      FormNameParam.Value = 'TPriceListItemEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inAmount'
          Value = 1.000000000000000000
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = FormParams
          ComponentItem = 'GoodsId'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = Null
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = MasterDS
      IdFieldName = 'Id'
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 512
  end
  inherited MasterCDS: TClientDataSet
    Left = 88
    Top = 512
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PriceList'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLanguageId'
        Value = ''
        Component = GuidesLanguage
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 120
    Top = 264
  end
  inherited BarManager: TdxBarManager
    Left = 80
    Top = 207
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bblbSearchArticle'
        end
        item
          Visible = True
          ItemName = 'bbedSearchArticle'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddMask'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecord'
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
          ItemName = 'bbAdd_limit'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad_SkiDoo'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad_Osculati'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad_Gotthardt'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad_Uflex1'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad_Uflex2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad_Uflex3'
        end
        item
          Visible = True
          ItemName = 'bbtStartLoad_ASGEMEA'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad_RapidMarine'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
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
    inherited bbPrint: TdxBarButton
      Visible = ivNever
    end
    object bbPrint_Bill: TdxBarButton [5]
      Caption = #1057#1095#1077#1090
      Category = 0
      Hint = #1057#1095#1077#1090
      Visible = ivAlways
      ImageIndex = 21
    end
    object bbPrintTax: TdxBarButton [6]
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbPrintTax_Client: TdxBarButton [7]
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Visible = ivAlways
      ImageIndex = 18
    end
    inherited bbAddMask: TdxBarButton
      Visible = ivNever
    end
    object bbTax: TdxBarButton
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Category = 0
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Visible = ivAlways
      ImageIndex = 41
    end
    object bbOpenPriceListLoad: TdxBarButton
      Action = actOpenPriceListLoad
      Category = 0
    end
    object bbUpdatePrice: TdxBarButton
      Action = macUpdatePrice
      Category = 0
    end
    object bbStartLoad_SkiDoo: TdxBarButton
      Action = mactStartLoad_SkiDoo
      Category = 0
    end
    object bbStartLoad_Osculati: TdxBarButton
      Action = mactStartLoad_Osculati
      Category = 0
    end
    object bbStartLoad_Gotthardt: TdxBarButton
      Action = mactStartLoad_Gotthardt
      Category = 0
    end
    object bbStartLoad_Uflex1: TdxBarButton
      Action = mactStartLoad_Uflex1
      Category = 0
    end
    object bbStartLoad_Uflex2: TdxBarButton
      Action = mactStartLoad_Uflex2
      Category = 0
    end
    object bbStartLoad_Uflex3: TdxBarButton
      Action = mactStartLoad_Uflex3
      Category = 0
    end
    object bbInsertRecord: TdxBarButton
      Action = mactAdd
      Category = 0
    end
    object bblbSearchArticle: TdxBarControlContainerItem
      Caption = 'lbSearchArticle'
      Category = 0
      Hint = 'lbSearchArticle'
      Visible = ivAlways
      Control = lbSearchArticle
    end
    object bbedSearchArticle: TdxBarControlContainerItem
      Caption = 'edSearchArticle'
      Category = 0
      Hint = 'edSearchArticle'
      Visible = ivAlways
      Control = edSearchArticle
    end
    object bbtStartLoad_ASGEMEA: TdxBarButton
      Action = mactStartLoad_ASGEMEA
      Category = 0
    end
    object bbAdd_limit: TdxBarButton
      Action = mactAdd_limit
      Category = 0
    end
    object bbStartLoad_RapidMarine: TdxBarButton
      Action = mactStartLoad_RapidMarine
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    Left = 830
    Top = 265
  end
  inherited PopupMenu: TPopupMenu
    Left = 800
    Top = 464
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNamePriceList'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNamePriceListTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNamePriceListBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId_Osculati'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId_Gotthardt'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId_Uflex1'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId_Uflex2'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId_Uflex3'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId_ASGEMEA'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 552
  end
  inherited StatusGuides: TdsdGuides
    Left = 128
    Top = 128
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_PriceList'
    Left = 176
    Top = 144
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_PriceList'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = ''
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'fff'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'fff'
        Value = Null
        Component = FormParams
        ComponentItem = 'PriceListId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'fff'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'fff'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 272
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PriceList'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
      end
      item
        Guides = GuidesPartner
      end>
    Left = 160
    Top = 192
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
      end
      item
      end
      item
        Control = edOperDate
      end
      item
      end
      item
      end
      item
        Control = edPartner
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 912
    Top = 320
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_PriceList_SetErased'
    Left = 718
    Top = 512
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_PriceList_SetUnErased'
    Left = 718
    Top = 464
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PriceList'
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
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
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
        Name = 'inDiscountPartnerId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DiscountPartnerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMeasureId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MeasureId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMeasureParentId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MeasureParentId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMeasureMult'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MeasureMult'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceParent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceParent'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmpfPriceParent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'EmpfPriceParent'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MinCount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinCountMult'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MinCountMult'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeightParent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeightParent'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCatalogPage'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CatalogPage'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOutlet'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOutlet'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = ''
    Left = 420
    Top = 188
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshPrice
    ComponentList = <
      item
        Component = GuidesLanguage
      end>
    Left = 512
    Top = 328
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 193
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 246
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 319
    Top = 208
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    FormNameParam.Value = 'TPartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 48
  end
  object spUpdate_Price: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_Price'
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
        Name = 'inMovementId'
        Value = 'FALSE'
        Component = FormParams
        ComponentItem = 'Id'
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
        Name = 'ioAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 664
    Top = 155
  end
  object spGetImportSettingId_SkiDoo: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TPriceListSkiDooJournalForm;zc_Object_ImportSetting_PriceListSki' +
          'DooJournal'
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
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 560
    Top = 384
  end
  object spGetImportSettingId_Osculati: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TPriceListOsculatiForm;zc_Object_ImportSetting_PriceListOsculati'
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
        ComponentItem = 'ImportSettingId_Osculati'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 720
    Top = 384
  end
  object GuidesLanguage: TdsdGuides
    KeyField = 'Id'
    LookupControl = edLanguage
    FormNameParam.Value = 'TLanguageForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TLanguageForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesLanguage
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesLanguage
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 672
    Top = 24
  end
  object spGetImportSettingId_Gotthardt: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TPriceListGotthardtForm;zc_Object_ImportSetting_PriceListGotthar' +
          'dt'
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
        ComponentItem = 'ImportSettingId_Gotthardt'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 552
    Top = 432
  end
  object spGetImportSettingId_Uflex1: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TPriceListUflex1Form;zc_Object_ImportSetting_PriceListUflex1'
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
        ComponentItem = 'ImportSettingId_Uflex1'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 920
    Top = 392
  end
  object spGetImportSettingId_Uflex2: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TPriceListUflex2Form;zc_Object_ImportSetting_PriceListUflex2'
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
        ComponentItem = 'ImportSettingId_Uflex2'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 920
    Top = 472
  end
  object spGetImportSettingId_GoodsArticle: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TPriceListGoodsArticleForm;zc_Object_ImportSetting_PriceListGood' +
          'sArticle'
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
        ComponentItem = 'ImportSettingId_Uflex3'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 936
    Top = 216
  end
  object FieldFilter_Article: TdsdFieldFilter
    TextEdit = edSearchArticle
    DataSet = MasterCDS
    Column = Article_all
    ColumnList = <
      item
        Column = Article_all
      end>
    ActionNumber1 = actChoiceGuides
    CheckBoxList = <>
    Left = 288
    Top = 336
  end
  object spGetImportSettingId_ASG_EMEA: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TPriceListASGEMEAForm;zc_Object_ImportSetting_PriceListASGEMEA'
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
        ComponentItem = 'ImportSettingId_ASGEMEA'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 920
    Top = 528
  end
  object EnterMoveNext1: TEnterMoveNext
    EnterMoveNextList = <
      item
        Control = edBarCode1
        ExitAction = macGoodsItem1
      end>
    Left = 752
    Top = 8
  end
  object spGet_dop1: TdsdStoredProc
    StoredProcName = 'gpGet_MI_byBarcode'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCode'
        Value = ''
        Component = edBarCode1
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 1.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'GoodsId'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 360
    Top = 424
  end
  object spGetImportSettingId_RapidMarine: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TPriceListRapidMarineForm;zc_Object_ImportSetting_PriceListRapid' +
          'Marine'
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
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 712
    Top = 296
  end
end
