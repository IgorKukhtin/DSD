inherited IncomeJournalChoiceForm: TIncomeJournalChoiceForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
  ClientHeight = 535
  ClientWidth = 765
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  AddOnFormData.Params = FormParams
  ExplicitWidth = 781
  ExplicitHeight = 573
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 765
    Height = 478
    TabOrder = 3
    ExplicitWidth = 765
    ExplicitHeight = 478
    ClientRectBottom = 478
    ClientRectRight = 765
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 765
      ExplicitHeight = 478
      inherited cxGrid: TcxGrid
        Width = 765
        Height = 478
        ExplicitWidth = 765
        ExplicitHeight = 478
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
            Width = 55
          end
          object InvNumberPartner: TcxGridDBColumn
            Caption = 'External Nr'
            DataBinding.FieldName = 'InvNumberPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperDatePartner: TcxGridDBColumn
            Caption = 'External Dt'
            DataBinding.FieldName = 'OperDatePartner'
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
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1084#1091
            Width = 91
          end
          object TotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1089#1082#1083#1072#1076')'
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
          object ChangePercent: TcxGridDBColumn
            Caption = '(-)% '#1089#1082'. (+)% '#1085#1072#1094
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
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
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
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
    Width = 765
    ExplicitWidth = 765
    inherited deStart: TcxDateEdit
      EditValue = 44197d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 44197d
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
    inherited actInsert: TdsdInsertUpdateAction
      Enabled = False
      FormName = 'TTaxForm'
      FormNameParam.Value = nil
    end
    inherited actInsertMask: TdsdInsertUpdateAction
      Enabled = False
    end
    inherited actUpdate: TdsdInsertUpdateAction
      Enabled = False
      FormName = 'TTaxForm'
      FormNameParam.Value = nil
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
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
    inherited actUnComplete: TdsdChangeMovementStatus
      Enabled = False
    end
    inherited actComplete: TdsdChangeMovementStatus
      Enabled = False
    end
    inherited actSetErased: TdsdChangeMovementStatus
      Enabled = False
    end
    inherited actMovementItemContainer: TdsdOpenForm
      Enabled = False
    end
    object dsdChoiceGuides: TdsdChoiceGuides
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
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1078#1091#1088#1085#1072#1083#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1078#1091#1088#1085#1072#1083#1072
      ImageIndex = 7
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
      Action = dsdChoiceGuides
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
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
end
