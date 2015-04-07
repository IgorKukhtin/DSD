-- Function: gpSelect_Object_Unit()

DROP FUNCTION IF EXISTS gpSelect_Object_GlobalConst(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GlobalConst(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, ActualBankStatementDate TDateTime) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

   RETURN QUERY 
       SELECT 
             GlobalConst.Id
           , ActualBankStatement.ValueData AS ActualBankStatementDate
       FROM Object AS GlobalConst 
              LEFT JOIN ObjectDate AS ActualBankStatement 
                     ON ActualBankStatement.DescId = zc_ObjectDate_GlobalConst_ActualBankStatement()
                    AND ActualBankStatement.ObjectId = GlobalConst.Id
      WHERE GlobalConst.DescId = zc_Object_GlobalConst();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GlobalConst(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.04.15                         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_GlobalConst ('2')