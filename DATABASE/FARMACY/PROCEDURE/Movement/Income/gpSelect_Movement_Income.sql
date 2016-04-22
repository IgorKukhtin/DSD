-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_Movement_Income (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSummMVAT TFloat, TotalSumm TFloat
             , PriceWithVAT Boolean
             , FromId Integer, FromName TVarChar, FromOKPO TVarChar
             , ToId Integer, ToName TVarChar, JuridicalName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar
             , ContractId Integer, ContractName TVarChar
             , PaymentDate TDateTime, PaySumm TFloat, SaleSumm TFloat
             , InvNumberBranch TVarChar, BranchDate TDateTime
             , Checked Boolean, isDocument Boolean 
             , PayColor Integer
             , DateLastPay TDateTime
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
--     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
        , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND NOT EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              )
        , Movement_Income AS (
                               SELECT
                                     Movement_Income_View.Id
                                   , Movement_Income_View.InvNumber
                                   , Movement_Income_View.OperDate
                                   , Movement_Income_View.StatusCode
                                   , Movement_Income_View.StatusName
                                   , Movement_Income_View.TotalCount
                                   , Movement_Income_View.TotalSummMVAT
                                   , Movement_Income_View.TotalSumm
                                   , Movement_Income_View.PriceWithVAT
                                   , Movement_Income_View.FromId
                                   , Movement_Income_View.FromName 
                                   , ObjectHistoryString_JuridicalDetails_OKPO.ValueData AS FromOKPO
                                   , Movement_Income_View.ToId
                                   , Movement_Income_View.ToName
                                   , Movement_Income_View.JuridicalName
                                   , Movement_Income_View.NDSKindId
                                   , Movement_Income_View.NDSKindName
                                   , Movement_Income_View.ContractId
                                   , Movement_Income_View.ContractName
                                   , CASE WHEN Movement_Income_View.PaySumm > 0.01
                                            OR Movement_Income_View.StatusId <> zc_Enum_Status_Complete()
                                          THEN Movement_Income_View.PaymentDate 
                                     END::TDateTime AS PaymentDate
                                   , Movement_Income_View.PaySumm
                                   , Movement_Income_View.SaleSumm
                                   , Movement_Income_View.InvNumberBranch
                                   , Movement_Income_View.BranchDate
                                   , Movement_Income_View.Checked
                                   , Movement_Income_View.isDocument
                                   , CASE WHEN Movement_Income_View.PaySumm <= 0.01 THEN zc_Color_Goods_Additional() END::Integer AS PayColor
                                   , Movement_Income_View.PaymentContainerId
                               FROM Movement_Income_View 
                                     JOIN tmpStatus ON tmpStatus.StatusId = Movement_Income_View.StatusId 

                                     LEFT OUTER JOIN ObjectHistory AS ObjectHistory_Juridical
                                                                   ON ObjectHistory_Juridical.ObjectId = Movement_Income_View.FromId
                                                                  AND ObjectHistory_Juridical.DescId = zc_ObjectHistory_JuridicalDetails()
                                                                  AND Movement_Income_View.OperDate >= ObjectHistory_Juridical.StartDate AND Movement_Income_View.OperDate < ObjectHistory_Juridical.EndDate
                                     LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
                                                                   ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = ObjectHistory_Juridical.Id
                                                                  AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()

                               WHERE Movement_Income_View.OperDate BETWEEN inStartDate AND inEndDate
                              )
        SELECT 
            Movement_Income.Id
          , Movement_Income.InvNumber
          , Movement_Income.OperDate
          , Movement_Income.StatusCode
          , Movement_Income.StatusName
          , Movement_Income.TotalCount
          , Movement_Income.TotalSummMVAT
          , Movement_Income.TotalSumm
          , Movement_Income.PriceWithVAT
          , Movement_Income.FromId
          , Movement_Income.FromName
          , Movement_Income.FromOKPO
          , Movement_Income.ToId
          , Movement_Income.ToName
          , Movement_Income.JuridicalName
          , Movement_Income.NDSKindId
          , Movement_Income.NDSKindName
          , Movement_Income.ContractId
          , Movement_Income.ContractName
          , Movement_Income.PaymentDate
          , Movement_Income.PaySumm
          , Movement_Income.SaleSumm
          , Movement_Income.InvNumberBranch
          , Movement_Income.BranchDate
          , Movement_Income.Checked
          , Movement_Income.isDocument
          , Movement_Income.PayColor
          , MAX(MovementItemContainer.OperDate)::TDateTime AS LastDatePay

          , Object_Insert.ValueData              AS InsertName
          , ObjectDate_Protocol_Insert.ValueData AS InsertDate
          , Object_Update.ValueData              AS UpdateName
          , ObjectDate_Protocol_Update.ValueData AS UpdateDate


        FROM
            Movement_Income
            LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Movement_Income.PaymentContainerId
                                                 AND MovementItemContainer.MovementDescId in (zc_Movement_BankAccount(), zc_Movement_Payment())

            LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                                 ON ObjectDate_Protocol_Insert.ObjectId = Movement_Income.Id
                                AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
            LEFT JOIN ObjectLink AS ObjectLink_Insert
                                 ON ObjectLink_Insert.ObjectId = Movement_Income.Id
                                AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId  

            LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                                 ON ObjectDate_Protocol_Update.ObjectId = Movement_Income.Id
                                AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()
            LEFT JOIN ObjectLink AS ObjectLink_Update
                                 ON ObjectLink_Update.ObjectId = Movement_Income.Id
                                AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId  
        GROUP BY
            Movement_Income.Id
          , Movement_Income.InvNumber
          , Movement_Income.OperDate
          , Movement_Income.StatusCode
          , Movement_Income.StatusName
          , Movement_Income.TotalCount
          , Movement_Income.TotalSummMVAT
          , Movement_Income.TotalSumm
          , Movement_Income.PriceWithVAT
          , Movement_Income.FromId
          , Movement_Income.FromName
          , Movement_Income.FromOKPO
          , Movement_Income.ToId
          , Movement_Income.ToName
          , Movement_Income.JuridicalName
          , Movement_Income.NDSKindId
          , Movement_Income.NDSKindName
          , Movement_Income.ContractId
          , Movement_Income.ContractName
          , Movement_Income.PaymentDate
          , Movement_Income.PaySumm
          , Movement_Income.SaleSumm
          , Movement_Income.InvNumberBranch
          , Movement_Income.BranchDate
          , Movement_Income.Checked
          , Movement_Income.isDocument
          , Movement_Income.PayColor
          , Object_Insert.ValueData
          , ObjectDate_Protocol_Insert.ValueData
          , Object_Update.ValueData
          , ObjectDate_Protocol_Update.ValueData
;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Income (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 22.04.16         * 
 30.01.16         * 
 21.12.15                                                                        *
 10.12.15                                                                        *
 08.12.15                                                                        *
 28.04.15                        *
 11.02.15                        *
 23.12.14                        *
 15.07.14                                                        *
 10.07.14                                                        *

*/

-- ����
--SELECT * FROM gpSelect_Movement_Income (inStartDate:= '30.01.2016', inEndDate:= '01.02.2016', inIsErased := FALSE, inSession:= '2')