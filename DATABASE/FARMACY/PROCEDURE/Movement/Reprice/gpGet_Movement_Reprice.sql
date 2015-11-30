-- Function: gpGet_Movement_Reprice()

DROP FUNCTION IF EXISTS gpGet_Movement_Reprice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Reprice(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , TotalSumm TFloat
             , UnitId Integer
             , UnitName TVarChar
             , GUID TVarChar
             )
AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Reprice());

    RETURN QUERY
    SELECT
        Movement_Reprice.Id
      , Movement_Reprice.InvNumber
      , Movement_Reprice.OperDate
      , Movement_Reprice.TotalSumm
      , Movement_Reprice.UnitId
      , Movement_Reprice.UnitName
      , Movement_Reprice.GUID
    FROM
        Movement_Reprice_View AS Movement_Reprice
    WHERE Movement_Reprice.Id =  inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Reprice (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 27.11.15                                                                        *
*/
