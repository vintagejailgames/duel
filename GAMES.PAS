unit games;

interface

{---------------------------------------------------------------------------}
{    coloca el caracter 'ch' en la posici¢ de pantalla definida en x i y    }
{---------------------------------------------------------------------------}
  procedure coloca(ch:char;atrib,x,y:byte);

{---------------------------------------------------------------------------}
{  guarda la informaci¢ de tots els car…cters de la pantalla en un vector   }
{---------------------------------------------------------------------------}
  function av(x,y:byte):char;

{---------------------------------------------------------------------------}
{   guarda la informaci¢ dels atributs de totes les posicions de pantalla   }
{---------------------------------------------------------------------------}
  function byt(x,y:byte): byte;

const
  tvideo= 2000; { Posicions que ocupa la pantalla      }
  n_bales= 5;

type
  bala=
    record
      x,y: byte;
      dx: shortint;
      dy: shortint;
      viu: boolean;
    end;

  cartutxera=
    record
      queden: 0..n_bales;
      total: array [1..n_bales] of bala;
    end;

  persona=
    record
      x: integer;     { coordenada x en el pl…        }
      y: integer;     { coordenada y en el pl…        }
      c: char;        { car…cter que la representa    }
      b: byte;        { color                         }
      dx: shortint;   { direcci¢ que ocupa en l'eix x }
      dy: shortint;   { direcci¢ que ocupa en l'eix y }
      viu: boolean;   { si est… viu o no              }
      vida: integer;  { els punts de vida que t‚      }
      auxC: char;
      auxFC: byte;
      auxFN: byte;
      car: cartutxera;
    end;

var
  top_m: integer;      { Fila on comen‡a el marge de dalt     }
  bottom_m: integer;   { Fila on acaba el marge de baix       }
  right_m: integer;    { Columna on acaba marge dret          }
  left_m: integer;     { Columna on comen‡a el marge esquerre }

implementation

type
  caracter=
    record
      car: char;
      att: byte;
    end;

  procedure coloca(ch:char;atrib,x,y:byte);
    var
      pantalla: array [1..tvideo] of caracter absolute $B800:0000;

    begin
      y:= y-1;
      if (y*right_m+x<=tvideo)
        then
          begin
            pantalla[y*right_m+x].car:= ch;
            pantalla[y*right_m+x].att:= atrib;
          end;
    end;

  function av(x,y:byte): char;
    var
      pantalla: array [1..tvideo] of caracter absolute $B800:0000;
      c: char;

    begin
      y:= y-1;
      c:= pantalla[y*right_m+x].car;
      av:= c;
    end;

  function byt(x,y:byte): byte;
    var
      pantalla: array [1..tvideo] of caracter absolute $B800:0000;
      c: byte;

    begin
      y:= y-1;
      c:= pantalla[y*right_m+x].att;
      byt:= c;
    end;

begin
  top_m:= 1;
  bottom_m:= 25;
  right_m:= 80;
  left_m:= 1;
end.