-- Function: _replica.zfCalc_Text_replace

DROP FUNCTION IF EXISTS _replica.zfCalc_Text_replace (Text, Text, Text);

CREATE OR REPLACE FUNCTION _replica.zfCalc_Text_replace(
    IN inText        Text,
    IN inFromText    Text,
    IN inToText      Text
)
RETURNS Text
AS
$BODY$
   DECLARE vbIndex  Integer;
BEGIN

    -- RETURN REPLACE (inText, inFromText, inToText);

    vbIndex:= POSITION (LOWER (inFromText) IN LOWER (inText));
    
    IF vbIndex > 0
    THEN
        inText:= OVERLAY (inText PLACING COALESCE (inToText, '') FROM vbIndex FOR LENGTH (inFromText));
        --
        IF POSITION (LOWER (inFromText) IN LOWER (inText)) > 0
        THEN RETURN _replica.zfCalc_Text_replace(inText,inFromText, inToText);
        ELSE RETURN inText;
        END IF;
        
    ELSE
        RETURN inText;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.03.19                                        *
*/

-- тест
-- SELECT * FROM _replica.zfCalc_Text_replace ('123aaa456', 'aaa', '0'), REPLACE ('123aaa456', 'aaa', '0');
