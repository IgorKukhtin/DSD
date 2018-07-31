-- для SessionGUID - возвращает данные из табл. ReplObject -> ObjectHistory - для формирования скриптов

DROP FUNCTION IF EXISTS gpSelect_ReplObjectHistoryString (TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ReplObjectHistoryString(
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
             , ObjectHistoryId    Integer
             , DescId             Integer
             , DescName           VarChar (100)
             , ItemName           VarChar (100)
                                  
             , ValueDataS         TVarChar
             , ValueDataF         TFloat
             , ValueDataD         TDateTime
             , ValueDataB         Boolean
             , isValuDNull        Boolean
             , isValuBNull        Boolean
                                  
             , GUID               VarChar (100)
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
        , ObjectHistoryString.ObjectHistoryId              AS ObjectHistoryId
        , ObjectHistoryString.DescId                       AS DescId
        , ObjectHistoryStringDesc.Code    :: VarChar (100) AS DescName
        , ObjectHistoryStringDesc.ItemName:: VarChar (100) AS ItemName
                                                    
        , ObjectHistoryString.ValueData             AS ValueDataS
        , 0                        :: TFloat        AS ValueDataF
        , NULL                     :: TDateTime     AS ValueDataD
        , NULL                     :: Boolean       AS ValueDataB
        , FALSE                    :: Boolean       AS isValuDNull
        , FALSE                    :: Boolean       AS isValuBNull

        , (CASE WHEN ObjectString_GUID.ValueData <> '' THEN ObjectString_GUID.ValueData ELSE ReplObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (100) AS GUID

     FROM ReplObject
          INNER JOIN ObjectHistory          ON ObjectHistory.ObjectId = ReplObject.ObjectId
          INNER JOIN ObjectHistoryString     ON ObjectHistoryString.ObjectHistoryId = ObjectHistory.Id
          LEFT JOIN  ObjectHistoryStringDesc ON ObjectHistoryStringDesc.Id   = ObjectHistoryString.DescId
          LEFT JOIN ObjectString AS ObjectString_GUID
                                 ON ObjectString_GUID.ObjectId = ReplObject.ObjectId
                                AND ObjectString_GUID.DescId   = zc_ObjectString_GUID()
     WHERE ReplObject.SessionGUID = inSessionGUID
       AND ((ReplObject.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
     ORDER BY ReplObject.ObjectId, ObjectHistoryString.DescId
    ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.07.18                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ReplObjectHistoryString  (inSessionGUID:= CURRENT_TIMESTAMP :: TVarChar, inStartId:= 0, inEndId:= 0, inDataBaseId:= 0, gConnectHost:= '', inSession:= zfCalc_UserAdmin()) -- ORDER BY 1
