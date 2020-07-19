-- Function: _replica.zfCalc_WordText_Split_replica

DROP FUNCTION IF EXISTS _replica.zfCalc_WordText_Split_replica (Text, Integer);

CREATE OR REPLACE FUNCTION _replica.zfCalc_WordText_Split_replica(
    IN inValue Text,
    IN inIndex Integer
)
RETURNS Text
AS
$BODY$
   DECLARE vbResult TVarChar;
   DECLARE vbIndex Integer;
   DECLARE vbIndex_find Integer;
BEGIN
    vbIndex:= 1;
    vbIndex_find:= 0;
 
    inValue := REPLACE (REPLACE (inValue,'{',''), '}','');
        -- старт
        WHILE vbIndex <= LENGTH (inValue) AND vbIndex_find <> inIndex
        LOOP
           IF TRIM (SPLIT_PART (inValue, ',', vbIndex)) <> ''
           THEN vbIndex_find:= vbIndex_find + 1; -- нашли не пустое слово
           END IF;

           IF vbIndex_find = inIndex
           THEN vbResult:= TRIM (SPLIT_PART (inValue, ',', vbIndex)); -- это то слово что надо
           END IF;

            -- теперь следуюющий
            vbIndex := vbIndex + 1;
        END LOOP;
 
    RETURN COALESCE (vbResult, '');

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.07.20         *
*/

-- тест
-- SELECT * FROM _replica.zfCalc_WordText_Split_replica (inValue:= '{1 ,2} ', inIndex:= 1)
