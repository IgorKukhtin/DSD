-- Function: gpSelect_TechnicalRediscount_PUSH()

DROP FUNCTION IF EXISTS gpSelect_TechnicalRediscount_PUSH (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION gpSelect_TechnicalRediscount_PUSH(
    IN inMovementID    Integer    , -- Movement PUSH
    IN inUnitID                Integer    , -- Подразделение
    IN inUserId                Integer      -- Сотрудник
)
RETURNS TABLE (Message TBlob
             , FormName TVarChar
             , Button TVarChar
             , Params TVarChar
             , TypeParams TVarChar
             , ValueParams TVarChar)

AS
$BODY$
   DECLARE vbWeek       Integer;
   DECLARE vbId         Integer;
BEGIN

  IF COALESCE((SELECT ObjectBoolean_Unit_TechnicalRediscount.ValueData
               FROM ObjectBoolean AS ObjectBoolean_Unit_TechnicalRediscount
               WHERE ObjectBoolean_Unit_TechnicalRediscount.ObjectId = inUnitID
                 AND ObjectBoolean_Unit_TechnicalRediscount.DescId = zc_ObjectBoolean_Unit_TechnicalRediscount()), False) = False
  THEN
    RETURN;
  END IF;

  IF EXISTS(SELECT Movement.Id
            FROM Movement
                 INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                              AND MovementLinkObject_Unit.ObjectId = inUnitID
            WHERE Movement.OperDate = CURRENT_DATE
              AND Movement.DescId = zc_Movement_TechnicalRediscount())
  THEN
      SELECT Movement.Id
      INTO vbId
      FROM Movement
           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                        AND MovementLinkObject_Unit.ObjectId = inUnitID
      WHERE Movement.OperDate = CURRENT_DATE
        AND Movement.DescId = zc_Movement_TechnicalRediscount();
  ELSE
    RETURN;
  END IF;

  RETURN QUERY
  SELECT 'Коллеги, создан тех переучет для корректировок'::TBlob,
         'TTechnicalRediscountCashierForm'::TVarChar,
         'Технический переучет'::TVarChar,
         'Id'::TVarChar,
         'ftInteger'::TVarChar,
         vbId::TVarChar;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 19.02.20         *
*/

-- SELECT * FROM gpSelect_TechnicalRediscount_PUSH(183292 , 3);