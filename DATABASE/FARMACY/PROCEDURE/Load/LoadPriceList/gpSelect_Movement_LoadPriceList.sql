-- Function: gpSelect_Movement_PriceList()

DROP FUNCTION IF EXISTS gpSelect_Movement_LoadPriceList (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_LoadPriceList(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, OperDate TDateTime
             , JuridicalId Integer, JuridicalName TVarChar
             , ContractId Integer, ContractName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , isAllGoodsConcat Boolean, NDSinPrice Boolean, isMoved Boolean)

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
--     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
       SELECT
             LoadPriceList.Id
           , LoadPriceList.OperDate	 -- ���� ���������
           , Object_Juridical.Id         AS JuridicalId
           , Object_Juridical.ValueData  AS JuridicalName
           , Object_Contract.Id          AS ContractId
           , Object_Contract.ValueData   AS ContractName
           
           , Object_User_Insert.ValueData   AS InsertName
           , LoadPriceList.Date_Insert      AS InsertDate
          
           , LoadPriceList.isAllGoodsConcat           
           , LoadPriceList.NDSinPrice           
           , LoadPriceList.isMoved
       FROM LoadPriceList
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = LoadPriceList.JuridicalId
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = LoadPriceList.ContractId

            LEFT JOIN Object AS Object_User_Insert ON Object_User_Insert.Id = LoadPriceList.UserId_Insert;
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_LoadPriceList (TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.07.14                        *

*/

-- ����
-- SELECT * FROM gpSelect_Movement_PriceList (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')