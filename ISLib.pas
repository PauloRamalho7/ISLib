unit ISLib;

interface

uses
  Sysutils,

  FMX.DialogService,
  FMX.Dialogs,
  FMX.Graphics,
  FMX.ListView.Types,
  FMX.TextLayout,

  System.Classes,
  System.IniFiles,
  System.NetEncoding,
  System.Types;

      function Nome_Mes(mes : integer;Idioma : String='PTBR'): String; Overload
      function Nome_Mes(mes : string;Idioma : String='PTBR'): String; Overload;
//      function GetDeleteConfirmation(AMessage: String): String;
//      Procedure FormatarMoeda( Componente : TObject; var Key: Char );
      function NomeExe: String;
      function NomeINI: String;
      procedure SetValorINI(const pSessao, pID, pValor: String);
      function GetValorINI(const pSessao, pID: String): String;
      function GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
      function ConvertValor(SValor : string):Double;
      function ValidarValor(SValor : string):Boolean;
      function Base64FromBitmap(Bitmap: TBitmap): string;
      function BitmapFromBase64(const base64: string): TBitmap;



implementation

      function Nome_Mes(mes : integer;Idioma : String='PTBR'): String; overload;
      begin

          if IDIOMA = 'PTBR' then
          begin

              case mes of
                      1 : Result := 'Janeiro';
                      2 : Result := 'Fevereiro';
                      3 : Result := 'Março';
                      4 : Result := 'Abril';
                      5 : Result := 'Maio';
                      6 : Result := 'Junho';
                      7 : Result := 'Julho';
                      8 : Result := 'Agosto';
                      9 : Result := 'Setembro';
                     10 : Result := 'Outubro';
                     11 : Result := 'Novembro';
                     12 : Result := 'Dezembro';
              end;
          end;
          if IDIOMA = 'ENG' then
          begin
              case mes of
                      1 : Result := 'January';
                      2 : Result := 'February';
                      3 : Result := 'March';
                      4 : Result := 'April';
                      5 : Result := 'May';
                      6 : Result := 'June';
                      7 : Result := 'July';
                      8 : Result := 'Agust';
                      9 : Result := 'September';
                     10 : Result := 'October';
                     11 : Result := 'November';
                     12 : Result := 'December';
              end;

          end;
          if IDIOMA = 'ESP' then
          begin
              case mes of
                      1 : Result := 'Janeiro';
                      2 : Result := 'Fevereiro';
                      3 : Result := 'Março';
                      4 : Result := 'Abril';
                      5 : Result := 'Maio';
                      6 : Result := 'Junho';
                      7 : Result := 'Julho';
                      8 : Result := 'Agosto';
                      9 : Result := 'Setembro';
                     10 : Result := 'Outubro';
                     11 : Result := 'Novembro';
                     12 : Result := 'Dezembro';
              end;

          end;

      end;

     function Nome_Mes(mes : string;Idioma : String='PTBR'): String;  Overload;
     begin
        Result := Nome_Mes(StrToInt(mes));

     end;

   {  function GetDeleteConfirmation(AMessage: String): String;
        var
          lResultStr: String;
        begin
          lResultStr:='';
          TDialogService.PreferredMode:=TDialogService.TPreferredMode.Platform;
          TDialogService.MessageDialog(AMessage, TMsgDlgType.mtConfirmation,
            FMX.Dialogs.mbYesNo, TMsgDlgBtn.mbNo, 0,
            procedure(const AResult: TModalResult)
            begin
              case AResult of
                mrYes: lResultStr:='Y';
                mrNo:  lResultStr:='N';
              end;
            end);

          Result:=lResultStr;
        end;



Procedure FormatarMoeda( Componente : TObject; var Key: Char );
var
   valor_str  : String;
   valor  : double;
begin

        if Componente is TEdit then
        begin
                // Se tecla pressionada é um numero, backspace ou delete...
                if ( Key in ['0'..'9', #8, #9] ) then
                begin
                         // Salva valor do edit...
                         valor_str := TEdit( Componente ).Text;

                         // Valida vazio...
                         if valor_str = EmptyStr then
                                valor_str := '0,00';

                         // Se valor numerico, insere na string...
                         if Key in ['0'..'9'] then
                                valor_str := Concat( valor_str, Key ) ;

                         // Retira pontos e virgulas...
                         valor_str := Trim( StringReplace( valor_str, '.', '', [rfReplaceAll, rfIgnoreCase] ) ) ;
                         valor_str := Trim( StringReplace( valor_str, ',', '', [rfReplaceAll, rfIgnoreCase] ) ) ;

                         // Inserindo 2 casas decimais...
                         valor := StrToFloat( valor_str ) ;
                         valor := ( valor / 100 ) ;

                         // Retornando valor tratado ao edit...
                         TEdit( Componente ).Text := FormatFloat( '###,##0.00', valor ) ;

                         // Reposiciona cursor...
                         TEdit( Componente ).SelStart := Length( TEdit( Componente ).Text );
                end;

                // Se nao é key importante, reseta...
                if Not( Key in [#8, #9] ) then
                        key := #0;
        end;

end;
}
      function NomeExe: String;
      var
        N, D: String;
      begin
        Result:='';
        N := ExtractFileName(ParamStr(0)); { Retira o path }
        D := ChangeFileExt(N,''); { Retira a extensão }

        { Coloca a primeira letra em maiúscula e o resto em minúscula }
        Result := UpperCase(Copy(D,1,1)) + LowerCase(Copy(D,2,Length(D)-1));
      end;

      function NomeINI: String;
      begin
        Result :='';
        Result := ExtractFileName(ParamStr(0))+NomeExe+'.ini';

      end;

      procedure SetValorINI(const pSessao, pID, pValor: String);
      var
        vFile : TIniFile;
      begin
        vFile := TIniFile.Create(NomeINI);

        vFile.WriteString(pSessao, pID, pValor);

        vFile.Free;
      end;

      function GetValorINI(const pSessao, pID: String): String;
      var
        vFile : TIniFile;
      begin
        vFile := TIniFile.Create(NomeINI);

        Result := vFile.ReadString(pSessao, pID,'');

        vFile.Free;
      end;

function GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
var
  Layout: TTextLayout;
begin
  // Create a TTextLayout to measure text dimensions
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      // Initialize layout parameters with those of the drawable
      Layout.Font.Assign(D.Font);
      Layout.VerticalAlign := D.TextVertAlign;
      Layout.HorizontalAlign := D.TextAlign;
      Layout.WordWrap := D.WordWrap;
      Layout.Trimming := D.Trimming;
      Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
      Layout.Text := Text;
    finally
      Layout.EndUpdate;
    end;
    // Get layout height
    Result := Round(Layout.Height);
    // Add one em to the height
    Layout.Text := 'm';
    Result := Result + Round(Layout.Height);
  finally
    Layout.Free;
  end;
end;

function ConvertValor(SValor : string):Double;
begin
    SValor := StringReplace(SValor, ',', '', [rfReplaceAll]);
    SValor := StringReplace(SValor, '.', '', [rfReplaceAll]);
    SValor := StringReplace(SValor, 'R$', '', [rfReplaceAll]);
    try
        Result := StrToFloat(SValor)/100;
    except
        Result := 0;
    end;

end;

function ValidarValor(SValor : string):Boolean;
begin
    SValor := StringReplace(SValor, ',', '', [rfReplaceAll]);
    SValor := StringReplace(SValor, '.', '', [rfReplaceAll]);
    SValor := StringReplace(SValor, 'R$', '', [rfReplaceAll]);
    try
        StrToFloat(SValor);
        Result := True;
    except
        Result := False;
    end;

end;

function Base64FromBitmap(Bitmap: TBitmap): string;
var
  Input: TBytesStream;
  Output: TStringStream;
  Encoding: TBase64Encoding;
begin
        Input := TBytesStream.Create;
        try
                Bitmap.SaveToStream(Input);
                Input.Position := 0;
                Output := TStringStream.Create('', TEncoding.ASCII);

                try
                    Encoding := TBase64Encoding.Create(0);
                    Encoding.Encode(Input, Output);
                    Result := Output.DataString;
                finally
                        Encoding.Free;
                        Output.Free;
                end;

        finally
                Input.Free;
        end;
end;

function BitmapFromBase64(const base64: string): TBitmap;
var
  Input: TStringStream;
  Output: TBytesStream;
  Encoding: TBase64Encoding;
begin
  Input := TStringStream.Create(base64, TEncoding.ASCII);
  try
    Output := TBytesStream.Create;
    try
      Encoding := TBase64Encoding.Create(0);
      Encoding.Decode(Input, Output);

      Output.Position := 0;
      Result := TBitmap.Create;
      try
        Result.LoadFromStream(Output);
      except
        Result.Free;
        raise;
      end;
    finally
      Encoding.DisposeOf;
      Output.Free;
    end;
  finally
    Input.Free;
  end;
end;

end.
