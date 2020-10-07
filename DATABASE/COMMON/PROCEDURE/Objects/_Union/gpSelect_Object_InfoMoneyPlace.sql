-- Function: gpSelect_Object_InfoMoneyPlace(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoneyPlace (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoneyPlace(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               DescName TVarChar,
               isErased Boolean
)
AS
$BODY$
BEGIN
     
     -- проверка прав пользователя на вызов процедуры 
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_InfoMoney());
     RETURN QUERY 

     SELECT Object_InfoMoney.Id                    AS Id
          , Object_InfoMoney.ObjectCode            AS Code
          , Object_InfoMoney.ValueData             AS Name
          , ObjectDesc.ItemName                    AS DescName
          , Object_InfoMoney.isErased              AS isErased
     FROM Object AS Object_InfoMoney
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_InfoMoney.DescId
     WHERE Object_InfoMoney.DescId = zc_Object_InfoMoney()

    UNION ALL
   SELECT Object_InfoMoneyDestination.Id             AS Id
        , Object_InfoMoneyDestination.ObjectCode     AS Code
        , Object_InfoMoneyDestination.ValueData      AS Name
        , ObjectDesc.ItemName                        AS DescName
        , Object_InfoMoneyDestination.isErased       AS isErased
    FROM Object AS Object_InfoMoneyDestination
         LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_InfoMoneyDestination.DescId
    WHERE Object_InfoMoneyDestination.DescId = zc_Object_InfoMoneyDestination()

    UNION ALL
    SELECT Object_InfoMoneyGroup.Id         AS Id 
         , Object_InfoMoneyGroup.ObjectCode AS Code
         , Object_InfoMoneyGroup.ValueData  AS Name
         , ObjectDesc.ItemName              AS DescName
         , Object_InfoMoneyGroup.isErased   AS isErased
    FROM Object AS Object_InfoMoneyGroup
         LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_InfoMoneyGroup.DescId
    WHERE Object_InfoMoneyGroup.DescId = zc_Object_InfoMoneyGroup()
   UNION ALL
    SELECT 0                     AS Id
         , NULL :: Integer       AS Code
         , 'УДАЛИТЬ' :: TVarChar AS Name
         , '' :: TVarChar        AS DescName
         , FALSE                 AS isErased
;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.07.19         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_InfoMoneyPlace('2'::TVarChar)