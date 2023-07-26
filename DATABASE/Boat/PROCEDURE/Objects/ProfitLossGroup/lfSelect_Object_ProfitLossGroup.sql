-- Function: lfSelect_Object_ProfitLossGroup ()

-- DROP FUNCTION lfSelect_Object_ProfitLossGroup ();

CREATE OR REPLACE FUNCTION lfSelect_Object_ProfitLossGroup()

RETURNS TABLE (ProfitLossGroupId Integer, ProfitLossGroupCode Integer, ProfitLossGroupName TVarChar)
AS
$BODY$
BEGIN

     -- �������� � ���������� ������ �� �����������
     RETURN QUERY 
     
      SELECT 
		    lfObject_ProfitLoss.ProfitLossGroupId         AS ProfitLossGroupId
		  , lfObject_ProfitLoss.ProfitLossGroupCode       AS ProfitLossGroupCode
		  , lfObject_ProfitLoss.ProfitLossGroupName       AS ProfitLossGroupName
     
      FROM lfSelect_Object_ProfitLoss() AS lfObject_ProfitLoss              

      GROUP BY lfObject_ProfitLoss.ProfitLossGroupId, lfObject_ProfitLoss.ProfitLossGroupCode, lfObject_ProfitLoss.ProfitLossGroupName;

 
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.08.13                                        *
*/

-- ����
-- SELECT * FROM lfSelect_Object_ProfitLossGroup()
