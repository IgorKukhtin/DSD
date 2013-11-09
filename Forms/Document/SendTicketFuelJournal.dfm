inherited SendTicketFuelJournalForm: TSendTicketFuelJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' ('#1058#1072#1083#1086#1085#1099' '#1085#1072' '#1090#1086#1087#1083#1080#1074#1086')>'
  ClientHeight = 427
  ClientWidth = 733
  ExplicitWidth = 749
  ExplicitHeight = 462
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 733
    Height = 370
    ExplicitWidth = 733
    ExplicitHeight = 370
    ClientRectBottom = 370
    ClientRectRight = 733
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 733
      ExplicitHeight = 370
      inherited cxGrid: TcxGrid
        Width = 733
        Height = 370
        ExplicitWidth = 733
        ExplicitHeight = 370
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
          DataController.Filter.TranslateBetween = True
          DataController.Filter.TranslateIn = True
          DataController.Filter.TranslateLike = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colFromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentVert = vaCenter
            Width = 140
          end
          object colToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentVert = vaCenter
            Width = 140
          end
          object colTotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'TotalCount'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 733
    ExplicitWidth = 733
  end
  inherited cxPropertiesStore: TcxPropertiesStore
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
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TSendTicketFuelForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TSendTicketFuelForm'
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Send'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      FloatClientWidth = 51
      FloatClientHeight = 71
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = actUpdate
        ShortCut = 13
      end>
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Send'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inStatusCode'
        Value = 2
        ParamType = ptInput
      end>
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Send'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inStatusCode'
        Value = 1
        ParamType = ptInput
      end>
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Send'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inStatusCode'
        Value = 3
        ParamType = ptInput
      end>
  end
end
