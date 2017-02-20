-- Function: gpGet_Movement_Sale_TotalSumm()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale_TotalSumm (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Sale_TotalSumm(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (TotalCount TFloat
             , TotalSumm  TFloat
             , TotalSummSale TFloat
             , TotalSummPrimeCost TFloat)
AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Sale());

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RETURN QUERY
        SELECT
            0::TFloat                                     AS TotalCount
          , 0::TFloat                                     AS TotalSumm
          , 0::TFloat                                     AS TotalSummSale
          , 0::TFloat                                     AS TotalSummPrimeCost;
    ELSE
        RETURN QUERY
        SELECT
            Movement_Sale.TotalCount
          , Movement_Sale.TotalSumm
          , Movement_Sale.TotalSummSale
          , Movement_Sale.TotalSummPrimeCost
        FROM
            Movement_Sale_View AS Movement_Sale
        WHERE Movement_Sale.Id =  inMovementId;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Sale_TotalSumm (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 17.02.17         * add TotalSummSale
 13.10.15                                                                        *
*/
