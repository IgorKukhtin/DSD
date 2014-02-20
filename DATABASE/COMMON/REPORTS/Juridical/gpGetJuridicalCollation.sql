-- Function: gpReport_JuridicalCollation()

DROP FUNCTION IF EXISTS gpGetJuridicalCollation (TVarChar);

CREATE OR REPLACE FUNCTION gpGetJuridicalCollation(
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (MainJuridicalId Integer, MainJuridicalName TVarChar)
AS
$BODY$
DECLARE
  vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());
     vbUserId := lpGetUserBySession(inSession);

     -- ���� ������, ������� ������� ������� � ��������. 
     -- ������� ������ - ����� ����������. �������� ���������� �� ������ ������ 20400 ��� ������� � 30500 ��� �������� �������
     RETURN QUERY  
     SELECT  
          Object_Juridical.Id
        , Object_Juridical.valuedata
     FROM Object AS Object_Juridical 
          
    WHERE Object_Juridical.Id IN (SELECT to_number(lpGet_DefaultValue('zc_Object_Juridical', 1), '000000'));
                                  
    -- �����. �������� ��������� ������. 
    -- ����� �������

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGetJuridicalCollation (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.02.14                         *  
*/

-- ����
-- SELECT * FROM gpReport_Fuel (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inBranchId:= null,inSession:= '2'); 
                                                                
