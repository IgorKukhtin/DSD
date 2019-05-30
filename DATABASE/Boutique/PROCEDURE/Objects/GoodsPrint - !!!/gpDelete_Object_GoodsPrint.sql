-- Function: gpDelete_Object_GoodsPrint (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpDelete_Object_GoodsPrint (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpDelete_Object_GoodsPrint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_GoodsPrint(
 INOUT ioOrd               Integer,      -- № п/п сессии GoodsPrint
   OUT outGoodsPrintName   TVarChar,     --
   OUT outUserId           Integer,      -- Пользователь сессии GoodsPrint
   OUT outUserName         TVarChar,     --
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsInfo());
   outUserId:= lpGetUserBySession (inSession);


   -- !!!СНАЧАЛА удаляем данные ВСЕХ Пользователей БОЛЬШЕ чем за 7 дней!!!
   DELETE FROM Object_GoodsPrint WHERE InsertDate < CURRENT_DATE - INTERVAL '7 DAY';


   -- Для Пустой сессии
   IF COALESCE (ioOrd, 0) = 0
   THEN
       -- удаляем все элементы для ВСЕХ сессий пользователя
       DELETE FROM Object_GoodsPrint WHERE Object_GoodsPrint.UserId = outUserId AND Object_GoodsPrint.isReprice = FALSE;
   ELSE
       -- удаляем все элементы для 1-ой сессии пользователя
       DELETE FROM Object_GoodsPrint
       WHERE Object_GoodsPrint.UserId     = outUserId
         AND Object_GoodsPrint.isReprice  = FALSE
         AND Object_GoodsPrint.InsertDate = (SELECT tmp.InsertDate FROM gpSelect_Object_GoodsPrint_Choice (outUserId, inSession) AS tmp
                                             WHERE tmp.Ord = ioOrd -- !!!выбрали только нужную!!!
                                            )
       ;


   END IF;

   -- Результат
   ioOrd            := 0 ;
   outGoodsPrintName:= '';
   outUserName      := lfGet_Object_ValueData_sh (outUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
17.08.17          *
*/

-- тест
-- SELECT * FROM gpDelete_Object_GoodsPrint (ioOrd:= 0, ioUserId:= 0, inSession:= zfCalc_UserAdmin());
