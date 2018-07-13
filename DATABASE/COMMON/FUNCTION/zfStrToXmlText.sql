-- Function: zfStrToXmlText

-- DROP FUNCTION IF EXISTS zfStrToXmlText (Text);

CREATE OR REPLACE FUNCTION zfStrToXmlText(inStr Text)
RETURNS Text AS
$BODY$
  DECLARE Res Text;
BEGIN
  Res := replace(inStr, '&', '&amp;');
  Res := replace(Res, '''', '&apos;');
  Res := replace(Res, '"', '&quot;');
  Res := replace(Res, '<', '&lt;');
  Res := replace(Res, '>', '&gt;');
  RETURN Res;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfStrToXmlText (Text) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ÿ‡·ÎËÈ Œ.¬.
  10.07.18       *  
*/

-- ÚÂÒÚ
-- SELECT * FROM zfStrToXmlText ('TVarChar')
-- SELECT * FROM zfStrToXmlText ('10')
