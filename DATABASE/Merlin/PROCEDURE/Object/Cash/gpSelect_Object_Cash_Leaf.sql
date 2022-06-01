-- Function: gpSelect_Object_Cash_Leaf()

DROP FUNCTION IF EXISTS gpSelect_Object_Cash_Leaf (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Cash_Leaf(
    IN inIsShowAll   Boolean,       -- признак показать удаленные да / нет
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean
             , isLeaf Boolean
             , CurrencyId Integer, CurrencyName TVarChar
             , ParentId Integer, ParentName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ShortName TVarChar, GroupNameFull TVarChar
             , NPP Integer
             , Amount TFloat
             , isUserAll Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
)
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
       SELECT tmp.Id
            , tmp.Code
            , tmp.Name
            , tmp.isErased
            , tmp.isLeaf
            , tmp.CurrencyId
            , tmp.CurrencyName
            , tmp.ParentId
            , tmp.ParentName
            , tmp.PaidKindId
            , tmp.PaidKindName
            , tmp.ShortName
            , tmp.GroupNameFull
            , tmp.NPP
            , tmp.Amount
            , tmp.isUserAll
            , tmp.InsertName
            , tmp.InsertDate
            , tmp.UpdateName
            , tmp.UpdateDate
       FROM gpSelect_Object_Cash(inIsShowAll, inSession)  AS tmp
       WHERE tmp.Id NOT IN (SELECT DISTINCT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Cash_Parent()) 
      ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Cash_Leaf (true, zfCalc_UserAdmin())
