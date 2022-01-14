-- Function: gpSelect_Object_InfoMoney_choice()

DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoney_choice (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoney_choice(
    IN inisService   Boolean,       -- показывать только По начислению да / нет
    IN inIsShowAll   Boolean,       -- признак показать удаленные да / нет
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean
             , InfoMoneyKindId Integer, InfoMoneyKindName TVarChar
             , ParentId Integer, ParentName TVarChar
             , GroupNameFull TVarChar
             , isUserAll Boolean, isService Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_InfoMoney());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY 
   SELECT tmp.Id          AS Id 
        , tmp.Code
        , tmp.Name
        , tmp.isErased
        
        , tmp.InfoMoneyKindId
        , tmp.InfoMoneyKindName
        , tmp.ParentId
        , tmp.ParentName
        
        , tmp.GroupNameFull
        , tmp.isUserAll
        , tmp.isService

        , tmp.InsertName
        , tmp.InsertDate
        , tmp.UpdateName
        , tmp.UpdateDate
   FROM gpSelect_Object_InfoMoney (inIsShowAll, inSession) AS tmp
   WHERE (COALESCE (tmp.isService, FALSE) = inisService OR inisService = FALSE) 
  ;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.01.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_InfoMoney (TRUE, FALSE, zfCalc_UserAdmin())