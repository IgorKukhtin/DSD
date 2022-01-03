-- Function: gpInsertUpdate_Movement_IlliquidUnit_Formation()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_IlliquidUnit_Formation (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_IlliquidUnit_Formation(
    IN inOperDate            TDateTime , -- Месяц формирования
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    inOperDate := date_trunc('month', inOperDate);

     -- Разрешаем только сотрудникам с правами админа
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION 'Формирование вам запрещено, обратитесь к системному администратору';
    END IF;

  PERFORM gpInsertUpdate_Movement_IlliquidUnit_FormationUnit (inOperDate := inOperDate, inUnitID := UnitList.UnitId,  inSession := inSession)
  FROM (
          WITH
          tmpCheck AS (SELECT DISTINCT MovementLinkObject_Unit.ObjectId                AS UnitId
                      FROM Movement

                           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                           INNER JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                                         ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                                        AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
                                                        AND COALESCE (MovementLinkObject_CashRegister.ObjectId, 0) <> 0

                      WHERE Movement.OperDate >= inOperDate - INTERVAL '1 MONTH'
                        AND Movement.OperDate < inOperDate + INTERVAL '1 DAY'
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                        AND Movement.DescId = zc_Movement_Check()
                      )
        , tmpUnit AS (SELECT Object_Unit.Id AS UnitId
                      FROM Object AS Object_Unit
                           INNER JOIN tmpCheck ON tmpCheck.UnitId = Object_Unit.Id
                           INNER JOIN ObjectLink AS ObjectLink_Unit_Parent
                                                 ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                                                AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
                                                AND ObjectLink_Unit_Parent.ChildObjectId > 0
                           INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                 ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = 4
                      WHERE Object_Unit.DescId = zc_Object_Unit()
                        AND Object_Unit.isErased = False
                      )

        SELECT tmpUnit.UnitId FROM tmpUnit) AS UnitList;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.12.19                                                       *
*/

-- SELECT * FROM gpInsertUpdate_Movement_IlliquidUnit_Formation (inOperDate := '23.12.2019', inSession := '3')