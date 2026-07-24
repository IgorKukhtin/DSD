object SaleCommercForm: TSaleCommercForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077' '#1055#1088#1086#1076#1072#1078' ('#1082#1086#1084#1084#1077#1088#1094#1080#1103')>'
  ClientHeight = 458
  ClientWidth = 985
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object DataPanel: TPanel
    Left = 0
    Top = 0
    Width = 985
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edInvNumber: TcxTextEdit
      Left = 177
      Top = 23
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 157
    end
    object cxLabel1: TcxLabel
      Left = 177
      Top = 5
      Caption = #8470' '#1076#1086#1082'.'
    end
    object edOperDate: TcxDateEdit
      Left = 339
      Top = 23
      EditValue = 42160d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 94
    end
    object cxLabel2: TcxLabel
      Left = 339
      Top = 5
      Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
    end
    object cxLabel11: TcxLabel
      Left = 8
      Top = 5
      Caption = #1057#1090#1072#1090#1091#1089
    end
    object ceStatus: TcxButtonEdit
      Left = 8
      Top = 22
      Properties.Buttons = <
        item
          Action = CompleteMovement
          Kind = bkGlyph
        end
        item
          Action = UnCompleteMovement
          Default = True
          Kind = bkGlyph
        end
        item
          Action = DeleteMovement
          Kind = bkGlyph
        end>
      Properties.Images = dmMain.ImageList
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 157
    end
  end
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 76
    Width = 985
    Height = 175
    Align = alClient
    TabOrder = 1
    Properties.ActivePage = cxTabSheetMain
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 175
    ClientRectRight = 985
    ClientRectTop = 24
    object cxTabSheetMain: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      object cxGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 985
        Height = 151
        Align = alClient
        TabOrder = 0
        object cxGridDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Sorted = True
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
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object BranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object ContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075#1086#1074#1086#1088#1072
            DataBinding.FieldName = 'ContractCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object ContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actContractChoicePartnerForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 200
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPaidKindChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 130
          end
          object PartnerCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
            DataBinding.FieldName = 'PartnerCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 93
          end
          object PartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPartner_ObjectForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 191
          end
          object IsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
        object cxGridLevel: TcxGridLevel
          GridView = cxGridDBTableView
        end
      end
    end
  end
  object cxSplitter1: TcxSplitter
    Left = 0
    Top = 251
    Width = 985
    Height = 5
    AlignSplitter = salBottom
    Control = cxGrid1
  end
  object cxGrid1: TcxGrid
    Left = 0
    Top = 256
    Width = 985
    Height = 202
    Align = alBottom
    PopupMenu = PopupMenu
    TabOrder = 7
    object cxGridDBTableView1: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ChildDS
      DataController.Filter.Options = [fcoCaseInsensitive]
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
          Column = chAmount
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
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = chAmountPromo
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = chAmountNoPromo
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = chSumm
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
          Format = ',0.####'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = chAmount
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
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = chAmountPromo
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = chAmountNoPromo
        end
        item
          Format = ',0.####'
          Kind = skSum
          Column = chSumm
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object chGoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object chGoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 200
      end
      object chGoodsKindName: TcxGridDBColumn
        Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsKindName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object chAmount: TcxGridDBColumn
        Caption = #1042#1110#1076#1074#1072#1085#1090#1072#1078#1077#1085#1085#1103', '#1050#1110#1083'-'#1089#1090#1100' - '#1055#1051#1040#1053' ('#1079#1072#1075#1072#1083#1100#1085#1080#1081')'
        DataBinding.FieldName = 'Amount'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object chSumm: TcxGridDBColumn
        Caption = #1042#1110#1076#1074#1072#1085#1090#1072#1078#1077#1085#1085#1103', '#1075#1088#1085' - '#1055#1051#1040#1053' ('#1079#1072#1075#1072#1083#1100#1085#1080#1081')'
        DataBinding.FieldName = 'Summ'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object chBonus: TcxGridDBColumn
        Caption = #1042#1110#1076#1074#1072#1085#1090#1072#1078#1077#1085#1085#1103', '#1075#1088#1085' - '#1055#1051#1040#1053' ('#1079#1072#1075#1072#1083#1100#1085#1080#1081')'
        DataBinding.FieldName = 'Bonus'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object chPrice: TcxGridDBColumn
        Caption = #1042#1110#1076#1074#1072#1085#1090#1072#1078#1077#1085#1085#1103', '#1075#1088#1085' - '#1055#1051#1040#1053' ('#1079#1072#1075#1072#1083#1100#1085#1080#1081')'
        DataBinding.FieldName = 'Price'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 80
      end
      object chAmountPromo: TcxGridDBColumn
        Caption = #1042#1110#1076#1074#1072#1085#1090#1072#1078#1077#1085#1085#1103', '#1050#1110#1083'-'#1089#1090#1100' - '#1055#1051#1040#1053' ('#1072#1082#1094#1110#1081#1085#1080#1081')'
        DataBinding.FieldName = 'AmountPromo'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object chSummPromo: TcxGridDBColumn
        Caption = #1042#1110#1076#1074#1072#1085#1090#1072#1078#1077#1085#1085#1103', '#1075#1088#1085' - '#1055#1051#1040#1053' ('#1072#1082#1094#1110#1081#1085#1080#1081')'
        DataBinding.FieldName = 'SummPromo'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object chAmountNoPromo: TcxGridDBColumn
        Caption = #1042#1110#1076#1074#1072#1085#1090#1072#1078#1077#1085#1085#1103', '#1050#1110#1083'-'#1089#1090#1100' - '#1055#1051#1040#1053' ('#1073#1077#1079' '#1072#1082#1094#1110#1081#1085#1080#1081')'
        DataBinding.FieldName = 'AmountNoPromo'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object chSummNoPromo: TcxGridDBColumn
        Caption = #1042#1110#1076#1074#1072#1085#1090#1072#1078#1077#1085#1085#1103', '#1075#1088#1085' - '#1055#1051#1040#1053' ('#1073#1077#1079' '#1072#1082#1094#1110#1081#1085#1080#1081')'
        DataBinding.FieldName = 'SummNoPromo'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
      object chisErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
        DataBinding.FieldName = 'isErased'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 60
      end
    end
    object cxGridLevel1: TcxGridLevel
      GridView = cxGridDBTableView1
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 14
    Top = 375
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_SaleCommerc'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 200
    Top = 143
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
    Left = 22
    Top = 295
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar: TdxBar
      AllowClose = False
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 51
      FloatClientHeight = 71
      ItemLinks = <
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
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
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
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedChild'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedChild'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
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
    object bbStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
    object bbInsertUpdateMovement: TdxBarButton
      Action = actInsertUpdateMovement
      Category = 0
    end
    object bbShowErased: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbGridToExel: TdxBarButton
      Action = GridToExcel
      Category = 0
    end
    object bbErased: TdxBarButton
      Action = SetErased
      Category = 0
    end
    object bbUnErased: TdxBarButton
      Action = SetUnErased
      Category = 0
    end
    object bbMIContainer: TdxBarButton
      Action = actMIContainer
      Category = 0
    end
    object bbMovementItemProtocol: TdxBarButton
      Action = MovementItemProtocolOpenForm
      Category = 0
    end
    object bbCalcAmountPartner: TdxBarControlContainerItem
      Caption = #1040#1074#1090#1086' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1077'  <'#1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1089#1090'.>'
      Category = 0
      Hint = #1040#1074#1090#1086' '#1079#1072#1087#1086#1083#1085#1077#1085#1080#1077'  <'#1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1089#1090'.>'
      Visible = ivAlways
    end
    object bbAddMask: TdxBarButton
      Action = actAddMask
      Category = 0
    end
    object bbInsertRecord: TdxBarButton
      Action = actInsertRecord
      Category = 0
    end
    object bbCompleteCost: TdxBarButton
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Category = 0
      Enabled = False
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Visible = ivNever
      ImageIndex = 12
    end
    object bbactUnCompleteCost: TdxBarButton
      Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Category = 0
      Enabled = False
      Hint = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Visible = ivNever
      ImageIndex = 11
    end
    object bbactSetErasedCost: TdxBarButton
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Category = 0
      Enabled = False
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1090#1088#1072#1090#1099
      Visible = ivNever
      ImageIndex = 13
    end
    object bbShowErasedCost: TdxBarButton
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Category = 0
      Enabled = False
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Visible = ivAlways
      ImageIndex = 64
    end
    object bbInsertRecordChild: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1083#1072#1085' '#1086#1087#1083#1072#1090'>'
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1083#1072#1085' '#1086#1087#1083#1072#1090'>'
      Visible = ivAlways
      ImageIndex = 0
    end
    object bbSetErasedChild: TdxBarButton
      Action = SetErasedChild
      Category = 0
    end
    object bbSetUnErasedChild: TdxBarButton
      Action = SetUnErasedChild
      Category = 0
    end
    object bbUpdateAsset_toGoods: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1057
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1054#1057
      Visible = ivAlways
      ImageIndex = 28
    end
    object bb: TdxBarButton
      Action = actShowErasedChild
      Category = 0
    end
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
    Left = 81
    Top = 304
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 51
    Top = 295
    object actInsertUpdateMovement: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMovement
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 14
      ShortCut = 113
    end
    object actShowErasedChild: TBooleanStoredProcAction
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spSelectMIChild
      StoredProcList = <
        item
          StoredProc = spSelectMIChild
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectMIChild
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actUpdateChildDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = 'actUpdateMasterDS'
      DataSource = ChildDS
    end
    object actUpdateMasterDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIMaster
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelectMIChild
        end>
      Caption = 'actUpdateMasterDS'
      DataSource = MasterDS
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectMIChild
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
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
          Name = 'InvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'From'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 0d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_EntryAsset'
      ReportNameParam.Value = 'PrintMovement_EntryAsset'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object GridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object SetErasedChild: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIChild
      StoredProcList = <
        item
          StoredProc = spErasedMIChild
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1087#1086#1076#1095#1080#1085#1077#1085#1085#1099#1081' '#1101#1083#1077#1084#1077#1085#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1087#1086#1076#1095#1080#1085#1077#1085#1085#1099#1081' '#1101#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ChildDS
    end
    object SetErased: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object SetUnErasedChild: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spUnErasedMIChild
      StoredProcList = <
        item
          StoredProc = spUnErasedMIChild
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ChildDS
    end
    object SetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spUnErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object UnCompleteMovement: TChangeGuidesStatus
      Category = 'Complete'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 11
      Status = mtUncomplete
      Guides = StatusGuides
    end
    object CompleteMovement: TChangeGuidesStatus
      Category = 'Complete'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      Guides = StatusGuides
    end
    object DeleteMovement: TChangeGuidesStatus
      Category = 'Complete'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end
        item
        end>
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      Hint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      ImageIndex = 13
      Status = mtDelete
      Guides = StatusGuides
    end
    object actMIContainer: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1074#1086#1076#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1074#1086#1076#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 57
      FormName = 'TMovementItemContainerForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object MovementItemProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
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
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actInsertRecordChild: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView1
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1083#1072#1085' '#1086#1087#1083#1072#1090'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1083#1072#1085' '#1086#1087#1083#1072#1090'>'
      ImageIndex = 0
    end
    object actInsertRecord: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actContractChoicePartnerForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ShortCut = 45
      ImageIndex = 0
    end
    object actContractChoicePartnerForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContractChoicePartnerForm'
      FormName = 'TContractChoicePartnerForm'
      FormNameParam.Value = 'TContractChoicePartnerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BranchName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BranchId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actBranch_ObjectForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Branch_ObjectForm'
      FormName = 'TBranch_ObjectForm'
      FormNameParam.Value = 'TBranch_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BranchId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BranchName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPartner_ObjectForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Partner_ObjectForm'
      FormName = 'TPartner_ObjectForm'
      FormNameParam.Value = 'TPartner_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPaidKindChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PaidKindForm'
      FormName = 'TPaidKindForm'
      FormNameParam.Value = 'TPaidKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actAddMask: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertMaskMIMaster
      StoredProcList = <
        item
          StoredProc = spInsertMaskMIMaster
        end
        item
          StoredProc = spSelectMI
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      ImageIndex = 54
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 110
    Top = 367
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 24
    Top = 343
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 672
    Top = 8
    object N1: TMenuItem
      Action = actRefresh
    end
  end
  object spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_SaleCommerc'
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
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BranchId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartnerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PaidKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 110
    Top = 143
  end
  object MasterViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 4
      end>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 435
    Top = 153
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 238
    Top = 287
  end
  object spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_EntryAsset'
    DataSets = <>
    OutputType = otResult
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
      end>
    PackSize = 1
    Left = 746
    Top = 8
  end
  object HeaderSaver: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spInsertUpdateMovement
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
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
      end
      item
      end>
    GetStoredProc = spGet
    Left = 520
    Top = 17
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_EntryAsset'
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 824
    Top = 8
  end
  object RefreshAddOn: TRefreshAddOn
    DataSet = 'ClientDataSet'
    KeyField = 'Id'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 142
    Top = 306
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <
      item
      end
      item
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end>
    Left = 456
    Top = 8
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_SaleCommerc_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 350
    Top = 176
  end
  object spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_SaleCommerc_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 278
    Top = 152
  end
  object StatusGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatus
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 39
    Top = 8
  end
  object spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_EntryAsset'
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
        Name = 'inStatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 116
  end
  object spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TotalSumm'
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
        Name = 'TotalSumm'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSumm'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 596
    Top = 4
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 556
    Top = 153
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 604
    Top = 150
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_SaleCommerc_Print'
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
    Left = 663
    Top = 144
  end
  object spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_SaleCommerc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = 0
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
        Name = 'ioAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPartner'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPacker'
        Value = 0.000000000000000000
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsCalcAmountPartner'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLiveWeight'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHeadCount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAssetId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AssetId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 30
    Top = 167
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 360
    Top = 344
  end
  object DBViewChildAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorColumn = chSummNoPromo
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 406
    Top = 289
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 296
    Top = 352
  end
  object spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_SaleCommerc_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ChildCDS
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
        Name = 'inParentId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSumm'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Summ'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPromo'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountPromo'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummPromo'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'SummPromo'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountNoPromo'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountNoPromo'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummNoPromo'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'SummNoPromo'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBonus'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Bonus'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 412
    Top = 352
  end
  object spSelectMIChild: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_SaleCommerc_Child'
    DataSet = ChildCDS
    DataSets = <
      item
        DataSet = ChildCDS
      end>
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 343
  end
  object spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_SaleCommercChild_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 494
    Top = 328
  end
  object spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_SaleCommercChild_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 590
    Top = 336
  end
end
