-- Function: gpSelect_Movement_Sale()

DROP FUNCTION IF EXISTS gpSelect_Movement_Sale (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Sale(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , TotalCount TFloat
             , TotalSumm TFloat
             , TotalSummSale TFloat
             , TotalSummPrimeCost TFloat
             , UnitId Integer
             , UnitName TVarChar
             , JuridicalId Integer
             , JuridicalName TVarChar
             , PaidKindId Integer
             , PaidKindName TVarChar
             , Comment TVarChar
             , OperDateSP TDateTime
             , PartnerMedicalName TVarChar
             , InvNumberSP TVarChar
             , MedicSPId   Integer
             , MedicSPName TVarChar
             , MemberSPId   Integer
             , MemberSPName TVarChar
             , GroupMemberSPName TVarChar
             , isSP Boolean
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbUnitId Integer;   
BEGIN

     vbUserId:= lpGetUserBySession (inSession);
     -- ������������ <�������� ����>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


     -- ����������� - ���� ���� ������ ������
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 308121 AND UserId = vbUserId)
     THEN
         vbUnitId:= zfConvert_StringToNumber (lpGet_DefaultValue ('zc_Object_Unit', vbUserId));
     ELSE
         vbUnitId:= 0;
     END IF;


     -- ���������
     RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
    , tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                    FROM ObjectLink AS ObjectLink_Unit_Juridical
                      INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                           ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                          AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                          AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                    WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                      AND (ObjectLink_Unit_Juridical.ObjectId = vbUnitId OR vbUnitId = 0)
                    )
        -- ���������
        SELECT
            Movement_Sale.Id
          , Movement_Sale.InvNumber
          , Movement_Sale.OperDate
          , Movement_Sale.StatusCode
          , Movement_Sale.StatusName
          , Movement_Sale.TotalCount
          , Movement_Sale.TotalSumm
          , Movement_Sale.TotalSummSale
          , Movement_Sale.TotalSummPrimeCost
          , Movement_Sale.UnitId
          , Movement_Sale.UnitName
          , Movement_Sale.JuridicalId
          , Movement_Sale.JuridicalName
          , Movement_Sale.PaidKindId
          , Movement_Sale.PaidKindName
          , Movement_Sale.Comment

          , Movement_Sale.OperDateSP
          , Movement_Sale.PartnerMedicalName
          , Movement_Sale.InvNumberSP
          , Movement_Sale.MedicSPid
          , Movement_Sale.MedicSPName
          , Movement_Sale.MemberSPId
          , Movement_Sale.MemberSPName 
          , Movement_Sale.GroupMemberSPName
          , CASE WHEN COALESCE (Movement_Sale.PartnerMedicalName,'') <> '' OR
                      COALESCE (Movement_Sale.InvNumberSP,'') <> '' OR
                      COALESCE (Movement_Sale.MedicSPName,'') <> '' OR
                      COALESCE (Movement_Sale.MemberSPName,'') <> ''
                 THEN TRUE
                 ELSE FALSE
            END ::Boolean AS isSP
        FROM
            tmpUnit
            LEFT JOIN Movement_Sale_View AS Movement_Sale ON Movement_Sale.UnitId = tmpUnit.UnitId
                                        AND Movement_Sale.OperDate BETWEEN inStartDate AND inEndDate
            INNER JOIN tmpStatus ON Movement_Sale.StatusId = tmpStatus.StatusId
            
        -- ORDER BY InvNumber
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Sale (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 08.02.17         * add SP
 04.05.16         * 
 13.10.15                                                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Sale (inStartDate:= '01.08.2016', inEndDate:= '01.08.2016', inIsErased := FALSE, inSession:= zfCalc_UserAdmin());
