object PromoContractBonus_DetailForm: TPromoContractBonus_DetailForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1044#1086#1075#1086#1074#1086#1088#1072' ('#1044#1077#1090#1072#1083#1100#1085#1086' '#1041#1086#1085#1091#1089' '#1089#1077#1090#1080')>'
  ClientHeight = 620
  ClientWidth = 1216
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1216
    Height = 30
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object cxLabel5: TcxLabel
      Left = 30
      Top = 6
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1072#1082#1094#1080#1080':'
    end
    object edPromo: TcxButtonEdit
      Left = 127
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 330
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 56
    Width = 1216
    Height = 137
    Align = alTop
    TabOrder = 0
    LookAndFeel.NativeStyle = False
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
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
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object ContractStateKindName: TcxGridDBColumn
        Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1075'.'
        DataBinding.FieldName = 'ContractStateKindCode'
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
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 67
      end
      object clCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 40
      end
      object InvNumberArchive: TcxGridDBColumn
        Caption = #1055#1086#1088#1103#1076#1082'. '#8470
        DataBinding.FieldName = 'InvNumberArchive'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 43
      end
      object InvNumber: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1075'.'
        DataBinding.FieldName = 'InvNumber'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 69
      end
      object ContractTagGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1087#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
        DataBinding.FieldName = 'ContractTagGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object ContractTagName: TcxGridDBColumn
        Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
        DataBinding.FieldName = 'ContractTagName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Caption = 'ContractTagChoiceForm'
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 79
      end
      object RetailName: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
        DataBinding.FieldName = 'RetailName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 127
      end
      object JuridicalGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1102#1088'. '#1083'.'
        DataBinding.FieldName = 'JuridicalGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object JuridicalCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1102#1088'.'#1083'.'
        DataBinding.FieldName = 'JuridicalCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object JuridicalName: TcxGridDBColumn
        Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Caption = 'JuridicalChoiceForm'
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 132
      end
      object OKPO: TcxGridDBColumn
        Caption = #1054#1050#1055#1054
        DataBinding.FieldName = 'OKPO'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        VisibleForCustomization = False
        Width = 60
      end
      object PaidKindName: TcxGridDBColumn
        Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
        DataBinding.FieldName = 'PaidKindName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Caption = 'PaidKindChoiceForm'
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object StartDate: TcxGridDBColumn
        Caption = #1044#1077#1081#1089#1090#1074'. '#1089
        DataBinding.FieldName = 'StartDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object EndDate: TcxGridDBColumn
        Caption = #1044#1077#1081#1089#1090#1074'. '#1076#1086
        DataBinding.FieldName = 'EndDate'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object ContractKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1076#1086#1075'.'
        DataBinding.FieldName = 'ContractKindName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Caption = 'ContractKindChoiceForm'
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 86
      end
      object InfoMoneyCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055
        DataBinding.FieldName = 'InfoMoneyCode'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Caption = 'InfoMoneyChoiceForm'
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 39
      end
      object InfoMoneyName: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Caption = 'InfoMoneyChoiceForm'
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 138
      end
      object JuridicalBasisName: TcxGridDBColumn
        Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalBasisName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object GoodsPropertyName: TcxGridDBColumn
        Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsPropertyName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Caption = 'GoodsPropertyForm'
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 135
      end
      object IsErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
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
  object cxGridContractCondition: TcxGrid
    Left = 0
    Top = 198
    Width = 1216
    Height = 189
    Align = alClient
    TabOrder = 1
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    object cxGridDBTableViewContractCondition: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ContractConditionDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.##'
          Kind = skSum
          Column = Value
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.##'
          Kind = skSum
          Column = Value
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object BonusKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1073#1086#1085#1091#1089#1072
        DataBinding.FieldName = 'BonusKindName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Caption = 'BonusKindChoiceForm'
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentVert = vaCenter
        Width = 127
      end
      object ContractConditionKindName: TcxGridDBColumn
        Caption = #1059#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
        DataBinding.FieldName = 'ContractConditionKindName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Caption = 'ContractConditionKindChoiceForm'
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentVert = vaCenter
        Width = 120
      end
      object Value: TcxGridDBColumn
        Caption = #1047#1085#1072#1095#1077#1085#1080#1077
        DataBinding.FieldName = 'Value'
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object clPercentRetBonus: TcxGridDBColumn
        Caption = '% '#1074#1086#1079#1074'. '#1087#1083#1072#1085
        DataBinding.FieldName = 'PercentRetBonus'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = '% '#1074#1086#1079#1074#1088#1072#1090#1072' '#1087#1083#1072#1085
        Width = 62
      end
      object colStartDate: TcxGridDBColumn
        Caption = #1044#1077#1081#1089#1090#1091#1077#1090' c...'
        DataBinding.FieldName = 'StartDate'
        FooterAlignmentHorz = taCenter
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object colEndDate: TcxGridDBColumn
        Caption = #1044#1077#1081#1089#1090#1091#1077#1090' '#1087#1086'...'
        DataBinding.FieldName = 'EndDate'
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
      object ccPaidKindName: TcxGridDBColumn
        Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
        DataBinding.FieldName = 'PaidKindName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Caption = 'PaidKindChoiceForm'
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object clccInfoMoneyName: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Caption = 'InfoMoneyChoiceForm'
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072' '#1073#1086#1085#1091#1089#1085#1086#1075#1086' '#1076#1086#1075#1086#1074#1086#1088#1072
        Width = 141
      end
      object ContractSendName: TcxGridDBColumn
        Caption = #8470' '#1076#1086#1075'. '#1084#1072#1088#1082#1077#1090'./'#1073#1072#1079#1072
        DataBinding.FieldName = 'ContractSendName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Caption = 'TContractChoiceForm'
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentVert = vaCenter
        HeaderHint = 
          #8470' '#1076#1086#1075#1086#1074#1086#1088#1072' '#1087#1077#1088#1077#1074#1099#1089#1090#1072#1074#1083#1077#1085#1080#1077' '#1084#1072#1088#1082#1077#1090#1080#1085#1075' '#1080#1083#1080' '#1087#1086#1080#1089#1082' '#1073#1072#1079#1099' '#1076#1083#1103' '#1084#1072#1088#1082#1077#1090'. ' +
          #1076#1086#1075#1086#1074#1086#1088#1072
        Width = 88
      end
      object ContractStateKindCode_Send: TcxGridDBColumn
        Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1075'. '#1084#1072#1088#1082#1077#1090'./'#1073#1072#1079#1072
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
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 102
      end
      object ContractTagName_Send: TcxGridDBColumn
        Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'. '#1084#1072#1088#1082#1077#1090'./'#1073#1072#1079#1072
        DataBinding.FieldName = 'ContractTagName_Send'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
      object InfoMoneyCode_Send: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055
        DataBinding.FieldName = 'InfoMoneyCode_Send'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1084#1072#1088#1082#1077#1090'./'#1073#1072#1079#1072
        Options.Editing = False
        Width = 120
      end
      object InfoMoneyName_Send: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyName_Send'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1084#1072#1088#1082#1077#1090'./'#1073#1072#1079#1072
        Options.Editing = False
        Width = 120
      end
      object JuridicalCode_Send: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1102#1088'.'#1083'.'
        DataBinding.FieldName = 'JuridicalCode_Send'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1084#1072#1088#1082#1077#1090'./'#1073#1072#1079#1072
        Options.Editing = False
        Width = 45
      end
      object JuridicalName_Send: TcxGridDBColumn
        Caption = #1070#1088'. '#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalName_Send'
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1084#1072#1088#1082#1077#1090'./'#1073#1072#1079#1072
        Options.Editing = False
        Width = 120
      end
      object colInsertName: TcxGridDBColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
        DataBinding.FieldName = 'InsertName'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
      object colUpdateName: TcxGridDBColumn
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
        DataBinding.FieldName = 'UpdateName'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
      object colInsertDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
        DataBinding.FieldName = 'InsertDate'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 75
      end
      object colUpdateDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
        DataBinding.FieldName = 'UpdateDate'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 75
      end
      object colComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentVert = vaCenter
        Width = 300
      end
      object clsfcisErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        Visible = False
        Width = 60
      end
    end
    object cxGridLevel2: TcxGridLevel
      GridView = cxGridDBTableViewContractCondition
    end
  end
  object Panel: TPanel
    Left = 0
    Top = 392
    Width = 1216
    Height = 228
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object cxGridContract_Child: TcxGrid
      Left = 0
      Top = 0
      Width = 571
      Height = 228
      Align = alClient
      TabOrder = 0
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = False
      LookAndFeel.SkinName = ''
      object cxGridDBTableViewContract_Child: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = Contract_ChildDS
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
        OptionsView.GroupByBox = False
        OptionsView.HeaderHeight = 40
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object ContractStateKindName_ch3: TcxGridDBColumn
          Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1075'.'
          DataBinding.FieldName = 'ContractStateKindCode'
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
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 67
        end
        object clCode_ch3: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'Code'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 40
        end
        object InvNumber_ch3: TcxGridDBColumn
          Caption = #8470' '#1076#1086#1075'.'
          DataBinding.FieldName = 'InvNumber'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 69
        end
        object ContractTagGroupName_ch3: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072' '#1087#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
          DataBinding.FieldName = 'ContractTagGroupName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object ContractTagName_ch3: TcxGridDBColumn
          Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
          DataBinding.FieldName = 'ContractTagName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Caption = 'ContractTagChoiceForm'
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 79
        end
        object RetailName_ch3: TcxGridDBColumn
          Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
          DataBinding.FieldName = 'RetailName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object JuridicalGroupName_ch3: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072' '#1102#1088'. '#1083'.'
          DataBinding.FieldName = 'JuridicalGroupName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object JuridicalCode_ch3: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1102#1088'.'#1083'.'
          DataBinding.FieldName = 'JuridicalCode'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 45
        end
        object JuridicalName_ch3: TcxGridDBColumn
          Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
          DataBinding.FieldName = 'JuridicalName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Caption = 'JuridicalChoiceForm'
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 132
        end
        object PaidKindName_ch3: TcxGridDBColumn
          Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
          DataBinding.FieldName = 'PaidKindName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Caption = 'PaidKindChoiceForm'
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 50
        end
        object StartDate_ch3: TcxGridDBColumn
          Caption = #1044#1077#1081#1089#1090#1074'. '#1089
          DataBinding.FieldName = 'StartDate'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
        object EndDate_ch3: TcxGridDBColumn
          Caption = #1044#1077#1081#1089#1090#1074'. '#1076#1086
          DataBinding.FieldName = 'EndDate'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
        object ContractKindName_ch3: TcxGridDBColumn
          Caption = #1042#1080#1076' '#1076#1086#1075'.'
          DataBinding.FieldName = 'ContractKindName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Caption = 'ContractKindChoiceForm'
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 86
        end
        object InfoMoneyCode_ch3: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1059#1055
          DataBinding.FieldName = 'InfoMoneyCode'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Caption = 'InfoMoneyChoiceForm'
              Default = True
              Kind = bkEllipsis
            end>
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 39
        end
        object InfoMoneyName_ch3: TcxGridDBColumn
          Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
          DataBinding.FieldName = 'InfoMoneyName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Caption = 'InfoMoneyChoiceForm'
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object JuridicalBasisName_ch3: TcxGridDBColumn
          Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
          DataBinding.FieldName = 'JuridicalBasisName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object GoodsPropertyName_ch3: TcxGridDBColumn
          Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1072
          DataBinding.FieldName = 'GoodsPropertyName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Caption = 'GoodsPropertyForm'
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 60
        end
        object clPisErased: TcxGridDBColumn
          Caption = #1059#1076#1072#1083#1077#1085
          DataBinding.FieldName = 'isErased'
          Visible = False
          Options.Editing = False
          Width = 20
        end
      end
      object cxGridLeveContract_Child: TcxGridLevel
        GridView = cxGridDBTableViewContract_Child
      end
    end
    object cxGridGoods: TcxGrid
      Left = 576
      Top = 0
      Width = 640
      Height = 228
      Align = alRight
      TabOrder = 1
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = False
      LookAndFeel.SkinName = ''
      object cxGridDBTableViewGoods: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = DataSourceGoods
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
        OptionsView.GroupByBox = False
        OptionsView.HeaderHeight = 40
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object GoodsGroupNameFull_ch4: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
          DataBinding.FieldName = 'GoodsGroupNameFull'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 150
        end
        object GoodsGroupName_ch4: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072
          DataBinding.FieldName = 'GoodsGroupName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 172
        end
        object Code_ch4: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1089#1074#1103#1079#1080
          DataBinding.FieldName = 'Code'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 57
        end
        object GoodsCode_ch4: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'GoodsCode'
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
        object GoodsName_ch4: TcxGridDBColumn
          Caption = #1058#1086#1074#1072#1088
          DataBinding.FieldName = 'GoodsName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Caption = 'GoodsChoiceForm'
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 166
        end
        object BarCode_ch4: TcxGridDBColumn
          Caption = #1064#1090#1088#1080#1093' '#1082#1086#1076
          DataBinding.FieldName = 'BarCode'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object Price_ch4: TcxGridDBColumn
          Caption = #1062#1077#1085#1072
          DataBinding.FieldName = 'Price'
          HeaderAlignmentVert = vaCenter
          Width = 43
        end
        object Article_ch4: TcxGridDBColumn
          Caption = #1040#1088#1090#1080#1082#1091#1083
          DataBinding.FieldName = 'Article'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object Persent_ch4: TcxGridDBColumn
          Caption = '% '#1080#1079#1084'. '#1094#1077#1085#1099
          DataBinding.FieldName = 'Persent'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.##;-,0.##; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = '% '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1086#1090#1085#1086#1089#1080#1090#1077#1083#1100#1085#1086' '#1087#1088#1077#1076#1099#1076#1091#1097#1077#1081' '#1094#1077#1085#1099
          Options.Editing = False
          Width = 47
        end
        object StartDate_ch4: TcxGridDBColumn
          Caption = #1044#1077#1081#1089#1090#1074'. '#1089
          DataBinding.FieldName = 'StartDate'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
        object MeasureName_ch4: TcxGridDBColumn
          Caption = #1045#1076'. '#1080#1079#1084'.'
          DataBinding.FieldName = 'MeasureName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object GoodsKindName_ch4: TcxGridDBColumn
          Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
          DataBinding.FieldName = 'GoodsKindName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 54
        end
        object TradeMarkName_ch4: TcxGridDBColumn
          Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
          DataBinding.FieldName = 'TradeMarkName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object PriceListName_ch4: TcxGridDBColumn
          Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          DataBinding.FieldName = 'PriceListName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
        object PriceListGoodsName_ch4: TcxGridDBColumn
          Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' ('#1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103')'
          DataBinding.FieldName = 'PriceListGoodsName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 109
        end
        object GoodsPropertyName_ch4: TcxGridDBColumn
          Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1072
          DataBinding.FieldName = 'GoodsPropertyName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 102
        end
        object isErased_ch4: TcxGridDBColumn
          Caption = #1059#1076#1072#1083#1077#1085
          DataBinding.FieldName = 'isErased'
          Visible = False
          Options.Editing = False
          Width = 20
        end
      end
      object cxGridLevelGoods: TcxGridLevel
        GridView = cxGridDBTableViewGoods
      end
    end
    object cxSplitter1: TcxSplitter
      Left = 571
      Top = 0
      Width = 5
      Height = 228
      AlignSplitter = salRight
      Control = cxGridGoods
    end
  end
  object cxSplitter3: TcxSplitter
    Left = 0
    Top = 193
    Width = 1216
    Height = 5
    AlignSplitter = salTop
    Control = cxGrid
  end
  object cxSplitter4: TcxSplitter
    Left = 0
    Top = 387
    Width = 1216
    Height = 5
    AlignSplitter = salBottom
    Control = Panel
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 40
    Top = 160
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    MasterFields = 'Id'
    Params = <>
    Left = 32
    Top = 224
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
    Left = 344
    Top = 120
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
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
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
    object bbGridToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object dxBarStatic1: TdxBarStatic
      Caption = '    '
      Category = 0
      Hint = '    '
      Visible = ivAlways
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 248
    Top = 136
    object actRefreshContract: TdsdDataSetRefresh
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
      RefreshOnTabSetChanges = False
    end
    object actRefresh: TdsdDataSetRefresh
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
      RefreshOnTabSetChanges = False
    end
    object macUpdateStateKind_Closed: TMultiAction
      Category = 'Close'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateStateKind_Closed_list
        end
        item
          Action = actRefreshContract
        end>
      QuestionBeforeExecute = #1047#1072#1082#1088#1099#1090#1100' '#1042#1057#1045' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1076#1086#1075#1086#1074#1086#1088#1072'?'
      InfoAfterExecute = #1047#1072#1082#1088#1099#1090#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1086#1074' '#1074#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
      Hint = #1047#1072#1082#1088#1099#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
      ImageIndex = 13
    end
    object InsertRecordCCPartner: TInsertRecord
      Category = 'CCPartner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072' ('#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072')>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072' ('#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072')>'
      ImageIndex = 0
    end
    object ProtocolOpenFormCCPartner: TdsdOpenForm
      Category = 'CCPartner'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083' <'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072' ('#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072')>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083' <'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072' ('#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072')>'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = Contract_ChildCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = Contract_ChildCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object dsdSetErasedCCPartner: TdsdUpdateErased
      Category = 'CCPartner'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072' ('#1091#1089#1083'. '#1076#1086#1075'.)'
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072' ('#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072')'
      ImageIndex = 2
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      DataSource = Contract_ChildDS
    end
    object dsdSetUnErasedССPartner: TdsdUpdateErased
      Category = 'CCPartner'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = Contract_ChildDS
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
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actUpdateStateKind_Closed: TdsdExecStoredProc
      Category = 'Close'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
      Hint = #1047#1072#1082#1088#1099#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
      ImageIndex = 13
    end
    object macUpdateStateKind_Closed_list: TMultiAction
      Category = 'Close'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateStateKind_Closed
        end>
      View = cxGridDBTableView
      Caption = 'macUpdateStateKind_Closed_list'
      ImageIndex = 13
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_PromoContract_BonusDetail'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end
      item
        DataSet = CDSContractCondition
      end
      item
        DataSet = Contract_ChildCDS
      end
      item
        DataSet = CDSContractGoods
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = False
        Component = GuidesPromo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 224
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 88
    Top = 256
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_Contract'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 160
    Top = 160
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
      end
      item
        Action = dsdChoiceGuides
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
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 800
    Top = 224
  end
  object ContractConditionDS: TDataSource
    DataSet = CDSContractCondition
    Left = 62
    Top = 397
  end
  object CDSContractCondition: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ContractId'
    MasterFields = 'ContractId'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 177
    Top = 389
  end
  object ChildViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewContractCondition
    OnDblClickActionList = <
      item
      end
      item
        Action = dsdChoiceGuides
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
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 408
    Top = 256
  end
  object PeriodChoice: TPeriodChoice
    Left = 480
    Top = 120
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end>
    Left = 536
    Top = 160
  end
  object dsdDBViewAddOnContract_Child: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewContract_Child
    OnDblClickActionList = <
      item
      end
      item
        Action = dsdChoiceGuides
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
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 376
    Top = 464
  end
  object CDSContractGoods: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ContractId'
    MasterFields = 'ContractId'
    MasterSource = Contract_ChildDS
    PacketRecords = 0
    Params = <>
    Left = 989
    Top = 373
  end
  object DataSourceGoods: TDataSource
    DataSet = CDSContractGoods
    Left = 1070
    Top = 357
  end
  object dsdDBViewAddOnGoods: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewGoods
    OnDblClickActionList = <
      item
      end
      item
        Action = dsdChoiceGuides
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
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 1120
    Top = 432
  end
  object spErasedUnErasedGoods: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ContractGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = CDSContractGoods
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1024
    Top = 456
  end
  object spUpdateVat: TdsdStoredProc
    StoredProcName = 'gpUpdateObject_Contract_isVat'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId '
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisVat'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isVat'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 235
  end
  object Contract_ChildDS: TDataSource
    DataSet = Contract_ChildCDS
    Left = 478
    Top = 493
  end
  object Contract_ChildCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 485
    Top = 437
  end
  object GuidesPromo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPromo
    DisableGuidesOpen = True
    Key = '0'
    FormNameParam.Value = 'TPromoJournalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPromoJournalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesPromo
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPromo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 302
    Top = 2
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MovementId'
        Value = Null
        Component = GuidesPromo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberFull'
        Value = Null
        Component = GuidesPromo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 768
    Top = 144
  end
end
