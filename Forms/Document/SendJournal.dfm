inherited SendJournalForm: TSendJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>'
  ClientHeight = 427
  ClientWidth = 733
  AddOnFormData.isSingle = False
  ExplicitWidth = 741
  ExplicitHeight = 454
  PixelsPerInch = 96
  TextHeight = 13
  inherited cxGrid: TcxGrid
    Width = 733
    Height = 370
    PopupMenu = PopupMenu
    TabOrder = 0
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
      object colStatus: TcxGridDBColumn
        Caption = #1057#1090#1072#1090#1091#1089
        DataBinding.FieldName = 'StatusCode'
        PropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.Images = dmMain.ImageList
        Properties.Items = <
          item
            Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
            ImageIndex = 11
            Value = 1
          end
          item
            Description = #1055#1088#1086#1074#1077#1076#1077#1085
            ImageIndex = 12
            Value = 2
          end
          item
            Description = #1059#1076#1072#1083#1077#1085
            ImageIndex = 13
            Value = 3
          end>
        HeaderAlignmentVert = vaCenter
      end
      object colInvNumber: TcxGridDBColumn
        Caption = #1053#1086#1084#1077#1088
        DataBinding.FieldName = 'InvNumber'
        HeaderAlignmentVert = vaCenter
        Width = 75
      end
      object colOperDate: TcxGridDBColumn
        Caption = #1044#1072#1090#1072
        DataBinding.FieldName = 'OperDate'
        HeaderAlignmentVert = vaCenter
        Width = 47
      end
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
  inherited Panel: TPanel
    Width = 733
    ExplicitWidth = 733
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 67
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
    Left = 8
    Top = 64
  end
  inherited ActionList: TActionList
    Left = 96
    Top = 264
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TSendForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TSendForm'
    end
  end
  inherited spMainData: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Send'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41275d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInputOutput
      end
      item
        Name = 'inEndDate'
        Value = 41639d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
  end
  inherited BarManager: TdxBarManager
    Left = 48
    Top = 64
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
    Left = 128
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Send'
    Params = <
      item
        Name = 'inMovementId'
        Component = MainDataCDS
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
        Component = MainDataCDS
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
        Component = MainDataCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inStatusCode'
        Value = 3
        ParamType = ptInput
      end>
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 120
    Top = 72
    object N1: TMenuItem
      Action = actComplete
    end
    object N2: TMenuItem
      Action = actUnComplete
    end
  end
end
