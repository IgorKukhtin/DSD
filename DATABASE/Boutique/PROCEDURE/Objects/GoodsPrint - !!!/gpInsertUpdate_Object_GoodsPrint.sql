-- Function: gpInsertUpdate_Object_GoodsPrint (Integer, Integer, Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPrint (Integer, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPrint (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPrint(
 INOUT ioOrd               Integer,      -- № п/п сессии GoodsPrint
 INOUT ioUserId            Integer,      -- Пользователь сессии GoodsPrint
    IN inUnitId            Integer,      --
    IN inPartionId         Integer,      --
    IN inGoodsId           Integer,      --
    IN inGoodsSizeId       Integer,      --
    IN inAmount            TFloat,       --
   OUT outGoodsPrintName   TVarChar,     --
   OUT outUserName         TVarChar,     -- 
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId      Integer;
  DECLARE vbInsertDate  TDateTime;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsPrint());


   -- Результат
   SELECT tmp.ioOrd, tmp.outUserName, tmp.outGoodsPrintName
          INTO ioOrd, outUserName, outGoodsPrintName
   FROM lpInsertUpdate_Object_GoodsPrint (ioOrd       := ioOrd
                                        , ioUserId    := ioUserId
                                        , inUnitId    := inUnitId
                                        , inPartionId := inPartionId
                                        , inAmount    := inAmount
                                        , inIsReprice := FALSE      -- может измениться
                                        , inUserId    := vbUserId
                                         ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
 02.05.18         *
 06.03.18                                        *
 17.08.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsPrint (ioOrd:= 0, ioUserId:= 0, inUnitId:= 4198, inPartionId:= 0, inGoodsId:= 0, inGoodsSizeId :=0, inAmount:= 5, inSession := zfCalc_UserAdmin());
