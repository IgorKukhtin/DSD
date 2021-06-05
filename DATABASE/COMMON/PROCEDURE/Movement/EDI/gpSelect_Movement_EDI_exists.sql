-- Function: gpSelect_Movement_EDI_exists()

DROP FUNCTION IF EXISTS gpSelect_Movement_EDI_exists (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_EDI_exists(
    IN inFileName  TVarChar , --
   OUT outIsExists Boolean  , --
    IN inSession   TVarChar   -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ZakazInternal());

     IF EXTRACT (HOUR FROM CURRENT_TIMESTAMP) BETWEEN 7 AND 18
     THEN
          outIsExists:= 1 < (SELECT COUNT(*)
                             FROM (SELECT X[1] :: Text AS Value
                                   FROM (SELECT Movement.Id
                                              , XPATH ('/XML/EDIEvent/@Value', MovementProtocol.ProtocolData :: XML) AS X
                                              , MovementProtocol.OperDate
                                              , MovementProtocol.UserId
                                         FROM Movement
                                              JOIN MovementProtocol ON MovementProtocol.MovementId = Movement.Id AND MovementProtocol.isInsert IS NULL
                                         WHERE Movement.OperDate = CURRENT_DATE
                                           AND Movement.DescId   = zc_Movement_EDI()
                                        ) AS MovementProtocolData
                                  ) AS MovementProtocolData
                             WHERE MovementProtocolData.Value ILIKE ('%' || inFileName || '%')
                            ); 
     ELSE outIsExists:= FALSE;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.06.21                                        *
*/

/*
select Movement.*, * from 
(SELECT X[1] :: Text AS Value, *
                                   FROM (SELECT XPATH ('/XML/EDIEvent/@Value', MovementProtocol.ProtocolData :: XML) AS X
                                              , MovementProtocol.*
                                         FROM Movement
                                              JOIN MovementProtocol ON MovementProtocol.MovementId = Movement.Id AND MovementProtocol.isInsert IS NULL
                                         WHERE Movement.OperDate = CURRENT_DATE
                                           AND Movement.DescId   = zc_Movement_EDI()
                                        ) AS MovementProtocolData
                                  ) AS MovementProtocolData

join Movement on Movement.Id = MovementId

                              WHERE MovementProtocolData.Value ILIKE ('%Загрузка ORDER из EDI завершена _order%')



order by MovementProtocolData.id desc limit 10
*/
-- тест
-- SELECT * FROM gpSelect_Movement_EDI_exists (inFileName:= 'order_20210604130902_d4510661-500c-49ed-9220-1dd9690a2278.xml', inSession:= zfCalc_UserAdmin())
