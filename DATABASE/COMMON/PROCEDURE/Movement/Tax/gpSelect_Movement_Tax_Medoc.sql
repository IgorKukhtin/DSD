 -- Function: gpSelect_Movement_Tax_Medoc()

DROP FUNCTION IF EXISTS gpSelect_Movement_Tax_Medoc (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Tax_Medoc(
    IN inMovementId        Integer  , -- ключ Документа
    IN inisClientCopy      Boolean  , -- копия для клиента
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
DECLARE
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE Cursor3 refcursor;

    DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_Begin1:= CLOCK_TIMESTAMP();

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!меняется параметр!!!
     IF EXISTS (SELECT 1
                FROM Movement
                     INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                   ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                  AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                     INNER JOIN Object_Contract_InvNumber_View ON Object_Contract_InvNumber_View.ContractId = MovementLinkObject_Contract.ObjectId
                                                              AND Object_Contract_InvNumber_View.InfoMoneyId = zc_Enum_InfoMoney_30201()
                WHERE Movement.Id = inMovementId)
     THEN inMovementId:=0;
     END IF;


     OPEN Cursor1 FOR
     SELECT $1 FROM gpSelect_Movement_Tax_Print (inMovementId, inisClientCopy, inSession) AS tmp;
     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR
     SELECT $2 FROM gpSelect_Movement_Tax_Print (inMovementId, inisClientCopy, inSession) AS tmp;
     RETURN NEXT Cursor2;

     OPEN Cursor3 FOR
     SELECT $3 FROM gpSelect_Movement_Tax_Print (inMovementId, inisClientCopy, inSession) AS tmp;
     RETURN NEXT Cursor3;


     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
   /*INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                                    AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE position( 'autovacuum: VACUUM' in query) = 1) AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО lpSelectMinPrice_List
             , NULL AS Time2
               -- сколько всего выполнялась проц lpSelectMinPrice_List
             , NULL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ lpSelectMinPrice_List
             , NULL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpSelect_Movement_Tax_Medoc'
               -- ProtocolData
             , inMovementId        :: TVarChar
    || ', ' || inisClientCopy      :: TVarChar
    || ', ' || inSession
              ;*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Tax_Medoc (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.05.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Tax_Medoc (inMovementId := 171760, inisClientCopy:= FALSE ,inSession:= zfCalc_UserAdmin());
