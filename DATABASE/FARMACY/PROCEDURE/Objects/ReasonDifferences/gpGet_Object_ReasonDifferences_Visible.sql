-- Function: gpGet_Object_ReasonDifferences_Visible()

DROP FUNCTION IF EXISTS gpGet_Object_ReasonDifferences_Visible(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReasonDifferences_Visible(
   OUT outVisible    Boolean  ,  
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

 -- Для роли "Кассир аптеки"
   IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
            WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy())
   THEN
     outVisible := False;
   ELSE
     outVisible := True;   
   END IF;
   
    
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ReasonDifferences_Visible (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 17.12.21                                                      *
 
*/

-- SELECT * FROM gpGet_Object_ReasonDifferences_Visible ('3');