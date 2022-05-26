-- Function: gpSelect_Object_Cash()

DROP FUNCTION IF EXISTS gpSelect_Object_Cash (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Cash(
    IN inIsShowAll   Boolean,       -- признак показать удаленные да / нет
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean
             , isLeaf Boolean
             , CurrencyId Integer, CurrencyName TVarChar
             , ParentId Integer, ParentName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ShortName TVarChar, GroupNameFull TVarChar
             , NPP TFloat
             , isUserAll Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Cash());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY 
   SELECT Object_Cash.Id          AS Id 
        , Object_Cash.ObjectCode  AS Code
        , Object_Cash.ValueData   AS Name
        , Object_Cash.isErased    AS isErased  
        , COALESCE (ObjectBoolean_isLeaf.ValueData,TRUE)    ::Boolean AS isLeaf
        
        , Object_Currency.Id            AS CurrencyId
        , Object_Currency.ValueData     AS CurrencyName
        , COALESCE(Object_Parent.Id,0)  AS ParentId
        , Object_Parent.ValueData       AS ParentName
        , Object_PaidKind.Id            AS PaidKindId
        , Object_PaidKind.ValueData     AS PaidKindName   

        , ObjectString_ShortName.ValueData     AS ShortName
        , ObjectString_GroupNameFull.ValueData AS GroupNameFull
        , ObjectFloat_NPP.ValueData   ::TFloat AS NPP 
        , COALESCE (ObjectBoolean_UserAll.ValueData, FALSE) ::Boolean AS isUserAll

        , Object_Insert.ValueData         AS InsertName
        , ObjectDate_Insert.ValueData     AS InsertDate
        , Object_Update.ValueData         AS UpdateName
        , ObjectDate_Update.ValueData     AS UpdateDate
   FROM Object AS Object_Cash

        LEFT JOIN ObjectString AS ObjectString_ShortName
                               ON ObjectString_ShortName.ObjectId = Object_Cash.Id
                              AND ObjectString_ShortName.DescId = zc_ObjectString_Cash_ShortName()
        LEFT JOIN ObjectString AS ObjectString_GroupNameFull
                               ON ObjectString_GroupNameFull.ObjectId = Object_Cash.Id
                              AND ObjectString_GroupNameFull.DescId = zc_ObjectString_Cash_GroupNameFull()
        LEFT JOIN ObjectFloat AS ObjectFloat_NPP
                              ON ObjectFloat_NPP.ObjectId = Object_Cash.Id
                             AND ObjectFloat_NPP.DescId = zc_ObjectFloat_Cash_NPP()

        LEFT JOIN ObjectLink AS ObjectLink_Currency
                             ON ObjectLink_Currency.ObjectId = Object_Cash.Id
                            AND ObjectLink_Currency.DescId = zc_ObjectLink_Cash_Currency()
        LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Currency.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Parent
                             ON ObjectLink_Parent.ObjectId = Object_Cash.Id
                            AND ObjectLink_Parent.DescId = zc_ObjectLink_Cash_Parent()
        LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Parent.ChildObjectId
          
        LEFT JOIN ObjectLink AS ObjectLink_Child
                             ON ObjectLink_Child.ChildObjectId = Object_Cash.Id
                            AND ObjectLink_Child.DescId = zc_ObjectLink_Cash_Parent()
                            AND 1=0

        LEFT JOIN ObjectLink AS ObjectLink_PaidKind
                             ON ObjectLink_PaidKind.ObjectId = Object_Cash.Id
                            AND ObjectLink_PaidKind.DescId = zc_ObjectLink_Cash_PaidKind()
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_PaidKind.ChildObjectId

        LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf 
                                ON ObjectBoolean_isLeaf.ObjectId = Object_Cash.Id
                               AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_UserAll
                                ON ObjectBoolean_UserAll.ObjectId = Object_Cash.Id
                               AND ObjectBoolean_UserAll.DescId = zc_ObjectBoolean_Cash_UserAll()

        LEFT JOIN ObjectLink AS ObjectLink_Insert
                             ON ObjectLink_Insert.ObjectId = Object_Cash.Id
                            AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

        LEFT JOIN ObjectDate AS ObjectDate_Insert
                             ON ObjectDate_Insert.ObjectId = Object_Cash.Id
                            AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

        LEFT JOIN ObjectLink AS ObjectLink_Update
                             ON ObjectLink_Update.ObjectId = Object_Cash.Id
                            AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId

        LEFT JOIN ObjectDate AS ObjectDate_Update
                             ON ObjectDate_Update.ObjectId = Object_Cash.Id
                            AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()
   WHERE Object_Cash.DescId = zc_Object_Cash()
     AND (Object_Cash.isErased = FALSE OR inIsShowAll = TRUE)
     AND ObjectLink_Child.ObjectId IS NULL
  ;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.22         *
 11.01.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Cash (true, zfCalc_UserAdmin())
