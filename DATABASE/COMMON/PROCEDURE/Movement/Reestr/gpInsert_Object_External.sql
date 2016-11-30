-- Function: gpInsert_Object_External()

DROP FUNCTION  IF EXISTS gpInsert_Object_External(Integer, TVarChar,TVarChar,TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_External(
    IN inId             Integer   ,     -- ключ объекта <Документ реестр> 
    IN inDriver         TVarChar  ,     -- Водитель 
    IN inMember         TVarChar  ,     -- Экспедитор
    IN inCar            TVarChar  ,     -- № Авто
   OUT outDriverId      Integer   ,     -- ид Водитель
   OUT outMemberId      Integer   ,     -- ид Экспедитор
   OUT outCarId         Integer   ,     -- ид Авто
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS record AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Role());
  -- outDriverId:=0;
  -- outMemberId:=0;
  -- outCarId:=0;

   vbUserId := inSession;

   IF COALESCE (inDriver, '') <> ''
      THEN
          inDriver:= TRIM (COALESCE (inDriver, ''));

          -- ищем водителя в спр.Физ.лиц
          outDriverId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Member() AND TRIM(Object.ValueData) LIKE inDriver);
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
                                                                           , inUserId:= vbUserId
                                                                             );
                 END IF;  
          END IF;
   END IF;
  
   IF COALESCE (inMember, '') <> ''
      THEN
          inMember:= TRIM (COALESCE (inMember, ''));

          -- ищем экспедитора в спр.Физ.лиц
          outMemberId:= (SELECT  Object.Id  FROM Object WHERE Object.DescId = zc_Object_Member() AND Object.ValueData LIKE inMember);
          IF COALESCE (outMemberId,0)=0
             THEN 
                 -- ищем экспедитора в спр.Физ.лиц(сторонние)
                 outMemberId:= (SELECT  Object.Id  FROM Object WHERE Object.DescId = zc_Object_MemberExternal() AND Object.ValueData LIKE inMember);
                 IF COALESCE (outMemberId,0)=0 
                    THEN 
                        -- не нашли Сохраняем в спр.Физ.лиц(сторонние)
                        outMemberId := lpInsertUpdate_Object_MemberExternal (ioId    := 0
                                                                           , inCode  := lfGet_ObjectCode(0, zc_Object_MemberExternal()) 
                                                                           , inName  := inMember
                                                                           , inUserId:= vbUserId
                                                                             );
                 END IF;  
          END IF;
   END IF;

   IF COALESCE (inCar, '') <> ''
      THEN
          inCar:= TRIM (COALESCE (inCar, ''));

          -- ищем экспедитора в спр.Физ.лиц
          outCarId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Car() AND Object.ValueData LIKE inCar);
          IF COALESCE (outCarId,0)=0
             THEN 
                 -- ищем экспедитора в спр.авто(сторонние)
                 outCarId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CarExternal() AND Object.ValueData LIKE inCar);
                 IF COALESCE (outCarId,0)=0 
                    THEN 
                        -- не нашли Сохраняем в авто(сторонние)
                        outCarId := lpInsertUpdate_Object_CarExternal (ioId	    := 0
                                            , inCode        := lfGet_ObjectCode(0, zc_Object_CarExternal())
                                            , inName        := inCar
                                            , inRegistrationCertificate := '' ::TVarChar
                                            , inComment     := '' ::TVarChar
                                            , inCarModelId  := 0
                                            , inJuridicalId := 0
                                            , inUserId      := vbUserId
                                              );
                 END IF;  
          END IF;
   END IF;
 
   
   -- сохранили протокол
   --PERFORM lpInsert_ObjectProtocol (ioId, UserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.11.16         *

*/

-- тест
-- SELECT * FROM gpInsert_Object_External()
--select * from gpInsert_Object_External(inId := 0 , inDriver := 'Демчик'  , inMember := 'Демчик' , inCar := '5115' ,  inSession := '5');

--SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Member() AND Object.ValueData LIKE '%Демчик%') 736986