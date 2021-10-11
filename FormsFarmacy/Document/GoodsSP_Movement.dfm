inherited GoodsSP_MovementForm: TGoodsSP_MovementForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1058#1086#1074#1072#1088#1099' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072'>'
  ClientHeight = 554
  ClientWidth = 1043
  AddOnFormData.AddOnFormRefresh.ParentList = 'Loss'
  ExplicitWidth = 1059
  ExplicitHeight = 593
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1043
    Height = 468
    ExplicitWidth = 1043
    ExplicitHeight = 468
    ClientRectBottom = 468
    ClientRectRight = 1043
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1043
      ExplicitHeight = 444
      inherited cxGrid: TcxGrid
        Width = 1043
        Height = 444
        ExplicitWidth = 1043
        ExplicitHeight = 444
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end>
          OptionsBehavior.IncSearch = True
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
          object GoodsCode: TcxGridDBColumn [0]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsName: TcxGridDBColumn [1]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 253
          end
          object ColSP: TcxGridDBColumn [2]
            Caption = #8470' '#1079'/'#1087' (1)'
            DataBinding.FieldName = 'ColSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 59
          end
          object IntenalSPName: TcxGridDBColumn [3]
            Caption = #1052#1110#1078#1085#1072#1088#1086#1076#1085#1072' '#1085#1077#1087#1072#1090#1077#1085#1090#1086#1074#1072#1085#1072' '#1085#1072#1079#1074#1072' (2)'
            DataBinding.FieldName = 'IntenalSPName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actIntenalSPChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 97
          end
          object BrandSPName: TcxGridDBColumn [4]
            Caption = #1058#1086#1088#1075#1086#1074#1072' '#1085#1072#1079#1074#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091' (3)'
            DataBinding.FieldName = 'BrandSPName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actBrandSPChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 115
          end
          object KindOutSPName: TcxGridDBColumn [5]
            Caption = #1060#1086#1088#1084#1072' '#1074#1080#1087#1091#1089#1082#1091' (4)'
            DataBinding.FieldName = 'KindOutSPName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actKindOutSPChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 57
          end
          object Pack: TcxGridDBColumn [6]
            Caption = #1057#1080#1083#1072' '#1076#1110#1111' ('#1076#1086#1079#1091#1074#1072#1085#1085#1103') (5)'
            DataBinding.FieldName = 'Pack'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 105
          end
          object CountSPMin: TcxGridDBColumn [7]
            Caption = #1052#1110#1085#1110#1084#1072#1083#1100#1085#1072' '#1082#1110#1083#1100#1082#1110#1089#1090#1100' '#1092#1086#1088#1084' '#1074#1080#1087#1091#1089#1082#1091' '#1076#1086' '#1087#1088#1086#1076#1072#1078#1091
            DataBinding.FieldName = 'CountSPMin'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 83
          end
          object CountSP: TcxGridDBColumn [8]
            Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1086#1076#1080#1085#1080#1094#1100' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091' '#1091' '#1089#1087#1086#1078#1080#1074#1095#1110#1081' '#1091#1087#1072#1082#1086#1074#1094#1110' (6)'
            DataBinding.FieldName = 'CountSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object GroupSP: TcxGridDBColumn [9]
            Caption = #1043#1088#1091#1087#1080' '#1074#1110#1076#1096#1082#1086#1076#1091'-'#1074#1072#1085#1085#1103' '#8211' '#1030' '#1072#1073#1086' '#1030#1030
            DataBinding.FieldName = 'GroupSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##; ; '
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 88
          end
          object CodeATX: TcxGridDBColumn [10]
            Caption = #1050#1086#1076' '#1040#1058#1061' (7)'
            DataBinding.FieldName = 'CodeATX'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 56
          end
          object MakerSP: TcxGridDBColumn [11]
            Caption = #1053#1072#1081#1084#1077#1085#1091#1074#1072#1085#1085#1103' '#1074#1080#1088#1086#1073#1085#1080#1082#1072', '#1082#1088#1072#1111#1085#1072' (8)'
            DataBinding.FieldName = 'MakerSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 97
          end
          object ReestrSP: TcxGridDBColumn [12]
            Caption = #1053#1086#1084#1077#1088' '#1088#1077#1108#1089#1090#1088#1072#1094#1110#1081#1085#1086#1075#1086' '#1087#1086#1089#1074#1110#1076#1095#1077#1085#1085#1103' '#1085#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1080#1081' '#1079#1072#1089#1110#1073' (9)'
            DataBinding.FieldName = 'ReestrSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 116
          end
          object ReestrDateSP: TcxGridDBColumn [13]
            Caption = 
              #1044#1072#1090#1072' '#1079#1072#1082#1110#1085#1095#1077#1085#1085#1103' '#1089#1090#1088#1086#1082#1091' '#1076#1110#1111' '#1088#1077#1108#1089#1090#1088#1072#1094#1110#1081#1085#1086#1075#1086' '#1087#1086#1089#1074#1110#1076#1095#1077#1085#1085#1103' '#1085#1072' '#1083#1110#1082#1072#1088#1089#1100 +
              #1082#1080#1081' '#1079#1072#1089#1110#1073' (10)'
            DataBinding.FieldName = 'ReestrDateSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 121
          end
          object PriceOptSP: TcxGridDBColumn [14]
            Caption = #1054#1087#1090#1086#1074#1086'- '#1074#1110#1076#1087#1091#1089#1082#1085#1072' '#1094#1110#1085#1072' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091', '#1075#1088#1085' (11)'
            DataBinding.FieldName = 'PriceOptSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 91
          end
          object PriceRetSP: TcxGridDBColumn [15]
            Caption = #1056#1086#1079#1076#1088#1110#1073#1085#1072' '#1094#1110#1085#1072' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091', '#1075#1088#1085' (12)'
            DataBinding.FieldName = 'PriceRetSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 68
          end
          object DailyNormSP: TcxGridDBColumn [16]
            Caption = #1044#1086#1073#1086#1074#1072' '#1076#1086#1079#1072' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091', '#1088#1077#1082#1086#1084#1077#1085#1076#1086#1074#1072#1085#1072' '#1042#1054#1054#1047' (13)'
            DataBinding.FieldName = 'DailyNormSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 135
          end
          object DailyCompensationSP: TcxGridDBColumn [17]
            Caption = #1056#1086#1079#1084#1110#1088' '#1074#1110#1076#1096#1082#1086#1076#1091#1074#1072#1085#1085#1103' '#1076#1086#1073#1086#1074#1086#1111' '#1076#1086#1079#1080' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091', '#1075#1088#1085' (14)'
            DataBinding.FieldName = 'DailyCompensationSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 111
          end
          object PriceSP: TcxGridDBColumn [18]
            Caption = #1056#1086#1079#1084#1110#1088' '#1074#1110#1076#1096#1082#1086#1076#1091#1074#1072#1085#1085#1103' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091', '#1075#1088#1085' (15)'
            DataBinding.FieldName = 'PriceSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
          object PaymentSP: TcxGridDBColumn [19]
            Caption = #1057#1091#1084#1072' '#1076#1086#1087#1083#1072#1090#1080' '#1079#1072' '#1091#1087#1072#1082#1086#1074#1082#1091', '#1075#1088#1085' (16)'
            DataBinding.FieldName = 'PaymentSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 89
          end
          object IdSP: TcxGridDBColumn [20]
            Caption = 'ID '#1083#1110#1082#1072#1088'. '#1079#1072#1089#1086#1073#1091
            DataBinding.FieldName = 'IdSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 'ID '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091
            Width = 60
          end
          object DosageIdSP: TcxGridDBColumn [21]
            Caption = 'DosageID '#1083#1110#1082#1072#1088'. '#1079#1072#1089#1086#1073#1091
            DataBinding.FieldName = 'DosageIdSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 'DosageID '#1083#1110#1082#1072#1088#1089#1100#1082#1086#1075#1086' '#1079#1072#1089#1086#1073#1091
            Width = 63
          end
          object NumeratorUnitSP: TcxGridDBColumn [22]
            Caption = #1054#1076#1080#1085#1080#1094#1103' '#1074#1080#1084#1110#1088#1091' '#1089#1080#1083#1080' '#1076#1110#1111
            DataBinding.FieldName = 'NumeratorUnitSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1076#1080#1085#1080#1094#1103' '#1074#1080#1084#1110#1088#1091' '#1089#1080#1083#1080' '#1076#1110#1111
            Width = 60
          end
          object DenumeratorValueSP: TcxGridDBColumn [23]
            Caption = #1050#1110#1083#1100#1082#1110#1089#1090#1100' '#1089#1091#1090#1085#1086#1089#1090#1110
            DataBinding.FieldName = 'DenumeratorValueSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 76
          end
          object DenumeratorUnitSP: TcxGridDBColumn [24]
            Caption = #1054#1076#1080#1085#1080#1094#1103' '#1074#1080#1084#1110#1088#1091' '#1089#1091#1090#1085#1086#1089#1090#1110
            DataBinding.FieldName = 'DenumeratorUnitSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1076#1080#1085#1080#1094#1103' '#1074#1080#1084#1110#1088#1091' '#1089#1091#1090#1085#1086#1089#1090#1110
            Width = 60
          end
          object ProgramIdSP: TcxGridDBColumn [25]
            Caption = 'ID '#1091#1095#1072#1089#1085#1080#1082#1072' '#1087#1088#1086#1075#1088#1072#1084#1080
            DataBinding.FieldName = 'ProgramIdSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 'ID '#1091#1095#1072#1089#1085#1080#1082#1072' '#1087#1088#1086#1075#1088#1072#1084#1080
            Width = 65
          end
          inherited colIsErased: TcxGridDBColumn
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1043
    TabOrder = 3
    ExplicitWidth = 1043
    inherited edInvNumber: TcxTextEdit
      Left = 182
      ExplicitLeft = 182
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 182
      ExplicitLeft = 182
    end
    inherited edOperDate: TcxDateEdit
      Left = 266
      EditValue = 42951d
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 266
      ExplicitWidth = 86
      Width = 86
    end
    inherited cxLabel2: TcxLabel
      Left = 266
      ExplicitLeft = 266
    end
    inherited ceStatus: TcxButtonEdit
      ExplicitWidth = 166
      ExplicitHeight = 22
      Width = 166
    end
    object edOperDateEnd: TcxDateEdit
      Left = 472
      Top = 23
      EditValue = 43326d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 6
      Width = 103
    end
    object cxLabel4: TcxLabel
      Left = 472
      Top = 5
      Caption = #1054#1082#1086#1085'. '#1089#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
    end
    object edMedicalProgramSP: TcxButtonEdit
      Left = 592
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 296
    end
    object cxLabel5: TcxLabel
      Left = 592
      Top = 5
      Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1072#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1072
    end
    object cxLabel6: TcxLabel
      Left = 901
      Top = 5
      Caption = '% '#1085#1072#1094#1077#1085#1082#1080
    end
    object ctPercentMarkup: TcxCurrencyEdit
      Left = 901
      Top = 23
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      TabOrder = 11
      Width = 60
    end
  end
  object edOperDateStart: TcxDateEdit [2]
    Left = 373
    Top = 23
    EditValue = 43326d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 6
    Width = 93
  end
  object cxLabel3: TcxLabel [3]
    Left = 373
    Top = 5
    Caption = #1053#1072#1095'.'#1089#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 387
    Top = 416
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 296
    Top = 352
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    object actDoLoadDop: TExecuteImportSettingsAction [0]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingDopId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actRefreshMI: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      TabSheet = tsMain
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
    object actGetImportSettingDop: TdsdExecStoredProc [2]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingDopId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingDopId
        end>
      Caption = 'actGetImportSetting'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1086#1087'. '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091'  '#1080#1079' '#1092#1072#1081#1083#1072
    end
    inherited actRefresh: TdsdDataSetRefresh
      RefreshOnTabSetChanges = True
    end
    object macStartLoadDop: TMultiAction [5]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingDop
        end
        item
          Action = actDoLoadDop
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1044#1086#1087'. '#1076#1072#1085#1085#1099#1093' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100'  '#1044#1086#1087'. '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091' '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1086#1087'. '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091' '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 48
      WithoutNext = True
    end
    object macStartLoadHelsi: TMultiAction [7]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingHelsi
        end
        item
          Action = actDoLoadHelsi
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1044#1086#1087'. '#1076#1072#1085#1085#1099#1093' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091' '#1080#1079' '#1092#1072#1081#1083#1072' ('#1061#1077#1083#1089#1080')?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100'  '#1044#1086#1087'. '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091' '#1080#1079' '#1092#1072#1081#1083#1072' ('#1061#1077#1083#1089#1080')'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1086#1087'. '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091' '#1080#1079' '#1092#1072#1081#1083#1072' ('#1061#1077#1083#1089#1080')'
      ImageIndex = 30
      WithoutNext = True
    end
    object actInsertMI: TdsdExecStoredProc [10]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertMI
      StoredProcList = <
        item
          StoredProc = spInsertMI
        end>
      Caption = 'actInsertMI'
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint_GoodsSP
      StoredProcList = <
        item
          StoredProc = spSelectPrint_GoodsSP
        end>
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
      ReportName = #1057#1087#1080#1089#1072#1085#1080#1077
      ReportNameParam.Value = #1057#1087#1080#1089#1072#1085#1080#1077
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
          StoredProc = spGet
        end>
    end
    object actGoodsKindChoice: TOpenChoiceForm [19]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
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
    object actComplete: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementComplete
      StoredProcList = <
        item
          StoredProc = spMovementComplete
        end
        item
          StoredProc = spGet
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1076#1085#1080#1084' '#1095#1080#1089#1083#1086#1084
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1076#1085#1080#1084' '#1095#1080#1089#1083#1086#1084
      ImageIndex = 12
    end
    object actIntenalSPChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TIntenalSPForm'
      FormName = 'TIntenalSPForm'
      FormNameParam.Value = 'TIntenalSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'IntenalSPId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'IntenalSPName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actKindOutSPChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TKindOutSPForm'
      FormName = 'TKindOutSPForm'
      FormNameParam.Value = 'TKindOutSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'KindOutSPId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'KindOutSPName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actBrandSPChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TBrandSPForm'
      FormName = 'TBrandSPForm'
      FormNameParam.Value = 'TBrandSPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BrandSPId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BrandSPName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceMovGoodsSP: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TBrandSPForm'
      FormName = 'TGoodsSPJournalChoiceForm'
      FormNameParam.Value = 'TGoodsSPJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'MovementId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object macInsertMI: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actChoiceMovGoodsSP
        end
        item
          Action = actInsertMI
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1076#1086#1073#1072#1074#1080#1090#1100' '#1090#1086#1074#1072#1088#1099' '#1080#1079' '#1076#1088#1091#1075#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1076#1086#1073#1072#1074#1083#1077#1085#1099
      Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1076#1088#1091#1075#1086#1075#1086' '#1076#1086#1082'-'#1090#1072
      Hint = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1076#1088#1091#1075#1086#1075#1086' '#1076#1086#1082'-'#1090#1072
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = '0'
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actGetImportSetting: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSetting'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091'  '#1080#1079' '#1092#1072#1081#1083#1072
    end
    object actSetErasedGoodsSp: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isSp_SetErased
      StoredProcList = <
        item
          StoredProc = spUpdate_isSp_SetErased
        end>
      Caption = 'actGetImportSetting'
    end
    object macStartLoad: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1044#1072#1085#1085#1099#1093' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091'  '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091'  '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091'  '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 41
      WithoutNext = True
    end
    object actGetImportSettingHelsi: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingHelsiId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingHelsiId
        end>
      Caption = 'actGetImportSetting'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1086#1087'. '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091'  '#1080#1079' '#1092#1072#1081#1083#1072' ('#1061#1077#1083#1089#1080')'
    end
    object actDoLoadHelsi: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingHelsiId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
  end
  inherited MasterDS: TDataSource
    Left = 192
    Top = 432
  end
  inherited MasterCDS: TClientDataSet
    Left = 256
    Top = 432
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_GoodsSP'
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
      end>
    Left = 160
    Top = 248
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
          ItemName = 'bbInsertMI'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
          ItemName = 'bbStartLoad'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStartLoadDop'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbStartLoadHelsi'
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
    object bbComplete: TdxBarButton
      Action = actComplete
      Category = 0
    end
    object bbInsertMI: TdxBarButton
      Action = macInsertMI
      Category = 0
      ImageIndex = 27
    end
    object bbStartLoad: TdxBarButton
      Action = macStartLoad
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1044#1072#1085#1085#1099#1077' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091' '#1080#1079' '#1092#1072#1081#1083#1072
      Category = 0
    end
    object bbStartLoadDop: TdxBarButton
      Action = macStartLoadDop
      Category = 0
    end
    object bbStartLoadHelsi: TdxBarButton
      Action = macStartLoadHelsi
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
    SearchAsFilter = False
    Left = 694
    Top = 185
  end
  inherited PopupMenu: TPopupMenu
    Left = 712
    Top = 408
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
        Value = '0'
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
        Name = 'ReportNameLoss'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameLossTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameLossBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMask'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingDopId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingIsSpecConditionId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingHelsiId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 808
    Top = 240
  end
  inherited StatusGuides: TdsdGuides
    Left = 57
    Top = 16
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_GoodsSP'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 120
    Top = 16
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_GoodsSP'
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
        Name = 'inMask'
        Value = False
        Component = FormParams
        ComponentItem = 'inMask'
        DataType = ftBoolean
        ParamType = ptInput
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
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
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
        Name = 'OperDateStart'
        Value = Null
        Component = edOperDateStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateEnd'
        Value = Null
        Component = edOperDateEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'MedicalProgramSPId'
        Value = Null
        Component = GuidesMedicalProgramSP
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MedicalProgramSPName'
        Value = Null
        Component = GuidesMedicalProgramSP
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentMarkup'
        Value = Null
        Component = ctPercentMarkup
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_GoodsSP'
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
        Name = 'inOperDateStart'
        Value = Null
        Component = edOperDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateEnd'
        Value = Null
        Component = edOperDateEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMedicalProgramSPId'
        Value = Null
        Component = GuidesMedicalProgramSP
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercentMarkup'
        Value = Null
        Component = ctPercentMarkup
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesMedicalProgramSP
      end
      item
      end
      item
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
        Control = edOperDate
      end
      item
        Control = edOperDateEnd
      end
      item
        Control = edOperDateStart
      end
      item
        Control = edMedicalProgramSP
      end
      item
        Control = ctPercentMarkup
      end>
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 696
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_GoodsSP_SetErased'
    Left = 598
    Top = 464
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_GoodsSP_SetUnErased'
    Left = 718
    Top = 464
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_GoodsSP'
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
        Name = 'inIntenalSPId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IntenalSPId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBrandSPId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BrandSPId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKindOutSPId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'KindOutSPId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inColSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ColSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountSPMin'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountSPMin'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceOptSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceOptSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceRetSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceRetSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDailyNormSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DailyNormSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDailyCompensationSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DailyCompensationSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaymentSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PaymentSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGroupSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GroupSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDenumeratorValueSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DenumeratorValueSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPack'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Pack'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCodeATX'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CodeATX'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMakerSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MakerSP'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReestrSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReestrSP'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReestrDateSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReestrDateSP'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIdSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IdSP'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDosageIdSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DosageIdSP'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProgramIdSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ProgramIdSP'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumeratorUnitSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NumeratorUnitSP'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDenumeratorUnitSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DenumeratorUnitSP'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_GoodsSP'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
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
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIntenalSPId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IntenalSPId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBrandSPId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BrandSPId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKindOutSPId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'KindOutSPId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inColSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ColSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceOptSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceOptSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceRetSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceRetSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDailyNormSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DailyNormSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDailyCompensationSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DailyCompensationSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaymentSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PaymentSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGroupSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GroupSP'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPack'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Pack'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCodeATX'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CodeATX'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMakerSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MakerSP'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReestrSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReestrSP'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReestrDateSP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReestrDateSP'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 420
    Top = 188
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshPrice
    ComponentList = <
      item
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
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 644
    Top = 334
  end
  object spSelectPrint_GoodsSP: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_GoodsSP_Print'
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
  object spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_GoodsSP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = False
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 56
    Top = 384
  end
  object spInsertMI: TdsdStoredProc
    StoredProcName = 'gpInsert_MI_GoodsSP_Mask'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Mask'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    Left = 767
    Top = 312
  end
  object spUpdate_isSp_SetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_GoodsSP'
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 939
    Top = 398
  end
  object spGetImportSettingId: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TGoodsSPMovementForm;zc_Object_ImportSetting_GoodsSPMovement'
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
    Left = 912
    Top = 240
  end
  object spGetImportSettingDopId: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TGoodsSPMovementForm;zc_Object_ImportSetting_GoodsSPDopMovement'
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
        ComponentItem = 'ImportSettingDopId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 912
    Top = 296
  end
  object spGetImportSettingHelsiId: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TGoodsSPMovementForm;zc_Object_ImportSetting_GoodsSPMovementHels' +
          'i'
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
        ComponentItem = 'ImportSettingHelsiId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 840
    Top = 360
  end
  object GuidesMedicalProgramSP: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMedicalProgramSP
    FormNameParam.Value = 'TMedicalProgramSPForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMedicalProgramSPForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMedicalProgramSP
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMedicalProgramSP
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 777
    Top = 11
  end
end
