object SearchByCaptionForm: TSearchByCaptionForm
  Left = 0
  Top = 0
  Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1085#1072#1079#1074#1072#1085#1080#1103#1084
  ClientHeight = 442
  ClientWidth = 839
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object SearchByCaptionGrid: TcxGrid
    Left = 0
    Top = 51
    Width = 839
    Height = 391
    Align = alClient
    TabOrder = 1
    object SearchByCaptionGridDBTableView: TcxGridDBTableView
      OnDblClick = SearchByCaptionGridDBTableViewDblClick
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = SearchByCaptionDS
      DataController.KeyFieldNames = 'Name'
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = colCaption
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
      object colCaption: TcxGridDBColumn
        Caption = #1055#1091#1085#1082#1090' '#1084#1077#1085#1102
        DataBinding.FieldName = 'Caption'
        OnCustomDrawCell = colCaptionCustomDrawCell
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 272
      end
      object coPath: TcxGridDBColumn
        Caption = #1056#1072#1089#1087#1086#1083#1086#1078#1077#1085#1080#1077' '#1074' '#1084#1077#1085#1102
        DataBinding.FieldName = 'Path'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Width = 540
      end
    end
    object SearchByCaptionGridLevel: TcxGridLevel
      Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
      GridView = SearchByCaptionGridDBTableView
    end
  end
  object pnl1: TPanel
    Left = 0
    Top = 26
    Width = 839
    Height = 25
    Align = alTop
    TabOrder = 0
    DesignSize = (
      839
      25)
    object edt1: TEdit
      Left = 1
      Top = 1
      Width = 837
      Height = 23
      Align = alClient
      AutoSelect = False
      TabOrder = 0
      OnChange = edt1Change
      OnExit = edt1Exit
      ExplicitHeight = 21
    end
    object ProgressBar1: TProgressBar
      Left = 773
      Top = 12
      Width = 57
      Height = 9
      Anchors = [akTop, akRight]
      BarColor = clMedGray
      TabOrder = 1
      Visible = False
    end
  end
  object SearchByCaptionDS: TDataSource
    DataSet = SearchByCaptionCDS
    Left = 504
    Top = 136
  end
  object SearchByCaptionCDS: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Caption'
        DataType = ftString
        Size = 120
      end
      item
        Name = 'Path'
        DataType = ftString
        Size = 400
      end
      item
        Name = 'Name'
        DataType = ftString
        Size = 100
      end>
    IndexDefs = <>
    IndexFieldNames = 'Caption'
    Params = <>
    StoreDefs = True
    Left = 360
    Top = 136
    Data = {
      680000009619E0BD010000001800000003000000000003000000680007436170
      74696F6E01004900000001000557494454480200020078000450617468020049
      0000000100055749445448020002009001044E616D6501004900000001000557
      494454480200020064000000}
    object SearchByCaptionCDSCaption: TStringField
      FieldName = 'Caption'
      Size = 120
    end
    object SearchByCaptionCDSPath: TStringField
      FieldName = 'Path'
      Size = 400
    end
    object SearchByCaptionCDSName: TStringField
      FieldName = 'Name'
      Size = 100
    end
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
    Left = 176
    Top = 136
    DockControlHeights = (
      0
      0
      26
      0)
    object Bar: TdxBar
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
          ItemName = 'dxBarStatic'
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
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Category = 0
      Visible = ivAlways
      Left = 280
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
      Left = 208
      Top = 65528
    end
    object bbGridToExcel: TdxBarButton
      Category = 0
      Visible = ivAlways
      Left = 232
    end
    object bbOpen: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      Left = 160
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 672
    Top = 136
  end
end
