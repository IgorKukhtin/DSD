--- Function: gpInsertUpdate_Movement_IlliquidUnit_Formation()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TechnicalRediscount_Formation (TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TechnicalRediscount_Formation(
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
  vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TechnicalRediscount());

  PERFORM gpInsertUpdate_Movement_TechnicalRediscount (ioId           := 0,
                                                       inInvNumber    := CAST (NEXTVAL ('Movement_TechnicalRediscount_seq') AS TVarChar),
                                                       inOperDate     := CURRENT_DATE,
                                                       inUnitID       := UnitList.UnitId,
                                                       inComment      := '',
                                                       inisRedCheck   := FALSE,
                                                       inisAdjustment := FALSE,
                                                       inSession      := inSession)
  FROM (
          WITH
           tmpMovement AS (SELECT Movement.Id
                                , MovementLinkObject_Unit.ObjectId AS UnitId
                           FROM Movement 
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                LEFT JOIN MovementBoolean AS MovementBoolean_RedCheck
                                                          ON MovementBoolean_RedCheck.MovementId = Movement.Id
                                                         AND MovementBoolean_RedCheck.DescId = zc_MovementBoolean_RedCheck()
                                LEFT JOIN MovementBoolean AS MovementBoolean_Adjustment
                                                          ON MovementBoolean_Adjustment.MovementId = Movement.Id
                                                         AND MovementBoolean_Adjustment.DescId = zc_MovementBoolean_Adjustment()
                                LEFT JOIN MovementBoolean AS MovementBoolean_CorrectionSUN
                                                          ON MovementBoolean_CorrectionSUN.MovementId = Movement.Id
                                                         AND MovementBoolean_CorrectionSUN.DescId = zc_MovementBoolean_CorrectionSUN()
                           WHERE Movement.DescId = zc_Movement_TechnicalRediscount() 
                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                             AND COALESCE (MovementBoolean_RedCheck.ValueData, False) = False
                             AND COALESCE (MovementBoolean_Adjustment.ValueData, False) = False
                             AND COALESCE (MovementBoolean_CorrectionSUN.ValueData, False) = False
                           )
         , tmpUnit AS (SELECT Object_Unit_View.Id AS UnitId
                       FROM Object_Unit_View 
                            INNER JOIN ObjectBoolean AS ObjectBoolean_Unit_TechnicalRediscount
                                                    ON ObjectBoolean_Unit_TechnicalRediscount.ObjectId = Object_Unit_View.Id
                                                   AND ObjectBoolean_Unit_TechnicalRediscount.DescId = zc_ObjectBoolean_Unit_TechnicalRediscount()
                                                   AND ObjectBoolean_Unit_TechnicalRediscount.ValueData = True
                            LEFT JOIN tmpMovement ON tmpMovement.UnitId = Object_Unit_View.Id
                       WHERE Object_Unit_View.isErased = False
                         AND COALESCE (Object_Unit_View.ParentId, 0) <> 377612
                         AND Object_Unit_View.Id <> 389328
                         AND Object_Unit_View.Name NOT ILIKE 'Зачинена%'
                         AND COALESCE (Object_Unit_View.ParentId, 0) IN 
                             (SELECT DISTINCT U.Id FROM Object_Unit_View AS U WHERE U.isErased = False AND COALESCE (U.ParentId, 0) = 0) 
                         AND COALESCE (tmpMovement.Id, 0) = 0
                      )

        SELECT tmpUnit.UnitId FROM tmpUnit) AS UnitList;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.02.20                                                       *
*/

-- SELECT * FROM gpInsertUpdate_Movement_TechnicalRediscount_Formation (inSession := '3')