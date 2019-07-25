-- Function: gpSelect_Movement_ChoiceSend()

DROP FUNCTION IF EXISTS gpSelect_Movement_ChoiceSend (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ChoiceSend(
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
             Movement_Send.Id
           , Movement_Send.InvNumber
           , Movement_Send.OperDate
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , MovementFloat_TotalSumm.ValueData                  AS TotalSumm

        FROM (SELECT Movement.*
              FROM  Movement 

                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                 ON MovementLinkObject_From.MovementId = Movement.Id
                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                 
                    WHERE Movement.DescId = zc_Movement_Send()
                      AND Movement.StatusId = zc_Enum_Status_UnComplete()
                      AND MovementLinkObject_From.ObjectId = inUnitId
              ) AS Movement_Send
              
             LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                     ON MovementFloat_TotalCount.MovementId = Movement_Send.Id
                                    AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
 
             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                     ON MovementFloat_TotalSumm.MovementId =  Movement_Send.Id
                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�. +
 24.07.19                                                                                    *
*/

-- ����
-- 
SELECT * FROM gpSelect_Movement_ChoiceSend (inUnitId:= 394426  , inSession:= '3')

