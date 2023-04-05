
unit Unit13;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Unit14,
  FMX.StdCtrls, FMX.Layouts, FMX.ExtCtrls, FMX.Controls.Presentation,
  FMX.ListBox, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, FMX.Edit;

  type
  TForm13 = class(TForm)
    Timer1: TTimer;
    Layout1: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    IdHTTP1: TIdHTTP;
    GroupBox1: TGroupBox;
    ImageViewer1: TImageViewer;
    Label4: TLabel;
    Label5: TLabel;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    GroupBox2: TGroupBox;
    Button3: TButton;
    Label7: TLabel;
    ImageViewer2: TImageViewer;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    procedure Splash(Sender: TObject);
    procedure FinTemps(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form13: TForm13;

implementation
var Form14 : TForm14;

{$R *.fmx}

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
     t2 := edit1.Text;
    try
      reponse1 := http.Get('http://192.168.20.124:80/d?rtmp=t1:t2');
      if reponse1 = 'OK' then showMessage('Paramétrage réussi');

    finally
      http.free;
    end;
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
   Timer1.Interval := 5000;
   Form13.Visible := false;
   Form14.ShowModal;
end;

end.
