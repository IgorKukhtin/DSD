  -- Function: gpUpdate_Clear_DefaultUnitUser()

  DROP FUNCTION IF EXISTS gpUpdate_Clear_DefaultUnitUser (TVarChar);


  CREATE OR REPLACE FUNCTION gpUpdate_Clear_DefaultUnitUser(
      IN inSession     TVarChar       -- сессия пользователя
  )
    RETURNS Void 
  AS
  $BODY$
    DECLARE vbUserId Integer;
  BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_User());
     vbUserId := inSession;

     PERFORM gpUpdate_Clear_DefaultUnit (vbUserId, '3');
                                
  END;
  $BODY$
    LANGUAGE plpgsql VOLATILE;
    
  /*
   ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                 Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
   14.01.20                                                       *
  */

  -- тест
  -- select * from gpUpdate_Clear_DefaultUnitUser( inSession := '3');