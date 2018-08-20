-- Function: gpGet_Movement_RepriceChange_TotalSum()

DROP FUNCTION IF EXISTS gpGet_Movement_RepriceChange_TotalSum (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_RepriceChange_TotalSum(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (TotalSumm TFloat)
AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_RepriceChange());

    SELECT Movement_RepriceChange.TotalSum
    FROM Movement_RepriceChange_View AS Movement_RepriceChange
    WHERE Movement_RepriceChange.Id = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.08.18         *
*/
