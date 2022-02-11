-- Function: lpSelect_PeriodClose_Desc (TVarChar)

DROP FUNCTION IF EXISTS lpSelect_PeriodClose_Desc (TVarChar);
DROP FUNCTION IF EXISTS lpSelect_PeriodClose_Desc (Integer);

CREATE OR REPLACE FUNCTION lpSelect_PeriodClose_Desc(
    IN inUserId  Integer -- ������������
)
RETURNS TABLE (DescId Integer, MovementDescId Integer, DescName TVarChar)
AS
$BODY$
BEGIN

     -- ��������� - ���������, �������� ? :)
     RETURN QUERY 
        -- �������; ������� �� ����������
        SELECT 1                     AS DescId
             , MovementDesc.Id       AS MovementDescId
             , MovementDesc.ItemName AS DescName
        FROM MovementDesc
        WHERE Id IN (zc_Movement_Sale()/*, zc_Movement_ReturnIn()*/ /*, zc_Movement_SendOnPrice()*/)

       UNION ALL
        SELECT 2                     AS DescId
             , MovementDesc.Id       AS MovementDescId
             , MovementDesc.ItemName AS DescName
        FROM MovementDesc
        WHERE Id IN (zc_Movement_ReturnIn())


       UNION ALL
        -- ��������� ���������; ������������� � ��������� ���������
        SELECT 3                     AS DescId
             , MovementDesc.Id       AS MovementDescId
             , MovementDesc.ItemName AS DescName
        FROM MovementDesc
        WHERE Id IN (zc_Movement_Tax()/*, zc_Movement_TaxCorrective()*/)
       UNION ALL
        -- ��������� ���������; ������������� � ��������� ���������
        SELECT 4                     AS DescId
             , MovementDesc.Id       AS MovementDescId
             , MovementDesc.ItemName AS DescName
        FROM MovementDesc
        WHERE Id IN (zc_Movement_TaxCorrective())

       UNION ALL
        -- ���������� ����� �� ������������ ����; ���������� �� ������������ ���� (������� ������� ��������)
        SELECT 11                     AS DescId
             , MovementDesc.Id       AS MovementDescId
             , MovementDesc.ItemName AS DescName
        FROM MovementDesc
      --WHERE Id IN (zc_Movement_Service(), zc_Movement_ProfitLossService())
        WHERE Id IN (zc_Movement_Service())

       UNION ALL
        -- ������� ����� (������); ������� ����� (������)
        SELECT 12                     AS DescId
             , MovementDesc.Id       AS MovementDescId
             , MovementDesc.ItemName AS DescName
        FROM MovementDesc
        WHERE Id IN (zc_Movement_TransferDebtIn(), zc_Movement_TransferDebtOut())

       ORDER BY 1, 2
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpSelect_PeriodClose_Desc (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.04.16                                        *
*/

-- ����
-- SELECT * FROM lpSelect_PeriodClose_Desc (inUserId:= zfCalc_UserAdmin() :: Integer); 
