inherited ContractEditForm: TContractEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1075#1086#1074#1086#1088'>'
  ClientHeight = 713
  ClientWidth = 934
  ExplicitWidth = 940
  ExplicitHeight = 742
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 67
    Top = 687
    Height = 23
    TabOrder = 2
    ExplicitLeft = 67
    ExplicitTop = 687
    ExplicitHeight = 23
  end
  inherited bbCancel: TcxButton
    Left = 213
    Top = 687
    Height = 23
    ExplicitLeft = 213
    ExplicitTop = 687
    ExplicitHeight = 23
  end
  object edInvNumber: TcxTextEdit [2]
    Left = 16
    Top = 104
    TabOrder = 0
    Width = 104
  end
  object LbInvNumber: TcxLabel [3]
    Left = 16
    Top = 87
    Caption = #8470' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object cxLabel3: TcxLabel [4]
    Left = 16
    Top = 316
    Caption = #1042#1080#1076' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object cxLabel4: TcxLabel [5]
    Left = 127
    Top = 201
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object ceComment: TcxTextEdit [6]
    Left = 183
    Top = 656
    TabOrder = 4
    Width = 161
  end
  object cxLabel5: TcxLabel [7]
    Left = 184
    Top = 639
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edContractKind: TcxButtonEdit [8]
    Left = 16
    Top = 333
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 162
  end
  object edJuridical: TcxButtonEdit [9]
    Left = 127
    Top = 218
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 217
  end
  object edSigningDate: TcxDateEdit [10]
    Left = 16
    Top = 141
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 8
    Width = 104
  end
  object cxLabel1: TcxLabel [11]
    Left = 17
    Top = 124
    Caption = #1044#1072#1090#1072' '#1079#1072#1082#1083#1102#1095#1077#1085#1080#1103
  end
  object cxLabel2: TcxLabel [12]
    Left = 127
    Top = 124
    Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1089
  end
  object edStartDate: TcxDateEdit [13]
    Left = 127
    Top = 141
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 11
    Width = 103
  end
  object edEndDate: TcxDateEdit [14]
    Left = 239
    Top = 141
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 12
    Width = 105
  end
  object cxLabel6: TcxLabel [15]
    Left = 239
    Top = 124
    Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1076#1086
  end
  object cxLabel9: TcxLabel [16]
    Left = 18
    Top = 278
    Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
  end
  object edInfoMoney: TcxButtonEdit [17]
    Left = 16
    Top = 295
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 328
  end
  object edPaidKind: TcxButtonEdit [18]
    Left = 16
    Top = 218
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 104
  end
  object cxLabel10: TcxLabel [19]
    Left = 17
    Top = 201
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
  end
  object cxLabel11: TcxLabel [20]
    Left = 17
    Top = -1
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit [21]
    Left = 17
    Top = 14
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 58
  end
  object cxLabel12: TcxLabel [22]
    Left = 183
    Top = 316
    Caption = #1055#1086#1088#1103#1076#1082#1086#1074#1099#1081' '#8470
  end
  object edInvNumberArchive: TcxTextEdit [23]
    Left = 184
    Top = 333
    TabOrder = 21
    Width = 161
  end
  object cxLabel7: TcxLabel [24]
    Left = 16
    Top = 395
    Caption = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
  end
  object edPersonal: TcxButtonEdit [25]
    Left = 16
    Top = 412
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 23
    Width = 162
  end
  object cxLabel8: TcxLabel [26]
    Left = 184
    Top = 396
    Caption = #1056#1077#1075#1080#1086#1085' ('#1076#1086#1075#1086#1074#1086#1088')'
  end
  object edAreaContract: TcxButtonEdit [27]
    Left = 183
    Top = 414
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 25
    Width = 161
  end
  object cxLabel13: TcxLabel [28]
    Left = 18
    Top = 353
    Caption = #1055#1088#1077#1076#1084#1077#1090' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object edContractArticle: TcxButtonEdit [29]
    Left = 16
    Top = 370
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 27
    Width = 162
  end
  object cxLabel14: TcxLabel [30]
    Left = 183
    Top = 353
    Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object edContractStateKind: TcxButtonEdit [31]
    Left = 183
    Top = 371
    Properties.Buttons = <
      item
        Action = actGetStateKindUnSigned
        Kind = bkGlyph
      end
      item
        Action = actGetStateKindPartner
        Kind = bkGlyph
      end
      item
        Action = actGetStateKindSigned
        Default = True
        Kind = bkGlyph
      end
      item
        Action = actGetStateKindClose
        Kind = bkGlyph
      end>
    Properties.Images = dmMain.ImageList
    Properties.ReadOnly = True
    TabOrder = 29
    Width = 161
  end
  object Panel: TPanel [32]
    Left = 375
    Top = 0
    Width = 559
    Height = 713
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 30
    object cxGridContractCondition: TcxGrid
      Left = 0
      Top = 26
      Width = 559
      Height = 198
      Align = alTop
      TabOrder = 0
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = False
      LookAndFeel.SkinName = ''
      object cxGridDBTableViewContractCondition: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = ContractConditionDS
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
        OptionsData.Inserting = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object BonusKindName: TcxGridDBColumn
          Caption = #1042#1080#1076' '#1073#1086#1085#1091#1089#1072
          DataBinding.FieldName = 'BonusKindName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = BonusKindChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 79
        end
        object ContractConditionKindName: TcxGridDBColumn
          Caption = #1059#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
          DataBinding.FieldName = 'ContractConditionKindName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = ContractConditionKindChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 96
        end
        object Value: TcxGridDBColumn
          Caption = #1047#1085#1072#1095#1077#1085#1080#1077
          DataBinding.FieldName = 'Value'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 53
        end
        object PercentRetBonus: TcxGridDBColumn
          Caption = '% '#1074#1086#1079#1074'. '#1087#1083#1072#1085
          DataBinding.FieldName = 'PercentRetBonus'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.##;-,0.##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = '% '#1074#1086#1079#1074#1088#1072#1090#1072' '#1087#1083#1072#1085
          Width = 62
        end
        object InfoMoneyName: TcxGridDBColumn
          Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
          DataBinding.FieldName = 'InfoMoneyName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = InfoMoneyChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 84
        end
        object ContractSendName: TcxGridDBColumn
          Caption = #8470' '#1076#1086#1075'. '#1084#1072#1088#1082#1077#1090#1080#1085#1075
          DataBinding.FieldName = 'ContractSendName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actContractSendChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #8470' '#1076#1086#1075#1086#1074#1086#1088#1072' '#1087#1077#1088#1077#1074#1099#1089#1090#1072#1074#1083#1077#1085#1080#1077' '#1084#1072#1088#1082#1077#1090#1080#1085#1075
          Width = 57
        end
        object ContractStateKindCode_Send: TcxGridDBColumn
          Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1075'. '#1084#1072#1088#1082#1077#1090'.'
          DataBinding.FieldName = 'ContractStateKindCode_Send'
          PropertiesClassName = 'TcxImageComboBoxProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.Alignment.Vert = taVCenter
          Properties.Images = dmMain.ImageList
          Properties.Items = <
            item
              Description = #1055#1086#1076#1087#1080#1089#1072#1085
              ImageIndex = 12
              Value = 1
            end
            item
              Description = #1053#1077' '#1087#1086#1076#1087#1080#1089#1072#1085
              ImageIndex = 11
              Value = 2
            end
            item
              Description = #1047#1072#1074#1077#1088#1096#1077#1085
              ImageIndex = 13
              Value = 3
            end
            item
              Description = #1059' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
              ImageIndex = 66
              Value = 4
            end>
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 67
        end
        object ContractTagName_Send: TcxGridDBColumn
          Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'. '#1084#1072#1088#1082#1077#1090'.'
          DataBinding.FieldName = 'ContractTagName_Send'
          Visible = False
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 120
        end
        object InfoMoneyCode_Send: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1059#1055
          DataBinding.FieldName = 'InfoMoneyCode_Send'
          Visible = False
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 120
        end
        object InfoMoneyName_Send: TcxGridDBColumn
          Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
          DataBinding.FieldName = 'InfoMoneyName_Send'
          Visible = False
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 120
        end
        object JuridicalCode_Send: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1102#1088'.'#1083'.'
          DataBinding.FieldName = 'JuridicalCode_Send'
          Visible = False
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 120
        end
        object JuridicalName_Send: TcxGridDBColumn
          Caption = #1070#1088'. '#1083#1080#1094#1086
          DataBinding.FieldName = 'JuridicalName_Send'
          Visible = False
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 120
        end
        object Comment: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          DataBinding.FieldName = 'Comment'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 76
        end
        object colStartDate: TcxGridDBColumn
          Caption = #1044#1077#1081#1089#1090#1091#1077#1090' '#1089
          DataBinding.FieldName = 'StartDate'
          FooterAlignmentHorz = taCenter
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 55
        end
        object colEndDate: TcxGridDBColumn
          Caption = #1044#1077#1081#1089#1090#1091#1077#1090' '#1087#1086
          DataBinding.FieldName = 'EndDate'
          FooterAlignmentHorz = taCenter
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderGlyphAlignmentHorz = taCenter
          Options.Editing = False
          Width = 43
        end
        object сolPaidKindName: TcxGridDBColumn
          Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
          DataBinding.FieldName = 'PaidKindName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = PaidKindChoiceFormСС
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object isErased: TcxGridDBColumn
          Caption = #1059#1076#1072#1083#1077#1085
          DataBinding.FieldName = 'isErased'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
        end
      end
      object cxGridContractConditionLevel: TcxGridLevel
        GridView = cxGridDBTableViewContractCondition
      end
    end
    object dxBarDockControl1: TdxBarDockControl
      Left = 0
      Top = 0
      Width = 559
      Height = 26
      Align = dalTop
      BarManager = BarManager
    end
    object dxBarDockControl2: TdxBarDockControl
      Left = 0
      Top = 224
      Width = 559
      Height = 26
      Align = dalTop
      BarManager = BarManager
    end
    object cxDBVerticalGrid: TcxDBVerticalGrid
      Left = 0
      Top = 414
      Width = 559
      Height = 297
      Images = dmMain.ImageList
      LayoutStyle = lsMultiRecordView
      OptionsView.RowHeaderWidth = 109
      OptionsView.RowHeight = 60
      OptionsView.ValueWidth = 104
      OptionsData.Editing = False
      OptionsData.Appending = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      Navigator.Buttons.CustomButtons = <>
      Styles.Header = dmMain.cxHeaderStyle
      TabOrder = 3
      DataController.DataSource = DocumentDS
      Version = 1
      object colFileName: TcxDBEditorRow
        Options.CanAutoHeight = False
        Height = 142
        Properties.Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
        Properties.HeaderAlignmentHorz = taCenter
        Properties.HeaderAlignmentVert = vaCenter
        Properties.ImageIndex = 28
        Properties.EditPropertiesClassName = 'TcxLabelProperties'
        Properties.EditProperties.Alignment.Horz = taCenter
        Properties.EditProperties.Alignment.Vert = taVCenter
        Properties.EditProperties.WordWrap = True
        Properties.DataBinding.FieldName = 'FileName'
        Properties.Options.Editing = False
        ID = 0
        ParentID = -1
        Index = 0
        Version = 1
      end
    end
    object cxLabel37: TcxLabel
      Left = 7
      Top = 273
      Caption = #1060#1080#1083#1080#1072#1083' ('#1088#1072#1089#1095#1077#1090#1099' '#1085#1072#1083')'
    end
    object edBranch: TcxButtonEdit
      Left = 7
      Top = 289
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 218
    end
    object cbisNotTareReturning: TcxCheckBox
      Left = 7
      Top = 330
      Caption = #1053#1077#1090' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1090#1072#1088#1099
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      Width = 122
    end
  end
  object cxLabel15: TcxLabel [33]
    Left = 18
    Top = 600
    Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object edMainJuridical: TcxButtonEdit [34]
    Left = 17
    Top = 615
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 35
    Width = 161
  end
  object cxLabel16: TcxLabel [35]
    Left = 16
    Top = 558
    Caption = #1041#1072#1085#1082' ('#1080#1089#1093'.'#1087#1083#1072#1090#1077#1078')'
  end
  object edBankId: TcxButtonEdit [36]
    Left = 16
    Top = 574
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 36
    Width = 162
  end
  object edBankAccountExternal: TcxTextEdit [37]
    Left = 184
    Top = 535
    Hint = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090' ('#1080#1089#1093'.'#1087#1083#1072#1090#1077#1078') - '#1087#1088#1080' '#1087#1077#1095#1072#1090#1080' '#1069#1082#1089#1087#1086#1088#1090#1072
    TabOrder = 38
    Width = 161
  end
  object cxLabel17: TcxLabel [38]
    Left = 184
    Top = 518
    Hint = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090' ('#1080#1089#1093'.'#1087#1083#1072#1090#1077#1078') - '#1087#1088#1080' '#1087#1077#1095#1072#1090#1080' '#1069#1082#1089#1087#1086#1088#1090#1072
    Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090' ('#1080#1089#1093'.'#1087#1083#1072#1090#1077#1078')'
  end
  object cbisDefault: TcxCheckBox [39]
    Left = 86
    Top = 25
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
    ParentShowHint = False
    ShowHint = True
    TabOrder = 39
    Width = 97
  end
  object ceisStandart: TcxCheckBox [40]
    Left = 86
    Top = 5
    Caption = #1058#1080#1087#1086#1074#1086#1081
    TabOrder = 42
    Width = 67
  end
  object cxLabel18: TcxLabel [41]
    Left = 184
    Top = 439
    Caption = #1058#1055' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
  end
  object cxLabel19: TcxLabel [42]
    Left = 18
    Top = 439
    Caption = #1041#1091#1093#1075'.'#1089#1074#1077#1088#1082#1072' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
  end
  object edPersonalTrade: TcxButtonEdit [43]
    Left = 184
    Top = 456
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 43
    Width = 161
  end
  object edPersonalCollation: TcxButtonEdit [44]
    Left = 16
    Top = 456
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 46
    Width = 162
  end
  object cxLabel20: TcxLabel [45]
    Left = 16
    Top = 518
    Hint = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090' ('#1074#1093'.'#1087#1083#1072#1090#1077#1078') - '#1087#1086#1082#1072#1079#1072#1090#1100' '#1087#1088#1080' '#1087#1077#1095#1072#1090#1080' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
    Caption = #1056#1072#1089#1095'.'#1089#1095'.('#1074#1093'.'#1087#1083#1072#1090#1077#1078') '#1087#1077#1095'.'#1085#1072#1082#1083'.'
  end
  object cxLabel21: TcxLabel [46]
    Left = 127
    Top = 87
    Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075#1086#1074#1086#1088#1072
  end
  object edContractTag: TcxButtonEdit [47]
    Left = 127
    Top = 104
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 47
    Width = 101
  end
  object ceBankAccount: TcxButtonEdit [48]
    Left = 16
    Top = 534
    Hint = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090' ('#1074#1093'.'#1087#1083#1072#1090#1077#1078') - '#1087#1086#1082#1072#1079#1072#1090#1100' '#1087#1088#1080' '#1087#1077#1095#1072#1090#1080' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 48
    Width = 162
  end
  object ceisPersonal: TcxCheckBox [49]
    Left = 162
    Top = 5
    Hint = #1057#1083#1091#1078#1077#1073#1085#1072#1103' '#1079#1072#1087#1080#1089#1082#1072
    Caption = #1057#1083#1091#1078'. '#1079#1072#1087#1080#1089#1082#1072
    ParentShowHint = False
    ShowHint = True
    TabOrder = 49
    Width = 98
  end
  object ceIsUnique: TcxCheckBox [50]
    Left = 275
    Top = 5
    Caption = #1056#1072#1089#1095#1077#1090' '#1076#1086#1083#1075#1072
    TabOrder = 51
    Width = 92
  end
  object cxLabel22: TcxLabel [51]
    Left = 185
    Top = 480
    Caption = #1050#1086#1076' GLN - '#1087#1086#1089#1090#1072#1074#1097#1080#1082
  end
  object edGLNCode: TcxTextEdit [52]
    Left = 183
    Top = 495
    TabOrder = 53
    Width = 161
  end
  object cxLabel23: TcxLabel [53]
    Left = 16
    Top = 238
    Caption = #1070#1088'. '#1083#1080#1094#1086'('#1087#1077#1095#1072#1090#1100' '#1076#1086#1082'.)'
  end
  object edJuridicalDocument: TcxButtonEdit [54]
    Left = 16
    Top = 256
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 55
    Width = 162
  end
  object cxLabel24: TcxLabel [55]
    Left = 185
    Top = 598
    Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
  end
  object cePriceList: TcxButtonEdit [56]
    Left = 184
    Top = 615
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 57
    Width = 160
  end
  object cxLabel25: TcxLabel [57]
    Left = 352
    Top = 526
    Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' ('#1040#1082#1094#1080#1086#1085#1085#1099#1081')'
    Visible = False
  end
  object cePriceListPromo: TcxButtonEdit [58]
    Left = 367
    Top = 540
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 59
    Visible = False
    Width = 161
  end
  object cxLabel26: TcxLabel [59]
    Left = 352
    Top = 567
    Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1072#1082#1094#1080#1080
    Visible = False
  end
  object edStartPromo: TcxDateEdit [60]
    Left = 352
    Top = 582
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    Properties.ValidateOnEnter = False
    TabOrder = 61
    Visible = False
    Width = 100
  end
  object cxLabel27: TcxLabel [61]
    Left = 458
    Top = 567
    Caption = #1044#1072#1090#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1072#1082#1094#1080#1080
    Visible = False
  end
  object edEndPromo: TcxDateEdit [62]
    Left = 460
    Top = 582
    EditValue = 0d
    Properties.SaveTime = False
    Properties.ShowTime = False
    Properties.ValidateOnEnter = False
    TabOrder = 63
    Visible = False
    Width = 100
  end
  object cxLabel28: TcxLabel [63]
    Left = 16
    Top = 639
    Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1072
  end
  object ceGoodsProperty: TcxButtonEdit [64]
    Left = 16
    Top = 656
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 64
    Width = 160
  end
  object edTerm: TcxCurrencyEdit [65]
    Left = 16
    Top = 179
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 67
    Width = 104
  end
  object cxLabel29: TcxLabel [66]
    Left = 18
    Top = 163
    Caption = #1055#1077#1088#1080#1086#1076' '#1087#1088#1086#1083#1086#1085#1075'.'
  end
  object cxLabel30: TcxLabel [67]
    Left = 127
    Top = 163
    Caption = #1058#1080#1087' '#1087#1088#1086#1083#1086#1085#1075#1072#1094#1080#1080
  end
  object edContractTermKind: TcxButtonEdit [68]
    Left = 127
    Top = 179
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 69
    Width = 125
  end
  object cxLabel31: TcxLabel [69]
    Left = 17
    Top = 480
    Caption = 'C'#1086#1090#1088#1091#1076#1085#1080#1082' ('#1087#1086#1076#1087#1080#1089#1072#1085#1090')'
  end
  object edPersonalSigning: TcxButtonEdit [70]
    Left = 16
    Top = 495
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 71
    Width = 162
  end
  object cxLabel32: TcxLabel [71]
    Left = 264
    Top = 163
    Caption = #1042#1072#1083#1102#1090#1072
  end
  object ceCurrency: TcxButtonEdit [72]
    Left = 264
    Top = 179
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 72
    Width = 80
  end
  object edDayTaxSummary: TcxCurrencyEdit [73]
    Left = 239
    Top = 104
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 75
    Width = 105
  end
  object cxLabel33: TcxLabel [74]
    Left = 239
    Top = 87
    Caption = #1050#1086#1083'. '#1076#1085'. '#1089#1074#1086#1076#1085'. '#1053#1053
  end
  object cxLabel34: TcxLabel [75]
    Left = 184
    Top = 238
    Caption = #1070#1088'. '#1083#1080#1094#1086' ('#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082')'
  end
  object edJuridicalInvoice: TcxButtonEdit [76]
    Left = 184
    Top = 256
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 77
    Width = 160
  end
  object cxLabel35: TcxLabel [77]
    Left = 17
    Top = 33
    Hint = #1050#1086#1076' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
    Caption = #1050#1086#1076' '#1087#1086#1089#1090'.'
    ParentShowHint = False
    ShowHint = True
  end
  object edPartnerCode: TcxTextEdit [78]
    Left = 17
    Top = 48
    TabOrder = 78
    Width = 58
  end
  object cbisDefaultOut: TcxCheckBox [79]
    Left = 86
    Top = 45
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1080#1089#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1080#1089#1093'. '#1087#1083'.)'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 80
    Width = 155
  end
  object cxLabel36: TcxLabel [80]
    Left = 184
    Top = 557
    Hint = 
      #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103') - '#1076#1083#1103' '#1086#1073#1088#1072#1073#1086#1090#1082#1080' '#1087#1083#1072#1090#1077#1078#1072' '#1074' '#1073#1072#1085#1082'.'#1074#1099#1087#1080#1089 +
      #1082#1077
    Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103')'
  end
  object edBankAccountPartner: TcxTextEdit [81]
    Left = 184
    Top = 574
    Hint = 
      #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103') - '#1076#1083#1103' '#1086#1073#1088#1072#1073#1086#1090#1082#1080' '#1087#1083#1072#1090#1077#1078#1072' '#1074' '#1073#1072#1085#1082'.'#1074#1099#1087#1080#1089 +
      #1082#1077
    TabOrder = 81
    Width = 161
  end
  object cbisRealEx: TcxCheckBox [82]
    Left = 275
    Top = 25
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1060#1080#1079'. '#1086#1073#1084#1077#1085
    ParentShowHint = False
    ShowHint = True
    TabOrder = 82
    Width = 92
  end
  object cbNotVat: TcxCheckBox [83]
    Left = 275
    Top = 45
    Hint = #1082#1083#1080#1077#1085#1090' '#1073#1077#1079' '#1053#1044#1057' ('#1089#1090#1072#1074#1082#1072' 0%)'
    Caption = #1073#1077#1079' '#1053#1044#1057' (0%)'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 86
    Width = 92
  end
  object cbMarketNot: TcxCheckBox [84]
    Left = 86
    Top = 64
    Hint = #1057#1083#1091#1078#1077#1073#1085#1072#1103' '#1079#1072#1087#1080#1089#1082#1072
    Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1085#1099#1081' '#1076#1086#1089#1090#1091#1087' '#1084#1072#1088#1082#1077#1090#1080#1085#1075
    ParentShowHint = False
    ShowHint = True
    TabOrder = 88
    Width = 194
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 587
    Top = 508
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 392
    Top = 467
  end
  inherited ActionList: TActionList
    Left = 437
    Top = 381
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelectContractCondition
        end
        item
          StoredProc = spDocumentSelect
        end>
    end
    object actConditionRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ContractConditionKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContractConditionKindChoiceForm'
      FormName = 'TContractConditionKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = ContractConditionCDS
          ComponentItem = 'ContractConditionKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ContractConditionCDS
          ComponentItem = 'ContractConditionKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object InsertRecordCCK: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewContractCondition
      Action = ContractConditionKindChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1080#1087' '#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
      Hint = #1058#1080#1087' '#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
      ImageIndex = 0
    end
    object InfoMoneyChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'InfoMoneyChoiceForm'
      FormName = 'TInfoMoney_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ContractConditionCDS
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ContractConditionCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actContractCondition: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateContractCondition
      StoredProcList = <
        item
          StoredProc = spInsertUpdateContractCondition
        end>
      Caption = 'actUpdateDataSetCCK'
      DataSource = ContractConditionDS
    end
    object BonusKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'BonusKindChoiceForm'
      FormName = 'TBonusKindForm'
      FormNameParam.Value = 'TBonusKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = ContractConditionCDS
          ComponentItem = 'BonusKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ContractConditionCDS
          ComponentItem = 'BonusKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actInsertDocument: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertDocument
      StoredProcList = <
        item
          StoredProc = spInsertDocument
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 0
    end
    object DocumentRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spDocumentSelect
      StoredProcList = <
        item
          StoredProc = spDocumentSelect
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object DocumentOpenAction: TDocumentOpenAction
      Category = 'DSDLib'
      MoveParams = <>
      Document = Document
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1080
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1080
      ImageIndex = 60
    end
    object MultiActionInsertContractCondition: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spInserUpdateContract
        end
        item
          Action = InsertRecordCCK
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1091#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1091#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
      ImageIndex = 0
    end
    object MultiActionInsertDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spInserUpdateContract
        end
        item
          Action = actInsertDocument
        end
        item
          Action = DocumentRefresh
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
      ImageIndex = 0
    end
    object spInserUpdateContract: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'spInserUpdateContract'
    end
    object actSetErasedContractCondition: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedCondition
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedCondition
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1091#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1091#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ContractConditionDS
    end
    object actSetUnErasedContractCondition: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedCondition
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedCondition
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ContractConditionDS
    end
    object actDeleteDocument: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDeleteDocument
      StoredProcList = <
        item
          StoredProc = spDeleteDocument
        end
        item
          StoredProc = spDocumentSelect
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
      ImageIndex = 2
      QuestionBeforeExecute = #1042#1099' '#1076#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1093#1086#1090#1080#1090#1077' '#1091#1076#1072#1083#1080#1090#1100' '#1089#1082#1072#1085'-'#1082#1086#1087#1080#1102
    end
    object actGetStateKindUnSigned: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetStateKindUnSigned
      StoredProcList = <
        item
          StoredProc = spGetStateKindUnSigned
        end>
      Caption = 'actGetStateKindUnSigned'
      ImageIndex = 11
    end
    object actGetStateKindSigned: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetStateKindSigned
      StoredProcList = <
        item
          StoredProc = spGetStateKindSigned
        end>
      Caption = 'actGetStateKindSigned'
      ImageIndex = 12
    end
    object actGetStateKindPartner: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetStateKind_Partner
      StoredProcList = <
        item
          StoredProc = spGetStateKind_Partner
        end>
      Caption = 'actGetStateKindClose'
      ImageIndex = 66
    end
    object actGetStateKindClose: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetStateKindClose
      StoredProcList = <
        item
          StoredProc = spGetStateKindClose
        end>
      Caption = 'actGetStateKindClose'
      ImageIndex = 13
    end
    object actContractSendChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TContractChoiceForm'
      FormName = 'TContractChoiceForm'
      FormNameParam.Value = 'TContractChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ContractConditionCDS
          ComponentItem = 'ContractSendId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ContractConditionCDS
          ComponentItem = 'ContractSendName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = GuidesJuridical
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = GuidesJuridical
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actShowErasedCC: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectContractCondition
      StoredProcList = <
        item
          StoredProc = spSelectContractCondition
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1101#1083#1077#1084#1077#1085#1090#1099
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077' '#1101#1083#1077#1084#1077#1085#1090#1099
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object ProtocolOpenFormCondition: TdsdOpenForm
      Category = 'Condition'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' <'#1059#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072'>'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ContractConditionCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ContractConditionCDS
          ComponentItem = 'ContractConditionKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object PaidKindChoiceFormСС: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PaidKindChoiceForm'
      FormName = 'TPaidKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ContractConditionCDS
          ComponentItem = 'PaidKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ContractConditionCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 488
    Top = 423
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Contract'
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
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = edCode
        ParamType = ptInput
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
        Name = 'inInvNumberArchive'
        Value = ''
        Component = edInvNumberArchive
        DataType = ftString
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
        Name = 'inBankAccountExternal'
        Value = ''
        Component = edBankAccountExternal
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountPartner'
        Value = Null
        Component = edBankAccountPartner
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGLNCode'
        Value = ''
        Component = edGLNCode
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerCode'
        Value = Null
        Component = edPartnerCode
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTerm'
        Value = Null
        Component = edTerm
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDayTaxSummary'
        Value = Null
        Component = edDayTaxSummary
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSigningDate'
        Value = 0d
        Component = edSigningDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = 0d
        Component = edStartDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 0d
        Component = edEndDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = GuidesJuridical
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalBasisId'
        Value = ''
        Component = GuidesMainJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalDocumentId'
        Value = Null
        Component = GuidesJuridicalDocument
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalInvoiceId'
        Value = Null
        Component = GuidesJuridicalInvoice
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = GuidesInfoMoney
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractKindId'
        Value = ''
        Component = GuidesContractKind
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = GuidesPaidKind
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = ''
        Component = GuidesPersonal
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalTradeId'
        Value = ''
        Component = GuidesPersonalTrade
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalCollationId'
        Value = ''
        Component = GuidesPersonalCollation
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalSigningId'
        Value = Null
        Component = GuidesPersonalSigning
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountId'
        Value = ''
        Component = GuidesBankAccount
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractTagId'
        Value = ''
        Component = ContractTagGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAreaContractId'
        Value = ''
        Component = GuidesAreaContract
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractArticleId'
        Value = ''
        Component = GuidesContractArticle
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractStateKindId'
        Value = ''
        Component = ContractStateKindGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractTermKindId'
        Value = Null
        Component = GuidesContractTermKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId'
        Value = Null
        Component = GuidesCurrency
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankId'
        Value = ''
        Component = GuidesBank
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchId'
        Value = Null
        Component = GuidesBranch
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDefault'
        Value = False
        Component = cbisDefault
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDefaultOut'
        Value = Null
        Component = cbisDefaultOut
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisStandart'
        Value = False
        Component = ceisStandart
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPersonal'
        Value = False
        Component = ceisPersonal
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisUnique'
        Value = False
        Component = ceIsUnique
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisRealEx'
        Value = Null
        Component = cbisRealEx
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotVat'
        Value = Null
        Component = cbNotVat
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNotTareReturning'
        Value = Null
        Component = cbisNotTareReturning
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMarketNot'
        Value = Null
        Component = cbMarketNot
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListPromoId'
        Value = Null
        Component = GuidesPriceListPromo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartPromo'
        Value = Null
        Component = edStartPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InEndPromo'
        Value = Null
        Component = edEndPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 496
    Top = 620
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Contract'
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberArchive'
        Value = ''
        Component = edInvNumberArchive
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SigningDate'
        Value = 0d
        Component = edSigningDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate'
        Value = 0d
        Component = edStartDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 0d
        Component = edEndDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractKindId'
        Value = ''
        Component = GuidesContractKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractKindName'
        Value = ''
        Component = GuidesContractKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalTradeId'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalTradeName'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalCollationId'
        Value = ''
        Component = GuidesPersonalCollation
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalCollationName'
        Value = ''
        Component = GuidesPersonalCollation
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalSigningId'
        Value = Null
        Component = GuidesPersonalSigning
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalSigningName'
        Value = Null
        Component = GuidesPersonalSigning
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountId'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountName'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagId'
        Value = ''
        Component = ContractTagGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagName'
        Value = ''
        Component = ContractTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AreaContractId'
        Value = ''
        Component = GuidesAreaContract
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AreaContractName'
        Value = ''
        Component = GuidesAreaContract
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractArticleId'
        Value = ''
        Component = GuidesContractArticle
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractArticleName'
        Value = ''
        Component = GuidesContractArticle
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractStateKindId'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractStateKindName'
        Value = ''
        Component = ContractStateKindGuides
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
        Name = 'BankAccountExternal'
        Value = ''
        Component = edBankAccountExternal
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountPartner'
        Value = Null
        Component = edBankAccountPartner
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GLNCode'
        Value = ''
        Component = edGLNCode
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerCode'
        Value = Null
        Component = edPartnerCode
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisId'
        Value = ''
        Component = GuidesMainJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisName'
        Value = ''
        Component = GuidesMainJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalDocumentId'
        Value = Null
        Component = GuidesJuridicalDocument
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalDocumentName'
        Value = Null
        Component = GuidesJuridicalDocument
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankId'
        Value = ''
        Component = GuidesBank
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankName'
        Value = ''
        Component = GuidesBank
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDefault'
        Value = False
        Component = cbisDefault
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDefaultOut'
        Value = Null
        Component = cbisDefaultOut
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isStandart'
        Value = False
        Component = ceisStandart
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPersonal'
        Value = False
        Component = ceisPersonal
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isUnique'
        Value = False
        Component = ceIsUnique
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListPromoId'
        Value = Null
        Component = GuidesPriceListPromo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListPromoName'
        Value = Null
        Component = GuidesPriceListPromo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartPromo'
        Value = Null
        Component = edStartPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndPromo'
        Value = Null
        Component = edEndPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPropertyId'
        Value = Null
        Component = GuidesGoodsProperty
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPropertyName'
        Value = Null
        Component = GuidesGoodsProperty
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Term'
        Value = Null
        Component = edTerm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTermKindId'
        Value = Null
        Component = GuidesContractTermKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTermKindName'
        Value = Null
        Component = GuidesContractTermKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = Null
        Component = GuidesCurrency
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = Null
        Component = GuidesCurrency
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DayTaxSummary'
        Value = Null
        Component = edDayTaxSummary
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalInvoiceId'
        Value = Null
        Component = GuidesJuridicalInvoice
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalInvoiceName'
        Value = Null
        Component = GuidesJuridicalInvoice
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchId'
        Value = Null
        Component = GuidesBranch
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchName'
        Value = Null
        Component = GuidesBranch
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRealEx'
        Value = Null
        Component = cbisRealEx
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNotVat'
        Value = Null
        Component = cbNotVat
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNotTareReturning'
        Value = Null
        Component = cbisNotTareReturning
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMarketNot'
        Value = Null
        Component = cbMarketNot
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 432
    Top = 619
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 141
    Top = 178
  end
  object GuidesInfoMoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 342
    Top = 235
  end
  object GuidesContractKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractKind
    FormNameParam.Value = 'TContractKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContractKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContractKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = 0
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 306
  end
  object GuidesPersonal: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 400
  end
  object GuidesAreaContract: TdsdGuides
    KeyField = 'Id'
    LookupControl = edAreaContract
    FormNameParam.Value = 'TAreaContractForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAreaContractForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesAreaContract
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesAreaContract
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 245
    Top = 398
  end
  object GuidesContractArticle: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractArticle
    FormNameParam.Value = 'TContractArticleForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractArticleForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContractArticle
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContractArticle
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 353
  end
  object ContractStateKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractStateKind
    FormNameParam.Value = 'TContractStateKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractStateKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 868
    Top = 347
  end
  object GuidesPaidKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 64
    Top = 200
  end
  object ContractConditionDS: TDataSource
    DataSet = ContractConditionCDS
    Left = 430
    Top = 149
  end
  object ContractConditionCDS: TClientDataSet
    Aggregates = <>
    PacketRecords = 0
    Params = <>
    Left = 489
    Top = 151
  end
  object spInsertUpdateContractCondition: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ContractCondition'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ContractConditionCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ContractConditionCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue'
        Value = Null
        Component = ContractConditionCDS
        ComponentItem = 'Value'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercentRetBonus'
        Value = Null
        Component = ContractConditionCDS
        ComponentItem = 'PercentRetBonus'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractConditionKindId'
        Value = Null
        Component = ContractConditionCDS
        ComponentItem = 'ContractConditionKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBonusKindId'
        Value = Null
        Component = ContractConditionCDS
        ComponentItem = 'BonusKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = Null
        Component = ContractConditionCDS
        ComponentItem = 'InfoMoneyId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractSendId'
        Value = Null
        Component = ContractConditionCDS
        ComponentItem = 'ContractSendId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = Null
        Component = ContractConditionCDS
        ComponentItem = 'PaidKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = Null
        Component = ContractConditionCDS
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 760
    Top = 88
  end
  object spSelectContractCondition: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ContractConditionByContract'
    DataSet = ContractConditionCDS
    DataSets = <
      item
        DataSet = ContractConditionCDS
      end>
    Params = <
      item
        Name = 'incontractid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowErasedCC
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 410
    Top = 103
  end
  object BarManager: TdxBarManager
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
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 376
    Top = 435
    DockControlHeights = (
      0
      0
      0
      0)
    object BarManagerBar1: TdxBar
      Caption = #1059#1089#1083#1086#1074#1080#1103' '#1088#1072#1073#1086#1090#1099
      CaptionButtons = <>
      DockControl = dxBarDockControl1
      DockedDockControl = dxBarDockControl1
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 811
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertCondition'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedContractCondition'
        end
        item
          Visible = True
          ItemName = 'bbSetUnerasedCondition'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErasedCC'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbConditionRefresh'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bb'
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
    object BarManagerBar2: TdxBar
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      CaptionButtons = <>
      DockControl = dxBarDockControl2
      DockedDockControl = dxBarDockControl2
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 811
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbAddDocument'
        end
        item
          Visible = True
          ItemName = 'bbDeleteDocument'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenDocument'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefreshDoc'
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
    object bbAddDocument: TdxBarButton
      Action = MultiActionInsertDocument
      Category = 0
    end
    object bbRefreshDoc: TdxBarButton
      Action = DocumentRefresh
      Category = 0
    end
    object bbStatic: TdxBarStatic
      Caption = '   '
      Category = 0
      Enabled = False
      Hint = '   '
      Visible = ivAlways
    end
    object bbOpenDocument: TdxBarButton
      Action = DocumentOpenAction
      Category = 0
    end
    object bbInsertCondition: TdxBarButton
      Action = MultiActionInsertContractCondition
      Category = 0
    end
    object bbConditionRefresh: TdxBarButton
      Action = actConditionRefresh
      Category = 0
    end
    object bbSetErasedContractCondition: TdxBarButton
      Action = actSetErasedContractCondition
      Category = 0
    end
    object bbSetUnerasedCondition: TdxBarButton
      Action = actSetUnErasedContractCondition
      Category = 0
    end
    object bbDeleteDocument: TdxBarButton
      Action = actDeleteDocument
      Category = 0
    end
    object bbShowErasedCC: TdxBarButton
      Action = actShowErasedCC
      Category = 0
    end
    object bb: TdxBarButton
      Action = ProtocolOpenFormCondition
      Category = 0
    end
  end
  object spDocumentSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ContractDocument'
    DataSet = DocumentCDS
    DataSets = <
      item
        DataSet = DocumentCDS
      end>
    Params = <
      item
        Name = 'incontractid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 528
    Top = 352
  end
  object DocumentDS: TDataSource
    DataSet = DocumentCDS
    Left = 640
    Top = 344
  end
  object DocumentCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 864
    Top = 288
  end
  object Document: TDocument
    GetBlobProcedure = spGetDocument
    Left = 520
    Top = 240
  end
  object spInsertDocument: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ContractDocument'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioid'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'indocumentname'
        Value = ''
        Component = Document
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'incontractid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'incontractdocumentdata'
        Value = '789C535018D10000F1E01FE1'
        Component = Document
        ComponentItem = 'Data'
        DataType = ftBlob
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 672
    Top = 536
  end
  object spGetDocument: TdsdStoredProc
    StoredProcName = 'gpGet_Object_ContractDocument'
    DataSets = <>
    OutputType = otBlob
    Params = <
      item
        Name = 'incontractdocumentid'
        Value = Null
        Component = DocumentCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 640
    Top = 224
  end
  object GuidesMainJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMainJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMainJuridical
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMainJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 24
    Top = 597
  end
  object spErasedUnErasedCondition: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ContractCondition'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ContractConditionCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 80
  end
  object DBViewAddOnCondition: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewContractCondition
    OnDblClickActionList = <>
    ActionItemList = <
      item
        Action = actSetErasedContractCondition
        ShortCut = 46
        SecondaryShortCuts.Strings = (
          'Del')
      end
      item
        Action = actSetUnErasedContractCondition
        ShortCut = 46
        SecondaryShortCuts.Strings = (
          'Del')
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
    Left = 616
    Top = 72
  end
  object spDeleteDocument: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_ContractDocument'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = DocumentCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 728
    Top = 248
  end
  object spGetStateKindUnSigned: TdsdStoredProc
    StoredProcName = 'gpGetUpdate_Object_StateKind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inContractStateKindCode'
        Value = 2
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 768
    Top = 362
  end
  object spGetStateKindSigned: TdsdStoredProc
    StoredProcName = 'gpGetUpdate_Object_StateKind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inContractStateKindCode'
        Value = 1
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 768
    Top = 410
  end
  object spGetStateKindClose: TdsdStoredProc
    StoredProcName = 'gpGetUpdate_Object_StateKind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inContractStateKindCode'
        Value = 3
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 768
    Top = 458
  end
  object spGetStateKind_Partner: TdsdStoredProc
    StoredProcName = 'gpGetUpdate_Object_StateKind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inContractStateKindCode'
        Value = 4
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractStateKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 768
    Top = 306
  end
  object GuidesBank: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBankId
    FormNameParam.Value = 'TBankForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBank
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBank
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 523
  end
  object GuidesPersonalTrade: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalTrade
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 348
    Top = 368
  end
  object GuidesPersonalCollation: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalCollation
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalCollation
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalCollation
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 444
  end
  object GuidesBankAccount: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBankAccount
    FormNameParam.Value = 'TBankAccountForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankAccountForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 67
    Top = 481
  end
  object ContractTagGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractTag
    FormNameParam.Value = 'TContractTagForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractTagForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractTagGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 376
    Top = 47
  end
  object GuidesJuridicalDocument: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridicalDocument
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridicalDocument
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridicalDocument
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 365
    Top = 306
  end
  object GuidesPriceList: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePriceList
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPriceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPriceList
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPriceList
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 249
    Top = 603
  end
  object GuidesPriceListPromo: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePriceListPromo
    FormNameParam.Value = 'TPriceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPriceListPromo
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPriceListPromo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 336
    Top = 642
  end
  object GuidesGoodsProperty: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsProperty
    FormNameParam.Value = 'TGoodsPropertyForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsPropertyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsProperty
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsProperty
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 641
  end
  object GuidesContractTermKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractTermKind
    FormNameParam.Value = 'TContractTermKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractTermKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContractTermKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContractTermKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 152
  end
  object GuidesPersonalSigning: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalSigning
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalSigning
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalSigning
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 556
  end
  object GuidesCurrency: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceCurrency
    FormNameParam.Value = 'TCurrencyForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCurrencyForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCurrency
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCurrency
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 152
  end
  object GuidesJuridicalInvoice: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridicalInvoice
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridicalInvoice
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridicalInvoice
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 349
    Top = 170
  end
  object GuidesBranch: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 464
    Top = 275
  end
end
