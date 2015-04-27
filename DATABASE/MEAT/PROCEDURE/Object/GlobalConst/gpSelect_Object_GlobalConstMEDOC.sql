-- Function: gpSelect_Object_Unit()

DROP FUNCTION IF EXISTS gpSelect_Object_GlobalConstMEDOC(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GlobalConstMEDOC(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, OperDate TDateTime, ValueText TVarChar) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

   RETURN QUERY 
       SELECT 
             GlobalConst.Id
           , COALESCE(ActualBankStatement.ValueData, CURRENT_DATE)::TDateTime
           , GlobalConst.ValueData
      FROM Object AS GlobalConst 
              LEFT JOIN ObjectDate AS ActualBankStatement 
                     ON ActualBankStatement.DescId = zc_ObjectDate_GlobalConst_ActualBankStatement()
                    AND ActualBankStatement.ObjectId = GlobalConst.Id
      WHERE GlobalConst.Id = zc_Enum_GlobalConst_MedocTaxDate();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GlobalConstMEDOC(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.04.15                         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_GlobalConst ('2')