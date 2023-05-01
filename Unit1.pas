unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, Unit13;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    procedure ferME(Sender: TObject; var Action: TCloseAction);

  private
    { Déclarations privées }
  public
    { Déclarations publiques }

  end;

var
  Form1: TForm1;

implementation


{$R *.fmx}
procedure TForm1.ferME(Sender: TObject; var Action: TCloseAction);
begin
 Form1.ADOConnection1.Connected := False;
end;



begin
Form1.ADOConnection1.ConnectionString := 'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=C:\Users\Public\Documents\XTEMP\TMPDB.accdb';
Form1.ADOConnection1.Connected := True;


Form1.ADOQuery1.SQL.Text := 'SELECT Date, Temperature, Humidite, IndK FROM TMP';
Form1.ADOQuery1.Open;

while not Form1.ADOQuery1.Eof do
begin
  Form1.Memo1.Lines.Add(Format('%s --> Temperature : %f; Humidité : %f; Indice K : %f ', [Form1.ADOQuery1.FieldByName('Date').AsString, Form1.ADOQuery1.FieldByName('Temperature').AsFloat, Form1.ADOQuery1.FieldByName('Humidite').AsFloat, Form1.ADOQuery1.FieldByName('IndK').AsFloat]));
  Form1.ADOQuery1.Next;
end;

Form1.ADOQuery1.Close;


end.
