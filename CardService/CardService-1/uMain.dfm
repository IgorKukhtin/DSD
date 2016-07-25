object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'CardService'
  ClientHeight = 233
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 30
    Height = 16
    Caption = 'Login'
  end
  object Label2: TLabel
    Left = 24
    Top = 54
    Width = 55
    Height = 16
    Caption = 'Password'
  end
  object Label3: TLabel
    Left = 23
    Top = 104
    Width = 56
    Height = 16
    Caption = 'Card num'
  end
  object Label4: TLabel
    Left = 23
    Top = 144
    Width = 48
    Height = 16
    Caption = 'BarCode'
  end
  object lRequestedQuantity: TLabel
    Left = 279
    Top = 24
    Width = 107
    Height = 16
    Caption = 'RequestedQuantity'
  end
  object lRequestedPrice: TLabel
    Left = 416
    Top = 24
    Width = 91
    Height = 16
    Caption = 'lRequestedPrice'
  end
  object Label6: TLabel
    Left = 384
    Top = 130
    Width = 86
    Height = 16
    Caption = 'ChangePercent'
  end
  object Label7: TLabel
    Left = 487
    Top = 130
    Width = 123
    Height = 16
    Caption = 'SummChangePercent'
  end
  object bCheckCard: TButton
    Left = 128
    Top = 176
    Width = 97
    Height = 41
    Caption = 'Check card'
    TabOrder = 0
    OnClick = bCheckCardClick
  end
  object eLogin: TEdit
    Left = 104
    Top = 21
    Width = 121
    Height = 24
    TabOrder = 1
    Text = 'PANI'
  end
  object ePassword: TEdit
    Left = 104
    Top = 51
    Width = 121
    Height = 24
    TabOrder = 2
    Text = 'pass'
  end
  object eCardNum: TEdit
    Left = 104
    Top = 101
    Width = 121
    Height = 24
    TabOrder = 3
    Text = '4820043367665'
    OnChange = eCardNumChange
  end
  object bCheckSale: TButton
    Left = 320
    Top = 176
    Width = 113
    Height = 41
    Caption = 'Check BarCode'
    TabOrder = 4
    OnClick = bCheckSaleClick
  end
  object eBarCode: TEdit
    Left = 104
    Top = 144
    Width = 121
    Height = 24
    TabOrder = 5
    Text = '4034541002175'
  end
  object eResult: TEdit
    Left = 256
    Top = 146
    Width = 97
    Height = 24
    TabOrder = 6
    Text = 'eResult'
  end
  object eCardNumRes: TEdit
    Left = 256
    Top = 100
    Width = 300
    Height = 24
    TabOrder = 7
    Text = 'eCardNumRes'
    OnChange = eCardNumChange
  end
  object eResultChangePercent: TEdit
    Left = 384
    Top = 146
    Width = 97
    Height = 24
    TabOrder = 8
    Text = 'eResultChangePercent'
  end
  object eResultSummChangePercent: TEdit
    Left = 487
    Top = 144
    Width = 123
    Height = 24
    TabOrder = 9
    Text = 'eResultSummChangePercent'
  end
  object eResultRequestedPrice: TEdit
    Left = 416
    Top = 46
    Width = 107
    Height = 24
    TabOrder = 10
    Text = 'eResultRequestedPrice'
  end
  object eResultRequestedQuantity: TEdit
    Left = 279
    Top = 46
    Width = 107
    Height = 24
    TabOrder = 11
    Text = 'eResultRequestedQuantity'
  end
  object bCommit: TButton
    Left = 480
    Top = 176
    Width = 113
    Height = 41
    Caption = 'Commit BarCode'
    TabOrder = 12
    OnClick = bCommitClick
  end
  object HTTPRIO1: THTTPRIO
    HTTPWebNode.UseUTF8InHeader = True
    HTTPWebNode.InvokeOptions = [soIgnoreInvalidCerts, soAutoCheckAccessPointViaUDDI]
    HTTPWebNode.WebNodeOptions = []
    Converter.Options = [soSendMultiRefObj, soTryAllSchema, soRootRefNodesToBody, soCacheMimeResponse, soUTF8EncodeXML]
    Left = 600
    Top = 16
  end
end
