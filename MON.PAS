unit mon;  { Versi¢ 1.0 }

{ Aquesta unit la faig per a estalviar minuts davant del teclat cada vegada }
{ que intente fer un programa. Inclou procediments que fan seqŠncies       }
{ d'instruccions que s'utilitzen prou sovint, aix¡ s'estalvia temps i       }
{ escriptura. Tamb‚ inclou alguns procediments amb el nom m‚s curt que      }
{ que l'original.                                                           }
{ ------------------------------------------------------------------------- }
{ VIDEU: un vector de 2000 QUADRETs (en mode 80x25 la pantalla t‚ 2000      }
{        caracters, quan vulgam accedir a una posici¢ de la pantalla per a  }
{        saber que cont‚, per exemple, utilitzarem la variable VIDEU.       }
{ ------------------------------------------------------------------------- }
{ PANTALLA: prepara la pantalla per als programes. Els par…metres que se li }
{           donen fan referŠncia, respectivament, al mode de text, color de }
{           fons de la pantalla i color del text.                           }
{ FONS: ‚s el mateix que TEXTBACKGROUND, per• aix¡ t‚ un nom m‚s curt.      }
{ MODE: ‚s el mateix que TEXTMODE, per• aix¡ t‚ un nom m‚s curt.            }
{ COLOR: ‚s el mateix que TEXTCOLOR, per• aix¡ t‚ un nom m‚s curt.          }
{ FULL: prepara la p…gina amb un color de fons i de tinta.                  }
{ ALDOS: estableix el mode de text, fons de pantalla i color de text que t‚ }
{        normalment el DOS per a poder eixir del programa.                  }
{ STOP: atura el programa fins que pulsem una tecla.                        }
{ AC: amaga el cursor, l'ha fet Vialgon en ensamblador.                     }
{ MC: mostra el cursor, l'ha fet Vialgon en ensamblador.                    }
{ BBT: borra el buffer del teclat, l'ha fet Pepe en ensamblador.            }
{ SPC: escriu x espais.                                                     }
{ MAKEWINDOW: crea una finestra de fons a i tinta b.                        }
{ INTRONUM: per a introduir un n£mero evitant cometre run time error si     }
{           posem una lletra.                                               }
{ SWAP: per a intercanviar el valor de dues variables. L'he fet jo gr…cies  }
{       als coneixements adquirits en AD1.                                  }
{ BEEP: emet un beep per l'speaker del catxarret.                           }
{ ------------------------------------------------------------------------- }
{ Par…metres per al mode de video:                                          }
{                                                                           }
{   0: 40x25 b/n        CGA                                                 }
{   1: 40x25 color      CGA                                                 }
{   2: 80x25 b/n        CGA                                                 }
{   3: 80x25 color      CGA                                                 }
{   7: 80x25 b/n        HGC                                                 }
{ 256: 43/50 lines      EGA/VGA                                             }
{ 258: 640x400 pixels   mola un pu¤ao                                       }
{ ------------------------------------------------------------------------- }
{ Par…metres per al fons de pantalla i color de text                        }
{                                                                           }
{   0: negre                             8: gris obscur                     }
{   1: blau                              9: blau brillant                   }
{   2: verd                             10: verd brillant                   }
{   3: cian                             11: cian brillant                   }
{   4: roig                             12: roig brillant                   }
{   5: magenta                          13: magenta brillant                }
{   6: marr¢                            14: groc                            }
{   7: gris brillant                    15: blanc                           }
{                                                                           }
{  La primera columna es pot utilitzar tant per a color de text com de fons }
{  La segona columna nom‚s es pot utilitzar per a color de text             }
{ ------------------------------------------------------------------------- }

interface

  var
    videu: array [1..6000] of word absolute $b800:0000;

  function xy2(x,y: integer): integer;
  procedure pantalla(a,b,c: integer);
  procedure fons(a: integer);
  procedure mode(a: integer);
  procedure color(a: integer);
  procedure full(f,t: integer);
  procedure cls;
  procedure aldos;
  procedure stop;
  procedure ac;
  procedure mc;
  procedure bbt;
  procedure spc(x: integer);
  procedure intronum(var x: integer);
  procedure swap(var x,y: integer);
  procedure beep;

implementation

  uses crt;

  function xy2(x,y: integer): integer;
    begin
      xy2:= x+(80*(y-1));
    end;

  procedure pantalla(a,b,c: integer);
    begin
       textmode(a);
       textbackground(b);
       textcolor(c);
       clrscr;
    end;

  procedure fons(a: integer);
    begin
      textbackground(a);
    end;

  procedure mode(a: integer);
    begin
      textmode(a);
    end;

  procedure color(a: integer);
    begin
      textcolor(a);
    end;

  procedure full(f,t: integer);
    begin
      fons(f);
      color(t);
    end;

  procedure cls;
    begin
      clrscr;
    end;

  procedure aldos;
    begin
      pantalla(3,0,7);
    end;

  procedure stop;
    begin
      repeat
      until keypressed;
    end;

  procedure ac;
    begin
      asm
        push ax;
        push cx;
        mov ah,1;
        mov ch,4;
        mov cl,0;
        int $10;
        pop cx;
        pop ax;
      end;
    end;

  procedure mc;
    begin
      asm
        push ax;
        push cx;
        mov ah,1;
        mov ch,0;
        mov cl,1;
        int $10;
        pop cx;
        pop ax;
      end;
    end;

  procedure bbt;
    begin
      asm
        xor ah,ah;
        int 16h;
      end;
    end;

  procedure spc(x: integer);
    var
      i: integer;

    begin
      for i:= 1 to x do write(' ');
    end;

  procedure intronum(var x: integer);
    var
      s: string;
      i,pot,j: integer;
      ch: char;

    begin
      s[0]:= chr(0);
      x:= 0;
      i:= 1;
      repeat
        ch:= readkey;
        case ord(ch) of
          48..57:
            begin
              write(ch);
              s[i]:= ch;
              s[0]:= chr(i);
              i:= i+1;
            end;
          8:
            if ord(s[0])> 0 then
              begin
                write(ch,' ',ch);
                i:= i-1;
                s[0]:= chr(ord(s[0])-1);
              end;
        end;
      until (ord(ch)= 13) and (ord(s[0])> 0);
      for i:= 1 to ord(s[0]) do begin
        pot:=1;
        for j:=1 to (ord(s[0])-i) do pot:=pot*10;
        x:= x+((ord(s[i])-48)*pot);
      end;
    end;

  procedure swap(var x,y: integer);
    var
      aux: integer;

    begin
      aux:= x;
      x:= y;
      y:= aux;
    end;

  procedure beep;
    begin
      sound(200);
      delay(200);
      nosound;
    end;

end.