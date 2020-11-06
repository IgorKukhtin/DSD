-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_Movement_ChoiceIncome (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ChoiceIncome(
    IN inUnitId        Integer ,
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSummMVAT TFloat, TotalSumm TFloat
             , TotalSummSample TFloat
             , PriceWithVAT Boolean
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar, JuridicalName TVarChar
             , NDSKindId Integer, NDSKindName TVarChar, NDS TFloat
             , ContractId Integer, ContractName TVarChar, SaleSumm TFloat
             , InvNumberBranch TVarChar, BranchDate TDateTime
             , Checked Boolean, isDocument Boolean, isRegistered Boolean
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , Comment TVarChar
             )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN


     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());

     RETURN QUERY
     WITH Movement_Income AS ( SELECT Movement_Income.Id
                                    , Movement_Income.InvNumber
                                    , Movement_Income.OperDate
                                    , Movement_Income.StatusId
                                    , MovementLinkObject_To.ObjectId        AS ToId
                                    , MovementLinkObject_From.ObjectId      AS FromId
                                    , MovementLinkObject_Juridical.ObjectId AS JuridicalId
                               FROM Movement AS Movement_Income 
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                  ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                 AND MovementLinkObject_To.ObjectId = inUnitId

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                                 ON MovementLinkObject_Juridical.MovementId = Movement_Income.Id
                                                                AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()

                                    LEFT JOIN MovementDate AS MovementDate_Payment
                                                           ON MovementDate_Payment.MovementId =  Movement_Income.Id
                                                          AND MovementDate_Payment.DescId = zc_MovementDate_Payment()
                                WHERE Movement_Income.StatusId in (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                                  AND Movement_Income.OperDate >= inStartDate AND Movement_Income.OperDate <inEndDate + interval '1 day'
                                  AND Movement_Income.DescId = zc_Movement_Income()
                              )
 
        SELECT Movement_Income.Id
             , Movement_Income.InvNumber
             , Movement_Income.OperDate
             , Object_Status.ObjectCode                   AS StatusCode
             , Object_Status.ValueData                    AS StatusName
             , MovementFloat_TotalCount.ValueData         AS TotalCount
             , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
             , MovementFloat_TotalSumm.ValueData          AS TotalSumm
             , MovementFloat_TotalSummSample.ValueData  ::TFloat AS TotalSummSample
             , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
             , Object_From.Id                             AS FromId
             , Object_From.ValueData                      AS FromName
             , Object_To.Id                               AS ToId      
             , Object_To.Name                             AS ToName
             , Object_Juridical.ValueData                 AS JuridicalName
             , MovementLinkObject_NDSKind.ObjectId        AS NDSKindId
             , Object_NDSKind.ValueData                   AS NDSKindName
             , ObjectFloat_NDSKind_NDS.ValueData          AS NDS
             , MovementLinkObject_Contract.ObjectId       AS ContractId
             , Object_Contract.ValueData                  AS ContractName
             , MovementFloat_TotalSummSale.ValueData      AS SaleSumm
             , MovementString_InvNumberBranch.ValueData   AS InvNumberBranch
             , MovementDate_Branch.ValueData              AS BranchDate
             , COALESCE(MovementBoolean_Checked.ValueData, false)     AS Checked
             , COALESCE(MovementBoolean_Document.ValueData, false)    AS isDocument
             , MovementBoolean_Registered.ValueData                   AS isRegistered -- !!!иногда будем возвращать NULL!!!

             , Object_Insert.ValueData              AS InsertName
             , MovementDate_Insert.ValueData        AS InsertDate
             , Object_Update.ValueData              AS UpdateName
             , MovementDate_Update.ValueData        AS UpdateDate

             , COALESCE (MovementString_Comment.ValueData,''):: TVarChar         AS Comment
        FROM Movement_Income

        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Income.StatusId
        LEFT JOIN Object_Unit_View AS Object_To ON Object_To.Id = Movement_Income.ToId
        LEFT JOIN Object AS Object_From ON Object_From.Id = Movement_Income.FromId
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Movement_Income.JuridicalId

        LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                ON MovementFloat_TotalCount.MovementId = Movement_Income.Id
                               AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId = Movement_Income.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummSale
                                ON MovementFloat_TotalSummSale.MovementId = Movement_Income.Id
                               AND MovementFloat_TotalSummSale.DescId = zc_MovementFloat_TotalSummSale()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummSample
                                ON MovementFloat_TotalSummSample.MovementId = Movement_Income.Id
                               AND MovementFloat_TotalSummSample.DescId = zc_MovementFloat_TotalSummSample()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                ON MovementFloat_TotalSummMVAT.MovementId = Movement_Income.Id
                               AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

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

        LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                  ON MovementBoolean_PriceWithVAT.MovementId = Movement_Income.Id
                                 AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

        LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                  ON MovementBoolean_Checked.MovementId = Movement_Income.Id
                                 AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

        LEFT JOIN MovementBoolean AS MovementBoolean_Registered
                                  ON MovementBoolean_Registered.MovementId = Movement_Income.Id
                                 AND MovementBoolean_Registered.DescId = zc_MovementBoolean_Registered()

        LEFT JOIN MovementBoolean AS MovementBoolean_Document
                                  ON MovementBoolean_Document.MovementId = Movement_Income.Id
                                 AND MovementBoolean_Document.DescId = zc_MovementBoolean_Document()

        LEFT JOIN MovementBoolean AS MovementBoolean_UseNDSKind
                                  ON MovementBoolean_UseNDSKind.MovementId = Movement_Income.Id
                                 AND MovementBoolean_UseNDSKind.DescId = zc_MovementBoolean_UseNDSKind()

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement_Income.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        -- точка другого юр.лица
        LEFT JOIN MovementBoolean AS MovementBoolean_Different
                                  ON MovementBoolean_Different.MovementId = Movement_Income.Id
                                 AND MovementBoolean_Different.DescId = zc_MovementBoolean_Different()

        LEFT JOIN MovementDate    AS MovementDate_Payment
                                  ON MovementDate_Payment.MovementId = Movement_Income.Id
                                 AND MovementDate_Payment.DescId = zc_MovementDate_Payment()

        LEFT JOIN MovementDate    AS MovementDate_Branch
                                  ON MovementDate_Branch.MovementId = Movement_Income.Id
                                 AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

        LEFT JOIN MovementDate    AS MovementDate_Check
                                  ON MovementDate_Check.MovementId = Movement_Income.Id
                                 AND MovementDate_Check.DescId = zc_MovementDate_Check()

        LEFT JOIN MovementString  AS MovementString_InvNumberBranch
                                  ON MovementString_InvNumberBranch.MovementId = Movement_Income.Id
                                 AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()

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
ALTER FUNCTION gpSelect_Movement_ChoiceIncome (Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.  Шаблий О.В.
 06.11.20                                                                                     * 

*/

-- тест

select * from gpSelect_Movement_ChoiceIncome(inUnitID := 11152911 , inStartDate := ('01.11.2020')::TDateTime , inEndDate := ('06.11.2020')::TDateTime ,  inSession := '3');