-- Function: gpGet_Movement_PriceList()

DROP FUNCTION IF EXISTS gpGet_Movement_PriceList (Integer, TDateTime, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_PriceList(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , ContractId Integer, ContractName TVarChar
             , AreaId Integer, AreaName TVarChar
             , PriceListId Integer
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_PriceList());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                                                AS Id
             , CAST (NEXTVAL ('movement_pricelist_seq') AS TVarChar) AS InvNumber
             , inOperDate                                       AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , 0                     		                AS JuridicalId
             , CAST ('' AS TVarChar) 		                AS JuridicalName
             , 0                     		                AS ContractId
             , CAST ('' AS TVarChar) 			        AS ContractName
             , 0                     		                AS AreaId
             , CAST ('' AS TVarChar) 			        AS AreaName
           
             , 0                                                AS PriceListId

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                          AS Id
           , Movement.InvNumber                   AS InvNumber
           , Movement.OperDate                    AS OperDate
           , Object_Status.ObjectCode             AS StatusCode
           , Object_Status.ValueData              AS StatusName
           , Object_Juridical.Id                  AS JuridicalId
           , Object_Juridical.ValueData           AS JuridicalName
           , Object_Contract.Id                   AS ContractId
           , Object_Contract.ValueData            AS ContractName
           , Object_Area.Id                       AS AreaId
           , Object_Area.ValueData                AS AreaName
           , LoadPriceList.Id                     AS PriceListId

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                         ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                        AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

            LEFT JOIN LoadPriceList ON LoadPriceList.JuridicalId = Object_Juridical.Id
                                   AND LoadPriceList.ContractId  = Object_Contract.Id
                                   
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                         ON MovementLinkObject_Area.MovementId = Movement.Id
                                        AND MovementLinkObject_Area.DescId = zc_MovementLinkObject_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = MovementLinkObject_Area.ObjectId
            --LEFT JOIN Object AS Object_Area ON Object_Area.Id = LoadPriceList.AreaId 
            
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_PriceList();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_PriceList (Integer, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.09.17         * add AreaName
 01.07.14                                                        *
*/

-- ����
-- SELECT * FROM gpGet_Movement_PriceList (inMovementId:= 1, inSession:= '9818')