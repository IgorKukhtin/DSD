-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_Movement_Income (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Income (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Income(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime ,
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumberPartner TVarChar
             , OperDate TDateTime, OperDatePartner TDateTime
             , StatusCode Integer, StatusName TVarChar
             , PriceWithVAT Boolean
             , VATPercent TFloat, DiscountTax TFloat
             , SummTaxPVAT TFloat
             , SummTaxMVAT TFloat
             , SummPost TFloat
             , SummPack TFloat
             , SummInsur TFloat
             , TotalDiscountTax TFloat
             , TotalSummTaxPVAT TFloat
             , TotalSummTaxMVAT TFloat 
             , TotalSummMVAT TFloat, Summ2 TFloat, Summ3 TFloat, Summ4 TFloat
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , Comment TVarChar
             , InsertId Integer, InsertName TVarChar, InsertDate TDateTime
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Income());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0                         AS Id
             , CAST (NEXTVAL ('movement_Income_seq') AS TVarChar) AS InvNumber
             , CAST ('' AS TVarChar)     AS InvNumberPartner
             , inOperDate   ::TDateTime   AS OperDate     --CURRENT_DATE
             , NULL ::TDateTime          AS OperDatePartner 
             , Object_Status.Code        AS StatusCode
             , Object_Status.Name        AS StatusName
             , CAST (False as Boolean)   AS PriceWithVAT
             , CAST (0 as TFloat)        AS VATPercent
             , CAST (0 as TFloat)        AS DiscountTax

             , CAST (0 as TFloat)        AS SummTaxMVAT
             , CAST (0 as TFloat)        AS SummTaxPVAT
             , CAST (0 as TFloat)        AS SummPost
             , CAST (0 as TFloat)        AS SummPack
             , CAST (0 as TFloat)        AS SummInsur
             , CAST (0 as TFloat)        AS TotalDiscountTax 
             , CAST (0 as TFloat)        AS TotalSummTaxPVAT
             , CAST (0 as TFloat)        AS TotalSummTaxMVAT
              --
             , CAST (0 as TFloat)        AS TotalSummMVAT
               -- сумма без НДС, после п.1.
             , CAST (0 as TFloat)        AS Summ2
               -- сумма без НДС, после п.2.
             , CAST (0 as TFloat)        AS Summ3
               -- сумма без НДС, после п.3.
             , CAST (0 as TFloat)        AS Summ4

             , 0                         AS FromId
             , CAST ('' AS TVarChar)     AS FromName
             , Object_To.Id              AS ToId
             , Object_To.ValueData       AS ToName
             , 0                         AS PaidKindId
             , CAST ('' AS TVarChar)     AS PaidKindName
             , CAST ('' AS TVarChar)     AS Comment

             , Object_Insert.Id                AS InsertId
             , Object_Insert.ValueData         AS InsertName
             , CURRENT_TIMESTAMP  ::TDateTime  AS InsertDate
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
               LEFT JOIN Object AS Object_To ON Object_To.Id = 35139 -- Склад Основной
          ;

     ELSE

     RETURN QUERY

        SELECT 
            Movement_Income.Id
          , Movement_Income.InvNumber
          , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
          , Movement_Income.OperDate                  AS OperDate
          , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
          , Object_Status.ObjectCode                  AS StatusCode
          , Object_Status.ValueData                   AS StatusName

          , MovementBoolean_PriceWithVAT.ValueData    AS PriceWithVAT
          , MovementFloat_VATPercent.ValueData        AS VATPercent
          , MovementFloat_DiscountTax.ValueData       AS DiscountTax
          , MovementFloat_SummTaxPVAT.ValueData       :: TFloat AS SummTaxPVAT
          , MovementFloat_SummTaxMVAT.ValueData       :: TFloat AS SummTaxMVAT
          , MovementFloat_SummPost.ValueData          :: TFloat AS SummPost
          , MovementFloat_SummPack.ValueData          :: TFloat AS SummPack
          , MovementFloat_SummInsur.ValueData         :: TFloat AS SummInsur
          , MovementFloat_TotalDiscountTax.ValueData  :: TFloat AS TotalDiscountTax
          , MovementFloat_TotalSummTaxPVAT.ValueData  :: TFloat AS TotalSummTaxPVAT
          , MovementFloat_TotalSummTaxMVAT.ValueData  :: TFloat AS TotalSummTaxMVAT
          --
          , MovementFloat_TotalSummMVAT.ValueData                     :: TFloat AS TotalSummMVAT
            -- сумма без НДС, после п.1.
          , (COALESCE (MovementFloat_TotalSummMVAT.ValueData,0)
             - COALESCE (MovementFloat_SummTaxMVAT.ValueData,0))      :: TFloat AS Summ2
            -- сумма без НДС, после п.2.
          , (COALESCE (MovementFloat_TotalSummMVAT.ValueData,0) 
             - COALESCE (MovementFloat_SummTaxMVAT.ValueData,0) 
             + COALESCE (MovementFloat_SummPost.ValueData,0)
             + COALESCE (MovementFloat_SummPack.ValueData,0)
             + COALESCE (MovementFloat_SummInsur.ValueData,0))        :: TFloat AS Summ3
            -- сумма без НДС, после п.3.
          , (COALESCE (MovementFloat_TotalSummMVAT.ValueData,0) 
             - COALESCE (MovementFloat_SummTaxMVAT.ValueData,0) 
             + COALESCE (MovementFloat_SummPost.ValueData,0)
             + COALESCE (MovementFloat_SummPack.ValueData,0)
             + COALESCE (MovementFloat_SummInsur.ValueData,0)
             - COALESCE (MovementFloat_TotalSummTaxMVAT.ValueData,0)) :: TFloat AS Summ4

          --
          , Object_From.Id                            AS FromId
          , Object_From.ValueData                     AS FromName
          , Object_To.Id                              AS ToId      
          , Object_To.ValueData                       AS ToName
          , Object_PaidKind.Id                        AS PaidKindId      
          , Object_PaidKind.ValueData                 AS PaidKindName
          , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment

          , Object_Insert.Id                     AS InsertId
          , Object_Insert.ValueData              AS InsertName
          , MovementDate_Insert.ValueData        AS InsertDate
        FROM Movement AS Movement_Income 
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Income.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId 

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement_Income.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId 

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId = Movement_Income.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_Income.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()       

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement_Income.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
    
            LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                    ON MovementFloat_DiscountTax.MovementId = Movement_Income.Id
                                   AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()

             LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                     ON MovementFloat_TotalSummMVAT.MovementId = Movement_Income.Id
                                    AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

             LEFT JOIN MovementFloat AS MovementFloat_SummTaxMVAT
                                     ON MovementFloat_SummTaxMVAT.MovementId = Movement_Income.Id
                                    AND MovementFloat_SummTaxMVAT.DescId = zc_MovementFloat_SummTaxMVAT()
             LEFT JOIN MovementFloat AS MovementFloat_SummTaxPVAT
                                     ON MovementFloat_SummTaxPVAT.MovementId = Movement_Income.Id
                                    AND MovementFloat_SummTaxPVAT.DescId = zc_MovementFloat_SummTaxPVAT()
             LEFT JOIN MovementFloat AS MovementFloat_SummPost
                                     ON MovementFloat_SummPost.MovementId = Movement_Income.Id
                                    AND MovementFloat_SummPost.DescId = zc_MovementFloat_SummPost()
             LEFT JOIN MovementFloat AS MovementFloat_SummPack
                                     ON MovementFloat_SummPack.MovementId = Movement_Income.Id
                                    AND MovementFloat_SummPack.DescId = zc_MovementFloat_SummPack()
             LEFT JOIN MovementFloat AS MovementFloat_SummInsur
                                     ON MovementFloat_SummInsur.MovementId = Movement_Income.Id
                                    AND MovementFloat_SummInsur.DescId = zc_MovementFloat_SummInsur()
             LEFT JOIN MovementFloat AS MovementFloat_TotalDiscountTax
                                     ON MovementFloat_TotalDiscountTax.MovementId = Movement_Income.Id
                                    AND MovementFloat_TotalDiscountTax.DescId = zc_MovementFloat_TotalDiscountTax()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummTaxMVAT
                                     ON MovementFloat_TotalSummTaxMVAT.MovementId = Movement_Income.Id
                                    AND MovementFloat_TotalSummTaxMVAT.DescId = zc_MovementFloat_TotalSummTaxMVAT()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummTaxPVAT
                                     ON MovementFloat_TotalSummTaxPVAT.MovementId = Movement_Income.Id
                                    AND MovementFloat_TotalSummTaxPVAT.DescId = zc_MovementFloat_TotalSummTaxPVAT()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId = Movement_Income.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
    
            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement_Income.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement_Income.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement_Income.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

        WHERE Movement_Income.Id = inMovementId
          AND Movement_Income.DescId = zc_Movement_Income()
          ;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.06.22         *
 08.02.21         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Income (inMovementId:= 1, inOperDate:= '02.02.2021', inSession:= zfCalc_UserAdmin())
