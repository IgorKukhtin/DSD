-- Function: gpSelect_MovementProtocol_Info() 

DROP FUNCTION IF EXISTS gpSelect_MovementProtocol_Info (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementProtocol_Info (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementProtocol_Info(
    IN inMovementId      Integer,    -- объект
    IN inCodeInfo        Integer,    -- тип объекта
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , UserName TVarChar
             , TextInfo Text
             , ProtocolData Text
             )
AS
$BODY$
BEGIN

  -- проверка
  IF COALESCE (inMovementId, 0) = 0 THEN
     --RAISE EXCEPTION 'Ошибка.Просмотр протокола недоступен.';
     RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Просмотр протокола недоступен.' :: TVarChar
                                           , inProcedureName := 'gpSelect_MovementProtocol_Info' :: TVarChar
                                           , inUserId        := inUserId
                                           );
  END IF;

  IF inMovementId <> 0 
  THEN
  -- real-1
  RETURN QUERY 
   WITH
   --выбрали весь протокол тек. документа 
   tmpProtocolALL AS (SELECT *
                      FROM MovementProtocol
                      WHERE MovementId = inMovementId
                      
                      )
   -- данные по изменению параметров Информация
 , tmpProtocol AS (SELECT tmpProtocolALL.OperDate
                        , Object_User.ValueData
                        , REPLACE(REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Информация 1"] /@FieldValue', tmpProtocolALL.ProtocolData :: XML) AS TEXT), '{', ''), '}',''), '"','')   AS TextInfo
                        , tmpProtocolALL.ProtocolData::Text
                        , ROW_NUMBER() OVER(ORDER BY tmpProtocolALL.OperDate) AS ord
                   FROM tmpProtocolALL
                     JOIN Object AS Object_User ON Object_User.Id = tmpProtocolALL.UserId
                   WHERE inCodeInfo = 1
                UNION
                   SELECT tmpProtocolALL.OperDate
                        , Object_User.ValueData
                        , REPLACE(REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Информация 2"] /@FieldValue', tmpProtocolALL.ProtocolData :: XML) AS TEXT), '{', ''), '}',''), '"','')   AS TextInfo
                        , tmpProtocolALL.ProtocolData::Text
                        , ROW_NUMBER() OVER(ORDER BY tmpProtocolALL.OperDate) AS ord
                   FROM tmpProtocolALL
                     JOIN Object AS Object_User ON Object_User.Id = tmpProtocolALL.UserId
                   WHERE inCodeInfo = 2
                UNION
                   SELECT tmpProtocolALL.OperDate
                        , Object_User.ValueData
                        , REPLACE(REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Информация 3"] /@FieldValue', tmpProtocolALL.ProtocolData :: XML) AS TEXT), '{', ''), '}',''), '"','')   AS TextInfo
                        , tmpProtocolALL.ProtocolData::Text
                        , ROW_NUMBER() OVER(ORDER BY tmpProtocolALL.OperDate) AS ord
                   FROM tmpProtocolALL
                     JOIN Object AS Object_User ON Object_User.Id = tmpProtocolALL.UserId
                   WHERE inCodeInfo = 3
                   )
   -- Изменения
   SELECT tt1.OperDate
        , tt1.ValueData ::TVarChar AS UserName
        , tt1.TextInfo  ::Text
        , tt1.ProtocolData::Text
   FROM tmpProtocol AS tt1
        LEFT JOIN tmpProtocol AS tt2 ON tt2.ord = tt1.ord-1
   WHERE COALESCE (tt1.TextInfo,'') <> COALESCE (tt2.TextInfo,'')  ;

  ELSE
     --RAISE EXCEPTION 'Ошибка.Просмотр протокола недоступен.';
     RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Просмотр протокола недоступен.' :: TVarChar
                                           , inProcedureName := 'gpSelect_Protocol' :: TVarChar
                                           , inUserId        := inUserId
                                           );

  END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.03.21         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementProtocol_Info (inMovementId:=  78, inCodeInfo:= 1, inSession := '5');

