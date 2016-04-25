-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_Movement_IncomePharmacy (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_IncomePharmacy(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar, JuridicalName TVarChar, ContractName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar
             , SaleSumm TFloat
             , InvNumberBranch TVarChar, BranchDate TDateTime
             , Checked Boolean 
             , isDocument Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUnitId Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);
     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;   
     vbUnitId := vbUnitKey::Integer;

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
        , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND NOT EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              )

       SELECT
             Movement_Income_View.Id
           , Movement_Income_View.InvNumber
           , Movement_Income_View.OperDate
           , Movement_Income_View.StatusCode
           , Movement_Income_View.StatusName
           , Movement_Income_View.TotalCount
           , Movement_Income_View.FromId
           , Movement_Income_View.FromName
           , Movement_Income_View.ToId
           , Movement_Income_View.ToName
           , Movement_Income_View.JuridicalName
           , Movement_Income_View.ContractName
           , Movement_Income_View.NDSKindId
           , Movement_Income_View.NDSKindName
           , Movement_Income_View.SaleSumm
           , Movement_Income_View.InvNumberBranch
           , Movement_Income_View.BranchDate
           , Movement_Income_View.Checked
           , Movement_Income_View.isDocument

           , Object_Insert.ValueData              AS InsertName
           , ObjectDate_Protocol_Insert.ValueData AS InsertDate
           , Object_Update.ValueData              AS UpdateName
           , ObjectDate_Protocol_Update.ValueData AS UpdateDate
       FROM Movement_Income_View 
            JOIN tmpStatus ON tmpStatus.StatusId = Movement_Income_View.StatusId 

            LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                                 ON ObjectDate_Protocol_Insert.ObjectId = Movement_Income_View.Id
                                AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
            LEFT JOIN ObjectLink AS ObjectLink_Insert
                                 ON ObjectLink_Insert.ObjectId = Movement_Income_View.Id
                                AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId  

            LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                                 ON ObjectDate_Protocol_Update.ObjectId = Movement_Income_View.Id
                                AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()
            LEFT JOIN ObjectLink AS ObjectLink_Update
                                 ON ObjectLink_Update.ObjectId = Movement_Income_View.Id
                                AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId  

       WHERE Movement_Income_View.OperDate BETWEEN inStartDate AND inEndDate 
         AND Movement_Income_View.ToId = vbUnitId
       ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_IncomePharmacy (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.04.16         *
 28.04.15                        *
 11.02.15                        *
 23.12.14                        *
 15.07.14                                                        *
 10.07.14                                                        *

*/

-- ����
 --SELECT * FROM gpSelect_Movement_IncomePharmacy (inStartDate:= '30.01.2016', inEndDate:= '01.02.2016', inIsErased := FALSE, inSession:= '2')