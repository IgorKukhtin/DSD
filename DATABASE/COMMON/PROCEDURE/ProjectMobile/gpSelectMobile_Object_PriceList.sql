-- Function: gpSelectMobile_Object_PriceList (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_PriceList (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_PriceList (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id           Integer
             , ObjectCode   Integer  -- Код
             , ValueData    TVarChar -- Название
             , PriceWithVAT Boolean  -- Цена с НДС (да/нет)
             , VATPercent   TFloat   -- % НДС
             , isErased     Boolean  -- Удаленный ли элемент
             , isSync       Boolean  -- Синхронизируется (да/нет)
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- Результат
      RETURN QUERY
        WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS PriceListId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                             FROM ObjectProtocol
                                  JOIN Object AS Object_PriceList
                                              ON Object_PriceList.Id = ObjectProtocol.ObjectId
                                             AND Object_PriceList.DescId = zc_Object_PriceList() 
                             WHERE ObjectProtocol.OperDate > inSyncDateIn
                             GROUP BY ObjectProtocol.ObjectId
                            )
        SELECT Object_PriceList.Id
             , Object_PriceList.ObjectCode
             , Object_PriceList.ValueData
             , ObjectBoolean_PriceList_PriceWithVAT.ValueData AS PriceWithVAT
             , ObjectFloat_PriceList_VATPercent.ValueData AS VATPercent
             , Object_PriceList.isErased
             , (NOT Object_PriceList.isErased) AS isSync
        FROM Object AS Object_PriceList
             JOIN tmpProtocol ON tmpProtocol.PriceListId = Object_PriceList.Id
             LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceList_PriceWithVAT
                                     ON ObjectBoolean_PriceList_PriceWithVAT.ObjectId = Object_PriceList.Id
                                    AND ObjectBoolean_PriceList_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT() 
             LEFT JOIN ObjectFloat AS ObjectFloat_PriceList_VATPercent
                                   ON ObjectFloat_PriceList_VATPercent.ObjectId = Object_PriceList.Id
                                  AND ObjectFloat_PriceList_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent() 
        WHERE Object_PriceList.DescId = zc_Object_PriceList();

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 17.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelectMobile_Object_PriceList(inSyncDateIn := CURRENT_TIMESTAMP - Interval '10 day', inSession := zfCalc_UserAdmin())
