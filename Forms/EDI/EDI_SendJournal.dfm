inherited EDI_SendJournalForm: TEDI_SendJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' <'#1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1074' EDI>'
  ClientHeight = 431
  ClientWidth = 941
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 957
  ExplicitHeight = 470
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 941
    Height = 374
    TabOrder = 3
    ExplicitWidth = 941
    ExplicitHeight = 374
    ClientRectBottom = 374
    ClientRectRight = 941
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 941
      ExplicitHeight = 374
      inherited cxGrid: TcxGrid
        Width = 941
        Height = 374
        ExplicitWidth = 941
        ExplicitHeight = 374
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = ToName
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
          end
          inherited colInvNumber: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
          end
          inherited colOperDate: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
          end
          object MovementDescName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'MovementDescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colStatus_sale: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'StatusCode_sale'
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InvNumber_Parent: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'InvNumber_Parent'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperDate_Parent: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'OperDate_Parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperDatePartner_Parent: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1087#1088'. '#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'OperDatePartner_Parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 160
          end
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object JuridicalName_To: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName_To'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
          end
          object OperDatePartner: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' '#1082#1086#1075#1076#1072' '#1086#1090#1087#1088#1072#1074#1080#1083#1080
            DataBinding.FieldName = 'OperDatePartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 121
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object isEdiOrdspr: TcxGridDBColumn
            Caption = 'EDI - '#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077
            DataBinding.FieldName = 'isEdiOrdspr'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isEdiInvoice: TcxGridDBColumn
            Caption = 'EDI - '#1057#1095#1077#1090
            DataBinding.FieldName = 'isEdiInvoice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isEdiDesadv: TcxGridDBColumn
            Caption = 'EDI - '#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'isEdiDesadv'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object isVchasno: TcxGridDBColumn
            Caption = #1042#1095#1072#1089#1085#1086'-EDI ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isVchasno'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 941
    ExplicitWidth = 941
    inherited deStart: TcxDateEdit
      EditValue = 43101d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 43101d
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 83
    Top = 291
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 48
    Top = 195
  end
  inherited ActionList: TActionList
    Left = 239
    Top = 290
    inherited actUpdate: TdsdInsertUpdateAction
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
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TMovement_PeriodDialogForm'
      FormNameParam.Value = 'TMovement_PeriodDialogForm'
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
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_EDI_Send'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited BarManager: TdxBarManager
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
          ItemName = 'bbComplete'
        end
        item
          Visible = True
          ItemName = 'bbUnComplete'
        end
        item
          Visible = True
          ItemName = 'bbDelete'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
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
          ItemName = 'bbMovementProtocol'
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
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ActionItemList = <
      item
      end>
    Left = 256
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_EDI_Send'
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_EDI_Send'
    Left = 488
    Top = 168
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_EDI_Send'
    Left = 440
    Top = 216
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_EDI_Send'
  end
end
