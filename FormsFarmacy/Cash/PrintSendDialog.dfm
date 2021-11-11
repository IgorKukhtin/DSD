object PrintSendDialogForm: TPrintSendDialogForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1055#1077#1095#1072#1090#1100' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
  ClientHeight = 164
  ClientWidth = 278
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  GlassFrame.Bottom = 60
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.RefreshAction = acttRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 124
    Top = 24
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 124
    Top = 96
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Send_Print'
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
    Left = 39
    Top = 24
  end
  object ActionList1: TActionList
    Left = 216
    Top = 24
    object acttRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = mactPrint
      AfterAction = mactPrint
      Timer = Timer
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object mactPrint: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
        end
        item
        end>
      Caption = 'mactPrint'
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 32
    Top = 96
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 216
    Top = 96
  end
end
