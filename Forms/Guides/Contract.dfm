object ContractForm: TContractForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1044#1086#1075#1086#1074#1086#1088#1072'>'
  ClientHeight = 602
  ClientWidth = 1274
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
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 26
    Width = 1274
    Height = 30
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object deStart: TcxDateEdit
      Left = 238
      Top = 4
      EditValue = 42370d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxlEnd: TcxLabel
      Left = 329
      Top = 4
      AutoSize = False
      Caption = #1087#1086
      Properties.Alignment.Vert = taVCenter
      Height = 21
      Width = 21
      AnchorY = 15
    end
    object deEnd: TcxDateEdit
      Left = 351
      Top = 4
      EditValue = 42370d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 2
      Width = 85
    end
    object cbPeriod: TcxCheckBox
      Left = 18
      Top = 4
      Action = actRefresh
      Caption = '<'#1044#1086#1075#1086#1074#1086#1088' '#1076#1077#1081#1089#1090#1074#1091#1077#1090' '#1076#1086'> '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089
      TabOrder = 4
      Width = 218
    end
    object cbEndDate: TcxCheckBox
      Left = 442
      Top = 4
      Action = actRefresh
      Caption = '<'#1044#1086#1075#1086#1074#1086#1088' '#1076#1077#1081#1089#1090#1074#1091#1077#1090' '#1076#1086'> '#1087#1086' '#1076#1072#1090#1091' '#1074#1082#1083#1102#1095#1080#1090#1077#1083#1100#1085#1086
      TabOrder = 3
      Width = 278
    end
    object cePersonal_update: TcxButtonEdit
      Left = 735
      Top = 4
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Text = #1057#1086#1090#1088#1091#1076#1085#1080#1082
      Width = 290
    end
  end
  object cxGridContractCondition: TcxGrid
    Left = 0
    Top = 366
    Width = 476
    Height = 236
    Align = alLeft
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
            Action = BonusKindChoiceForm
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
            Action = ContractConditionKindChoiceForm
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
            Action = PaidKindChoiceFormСС
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
            Action = InfoMoneyChoiceForm_ContractCondition
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
            Action = ContractSendChoiceForm
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
        HeaderHint = 
          #1076#1086#1075#1086#1074#1086#1088' '#1087#1077#1088#1077#1074#1099#1089#1090#1072#1074#1083#1077#1085#1080#1077' '#1084#1072#1088#1082#1077#1090#1080#1085#1075' '#1080#1083#1080' '#1087#1086#1080#1089#1082' '#1073#1072#1079#1099' '#1076#1083#1103' '#1084#1072#1088#1082#1077#1090'. '#1076#1086#1075 +
          #1086#1074#1086#1088#1072
        Options.Editing = False
        Width = 67
      end
      object ContractTagName_Send: TcxGridDBColumn
        Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'. '#1084#1072#1088#1082#1077#1090'./'#1073#1072#1079#1072
        DataBinding.FieldName = 'ContractTagName_Send'
        HeaderAlignmentVert = vaCenter
        HeaderHint = 
          #1076#1086#1075#1086#1074#1086#1088' '#1087#1077#1088#1077#1074#1099#1089#1090#1072#1074#1083#1077#1085#1080#1077' '#1084#1072#1088#1082#1077#1090#1080#1085#1075' '#1080#1083#1080' '#1087#1086#1080#1089#1082' '#1073#1072#1079#1099' '#1076#1083#1103' '#1084#1072#1088#1082#1077#1090'. '#1076#1086#1075 +
          #1086#1074#1086#1088#1072
        Options.Editing = False
        Width = 120
      end
      object InfoMoneyCode_Send: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055' ('#1084#1072#1088#1082#1077#1090'/'#1073#1072#1079#1072')'
        DataBinding.FieldName = 'InfoMoneyCode_Send'
        HeaderAlignmentVert = vaCenter
        HeaderHint = 
          #1076#1086#1075#1086#1074#1086#1088' '#1087#1077#1088#1077#1074#1099#1089#1090#1072#1074#1083#1077#1085#1080#1077' '#1084#1072#1088#1082#1077#1090#1080#1085#1075' '#1080#1083#1080' '#1087#1086#1080#1089#1082' '#1073#1072#1079#1099' '#1076#1083#1103' '#1084#1072#1088#1082#1077#1090'. '#1076#1086#1075 +
          #1086#1074#1086#1088#1072
        Options.Editing = False
        Width = 120
      end
      object InfoMoneyName_Send: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103' ('#1084#1072#1088#1082#1077#1090'/'#1073#1072#1079#1072')'
        DataBinding.FieldName = 'InfoMoneyName_Send'
        HeaderAlignmentVert = vaCenter
        HeaderHint = 
          #1076#1086#1075#1086#1074#1086#1088' '#1087#1077#1088#1077#1074#1099#1089#1090#1072#1074#1083#1077#1085#1080#1077' '#1084#1072#1088#1082#1077#1090#1080#1085#1075' '#1080#1083#1080' '#1087#1086#1080#1089#1082' '#1073#1072#1079#1099' '#1076#1083#1103' '#1084#1072#1088#1082#1077#1090'. '#1076#1086#1075 +
          #1086#1074#1086#1088#1072
        Options.Editing = False
        Width = 120
      end
      object JuridicalCode_Send: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1102#1088'.'#1083'.'
        DataBinding.FieldName = 'JuridicalCode_Send'
        HeaderAlignmentVert = vaCenter
        HeaderHint = 
          #1076#1086#1075#1086#1074#1086#1088' '#1087#1077#1088#1077#1074#1099#1089#1090#1072#1074#1083#1077#1085#1080#1077' '#1084#1072#1088#1082#1077#1090#1080#1085#1075' '#1080#1083#1080' '#1087#1086#1080#1089#1082' '#1073#1072#1079#1099' '#1076#1083#1103' '#1084#1072#1088#1082#1077#1090'. '#1076#1086#1075 +
          #1086#1074#1086#1088#1072
        Options.Editing = False
        Width = 45
      end
      object JuridicalName_Send: TcxGridDBColumn
        Caption = #1070#1088'. '#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalName_Send'
        HeaderAlignmentVert = vaCenter
        HeaderHint = 
          #1076#1086#1075#1086#1074#1086#1088' '#1087#1077#1088#1077#1074#1099#1089#1090#1072#1074#1083#1077#1085#1080#1077' '#1084#1072#1088#1082#1077#1090#1080#1085#1075' '#1080#1083#1080' '#1087#1086#1080#1089#1082' '#1073#1072#1079#1099' '#1076#1083#1103' '#1084#1072#1088#1082#1077#1090'. '#1076#1086#1075 +
          #1086#1074#1086#1088#1072
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
    Left = 782
    Top = 366
    Width = 492
    Height = 236
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 4
    object cxGridPartner: TcxGrid
      Left = 0
      Top = 0
      Width = 317
      Height = 236
      Align = alClient
      TabOrder = 0
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = False
      LookAndFeel.SkinName = ''
      object cxGridDBTableViewPartner: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = DataSourcePartner
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
        object colCode: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1089#1074#1103#1079#1080
          DataBinding.FieldName = 'Code'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 57
        end
        object isConnected: TcxGridDBColumn
          Caption = #1055#1086#1076#1082#1083'.'
          DataBinding.FieldName = 'isConnected'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object PartnerCode: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'PartnerCode'
          Visible = False
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 45
        end
        object PartnerName: TcxGridDBColumn
          Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1044#1086#1075#1086#1074#1086#1088')'
          DataBinding.FieldName = 'PartnerName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = PartnerChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1044#1086#1075#1086#1074#1086#1088')'
          Width = 258
        end
        object clPisErased: TcxGridDBColumn
          Caption = #1059#1076#1072#1083#1077#1085
          DataBinding.FieldName = 'isErased'
          Visible = False
          Options.Editing = False
          Width = 20
        end
      end
      object cxGridLevePartner: TcxGridLevel
        GridView = cxGridDBTableViewPartner
      end
    end
    object cxGridGoods: TcxGrid
      Left = 322
      Top = 0
      Width = 170
      Height = 236
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
        object Code: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1089#1074#1103#1079#1080
          DataBinding.FieldName = 'Code'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 57
        end
        object GoodsCode: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'GoodsCode'
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
        object GoodsName: TcxGridDBColumn
          Caption = #1058#1086#1074#1072#1088' ('#1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103')'
          DataBinding.FieldName = 'GoodsName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = GoodsChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 166
        end
        object GoodsKindName: TcxGridDBColumn
          Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
          DataBinding.FieldName = 'GoodsKindName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = GoodsKindChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentVert = vaCenter
          Width = 60
        end
        object Price: TcxGridDBColumn
          Caption = #1062#1077#1085#1072
          DataBinding.FieldName = 'Price'
          HeaderAlignmentVert = vaCenter
          Width = 43
        end
        object cgBarCode: TcxGridDBColumn
          Caption = #1064#1090#1088#1080#1093' '#1082#1086#1076
          DataBinding.FieldName = 'BarCode'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object cgArticle: TcxGridDBColumn
          Caption = #1040#1088#1090#1080#1082#1091#1083
          DataBinding.FieldName = 'Article'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object cgPersent: TcxGridDBColumn
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
        object cgStartDate: TcxGridDBColumn
          Caption = #1044#1077#1081#1089#1090#1074'. '#1089
          DataBinding.FieldName = 'StartDate'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
        object clGisErased: TcxGridDBColumn
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
      Left = 317
      Top = 0
      Width = 5
      Height = 236
      AlignSplitter = salRight
      Control = cxGridGoods
    end
  end
  object cxTopSplitter: TcxSplitter
    Left = 0
    Top = 361
    Width = 1274
    Height = 5
    AlignSplitter = salTop
    Control = Panel2
  end
  object cxRightSplitter: TcxSplitter
    Left = 778
    Top = 366
    Width = 4
    Height = 236
    AlignSplitter = salRight
    Control = Panel
  end
  object CCPartner: TcxGrid
    Left = 481
    Top = 366
    Width = 297
    Height = 236
    Align = alClient
    TabOrder = 6
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    object cxGridDBTableViewCCPartner: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = CCPartnerDS
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
      object ccpisConnected: TcxGridDBColumn
        Caption = #1055#1086#1076#1082#1083'.'
        DataBinding.FieldName = 'isConnected'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object ccpCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1089#1074#1103#1079#1080
        DataBinding.FieldName = 'Code'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 57
      end
      object ccpPartnerCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'PartnerCode'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object ccpPartnerName: TcxGridDBColumn
        Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1059#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072')'
        DataBinding.FieldName = 'PartnerName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = PartnerContractConditionChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1059#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072')'
        Width = 258
      end
      object ccpisErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        Visible = False
        Options.Editing = False
        Width = 20
      end
    end
    object cxGridLevelCCPartner: TcxGridLevel
      GridView = cxGridDBTableViewCCPartner
    end
  end
  object cxSplitter2: TcxSplitter
    Left = 476
    Top = 366
    Width = 5
    Height = 236
    Control = cxGridContractCondition
  end
  object Panel2: TPanel
    Left = 0
    Top = 56
    Width = 1274
    Height = 305
    Align = alTop
    Caption = 'Panel2'
    TabOrder = 11
    object Panel3: TPanel
      Left = 1002
      Top = 1
      Width = 271
      Height = 303
      Align = alRight
      Caption = 'Panel3'
      TabOrder = 0
      object cxGridContractPriceList: TcxGrid
        Left = 1
        Top = 1
        Width = 269
        Height = 301
        Align = alClient
        TabOrder = 0
        LookAndFeel.Kind = lfStandard
        LookAndFeel.NativeStyle = False
        LookAndFeel.SkinName = ''
        object cxGridDBTableViewContractPriceList: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ContractPriceListDS
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
          object PriceListName_ch6: TcxGridDBColumn
            Caption = #1055#1088#1072#1081#1089' '#1083#1080#1089#1090
            DataBinding.FieldName = 'PriceListName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ContractPriceListChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object StartDate_ch6: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1091#1077#1090' c...'
            DataBinding.FieldName = 'StartDate'
            FooterAlignmentHorz = taCenter
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object EndDate_ch6: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1091#1077#1090' '#1087#1086'...'
            DataBinding.FieldName = 'EndDate'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Comment_ch6: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object InsertName_ch6: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object UpdateName_ch6: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InsertDate_ch6: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object UpdateDate_ch6: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 48
          end
          object isErased_ch6: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            Options.Editing = False
            Width = 20
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableViewContractPriceList
        end
      end
    end
    object Panel4: TPanel
      Left = 753
      Top = 6
      Width = 177
      Height = 215
      Caption = 'Panel4'
      TabOrder = 1
    end
    object cxSplitter3: TcxSplitter
      Left = 994
      Top = 1
      Width = 8
      Height = 303
      HotZoneClassName = 'TcxMediaPlayer8Style'
      AlignSplitter = salRight
      Control = Panel3
    end
    object cxGrid: TcxGrid
      Left = 1
      Top = 1
      Width = 993
      Height = 303
      Align = alClient
      TabOrder = 3
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
        OptionsBehavior.IncSearchItem = Comment
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsView.HeaderHeight = 40
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object isIrna: TcxGridDBColumn
          Caption = #1048#1088#1085#1072
          DataBinding.FieldName = 'isIrna'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1048#1088#1085#1072' ('#1044#1072'/'#1053#1077#1090')'
          Options.Editing = False
          Width = 45
        end
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
          Width = 50
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
              Action = ContractTagChoiceForm
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
          Width = 80
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
              Action = JuridicalChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 132
        end
        object JuridicalDocumentName: TcxGridDBColumn
          Caption = #1070#1088'. '#1083#1080#1094#1086' ('#1087#1077#1095#1072#1090#1100' '#1076#1086#1082'.)'
          DataBinding.FieldName = 'JuridicalDocumentName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = JuridicalDocumentChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 100
        end
        object JuridicalInvoiceName: TcxGridDBColumn
          Caption = #1070#1088'. '#1083#1080#1094#1086' ('#1087#1077#1095#1072#1090#1100' '#1076#1086#1082'.  '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082')'
          DataBinding.FieldName = 'JuridicalInvoiceName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = JuridicalInvoiceChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 100
        end
        object OKPO: TcxGridDBColumn
          Caption = #1054#1050#1055#1054
          DataBinding.FieldName = 'OKPO'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
        object PaidKindName: TcxGridDBColumn
          Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
          DataBinding.FieldName = 'PaidKindName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = PaidKindChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 50
        end
        object CurrencyName: TcxGridDBColumn
          Caption = #1042#1072#1083#1102#1090#1072
          DataBinding.FieldName = 'CurrencyName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
        object ChangePercent: TcxGridDBColumn
          Caption = '(-)% '#1057#1082#1080#1076'. (+)% '#1053#1072#1094'.'
          DataBinding.FieldName = 'ChangePercent'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object ChangePercentPartner: TcxGridDBColumn
          Caption = '% '#1053#1072#1094'. '#1055#1072#1074'.'
          DataBinding.FieldName = 'ChangePercentPartner'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object SigningDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' '#1079#1072#1082#1083#1102#1095#1077#1085#1080#1103
          DataBinding.FieldName = 'SigningDate'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
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
        object EndDate_real: TcxGridDBColumn
          Caption = #1044#1077#1081#1089#1090#1074'. '#1076#1086' ('#1080#1085#1092'.)'
          DataBinding.FieldName = 'EndDate_real'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1044#1086#1075#1086#1074#1086#1088' '#1076#1077#1081#1089#1090#1074'. '#1076#1086' ('#1080#1085#1092'.)'
          Options.Editing = False
          Width = 60
        end
        object EndDate_Term: TcxGridDBColumn
          Caption = #1044#1077#1081#1089#1090#1074'. '#1076#1086' ('#1089' '#1087#1088#1086#1083#1086#1085#1075#1072#1094#1080#1077#1081')'
          DataBinding.FieldName = 'EndDate_Term'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object ContractTermKindName: TcxGridDBColumn
          Caption = #1058#1080#1087' '#1087#1088#1086#1083#1086#1085#1075#1072#1094#1080#1080
          DataBinding.FieldName = 'ContractTermKindName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 50
        end
        object Term: TcxGridDBColumn
          Caption = #1055#1077#1088#1080#1086#1076' '#1087#1088#1086#1083#1086#1085#1075#1072#1094#1080#1080
          DataBinding.FieldName = 'Term'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.#;-,0.#; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 45
        end
        object ContractKindName: TcxGridDBColumn
          Caption = #1042#1080#1076' '#1076#1086#1075'.'
          DataBinding.FieldName = 'ContractKindName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = ContractKindChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 86
        end
        object InfoMoneyGroupCode: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1059#1055' '#1075#1088#1091#1087#1087#1099
          DataBinding.FieldName = 'InfoMoneyGroupCode'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object InfoMoneyGroupName: TcxGridDBColumn
          Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
          DataBinding.FieldName = 'InfoMoneyGroupName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = InfoMoneyChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 113
        end
        object InfoMoneyDestinationCode: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1059#1055' '#1085#1072#1079#1085#1072#1095'.'
          DataBinding.FieldName = 'InfoMoneyDestinationCode'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object InfoMoneyDestinationName: TcxGridDBColumn
          Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
          DataBinding.FieldName = 'InfoMoneyDestinationName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object InfoMoneyCode: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1059#1055
          DataBinding.FieldName = 'InfoMoneyCode'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = InfoMoneyChoiceForm
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
              Action = InfoMoneyChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object PersonalName: TcxGridDBColumn
          Caption = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
          DataBinding.FieldName = 'PersonalName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = PersonalChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 82
        end
        object PersonalTradeName: TcxGridDBColumn
          Caption = #1058#1055' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
          DataBinding.FieldName = 'PersonalTradeName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = PersonalTradeChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 60
        end
        object PersonalCollationName: TcxGridDBColumn
          Caption = #1041#1091#1093#1075'.'#1089#1074#1077#1088#1082#1072' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
          DataBinding.FieldName = 'PersonalCollationName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = PersonalCollationChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 78
        end
        object PersonalSigningName: TcxGridDBColumn
          Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1087#1086#1076#1087#1080#1089#1072#1085#1090')'
          DataBinding.FieldName = 'PersonalSigningName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 75
        end
        object AreaContractName: TcxGridDBColumn
          Caption = #1056#1077#1075#1080#1086#1085' ('#1076#1086#1075#1086#1074#1086#1088')'
          DataBinding.FieldName = 'AreaContractName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object ContractArticleName: TcxGridDBColumn
          Caption = #1055#1088#1077#1076#1084#1077#1090' '#1076#1086#1075#1086#1074#1086#1088#1072
          DataBinding.FieldName = 'ContractArticleName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
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
        object BankAccountName: TcxGridDBColumn
          Caption = #1056'.'#1089#1095#1077#1090' ('#1074#1093'.'#1087#1083#1072#1090#1077#1078')'
          DataBinding.FieldName = 'BankAccountName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = BankAccountChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
        object BankAccountExternal: TcxGridDBColumn
          Caption = #1056'.'#1089#1095#1077#1090' ('#1080#1089#1093'.'#1087#1083#1072#1090#1077#1078')'
          DataBinding.FieldName = 'BankAccountExternal'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 47
        end
        object BankAccountPartner: TcxGridDBColumn
          Caption = #1088#1072#1089#1095'.'#1089#1095#1077#1090' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103')'
          DataBinding.FieldName = 'BankAccountPartner'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 47
        end
        object BankName: TcxGridDBColumn
          Caption = #1041#1072#1085#1082' ('#1080#1089#1093'.'#1087#1083#1072#1090#1077#1078')'
          DataBinding.FieldName = 'BankName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 61
        end
        object isWMS: TcxGridDBColumn
          Caption = #1054#1090#1087'. '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' '#1042#1052#1057
          DataBinding.FieldName = 'isWMS'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1054#1090#1087#1088#1072#1074#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' '#1042#1052#1057
          Options.Editing = False
          Width = 98
        end
        object InsertName: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
          DataBinding.FieldName = 'InsertName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object UpdateName: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
          DataBinding.FieldName = 'UpdateName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object InsertDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
          DataBinding.FieldName = 'InsertDate'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object UpdateDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
          DataBinding.FieldName = 'UpdateDate'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 48
        end
        object GLNCode: TcxGridDBColumn
          Caption = #1050#1086#1076' GLN - '#1087#1086#1089#1090#1072#1074#1097#1080#1082
          DataBinding.FieldName = 'GLNCode'
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 45
        end
        object clPartnerCode: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1087#1086#1089#1090'.'
          DataBinding.FieldName = 'PartnerCode'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1050#1086#1076' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
          Options.Editing = False
          Width = 60
        end
        object Comment: TcxGridDBColumn
          Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
          DataBinding.FieldName = 'Comment'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 58
        end
        object DayTaxSummary: TcxGridDBColumn
          Caption = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1057#1074#1086#1076#1085#1086#1081' '#1053#1053
          DataBinding.FieldName = 'DayTaxSummary'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.#;-,0.#; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1089#1074#1086#1076#1085#1086#1081' '#1053#1053' (0 = 1 '#1084#1077#1089#1103#1094')'
          Options.Editing = False
          Width = 87
        end
        object IsStandart: TcxGridDBColumn
          Caption = #1058#1080#1087#1086#1074#1086#1081
          DataBinding.FieldName = 'isStandart'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 40
        end
        object IsPersonal: TcxGridDBColumn
          Caption = 'C'#1083#1091#1078'. '#1079#1072#1087'.'
          DataBinding.FieldName = 'isPersonal'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 40
        end
        object IsDefault: TcxGridDBColumn
          Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
          DataBinding.FieldName = 'isDefault'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
          Options.Editing = False
          Width = 40
        end
        object IsDefaultOut: TcxGridDBColumn
          Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1080#1089#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
          DataBinding.FieldName = 'isDefaultOut'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1080#1089#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
          Options.Editing = False
          Width = 40
        end
        object IsUnique: TcxGridDBColumn
          Caption = #1056#1072#1089#1095#1077#1090' '#1076#1086#1083#1075#1072
          DataBinding.FieldName = 'isUnique'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 40
        end
        object DocumentCount: TcxGridDBColumn
          Caption = #1050#1086#1083'-'#1074#1086' '#1076#1086#1082'-'#1090#1086#1074
          DataBinding.FieldName = 'DocumentCount'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object DateDocument: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' '#1076#1086#1082'-'#1090#1072
          DataBinding.FieldName = 'DateDocument'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object ContractKeyId: TcxGridDBColumn
          Caption = #1050#1083#1102#1095' ('#1088#1072#1089#1095'. '#1076#1086#1083#1075#1072')'
          DataBinding.FieldName = 'ContractKeyId'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 50
        end
        object ContractStateKindName_Key: TcxGridDBColumn
          Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1075'. ('#1088#1072#1089#1095'. '#1076#1086#1083#1075#1072')'
          DataBinding.FieldName = 'ContractStateKindCode_Key'
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
        object Code_Key: TcxGridDBColumn
          Caption = #1050#1086#1076' ('#1088#1072#1089#1095'. '#1076#1086#1083#1075#1072')'
          DataBinding.FieldName = 'Code_Key'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 40
        end
        object InvNumber_Key: TcxGridDBColumn
          Caption = #8470' '#1076#1086#1075'. ('#1088#1072#1089#1095'. '#1076#1086#1083#1075#1072')'
          DataBinding.FieldName = 'InvNumber_Key'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object PriceListName: TcxGridDBColumn
          Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          DataBinding.FieldName = 'PriceListName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' ('#1087#1086#1089#1083#1077#1076#1085#1080#1081')'
          Options.Editing = False
          Width = 60
        end
        object StartDate_PriceList: TcxGridDBColumn
          Caption = #1044#1077#1081#1089#1090#1091#1077#1090' c... ('#1055#1088#1072#1081#1089'-'#1083#1080#1089#1090')'
          DataBinding.FieldName = 'StartDate_PriceList'
          Options.Editing = False
          Width = 70
        end
        object PriceListName_old: TcxGridDBColumn
          Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090'(old)'
          DataBinding.FieldName = 'PriceListName_old'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090'(old)'
          Options.Editing = False
          Width = 60
        end
        object PriceListGoodsName: TcxGridDBColumn
          Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090'('#1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103')'
          DataBinding.FieldName = 'PriceListGoodsName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
        object GoodsPropertyName: TcxGridDBColumn
          Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '#1089#1074#1086#1081#1089#1090#1074' '#1090#1086#1074#1072#1088#1072
          DataBinding.FieldName = 'GoodsPropertyName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = GoodsPropertyChoiceForm
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 60
        end
        object BranchName: TcxGridDBColumn
          Caption = #1060#1080#1083#1080#1072#1083' ('#1088#1072#1089#1095#1077#1090#1099' '#1085#1072#1083')'
          DataBinding.FieldName = 'BranchName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object isVat: TcxGridDBColumn
          Caption = 'C'#1090#1072#1074#1082#1072' 0% ('#1090#1072#1084#1086#1078#1085#1103')'
          DataBinding.FieldName = 'isVat'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 30
        end
        object isNotVat: TcxGridDBColumn
          Caption = 'C'#1090#1072#1074#1082#1072' 0%'
          DataBinding.FieldName = 'isNotVat'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1082#1083#1080#1077#1085#1090' '#1073#1077#1079' '#1053#1044#1057' ('#1089#1090#1072#1074#1082#1072' 0%)'
          Options.Editing = False
          Width = 30
        end
        object isRealEx: TcxGridDBColumn
          Caption = #1060#1080#1079'. '#1086#1073#1084#1077#1085
          DataBinding.FieldName = 'isRealEx'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1060#1080#1079'. '#1086#1073#1084#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
          Options.Editing = False
          Width = 46
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
        object isNotTareReturning: TcxGridDBColumn
          Caption = #1053#1077#1090' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1090#1072#1088#1099
          DataBinding.FieldName = 'isNotTareReturning'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object isMarketNot: TcxGridDBColumn
          Caption = #1054#1075#1088'. '#1076#1086#1089#1090#1091#1087' '#1084#1072#1088#1082#1077#1090#1080#1085#1075
          DataBinding.FieldName = 'isMarketNot'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          HeaderHint = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1085#1099#1081' '#1076#1086#1089#1090#1091#1087' '#1084#1072#1088#1082#1077#1090#1080#1085#1075
          Options.Editing = False
          Width = 80
        end
      end
      object cxGridLevel: TcxGridLevel
        GridView = cxGridDBTableView
      end
    end
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
    Left = 96
    Top = 160
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
      end
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
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
    Left = 136
    Top = 136
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
          ItemName = 'bsContract'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bsContract'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bsContract'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
        end
        item
          Visible = True
          ItemName = 'bsContract'
        end
        item
          Visible = True
          ItemName = 'bsContract'
        end
        item
          Visible = True
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bsContract2'
        end
        item
          Visible = True
          ItemName = 'bsContract'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecCCK'
        end
        item
          Visible = True
          ItemName = 'bsContractCondition'
        end
        item
          Visible = True
          ItemName = 'bsContract'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecordCCPartner'
        end
        item
          Visible = True
          ItemName = 'bsContractConditionPartner'
        end
        item
          Visible = True
          ItemName = 'bbShowAll_CCPartner'
        end
        item
          Visible = True
          ItemName = 'bsContract'
        end
        item
          Visible = True
          ItemName = 'bbRecordCP'
        end
        item
          Visible = True
          ItemName = 'bsContractPartner'
        end
        item
          Visible = True
          ItemName = 'bsContract'
        end
        item
          Visible = True
          ItemName = 'bbRecordGoods'
        end
        item
          Visible = True
          ItemName = 'bsContractGoods'
        end
        item
          Visible = True
          ItemName = 'bsContract'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecord_ContractPriceList'
        end
        item
          Visible = True
          ItemName = 'bsContractPriceList'
        end
        item
          Visible = True
          ItemName = 'bsContract'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isIrna'
        end
        item
          Visible = True
          ItemName = 'bsContract'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'bsContract'
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
      Action = actInsert
      Category = 0
    end
    object bbEdit: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object bbSetErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
    end
    object bbSetUnErased: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
    end
    object bbGridToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object bsContract: TdxBarStatic
      Caption = '    '
      Category = 0
      Hint = '    '
      Visible = ivAlways
      ShowCaption = False
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbInsertRecCCK: TdxBarButton
      Action = InsertRecordCCK
      Category = 0
    end
    object bbIsPeriod: TdxBarControlContainerItem
      Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      Category = 0
      Hint = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      Visible = ivAlways
      Control = cbPeriod
    end
    object bbStartDate: TdxBarControlContainerItem
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1087#1077#1088#1080#1086#1076#1072
      Category = 0
      Hint = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1087#1077#1088#1080#1086#1076#1072
      Visible = ivAlways
      Control = deStart
    end
    object bbEnd: TdxBarControlContainerItem
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072
      Category = 0
      Hint = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072
      Visible = ivAlways
      Control = cxlEnd
    end
    object bbEndDate: TdxBarControlContainerItem
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1087#1077#1088#1080#1086#1076#1072
      Category = 0
      Hint = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1087#1077#1088#1080#1086#1076#1072
      Visible = ivAlways
      Control = deEnd
    end
    object bbIsEndDate: TdxBarControlContainerItem
      Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1087#1086' '#1076#1072#1090#1091' '#1086#1082#1086#1085#1095#1072#1085#1080#1103
      Category = 0
      Hint = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' '#1087#1086' '#1076#1072#1090#1091' '#1086#1082#1086#1085#1095#1072#1085#1080#1103
      Visible = ivAlways
      Control = cbEndDate
    end
    object bbRecordCP: TdxBarButton
      Action = InsertRecordCP
      Category = 0
    end
    object bbProtocol: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbRecordGoods: TdxBarButton
      Action = InsertRecordGoods
      Category = 0
    end
    object bbSetErasedPartner: TdxBarButton
      Action = dsdSetErasedPartner
      Category = 0
    end
    object bbSetErasedGoods: TdxBarButton
      Action = dsdSetErasedGoods
      Category = 0
    end
    object bbSetUnErasedPartner: TdxBarButton
      Action = dsdSetUnErasedPartner
      Category = 0
    end
    object bbSetUnErasedGoods: TdxBarButton
      Action = dsdSetUnErasedGoods
      Category = 0
    end
    object bbProtocolOpenFormCondition: TdxBarButton
      Action = ProtocolOpenFormCondition
      Category = 0
    end
    object bbProtocolOpenFormPartner: TdxBarButton
      Action = ProtocolOpenFormPartner
      Category = 0
    end
    object bbProtocolOpenFormGoods: TdxBarButton
      Action = ProtocolOpenFormGoods
      Category = 0
    end
    object bbCustom: TdxBarButton
      Action = actUpdateVat
      Category = 0
    end
    object bbUpdateDefaultOut: TdxBarButton
      Action = actUpdateDefaultOut
      Category = 0
    end
    object bbUpdate_isWMS: TdxBarButton
      Action = actUpdate_isWMS
      Category = 0
    end
    object bbUpdateStateKind_Closed: TdxBarButton
      Action = macUpdateStateKind_Closed
      Category = 0
    end
    object bbContractGoodsChoiceOpenForm: TdxBarButton
      Action = actContractGoodsChoiceOpenForm
      Category = 0
    end
    object bbInsertRecordCCPartner: TdxBarButton
      Action = InsertRecordCCPartner
      Category = 0
    end
    object bbdsdSetErasedCCPartner: TdxBarButton
      Action = dsdSetErasedCCPartner
      Category = 0
    end
    object bbdsdSetUnErasedССPartner: TdxBarButton
      Action = dsdSetUnErasedССPartner
      Category = 0
    end
    object bbProtocolOpenFormCCPartner: TdxBarButton
      Action = ProtocolOpenFormCCPartner
      Category = 0
    end
    object bbDelete_ContractSend: TdxBarButton
      Action = actDelete_ContractSend
      Category = 0
    end
    object bbInsertRecord_ContractPriceList: TdxBarButton
      Action = InsertRecord_ContractPriceList
      Category = 0
    end
    object bbSetErased_ContractPriceList: TdxBarButton
      Action = actSetErased_ContractPriceList
      Category = 0
    end
    object bbSetUnErased_ContractPriceList: TdxBarButton
      Action = actSetUnErased_ContractPriceList
      Category = 0
    end
    object bbOpenForm_ContractPriceList: TdxBarButton
      Action = OpenForm_ContractPriceList
      Category = 0
    end
    object bsContractPriceList: TdxBarSubItem
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbSetErased_ContractPriceList'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased_ContractPriceList'
        end
        item
          Visible = True
          ItemName = 'bbOpenForm_ContractPriceList'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbStartLoadPriceList'
        end
        item
          Visible = True
          ItemName = 'bbStartLoadPriceListNew'
        end>
    end
    object bbShowErased: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object bsContract2: TdxBarSubItem
      Caption = #1044#1086#1075#1086#1074#1086#1088
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          Visible = True
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'
        end
        item
          Visible = True
          ItemName = 'bbProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbCustom'
        end
        item
          Visible = True
          ItemName = 'bbUpdateDefaultOut'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isWMS'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Personal'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbUpdateStateKind_Closed'
        end>
    end
    object dxBarSeparator1: TdxBarSeparator
      Caption = 'dxBarSeparator1'
      Category = 0
      Hint = 'dxBarSeparator1'
      Visible = ivAlways
      ShowCaption = False
    end
    object bsContractCondition: TdxBarSubItem
      Caption = #1059#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbSetErasedCC'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'#1057#1057
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenFormCondition'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbDelete_ContractSend'
        end>
    end
    object bsContractPartner: TdxBarSubItem
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1076#1086#1075#1086#1074#1086#1088')'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbSetErasedPartner'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedPartner'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateCP_grid'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenFormPartner'
        end>
    end
    object bsContractConditionPartner: TdxBarSubItem
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1091#1089#1083#1086#1074#1080#1077' '#1076#1086#1075'.)'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbdsdSetErasedCCPartner'
        end
        item
          Visible = True
          ItemName = 'bbdsdSetUnErased'#1057#1057'Partner'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_CCP_Connected_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_CCP_Connected_No'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcelCCP'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenFormCCPartner'
        end>
    end
    object bsContractGoods: TdxBarSubItem
      Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbSetErasedGoods'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedGoods'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenFormGoods'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbContractGoodsChoiceOpenForm'
        end>
    end
    object bbSetErasedCC: TdxBarButton
      Action = dsdSetErasedCC
      Category = 0
    end
    object bbSetUnErasedСС: TdxBarButton
      Action = dsdSetUnErasedСС
      Category = 0
    end
    object bbUpdate_isIrna: TdxBarButton
      Action = macUpdate_isIrna
      Category = 0
    end
    object bbShowAll_CCPartner: TdxBarButton
      Action = actShowAll_CCPartner
      Category = 0
    end
    object bbUpdate_CCP_Connected_Yes: TdxBarButton
      Action = macUpdate_CCP_Connected_Yes
      Category = 0
    end
    object bbUpdate_CCP_Connected_No: TdxBarButton
      Action = macUpdate_CCP_Connected_No
      Category = 0
    end
    object bbGridToExcelCCP: TdxBarButton
      Action = actGridToExcelCCP
      Category = 0
    end
    object bbStartLoad: TdxBarButton
      Action = macStartLoad
      Category = 0
    end
    object bbStartLoadPriceList: TdxBarButton
      Action = macStartLoadPriceList
      Category = 0
    end
    object bbInsertUpdateCP_grid: TdxBarButton
      Action = actInsertUpdateCP_grid
      Category = 0
    end
    object bbStartLoadPriceListNew: TdxBarButton
      Action = macStartLoadPriceListNew
      Category = 0
    end
    object bbUpdate_Personal: TdxBarButton
      Action = macUpdate_Personal
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 248
    Top = 136
    object actDoLoad_PriceList: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <>
    end
    object actGetImportSetting_PriceListNew: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_PriceListNew
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_PriceListNew
        end>
      Caption = 'actGetImportSetting'
    end
    object InsertRecord_ContractPriceList: TInsertRecord
      Category = 'ContractPriceList'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewContractPriceList
      Action = ContractPriceListChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' ('#1076#1086#1075#1086#1074#1086#1088')>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' ('#1076#1086#1075#1086#1074#1086#1088')>'
      ImageIndex = 0
    end
    object macStartLoadPriceListNew: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_PriceListNew
        end
        item
          Action = actDoLoad_PriceList
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1074' '#1048#1089#1090#1086#1088#1080#1102' '#1087#1088#1072#1081#1089#1086#1074' ('#1085#1086#1074#1099#1081' '#1087#1088#1072#1081#1089') '#1080#1079' '#1101#1082#1089#1077#1083#1103'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1087#1088#1072#1081#1089#1086#1074' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#1080#1089#1090#1086#1088#1080#1080' '#1087#1088#1072#1081#1089#1086#1074' ('#1085#1086#1074#1099#1081' '#1087#1088#1072#1081#1089')'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#1080#1089#1090#1086#1088#1080#1080' '#1087#1088#1072#1081#1089#1086#1074' ('#1085#1086#1074#1099#1081' '#1087#1088#1072#1081#1089')'
      ImageIndex = 41
    end
    object actGetImportSetting_PriceList: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_PriceList
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_PriceList
        end>
      Caption = 'actGetImportSetting'
    end
    object actRefreshCCPartner: TdsdDataSetRefresh
      Category = 'CCPartner'
      MoveParams = <>
      StoredProc = spSelectCCPartner
      StoredProcList = <
        item
          StoredProc = spSelectCCPartner
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object macStartLoadPriceList: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_PriceList
        end
        item
          Action = actDoLoad_PriceList
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1048#1089#1090#1086#1088#1080#1080' '#1087#1088#1072#1081#1089#1086#1074' '#1080#1079' '#1101#1082#1089#1077#1083#1103'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1087#1088#1072#1081#1089#1086#1074' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#1080#1089#1090#1086#1088#1080#1080' '#1087#1088#1072#1081#1089#1086#1074
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#1080#1089#1090#1086#1088#1080#1080' '#1087#1088#1072#1081#1089#1086#1074
      ImageIndex = 41
    end
    object OpenForm_ContractPriceList: TdsdOpenForm
      Category = 'ContractPriceList'
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
          Component = ContractPriceListCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ContractPriceListCDS
          ComponentItem = 'PriceListName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object dsdSetErasedCC: TdsdUpdateErased
      Category = 'Condition'
      MoveParams = <>
      StoredProc = spErasedUnErasedCC
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedCC
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ContractConditionDS
    end
    object actSetErased_ContractPriceList: TdsdUpdateErased
      Category = 'ContractPriceList'
      MoveParams = <>
      StoredProc = spErasedUnErased_ContractPriceList
      StoredProcList = <
        item
          StoredProc = spErasedUnErased_ContractPriceList
        end
        item
          StoredProc = spSelect_ContractPriceList
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ContractPriceListDS
    end
    object dsdSetUnErasedСС: TdsdUpdateErased
      Category = 'Condition'
      MoveParams = <>
      StoredProc = spErasedUnErasedCC
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedCC
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ContractConditionDS
    end
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
    object actSetUnErased_ContractPriceList: TdsdUpdateErased
      Category = 'ContractPriceList'
      MoveParams = <>
      StoredProc = spErasedUnErased_ContractPriceList
      StoredProcList = <
        item
          StoredProc = spErasedUnErased_ContractPriceList
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ContractPriceListDS
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectContractCondition
        end
        item
          StoredProc = spSelectCCPartner
        end
        item
          StoredProc = spSelectContractPartner
        end
        item
          StoredProc = spSelectContractGoods
        end
        item
          StoredProc = spSelect_ContractPriceList
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object macUpdate_CCP_Connected_No: TMultiAction
      Category = 'CCPartner'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_CCP_Connected_list_No
        end
        item
          Action = actRefreshCCPartner
        end>
      QuestionBeforeExecute = #1054#1090#1082#1083#1102#1095#1080#1090#1100' '#1042#1057#1045' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1058#1058' '#1086#1090' '#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072'?'
      Caption = #1054#1090#1082#1083#1102#1095#1080#1090#1100' '#1042#1057#1045' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1058#1058' '#1086#1090' '#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
      Hint = #1054#1090#1082#1083#1102#1095#1080#1090#1100' '#1042#1057#1045' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1058#1058' '#1086#1090' '#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
      ImageIndex = 52
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
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1042#1057#1045' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1044#1086#1075#1086#1074#1086#1088#1072
      Hint = #1047#1072#1082#1088#1099#1090#1100' '#1042#1057#1045' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
      ImageIndex = 13
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
          Component = CDSContractCondition
          ComponentItem = 'PaidKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = CDSContractCondition
          ComponentItem = 'PaidKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object PaidKindChoiceForm: TOpenChoiceForm
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
          Component = ClientDataSet
          ComponentItem = 'PaidKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PaidKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object InsertRecordCCPartner: TInsertRecord
      Category = 'CCPartner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewCCPartner
      Action = PartnerContractConditionChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1091#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072')>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1091#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072')>'
      ImageIndex = 0
    end
    object InsertRecordGoods: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewGoods
      Action = GoodsChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088' ('#1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103')>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088' ('#1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103')>'
      ImageIndex = 0
    end
    object InsertRecordCP: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewPartner
      Action = PartnerChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1076#1086#1075#1086#1074#1086#1088')>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1076#1086#1075#1086#1074#1086#1088')>'
      ImageIndex = 0
    end
    object ProtocolOpenFormCCPartner: TdsdOpenForm
      Category = 'CCPartner'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
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
          Component = CCPartnerCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = CCPartnerCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1044#1086#1075#1086#1074#1086#1088
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1044#1086#1075#1086#1074#1086#1088
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TContractEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object ProtocolOpenFormGoods: TdsdOpenForm
      Category = 'DSDLib'
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
          Component = CDSContractGoods
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = CDSContractGoods
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object ProtocolOpenFormPartner: TdsdOpenForm
      Category = 'DSDLib'
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
          Component = CDSContractPartner
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = CDSContractPartner
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
          Component = CDSContractCondition
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = CDSContractCondition
          ComponentItem = 'BonusKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object ProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
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
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'InvNumber'
          DataType = ftString
          ParamType = ptInput
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
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1059#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1059#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072'>'
      ImageIndex = 0
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TContractEditForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalId'
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
      isShowModal = True
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object dsdSetErasedCCPartner: TdsdUpdateErased
      Category = 'CCPartner'
      MoveParams = <>
      StoredProc = spErasedUnErasedCCPartner
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedCCPartner
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      DataSource = CCPartnerDS
    end
    object ContractKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContractKindChoiceForm'
      FormName = 'TContractKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'ContractKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'ContractKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGridToExcelCCP: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = CCPartner
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1059#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072')'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1059#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072')'
      ImageIndex = 6
      ShortCut = 16472
    end
    object dsdSetErasedGoods: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedGoods
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedGoods
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      DataSource = DataSourceGoods
    end
    object dsdSetErasedPartner: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedPartner
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedPartner
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      DataSource = DataSourcePartner
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
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      DataSource = DataSource
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
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyCode'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyGroupId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyGroupName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object InfoMoneyChoiceForm_ContractCondition: TOpenChoiceForm
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
          Component = CDSContractCondition
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = CDSContractCondition
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object dsdSetUnErasedССPartner: TdsdUpdateErased
      Category = 'CCPartner'
      MoveParams = <>
      StoredProc = spErasedUnErasedCCPartner
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedCCPartner
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = CCPartnerDS
    end
    object GoodsPropertyChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsPropertyForm'
      FormName = 'TGoodsPropertyForm'
      FormNameParam.Value = 'TGoodsPropertyForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsPropertyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsPropertyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object ContractPriceListChoiceForm: TOpenChoiceForm
      Category = 'ContractPriceList'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PriceListForm'
      FormName = 'TPriceList_ObjectForm'
      FormNameParam.Value = 'TPriceList_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ContractPriceListCDS
          ComponentItem = 'PriceListId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ContractPriceListCDS
          ComponentItem = 'PriceListName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object JuridicalChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'JuridicalChoiceForm'
      FormName = 'TJuridical_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OKPO'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'OKPO'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalCode'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object dsdSetUnErasedGoods: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedGoods
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedGoods
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DataSourceGoods
    end
    object dsdSetUnErasedPartner: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedPartner
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedPartner
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DataSourcePartner
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
      ShortCut = 8238
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DataSource
    end
    object UpdateDataSet_ContractPriceList: TdsdUpdateDataSet
      Category = 'ContractPriceList'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_ContractPriceList
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_ContractPriceList
        end
        item
          StoredProc = spSelect_ContractPriceList
        end>
      Caption = 'actUpdateDataSet'
      DataSource = ContractPriceListDS
    end
    object ContractTagChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContractTagChoiceForm'
      FormName = 'TContractTagForm'
      FormNameParam.Value = 'TContractTagForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'ContractTagId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'ContractTagName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object BankAccountChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'BankAccountChoiceForm'
      FormName = 'TBankAccountForm'
      FormNameParam.Value = 'TBankAccountForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BankAccountId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BankAccountName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
    object ContractSendChoiceForm: TOpenChoiceForm
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
          Component = CDSContractCondition
          ComponentItem = 'ContractSendId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = CDSContractCondition
          ComponentItem = 'ContractSendName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object ContractConditionKindChoiceForm: TOpenChoiceForm
      Category = 'Condition'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContractConditionKindChoiceForm'
      FormName = 'TContractConditionKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = CDSContractCondition
          ComponentItem = 'ContractConditionKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = CDSContractCondition
          ComponentItem = 'ContractConditionKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
          Name = 'Key'
          Value = Null
          Component = CDSContractCondition
          ComponentItem = 'BonusKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = CDSContractCondition
          ComponentItem = 'BonusKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
    object actUpdateDataSetCCPartner: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateCCPartner
      StoredProcList = <
        item
          StoredProc = spInsertUpdateCCPartner
        end>
      Caption = 'actUpdateDataSet'
      DataSource = CCPartnerDS
    end
    object actUpdateDSGoods: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateContractGoods
      StoredProcList = <
        item
          StoredProc = spInsertUpdateContractGoods
        end>
      Caption = 'actUpdateDSGoods'
      DataSource = DataSourceGoods
    end
    object dsdUpdateDataSet1: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateContractPartner
      StoredProcList = <
        item
          StoredProc = spInsertUpdateContractPartner
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSourcePartner
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
    end
    object PersonalChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PersonalChoiceForm'
      FormName = 'TPersonal_ObjectForm'
      FormNameParam.Value = 'TPersonal_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PersonalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PersonalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macUpdate_isIrna: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_isIrna_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1083#1103' '#1042#1099#1073#1088#1072#1085#1085#1099#1093' '#1101#1083#1077#1084#1077#1085#1090#1086#1074' '#1047#1085#1072#1095#1077#1085#1080#1077' <'#1048#1088#1085#1072'> '#1085#1072' '#1087#1088#1086#1090#1080#1074#1086#1087#1086#1083#1086#1078 +
        #1085#1086#1077'?'
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' '#1080#1079#1084#1077#1085#1077#1085#1086
      Caption = 'macUpdate_isIrna'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1047#1085#1072#1095#1077#1085#1080#1077' <'#1048#1088#1085#1072'> '#1044#1072'/'#1053#1077#1090
      ImageIndex = 66
    end
    object GoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsChoiceForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = CDSContractGoods
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = CDSContractGoods
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object PersonalTradeChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PersonalTradeChoiceForm'
      FormName = 'TPersonal_ObjectForm'
      FormNameParam.Value = 'TPersonal_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PersonalTradeId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PersonalTradeName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object PartnerContractConditionChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartnerChoiceForm'
      FormName = 'TPartner_ObjectForm'
      FormNameParam.Value = 'TPartner_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = CCPartnerCDS
          ComponentItem = 'PartnerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = CCPartnerCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalName'
          MultiSelectSeparator = ','
        end
        item
          Value = True
          Component = CCPartnerCDS
          ComponentItem = 'isConnected'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actDelete_ContractSend: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_ContractSend
      StoredProcList = <
        item
          StoredProc = spDelete_ContractSend
        end
        item
          StoredProc = spSelectContractCondition
        end>
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' '#8470' '#1076#1086#1075'. '#1084#1072#1088#1082#1077#1090'./'#1073#1072#1079#1072
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' '#8470' '#1076#1086#1075'. '#1084#1072#1088#1082#1077#1090'./'#1073#1072#1079#1072
      ImageIndex = 77
    end
    object GoodsKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindChoiceForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = 'TGoodsKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = CDSContractGoods
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = CDSContractGoods
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object PartnerChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PartnerChoiceForm'
      FormName = 'TPartner_ObjectForm'
      FormNameParam.Value = 'TPartner_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = CDSContractPartner
          ComponentItem = 'PartnerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = CDSContractPartner
          ComponentItem = 'PartnerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalName'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isConnected'
          Value = True
          Component = CDSContractPartner
          ComponentItem = 'isConnected'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object PersonalCollationChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PersonalCollationChoiceForm'
      FormName = 'TPersonal_ObjectForm'
      FormNameParam.Value = 'TPersonal_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PersonalCollationId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PersonalCollationName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object JuridicalInvoiceChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'JuridicalDocumentChoiceForm'
      FormName = 'TJuridical_ObjectForm'
      FormNameParam.Value = 'TJuridical_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalInvoiceId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalInvoiceName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object JuridicalDocumentChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'JuridicalDocumentChoiceForm'
      FormName = 'TJuridical_ObjectForm'
      FormNameParam.Value = 'TJuridical_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalDocumentId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalDocumentName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdate_isWMS: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isWMS
      StoredProcList = <
        item
          StoredProc = spUpdate_isWMS
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1087#1088#1072#1074#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' '#1042#1052#1057' '#1044#1072'/'#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1090#1087#1088#1072#1074#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1076#1083#1103' '#1042#1052#1057' '#1044#1072'/'#1053#1077#1090
      ImageIndex = 52
    end
    object actUpdateStateKind_Closed: TdsdExecStoredProc
      Category = 'Close'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateStateKind_Closed
      StoredProcList = <
        item
          StoredProc = spUpdateStateKind_Closed
        end>
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
      Hint = #1047#1072#1082#1088#1099#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
      ImageIndex = 13
    end
    object actUpdateVat: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateVat
      StoredProcList = <
        item
          StoredProc = spUpdateVat
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "C'#1090#1072#1074#1082#1072' 0% ('#1090#1072#1084#1086#1078#1085#1103') '#1044#1072'/'#1053#1077#1090'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "C'#1090#1072#1074#1082#1072' 0% ('#1090#1072#1084#1086#1078#1085#1103') '#1044#1072'/'#1053#1077#1090'"'
      ImageIndex = 58
    end
    object actUpdateDefaultOut: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateDefaultOut
      StoredProcList = <
        item
          StoredProc = spUpdateDefaultOut
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1080#1089#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081') '#1044#1072'/'#1053#1077#1090'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1080#1089#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081') '#1044#1072'/'#1053#1077#1090'"'
      ImageIndex = 76
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
    object actContractGoodsChoiceOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1080
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1080
      ImageIndex = 26
      FormName = 'TContractGoodsChoiceForm'
      FormNameParam.Value = 'TContractGoodsChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'ContractId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'InvNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'RetailId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'RetailName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListGoodsId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PriceListGoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceListGoodsName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'PriceListGoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractTagId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'ContractTagId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractTagName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'ContractTagName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsPropertyId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsPropertyId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsPropertyName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsPropertyName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect_ContractPriceList
      StoredProcList = <
        item
          StoredProc = spSelect_ContractPriceList
        end
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
    object actUpdate_isIrna: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isIrna
      StoredProcList = <
        item
          StoredProc = spUpdate_isIrna
        end>
      Caption = 'actUpdate_isIrna'
      ImageIndex = 66
    end
    object macUpdate_isIrna_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_isIrna
        end>
      View = cxGridDBTableView
      Caption = 'macUpdate_isIrna_list'
      ImageIndex = 66
    end
    object actShowAll_CCPartner: TBooleanStoredProcAction
      Category = 'CCPartner'
      MoveParams = <>
      StoredProc = spSelectCCPartner
      StoredProcList = <
        item
          StoredProc = spSelectCCPartner
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082' '#1058#1058' '#1076#1083#1103' '#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075'.'
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082' '#1058#1058' '#1076#1083#1103' '#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075'.'
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1086#1093#1088#1072#1085#1077#1085#1085#1099#1077' '#1058#1058' '#1076#1083#1103' '#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075'.'
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082' '#1058#1058' '#1076#1083#1103' '#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075'.'
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1086#1093#1088#1072#1085#1077#1085#1085#1099#1077'  '#1058#1058' '#1076#1083#1103' '#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075'.'
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082' '#1058#1058' '#1076#1083#1103' '#1091#1089#1083#1086#1074#1080#1103' '#1076#1086#1075'.'
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object macUpdate_CCP_Connected_list_No: TMultiAction
      Category = 'CCPartner'
      MoveParams = <>
      ActionList = <
        item
          Action = dsdSetErasedCCPartner
        end>
      View = cxGridDBTableViewCCPartner
      Caption = #1054#1090#1082#1083#1102#1095#1080#1090#1100' '#1042#1057#1045' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1058#1058' '#1082' '#1091#1089#1083#1086#1074#1080#1102' '#1076#1086#1075#1086#1074#1086#1088#1072
      Hint = #1054#1090#1082#1083#1102#1095#1080#1090#1100' '#1042#1057#1045' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1058#1058' '#1082' '#1091#1089#1083#1086#1074#1080#1102' '#1076#1086#1075#1086#1074#1086#1088#1072
      ImageIndex = 52
    end
    object actUpdate_CCP_Connected_Yes: TdsdExecStoredProc
      Category = 'CCPartner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CCP_Connected_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_CCP_Connected_Yes
        end>
      Caption = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1044#1072
      Hint = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1044#1072
    end
    object macUpdate_CCP_Connected_list_Yes: TMultiAction
      Category = 'CCPartner'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_CCP_Connected_Yes
        end>
      View = cxGridDBTableViewCCPartner
      Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100' '#1042#1057#1045' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1058#1058' '#1082' '#1091#1089#1083#1086#1074#1080#1102' '#1076#1086#1075#1086#1074#1086#1088#1072
      Hint = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100' '#1042#1057#1045' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1058#1058' '#1082' '#1091#1089#1083#1086#1074#1080#1102' '#1076#1086#1075#1086#1074#1086#1088#1072
      ImageIndex = 76
    end
    object macUpdate_CCP_Connected_Yes: TMultiAction
      Category = 'CCPartner'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_CCP_Connected_list_Yes
        end
        item
          Action = actRefreshCCPartner
        end>
      QuestionBeforeExecute = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100' '#1042#1057#1045' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1058#1058' '#1082' '#1091#1089#1083#1086#1074#1080#1102' '#1076#1086#1075#1086#1074#1086#1088#1072'?'
      Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100' '#1042#1057#1045' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1058#1058' '#1082' '#1091#1089#1083#1086#1074#1080#1102' '#1076#1086#1075#1086#1074#1086#1088#1072
      Hint = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100' '#1042#1057#1045' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1058#1058' '#1082' '#1091#1089#1083#1086#1074#1080#1102' '#1076#1086#1075#1086#1074#1086#1088#1072
      ImageIndex = 76
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <>
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
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1044#1086#1075#1086#1074#1086#1088#1086#1074' ('#1092#1080#1079#1086#1073#1084#1077#1085') '#1080#1079' '#1101#1082#1089#1077#1083#1103'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#1044#1086#1075#1086#1074#1086#1088#1072' ('#1092#1080#1079#1086#1073#1084#1077#1085')'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1101#1082#1089#1077#1083#1103' '#1044#1086#1075#1086#1074#1086#1088#1072' ('#1092#1080#1079#1086#1073#1084#1077#1085')'
      ImageIndex = 41
    end
    object actInsertUpdateCP_grid: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateContractPartner_connect
      StoredProcList = <
        item
          StoredProc = spInsertUpdateContractPartner_connect
        end
        item
          StoredProc = spSelectContractPartner
        end>
      Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100' <'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1076#1086#1075#1086#1074#1086#1088')>'
      Hint = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100' <'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1076#1086#1075#1086#1074#1086#1088')>'
      ImageIndex = 76
    end
    object actUpdate_Personal: TdsdExecStoredProc
      Category = 'Personal'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdatePersonal
      StoredProcList = <
        item
          StoredProc = spUpdatePersonal
        end>
      Caption = 'actUpdate_Personal'
      ImageIndex = 76
    end
    object macUpdate_Personal_list: TMultiAction
      Category = 'Personal'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Personal
        end>
      View = cxGridDBTableView
      Caption = 'macUpdate_Personal_list'
      ImageIndex = 76
    end
    object macUpdate_Personal: TMultiAction
      Category = 'Personal'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_Personal_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1089#1077#1084' '#1076#1086#1075#1086#1074#1086#1088#1072#1084' '#1074#1099#1073#1088#1072#1085#1085#1086#1075#1086' <'#1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')>' +
        '?'
      InfoAfterExecute = #1055#1072#1088#1072#1084#1077#1090#1088' <'#1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')> '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' <'#1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')>'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1042#1057#1045#1052' <'#1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')>'
      ImageIndex = 79
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Contract'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41852d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41852d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPeriod'
        Value = False
        Component = cbPeriod
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsEndDate'
        Value = False
        Component = cbEndDate
        DataType = ftBoolean
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
    Left = 136
    Top = 208
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = actUpdate
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
        Action = actUpdate
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
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 760
    Top = 240
  end
  object ContractConditionDS: TDataSource
    DataSet = CDSContractCondition
    Left = 62
    Top = 397
  end
  object CDSContractCondition: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ContractId'
    MasterFields = 'Id'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 177
    Top = 389
  end
  object spInsertUpdateContractCondition: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ContractCondition'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = CDSContractCondition
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = CDSContractCondition
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue'
        Value = Null
        Component = CDSContractCondition
        ComponentItem = 'Value'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercentRetBonus'
        Value = Null
        Component = CDSContractCondition
        ComponentItem = 'PercentRetBonus'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractConditionKindId'
        Value = Null
        Component = CDSContractCondition
        ComponentItem = 'ContractConditionKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBonusKindId'
        Value = Null
        Component = CDSContractCondition
        ComponentItem = 'BonusKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = Null
        Component = CDSContractCondition
        ComponentItem = 'InfoMoneyId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractSendId'
        Value = Null
        Component = CDSContractCondition
        ComponentItem = 'ContractSendId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = Null
        Component = CDSContractCondition
        ComponentItem = 'PaidKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = Null
        Component = CDSContractCondition
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEndDate'
        Value = Null
        Component = CDSContractCondition
        ComponentItem = 'EndDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 152
    Top = 440
  end
  object spSelectContractCondition: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ContractCondition'
    DataSet = CDSContractCondition
    DataSets = <
      item
        DataSet = CDSContractCondition
      end>
    Params = <
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 314
    Top = 413
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Contract'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PersonalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalTradeId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PersonalTradeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalCollationId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'PersonalCollationId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BankAccountId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractTagId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'ContractTagId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalDocumentId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'JuridicalDocumentId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalInvoiceId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'JuridicalInvoiceId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsPropertyId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsPropertyId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 176
  end
  object ChildViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewContractCondition
    OnDblClickActionList = <
      item
        Action = actUpdate
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
        Action = actUpdate
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
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 32
    Top = 480
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
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
  object CDSContractPartner: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ContractId'
    MasterFields = 'Id'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 853
    Top = 469
  end
  object DataSourcePartner: TDataSource
    DataSet = CDSContractPartner
    Left = 806
    Top = 469
  end
  object spSelectContractPartner: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ContractPartner'
    DataSet = CDSContractPartner
    DataSets = <
      item
        DataSet = CDSContractPartner
      end>
    Params = <>
    PackSize = 1
    Left = 937
    Top = 501
  end
  object spInsertUpdateContractPartner: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ContractPartner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = CDSContractPartner
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = CDSContractPartner
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = CDSContractPartner
        ComponentItem = 'PartnerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 960
    Top = 392
  end
  object dsdDBViewAddOnPartner: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewPartner
    OnDblClickActionList = <
      item
        Action = actUpdate
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
        Action = actUpdate
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
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 936
    Top = 440
  end
  object CDSContractGoods: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ContractId'
    MasterFields = 'Id'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 1125
    Top = 413
  end
  object DataSourceGoods: TDataSource
    DataSet = CDSContractGoods
    Left = 1142
    Top = 357
  end
  object dsdDBViewAddOnGoods: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewGoods
    OnDblClickActionList = <
      item
        Action = actUpdate
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
        Action = actUpdate
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
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 1208
    Top = 464
  end
  object spSelectContractGoods: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ContractGoods'
    DataSet = CDSContractGoods
    DataSets = <
      item
        DataSet = CDSContractGoods
      end>
    Params = <>
    PackSize = 1
    Left = 1106
    Top = 469
  end
  object spInsertUpdateContractGoods: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ContractGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = CDSContractGoods
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = CDSContractGoods
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = CDSContractGoods
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = CDSContractGoods
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = CDSContractGoods
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1176
    Top = 424
  end
  object spErasedUnErasedPartner: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ContractPartner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = CDSContractPartner
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 848
    Top = 408
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
    Left = 1096
    Top = 512
  end
  object spUpdateDefaultOut: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Contract_isDefaultOut'
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
        Name = 'inisDefaultOut'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isDefaultOut'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 512
    Top = 251
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
  object spUpdate_isWMS: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Contract_isWMS'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisWMS'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isWMS'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisWMS'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isWMS'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 200
  end
  object spUpdateStateKind_Closed: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Contract_StateKind_Closed'
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
        Name = 'inContractStateKindId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'ContractStateKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'EndDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate_Term'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'EndDate_Term'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 283
  end
  object CCPartnerDS: TDataSource
    DataSet = CCPartnerCDS
    Left = 494
    Top = 469
  end
  object CCPartnerCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ContractConditionId'
    MasterFields = 'Id'
    MasterSource = ContractConditionDS
    PacketRecords = 0
    Params = <>
    Left = 485
    Top = 437
  end
  object dsdDBViewAddOnCCPartner: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewCCPartner
    OnDblClickActionList = <
      item
        Action = actUpdate
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
        Action = actUpdate
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
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 552
    Top = 504
  end
  object spInsertUpdateCCPartner: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ContractConditionPartner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = CCPartnerCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = CCPartnerCDS
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractConditionId'
        Value = Null
        Component = CDSContractCondition
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = CCPartnerCDS
        ComponentItem = 'PartnerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 632
    Top = 480
  end
  object spSelectCCPartner: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ContractConditionPartner'
    DataSet = CCPartnerCDS
    DataSets = <
      item
        DataSet = CCPartnerCDS
      end>
    Params = <
      item
        Name = 'inContractId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowAll'
        Value = Null
        Component = actShowAll_CCPartner
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 545
    Top = 397
  end
  object spErasedUnErasedCCPartner: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ContractConditionPartner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = CCPartnerCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 688
    Top = 408
  end
  object spDelete_ContractSend: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_ContractCondition_ContractSend'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = CDSContractCondition
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outContractSendName'
        Value = Null
        Component = actContractCondition
        ComponentItem = 'ContractSendName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 352
    Top = 488
  end
  object ContractPriceListDS: TDataSource
    DataSet = ContractPriceListCDS
    Left = 1062
    Top = 101
  end
  object ContractPriceListCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ContractId'
    MasterFields = 'Id'
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 1009
    Top = 109
  end
  object spSelect_ContractPriceList: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ContractPriceList'
    DataSet = ContractPriceListCDS
    DataSets = <
      item
        DataSet = ContractPriceListCDS
      end>
    Params = <
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1050
    Top = 165
  end
  object dsdDBViewAddOnContractPriceList: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewContractPriceList
    OnDblClickActionList = <>
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
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 1136
    Top = 144
  end
  object spInsertUpdate_ContractPriceList: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ContractPriceList'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ContractPriceListCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ContractPriceListCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId'
        Value = Null
        Component = ContractPriceListCDS
        ComponentItem = 'PriceListId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = Null
        Component = ContractPriceListCDS
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1096
    Top = 240
  end
  object spErasedUnErased_ContractPriceList: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ContractPriceList'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = ContractPriceListCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 984
    Top = 200
  end
  object spErasedUnErasedCC: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_ContractCondition'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = CDSContractCondition
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 112
    Top = 504
  end
  object spUpdate_isIrna: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Guide_Irna'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisIrna'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'isIrna'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 352
    Top = 184
  end
  object spUpdate_CCP_Connected_Yes: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ContractConditionPartner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = CCPartnerCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = CCPartnerCDS
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractConditionId'
        Value = Null
        Component = CDSContractCondition
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = CCPartnerCDS
        ComponentItem = 'PartnerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 576
    Top = 448
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
        Value = 'TContractForm;zc_Object_ImportSetting_Contract'
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
    Left = 824
    Top = 144
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 736
    Top = 144
  end
  object spGetImportSettingId_PriceList: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TContractPriceListForm;zc_Object_ImportSetting_ContractPriceList'
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
    Left = 840
    Top = 192
  end
  object spInsertUpdateContractPartner_connect: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ContractPartner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = CDSContractPartner
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = Null
        Component = CDSContractPartner
        ComponentItem = 'Code'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = CDSContractPartner
        ComponentItem = 'PartnerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1008
    Top = 440
  end
  object spGetImportSettingId_PriceListNew: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TContractPriceListForm;zc_Object_ImportSetting_ContractPriceList' +
          'New'
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
    Left = 840
    Top = 232
  end
  object GuidesPersonal_update: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonal_update
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonal_update
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonal_update
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 802
    Top = 29
  end
  object spUpdatePersonal: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Contract_PersonalParam'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = ''
        Component = GuidesPersonal_update
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParam'
        Value = '1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 264
  end
end
