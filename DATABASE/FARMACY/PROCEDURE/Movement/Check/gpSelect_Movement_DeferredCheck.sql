-- Function: gpSelect_Movement_DeferredCheck()

DROP FUNCTION IF EXISTS gpSelect_Movement_DeferredCheck (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_DeferredCheck(
    IN inUnitId        Integer,    -- �������������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, 
               TotalCount TFloat, TotalSumm TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY
         SELECT       
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , MovementFloat_TotalSumm.ValueData                  AS TotalSumm

        FROM (SELECT Movement.*
                   , MovementLinkObject_Unit.ObjectId                    AS UnitId
              FROM  MovementBoolean AS MovementBoolean_Deferred
              
                    INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                       AND Movement.DescId = zc_Movement_Check()
                                       AND Movement.StatusId = zc_Enum_Status_UnComplete()

                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()   
                                                 
                    WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                      AND MovementBoolean_Deferred.ValueData = TRUE
              ) AS Movement_Check 
              
             LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                     ON MovementFloat_TotalCount.MovementId = Movement_Check.Id
                                    AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
 
             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                     ON MovementFloat_TotalSumm.MovementId =  Movement_Check.Id
                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
        WHERE Movement_Check.UnitId = inUnitId

      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�. +
 19.07.19                                                                                    *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_DeferredCheck (inUnitId:= 1, inSession:= '3')

