-- Function: gpInsertUpdate_Object_OrderCarInfo (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OrderCarInfo (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_OrderCarInfo (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_OrderCarInfo(
   INOUT ioId                    Integer, 
      IN inRouteId               Integer, 
      IN inRetailId              Integer,
      IN inUnitId                Integer,
      IN inOperDate              TFloat ,     -- 
      IN inOperDatePartner       TFloat ,     -- 
      IN inDays                  TFloat ,     -- 
      IN inHour                  TFloat ,     --
      IN inMin                   TFloat ,     --      
      IN inSession               TVarChar
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_OrderCarInfo());
   vbUserId:= lpGetUserBySession (inSession);
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object_OrderCarInfo (ioId	      := ioId
                                             , inRouteId  := inRouteId
                                             , inRetailId := inRetailId
                                             , inUnitId   := inUnitId
                                             , inOperDate := inOperDate
                                             , inOperDatePartner := inOperDatePartner 
                                             , inDays     := inDays
                                             , inHour     := inHour
                                             , inMin      := inMin  
                                             , inUserId   := vbUserId
                                              );

  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.22         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_OrderCarInfo()