object LoyaltySPListForm: TLoyaltySPListForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #1042#1099#1073#1086#1088' '#1085#1072#1082#1086#1087#1080#1090#1077#1083#1100#1085#1086#1081' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1083#1086#1103#1103#1083#1100#1085#1086#1089#1090#1080
  ClientHeight = 361
  ClientWidth = 619
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object LoyaltySPListGrid: TcxGrid
    Left = 0
    Top = 28
    Width = 619
    Height = 333
    Align = alClient
    TabOrder = 0
    object LoyaltySPListGridDBTableView: TcxGridDBTableView
      OnDblClick = LoyaltySPListGridDBTableViewDblClick
      OnKeyDown = LoyaltySPListGridDBTableViewKeyDown
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = LoyaltySPListDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = Coment
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GridLineColor = clBtnFace
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object Coment: TcxGridDBColumn
        Caption = #1044#1077#1081#1089#1090#1074#1080#1077
        DataBinding.FieldName = 'Coment'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 250
      end
      object EndPromo: TcxGridDBColumn
        Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1085#1072#1082#1086#1087#1083#1077#1085#1080#1103
        DataBinding.FieldName = 'EndPromo'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 126
      end
      object EndSale: TcxGridDBColumn
        Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1086#1075#1072#1096#1077#1085#1080#1103
        DataBinding.FieldName = 'EndSale'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 86
      end
      object SummaRemainder: TcxGridDBColumn
        Caption = #1053#1072#1082#1086#1087#1083#1077#1085#1086
        DataBinding.FieldName = 'SummaRemainder'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 84
      end
    end
    object LoyaltySPListGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = LoyaltySPListGridDBTableView
    end
  end
  object cxGrid1: TcxGrid
    Left = 0
    Top = 28
    Width = 619
    Height = 333
    Align = alClient
    TabOrder = 5
    object cxGridDBTableView1: TcxGridDBTableView
      OnDblClick = LoyaltySPListGridDBTableViewDblClick
      OnKeyDown = LoyaltySPListGridDBTableViewKeyDown
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = LoyaltySPListDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = cxGridDBColumn1
        end>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GridLineColor = clBtnFace
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object cxGridDBColumn1: TcxGridDBColumn
        Caption = #1044#1077#1081#1089#1090#1074#1080#1077
        DataBinding.FieldName = 'Coment'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 250
      end
      object cxGridDBColumn2: TcxGridDBColumn
        Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1085#1072#1082#1086#1087#1083#1077#1085#1080#1103
        DataBinding.FieldName = 'EndPromo'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 126
      end
      object cxGridDBColumn3: TcxGridDBColumn
        Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1086#1075#1072#1096#1077#1085#1080#1103
        DataBinding.FieldName = 'EndSale'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 86
      end
      object cxGridDBColumn4: TcxGridDBColumn
        Caption = #1053#1072#1082#1086#1087#1083#1077#1085#1086
        DataBinding.FieldName = 'SummaRemainder'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 84
      end
    end
    object cxGridLevel1: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = cxGridDBTableView1
    end
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 224
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <>
    StorageName = 'cxPropertiesStore'
    Left = 160
    Top = 64
  end
  object LoyaltySPListDS: TDataSource
    DataSet = MainCashForm2.LoyaltySPCDS
    Left = 432
    Top = 136
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
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 64
    Top = 64
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      28
      0)
    object dxBarManager1Bar1: TdxBar
      Caption = 'Custom 1'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 613
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
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
    object dxBarButton1: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100' '#1080#1079' '#1083#1080#1089#1090#1072' '#1086#1090#1082#1072#1079#1086#1074
      Category = 0
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100' '#1080#1079' '#1083#1080#1089#1090#1072' '#1086#1090#1082#1072#1079#1086#1074
      Visible = ivAlways
      ImageIndex = 52
      ShortCut = 46
    end
    object cxBarEditItem1: TcxBarEditItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      PropertiesClassName = 'TcxSpinEditProperties'
    end
    object dxBarButton2: TdxBarButton
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074#1089#1077' '#1074#1074#1077#1076#1077#1085#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      Category = 0
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074#1089#1077' '#1074#1074#1077#1076#1077#1085#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      Visible = ivAlways
      ImageIndex = 30
    end
    object dxBarStatic: TdxBarStatic
      Category = 0
      Visible = ivAlways
    end
    object dxBarStatic1: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object dxBarButton3: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object dxBarButton4: TdxBarButton
      Action = actClose
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 56
    Top = 144
    object actClose: TAction
      Caption = #1042#1099#1073#1088#1072#1090#1100
      Hint = #1042#1099#1073#1088#1072#1090#1100
      ImageIndex = 7
      OnExecute = actCloseExecute
    end
  end
end
