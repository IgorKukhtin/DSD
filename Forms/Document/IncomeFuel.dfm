object IncomeFuelForm: TIncomeFuelForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' ('#1047#1072#1087#1088#1072#1074#1082#1072' '#1072#1074#1090#1086')>'
  ClientHeight = 597
  ClientWidth = 879
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
    Width = 879
    Height = 133
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edInvNumber: TcxTextEdit
      Left = 8
      Top = 23
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 74
    end
    object cxLabel1: TcxLabel
      Left = 8
      Top = 5
      Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edOperDate: TcxDateEdit
      Left = 177
      Top = 23
      EditValue = 42387d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 89
    end
    object cxLabel2: TcxLabel
      Left = 177
      Top = 5
      Caption = #1044#1072#1090#1072' ('#1072#1074#1090#1086')'
    end
    object edFrom: TcxButtonEdit
      Left = 274
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 3
      Width = 172
    end
    object edTo: TcxButtonEdit
      Left = 455
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 2
      Width = 135
    end
    object cxLabel3: TcxLabel
      Left = 277
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086' ('#1048#1089#1090#1086#1095#1085#1080#1082' '#1079#1072#1087#1088#1072#1074#1082#1080')'
    end
    object cxLabel4: TcxLabel
      Left = 455
      Top = 5
      Caption = #1050#1086#1084#1091' ('#1040#1074#1090#1086#1084#1086#1073#1080#1083#1100', '#1060#1080#1079'.'#1083'.)'
    end
    object edPriceWithVAT: TcxCheckBox
      Left = 274
      Top = 63
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 130
    end
    object edVATPercent: TcxCurrencyEdit
      Left = 406
      Top = 63
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 40
    end
    object cxLabel7: TcxLabel
      Left = 406
      Top = 45
      Caption = '% '#1053#1044#1057
    end
    object cxLabel9: TcxLabel
      Left = 738
      Top = 5
      Caption = #1044#1086#1075#1086#1074#1086#1088
    end
    object edContract: TcxButtonEdit
      Left = 738
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      TabOrder = 4
      Width = 130
    end
    object cxLabel10: TcxLabel
      Left = 599
      Top = 5
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
    end
    object edPaidKind: TcxButtonEdit
      Left = 599
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 130
    end
    object cxLabel12: TcxLabel
      Left = 738
      Top = 45
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1042#1086#1076#1080#1090#1077#1083#1100')'
    end
    object edDriver: TcxButtonEdit
      Left = 738
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Width = 130
    end
    object edRoute: TcxButtonEdit
      Left = 599
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 17
      Width = 130
    end
    object cxLabel5: TcxLabel
      Left = 599
      Top = 45
      Caption = #1052#1072#1088#1096#1088#1091#1090
    end
    object cxLabel6: TcxLabel
      Left = 88
      Top = 5
      Caption = #8470' '#1095#1077#1082#1072
    end
    object edInvNumberPartner: TcxTextEdit
      Left = 88
      Top = 23
      TabOrder = 20
      Width = 84
    end
    object cxLabel8: TcxLabel
      Left = 8
      Top = 45
      Caption = #1057#1090#1072#1090#1091#1089
    end
    object cxLabel11: TcxLabel
      Left = 455
      Top = 45
      Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1094#1077#1085#1077', '#1075#1088#1085' '#1079#1072' 1'#1083'.'
    end
    object edChangePrice: TcxCurrencyEdit
      Left = 458
      Top = 63
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 3
      Properties.DisplayFormat = ',0.###'
      Properties.ReadOnly = True
      TabOrder = 23
      Width = 135
    end
    object edOperDatePartner: TcxDateEdit
      Left = 177
      Top = 63
      EditValue = 42244d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 24
      Width = 89
    end
    object cxLabel13: TcxLabel
      Left = 177
      Top = 45
      Caption = #1044#1072#1090#1072' '#1079#1072#1087#1088#1072#1074#1082#1080
    end
    object ceStatus: TcxButtonEdit
      Left = 9
      Top = 63
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
      TabOrder = 26
      Width = 163
    end
    object edLimit: TcxCurrencyEdit
      Left = 191
      Top = 106
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 3
      Properties.DisplayFormat = ',0.###'
      Properties.ReadOnly = True
      TabOrder = 27
      Width = 59
    end
    object cxLabel19: TcxLabel
      Left = 191
      Top = 88
      Caption = #1051#1080#1084#1080#1090', '#1075#1088#1085
    end
  end
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 159
    Width = 879
    Height = 438
    Align = alClient
    TabOrder = 2
    Properties.ActivePage = cxTabSheetMain
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 438
    ClientRectRight = 879
    ClientRectTop = 24
    object cxTabSheetMain: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      object cxGridChild: TcxGrid
        Left = 0
        Top = 163
        Width = 879
        Height = 251
        Align = alBottom
        TabOrder = 0
        object cxGridDBTableViewChild: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmount
            end
            item
              Kind = skSum
              Column = clOperDate
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clDistance_calc
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clDistance_calc
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Appending = True
          OptionsData.DeletingConfirmation = False
          OptionsView.CellAutoHeight = True
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object colLineNum: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'LineNum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object clDayOfWeekName: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080
            DataBinding.FieldName = 'DayOfWeekName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object clOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object clRouteMemberCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'RouteMemberCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 49
          end
          object clRouteMemberName: TcxGridDBColumn
            Caption = #1052#1072#1088#1096#1088#1091#1090' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074')'
            DataBinding.FieldName = 'RouteMemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 208
          end
          object clStartOdometre: TcxGridDBColumn
            Caption = #1057#1087#1080#1076#1086#1084#1077#1090#1088' '#1085#1072#1095'. '#1087#1086#1082#1072#1079#1072#1085#1080#1077', '#1082#1084
            DataBinding.FieldName = 'StartOdometre'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 129
          end
          object clEndOdometre: TcxGridDBColumn
            Caption = #1057#1087#1080#1076#1086#1084#1077#1090#1088' '#1082#1086#1085#1077#1095'. '#1087#1086#1082#1072#1079#1072#1085#1080#1077', '#1082#1084
            DataBinding.FieldName = 'EndOdometre'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0;;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 128
          end
          object clDistance_calc: TcxGridDBColumn
            Caption = #1055#1088#1086#1073#1077#1075' '#1092#1072#1082#1090', '#1082#1084
            DataBinding.FieldName = 'Distance_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object clAmount: TcxGridDBColumn
            Caption = #1047#1072#1087#1088#1072#1074#1082#1072', '#1083
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 106
          end
        end
        object cxGridLevelChild: TcxGridLevel
          GridView = cxGridDBTableViewChild
        end
      end
      object cxSplitterChild: TcxSplitter
        Left = 0
        Top = 155
        Width = 879
        Height = 8
        AlignSplitter = salBottom
        Control = cxGridChild
      end
      object cxGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 879
        Height = 155
        Align = alClient
        TabOrder = 2
        object cxGridDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountSumm
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountSumm
            end
            item
              Kind = skSum
              Column = colPrice
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object colName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object colFuelName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1087#1083#1080#1074#1072
            DataBinding.FieldName = 'FuelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object colMeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colCountForPrice: TcxGridDBColumn
            Caption = #1050#1086#1083' '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0;;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object colAmountSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object colIsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
        end
        object cxGridLevel: TcxGridLevel
          GridView = cxGridDBTableView
        end
      end
    end
  end
  object cxLabel14: TcxLabel
    Left = 556
    Top = 88
    Caption = #1057#1087#1080#1076#1086#1084#1077#1090#1088' '#1085#1072#1095'. '#1082#1084
  end
  object edStartOdometre: TcxCurrencyEdit
    Left = 556
    Top = 106
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 100
  end
  object cxLabel15: TcxLabel
    Left = 662
    Top = 88
    Caption = #1057#1087#1080#1076#1086#1084#1077#1090#1088' '#1082#1086#1085'. '#1082#1084
  end
  object edEndOdometre: TcxCurrencyEdit
    Left = 662
    Top = 106
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 100
  end
  object cxLabel16: TcxLabel
    Left = 9
    Top = 88
    Caption = #1053#1086#1088#1084#1072' '#1072#1074#1090#1086
  end
  object edAmountFuel: TcxCurrencyEdit
    Left = 9
    Top = 106
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 62
  end
  object edReparation: TcxCurrencyEdit
    Left = 79
    Top = 106
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 105
  end
  object cxLabel17: TcxLabel
    Left = 79
    Top = 88
    Caption = #1040#1084#1086#1088#1090'. '#1079#1072' 1 '#1082#1084', '#1075#1088#1085'.'
  end
  object edLimitDistance: TcxCurrencyEdit
    Left = 356
    Top = 106
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 74
  end
  object cxLabel20: TcxLabel
    Left = 356
    Top = 88
    Caption = #1051#1080#1084#1080#1090', '#1082#1084
  end
  object edLimitChange: TcxCurrencyEdit
    Left = 256
    Top = 106
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = False
    TabOrder = 13
    Width = 94
  end
  object cxLabel21: TcxLabel
    Left = 256
    Top = 88
    Caption = #1051#1080#1084#1080#1090' ('#1089#1083#1091#1078'.) '#1075#1088#1085
  end
  object edLimitDistanceChange: TcxCurrencyEdit
    Left = 437
    Top = 106
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    TabOrder = 15
    Width = 109
  end
  object cxLabel22: TcxLabel
    Left = 437
    Top = 88
    Caption = #1051#1080#1084#1080#1090' ('#1089#1083#1091#1078'.) '#1082#1084
  end
  object edDistanceDiff: TcxCurrencyEdit
    Left = 768
    Top = 106
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 3
    Properties.DisplayFormat = ',0.###'
    Properties.ReadOnly = True
    TabOrder = 20
    Width = 100
  end
  object cxLabel23: TcxLabel
    Left = 768
    Top = 88
    Caption = #1055#1088#1086#1073#1077#1075' '#1080#1090#1086#1075#1086', '#1082#1084
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
      end
      item
        Name = 'inPaidKindId'
        Value = '0'
        ParamType = ptInput
      end>
    Left = 160
    Top = 311
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_IncomeFuel'
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
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = FormParams
        ComponentItem = 'ShowAll'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 92
    Top = 272
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
    Left = 19
    Top = 217
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
          ItemName = 'bbStatic'
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
          ItemName = 'bbInsertRecordChild'
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
          ItemName = 'bbMIContainer'
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
    object bbInsertRecordChild: TdxBarButton
      Action = InsertRecordChild
      Category = 0
    end
    object bbSetErasedChild: TdxBarButton
      Action = SetErasedChild
      Category = 0
    end
    object bbSetUnErasedChild: TdxBarButton
      Action = SetUnErasedChild
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
    Left = 78
    Top = 219
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 49
    Top = 217
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
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
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
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <>
      Params = <
        item
          Name = 'InvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'From'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'OperDate'
          Value = 0d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
        end>
      ReportName = #1055#1088#1080#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = ''
      ReportNameParam.DataType = ftString
    end
    object GridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
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
      Category = 'DSDLib'
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
      Category = 'DSDLib'
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
      Category = 'DSDLib'
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
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
        end>
      isShowModal = False
    end
    object RouteMemberChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'RouteMemberForm'
      FormName = 'TRouteMemberForm'
      FormNameParam.Value = 'TRouteMemberForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'RouteMemberId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'RouteMemberName'
          DataType = ftWideString
        end
        item
          Name = 'Code'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'RouteMemberCode'
        end>
      isShowModal = True
    end
    object InsertRecordChild: TInsertRecord
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewChild
      Action = RouteMemberChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1052#1072#1088#1096#1088#1091#1090'('#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072')>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1052#1072#1088#1096#1088#1091#1090'('#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072')>'
      ShortCut = 45
      ImageIndex = 0
    end
    object SetErasedChild: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spErasedMIChild
      StoredProcList = <
        item
          StoredProc = spErasedMIChild
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1052#1072#1088#1096#1088#1091#1090'('#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072')>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1052#1072#1088#1096#1088#1091#1090'('#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072')>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ChildDS
    end
    object SetUnErasedChild: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      MoveParams = <>
      StoredProc = spUnErasedMIChild
      StoredProcList = <
        item
          StoredProc = spUnErasedMIChild
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ChildDS
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
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spSelectMIChild
        end>
      Caption = 'actUpdateChildDS'
      DataSource = ChildDS
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 48
    Top = 272
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 16
    Top = 272
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TSourceFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TSourceFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ContractId'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        ParamType = ptInput
      end
      item
        Name = 'ChangePrice'
        Value = 0.000000000000000000
        Component = edChangePrice
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
      end>
    Left = 336
    Top = 32
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TMember_TrasportChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.ParamType = ptInputOutput
    FormName = 'TMember_TrasportChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInputOutput
      end
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'AmountFuel'
        Value = Null
        Component = edAmountFuel
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'Reparation'
        Value = Null
        Component = edReparation
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'LimitMoney'
        Value = Null
        Component = edLimit
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'LimitDistance'
        Value = Null
        Component = edLimitDistance
        DataType = ftFloat
        ParamType = ptInput
      end>
    Left = 416
    Top = 24
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 216
    Top = 279
    object N1: TMenuItem
      Action = actRefresh
    end
  end
  object spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_IncomeFuel'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'ioCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'outAmountSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSumm'
        DataType = ftFloat
      end>
    PackSize = 1
    Left = 134
    Top = 272
  end
  object MasterViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        DataSummaryItemIndex = 2
      end>
    Left = 192
    Top = 183
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 108
    Top = 218
  end
  object spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_IncomeMemberFuel'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inOperDatePartner'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inInvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inPriceWithVAT'
        Value = 'False'
        Component = edPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inVATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inChangePrice'
        Value = 0.000000000000000000
        Component = edChangePrice
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inStartOdometre'
        Value = Null
        Component = edStartOdometre
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inEndOdometre'
        Value = Null
        Component = edEndOdometre
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inAmountFuel'
        Value = Null
        Component = edAmountFuel
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inReparation'
        Value = Null
        Component = edReparation
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inLimit'
        Value = Null
        Component = edLimit
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inLimitDistance'
        Value = Null
        Component = edLimitDistance
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inLimitChange'
        Value = Null
        Component = edLimitChange
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inLimitDistanceChange'
        Value = Null
        Component = edLimitDistanceChange
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inContractId'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inRouteId'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPersonalDriverId'
        Value = ''
        Component = GuidesPersonalDriver
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 378
    Top = 232
  end
  object HeaderSaver: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    StoredProc = spInsertUpdateMovement
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edInvNumberPartner
      end
      item
        Control = edOperDate
      end
      item
        Control = edOperDatePartner
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = edPriceWithVAT
      end
      item
        Control = edVATPercent
      end
      item
        Control = edChangePrice
      end
      item
        Control = edPaidKind
      end
      item
        Control = edContract
      end
      item
        Control = edRoute
      end
      item
        Control = edDriver
      end
      item
        Control = edAmountFuel
      end
      item
        Control = edReparation
      end
      item
        Control = edLimit
      end
      item
        Control = edLimitChange
      end
      item
        Control = edLimitDistance
      end
      item
        Control = edLimitDistanceChange
      end
      item
        Control = edEndOdometre
      end
      item
        Control = edStartOdometre
      end
      item
        Control = edDistanceDiff
      end>
    GetStoredProc = spGet
    Left = 296
    Top = 252
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_IncomeFuel'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
      end
      item
        Name = 'OperDatePartner'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
      end
      item
        Name = 'InvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
      end
      item
        Name = 'ToParentId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'ParentId'
        DataType = ftString
      end
      item
        Name = 'PriceWithVAT'
        Value = 'False'
        Component = edPriceWithVAT
        DataType = ftBoolean
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
      end
      item
        Name = 'ChangePrice'
        Value = 0.000000000000000000
        Component = edChangePrice
        DataType = ftFloat
      end
      item
        Name = 'ContractId'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
      end
      item
        Name = 'ContarctName'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PersonalDriverId'
        Value = ''
        Component = GuidesPersonalDriver
        ComponentItem = 'Key'
      end
      item
        Name = 'PersonalDriverName'
        Value = ''
        Component = GuidesPersonalDriver
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'RouteId'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'Key'
      end
      item
        Name = 'RouteName'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'AmountFuel'
        Value = Null
        Component = edAmountFuel
        DataType = ftFloat
      end
      item
        Name = 'Reparation'
        Value = Null
        Component = edReparation
        DataType = ftFloat
      end
      item
        Name = 'LimitMoney'
        Value = Null
        Component = edLimit
        DataType = ftFloat
      end
      item
        Name = 'LimitChange'
        Value = Null
        Component = edLimitChange
        DataType = ftFloat
      end
      item
        Name = 'LimitDistance'
        Value = Null
        Component = edLimitDistance
        DataType = ftFloat
      end
      item
        Name = 'LimitDistanceChange'
        Value = Null
        Component = edLimitDistanceChange
        DataType = ftFloat
      end
      item
        Name = 'StartOdometre'
        Value = Null
        Component = edStartOdometre
        DataType = ftFloat
      end
      item
        Name = 'EndOdometre'
        Value = Null
        Component = edEndOdometre
        DataType = ftFloat
      end
      item
        Name = 'DistanceDiff'
        Value = Null
        Component = edDistanceDiff
        DataType = ftFloat
      end>
    PackSize = 1
    Left = 216
    Top = 221
  end
  object RefreshAddOn: TRefreshAddOn
    DataSet = 'ClientDataSet'
    KeyField = 'Id'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 432
    Top = 247
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end>
    Left = 248
    Top = 237
  end
  object GuidesContract: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'inPaidKindId'
      end>
    Left = 640
    Top = 40
  end
  object GuidesPaidKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
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
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 736
    Top = 40
  end
  object GuidesPersonalDriver: TdsdGuides
    KeyField = 'Id'
    LookupControl = edDriver
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalDriver
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalDriver
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 560
    Top = 40
  end
  object GuidesRoute: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRoute
    FormNameParam.Value = 'TRouteForm'
    FormNameParam.DataType = ftString
    FormName = 'TRouteForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 487
    Top = 37
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpSetErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
      end>
    PackSize = 1
    Left = 510
    Top = 212
  end
  object spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpSetUnErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
      end>
    PackSize = 1
    Left = 574
    Top = 228
  end
  object StatusGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatus
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 31
    Top = 41
  end
  object spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Income'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inStatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 71
    Top = 41
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
      end
      item
        Name = 'TotalSumm'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSumm'
        DataType = ftString
      end>
    PackSize = 1
    Left = 444
    Top = 188
  end
  object ChildViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewChild
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 288
    Top = 431
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 32
    Top = 408
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 84
    Top = 438
  end
  object spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_IncomeFuel_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = ChildCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inRouteMemberName'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'RouteMemberName'
        DataType = ftWideString
        ParamType = ptInput
      end
      item
        Name = 'inStartOdometre'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'StartOdometre'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inEndOdometre'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'EndOdometre'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'outDistance_calc'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Distance_calc'
        DataType = ftFloat
      end
      item
        Name = 'outStartOdometre_calc'
        Value = Null
        Component = edStartOdometre
        DataType = ftFloat
      end
      item
        Name = 'outEndOdometre_calc'
        Value = Null
        Component = edEndOdometre
        DataType = ftFloat
      end
      item
        Name = 'outDistanceDiff'
        Value = Null
        Component = edDistanceDiff
        DataType = ftFloat
      end>
    PackSize = 1
    Left = 186
    Top = 445
  end
  object spSelectMIChild: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_IncomeFuel_Child'
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
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 556
    Top = 440
  end
  object spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpSetErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
      end>
    PackSize = 1
    Left = 366
    Top = 396
  end
  object spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpSetUnErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
      end>
    PackSize = 1
    Left = 494
    Top = 388
  end
end
