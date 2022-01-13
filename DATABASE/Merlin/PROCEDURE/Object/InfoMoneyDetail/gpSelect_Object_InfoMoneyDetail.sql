-- Function: gpSelect_Object_InfoMoneyDetail()

DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoneyDetail (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoneyDetail(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean
             , InfoMoneyKindId Integer, InfoMoneyKindName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InfoMoneyDetail());

   RETURN QUERY 
   SELECT Object_InfoMoneyDetail.Id          AS Id
        , Object_InfoMoneyDetail.ObjectCode  AS Code
        , Object_InfoMoneyDetail.ValueData   AS Name
        , Object_InfoMoneyDetail.isErased    AS isErased
        
        , Object_InfoMoneyKind.Id         AS InfoMoneyKindId
        , Object_InfoMoneyKind.ValueData  AS InfoMoneyKindName

        , Object_Insert.ValueData         AS InsertName
        , ObjectDate_Insert.ValueData     AS InsertDate
        , Object_Update.ValueData         AS UpdateName
        , ObjectDate_Update.ValueData     AS UpdateDate

       FROM Object AS Object_InfoMoneyDetail
        LEFT JOIN ObjectLink AS ObjectLink_InfoMoneyKind
                             ON ObjectLink_InfoMoneyKind.ObjectId = Object_InfoMoneyDetail.Id
                            AND ObjectLink_InfoMoneyKind.DescId = zc_ObjectLink_InfoMoneyDetail_InfoMoneyKind()
        LEFT JOIN Object AS Object_InfoMoneyKind ON Object_InfoMoneyKind.Id = ObjectLink_InfoMoneyKind.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Insert
                             ON ObjectLink_Insert.ObjectId = Object_InfoMoneyDetail.Id
                            AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

        LEFT JOIN ObjectDate AS ObjectDate_Insert
                             ON ObjectDate_Insert.ObjectId = Object_InfoMoneyDetail.Id
                            AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

        LEFT JOIN ObjectLink AS ObjectLink_Update
                             ON ObjectLink_Update.ObjectId = Object_InfoMoneyDetail.Id
                            AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId

        LEFT JOIN ObjectDate AS ObjectDate_Update
                             ON ObjectDate_Update.ObjectId = Object_InfoMoneyDetail.Id
                            AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()
       WHERE Object_InfoMoneyDetail.DescId = zc_Object_InfoMoneyDetail()
   ;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.01.22          *     
*/

-- тест
-- SELECT * FROM gpSelect_Object_InfoMoneyDetail('2')