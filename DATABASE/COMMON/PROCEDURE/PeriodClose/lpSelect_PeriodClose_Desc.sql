-- Function: lpSelect_PeriodClose_Desc (TVarChar)

DROP FUNCTION IF EXISTS lpSelect_PeriodClose_Desc (TVarChar);

CREATE OR REPLACE FUNCTION lpSelect_PeriodClose_Desc(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (DescId Integer, MovementDescId Integer, DescName TVarChar)
AS
$BODY$
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());


     -- ��������� - ���������, �������� ? :)
     RETURN QUERY 
        -- �������; ������� �� ����������
        SELECT 1                     AS DescId
             , MovementDesc.Id       AS MovementDescId
             , MovementDesc.ItemName AS DescName
        FROM MovementDesc
        WHERE Id IN (zc_Movement_Sale(), zc_Movement_ReturnIn()/*, zc_Movement_SendOnPrice()*/)
       UNION ALL
        -- ��������� ���������; ������������� � ��������� ���������
        SELECT 2                                           AS DescId
             , MovementDesc.Id       AS MovementDescId
             , MovementDesc.ItemName AS DescName
        FROM MovementDesc
        WHERE Id IN (zc_Movement_Tax(), zc_Movement_TaxCorrective())
       UNION ALL
        -- ���������� ����� �� ������������ ����; ���������� �� ������������ ���� (������� ������� ��������)
        SELECT 3                                           AS DescId
             , MovementDesc.Id       AS MovementDescId
             , MovementDesc.ItemName AS DescName
        FROM MovementDesc
        WHERE Id IN (zc_Movement_Service(), zc_Movement_ProfitLossService())
       UNION ALL
        -- ������� ����� (������); ������� ����� (������)
        SELECT 4                                           AS DescId
             , MovementDesc.Id       AS MovementDescId
             , MovementDesc.ItemName AS DescName
        FROM MovementDesc
        WHERE Id IN (zc_Movement_TransferDebtIn(), zc_Movement_TransferDebtOut())
       ORDER BY 1, 2
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpSelect_PeriodClose_Desc (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.04.16                                        *
*/

-- ����
-- SELECT * FROM lpSelect_PeriodClose_Desc (inSession:= zfCalc_UserAdmin()); 
