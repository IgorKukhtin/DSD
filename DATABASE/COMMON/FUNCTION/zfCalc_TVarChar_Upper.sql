-- Function: zfCalc_TVarChar_Upper

DROP FUNCTION IF EXISTS zfCalc_TVarChar_Upper (TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_TVarChar_Upper(
    IN inText        TVarChar
    )
RETURNS Text
AS
$BODY$
   DECLARE vbIndex  Integer;
   DECLARE vbText   TVarChar;
   DECLARE vbChar   Integer;
BEGIN

  vbText := '';

  -- ïàðñèì
  vbIndex := 1;
  WHILE SUBSTRING (inText, vbIndex, 1) <> '' LOOP

     vbChar :=  ascii(SUBSTRING (inText, vbIndex, 1));

     IF vbChar >= 1072 AND vbChar <= 1103  -- À...ß
     THEN
       vbText := vbText || Chr(vbChar - 32);
     ELSEIF vbChar = 1105 -- ¨
     THEN
       vbText := vbText || Chr(1025);
     ELSEIF vbChar = 1108 -- ª
     THEN
       vbText := vbText || Chr(1028);
     ELSEIF vbChar = 1110 -- ²
     THEN
       vbText := vbText || Chr(1030);
     ELSEIF vbChar = 1111 -- ¯
     THEN
       vbText := vbText || Chr(1031);
     ELSEIF vbChar = 1168 -- 1168
     THEN
       vbText := vbText || Chr(1169);
     ELSE
       vbText := vbText || UPPER(Chr(vbChar));
     END IF;

     -- òåïåðü ñëåäóþþùèé
     vbIndex := vbIndex + 1;
  END LOOP;

  RETURN vbText;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.   Øàáëèé Î.Â.
 21.12.20                                                       *
*/

select * from zfCalc_TVarChar_Upper('Êîðâàëîë rRdD ´³¿¸º')