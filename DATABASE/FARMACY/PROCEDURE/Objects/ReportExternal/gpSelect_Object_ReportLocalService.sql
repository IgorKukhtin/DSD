-- Function: gpSelect_Object_ReportLocalService()

DROP FUNCTION IF EXISTS gpSelect_Object_ReportLocalService (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReportLocalService(
    IN inSession     TVarChar            -- ������ ������������
)
RETURNS TABLE (Id Integer
             , Code Integer
             , Name     TVarChar
             , isErased Boolean
              ) 
AS
$BODY$
BEGIN

      -- �������� ���� ������������ �� ����� ���������
      -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReportExternal());

      RETURN QUERY
        SELECT 0
             , 0 AS Code
             , 'gpReport_IncomeConsumptionBalance'::TVarChar  AS Name
             , False
        ORDER BY 3
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.   ������ �.�.
  15.04.19                                                                       *
*/

-- ����
-- update Object set ValueData = '' where Id = 1208446
-- SELECT * FROM gpSelect_Object_ReportLocalService (inSession:= zfCalc_UserAdmin())
