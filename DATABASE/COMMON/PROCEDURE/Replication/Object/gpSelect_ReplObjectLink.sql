-- для SessionGUID - возвращает данные из табл. ReplObject -> Object - для формирования скриптов

DROP FUNCTION IF EXISTS gpSelect_ReplObjectLink (TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ReplObjectLink(
    IN inSessionGUID  TVarChar,      --
    IN inStartId      Integer,       --
    IN inEndId        Integer,       --
    IN inDataBaseId   Integer,       -- для формирования "виртуального" GUID
    IN gConnectHost   TVarChar,      -- виртуальный, что б в exe - использовать другой сервак
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (OperDate_last      TDateTime
             , ObjectDescId       Integer
             , ObjectId           Integer
             , DescId             Integer
             , DescName           VarChar (100)
             , ItemName           VarChar (100)
             , ChildObjectDescId  Integer
             , ChildObjectId      Integer
             , GUID               VarChar (100)
             , GUID_child         VarChar (100)
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PaidKind());


     -- Результат

     -- 1. Object
     RETURN QUERY
     SELECT
          ReplObject.OperDate_last                  AS OperDate_last
        , ReplObject.DescId                         AS ObjectDescId
        , ReplObject.ObjectId                       AS ObjectId
        , ObjectLink.DescId                         AS DescId
        , ObjectLinkDesc.Code      :: VarChar (100) AS DescName
        , ObjectLinkDesc.ItemName  :: VarChar (100) AS ItemName
        , ObjectLinkDesc.ChildObjectDescId          AS ChildObjectDescId
        , ObjectLink.ChildObjectId :: Integer       AS ChildObjectId

        , (CASE WHEN ObjectString_GUID.ValueData       <> '' THEN ObjectString_GUID.ValueData       ELSE ReplObject.ObjectId      :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (100) AS GUID
        , (CASE WHEN ObjectString_GUID_child.ValueData <> '' THEN ObjectString_GUID_child.ValueData ELSE ObjectLink.ChildObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (100) AS GUID_child

     FROM ReplObject
          INNER JOIN ObjectLink     ON ObjectLink.ObjectId = ReplObject.ObjectId
          LEFT JOIN  ObjectLinkDesc ON ObjectLinkDesc.Id   = ObjectLink.DescId

          LEFT JOIN ObjectString AS ObjectString_GUID
                                 ON ObjectString_GUID.ObjectId = ReplObject.ObjectId
                                AND ObjectString_GUID.DescId   = zc_ObjectString_GUID()
          LEFT JOIN ObjectString AS ObjectString_GUID_child
                                 ON ObjectString_GUID_child.ObjectId = ObjectLink.ChildObjectId
                                AND ObjectString_GUID_child.DescId   = zc_ObjectString_GUID()

     WHERE ReplObject.SessionGUID = inSessionGUID
       AND ((ReplObject.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
     ORDER BY ReplObject.ObjectId
    ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.18                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ReplObjectLink  (inSessionGUID:= CURRENT_TIMESTAMP :: TVarChar, inStartId:= 0, inEndId:= 0, inDataBaseId:= 0, gConnectHost:= '', inSession:= zfCalc_UserAdmin()) -- ORDER BY 1
