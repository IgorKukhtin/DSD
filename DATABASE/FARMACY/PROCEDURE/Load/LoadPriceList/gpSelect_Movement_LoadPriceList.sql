 -- Function: gpSelect_Movement_PriceList()

DROP FUNCTION IF EXISTS gpSelect_Movement_LoadPriceList (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_LoadPriceList(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, OperDate TDateTime
             , JuridicalId Integer, JuridicalName TVarChar
             , AreaId Integer, AreaName TVarChar
             , ContractId Integer, ContractName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
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
             LoadPriceList.Id               AS Id
           , LoadPriceList.OperDate	    AS OperDate -- ���� ���������
           , Object_Juridical.Id            AS JuridicalId
           , Object_Juridical.ValueData     AS JuridicalName
           , Object_Area.Id                 AS AreaId
           , Object_Area.ValueData          AS AreaName
           , Object_Contract.Id             AS ContractId
           , Object_Contract.ValueData      AS ContractName
           
           , Object_User_Insert.ValueData   AS InsertName
           , LoadPriceList.Date_Insert      AS InsertDate

           , Object_User_Update.ValueData   AS UpdateName
           , LoadPriceList.Date_Update      AS UpdateDate
          
           , LoadPriceList.isAllGoodsConcat           
           , LoadPriceList.NDSinPrice           
           , COALESCE (LoadPriceList.isMoved, FALSE) :: Boolean AS isMoved
       FROM LoadPriceList
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = LoadPriceList.JuridicalId
            
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = LoadPriceList.ContractId

            LEFT JOIN Object AS Object_User_Insert ON Object_User_Insert.Id = LoadPriceList.UserId_Insert
            LEFT JOIN Object AS Object_User_Update ON Object_User_Update.Id = LoadPriceList.UserId_Update
            
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = LoadPriceList.AreaId  
            
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_LoadPriceList (TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.10.17         * LoadPriceList.AreaId
 25.09.17         * add AreaName
 01.07.14                        *

*/

-- ����
-- SELECT * FROM gpSelect_Movement_PriceList (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')
