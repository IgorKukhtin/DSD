object SendDebtForm: TSendDebtForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1042#1079#1072#1080#1084#1086#1079#1072#1095#1077#1090' ('#1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1077' '#1083#1080#1094#1072')>'
  ClientHeight = 396
  ClientWidth = 1002
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
    Width = 1002
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object edInvNumber: TcxTextEdit
      Left = 170
      Top = 23
      Enabled = False
      Properties.ReadOnly = True
      TabOrder = 0
      Text = '0'
      Width = 90
    end
    object cxLabel1: TcxLabel
      Left = 170
      Top = 5
      Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edOperDate: TcxDateEdit
      Left = 270
      Top = 23
      EditValue = 0d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 100
    end
    object cxLabel2: TcxLabel
      Left = 270
      Top = 5
      Caption = #1044#1072#1090#1072
    end
    object edJuridicalBasis: TcxButtonEdit
      Left = 380
      Top = 23
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 180
    end
    object cxLabel3: TcxLabel
      Left = 380
      Top = 5
      Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
    end
    object cxLabel4: TcxLabel
      Left = 8
      Top = 5
      Caption = #1057#1090#1072#1090#1091#1089
    end
    object ceStatus: TcxButtonEdit
      Left = 8
      Top = 23
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
      TabOrder = 7
      Width = 152
    end
    object cxLabel5: TcxLabel
      Left = 570
      Top = 5
      Caption = #1041#1080#1079#1085#1077#1089
    end
    object edBusiness: TcxButtonEdit
      Left = 570
      Top = 23
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 150
    end
  end
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 86
    Width = 1002
    Height = 310
    Align = alClient
    TabOrder = 2
    Properties.ActivePage = cxTabSheetMain
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 310
    ClientRectRight = 1002
    ClientRectTop = 24
    object cxTabSheetMain: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      ImageIndex = 0
      object cxGrid: TcxGrid
        Left = 0
        Top = 0
        Width = 1002
        Height = 286
        Align = alClient
        TabOrder = 0
        object cxGridDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.###;-,0.###; ;'
              Kind = skSum
            end
            item
              Format = ',0.###;-,0.###; ;'
              Kind = skSum
            end
            item
              Format = ',0.###;-,0.###; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountDebet
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountKredit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSummKredit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSummDebet
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skSum
            end
            item
              Format = ',0.###;-,0.###; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountDebet
            end
            item
              Format = ',0.###;-,0.###; ;'
              Kind = skSum
            end
            item
              Format = ',0.###;-,0.###; ;'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountKredit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSummKredit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSummDebet
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
          object clJuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'JuridicalCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
          object clJuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ContractChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 101
          end
          object clOKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object clPaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object clContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ContractChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object clInfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object clInfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clInfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clInfoMoneyName: TcxGridDBColumn
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
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object clUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object clIsCalculated: TcxGridDBColumn
            Caption = #1087#1086' '#1076#1086#1083#1075#1091' ('#1076#1072'/'#1085#1077#1090') '
            DataBinding.FieldName = 'isCalculated'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object clSummDebet: TcxGridDBColumn
            Caption = #1044#1077#1073#1077#1090' '#1076#1086#1083#1075' '#1085#1072' '#1076#1072#1090#1091
            DataBinding.FieldName = 'SummDebet'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clSummKredit: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090' '#1076#1086#1083#1075' '#1085#1072' '#1076#1072#1090#1091
            DataBinding.FieldName = 'SummKredit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clAmountDebet: TcxGridDBColumn
            Caption = #1044#1077#1073#1077#1090' '#1089#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountDebet'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.UseDisplayFormatWhenEditing = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clAmountKredit: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090' '#1089#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountKredit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clIsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
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
    end
    object cxTabSheetEntry: TcxTabSheet
      Caption = #1055#1088#1086#1074#1086#1076#1082#1080
      ImageIndex = 1
      object cxGridEntry: TcxGrid
        Left = 0
        Top = 0
        Width = 1002
        Height = 286
        Align = alClient
        TabOrder = 0
        object cxGridEntryDBTableView: TcxGridDBTableView
          PopupMenu = PopupMenu
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = EntryDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colKreditAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colDebetAmount
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object clOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colAccountCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1089#1095#1077#1090#1072
            DataBinding.FieldName = 'AccountCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colDebetAccountGroupName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1044' '#1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'DebetAccountGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object colDebetAccountDirectionName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1044' '#1053#1072#1087#1088#1072#1074#1083
            DataBinding.FieldName = 'DebetAccountDirectionName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object colDebetAccountName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1044#1077#1073#1077#1090
            DataBinding.FieldName = 'DebetAccountName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object colKreditAccountGroupName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1050' '#1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'KreditAccountGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colKreditAccountDirectionName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1050' '#1053#1072#1087#1088#1072#1074#1083
            DataBinding.FieldName = 'KreditAccountDirectionName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colKreditAccountName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' '#1050#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'KreditAccountName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object colDirectionObjectCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1086#1073'.'#1085#1072#1087#1088'.'
            DataBinding.FieldName = 'DirectionObjectCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object colDirectionObjectName: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'DirectionObjectName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
          end
          object colDestinationObjectCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1086#1073'.'#1085#1072#1079#1085'.'
            DataBinding.FieldName = 'DestinationObjectCode'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object colDestinationObjectName: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1082#1090' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'DestinationObjectName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colBusinessCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1073#1080#1079#1085#1077#1089#1072
            DataBinding.FieldName = 'BusinessCode'
            Visible = False
            Options.Editing = False
            Width = 45
          end
          object colBusinessName: TcxGridDBColumn
            Caption = #1041#1080#1079#1085#1077#1089
            DataBinding.FieldName = 'BusinessName'
            Options.Editing = False
            Width = 70
          end
          object colAccountOnComplete: TcxGridDBColumn
            Caption = '***'
            DataBinding.FieldName = 'AccountOnComplete'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 20
          end
          object colDebetAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1076#1077#1073#1077#1090
            DataBinding.FieldName = 'DebetAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colKreditAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1082#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'KreditAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.Nullable = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colInfoMoneyName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 93
          end
          object colInfoMoneyName_Detail: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1103' '#1076#1077#1090#1072#1083#1100#1085#1086
            DataBinding.FieldName = 'InfoMoneyName_Detail'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
        object cxGridEntryLevel: TcxGridLevel
          GridView = cxGridEntryDBTableView
        end
      end
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end>
    Left = 240
    Top = 304
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_LossDebt'
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
        Component = actShowAll
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
    Left = 116
    Top = 224
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
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
    Left = 24
    Top = 168
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
      FloatLeft = 520
      FloatTop = 277
      FloatClientWidth = 51
      FloatClientHeight = 163
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
          ItemName = 'bbInsert'
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
        end
        item
          Visible = True
          ItemName = 'bbEntryToGrid'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
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
    object bbStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbGridToExel: TdxBarButton
      Action = GridToExcel
      Category = 0
    end
    object bbEntryToGrid: TdxBarButton
      Action = EntryToExcel
      Category = 0
    end
    object bbInsert: TdxBarButton
      Action = InsertRecord
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
    Left = 88
    Top = 168
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 56
    Top = 168
    object actInsertUpdateMovement: TdsdExecStoredProc
      Category = 'DSDLib'
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
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
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
      StoredProc = spInsertUpdateMIMaster
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end>
      Caption = 'actUpdateMasterDS'
      DataSource = MasterDS
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelectMI
        end
        item
          StoredProc = spSelectMIContainer
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      Params = <
        item
          Name = 'InvNumber'
          Value = '0'
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'From'
          Value = ''
          Component = GuidesJuridicalBasis
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
    end
    object GridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object EntryToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      TabSheet = cxTabSheetEntry
      Grid = cxGridEntry
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object InsertRecord: TInsertRecord
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      View = cxGridDBTableView
      Action = ContractChoiceForm
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086'>'
      ShortCut = 45
      ImageIndex = 0
    end
    object SetErased: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1044#1086#1075#1086#1074#1086#1088'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1044#1086#1075#1086#1074#1086#1088'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object SetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      TabSheet = cxTabSheetMain
      StoredProc = spUnErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object InfoMoneyChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      FormName = 'TInfoMoneyForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object ContractChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      FormName = 'TContractChoiceForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'ContractName'
          DataType = ftString
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'JuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyId'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'InfoMoneyName'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object CarChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      FormName = 'TCarForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'CarId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'CarName'
          DataType = ftString
        end
        item
          Name = 'CarModelName'
          Component = MasterCDS
          ComponentItem = 'CarModelName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object RouteChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      FormName = 'TRouteForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'RouteId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'RouteName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object UnCompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
          StoredProc = spSelectMIContainer
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 11
      Status = mtUncomplete
      Guides = StatusGuides
    end
    object CompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
          StoredProc = spSelectMIContainer
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      Guides = StatusGuides
    end
    object DeleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
          StoredProc = spSelectMIContainer
        end>
      Caption = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      Hint = #1057#1090#1072#1090#1091#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091#1076#1072#1083#1077#1085
      ImageIndex = 13
      Status = mtDelete
      Guides = StatusGuides
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 55
    Top = 224
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 26
    Top = 224
  end
  object GuidesJuridicalBasis: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridicalBasis
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridicalBasis
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridicalBasis
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 440
    Top = 16
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 240
    Top = 256
    object N1: TMenuItem
      Action = actRefresh
    end
  end
  object spSelectMIContainer: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItemContainer_Movement'
    DataSet = EntryCDS
    DataSets = <
      item
        DataSet = EntryCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 88
    Top = 296
  end
  object EntryCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 24
    Top = 296
  end
  object EntryDS: TDataSource
    DataSet = EntryCDS
    Left = 56
    Top = 296
  end
  object spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_SendDebt'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = MasterCDS
        ComponentItem = 'id'
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
        Name = 'inJuridicalId'
        Component = MasterCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
      end
      item
        Name = 'ioAmountDebet'
        Component = MasterCDS
        ComponentItem = 'AmountDebet'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'ioAmountKredit'
        Component = MasterCDS
        ComponentItem = 'AmountKredit'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'ioSummDebet'
        Component = MasterCDS
        ComponentItem = 'SummDebet'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'ioSummKredit'
        Component = MasterCDS
        ComponentItem = 'SummKredit'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'ioIsCalculated'
        Component = MasterCDS
        ComponentItem = 'isCalculated'
        DataType = ftBoolean
        ParamType = ptInputOutput
      end
      item
        Name = 'inContractId'
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindId'
        Component = MasterCDS
        ComponentItem = 'PaidKindId'
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyId'
        Component = MasterCDS
        ComponentItem = 'InfoMoneyId'
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
      end>
    Left = 86
    Top = 224
  end
  object frxDBDataset: TfrxDBDataset
    UserName = 'frxDBDataset'
    CloseDataSource = False
    DataSet = MasterCDS
    BCDToCurrency = False
    Left = 192
    Top = 224
  end
  object MasterViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = True
    Left = 328
    Top = 312
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 120
    Top = 168
  end
  object EntryViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridEntryDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    Left = 368
    Top = 272
  end
  object spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_SendDebt'
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
        Value = '0'
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
        Name = 'inBusinessId'
        Value = ''
        Component = GuidesBusiness
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalBasisId'
        Value = ''
        Component = GuidesJuridicalBasis
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 387
    Top = 177
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
        Control = edOperDate
      end
      item
        Control = edJuridicalBasis
      end
      item
        Control = edBusiness
      end>
    GetStoredProc = spGet
    Left = 306
    Top = 193
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_SendDebt'
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
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
      end
      item
        Name = 'Invnumber'
        Value = '0'
        Component = edInvNumber
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'JuridicalBasisId'
        Value = ''
        Component = GuidesJuridicalBasis
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalBasisName'
        Value = ''
        Component = GuidesJuridicalBasis
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'BusinessId'
        Value = ''
        Component = GuidesBusiness
        ComponentItem = 'TextValue'
      end
      item
        Name = 'BusinessName'
        Value = ''
        Component = GuidesBusiness
        ComponentItem = 'TextValue'
      end>
    Left = 552
    Top = 48
  end
  object RefreshAddOn: TRefreshAddOn
    FormName = 'PersonalAccountJournalForm'
    DataSet = 'ClientDataSet'
    KeyField = 'Id'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 579
    Top = 285
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    GuidesList = <
      item
        Guides = GuidesJuridicalBasis
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end>
    Left = 258
    Top = 178
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_LossDebt_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'outIsErased'
        Component = MasterCDS
        ComponentItem = 'IsErased'
        DataType = ftBoolean
      end>
    Left = 574
    Top = 200
  end
  object spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_SendDebt_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'outIsErased'
        Component = MasterCDS
        ComponentItem = 'IsErased'
        DataType = ftBoolean
      end>
    Left = 630
    Top = 224
  end
  object StatusGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatus
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 60
    Top = 16
  end
  object spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_SendDebt'
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
    Left = 92
    Top = 16
  end
  object GuidesBusiness: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBusiness
    FormNameParam.Value = 'TBusiness_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TBusiness_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBusiness
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBusiness
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 656
    Top = 24
  end
end
