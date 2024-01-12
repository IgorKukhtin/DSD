object Goods_UKTZEDForm: TGoods_UKTZEDForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <T'#1086#1074#1072#1088#1099'> ('#1082#1086#1076#1099' '#1059#1050#1058' '#1047#1045#1044')'
  ClientHeight = 404
  ClientWidth = 982
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
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 982
    Height = 378
    Align = alClient
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
      OptionsBehavior.IncSearchItem = Name
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsView.HeaderHeight = 60
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object GoodsPlatformName: TcxGridDBColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' '#1087#1083#1086#1097#1072#1076#1082#1072
        DataBinding.FieldName = 'GoodsPlatformName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 93
      end
      object TradeMarkName: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
        DataBinding.FieldName = 'TradeMarkName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 78
      end
      object GroupStatName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080
        DataBinding.FieldName = 'GroupStatName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object GoodsGroupNameFull: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
        DataBinding.FieldName = 'GoodsGroupNameFull'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 86
      end
      object CodeUKTZED_calc: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1087#1086' '#1059#1050#1058' '#1047#1045#1044' ('#1088#1072#1089#1095#1077#1090')'
        DataBinding.FieldName = 'CodeUKTZED_calc'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object CodeUKTZED: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1087#1086' '#1059#1050#1058' '#1047#1045#1044
        DataBinding.FieldName = 'CodeUKTZED'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CodeUKTZED_group: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1087#1086' '#1059#1050#1058' '#1047#1045#1044' ('#1075#1088#1091#1087#1087#1072')'
        DataBinding.FieldName = 'CodeUKTZED_group'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object CodeUKTZED_Calc_new: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1087#1086' '#1059#1050#1058' '#1047#1045#1044', '#1085#1086#1074#1099#1081' ('#1088#1072#1089#1095#1077#1090')'
        DataBinding.FieldName = 'CodeUKTZED_Calc_new'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object DateUKTZED_new: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1076#1077#1081#1089#1090#1074'. '#1059#1050#1058' '#1047#1045#1044', '#1085#1086#1074#1099#1081
        DataBinding.FieldName = 'DateUKTZED_new'
        FooterAlignmentHorz = taCenter
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1044#1072#1090#1072' '#1076#1077#1081#1089#1090#1074#1080#1103' '#1076#1083#1103' '#1050#1086#1076' '#1087#1086' '#1059#1050#1058' '#1047#1045#1044' ('#1085#1086#1074#1099#1081')'
        Width = 80
      end
      object CodeUKTZED_new: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1087#1086' '#1059#1050#1058' '#1047#1045#1044', '#1085#1086#1074#1099#1081
        DataBinding.FieldName = 'CodeUKTZED_new'
        FooterAlignmentHorz = taCenter
        GroupSummaryAlignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object CodeUKTZED_group_new: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1087#1086' '#1059#1050#1058' '#1047#1045#1044', '#1085#1086#1074#1099#1081' ('#1075#1088#1091#1087#1087#1072')'
        DataBinding.FieldName = 'CodeUKTZED_group_new'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 152
      end
      object MeasureName: TcxGridDBColumn
        Caption = #1045#1076'. '#1080#1079#1084'.'
        DataBinding.FieldName = 'MeasureName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 43
      end
      object Weight: TcxGridDBColumn
        Caption = #1042#1077#1089
        DataBinding.FieldName = 'Weight'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 43
      end
      object TaxImport: TcxGridDBColumn
        Caption = #1055#1088#1080#1079#1085#1072#1082' '#1080#1084#1087#1086#1088#1090'. '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'TaxImport'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1055#1088#1080#1079#1085#1072#1082' '#1080#1084#1087#1086#1088#1090#1080#1088#1086#1074#1072#1085#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072
        Options.Editing = False
        Width = 57
      end
      object TaxImport_calc: TcxGridDBColumn
        Caption = #1055#1088#1080#1079#1085#1072#1082' '#1080#1084#1087#1086#1088#1090'. '#1090#1086#1074#1072#1088#1072' ('#1088#1072#1089#1095#1077#1090')'
        DataBinding.FieldName = 'TaxImport_calc'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 59
      end
      object TaxImport_group: TcxGridDBColumn
        Caption = #1055#1088#1080#1079#1085#1072#1082' '#1080#1084#1087#1086#1088#1090'. '#1090#1086#1074#1072#1088#1072' ('#1075#1088#1091#1087#1087#1072')'
        DataBinding.FieldName = 'TaxImport_group'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 61
      end
      object DKPP: TcxGridDBColumn
        Caption = #1059#1089#1083#1091#1075#1080' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1044#1050#1055#1055
        DataBinding.FieldName = 'DKPP'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 61
      end
      object DKPP_calc: TcxGridDBColumn
        Caption = #1059#1089#1083#1091#1075#1080' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1044#1050#1055#1055' ('#1088#1072#1089#1095#1077#1090')'
        DataBinding.FieldName = 'DKPP_calc'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 59
      end
      object DKPP_group: TcxGridDBColumn
        Caption = #1059#1089#1083#1091#1075#1080' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1044#1050#1055#1055' ('#1075#1088#1091#1087#1087#1072')'
        DataBinding.FieldName = 'DKPP_group'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 58
      end
      object TaxAction: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1074#1080#1076#1072' '#1076#1077#1103#1090'. '#1089'.-'#1093'. '#1087#1088#1086#1080#1079#1074'.'
        DataBinding.FieldName = 'TaxAction'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1076' '#1074#1080#1076#1072' '#1076#1077#1103#1090#1077#1083#1100#1085#1086#1089#1090#1080' '#1089#1077#1083#1100#1089#1082#1086'-'#1093#1086#1079#1103#1081#1089#1090#1074'. '#1090#1086#1074#1072#1088#1086#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1103' '
        Options.Editing = False
        Width = 60
      end
      object TaxAction_calc: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1074#1080#1076#1072' '#1076#1077#1103#1090'. '#1089'.-'#1093'. '#1087#1088#1086#1080#1079#1074'. ('#1088#1072#1089#1095#1077#1090')'
        DataBinding.FieldName = 'TaxAction_calc'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 75
      end
      object TaxAction_group: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1074#1080#1076#1072' '#1076#1077#1103#1090'. '#1089'.-'#1093'. '#1087#1088#1086#1080#1079#1074'. ('#1075#1088#1091#1087#1087#1072')'
        DataBinding.FieldName = 'TaxAction_group'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object BusinessName: TcxGridDBColumn
        Caption = #1041#1080#1079#1085#1077#1089
        DataBinding.FieldName = 'BusinessName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object GoodsGroupPropertyName: TcxGridDBColumn
        Caption = ' '#9#1040#1085#1072#1083#1080#1090#1080#1095#1077#1089#1082#1080#1081' '#1082#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088' '
        DataBinding.FieldName = 'GoodsGroupPropertyName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actChoiceGoodsGroupProperty
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1040#1085#1072#1083#1080#1090#1080#1082#1072' '#1059#1088#1086#1074#1077#1085#1100' 2'
        Width = 112
      end
      object GoodsGroupPropertyName_Parent: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' ('#1040#1085#1072#1083#1080#1090#1080#1095#1077#1089#1082#1080#1081' '#1082#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088')'
        DataBinding.FieldName = 'GoodsGroupPropertyName_Parent'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1040#1085#1072#1083#1080#1090#1080#1082#1072' '#1059#1088#1086#1074#1077#1085#1100' 1'
        Options.Editing = False
        Width = 100
      end
      object InfoMoneyCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055
        DataBinding.FieldName = 'InfoMoneyCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 84
      end
      object InfoMoneyGroupName: TcxGridDBColumn
        Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object InfoMoneyDestinationName: TcxGridDBColumn
        Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
        DataBinding.FieldName = 'InfoMoneyDestinationName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object InfoMoneyName: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object IsErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
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
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 40
    Top = 272
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 112
    Top = 216
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
    Left = 24
    Top = 160
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
    Left = 192
    Top = 96
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
          ItemName = 'bbShowAll'
        end
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
          ItemName = 'bbStartLoad_UKTZEDnew'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad_UKTZEDnewByCode'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenForm'
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
      Action = dsdGridToExcel1
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
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
    object bbStartLoad_UKTZEDnew: TdxBarButton
      Action = macStartLoad_UKTZEDnew
      Category = 0
    end
    object bbStartLoad_UKTZEDnewByCode: TdxBarButton
      Action = macStartLoad_UKTZEDnewByCode
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 208
    Top = 288
    object actGetImportSetting_UKTZEDnewByCode: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_byCode
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_byCode
        end>
      Caption = 'actGetImportSetting_UKTZEDnew'
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
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
          Name = 'Code'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'FuelName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'FuelName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'MeasureName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TradeMarkName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'TradeMarkName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
    end
    object macStartLoad_UKTZEDnewByCode: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_UKTZEDnewByCode
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1082#1086#1076#1086#1074' '#1059#1050#1058#1047' '#1080#1079' '#1092#1072#1081#1083#1072' ('#1087#1086' '#1082#1086#1076#1091' '#1090#1086#1074#1072#1088#1072')?'
      InfoAfterExecute = #1082#1086#1076#1072' '#1059#1050#1058#1047' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1059#1050#1058#1047' '#1085#1072' '#1076#1072#1090#1091' ('#1087#1086' '#1082#1086#1076#1091' '#1090#1086#1074#1072#1088#1072')'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1086#1076' '#1059#1050#1058#1047' '#1085#1072' '#1076#1072#1090#1091' '#1080#1079' '#1092#1072#1081#1083#1072' ('#1087#1086' '#1082#1086#1076#1091' '#1090#1086#1074#1072#1088#1072')'
      ImageIndex = 41
    end
    object dsdGridToExcel1: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
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
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateDataSource: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateParams
      StoredProcList = <
        item
          StoredProc = spUpdateParams
        end>
      Caption = 'actUpdateDataSource'
      DataSource = DataSource
    end
    object actGetImportSetting_UKTZEDnew: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSetting_UKTZEDnew'
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
    object macStartLoad_UKTZEDnew: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_UKTZEDnew
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1082#1086#1076#1086#1074' '#1059#1050#1058#1047' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1082#1086#1076#1072' '#1059#1050#1058#1047' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1059#1050#1058#1047' '#1085#1072' '#1076#1072#1090#1091
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1086#1076' '#1059#1050#1058#1047' '#1085#1072' '#1076#1072#1090#1091' '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 41
    end
    object actChoiceGoodsGroupProperty: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'AssetForm'
      FormName = 'TGoodsGroupPropertyForm'
      FormNameParam.Value = 'TGoodsGroupPropertyForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsGroupPropertyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsGroupPropertyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ParentId'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsGroupPropertyId_Parent'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ParentName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsGroupPropertyName_Parent'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods_UKTZED'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inShowAll'
        Value = True
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 40
    Top = 112
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 128
    Top = 320
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_Goods'
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
    Top = 152
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        ShortCut = 13
      end>
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 232
    Top = 184
  end
  object spUpdateParams: TdsdStoredProc
    StoredProcName = 'gpUpdateObject_Goods_UKTZED'
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
        Name = 'inUKTZED'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CodeUKTZED'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCodeUKTZED_new'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'CodeUKTZED_new'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateUKTZED_new'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'DateUKTZED_new'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupPropertyId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsGroupPropertyId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
    Top = 259
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 464
    Top = 232
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
        Value = 'TGoodsForm;zc_Object_ImportSetting_GoodsUKTZED'
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
    Left = 512
    Top = 144
  end
  object spGetImportSettingId_byCode: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TGoodsForm;zc_Object_ImportSetting_GoodsUKTZED2'
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
    Left = 632
    Top = 144
  end
end
