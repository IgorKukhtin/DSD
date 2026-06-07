-- Function: gpGet_Object_CommercRetail()

DROP FUNCTION IF EXISTS gpGet_Object_CommercRetail(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CommercRetail(
    IN inId          Integer,       -- Основные средства 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , RetailId Integer, RetailCode Integer, RetailName TVarChar
             , PositionId_1 Integer, PositionCode_1 Integer, PositionName_1 TVarChar
             , PositionId_2 Integer, PositionCode_2 Integer, PositionName_2 TVarChar
             , PositionId_3 Integer, PositionCode_3 Integer, PositionName_3 TVarChar
             , Comment TVarChar
) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_CommercRetail());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_CommercRetail()) AS Code
           -- , '<ПУСТО>' :: TVarChar AS Name
           , 0     ::Integer  AS RetailId
           , 0     ::Integer  AS RetailCode
           , ''    ::TVarChar AS RetailName
           , 0     ::Integer  AS PositionId_1
           , 0     ::Integer  AS PositionCode_1
           , ''    ::TVarChar AS PositionName_1 
           , 0     ::Integer  AS PositionId_2
           , 0     ::Integer  AS PositionCode_2
           , ''    ::TVarChar AS PositionName_2 
           , 0     ::Integer  AS PositionId_3
           , 0     ::Integer  AS PositionCode_3
           , ''    ::TVarChar AS PositionName_3
           , ''    ::TVarChar AS Comment
           ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_CommercRetail.Id           AS Id
         , Object_CommercRetail.ObjectCode   AS Code
         --, Object_CommercRetail.ValueData    AS Name

         , Object_Retail.Id                    ::Integer  AS RetailId
         , Object_Retail.ObjectCode            ::Integer  AS RetailCode
         , Object_Retail.ValueData             ::TVarChar AS RetailName
         , Object_Position_1.Id                ::Integer  AS PositionId_1
         , Object_Position_1.ObjectCode        ::Integer  AS PositionCode_1
         , Object_Position_1.ValueData         ::TVarChar AS PositionName_1 
         , Object_Position_2.Id                ::Integer  AS PositionId_2
         , Object_Position_2.ObjectCode        ::Integer  AS PositionCode_2
         , Object_Position_2.ValueData         ::TVarChar AS PositionName_2 
         , Object_Position_3.Id                ::Integer  AS PositionId_3
         , Object_Position_3.ObjectCode        ::Integer  AS PositionCode_3
         , Object_Position_3.ValueData         ::TVarChar AS PositionName_3

         , ObjectString_Comment.ValueData AS Comment
     FROM Object AS Object_CommercRetail
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_CommercRetail.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_CommercRetail_Comment()  

          LEFT JOIN ObjectLink AS ObjectLink_CommercRetail_Retail
                               ON ObjectLink_CommercRetail_Retail.ObjectId = Object_CommercRetail.Id
                              AND ObjectLink_CommercRetail_Retail.DescId = zc_ObjectLink_CommercRetail_Retail()
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_CommercRetail_Retail.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_CommercRetail_Position_1
                               ON ObjectLink_CommercRetail_Position_1.ObjectId = Object_CommercRetail.Id
                              AND ObjectLink_CommercRetail_Position_1.DescId = zc_ObjectLink_CommercRetail_Position_1()
          LEFT JOIN Object AS Object_Position_1 ON Object_Position_1.Id = ObjectLink_CommercRetail_Position_1.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_CommercRetail_Position_2
                               ON ObjectLink_CommercRetail_Position_2.ObjectId = Object_CommercRetail.Id
                              AND ObjectLink_CommercRetail_Position_2.DescId = zc_ObjectLink_CommercRetail_Position_2()
          LEFT JOIN Object AS Object_Position_2 ON Object_Position_2.Id = ObjectLink_CommercRetail_Position_2.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_CommercRetail_Position_3
                               ON ObjectLink_CommercRetail_Position_3.ObjectId = Object_CommercRetail.Id
                              AND ObjectLink_CommercRetail_Position_3.DescId = zc_ObjectLink_CommercRetail_Position_3()
          LEFT JOIN Object AS Object_Position_3 ON Object_Position_3.Id = ObjectLink_CommercRetail_Position_3.ChildObjectId

       WHERE Object_CommercRetail.DescId = zc_Object_CommercRetail()
         AND Object_CommercRetail.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.06.26         *
*/

-- тест
-- SELECT * FROM gpGet_Object_CommercRetail(0, '2')