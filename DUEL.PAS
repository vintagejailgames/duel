program duel_en_ok_corral;

uses mon,crt,games,keyboard;

const

{ *************************************** }
{           CONSTANTS DEL JOC             }
{ *************************************** }

  x= '·';
  cx= $0c;
  m= 'ù';
  cm= $0f;
  s= 'ı';
  cs= $06;
  n_arbres= 7;
  arbre= '*';
  c_arbre= $02;
  pont= '∫';
  c_pont= $06;
  riu= '€';
  c_riu= $11;
  ample_max_munt= 9;
  ample_min_munt= 2;
  muntanya= '€';
  c_muntanya= $06;
  tunel_a= 'Ø';
  tunel_b= 'Æ';
  c_tunel= $6e;
  n_forats= 4;
  forat= '¯';
  c_forat= $6f;
  dinamita= '5';
  c_dinamita= $ce;
  mesbales= '!';
  c_mesbales= $8f;
  frase= 'Duel en ok corral (ascii-adventures in the far west) by MON ∏';
  frase2= 'Has mort, foraster';
  frase3= 'Eres un Cl°n ÷stbud, t°o';

type
  aux_obj_no_fr=
    record
      c: char;
      b: byte;
    end;
  objectes_no_franquejables= array [1..10] of aux_obj_no_fr;

  objectes=
    record
      x,y: byte;
      j: boolean;
    end;

var

{ *************************************** }
{           VARIABLES DEL JOC             }
{ *************************************** }

  i,j: byte;
  r,r1,r2: integer;

  bo: persona;
  malo: persona;
  serp1: persona;
  serp2: persona;
  serp3: persona;

  v: objectes_no_franquejables;

  bales: objectes;

