inherited IncomeJournalChoiceForm: TIncomeJournalChoiceForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
  ClientHeight = 498
  ClientWidth = 999
  AddOnFormData.isSingle = True
  AddOnFormData.ChoiceAction = actChoiceGuides
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1015
  ExplicitHeight = 537
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 999
    Height = 400
    TabOrder = 3
    ExplicitWidth = 999
    ExplicitHeight = 400
    ClientRectBottom = 400
    ClientRectRight = 999
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 999
      ExplicitHeight = 400
      inherited cxGrid: TcxGrid
        Width = 999
        Height = 400
        ExplicitWidth = 999
        ExplicitHeight = 400
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
          DataController.Filter.TranslateBetween = True
          DataController.Filter.TranslateIn = True
          DataController.Filter.TranslateLike = True
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummMVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummPVAT
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
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummMVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummPVAT
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
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = FromName
            end>
          OptionsBehavior.GoToNextCellOnEnter = False
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsSelection.MultiSelect = True
          OptionsView.GroupByBox = True
          OptionsView.HeaderHeight = 40
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 70
          end
          inherited colInvNumber: TcxGridDBColumn
            Caption = 'Interne Nr'
            HeaderAlignmentHorz = taCenter
          end
          object InvNumberPartner: TcxGridDBColumn [2]
            Caption = 'External Nr'
            DataBinding.FieldName = 'InvNumberPartner'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          inherited colOperDate: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 70
          end
          object InvNumberInvoice: TcxGridDBColumn
            Caption = #8470' '#1057#1095#1077#1090#1072
            DataBinding.FieldName = 'InvNumberInvoice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1084#1077#1088' '#1057#1095#1077#1090#1072
            Options.Editing = False
            Width = 70
          end
          object InvNumberPack: TcxGridDBColumn
            Caption = #8470' '#1059#1087'. '#1083#1080#1089#1090#1072
            DataBinding.FieldName = 'InvNumberPack'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1084#1077#1088' '#1059#1087#1072#1082#1086#1074#1086#1095#1085#1086#1075#1086' '#1083#1080#1089#1090#1072
            Options.Editing = False
            Width = 70
          end
          object OperDatePartner: TcxGridDBColumn
            Caption = 'External Dt'
            DataBinding.FieldName = 'OperDatePartner'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object FromName: TcxGridDBColumn
            Caption = 'Lieferanten'
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090' '#1082#1086#1075#1086
            Width = 91
          end
          object ToName: TcxGridDBColumn
            Caption = #1057#1082#1083#1072#1076'/'#1059#1095#1072#1089#1090#1086#1082' '#1089#1073#1086#1088#1082#1080
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1084#1091
            Width = 120
          end
          object TotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'TotalCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object DiscountTax: TcxGridDBColumn
            Caption = '% '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'DiscountTax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 51
          end
          object PriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'PriceWithVAT'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object VATPercent: TcxGridDBColumn
            Caption = '% '#1053#1044#1057
            DataBinding.FieldName = 'VATPercent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 42
          end
          object TotalSummVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1053#1044#1057
            DataBinding.FieldName = 'TotalSummVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object TotalSummMVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'TotalSummMVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object TotalSummPVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'TotalSummPVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 107
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 999
    ExplicitWidth = 999
    inherited deStart: TcxDateEdit
      Left = 96
      ExplicitLeft = 96
      ExplicitWidth = 81
      Width = 81
    end
    inherited deEnd: TcxDateEdit
      Left = 295
      ExplicitLeft = 295
      ExplicitWidth = 80
      Width = 80
    end
    inherited cxLabel1: TcxLabel
      Left = 3
      ExplicitLeft = 3
    end
    inherited cxLabel2: TcxLabel
      Left = 184
      ExplicitLeft = 184
    end
    object lbSearchArticle: TcxLabel
      Left = 400
      Top = 4
      Caption = #8470' '#1087#1088#1080#1093#1086#1076':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchInvNumber: TcxTextEdit
      Left = 477
      Top = 5
      TabOrder = 5
      DesignSize = (
        120
        21)
      Width = 120
    end
    object cxLabel4: TcxLabel
      Left = 603
      Top = 4
      Caption = #8470' '#1089#1095#1077#1090':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchInvNumber_Invoice: TcxTextEdit
      Left = 663
      Top = 5
      TabOrder = 7
      DesignSize = (
        120
        21)
      Width = 120
    end
    object cxLabel3: TcxLabel
      Left = 789
      Top = 5
      Caption = 'Lieferanten: '
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchFromName: TcxTextEdit
      Left = 874
      Top = 5
      TabOrder = 9
      DesignSize = (
        120
        21)
      Width = 120
    end
  end
  object Panel_btn: TPanel [2]
    Left = 0
    Top = 457
    Width = 999
    Height = 41
    Align = alBottom
    TabOrder = 6
    object btnFormClose: TcxButton
      Left = 290
      Top = 7
      Width = 90
      Height = 25
      Action = actFormClose
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object btnChoiceGuides: TcxButton
      Left = 167
      Top = 7
      Width = 90
      Height = 25
      Action = actChoiceGuides
      TabOrder = 1
    end
    object btnShowErased: TcxButton
      Left = 462
      Top = 7
      Width = 139
      Height = 25
      Action = actShowErased
      TabOrder = 2
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 179
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 243
  end
  inherited ActionList: TActionList
    Left = 471
    inherited actMovementItemContainer: TdsdOpenForm
      Enabled = False
    end
    inherited actInsert: TdsdInsertUpdateAction
      Enabled = False
      FormName = 'TTaxForm'
      FormNameParam.Value = nil
      DataSource = nil
    end
    inherited actInsertMask: TdsdInsertUpdateAction
      Enabled = False
      DataSource = nil
    end
    inherited actUpdate: TdsdInsertUpdateAction
      Enabled = False
      FormName = 'TTaxForm'
      FormNameParam.Value = nil
      DataSource = nil
    end
    inherited actComplete: TdsdChangeMovementStatus
      Enabled = False
      DataSource = nil
    end
    inherited actUnComplete: TdsdChangeMovementStatus
      Enabled = False
      DataSource = nil
    end
    inherited actSetErased: TdsdChangeMovementStatus
      Enabled = False
      DataSource = nil
    end
    inherited mactReCompleteList: TMultiAction
      Enabled = False
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080' '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'?'
      Hint = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1042#1057#1045' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
    end
    inherited mactCompleteList: TMultiAction
      Enabled = False
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080' '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'?  '
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1042#1057#1045' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
    end
    inherited mactUnCompleteList: TMultiAction
      Enabled = False
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1086#1090#1084#1077#1085#1077' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'?  '
      InfoAfterExecute = #1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' '#1086#1090#1084#1077#1085#1080#1083#1086#1089#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1042#1089#1077#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
    end
    inherited mactSetErasedList: TMultiAction
      Enabled = False
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'? '
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1042#1057#1045' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
    end
    object actChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ToId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ToName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TotalSumm'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'TotalSumm'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      Caption = #1054#1050
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1078#1091#1088#1085#1072#1083#1072
      ImageIndex = 80
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 139
  end
  inherited MasterCDS: TClientDataSet
    Top = 139
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Income'
    Params = <
      item
        Name = 'instartdate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inenddate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
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
      end
      item
        Value = '0'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 171
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 155
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSelect'
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
    end
    inherited bbComplete: TdxBarButton
      Visible = ivNever
    end
    inherited bbUnComplete: TdxBarButton
      Visible = ivNever
    end
    inherited bbDelete: TdxBarButton
      Visible = ivNever
    end
    object bbSelect: TdxBarButton
      Action = actChoiceGuides
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actChoiceGuides
      end>
    ActionItemList = <
      item
        Action = actChoiceGuides
        ShortCut = 13
      end>
    Left = 320
    Top = 224
  end
  inherited PopupMenu: TPopupMenu
    Left = 640
    Top = 152
    inherited N3: TMenuItem
      Visible = False
    end
    inherited N2: TMenuItem
      Visible = False
    end
    inherited N4: TMenuItem
      Visible = False
    end
    inherited N5: TMenuItem
      Visible = False
    end
    inherited N7: TMenuItem
      Visible = False
    end
    inherited N8: TMenuItem
      Visible = False
    end
    inherited N9: TMenuItem
      Visible = False
    end
    inherited N10: TMenuItem
      Visible = False
    end
    inherited N11: TMenuItem
      Visible = False
    end
    inherited N12: TMenuItem
      Visible = False
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 240
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
    Left = 408
    Top = 344
  end
  inherited spMovementComplete: TdsdStoredProc
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inislastcomplete'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 320
  end
  inherited spMovementUnComplete: TdsdStoredProc
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 384
  end
  inherited spMovementSetErased: TdsdStoredProc
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 376
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 304
    Top = 288
  end
  inherited spMovementReComplete: TdsdStoredProc
    Left = 408
  end
  object FieldFilter_Article: TdsdFieldFilter
    TextEdit = edSearchInvNumber
    DataSet = MasterCDS
    Column = colInvNumber
    ColumnList = <
      item
        Column = colInvNumber
      end
      item
        Column = InvNumberInvoice
        TextEdit = edSearchInvNumber_Invoice
      end
      item
        Column = FromName
        TextEdit = edSearchFromName
      end>
    ActionNumber1 = actChoiceGuides
    CheckBoxList = <>
    Left = 784
    Top = 144
  end
end
