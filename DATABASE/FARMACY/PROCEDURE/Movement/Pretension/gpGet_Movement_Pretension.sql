-- Function: gpGet_Movement_Pretension()

DROP FUNCTION IF EXISTS gpGet_Movement_Pretension (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Pretension(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , PriceWithVAT Boolean
             , isDeferred Boolean
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar
             , IncomeMovementId Integer 
             , IncomeOperDate TDateTime, IncomeInvNumber TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , Comment TBlob, BranchDate TDateTime
             , ActName TVarChar
)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Pretension());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
       RAISE EXCEPTION '������. �������� "��������� ����������" ���������� �� �������.';
     ELSE

     RETURN QUERY
       SELECT
             Movement_Pretension_View.Id
           , Movement_Pretension_View.InvNumber
           , Movement_Pretension_View.OperDate
           , Movement_Pretension_View.StatusCode
           , Movement_Pretension_View.StatusName
           , Movement_Pretension_View.PriceWithVAT
           , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) ::Boolean  AS isDeferred
           , Movement_Pretension_View.FromId
           , Movement_Pretension_View.FromName
           , Movement_Pretension_View.ToId
           , Movement_Pretension_View.ToName
           , Movement_Pretension_View.NDSKindId
           , Movement_Pretension_View.NDSKindName
           , Movement_Pretension_View.MovementIncomeId
           , Movement_Pretension_View.IncomeOperDate
           , Movement_Pretension_View.IncomeInvNumber
           , Movement_Pretension_View.JuridicalId
           , Movement_Pretension_View.JuridicalName
           , Movement_Pretension_View.Comment
           , Movement_Pretension_View.BranchDate
           , CASE WHEN Movement_Pretension_View.ToId = 59611 THEN '��� �� ��������� ����'
                  WHEN Movement_Pretension_View.ToId = 59612 THEN '��� �� ��������� ����'
                  ELSE '��� �� ��������� ����' END::TVarChar AS ActName

       FROM Movement_Pretension_View       

           LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                     ON MovementBoolean_Deferred.MovementId = Movement_Pretension_View.Id
                                    AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

      WHERE Movement_Pretension_View.Id = inMovementId;

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Pretension (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.12.21                                                       *
*/

-- ����
-- 
select * from gpGet_Movement_Pretension(inMovementId := 26008006 ,  inSession := '3');