-- Function: gpInsertUpdate_Movement_IlliquidUnit_Formation()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TechnicalRediscount_Formation (TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TechnicalRediscount_Formation(
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
  vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TechnicalRediscount());

  IF date_part('DAY',  CURRENT_DATE)::Integer <= 15
  THEN
      vbOperDate := date_trunc('month', CURRENT_DATE);
  ELSE
      vbOperDate := date_trunc('month', CURRENT_DATE) + INTERVAL '15 DAY';   
  END IF;

  PERFORM gpInsertUpdate_Movement_TechnicalRediscount (ioId := 0,
                                                       inInvNumber := CAST (NEXTVAL ('Movement_TechnicalRediscount_seq') AS TVarChar),
                                                       inOperDate := vbOperDate,
                                                       inUnitID := UnitList.UnitId,
                                                       inComment := '',
                                                       inSession := inSession)
  FROM (
          WITH
           tmpMovement AS (SELECT Movement.Id
                                , MovementLinkObject_Unit.ObjectId AS UnitId
                                      FROM Movement 
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                           WHERE Movement.OperDate = vbOperDate
                             AND Movement.DescId = zc_Movement_TechnicalRediscount() 
                           )
         , tmpUnit AS (SELECT Object_Unit.Id AS UnitId
                       FROM Object AS Object_Unit
                            INNER JOIN ObjectBoolean AS ObjectBoolean_Unit_TechnicalRediscount
                                                    ON ObjectBoolean_Unit_TechnicalRediscount.ObjectId = Object_Unit.Id
                                                   AND ObjectBoolean_Unit_TechnicalRediscount.DescId = zc_ObjectBoolean_Unit_TechnicalRediscount()
                                                   AND ObjectBoolean_Unit_TechnicalRediscount.ValueData = True
                            LEFT JOIN tmpMovement ON tmpMovement.UnitId = Object_Unit.Id
                       WHERE Object_Unit.DescId = zc_Object_Unit()
                         AND Object_Unit.isErased = False
                         AND COALESCE (tmpMovement.Id, 0) = 0
                      )

        SELECT tmpUnit.UnitId FROM tmpUnit) AS UnitList;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.02.20                                                       *
*/

--SELECT * FROM gpInsertUpdate_Movement_TechnicalRediscount_Formation (inSession := '3')