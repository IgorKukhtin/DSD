-- Function: gpGet_Object_PartionCell_guide_edit()

DROP FUNCTION IF EXISTS gpGet_Object_PartionCell_guide_edit (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PartionCell_guide_edit(
    IN inId             Integer,       -- 
   OUT outExecForm      Boolean,       -- 
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     IF inId = zc_PartionCell_Err()
        AND EXISTS (SELECT 1 FROM ObjectString AS OS WHERE OS.ObjectId = vbUserId AND OS.DescId = zc_ObjectString_User_Key() AND OS.ValueData <> '')
     THEN -- Вызывается диалог
          outExecForm:= TRUE;
     ELSE -- НЕ Вызывается диалог
          outExecForm:= FALSE;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.02.25                                        *
*/

-- тест
-- SELECT * FROM gpGet_Object_PartionCell_guide_edit (zc_PartionCell_Err(), '5')
