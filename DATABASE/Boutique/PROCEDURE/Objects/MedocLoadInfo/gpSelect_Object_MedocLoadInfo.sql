-- Function: gpSelect_Object_ContractKind()

DROP FUNCTION IF EXISTS gpSelect_Object_MedocLoadInfo(TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MedocLoadInfo(
    IN inStartDate   TDateTime,     -- ���� ��������� 
    IN inEndDate     TDateTime,     -- ���� ��������
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
     WHERE Object_MedocLoadInfo_View.Period >= inStartDate AND Object_MedocLoadInfo_View.Period <= inEndDate;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MedocLoadInfo (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.05.15                         * 
*/

-- ����
-- SELECT * FROM gpSelect_Object_ContractKind('2')