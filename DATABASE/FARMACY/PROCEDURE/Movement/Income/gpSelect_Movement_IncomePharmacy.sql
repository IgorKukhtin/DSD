-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_Movement_IncomePharmacy (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_IncomePharmacy(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSumm TFloat
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar, JuridicalName TVarChar, ContractName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar, NDS TFloat
             , SaleSumm TFloat
             , InvNumberBranch TVarChar, BranchDate TDateTime
             , Checked Boolean
             , isDocument Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , isConduct Boolean, DateConduct TDateTime
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUnitId Integer;
   DECLARE vbisShowAll Boolean;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);
     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;
     vbUnitId := vbUnitKey::Integer;
     
     vbisShowAll := EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin());

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , Movement_Income AS ( SELECT Movement_Income.Id
                                    , Movement_Income.InvNumber
                                    , Movement_Income.OperDate
                                    , Movement_Income.StatusId
                                    , MovementLinkObject_To.ObjectId        AS ToId
                                    , MovementLinkObject_From.ObjectId      AS FromId
                                    , MovementLinkObject_Juridical.ObjectId AS JuridicalId
                               FROM tmpStatus
                                    LEFT JOIN Movement AS Movement_Income ON Movement_Income.StatusId = tmpStatus.StatusId
                                                                         AND Movement_Income.OperDate >= inStartDate AND Movement_Income.OperDate <inEndDate + interval '1 day'
                                                                         AND Movement_Income.DescId = zc_Movement_Income()
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                  ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                 AND (MovementLinkObject_To.ObjectId = vbUnitId OR vbisShowAll = TRUE)

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                                 ON MovementLinkObject_Juridical.MovementId = Movement_Income.Id
                                                                AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                              )
        SELECT Movement_Income.Id
             , Movement_Income.InvNumber
             , Movement_Income.OperDate
             , Object_Status.ObjectCode                   AS StatusCode
             , Object_Status.ValueData                    AS StatusName
             , MovementFloat_TotalCount.ValueData         AS TotalCount
             , MovementFloat_TotalSumm.ValueData          AS TotalSumm

             , Object_From.Id                             AS FromId
             , Object_From.ValueData                      AS FromName

             , Object_To.Id                               AS ToId
             , Object_To.Name                             AS ToName

             , Object_Juridical.ValueData                 AS JuridicalName
             , Object_Contract.ValueData                  AS ContractName
             , MovementLinkObject_NDSKind.ObjectId        AS NDSKindId
             , Object_NDSKind.ValueData                   AS NDSKindName
             , ObjectFloat_NDSKind_NDS.ValueData          AS NDS

             , MovementFloat_TotalSummSale.ValueData      AS SaleSumm

             , MovementString_InvNumberBranch.ValueData   AS InvNumberBranch
             , MovementDate_Branch.ValueData              AS BranchDate

             , COALESCE (MovementBoolean_Checked.ValueData, FALSE)  :: Boolean AS Checked
             , COALESCE (MovementBoolean_Document.ValueData, FALSE) :: Boolean AS isDocument

             , Object_Insert.ValueData              AS InsertName
             , MovementDate_Insert.ValueData        AS InsertDate
             , Object_Update.ValueData              AS UpdateName
             , MovementDate_Update.ValueData        AS UpdateDate

             , COALESCE (MovementBoolean_Conduct.ValueData, FALSE)               AS isConduct
             , MovementDate_Conduct.ValueData                                    AS DateConduct

       FROM Movement_Income
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Income.StatusId
            LEFT JOIN Object_Unit_View AS Object_To ON Object_To.Id = Movement_Income.ToId
            LEFT JOIN Object AS Object_From ON Object_From.Id = Movement_Income.FromId
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Movement_Income.JuridicalId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement_Income.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummSale
                                    ON MovementFloat_TotalSummSale.MovementId = Movement_Income.Id
                                   AND MovementFloat_TotalSummSale.DescId = zc_MovementFloat_TotalSummSale()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement_Income.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                         ON MovementLinkObject_NDSKind.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
            LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = MovementLinkObject_NDSKind.ObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                 AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementString  AS MovementString_InvNumberBranch
                                      ON MovementString_InvNumberBranch.MovementId = Movement_Income.Id
                                     AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()
            LEFT JOIN MovementDate    AS MovementDate_Branch
                                      ON MovementDate_Branch.MovementId = Movement_Income.Id
                                     AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId = Movement_Income.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

            LEFT JOIN MovementBoolean AS MovementBoolean_Document
                                      ON MovementBoolean_Document.MovementId = Movement_Income.Id
                                     AND MovementBoolean_Document.DescId = zc_MovementBoolean_Document()

            LEFT JOIN MovementBoolean AS MovementBoolean_Conduct
                                      ON MovementBoolean_Conduct.MovementId = Movement_Income.Id
                                     AND MovementBoolean_Conduct.DescId = zc_MovementBoolean_Conduct()

            LEFT JOIN MovementDate AS MovementDate_Conduct
                                   ON MovementDate_Conduct.MovementId = Movement_Income.Id
                                  AND MovementDate_Conduct.DescId = zc_MovementDate_Conduct()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement_Income.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement_Income.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement_Income.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement_Income.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId
          ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.01.18         * add NDS
 22.04.16         *
 28.04.15                        *
 11.02.15                        *
 23.12.14                        *
 15.07.14                                                        *
 10.07.14                                                        *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_IncomePharmacy (inStartDate:= '01.08.2021', inEndDate:= '20.08.2021', inIsErased := FALSE, inSession:= '3')

select * from gpSelect_Movement_IncomePharmacy(instartdate := ('01.05.2022')::TDateTime , inenddate := ('31.05.2022')::TDateTime , inIsErased := 'False' ,  inSession := '3');


