-- Function: gpSelect_Object_GlobalConst()

DROP FUNCTION IF EXISTS gpSelect_Object_GlobalConst(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GlobalConst(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, OperDate TDateTime, ValueText TVarChar, EnumName TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbValueData_new TVarChar;
   DECLARE vbOperDate_new TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());
     vbUserId:= lpGetUserBySession (inSession);


     -- только Админ делает Update
     IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         CREATE TEMP TABLE _tmpMovement (MovementId Integer, DescId Integer, InvNumber TVarChar, OperDate TDateTime) ON COMMIT DROP;
         INSERT INTO _tmpMovement (MovementId, DescId, InvNumber, OperDate)
            SELECT Movement.Id, Movement.DescId, Movement.InvNumber, Movement.OperDate
            FROM Movement
            WHERE Movement.OperDate >= '01.07.2015'
            AND Movement.StatusId = zc_Enum_Status_UnComplete()
            AND Movement.DescId IN (zc_Movement_Income(), zc_Movement_Inventory(), zc_Movement_Loss(), zc_Movement_ProductionSeparate(), zc_Movement_ProductionUnion(), zc_Movement_ReturnIn(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_Send(), zc_Movement_SendOnPrice())
            ORDER BY Movement.OperDate
            LIMIT 100;
         --
         SELECT ' ' || COALESCE (Object_User.ValueData, '') || ' <' || TO_CHAR (MovementProtocol.OperDate, 'DD.MM HH24:MM') || '> документ <' || MovementDesc.ItemName || '>  № <' || tmp.InvNumber || '> Актуальность отчетов до:'
              , tmp.OperDate
                INTO vbValueData_new, vbOperDate_new
         FROM (SELECT _tmpMovement.MovementId, _tmpMovement.DescId, _tmpMovement.InvNumber, _tmpMovement.OperDate, MAX (MovementProtocol.Id) AS Id_find
               FROM _tmpMovement
                    INNER JOIN MovementProtocol ON MovementProtocol.MovementId = _tmpMovement.MovementId
               GROUP BY _tmpMovement.MovementId, _tmpMovement.DescId, _tmpMovement.InvNumber, _tmpMovement.OperDate
              ) AS tmp
              INNER JOIN MovementProtocol ON MovementProtocol.Id = tmp.Id_find
                                         AND MovementProtocol.OperDate < CURRENT_TIMESTAMP - INTERVAL '3 MINUTE'
              LEFT JOIN Object AS Object_User ON Object_User.Id = MovementProtocol.UserId
              LEFT JOIN MovementDesc ON MovementDesc.Id = tmp.DescId
         ORDER BY tmp.OperDate
         LIMIT 1;
                        
         --
         --
         UPDATE Object SET ValueData = COALESCE (vbValueData_new, 'Актуальность 100 %')
         WHERE Object.Id = 418996 -- актуальность данных Integer
           AND Object.DescId = zc_Object_GlobalConst();
         --
         UPDATE ObjectDate SET ValueData = COALESCE (vbOperDate_new, CURRENT_TIMESTAMP)
         WHERE ObjectDate.ObjectId = 418996 -- актуальность данных Integer
           AND ObjectDate.DescId = zc_ObjectDate_GlobalConst_ActualBankStatement();
     END IF;

     RETURN QUERY 
       SELECT Object_GlobalConst.Id
            , COALESCE (ActualBankStatement.ValueData, CURRENT_DATE) :: TDateTime AS OperDate
            , Object_GlobalConst.ValueData AS ValueText
            , ObjectString.ValueData AS EnumName
       FROM Object AS Object_GlobalConst
            LEFT JOIN ObjectDate AS ActualBankStatement 
                                 ON ActualBankStatement.DescId = zc_ObjectDate_GlobalConst_ActualBankStatement()
                                AND ActualBankStatement.ObjectId = Object_GlobalConst.Id
            LEFT JOIN ObjectString ON ObjectString.ObjectId = Object_GlobalConst.Id
                                  AND ObjectString.DescId = zc_ObjectString_Enum()
       WHERE Object_GlobalConst.DescId = zc_Object_GlobalConst()
         AND Object_GlobalConst.ObjectCode < 100
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GlobalConst(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.04.15                                        * add EnumName
 06.04.15                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GlobalConst (zfCalc_UserAdmin())
