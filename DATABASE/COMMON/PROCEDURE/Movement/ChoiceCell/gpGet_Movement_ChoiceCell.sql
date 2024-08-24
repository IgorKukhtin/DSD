-- Function: gpGet_Movement_ChoiceCell()

DROP FUNCTION IF EXISTS gpGet_Movement_ChoiceCell (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ChoiceCell(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ChoiceCell());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_ChoiceCell_seq') AS TVarChar) AS InvNumber
             , CURRENT_DATE   ::TDateTime                             AS OperDate
             , Object_Status.Code                                     AS StatusCode
             , Object_Status.Name                                     AS StatusName
          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS Object_Status
         ;
         
     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                               AS Id
           , Movement.InvNumber                        AS InvNumber
           , Movement.OperDate                         AS OperDate
           , Object_Status.ObjectCode                  AS StatusCode
           , Object_Status.ValueData                   AS StatusName
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
         WHERE Movement.Id = inMovementId
           AND Movement.DescId = zc_Movement_ChoiceCell();

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�. 
 24.08.24         *
*/

-- ����
-- SELECT * FROM gpGet_Movement_ChoiceCell (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin())