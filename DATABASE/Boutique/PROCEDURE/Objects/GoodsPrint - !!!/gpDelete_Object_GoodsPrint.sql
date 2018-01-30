-- Function: gpDelete_Object_GoodsPrint (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpDelete_Object_GoodsPrint (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_Object_GoodsPrint(
 INOUT ioId                Integer,       -- Ключ объекта <>            
 INOUT ioUserId            Integer,
   OUT outGoodsPrintName   TVarChar,     --
   OUT outUserName         TVarChar,     --
    IN inSession           TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsInfo());
   vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (ioId, 0) = 0
   THEN
       -- удаляем все элементы текущего пользователя 
       DELETE FROM Object_GoodsPrint 
       WHERE Object_GoodsPrint.UserId = ioUserId;
   ELSE                     
       -- удаляем все элементы текущей сессии пользователя 
       DELETE FROM Object_GoodsPrint 
       WHERE Object_GoodsPrint.UserId = ioUserId
         AND Object_GoodsPrint.InsertDate IN (SELECT tmp.InsertDate 
                                              FROM  (SELECT Object_GoodsPrint.InsertDate
                                                          , ROW_NUMBER() OVER (PARTITION BY Object_GoodsPrint.UserId ORDER BY Object_GoodsPrint.InsertDate)  AS ord  
                                                     FROM Object_GoodsPrint
                                                     WHERE Object_GoodsPrint.UserId = ioUserId
                                                     GROUP BY Object_GoodsPrint.UserId, Object_GoodsPrint.InsertDate
                                                     ) AS tmp 
                                              WHERE tmp.Ord = ioId
                                              )  
       ;


   END IF;
   
   ioUserId := vbUserId;
   outUserName := lfGet_Object_ValueData (vbUserId) ::TVarChar;
   ioId := 0 ;
   --outInsertDate := Null;
   outGoodsPrintName := '' :: TVarChar;
      
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
-- select * from gpDelete_Object_GoodsPrint(ioId := 0 , ioUserId := 0 , inSession := '2'::TVarChar);