{ *************************************** }
{         PROCEDIMENTS DEL JOC            }
{ *************************************** }

  procedure act_vida(p: persona);
    begin
      if (p.vida>= 10)
        then
          begin
            full(11,15);
            gotoxy(2,25);
            write(p.vida);
          end
        else
          if (p.vida>= 4)
            then
              begin
                full(11,15);
                gotoxy(2,25);
                write(' ',p.vida);
              end
            else
              begin
                full(11,31);
                gotoxy(2,25);
                write(' ',p.vida);
              end
    end;

  procedure up(var p: persona; v: objectes_no_franquejables);
    var
      i: integer;
      trobat: boolean;

    begin
      if (p.y>top_m+1)
        then
          begin
            trobat:= false;
            i:= 1;
            while not(trobat) and (i<=10) do
              begin
                if (av(p.x,p.y-1)= v[i].c) and (byt(p.x,p.y-1)= v[i].b) then trobat:= true;
                i:= i+1;
              end;
            if not(trobat)
              then
                begin
                  p.auxFN:= ((byt(p.x,p.y-1) shr 4) shl 4)+((p.b shl 4) shr 4);
                  coloca(p.auxC,p.auxFC,p.x,p.y); { restaura l'antic carÖcter  }
                  p.auxC:= av(p.x,p.y-1);
                  p.auxFC:= byt(p.x,p.y-1);
                  p.y:= p.y-1;
                  coloca(p.c,p.auxFN,p.x,p.y);    { coloca el ninot }
                  p.dy:= -1;
                  delay(10);
                end;
          end;
    end;

  procedure down(var p: persona; v: objectes_no_franquejables);
    var
      i: integer;
      trobat: boolean;

    begin
      if (p.y<bottom_m-1)
        then
          begin
            trobat:= false;
            i:= 1;
            while not(trobat) and (i<=10) do
              begin
                if (av(p.x,p.y+1)= v[i].c) and (byt(p.x,p.y+1)= v[i].b) then trobat:= true;
                i:= i+1;
              end;
            if not(trobat)
              then
                begin
                  p.auxFN:= ((byt(p.x,p.y+1) shr 4) shl 4)+((p.b shl 4) shr 4);
                  coloca(p.auxC,p.auxFC,p.x,p.y);
                  p.auxC:= av(p.x,p.y+1);
                  p.auxFC:= byt(p.x,p.y+1);
                  p.y:= p.y+1;
                  coloca(p.c,p.auxFN,p.x,p.y);
                  p.dy:= 1;
                  delay(10);
                end;
          end;
    end;

  procedure left(var p: persona; v: objectes_no_franquejables);
    var
      i: integer;
      trobat: boolean;

    begin
      if (p.x>left_m)
        then
          begin
            trobat:= false;
            i:= 1;
            while not(trobat) and (i<=10) do
              begin
                if (av(p.x-1,p.y)= v[i].c) and (byt(p.x-1,p.y)= v[i].b) then trobat:= true;
                i:= i+1;
              end;
            if not(trobat)
              then
                begin
                  p.auxFN:= ((byt(p.x-1,p.y) shr 4) shl 4)+((p.b shl 4) shr 4);
                  coloca(p.auxC,p.auxFC,p.x,p.y);
                  p.auxC:= av(p.x-1,p.y);
                  p.auxFC:= byt(p.x-1,p.y);
                  p.x:= p.x-1;
                  coloca(p.c,p.auxFN,p.x,p.y);
                  p.dx:= -1;
                  delay(10);
                end;
          end;
    end;

  procedure right(var p: persona; v: objectes_no_franquejables);
    var
      i: integer;
      trobat: boolean;

    begin
      if (p.x<right_m)
        then
          begin
            trobat:= false;
            i:= 1;
            while not(trobat) and (i<=10) do
              begin
                if (av(p.x+1,p.y)= v[i].c) and (byt(p.x+1,p.y)= v[i].b) then trobat:= true;
                i:= i+1;
              end;
            if not(trobat)
              then
                begin
                  p.auxFN:= ((byt(p.x+1,p.y) shr 4) shl 4)+((p.b shl 4) shr 4);
                  coloca(p.auxC,p.auxFC,p.x,p.y);
                  p.auxC:= av(p.x+1,p.y);
                  p.auxFC:= byt(p.x+1,p.y);
                  p.x:= p.x+1;
                  coloca(p.c,p.auxFN,p.x,p.y);
                  p.dx:= 1;
                  delay(10);
                end;
          end;
    end;

  procedure moure_serp(var serp: persona; v: objectes_no_franquejables);
    begin
      r:= random(4);
      case r of
        0: up(serp,v);
        1: down(serp,v);
        2: left(serp,v);
        3: right(serp,v);
      end;
    end;

  procedure dispara(var p: persona);
    begin
      if (p.car.queden > 0)
        then
          begin
            beep;
            p.car.queden:= p.car.queden-1;
            p.car.total[p.car.queden+1].viu:= true;
            p.car.total[p.car.queden+1].dx:= p.dx;
            p.car.total[p.car.queden+1].dy:= p.dy;
          end;
    end;

  procedure mes_bales(var m: objectes);
    begin
      repeat
        r1:= random(43)+22;
        r2:= random(23)+2;
      until (av(r1,r2)= ' ');
      coloca(mesbales,c_mesbales,r1,r2);
      m.x:= r1;
      m.y:= r2;
      m.j:= false;
    end;

  procedure arreplega_mes_bales(var p: persona; var m: objectes);
    begin
      beep;
      m.x:= 0;
      m.y:= 0;
      m.j:= true;
      p.car.queden:= n_bales;
      p.auxC:= ' ';
      p.auxFC:= $00;
    end;

  procedure sortida;
    begin
      FreeKb;
      mc;
      halt;
    end;

  procedure mort;
    begin
      full(0,31);
      gotoxy((80-length(frase2)) div 2,13);
      write(frase2);
      delay(1500);
      sortida;
    end;

  procedure guanyes;
    begin
      full(0,31);
      gotoxy((80-length(frase3)) div 2,13);
      write(frase3);
      delay(1500);
      sortida;
    end;


  procedure lleva_vida(var p: persona);
    begin
      if (p.vida> 0) then p.vida:= p.vida-1;
      if (p.vida= 0) then p.viu:= false;
      act_vida(p);
      delay(50);
    end;

begin
{ *************************************** }
{         INICIACI‡ DE FUNCIONS           }
{        NECESSARIES PER  AL JOC          }
{ *************************************** }

 Randomize;  { INICIACI‡ DEL GENERADOR DE Nos. ALEATORIS }
 HookKb;     {  INICIACI‡ DE LA INTERRUPCI‡ DEL TECLAT   }
 ac;         {               AMAGA EL CURSOR             }

{ *************************************** }
{       PREPARA LA PANTALLA DEL JOC       }
{ *************************************** }

  full(0,7);
  cls;

{ *************************************** }
{             T÷TOL SUPERIOR              }
{ *************************************** }

  fons(11);
  gotoxy(1,top_m); clreol;
  gotoxy(1,bottom_m); clreol;
  color(15);
  gotoxy((80-length(frase)) div 2,1);
  write(frase);

{ *************************************** }
{               MUNTANYA A                }
{ *************************************** }

  for i:= top_m+1 to bottom_m-1 do
    begin
      j:= 0;
      r:= random(ample_max_munt)+ample_min_munt;
      repeat
        coloca(muntanya,c_muntanya,11+j,i);
        j:= j+1;
      until j= r;
    end;

{ *************************************** }
{                TUNEL A                  }
{ *************************************** }

  repeat
    r:= random(21)+3;
  until (av(11,r)= muntanya);
  for i:= 1 to ample_max_munt+1 do
    begin
      if (av(10+i,r+1)= muntanya) or (av(10+i,r+1)= forat)
        then coloca(tunel_a,c_tunel,10+i,r+1);
      if (av(10+i,r-1)= muntanya) or (av(10+i,r-1)= forat)
        then coloca(tunel_a,c_tunel,10+i,r-1);
      coloca(' ',0,10+i,r);
    end;

{ *************************************** }
{                FORATS A                 }
{ *************************************** }

    for i:= 1 to n_forats do
    begin
      repeat
        r:= random(23)+2;
      until (av(11,r)= muntanya);
      coloca(forat,c_forat,11,r);
    end;

{ *************************************** }
{               MUNTANYA B                }
{ *************************************** }

  for i:= top_m+1 to bottom_m-1 do
    begin
      j:= 0;
      r:= random(ample_max_munt)+ample_min_munt;
      repeat
        coloca(muntanya,c_muntanya,64+(6-j),i);
        j:= j+1;
      until j= r;
    end;

{ *************************************** }
{                TUNEL B                  }
{ *************************************** }

  repeat
    r:= random(21)+3;
  until (av(70,r)= muntanya);r:= random(22)+2;
  for i:= 1 to ample_max_munt+1 do
    begin
      if (av(60+i,r+1)= muntanya) or (av(60+i,r+1)= forat)
        then coloca(tunel_b,c_tunel,60+i,r+1);
      if (av(60+i,r-1)= muntanya) or (av(60+i,r-1)= forat)
        then coloca(tunel_b,c_tunel,60+i,r-1);
      coloca(' ',0,60+i,r);
    end;

{ *************************************** }
{                FORATS B                 }
{ *************************************** }

    for i:= 1 to n_forats do
    begin
      repeat
        r:= random(23)+2;
      until (av(70,r)= muntanya);
      coloca(forat,c_forat,70,r);
    end;

{ *************************************** }
{                  RIU                    }
{ *************************************** }

  for i:= top_m+1 to bottom_m-1 do
    begin
      j:= 0;
      r:= random(3)+3;
      repeat
        coloca(riu,c_riu,40-(r div 2)+j,i);
        j:= j+1;
      until j= r;
    end;

{ *************************************** }
{                  PONT                   }
{ *************************************** }

  r:= random(10)+10;
  for i:= 1 to 8 do coloca(pont,c_pont,36+i-1,r);

{ *************************************** }
{                 ARBRES                  }
{ *************************************** }

  for i:= 1 to n_arbres do
    begin
      repeat
        r1:= random(43)+22;
        r2:= random(23)+2;
      until (av(r1,r2)= ' ');
      coloca(arbre,c_arbre,r1,r2);
    end;

{ *************************************** }
{         INICIACI‡ DELS NINOTS           }
{         I D'„STIES CONSAGRAES           }
{ *************************************** }

  bo.x:= random(10)+1;
  bo.y:= random(23)+2;
  bo.c:= x;
  bo.b:= cx;
  bo.dx:= 1;
  bo.dy:= 0;
  bo.auxC:= ' ';
  bo.auxFC:= $00;
  bo.vida:= 10;
  bo.viu:= true;
  bo.car.queden:= n_bales;
  for i:= 1 to n_bales do bo.car.total[i].viu:= false;

  malo.x:= random(10)+71;
  malo.y:= random(23)+2;
  malo.c:= m;
  malo.b:= cm;
  malo.dx:= 1;
  malo.dy:= 0;
  malo.vida:= 10;
  malo.viu:= true;
  malo.car.queden:= n_bales;
  for i:= 1 to n_bales do malo.car.total[i].viu:= false;

  repeat
    serp1.x:= random(44)+16;
    serp1.y:= random(23)+2;
  until (av(serp1.x,serp1.y)= ' ');
  serp1.c:= s;
  serp1.b:= cs;
  serp1.vida:= 2;

  repeat
    serp2.x:= random(44)+16;
    serp2.y:= random(23)+2;
  until (av(serp2.x,serp2.y)= ' ');
  serp2.c:= s;
  serp2.b:= cs;
  serp2.vida:= 2;

  repeat
    serp3.x:= random(44)+16;
    serp3.y:= random(23)+2;
  until (av(serp3.x,serp3.y)= ' ');
  serp3.c:= s;
  serp3.b:= cs;
  serp3.vida:= 2;

  v[1].c:= arbre;
  v[1].b:= c_arbre;
  v[2].c:= muntanya;
  v[2].b:= c_muntanya;
  v[3].c:= forat;
  v[3].b:= c_forat;
  v[4].c:= x;
  v[4].b:= cx;
  v[5].c:= m;
  v[5].b:= cm;
  v[6].c:= tunel_a;
  v[6].b:= c_tunel;
  v[7].c:= tunel_b;
  v[7].b:= c_tunel;
  v[8].c:= s;
  v[8].b:= cs;

  bales.j:= true;

{ *************************************** }
{      COL.LOCACI‡ DELS PERSONATGES       }
{               EN PANTALLA               }
{ *************************************** }

  coloca(bo.c,bo.b,bo.x,bo.y);
  coloca(malo.c,malo.b,malo.x,malo.y);
  coloca(serp1.c,serp1.b,serp1.x,serp1.y);
  coloca(serp2.c,serp2.b,serp2.x,serp2.y);
  coloca(serp3.c,serp3.b,serp3.x,serp3.y);
  act_vida(bo);

{ *************************************** }
{        MOVIMENTS DELS PERSONATGES       }
{ *************************************** }

  while (bo.viu) and (malo.viu) do
   begin

    if keypress($10) then up(bo,v);
    if keypress($1e) then down(bo,v);
    if keypress($18) then left(bo,v);
    if keypress($19) then right(bo,v);

    if keypress($38) then dispara(bo);

    moure_serp(serp1,v);
    moure_serp(serp2,v);
    moure_serp(serp3,v);

{    if keypress($18) then up(malo,v);
    if keypress($26) then down(malo,v);
    if keypress($34) then left(malo,v);
    if keypress($35) then right(malo,v);}

    if keypress($01) then sortida;

    if ( (bo.car.queden= 0) or (malo.car.queden= 0) ) and (bales.j= true) then mes_bales(bales);

    if (bo.x= bales.x) and (bo.y= bales.y) then arreplega_mes_bales(bo,bales);
    if (malo.x= bales.x) and (malo.y= bales.y) then arreplega_mes_bales(malo,bales);

    if (bo.auxC= riu) and (bo.auxFC= c_riu) then lleva_vida(bo);
    if (malo.auxC= riu) and (malo.auxFC= c_riu) then lleva_vida(malo);

  { Q:     $10 }
  { A:     $1e }
  { O:     $18 }
  { P:     $19 }
  { Alt:   $38 }
  { Space: $39 }

  { ESC:   $01 }

   end;

   if not(bo.viu) then mort;
   if not(malo.viu) then guanyes;

end.


