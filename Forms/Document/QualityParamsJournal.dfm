inherited QualityParamsJournalForm: TQualityParamsJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077' - '#1087#1072#1088#1072#1084#1077#1090#1088#1099'>'
  ClientHeight = 649
  ClientWidth = 1014
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1030
  ExplicitHeight = 687
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1014
    Height = 592
    TabOrder = 3
    ExplicitWidth = 1014
    ExplicitHeight = 592
    ClientRectBottom = 592
    ClientRectRight = 1014
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1014
      ExplicitHeight = 592
      inherited cxGrid: TcxGrid
        Width = 1014
        Height = 592
        ExplicitWidth = 1014
        ExplicitHeight = 592
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skSum
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 88
          end
          inherited colInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 70
          end
          inherited colOperDate: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 75
          end
          object QualityNumber: TcxGridDBColumn
            Caption = #1044#1077#1082#1083#1072#1088#1072#1094#1110#1103' '#1074#1080#1088#1086#1073#1085#1080#1082#1072' '#8470
            DataBinding.FieldName = 'QualityNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object QualityName: TcxGridDBColumn
            Caption = #1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
            DataBinding.FieldName = 'QualityName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object CertificateNumber: TcxGridDBColumn
            Caption = #1042#1077#1090'. '#1089#1074#1110#1076'. '#8470
            DataBinding.FieldName = 'CertificateNumber'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperDateCertificate: TcxGridDBColumn
            Caption = #1042#1077#1090'. '#1089#1074#1110#1076'. '#1044#1072#1090#1072
            DataBinding.FieldName = 'OperDateCertificate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object CertificateSeries: TcxGridDBColumn
            Caption = #1042#1077#1090'. '#1089#1074#1110#1076'. <'#1057#1077#1088#1110#1103'>'
            DataBinding.FieldName = 'CertificateSeries'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CertificateSeriesNumber: TcxGridDBColumn
            Caption = #1042#1077#1090'. '#1089#1074#1110#1076'. <'#8470'> '#1089#1077#1088#1110#1111
            DataBinding.FieldName = 'CertificateSeriesNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ExpertPrior: TcxGridDBColumn
            Caption = #1057#1090#1088#1086#1082#1072' <'#1045#1082#1089#1087#1077#1088#1090#1085#1080#1081' '#1074#1080#1089#1085#1086#1074#1086#1082'>'
            DataBinding.FieldName = 'ExpertPrior'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 200
          end
          object ExpertLast: TcxGridDBColumn
            Caption = #1057#1090#1088#1086#1082#1072' <'#1045#1082#1089#1087#1077#1088#1090#1085#1080#1081' '#1074#1080#1089#1085#1086#1074#1086#1082' - '#1087#1086#1082#1072#1079#1085#1080#1082#1080'>'
            DataBinding.FieldName = 'ExpertLast'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 280
          end
          object Comment: TcxGridDBColumn
            Caption = #1054#1089#1086#1073#1083#1080#1074#1110' '#1074#1110#1076#1084#1110#1090#1082#1080
            DataBinding.FieldName = 'Comment'
            Visible = False
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1014
    ExplicitWidth = 1014
    inherited deStart: TcxDateEdit
      EditValue = 42005d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42005d
    end
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      FormName = 'TQualityParamsForm'
      FormNameParam.Value = 'TQualityParamsForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
        end
        item
          Name = 'inMovementId_Value'
          Value = 0
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end>
    end
    inherited actInsertMask: TdsdInsertUpdateAction
      FormName = 'TQualityParamsForm'
      FormNameParam.Value = 'TQualityParamsForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end>
    end
    inherited actUpdate: TdsdInsertUpdateAction
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      FormName = 'TQualityParamsForm'
      FormNameParam.Value = 'TQualityParamsForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
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
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 80
    Top = 168
  end
  inherited MasterCDS: TClientDataSet
    Left = 24
    Top = 128
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_QualityParams'
    Left = 280
    Top = 384
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 128
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbInsertMask'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          BeginGroup = True
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
    Left = 472
    Top = 248
  end
  inherited PopupMenu: TPopupMenu
    object N13: TMenuItem [1]
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 200
    Top = 120
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_QualityParams'
    Left = 136
    Top = 416
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_QualityParams'
    Left = 24
    Top = 400
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_QualityParams'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Left = 48
    Top = 296
  end
  inherited FormParams: TdsdFormParams
    Left = 384
    Top = 208
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_QualityParams'
    Left = 128
    Top = 344
  end
end
