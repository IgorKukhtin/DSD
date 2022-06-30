 -- Function: gpGet_GoodsSPSearch_1303()

DROP FUNCTION IF EXISTS gpGet_GoodsSPSearch_1303 (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_GoodsSPSearch_1303(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , OperDateStart TDateTime
             , OperDateEnd TDateTime
             )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbMovementId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSPSearch_1303());
    vbUserId:= lpGetUserBySession (inSession);

    SELECT Movement.Id                           AS Id
    INTO vbMovementId
    FROM Movement 

         LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                ON MovementDate_OperDateStart.MovementId = Movement.Id
                               AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()

         LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                ON MovementDate_OperDateEnd.MovementId = Movement.Id
                               AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

    WHERE Movement.DescId = zc_Movement_GoodsSPSearch_1303()
      AND Movement.StatusId = zc_Enum_Status_Complete()
      AND MovementDate_OperDateStart.ValueData <= CURRENT_DATE
      AND MovementDate_OperDateEnd.ValueData >= CURRENT_DATE 
    ORDER BY Movement.OperDate DESC
    LIMIT 1;
    
    IF COALESCE (vbMovementId, 0) = 0
    THEN
      RAISE EXCEPTION '��� ��������� "������ ������� ���. ������� 1303 ��� ������"';
    END IF;
        
    RETURN QUERY
         SELECT Movement.Id                            AS Id
              , Movement.InvNumber                     AS InvNumber
              , Movement.OperDate                      AS OperDate
              , Object_Status.ObjectCode               AS StatusCode
              , Object_Status.ValueData                AS StatusName
              , MovementDate_OperDateStart.ValueData   AS OperDateStart
              , MovementDate_OperDateEnd.ValueData     AS OperDateEnd
         FROM Movement
               LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
   
               LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                      ON MovementDate_OperDateStart.MovementId = Movement.Id
                                     AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
   
               LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                      ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                     AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

         WHERE Movement.Id = vbMovementId
           AND Movement.DescId = zc_Movement_GoodsSPSearch_1303();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.06.22                                                       *
*/

--����
-- 
SELECT * FROM gpGet_GoodsSPSearch_1303 (inSession:= '3')