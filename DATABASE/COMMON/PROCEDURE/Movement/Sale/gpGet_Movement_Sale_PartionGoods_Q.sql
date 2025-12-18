-- Function: gpGet_Movement_Sale_PartionGoods_Q()

DROP FUNCTION IF EXISTS gpGet_Movement_Sale_PartionGoods_Q (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Sale_PartionGoods_Q(
    IN inMovementId          Integer  , -- ключ Документа
    IN inSession             TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractName TVarChar, ContractTagName TVarChar
             , InvNumberOrder TVarChar
             , MovementId_Order Integer
             , isPromo Boolean
             , InsertName TVarChar
             , InsertDate TDateTime
             , StartWeighing TDateTime, EndWeighing TDateTime
              )
AS
$BODY$
  DECLARE vbContractId      Integer;
  DECLARE vbContractName    TVarChar;
  DECLARE vbContractTagName TVarChar;
  DECLARE vbMovementId_Transport Integer;
  DECLARE vbInvNumber_Transport  TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Sale());

    IF COALESCE (inMovementId, 0) < 0
    THEN
        RAISE EXCEPTION 'Ошибка. Невозможно открыть пустой документ.';
    END IF;


     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_sale_seq') AS TVarChar) AS InvNumber
             , CURRENT_Date                         AS OperDate
             , Object_Status.Code                   AS StatusCode
             , Object_Status.Name                   AS StatusName
             , CURRENT_Date                         AS OperDatePartner
             , CAST ('' AS TVarChar)                AS InvNumberPartner
             , CAST (False AS Boolean)              AS PriceWithVAT
             , CAST (20 AS TFloat)                  AS VATPercent
             , CAST (0 AS TFloat)                   AS ChangePercent

             , 0                                    AS FromId
             , CAST ('' AS TVarChar)                AS FromName
             , 0                                    AS ToId
             , CAST ('' AS TVarChar)                AS ToName
             , 0                                    AS PaidKindId
             , CAST ('' AS TVarChar)                AS PaidKindName
             , 0                                    AS ContractId
             , CAST ('' AS TVarChar)                AS ContractName
             , CAST ('' AS TVarChar)                AS ContractTagName
             , CAST ('' AS TVarChar)                AS InvNumberOrder
             , 0                                    AS MovementId_Order
             , CAST (FALSE AS Boolean)              AS isPromo   

             , Object_Insert.ValueData              AS InsertName
             , CURRENT_TIMESTAMP ::TDateTime        AS InsertDate

             , Null ::TDateTime  AS StartWeighing
             , Null ::TDateTime  AS EndWeighing
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object as Object_Currency ON Object_Currency.Id = zc_Enum_Currency_Basis();
     ELSE

         -- Поиск Договора - отдельно для скорости
         SELECT View_Contract_InvNumber.ContractId    	    AS ContractId
              , View_Contract_InvNumber.InvNumber     	    AS ContractName
              , View_Contract_InvNumber.ContractTagName     AS ContractTagName
                INTO vbContractId, vbContractName, vbContractTagName
         FROM MovementLinkObject AS MovementLinkObject_Contract
             LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId
         WHERE MovementLinkObject_Contract.MovementId = inMovementId
           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
           ;

         -- Результат
         RETURN QUERY
           WITH tmpMS  AS (SELECT * FROM MovementString       WHERE MovementString.MovementId       = inMovementId)
              , tmpMLO AS (SELECT * FROM MovementLinkObject   WHERE MovementLinkObject.MovementId   = inMovementId)
              , tmpMLM AS (SELECT * FROM MovementLinkMovement WHERE MovementLinkMovement.MovementId = inMovementId)
              
              --данные из док. взвешиваний
              , tmpWeighing AS (SELECT MIN (MovementDate_StartWeighing.ValueData)  AS StartWeighing
                                     , MAX (MovementDate_EndWeighing.ValueData)    AS EndWeighing
                                FROM Movement
                                     LEFT JOIN MovementDate AS MovementDate_StartWeighing
                                                            ON MovementDate_StartWeighing.MovementId = Movement.Id
                                                           AND MovementDate_StartWeighing.DescId = zc_MovementDate_StartWeighing()
                                     LEFT JOIN MovementDate AS MovementDate_EndWeighing
                                                            ON MovementDate_EndWeighing.MovementId = Movement.Id
                                                           AND MovementDate_EndWeighing.DescId = zc_MovementDate_EndWeighing() 
                                WHERE Movement.ParentId = inMovementId --32748596 --32739680    --32748596
                                  AND Movement.DescId = zc_movement_WeighingPartner()
                                )
           --результат
           SELECT
                 Movement.Id                                    AS Id
               , Movement.InvNumber                             AS InvNumber
               , Movement.OperDate                              AS OperDate
               , zfCalc_StatusCode_next (Movement.StatusId, Movement.StatusId_next)                          ::Integer  AS StatusCode
               , zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next) ::TVarChar AS StatusName
               , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
               , MovementString_InvNumberPartner.ValueData      AS InvNumberPartner
               , COALESCE (MovementBoolean_PriceWithVAT.ValueData, FALSE) :: Boolean AS PriceWithVAT
               , MovementFloat_VATPercent.ValueData             AS VATPercent
               , MovementFloat_ChangePercent.ValueData          AS ChangePercent

               , Object_From.Id                    		        AS FromId
               , Object_From.ValueData             		        AS FromName
               , Object_To.Id                      		        AS ToId
               , Object_To.ValueData               		        AS ToName
               , Object_PaidKind.Id                		        AS PaidKindId
               , Object_PaidKind.ValueData         		        AS PaidKindName
               , vbContractId    	                            AS ContractId
               , vbContractName  	                            AS ContractName
               , vbContractTagName                              AS ContractTagName
               , CASE WHEN TRIM (COALESCE (MovementString_InvNumberOrder.ValueData, '')) <> ''
                           THEN MovementString_InvNumberOrder.ValueData
                      WHEN MovementLinkMovement_Order.MovementChildId IS NOT NULL
                           THEN CASE WHEN Movement_Order.StatusId IN (zc_Enum_Status_Complete())
                                          THEN ''
                                     ELSE '???'
                                END
                             || CASE WHEN TRIM (COALESCE (MovementString_InvNumberPartner_Order.ValueData, '')) <> ''
                                          THEN MovementString_InvNumberPartner_Order.ValueData
                                     ELSE '***' || Movement_Order.InvNumber
                                END
                 END :: TVarChar AS InvNumberOrder
               
               , MovementLinkMovement_Order.MovementChildId          AS MovementId_Order

               , COALESCE (MovementBoolean_Promo.ValueData, FALSE)   AS isPromo    

               , Object_Insert.ValueData                                                  AS InsertName
               , COALESCE (MovementDate_Insert.ValueData, Movement.OperDate) :: TDateTime AS InsertDate

               , tmpWeighing.StartWeighing ::TDateTime AS StartWeighing
               , tmpWeighing.EndWeighing   ::TDateTime AS EndWeighing
           FROM Movement
                LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                LEFT JOIN tmpMS AS MovementString_InvNumberOrder
                                ON MovementString_InvNumberOrder.MovementId =  Movement.Id
                               AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

                LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                       ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                      AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                         ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                        AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                          ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                         AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

                LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                          ON MovementBoolean_Promo.MovementId =  Movement.Id
                                         AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()

                LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                        ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                       AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

                LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                        ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                       AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                LEFT JOIN tmpMLO AS MovementLinkObject_From
                                 ON MovementLinkObject_From.MovementId = Movement.Id
                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN tmpMLO AS MovementLinkObject_To
                                 ON MovementLinkObject_To.MovementId = Movement.Id        
                                AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN tmpMLO AS MovementLinkObject_PaidKind
                                 ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                     ON ObjectLink_Partner_Juridical.ObjectId = Object_To.Id
                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

                LEFT JOIN tmpMLM AS MovementLinkMovement_Order
                                 ON MovementLinkMovement_Order.MovementId = Movement.Id
                                AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                LEFT JOIN Movement AS Movement_Order ON Movement_Order.Id = MovementLinkMovement_Order.MovementChildId
                LEFT JOIN MovementString AS MovementString_InvNumberPartner_Order
                                         ON MovementString_InvNumberPartner_Order.MovementId = Movement_Order.Id
                                        AND MovementString_InvNumberPartner_Order.DescId = zc_MovementString_InvNumberPartner()

                LEFT JOIN MovementDate AS MovementDate_Insert
                                       ON MovementDate_Insert.MovementId = Movement.Id
                                      AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

                LEFT JOIN tmpMLO AS MovementLinkObject_Insert
                                 ON MovementLinkObject_Insert.MovementId = Movement.Id
                                AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
                LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId
                --взвешивания
                LEFT JOIN tmpWeighing ON 1 = 1

           WHERE Movement.Id     = inMovementId
             AND Movement.DescId = zc_Movement_Sale()
           LIMIT 1
           ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.12.25         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Sale_PartionGoods_Q (inMovementId:= 32467916 , inSession := zfCalc_UserAdmin());
