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
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar, JuridicalName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar
             , ContractId Integer, ContractName TVarChar
             , PaymentDate TDateTime, PaySumm TFloat, SaleSumm TFloat
             , InvNumberBranch TVarChar, BranchDate TDateTime, Checked Boolean 
             , CorrBonus TFloat, CorrOther TFloat, PayColor Integer
             , DateLastPay TDateTime
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
        , MovementBankAccount AS (  SELECT MovementBankAccount.OperDate, MLM_BankAccount_Income.MovementChildId
                                    FROM Movement AS MovementBankAccount
                                        INNER JOIN MovementLinkMovement AS MLM_BankAccount_Income
                                                                        ON MLM_BankAccount_Income.MovementId = MovementBankAccount.ID
                                                                       AND MLM_BankAccount_Income.DescId = zc_MovementLinkMovement_Child()
                                    WHERE
                                        MovementBankAccount.DescId = zc_Movement_BankAccount()
                                        AND
                                        MovementBankAccount.StatusId = zc_Enum_Status_Complete())

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
           , Movement_Income_View.CorrBonus
           , Movement_Income_View.CorrOther
           , CASE WHEN Movement_Income_View.PaySumm <= 0.01 THEN zc_Color_Goods_Additional() END::Integer AS PayColor
           , MovementBankAccount.OperDate AS DateLastPay
       FROM Movement_Income_View 
             JOIN tmpStatus ON tmpStatus.StatusId = Movement_Income_View.StatusId 
             LEFT OUTER JOIN MovementBankAccount ON MovementBankAccount.MovementChildId = Movement_Income_View.Id
             WHERE Movement_Income_View.OperDate BETWEEN inStartDate AND inEndDate;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Income (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 10.12.15                                                                        *
 08.12.15                                                                        *
 28.04.15                        *
 11.02.15                        *
 23.12.14                        *
 15.07.14                                                        *
 10.07.14                                                        *

*/

-- ����
-- SELECT * FROM gpSelect_Movement_Income (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')