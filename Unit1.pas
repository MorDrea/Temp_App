unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, Data.DB, Data.Win.ADODB,
  Datasnap.Provider, Datasnap.DBClient, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    procedure FERME(Sender: TObject; var Action: TCloseAction);

  private
    { Déclarations privées }
  public
    { Déclarations publiques }

  end;

var
  Form1: TForm1;

implementation


{$R *.fmx}
procedure TForm1.FERME(Sender: TObject; var Action: TCloseAction);
begin
   Form1.FDConnection1.Connected := False;
end;

begin
    Form1.FDConnection1 := TFDConnection.Create(nil);
    Form1.FDQuery1 := TFDQuery.Create(nil);
    Form1.FDConnection1.Params.DriverID := 'SQLite';
    Form1.FDConnection1.Params.Database := 'C:\Users\Public\Documents\XTEMP\TMPDB.db';
    Form1.FDConnection1.Params.Add('OpenMode=CreateUTF8');
    Form1.FDConnection1.Connected := True;
if Form1.FDConnection1.Connected then
begin
  Form1.FDQuery1.Connection := Form1.FDConnection1;
  Form1.FDQuery1.SQL.Text := 'SELECT * FROM TMP';
  Form1.FDQuery1.Open;
  Form1.Memo1.Lines.Clear;
  while not Form1.FDQuery1.Eof do
  begin
    Form1.Memo1.Lines.Add(Form1.FDQuery1.FieldByName('id').AsString + ' : ' +
                    'Date: ' + Form1.FDQuery1.FieldByName('DATE').AsString + '  -->  ' +
                    'Temperature : ' + Form1.FDQuery1.FieldByName('TEMPERATURE').AsString + ', ' +
                    'Humidite : ' + Form1.FDQuery1.FieldByName('HUMIDITE').AsString + ', ' +
                    'Indice K : ' + Form1.FDQuery1.FieldByName('INDK').AsString);
    Form1.FDQuery1.Next;
  end;
  Form1.FDQuery1.Close;
  Form1.FDConnection1.Connected := False;
end;



end.
