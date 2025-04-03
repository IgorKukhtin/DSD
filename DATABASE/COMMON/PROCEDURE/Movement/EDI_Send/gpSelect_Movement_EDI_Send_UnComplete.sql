-- Function: gpSelect_Movement_EDI_Send_UnComplete()

DROP FUNCTION IF EXISTS gpSelect_Movement_EDI_Send_UnComplete (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_EDI_Send_UnComplete(
    IN inSession             TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, MovementId Integer
             , isEdiOrdspr Boolean, isEdiInvoice Boolean, isEdiDesadv Boolean
             , InvNumber TVarChar, OperDate TDateTime, UpdateDate TDateTime, OperDatePartner TDateTime, InsertDate_WeighingPartner TDateTime
             , InvNumber_Parent TVarChar, OperDate_Parent TDateTime
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar, RetailName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , JuridicalName_To TVarChar
             , StatusCode Integer, StatusName TVarChar
             , Comment TVarChar
             , isVchasnoEDI Boolean
              )
AS
$BODY$
BEGIN

         -- Результат
         RETURN QUERY
           WITH tmpMovement_WeighingPartner AS (SELECT Movement_Order.Id             AS MovementId_order
                                                     , MAX (MIDate_Insert.ValueData) AS InsertDate
                                                FROM Movement 
                                                     INNER JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                                                     ON MovementLinkMovement_Order.MovementId = Movement.Id
                                                                                    AND MovementLinkMovement_Order.DescId     = zc_MovementLinkMovement_Order()
                                                     INNER JOIN Movement AS Movement_Order ON Movement_Order.Id     = MovementLinkMovement_Order.MovementChildId
                                                                                          AND Movement_Order.DescId = zc_Movement_OrderExternal()
                                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                            AND MovementItem.DescId     = zc_MI_Master()
                                                                            AND MovementItem.isErased   = FALSE
                                                     INNER JOIN MovementItemDate AS MIDate_Insert
                                                                                 ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                                                AND MIDate_Insert.DescId         = zc_MIDate_Insert()
                                                                            
                                                WHERE Movement.DescId   = zc_Movement_WeighingPartner()
                                                  AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                                  AND Movement.OperDate >= CURRENT_DATE - INTERVAL '3 DAY'
                                                GROUP BY Movement_Order.Id
                                               )

           SELECT
                 Movement.ParentId                              AS Id
               , Movement.Id                                    AS MovementId
               , MovementBoolean_EdiOrdspr.ValueData            AS isEdiOrdspr
               , MovementBoolean_EdiInvoice.ValueData           AS isEdiInvoice
               , MovementBoolean_EdiDesadv.ValueData            AS isEdiDesadv
               , Movement.InvNumber                             AS InvNumber
               , Movement.OperDate                              AS OperDate
               , MovementDate_Update.ValueData                  AS UpdateDate
               , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
               , tmpMovement_WeighingPartner.InsertDate :: TDateTime AS InsertDate_WeighingPartner

               , Movement_Parent.InvNumber                      AS InvNumber_Parent
               , Movement_Parent.OperDate                       AS OperDate_Parent
               , Object_From.Id                    		AS FromId
               , Object_From.ValueData             		AS FromName
               , Object_To.Id                      		AS ToId
               , Object_To.ValueData               		AS ToName
               , Object_Retail.ValueData                        AS RetailName
               , Object_PaidKind.Id                		AS PaidKindId
               , Object_PaidKind.ValueData         		AS PaidKindName
               , Object_JuridicalTo.ValueData                   AS JuridicalName_To

               , Object_Status.ObjectCode    		        AS StatusCode
               , Object_Status.ValueData     		        AS StatusName
               , MovementString_Comment.ValueData               AS Comment
                 -- схема Vchasno - EDI
               , COALESCE (ObjectBoolean_Juridical_VchasnoEdi.ValueData, FALSE) :: Boolean AS isVchasnoEDI


           FROM Movement
                LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                       ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                      AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                LEFT JOIN MovementDate AS MovementDate_Update
                                       ON MovementDate_Update.MovementId = Movement.Id
                                      AND MovementDate_Update.DescId     = zc_MovementDate_Update()
                LEFT JOIN MovementString AS MovementString_Comment
                                         ON MovementString_Comment.MovementId = Movement.Id
                                        AND MovementString_Comment.DescId     = zc_MovementString_Comment()

                LEFT JOIN MovementBoolean AS MovementBoolean_EdiOrdspr
                                          ON MovementBoolean_EdiOrdspr.MovementId = Movement.Id
                                         AND MovementBoolean_EdiOrdspr.DescId     = zc_MovementBoolean_EdiOrdspr()
                LEFT JOIN MovementBoolean AS MovementBoolean_EdiInvoice
                                          ON MovementBoolean_EdiInvoice.MovementId = Movement.Id
                                         AND MovementBoolean_EdiInvoice.DescId     = zc_MovementBoolean_EdiInvoice()
                LEFT JOIN MovementBoolean AS MovementBoolean_EdiDesadv
                                          ON MovementBoolean_EdiDesadv.MovementId = Movement.Id
                                         AND MovementBoolean_EdiDesadv.DescId     = zc_MovementBoolean_EdiDesadv()


                LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId

                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                               ON MovementLinkMovement_Order.MovementId = Movement.ParentId
                                              AND MovementLinkMovement_Order.DescId     = zc_MovementLinkMovement_Order()
                LEFT JOIN tmpMovement_WeighingPartner ON tmpMovement_WeighingPartner.MovementId_order = MovementLinkMovement_Order.MovementChildId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement_Parent.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                     ON ObjectLink_Unit_Branch.ObjectId = Object_From.Id
                                    AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement_Parent.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                             ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                            AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                     ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                LEFT JOIN Object AS Object_JuridicalTo ON Object_JuridicalTo.Id = ObjectLink_Partner_Juridical.ChildObjectId

                -- Без схемы Vchasno - EDI
                LEFT JOIN ObjectBoolean AS ObjectBoolean_Juridical_VchasnoEdi
                                        ON ObjectBoolean_Juridical_VchasnoEdi.ObjectId  = Object_JuridicalTo.Id
                                       AND ObjectBoolean_Juridical_VchasnoEdi.DescId    = zc_ObjectBoolean_Juridical_VchasnoEdi()
                                     --AND ObjectBoolean_Juridical_VchasnoEdi.ValueData = TRUE


                LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                     ON ObjectLink_Juridical_Retail.ObjectId = Object_JuridicalTo.Id
                                    AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

           WHERE Movement.DescId   = zc_Movement_EDI_Send()
             AND Movement.StatusId = zc_Enum_Status_UnComplete()
             AND Movement.OperDate >= CURRENT_DATE - INTERVAL '3 DAY'
             -- Без схемы Vchasno - EDI
             -- AND ObjectBoolean_Juridical_VchasnoEdi.ObjectId IS NULL
             --
             AND COALESCE (Movement_Parent.StatusId, 0) <> zc_Enum_Status_UnComplete()
             --
             AND ((Movement.OperDate < CURRENT_TIMESTAMP - INTERVAL '55 MIN'
              AND COALESCE (CASE WHEN tmpMovement_WeighingPartner.InsertDate > MovementDate_Update.ValueData THEN tmpMovement_WeighingPartner.InsertDate ELSE MovementDate_Update.ValueData END, zc_DateStart())
                < CURRENT_TIMESTAMP - INTERVAL '55 MIN'
                  )
               -- Этих Отправляем Сразу
               OR (Object_Retail.Id IN (310855 -- !!!Варус!!!
                                      -- , 310846 -- !!!ВК!!!
                                       )
               AND Movement.OperDate < CURRENT_TIMESTAMP - INTERVAL '1 MIN'
               AND COALESCE (MovementDate_Update.ValueData, zc_DateStart()) < CURRENT_TIMESTAMP - INTERVAL '1 MIN'
                  )
               /*OR (COALESCE (ObjectLink_Unit_Branch.ChildObjectId, 0) NOT IN (0, zc_Branch_Basis())
               AND Movement.OperDate < CURRENT_TIMESTAMP - INTERVAL '5 MIN'
               AND COALESCE (MovementDate_Update.ValueData, zc_DateStart()) < CURRENT_TIMESTAMP - INTERVAL '5 MIN'
                  )*/
                  
                )
           ORDER BY COALESCE (MovementDate_Update.ValueData, Movement.OperDate)
          ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.02.18                                        *
*/

-- тест
-- update Movement set Statusid = zc_Enum_Status_Erased() WHERE Id IN (SELECT tmp.MovementId FROM gpSelect_Movement_EDI_Send_UnComplete (inSession := zfCalc_UserAdmin()) AS tmp);
-- SELECT Movement.*, MD1.ValueData AS DateUpdate, MD2.ValueData AS DateSend FROM Movement LEFT JOIN MovementDate AS MD1 ON MD1.MovementId = Movement.Id AND MD1.DescId = zc_MovementDate_Update() LEFT JOIN MovementDate AS MD2 ON MD2.MovementId = Movement.Id AND MD2.DescId = zc_MovementDate_OperDatePartner() WHERE Movement.DescId = zc_Movement_EDI_Send() ORDER BY COALESCE (MD1.ValueData, Movement.OperDate) DESC
-- SELECT * FROM gpSelect_Movement_EDI_Send_UnComplete (inSession := zfCalc_UserAdmin());
