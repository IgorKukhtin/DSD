-- Function: gpSelect_Object_ContractKind()

DROP FUNCTION IF EXISTS gpGet_Object_MedocLoadInfo(TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MedocLoadInfo(
    IN inDate        TDateTime,     -- ���� 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Period TDateTime, LoadDateTime TDateTime) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ContractKind());

   RETURN QUERY 
   SELECT 
         Object_MedocLoadInfo_View.Period     
       , Object_MedocLoadInfo_View.LoadDateTime     
      FROM  Object_MedocLoadInfo_View 
     WHERE Object_MedocLoadInfo_View.Period = date_trunc('month', inDate);
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_MedocLoadInfo (TDateTime,  TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.05.15                         * 
*/

-- ����
-- SELECT * FROM gpSelect_Object_ContractKind('2')