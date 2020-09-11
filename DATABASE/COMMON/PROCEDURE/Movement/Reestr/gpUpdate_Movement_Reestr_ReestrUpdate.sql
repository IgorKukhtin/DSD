-- Function: gpInsert_Object_ReestrUpdate()

DROP FUNCTION  IF EXISTS gpUpdate_Movement_Reestr_ReestrUpdate(TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Reestr_ReestrUpdate(
    IN inDriver         TVarChar  ,     -- Водитель 
   OUT outDriverId      Integer   ,     -- ид Водитель
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   --
   IF COALESCE (inDriver, '') <> ''
      THEN
          inDriver:= TRIM (COALESCE (inDriver, ''));

          -- ищем водителя в спр.Физ.лиц
          outDriverId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Member() AND UPPER(CAST(Object.ValueData AS TVarChar)) LIKE UPPER(inDriver));
          IF COALESCE (outDriverId,0)=0
             THEN 
                 -- ищем водителя в спр.Физ.лиц(сторонние)
                 outDriverId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_MemberExternal() AND TRIM(Object.ValueData) LIKE inDriver);
                 IF COALESCE (outDriverId,0)=0 
                    THEN 
                        -- не нашли Сохраняем в спр.Физ.лиц(сторонние)
                        outDriverId := lpInsertUpdate_Object_MemberExternal (ioId    := 0
                                                                           , inCode  := lfGet_ObjectCode(0, zc_Object_MemberExternal()) 
                                                                           , inName  := inDriver
                                                                           , inDriverCertificate := '' ::TVarChar
                                                                           , inINN   := '' ::TVarChar
                                                                           , inUserId:= vbUserId
                                                                             );
                 END IF;  
          END IF;
   END IF;
  
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (outDriverId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.12.16         *

*/

-- тест
-- SELECT * FROM gpUpdate_Movement_Reestr_ReestrUpdate()
--select * from gpUpdate_Movement_Reestr_ReestrUpdate (inDriver := 'Демчик',  inSession := '5');

--SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Member() AND Object.ValueData LIKE '%Демчик%') 736986