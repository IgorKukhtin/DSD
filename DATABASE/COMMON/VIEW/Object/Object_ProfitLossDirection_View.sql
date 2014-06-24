-- View: Object_ProfitLossDirection_View

CREATE OR REPLACE VIEW Object_ProfitLossDirection_View AS
      SELECT ProfitLossGroupId
           , ProfitLossGroupCode
           , ProfitLossGroupName

           , ProfitLossDirectionId
           , ProfitLossDirectionCode
           , ProfitLossDirectionName

      FROM Object_ProfitLoss_View
      GROUP BY ProfitLossGroupId, ProfitLossGroupCode, ProfitLossGroupName
             , ProfitLossDirectionId, ProfitLossDirectionCode, ProfitLossDirectionName;

ALTER TABLE Object_ProfitLossDirection_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.11.13                                        *
*/

-- ����
-- SELECT * FROM Object_ProfitLossDirection_View