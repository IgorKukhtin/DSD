-- Function: gpSelect_PUSH_CashJackdawsGreen (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_PUSH_CashJackdawsGreen (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION gpSelect_PUSH_CashJackdawsGreen(
    IN inMovementID    Integer    , -- Movement PUSH
    IN inUnitID        Integer    , -- Подразделение
    IN inUserId        Integer      -- Cотрудник
)
RETURNS TABLE (Message TBlob
             , FormName TVarChar
             , Button TVarChar
             , Params TVarChar
             , TypeParams TVarChar
             , ValueParams TVarChar
             )
AS
$BODY$
BEGIN

   IF EXISTS(SELECT Movement.*
             FROM Movement

                  INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                              AND MovementLinkObject_Unit.ObjectId = inUnitID

                  LEFT JOIN MovementLinkObject AS MovementLinkObject_JackdawsChecks
                                               ON MovementLinkObject_JackdawsChecks.MovementId =  Movement.Id
                                              AND MovementLinkObject_JackdawsChecks.DescId = zc_MovementLinkObject_JackdawsChecks()
                  LEFT JOIN Object AS Object_JackdawsChecks ON Object_JackdawsChecks.Id = MovementLinkObject_JackdawsChecks.ObjectId

                  LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                               ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                              AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
                                              
             WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '3 DAY'
               AND Movement.StatusId = zc_Enum_Status_Complete()
               AND Movement.DescId = zc_Movement_Check()
               AND (COALESCE(Object_JackdawsChecks.ObjectCode, 0) <> 0
                OR COALESCE(MovementLinkObject_CashRegister.ObjectId, 0) = 0))
   THEN
     RETURN QUERY
     SELECT 'Есть чеки с зеленой галкой по которым надо пробить фискальный чек!'::TBlob AS Message,
            'TCheckJackdawsGreenJournalCashForm'::TVarChar                                  AS FormName,
            'Пробитие фискального чека по документам с зеленой галкой'::TVarChar       AS Button,
            ''::TVarChar            AS Params,
            ''::TVarChar            AS TypeParams,
            ''::TVarChar            AS ValueParams;
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_PUSH_CashTestingUser (Integer, Integer, Integer) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 04.02.21         *
*/

-- тест
-- select * from gpSelect_PUSH_CashJackdawsGreen(inMovementID := 0, inUnitID := 0, inUserId := 3);