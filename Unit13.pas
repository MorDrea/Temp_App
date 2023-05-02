
unit Unit13;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Unit14, Unit1,
  FMX.StdCtrls, FMX.Layouts, FMX.ExtCtrls, FMX.Controls.Presentation,
  FMX.ListBox, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, FMX.Edit, Datasnap.DBClient, Datasnap.Provider, Data.DB,
  Data.Win.ADODB, Data.FMTBcd, Data.SqlExpr, Data.DbxSqlite, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Windows, System.IOUtils;

  type
  TForm13 = class(TForm)
    Timer1: TTimer;
    Layout1: TLayout;
    Label1: TLabel;
    IdHTTP1: TIdHTTP;
    GroupBox1: TGroupBox;
    ImageViewer1: TImageViewer;
    Label4: TLabel;
    Label5: TLabel;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    GroupBox2: TGroupBox;
    Button3: TButton;
    Label7: TLabel;
    ImageViewer2: TImageViewer;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    StyleBook1: TStyleBook;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label15: TLabel;
    Button1: TButton;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    procedure Splash(Sender: TObject);
    procedure FinTemps(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form13: TForm13;

implementation
var Form14 : TForm14;  Form1 : TForm1;


{$R *.fmx}

procedure TForm13.Button1Click(Sender: TObject);
var
  FDQuery1: TFDQuery;
  Count: Integer;
begin
FDQuery1 := TFDQuery.Create(nil);
  try
    FDQuery1.Connection := FDConnection1;
    FDConnection1.Connected := True;


    FDQuery1.SQL.Text := 'SELECT COUNT(*) FROM temperature';
    FDQuery1.Open;

    Count := FDQuery1.Fields[0].AsInteger;

    if Count = 0 then
      ShowMessage('AUCUNE INFORMATION ENREGISTREE !')
    else
      Form1.Show;
  finally
    FDQuery1.Free;
    FDConnection1.Connected := False;
  end;
end;

procedure TForm13.Button2Click(Sender: TObject);
var
t1, t2, reponse1 : String ;
http: TIdHTTP;
begin
http := TIdHTTP.Create(nil);
   if ((edit1.Text = '') or (edit2.Text = ''))  then
   begin
       ShowMessage('Paramètres incorrects !');
   end else begin
     t1 := edit1.Text;
     t2 := edit2.Text;
    try
      reponse1 := http.Get('http://192.168.20.124:80/d?rtmp='+t1+':'+t2);
      if reponse1 = 'OK' then showMessage('Paramétrage réussi');

    finally
      http.free;
    end;
   end;
end;

procedure TForm13.Button3Click(Sender: TObject);
var
t, h, hic, reponse2 : String ;
i,j : Integer;
http: TIdHTTP;
FDQuery1: TFDQuery;
begin
http := TIdHTTP.Create(nil);

    try
      reponse2 := http.Get('http://192.168.20.124:80/?cmd=get');
      if reponse2 = 'err' then
      begin
           MessageBeep(MB_ICONEXCLAMATION);
           ShowMessage('VEUILLEZ REESSAYER ');
      end else if reponse2 = 'error' then
               begin
                  MessageBeep(MB_ICONERROR);
                  ShowMessage('TEMPERATURE ANORMALE, VERIFIEZ LE CAPTEUR OU LA RESISTANCE CHAUFFANTE ! ');
               end else begin
                    FDQuery1 := TFDQuery.Create(nil);
                    i := reponse2.IndexOf(':');
                    j := reponse2.IndexOf('!');
                    t := reponse2.Substring(0,i);
                    label12.Text := t;
                    h := reponse2.Substring(i+1,5);
                    label11.Text := h;
                    hic := reponse2.Substring(j+1);
                    label3.Text := hic;
                    try
                      FDQuery1.Connection := FDConnection1;
                      FDConnection1.Connected := True;
                      FDQuery1.SQL.Text := 'INSERT INTO TMP (DATE, TEMPERATURE, HUMIDITE, INDK) VALUES (:date, :temperature, :humidite, indk)';
                      FDQuery1.ParamByName('date').Value := Now;
                      FDQuery1.ParamByName('temperature').AsFloat := strToFloat(t);
                      FDQuery1.ParamByName('humidite').AsFloat := strToFloat(h);
                      FDQuery1.ParamByName('ondk').AsFloat := strToFloat(hic);
                      FDQuery1.ExecSQL;
                    finally
                      FDQuery1.Free;
                      FDConnection1.Connected := False;
                    end;

                    end;

    finally
      http.free;
    end;

end;

procedure TForm13.FinTemps(Sender: TObject);
begin
  Form13.Visible := true;
  Form14.Close;
end;

procedure TForm13.Splash(Sender: TObject);
begin
  Form14 := TForm14.Create(nil);
  FDConnection1 := TFDConnection.Create(nil);
  FDQuery1 := TFDQuery.Create(nil);

  if not DirectoryExists('C:\Users\Public\Documents\XTEMP') then
  begin
    if not CreateDir('C:\Users\Public\Documents\XTEMP') then
      ShowMessage('IMPOSSIBLE DE CREER VOTRE DOSSIER DE SAUVEGARDE, VEUILLEZ REDEMARRER L''APPLICATION !');
  end;

  if not TFile.Exists('C:\Users\Public\Documents\XTEMP\TMPDB.db') then begin
    TFile.Create('C:\Users\Public\Documents\XTEMP\TMPDB.db').free;
  end;

  try
    FDConnection1.Params.DriverID := 'SQLite';
    FDConnection1.Params.Database := 'C:\Users\Public\Documents\XTEMP\TMPDB.db';
    FDConnection1.Params.Add('OpenMode=CreateUTF8');
    FDConnection1.Connected := True;

    FDQuery1.Connection := FDConnection1;
    FDQuery1.SQL.Text := 'CREATE TABLE IF NOT EXISTS TMP ' +
                         '(id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
                         ' DATE DATETIME, ' +
                         ' TEMPERATURE REAL, ' +
                         ' HUMIDITE REAL, ' +
                         ' INDK REAL)';
    FDQuery1.ExecSQL;
  finally
    FDQuery1.Free;
    FDConnection1.Connected := False;
    FDConnection1.Free;
  end;

   Timer1.Interval := 5000;
   Form13.Visible := false;
   Form14.ShowModal;
end;


end.
