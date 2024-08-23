-- Function: zfSelect_Word_Split

DROP FUNCTION IF EXISTS zfSelect_Word_Split (TVarChar, Integer);
DROP FUNCTION IF EXISTS zfSelect_Word_Split (TVarChar, Boolean, Integer);

CREATE OR REPLACE FUNCTION zfSelect_Word_Split(
    IN inSep      TVarChar,
    IN inIsPromo  Boolean DEFAULT FALSE,
    IN inUserId   Integer DEFAULT 0       -- пользователь
)
RETURNS TABLE (Ord Integer, Word TVarChar, WordList TVarChar
              )
AS
$BODY$
   DECLARE vbIndex Integer;
   DECLARE vbWordList TVarChar;
   DECLARE curWord_Split CURSOR FOR SELECT _tmpWord_Split_from.WordList FROM _tmpWord_Split_from;
BEGIN
   

     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE LOWER (TABLE_NAME) = LOWER ('_tmpWord_Split_from'))
     THEN
         CREATE TEMP TABLE _tmpWord_Split_from (WordList TVarChar) ON COMMIT DROP;
         -- INSERT INTO _tmpWord_Split_from (WordList) SELECT '8347, 8352';
         
         IF inIsPromo = TRUE
         THEN
            INSERT INTO _tmpWord_Split_from (WordList)
            SELECT DISTINCT ObjectString_GoodsKind.ValueData AS WordList
            FROM ObjectString AS ObjectString_GoodsKind
            WHERE ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListSale_GoodsKind()
              AND ObjectString_GoodsKind.ValueData <> '';
         END IF;
         
     END IF;

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE LOWER (TABLE_NAME) = LOWER ('_tmpWord_Split_to'))
     THEN
         DELETE FROM _tmpWord_Split_to;
     ELSE
         CREATE TEMP TABLE _tmpWord_Split_to (Ord Integer, Word TVarChar, WordList TVarChar) ON COMMIT DROP;
     END IF;


     OPEN curWord_Split;
     LOOP
         FETCH curWord_Split INTO vbWordList;
         IF NOT FOUND THEN EXIT; END IF;

         -- парсим 
         vbIndex := 1;
         WHILE SPLIT_PART (vbWordList, inSep, vbIndex) <> '' LOOP
             -- добавляем то что нашли
             INSERT INTO _tmpWord_Split_to (Ord, Word, WordList) SELECT vbIndex, TRIM (SPLIT_PART (vbWordList, inSep, vbIndex)), vbWordList;
             -- теперь следуюющий
             vbIndex := vbIndex + 1;
         END LOOP;

     END LOOP;
     CLOSE curWord_Split;
     
     IF inIsPromo = TRUE
     THEN
         -- Реальная таблица
         TRUNCATE TABLE _tmpWord_Split_to_promo;
         -- Реальная таблица
         INSERT INTO _tmpWord_Split_to_promo (Ord, Word, WordList)
            SELECT _tmpWord_Split_to.Ord, _tmpWord_Split_to.Word, _tmpWord_Split_to.WordList FROM _tmpWord_Split_to;
     END IF;

  
     -- Результат
     RETURN QUERY
       SELECT _tmpWord_Split_to.Ord, _tmpWord_Split_to.Word, _tmpWord_Split_to.WordList FROM _tmpWord_Split_to;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.12.16                                        *
*/

-- тест
-- SELECT * FROM zfSelect_Word_Split (inSep:= ',', inIsPromo:= TRUE, inUserId:= zfCalc_UserAdmin() :: Integer);
