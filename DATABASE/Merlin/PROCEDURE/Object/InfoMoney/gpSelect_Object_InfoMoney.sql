-- Function: gpSelect_Object_InfoMoney()

DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoney (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoney(
    IN inIsShowAll   Boolean,       -- признак показать удаленные да / нет
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean
             , InfoMoneyKindId Integer, InfoMoneyKindName TVarChar
             , ParentId Integer, ParentName TVarChar
             , GroupNameFull TVarChar
             , isUserAll Boolean, isService Boolean 
             , isLeaf Boolean
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
   SELECT Object_InfoMoney.Id          AS Id 
        , Object_InfoMoney.ObjectCode  AS Code
        , Object_InfoMoney.ValueData   AS Name
        , Object_InfoMoney.isErased    AS isErased
        
        , Object_InfoMoneyKind.Id        AS InfoMoneyKindId
        , Object_InfoMoneyKind.ValueData AS InfoMoneyKindName
        , COALESCE(Object_Parent.Id,0)   AS ParentId
        , Object_Parent.ValueData        AS ParentName
        
        , ObjectString_GroupNameFull.ValueData AS GroupNameFull
        , COALESCE (ObjectBoolean_UserAll.ValueData, FALSE) ::Boolean AS isUserAll
        , COALESCE (ObjectBoolean_Service.ValueData, FALSE) ::Boolean AS isService  

        , COALESCE (ObjectBoolean_isLeaf.ValueData,TRUE)    ::Boolean AS isLeaf

        , Object_Insert.ValueData         AS InsertName
        , ObjectDate_Insert.ValueData     AS InsertDate
        , Object_Update.ValueData         AS UpdateName
        , ObjectDate_Update.ValueData     AS UpdateDate
   FROM Object AS Object_InfoMoney
        LEFT JOIN ObjectString AS ObjectString_GroupNameFull
                               ON ObjectString_GroupNameFull.ObjectId = Object_InfoMoney.Id
                              AND ObjectString_GroupNameFull.DescId = zc_ObjectString_InfoMoney_GroupNameFull()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_UserAll
                                ON ObjectBoolean_UserAll.ObjectId = Object_InfoMoney.Id
                               AND ObjectBoolean_UserAll.DescId = zc_ObjectBoolean_InfoMoney_UserAll()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Service
                                ON ObjectBoolean_Service.ObjectId = Object_InfoMoney.Id
                               AND ObjectBoolean_Service.DescId = zc_ObjectBoolean_InfoMoney_Service()

        LEFT JOIN ObjectLink AS ObjectLink_InfoMoneyKind
                             ON ObjectLink_InfoMoneyKind.ObjectId = Object_InfoMoney.Id
                            AND ObjectLink_InfoMoneyKind.DescId = zc_ObjectLink_InfoMoney_InfoMoneyKind()
        LEFT JOIN Object AS Object_InfoMoneyKind ON Object_InfoMoneyKind.Id = ObjectLink_InfoMoneyKind.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Parent
                             ON ObjectLink_Parent.ObjectId = Object_InfoMoney.Id
                            AND ObjectLink_Parent.DescId = zc_ObjectLink_InfoMoney_Parent()
        LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Parent.ChildObjectId

        LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf 
                                ON ObjectBoolean_isLeaf.ObjectId = Object_InfoMoney.Id
                               AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()
          
        LEFT JOIN ObjectLink AS ObjectLink_Insert
                             ON ObjectLink_Insert.ObjectId = Object_InfoMoney.Id
                            AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

        LEFT JOIN ObjectDate AS ObjectDate_Insert
                             ON ObjectDate_Insert.ObjectId = Object_InfoMoney.Id
                            AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

        LEFT JOIN ObjectLink AS ObjectLink_Update
                             ON ObjectLink_Update.ObjectId = Object_InfoMoney.Id
                            AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId

        LEFT JOIN ObjectDate AS ObjectDate_Update
                             ON ObjectDate_Update.ObjectId = Object_InfoMoney.Id
                            AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()
   WHERE Object_InfoMoney.DescId = zc_Object_InfoMoney()
     AND (Object_InfoMoney.isErased = FALSE OR inIsShowAll = TRUE)
  ;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.01.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_InfoMoney (FALSE, zfCalc_UserAdmin())
