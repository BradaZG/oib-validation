create or replace function IS_VALID_OIB(oib_in in varchar2) return varchar2 IS 
  tmp number;
  kontrolni number;
  oib varchar2(11);
begin
  /* �i��enje - svo�enje OIB-a na 11 znakova */
  oib := LTRIM(RTRIM(oib_in, ' '), ' ');
  oib := substr(oib_in, 1, 11);
  oib := lpad(oib, 11, '0'); 
  /* 1. prva znamenka zbroji se s brojem 10 */
  tmp := 10;
  for i in 1 .. 10
  loop
    /* algoritam za provjeru */
    /* 5. slijede�a znamenka zbroji se s ostatkom u prethodnom koraku */
    tmp := tmp + to_number(substr(oib, i, 1));
    /* 2. dobiveni zbroj cjelobrojno (s ostatkom) podijeli se brojem 10; ako je dobiveni 
       ostatak 0 zamijeni se brojem 10 (ovaj broj je tzv. me�uostatak) */
    tmp := mod(tmp, 10);
    if tmp = 0 then 
      tmp := 10;
    end if;
    /* 3. dobiveni me�uostatak pomno�i se brojem 2 */
    tmp := tmp * 2;
    /* 4. dobiveni umno�ak cjelobrojno (s ostatkom) podijeli se brojem 11; ovaj ostatak
       matemati�ki nikako ne mo�e biti 0 jer je rezultat prethodnog koraka uvijek paran broj */
    tmp := mod(tmp, 11);
  end loop;
  /* 7. razlika izmenu broja 11 i ostatka u zadnjem koraku je kontrolna znamenka; ako je
       ostatak 1 kontrolna znamenka je 0 (11-1=10, a 10 ima dvije znamenke) */
  kontrolni := mod(11 - tmp, 10);
  
  if kontrolni = substr(oib, 11, 1) then
    return ('Y');
  else
    return ('N');
  end if;
  
  EXCEPTION WHEN OTHERS then
    return ('N');
END;