
unit Unit13;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Unit14, Unit1,
  FMX.StdCtrls, FMX.Layouts, FMX.ExtCtrls, FMX.Controls.Presentation,
  FMX.ListBox, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, FMX.Edit, Datasnap.DBClient, Datasnap.Provider, Data.DB,
  Data.Win.ADODB;

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
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    DataSetProvider1: TDataSetProvider;
    ClientDataSet1: TClientDataSet;
    Button1: TButton;
    procedure Splash(Sender: TObject);
    procedure FinTemps(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure closeMe(Sender: TObject; var Action: TCloseAction);
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
begin
ADOQuery1.SQL.Text := 'SELECT COUNT(*) FROM TMP';
try
  ADOQuery1.Open;
  if ADOQuery1.Fields[0].AsInteger = 0 then
  begin
    ShowMessage('AUCUNE DONNEE ENREGISTREE !');
  end else begin

  end;
  ADOQuery1.Close;
except
  on E:Exception do
  begin
    if Pos('Table not found', E.Message) > 0 then
    begin
      ShowMessage('ERREUR RENCONTREE, VEUILLEZ REDEMARRER L''APPLICATION !');
    end
    else
    begin
      Form1.Show;
    end;
  end;
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
                    i := reponse2.IndexOf(':');
                    j := reponse2.IndexOf('!');
                    t := reponse2.Substring(0,i);
                    label12.Text := t;
                    h := reponse2.Substring(i+1,5);
                    label11.Text := h;
                    hic := reponse2.Substring(j+1);
                    label3.Text := hic;

    finally
      http.free;
    end;

    end;

    // Insérez les données de température dans la table de la base de données
ADOQuery1.SQL.Text := 'INSERT INTO TMP (Date, Temperature, Humidite, IndK) VALUES (:date, :temperature, :humidite, :indk)';
ADOQuery1.Parameters.ParamByName('date').Value := Now;
ADOQuery1.Parameters.ParamByName('temperature').Value := strToFloat(t);
ADOQuery1.Parameters.ParamByName('humidite').Value := strToFloat(h);
ADOQuery1.Parameters.ParamByName('indk').Value := strToFloat(hic);
ADOQuery1.ExecSQL;
end;

procedure TForm13.closeMe(Sender: TObject; var Action: TCloseAction);
begin
ADOConnection1.Connected := False;
end;

procedure TForm13.FinTemps(Sender: TObject);
begin
  Form13.Visible := true;
  Form14.Close;

  if not DirectoryExists('C:\Users\Public\Documents\XTEMP') then
begin
  if not CreateDir('C:\Users\Public\Documents\XTEMP') then
    ShowMessage('Erreur lors de la création du dossier');
end;

ADOConnection1.ConnectionString := 'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=C:\Users\Public\Documents\XTEMP\TMPDB.accdb';
ADOConnection1.Connected := True;

// Créez une requête SQL pour créer une table de température dans la base de données
ADOQuery1.SQL.Text := 'CREATE TABLE IF NOT EXISTS TMP (Date DATETIME, Temperature FLOAT, Humidite FLOAT, IndK FLOAT)';
ADOQuery1.ExecSQL;
end;

procedure TForm13.Splash(Sender: TObject);
begin
  Form14 := TForm14.Create(nil);
   Timer1.Interval := 5000;
   Form13.Visible := false;
   Form14.ShowModal;
end;

end.
