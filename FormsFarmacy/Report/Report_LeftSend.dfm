object Report_LeftSendForm: TReport_LeftSendForm
  Left = 0
  Top = 0
  Caption = #1050#1072#1084#1073#1101#1082#1080' '#1087#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103#1084' '#1087#1077#1088#1077#1076' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1077#1081
  ClientHeight = 488
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 31
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 869
    object deStart: TcxDateEdit
      Left = 101
      Top = 5
      EditValue = 43466d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 310
      Top = 5
      EditValue = 43466d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 4
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel2: TcxLabel
      Left = 200
      Top = 6
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 57
    Width = 900
    Height = 199
    Align = alClient
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 5
    ExplicitLeft = 240
    ExplicitTop = 144
    ExplicitWidth = 185
    ExplicitHeight = 41
    object cxSplitter2: TcxSplitter
      Left = 464
      Top = 1
      Width = 8
      Height = 197
      HotZoneClassName = 'TcxMediaPlayer8Style'
      AlignSplitter = salRight
      Control = GridGoods
      ExplicitLeft = 899
    end
    object GridIncome: TcxGrid
      Left = 1
      Top = 1
      Width = 463
      Height = 197
      Align = alClient
      TabOrder = 1
      ExplicitWidth = 394
      object GridIncomeDBBandedTableView: TcxGridDBBandedTableView
        Navigator.Buttons.CustomButtons = <>
        Navigator.Buttons.First.Visible = True
        Navigator.Buttons.PriorPage.Visible = True
        Navigator.Buttons.Prior.Visible = True
        Navigator.Buttons.Next.Visible = True
        Navigator.Buttons.NextPage.Visible = True
        Navigator.Buttons.Last.Visible = True
        Navigator.Buttons.Insert.Visible = True
        Navigator.Buttons.Append.Visible = False
        Navigator.Buttons.Delete.Visible = True
        Navigator.Buttons.Edit.Visible = True
        Navigator.Buttons.Post.Visible = True
        Navigator.Buttons.Cancel.Visible = True
        Navigator.Buttons.Refresh.Visible = True
        Navigator.Buttons.SaveBookmark.Visible = True
        Navigator.Buttons.GotoBookmark.Visible = True
        Navigator.Buttons.Filter.Visible = True
        DataController.DataSource = InventDS
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
        Bands = <
          item
            Caption = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080
            Width = 443
          end>
        object GridIncome_InvNumber: TcxGridDBBandedColumn
          Caption = #1053#1086#1084#1077#1088
          DataBinding.FieldName = 'InvNumber'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 71
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object GridIncome_OperDate: TcxGridDBBandedColumn
          Caption = #1044#1072#1090#1072
          DataBinding.FieldName = 'OperDate'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 84
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 0
        end
        object GridIncome_UnitName: TcxGridDBBandedColumn
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          DataBinding.FieldName = 'UnitName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 288
          Position.BandIndex = 0
          Position.ColIndex = 2
          Position.RowIndex = 0
        end
      end
      object GridIncomeLevel: TcxGridLevel
        GridView = GridIncomeDBBandedTableView
      end
    end
    object GridGoods: TcxGrid
      Left = 472
      Top = 1
      Width = 427
      Height = 197
      Align = alRight
      TabOrder = 2
      object GridGoodsDBBandedTableView: TcxGridDBBandedTableView
        Navigator.Buttons.CustomButtons = <>
        Navigator.Buttons.First.Visible = True
        Navigator.Buttons.PriorPage.Visible = True
        Navigator.Buttons.Prior.Visible = True
        Navigator.Buttons.Next.Visible = True
        Navigator.Buttons.NextPage.Visible = True
        Navigator.Buttons.Last.Visible = True
        Navigator.Buttons.Insert.Visible = True
        Navigator.Buttons.Append.Visible = False
        Navigator.Buttons.Delete.Visible = True
        Navigator.Buttons.Edit.Visible = True
        Navigator.Buttons.Post.Visible = True
        Navigator.Buttons.Cancel.Visible = True
        Navigator.Buttons.Refresh.Visible = True
        Navigator.Buttons.SaveBookmark.Visible = True
        Navigator.Buttons.GotoBookmark.Visible = True
        Navigator.Buttons.Filter.Visible = True
        DataController.DataSource = GoodsDS
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = ',0.####;-,0.####; ;'
            Kind = skSum
            Column = GridGoods_AmountReturn
          end>
        DataController.Summary.SummaryGroups = <>
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        Bands = <
          item
            Caption = #1058#1086#1074#1072#1088#1099' '#1082#1086#1090#1086#1088#1099#1077' '#1074#1077#1088#1085#1091#1083#1080#1089#1100
            Width = 330
          end>
        object GridGoods_GoodsCode: TcxGridDBBandedColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'GoodsCode'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 42
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object GridGoods_GoodsName: TcxGridDBBandedColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'GoodsName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 224
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 0
        end
        object GridGoods_AmountReturn: TcxGridDBBandedColumn
          Caption = #1050#1086#1083'-'#1074#1086
          DataBinding.FieldName = 'AmountReturn'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 64
          Position.BandIndex = 0
          Position.ColIndex = 2
          Position.RowIndex = 0
        end
      end
      object GridGoodsLevel: TcxGridLevel
        GridView = GridGoodsDBBandedTableView
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 264
    Width = 900
    Height = 224
    Align = alBottom
    Caption = 'Panel3'
    ShowCaption = False
    TabOrder = 6
    ExplicitLeft = -1
    ExplicitTop = 270
    object GridWasGot: TcxGrid
      Left = 440
      Top = 1
      Width = 459
      Height = 222
      Align = alRight
      TabOrder = 0
      object GridWasGotDBBandedTableView: TcxGridDBBandedTableView
        Navigator.Buttons.CustomButtons = <>
        Navigator.Buttons.First.Visible = True
        Navigator.Buttons.PriorPage.Visible = True
        Navigator.Buttons.Prior.Visible = True
        Navigator.Buttons.Next.Visible = True
        Navigator.Buttons.NextPage.Visible = True
        Navigator.Buttons.Last.Visible = True
        Navigator.Buttons.Insert.Visible = True
        Navigator.Buttons.Append.Visible = False
        Navigator.Buttons.Delete.Visible = True
        Navigator.Buttons.Edit.Visible = True
        Navigator.Buttons.Post.Visible = True
        Navigator.Buttons.Cancel.Visible = True
        Navigator.Buttons.Refresh.Visible = True
        Navigator.Buttons.SaveBookmark.Visible = True
        Navigator.Buttons.GotoBookmark.Visible = True
        Navigator.Buttons.Filter.Visible = True
        DataController.DataSource = WasGotDS
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = ',0.####;-,0.####; ;'
            Kind = skSum
          end>
        DataController.Summary.SummaryGroups = <>
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
        Bands = <
          item
            Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1074#1086#1079#1074#1088#1072#1090' '#1085#1072' '#1072#1087#1090#1077#1082#1091
            Width = 457
          end>
        object GridWasGot_InvNumber: TcxGridDBBandedColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'InvNumber'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 72
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object GridWasGot_GoodsName: TcxGridDBBandedColumn
          Caption = #1044#1072#1090#1072
          DataBinding.FieldName = 'OperDate'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 0
        end
        object GridWasGot_UnitName: TcxGridDBBandedColumn
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1086#1090#1082#1091#1076#1072' '#1074#1077#1088#1085#1091#1083#1080
          DataBinding.FieldName = 'UnitName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 239
          Position.BandIndex = 0
          Position.ColIndex = 2
          Position.RowIndex = 0
        end
        object GridWasGot_ReturnRate: TcxGridDBBandedColumn
          Caption = '% '#1074#1086#1079#1074#1088#1072#1090#1072
          DataBinding.FieldName = 'ReturnRate'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.00;-,0.00; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 76
          Position.BandIndex = 0
          Position.ColIndex = 3
          Position.RowIndex = 0
        end
      end
      object GridWasGotLevel: TcxGridLevel
        GridView = GridWasGotDBBandedTableView
      end
    end
    object cxSplitter3: TcxSplitter
      Left = 432
      Top = 1
      Width = 8
      Height = 222
      HotZoneClassName = 'TcxMediaPlayer8Style'
      AlignSplitter = salRight
      Control = GridWasGot
      ExplicitLeft = 899
    end
    object GridWasSent: TcxGrid
      Left = 1
      Top = 1
      Width = 431
      Height = 222
      Align = alClient
      TabOrder = 2
      ExplicitWidth = 394
      ExplicitHeight = 197
      object GridWasSentDBBandedTableView: TcxGridDBBandedTableView
        Navigator.Buttons.CustomButtons = <>
        Navigator.Buttons.First.Visible = True
        Navigator.Buttons.PriorPage.Visible = True
        Navigator.Buttons.Prior.Visible = True
        Navigator.Buttons.Next.Visible = True
        Navigator.Buttons.NextPage.Visible = True
        Navigator.Buttons.Last.Visible = True
        Navigator.Buttons.Insert.Visible = True
        Navigator.Buttons.Append.Visible = False
        Navigator.Buttons.Delete.Visible = True
        Navigator.Buttons.Edit.Visible = True
        Navigator.Buttons.Post.Visible = True
        Navigator.Buttons.Cancel.Visible = True
        Navigator.Buttons.Refresh.Visible = True
        Navigator.Buttons.SaveBookmark.Visible = True
        Navigator.Buttons.GotoBookmark.Visible = True
        Navigator.Buttons.Filter.Visible = True
        DataController.DataSource = WasSentDS
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
        Bands = <
          item
            Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1089' '#1072#1087#1090#1077#1082#1080
            Width = 443
          end>
        object GridWasSent_InvNumber: TcxGridDBBandedColumn
          Caption = #1053#1086#1084#1077#1088
          DataBinding.FieldName = 'InvNumber'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 92
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object GridWasSent_OperDate: TcxGridDBBandedColumn
          Caption = #1044#1072#1090#1072
          DataBinding.FieldName = 'OperDate'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 87
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 0
        end
        object GridWasSent_UnitName: TcxGridDBBandedColumn
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1082#1091#1076#1072' '#1087#1077#1088#1077#1084#1077#1089#1090#1080#1083#1080
          DataBinding.FieldName = 'UnitName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 264
          Position.BandIndex = 0
          Position.ColIndex = 2
          Position.RowIndex = 0
        end
      end
      object GridWasSentLevel: TcxGridLevel
        GridView = GridWasSentDBBandedTableView
      end
    end
  end
  object cxSplitter1: TcxSplitter
    Left = 0
    Top = 256
    Width = 900
    Height = 8
    HotZoneClassName = 'TcxMediaPlayer8Style'
    AlignSplitter = salBottom
    Control = Panel3
    ExplicitTop = 200
    ExplicitWidth = 869
  end
  object InventDS: TDataSource
    DataSet = InventCDS
    Left = 240
    Top = 280
  end
  object InventCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 160
    Top = 280
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
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
    Left = 312
    Top = 208
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
    Left = 224
    Top = 208
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
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
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
    object bbToExcel: TdxBarButton
      Action = actExportToExcel
      Category = 0
    end
    object bbStaticText: TdxBarButton
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' ('#1040#1082#1090#1080#1074'/'#1055#1072#1089#1089#1080#1074')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1040#1082#1090#1080#1074'/'#1055#1072#1089#1089#1080#1074')'
      Visible = ivAlways
      ImageIndex = 3
      ShortCut = 16464
    end
    object bbPrint2: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090')'
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbcbTotal: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object bbOpenReport_AccountMotion: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1091
      Category = 0
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1091
      Visible = ivAlways
      ImageIndex = 26
    end
    object bbReport_Account: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091'>'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091'>'
      Visible = ivAlways
      ImageIndex = 25
    end
    object bbPrint3: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090') '#1089#1074#1077#1088#1085#1091#1090#1086
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090') '#1089#1074#1077#1088#1085#1091#1090#1086
      Visible = ivAlways
      ImageIndex = 18
    end
    object bbGroup: TdxBarControlContainerItem
      Caption = 'bbGroup'
      Category = 0
      Hint = 'bbGroup'
      Visible = ivAlways
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 32
    Top = 200
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
    object actExportToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_PeriodDialogForm'
      FormNameParam.Value = 'TReport_PeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpReport_LeftSend'
    DataSet = InventCDS
    DataSets = <
      item
        DataSet = InventCDS
      end
      item
        DataSet = GoodsCDS
      end
      item
        DataSet = WasSentCDS
      end
      item
        DataSet = WasGotCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inDateStart'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateFinal'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 48
    Top = 280
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 800
    Top = 8
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 400
    Top = 48
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end>
    Left = 488
    Top = 48
  end
  object GoodsDS: TDataSource
    DataSet = GoodsCDS
    Left = 240
    Top = 336
  end
  object GoodsCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'InventId'
    MasterFields = 'Id'
    MasterSource = InventDS
    PacketRecords = 0
    Params = <>
    Left = 160
    Top = 336
  end
  object WasSentDS: TDataSource
    DataSet = WasSentCDS
    Left = 408
    Top = 280
  end
  object WasSentCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'InventId'
    MasterFields = 'Id'
    MasterSource = InventDS
    PacketRecords = 0
    Params = <>
    Left = 328
    Top = 280
  end
  object WasGotDS: TDataSource
    DataSet = WasGotCDS
    Left = 408
    Top = 336
  end
  object WasGotCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'InventId'
    MasterFields = 'Id'
    MasterSource = InventDS
    PacketRecords = 0
    Params = <>
    Left = 328
    Top = 336
  end
end
