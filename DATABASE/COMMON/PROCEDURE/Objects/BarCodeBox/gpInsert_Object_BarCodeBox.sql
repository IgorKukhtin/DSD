-- Function: gpInsert_Object_BarCodeBox (Integer, Integer, TVarChar, TFloat, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsert_Object_BarCodeBox (Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_BarCodeBox(
    IN inBoxId          Integer  , -- ссылка на Ящик
    IN inBarCode1       Integer  , -- 
    IN inBarCode2       Integer  , --   
    IN inBarCodePref    TVarChar , -- 
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbCode_calc Integer;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_BarCodeBox());
   vbUserId:= lpGetUserBySession (inSession);


   PERFORM gpInsertUpdate_Object_BarCodeBox(ioId         := 0
                                          , inCode       := lfGet_ObjectCode(0, zc_Object_BarCodeBox()) :: Integer
                                          , inBarCode    := tmpNew.BarCode   :: TVarChar
                                          , inWeight     := 0                :: TFloat
                                          , inAmountPrint:= 2                :: TFloat
                                          , inBoxId      := inBoxId          :: Integer
                                          , inSession    := inSession        :: TVarChar
                                           ) 
   FROM (SELECT inBarCodePref || REPEAT ('0', 5 - LENGTH (tmp.Num :: TVarChar) ) || tmp.Num :: TVarChar AS BarCode
         FROM (SELECT GENERATE_SERIES (inBarCode1, inBarCode2) as Num) as tmp
         ) AS tmpNew 

       LEFT JOIN (SELECT Object_BarCodeBox.ValueData     AS BarCode
                  FROM Object AS Object_BarCodeBox
                  WHERE Object_BarCodeBox.DescId = zc_Object_BarCodeBox()
                    AND Object_BarCodeBox.isErased  = FALSE
                 ) AS tmpBarCode ON tmpBarCode.BarCode = tmpNew.BarCode
   WHERE tmpBarCode.BarCode IS NULL;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.04.20         *
*/

-- тест
-- SELECT * FROM gpInsert_Object_BarCodeBox()
