inherited ProfitLossServiceJournalForm: TProfitLossServiceJournalForm
  Caption = 
    #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1087#1086' '#1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1084#1091' '#1083#1080#1094#1091' ('#1088#1072#1089#1093#1086#1076#1099' '#1073#1091#1076#1091 +
    #1097#1080#1093' '#1087#1077#1088#1080#1086#1076#1086#1074')>'
  ClientHeight = 535
  ClientWidth = 1110
  ExplicitWidth = 1118
  ExplicitHeight = 569
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1110
    Height = 476
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 1110
    ExplicitHeight = 476
    ClientRectBottom = 472
    ClientRectRight = 1106
    inherited tsMain: TcxTabSheet
      ExplicitLeft = 2
      ExplicitTop = 2
      ExplicitWidth = 1104
      ExplicitHeight = 470
      inherited cxGrid: TcxGrid
        Width = 1104
        Height = 470
        ExplicitWidth = 1104
        ExplicitHeight = 470
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
          DataController.Filter.TranslateBetween = True
          DataController.Filter.TranslateIn = True
          DataController.Filter.TranslateLike = True
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
              Format = ',0.####'
              Kind = skSum
            end>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = False
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          OptionsView.HeaderHeight = 40
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          inherited colInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          inherited colOperDate: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 50
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1110
    ExplicitWidth = 1110
    inherited deStart: TcxDateEdit
      EditValue = 41609d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 41639d
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
      FormName = 'TProfitLossServiceForm'
      FormNameParam.Name = 'TProfitLossServiceForm'
      FormNameParam.Value = 'TProfitLossServiceForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
        end
        item
          Name = 'ShowAll'
          Value = True
          DataType = ftBoolean
        end
        item
          Name = 'inOperDate'
          Value = 41639d
          Component = deEnd
          DataType = ftDateTime
        end>
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TProfitLossServiceForm'
      FormNameParam.Name = 'TProfitLossServiceForm'
      FormNameParam.Value = 'TProfitLossServiceForm'
      GuiParams = <
        item
          Name = 'Id'
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
        end
        item
          Name = 'inOperDate'
          Value = 41639d
          Component = deEnd
          DataType = ftDateTime
        end>
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
    StoredProcName = 'gpSelect_Movement_ProfitLossService'
    Params = <
      item
        Name = 'instartdate'
        Value = 41609d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inenddate'
        Value = 41639d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptUnknown
      end>
    Top = 155
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 155
    DockControlHeights = (
      0
      0
      28
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 224
  end
  inherited PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 640
    Top = 152
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
    StoredProcName = 'gpComplete_Movement_ProfitLossService'
    Params = <
      item
        Name = 'inmovementid'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inislastcomplete'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
      end>
    Left = 80
    Top = 320
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_ProfitLossService'
    Params = <
      item
        Name = 'inmovementid'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 80
    Top = 384
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_ProfitLossService'
    Params = <
      item
        Name = 'inmovementid'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 208
    Top = 376
  end
end
