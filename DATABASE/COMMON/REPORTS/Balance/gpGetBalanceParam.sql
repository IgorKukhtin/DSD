-- Function: gpReport_JuridicalCollation()

DROP FUNCTION IF EXISTS gpGetBalanceParam (TBlob ,TVarChar);

CREATE OR REPLACE FUNCTION gpGetBalanceParam(
    IN inData             TBlob , 
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (RootType Integer, AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer, InfoMoneyId Integer
             , ObjectDirectionId Integer, ObjectDestinationId Integer, JuridicalBasisId Integer, BusinessId Integer)
AS
$BODY$
DECLARE
  vbUserId Integer;
  vbIndex  Integer;
  vbRootType INTEGER;
  vbAccountGroupId INTEGER;
  vbAccountDirectionId INTEGER;
  vbAccountId INTEGER;
  vbInfoMoneyId INTEGER;
  vbObjectDirectionId INTEGER;
  vbObjectDestinationId INTEGER;
  vbJuridicalBasisId INTEGER;
  vbBusinessId INTEGER;
  vbData TVarChar;
  vbKey   TVarChar;
  vbValue TVarChar;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());
     vbUserId := lpGetUserBySession(inSession);

     vbIndex := 1;
     WHILE split_part(inData, ';', vbIndex) <> '' LOOP

         EXECUTE 'SELECT '||split_part(inData, ';', vbIndex) INTO vbData;
         IF vbData <> '' THEN
            EXECUTE 'SELECT '||split_part(vbData, '=', 1) INTO vbKey;
            EXECUTE 'SELECT '||split_part(vbData, '=', 2) INTO vbValue;

 --           CASE vbKey
   --             WHEN THEN ;
     --       END CASE; 
         END IF;
         vbIndex := vbIndex + 1;

     END LOOP;


     RETURN QUERY  
     SELECT  
       0 AS RootType
      ,0 AS AccountGroupI
      ,0 AS AccountDirectionId
      ,0 AS AccountId
      ,0 AS InfoMoneyId
      ,0 AS ObjectDirectionId
      ,0 AS ObjectDestinationId
      ,0 AS JuridicalBasisId
      ,0 AS BusinessId  ;
                                  
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGetBalanceParam (TBlob, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.03.14                         *  
*/

-- ����
-- SELECT * FROM gpReport_Fuel (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inBranchId:= null,inSession:= '2'); 
                                                                
