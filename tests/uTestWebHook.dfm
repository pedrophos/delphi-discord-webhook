object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 363
  ClientWidth = 672
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 11
    Top = 196
    Width = 157
    Height = 13
    Caption = 'Json da mensagem enviada'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 5
    Top = 6
    Width = 157
    Height = 13
    Caption = 'Json da mensagem enviada'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edtTest: TEdit
    Left = 5
    Top = 67
    Width = 441
    Height = 21
    TabOrder = 0
    Text = 'Texto a ser enviado'
  end
  object btnTextoSimples: TButton
    Left = 452
    Top = 65
    Width = 209
    Height = 25
    Caption = 'Enviar Texto Simples'
    TabOrder = 1
    OnClick = btnTextoSimplesClick
  end
  object btnTabela: TButton
    Left = 280
    Top = 113
    Width = 209
    Height = 25
    Caption = 'Enviar Tabela'
    TabOrder = 2
    OnClick = btnTabelaClick
  end
  object rgTipoTabela: TRadioGroup
    Left = 8
    Top = 105
    Width = 257
    Height = 33
    Caption = 'Metodo de envio da tabela'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Tabela'
      'Tabela em Linha')
    TabOrder = 3
  end
  object Memo1: TMemo
    Left = 5
    Top = 212
    Width = 662
    Height = 140
    ReadOnly = True
    TabOrder = 4
  end
  object btnWebHookMessage: TButton
    Left = 8
    Top = 164
    Width = 193
    Height = 25
    Caption = 'Enviar Exemplo mensagem discord'
    TabOrder = 5
    OnClick = btnWebHookMessageClick
  end
  object edtServerUrl: TEdit
    Left = 5
    Top = 27
    Width = 659
    Height = 21
    TabOrder = 6
  end
  object dtTest: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 624
    Top = 201
    object dtTestCODIGO: TStringField
      FieldName = 'CODIGO'
      Size = 10
    end
    object dtTestDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 30
    end
    object dtTestESTOQUE: TStringField
      Alignment = taCenter
      FieldName = 'ESTOQUE'
      Size = 7
    end
  end
  object FDMemTable1: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 576
    Top = 201
  end
end
