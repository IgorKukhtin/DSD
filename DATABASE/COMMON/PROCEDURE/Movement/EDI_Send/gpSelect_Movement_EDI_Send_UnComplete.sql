-- Function: gpSelect_Movement_EDI_Send_UnComplete()

DROP FUNCTION IF EXISTS gpSelect_Movement_EDI_Send_UnComplete (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_EDI_Send_UnComplete(
    IN inSession             TVarChar   -- сессия пользователя
)
RETURNS TABLE (-- Документ продажа - отправка в EDI
               Id Integer
               -- Документ для отправки в EDI
             , MovementId Integer
               --
             , isEdiOrdspr Boolean, isEdiInvoice Boolean, isEdiDesadv Boolean
               -- схема Vchasno - EDI
             , isVchasnoEDI Boolean
               -- ВН - Delnot, автоматическая отправка
             , isEdiDelnot Boolean
               -- ВН - Comdoc, автоматическая отправка
             , isEdiComdoc Boolean
               -- Вчасно - Декларация, автоматическая отправка
             , isEdiQuality Boolean
               --
               -- Документ для отправки в EDI
             , InvNumber TVarChar, OperDate TDateTime, UpdateDate TDateTime
               -- Дата/Время когда отправили в EDI
             , OperDatePartner TDateTime
               -- Дата/Время когда отправили Ошибку
             , OperDate_Sent TDateTime
               -- если ошибка - будет ли отправка - ждем 12 часов
             , isOperDate_Sent Boolean
               --
             , InsertDate_WeighingPartner TDateTime

               -- Док заявка
             , InvNumber_order TVarChar, InvNumberPartner_order TVarChar, OperDate_order TDateTime
               -- Док продажа
             , InvNumber_Parent TVarChar, OperDate_Parent TDateTime, OperDatePartner_Parent TDateTime
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar, RetailName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , JuridicalName_To TVarChar
             , StatusCode Integer, StatusName TVarChar
             , Comment TVarChar
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
                 , tmpMovement_Vchasno_find AS (SELECT DISTINCT Movement.ParentId AS MovementId_sale
                                                FROM Movement
                                                WHERE Movement.DescId   = zc_Movement_EDI_Send()
                                                  AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                                  AND Movement.OperDate >= CURRENT_DATE - INTERVAL '3 DAY'
                                               )
                 -- уже отправлен Desadv
               , tmpMovement_Vchasno_Desadv AS (SELECT DISTINCT Movement.ParentId AS MovementId_sale
                                                FROM Movement
                                                     INNER JOIN tmpMovement_Vchasno_find ON tmpMovement_Vchasno_find.MovementId_sale = Movement.ParentId
                                                     --  EDI - Уведомление об отгрузке
                                                     INNER JOIN MovementBoolean AS MovementBoolean_EdiDesadv
                                                                                ON MovementBoolean_EdiDesadv.MovementId = Movement.Id
                                                                               AND MovementBoolean_EdiDesadv.DescId     = zc_MovementBoolean_EdiDesadv()
                                                                               AND MovementBoolean_EdiDesadv.ValueData  = TRUE

                                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                                  ON MovementLinkObject_To.MovementId = Movement.ParentId
                                                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                     LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                          ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                                                         AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                                     -- схема Vchasno - EDI
                                                     INNER JOIN ObjectBoolean AS ObjectBoolean_Juridical_VchasnoEdi
                                                                              ON ObjectBoolean_Juridical_VchasnoEdi.ObjectId  = ObjectLink_Partner_Juridical.ChildObjectId
                                                                             AND ObjectBoolean_Juridical_VchasnoEdi.DescId    = zc_ObjectBoolean_Juridical_VchasnoEdi()
                                                                             AND ObjectBoolean_Juridical_VchasnoEdi.ValueData = TRUE

                                                WHERE Movement.DescId   = zc_Movement_EDI_Send()
                                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                                  AND Movement.OperDate >= CURRENT_DATE - INTERVAL '3 DAY'
                                               )
           -- Результат
           SELECT
                 -- Документ продажа - отправка в EDI
                 Movement.ParentId                              AS Id
                 -- Документ для отправки в EDI
               , Movement.Id                                    AS MovementId

               , MovementBoolean_EdiOrdspr.ValueData            AS isEdiOrdspr
               , MovementBoolean_EdiInvoice.ValueData           AS isEdiInvoice
               , MovementBoolean_EdiDesadv.ValueData            AS isEdiDesadv

                 -- схема Vchasno - EDI
               , CASE WHEN MovementString_DealId.ValueData <> ''
                           THEN COALESCE (ObjectBoolean_Juridical_VchasnoEdi.ValueData, FALSE)

                      -- Дільниця обліку і реалізації м`ясної сировини
                      WHEN MovementString_DealId.ValueData <> ''
                           MovementLinkObject_From.ObjectId = 133049
                           THEN TRUE

                      ELSE FALSE
                 END :: Boolean AS isVchasnoEDI


                 -- ВН - Delnot, автоматическая отправка
               , CASE -- этим никогда
                      --WHEN Object_Retail.Id = 8873723 -- Кошик
                      --     THEN FALSE

                      -- НЕ НАДО - временно Рост Харьков + Чудо-Маркет
                      --WHEN Object_Retail.Id IN (310862  -- Рост Харьков
                      --                        , 2473612 -- Чудо-Маркет
                      --                         )
                      --     THEN FALSE

                      -- если надо
                      -- WHEN ObjectBoolean_Juridical_VchasnoEdi.ValueData = TRUE AND ObjectBoolean_Juridical_EdiDelnot.ValueData = TRUE
                      --     THEN TRUE

                      -- только если стоит признак
                      WHEN ObjectBoolean_Juridical_VchasnoEdi.ValueData = TRUE AND (MovementBoolean_EdiDelnot.ValueData = TRUE
                                                                                 OR MovementBoolean_EdiComdoc.ValueData = TRUE
                                                                                   )
                       -- признак
                       AND ObjectBoolean_Juridical_EdiDelnot.ValueData = TRUE

                           -- отправили
                           THEN TRUE

                      ELSE FALSE
                 END:: Boolean AS isEdiDelnot


                 -- ВН - Comdoc, автоматическая отправка
               , CASE -- этим никогда
                      --WHEN Object_Retail.Id = 8873723 -- Кошик
                      --     THEN FALSE

                      -- НАДО - временно Рост Харьков + Чудо-Маркет
                      --WHEN Object_Retail.Id IN (310862  -- Рост Харьков
                      --                        , 2473612 -- Чудо-Маркет
                      --                         )
                      -- AND ObjectBoolean_Juridical_VchasnoEdi.ValueData = TRUE AND (MovementBoolean_EdiDelnot.ValueData = TRUE
                      --                                                           OR MovementBoolean_EdiComdoc.ValueData = TRUE
                      --                                                             )
                      --     THEN TRUE

                      -- только если стоит признак
                      WHEN ObjectBoolean_Juridical_VchasnoEdi.ValueData = TRUE AND (MovementBoolean_EdiDelnot.ValueData = TRUE
                                                                                 OR MovementBoolean_EdiComdoc.ValueData = TRUE
                                                                                   )
                       -- признак
                       AND ObjectBoolean_Juridical_EdiComdoc.ValueData = TRUE

                           -- отправили
                           THEN TRUE

                      ELSE FALSE
                 END:: Boolean AS isEdiComdoc
                 
               , COALESCE (ObjectBoolean_Juridical_EdiQuality.ValueData, FALSE) :: Boolean AS isEdiQuality


               , Movement.InvNumber                             AS InvNumber
               , Movement.OperDate                              AS OperDate
               , MovementDate_Update.ValueData                  AS UpdateDate
                 -- Дата/Время когда отправили в EDI
               , MovementDate_OperDatePartner.ValueData         AS OperDatePartner
                 -- Дата/Время когда отправили Ошибку
               , MovementDate_OperDate_Sent.ValueData           AS OperDate_Sent
                 -- если ошибка - будет ли отправка - ждем 12 часов
               , CASE WHEN COALESCE (MovementDate_OperDate_Sent.ValueData, zc_DateStart()) + INTERVAL '12 HOUR' < CURRENT_TIMESTAMP
                      THEN TRUE
                      ELSE FALSE
                 END :: Boolean AS isOperDate_Sent
                 --
               , tmpMovement_WeighingPartner.InsertDate :: TDateTime AS InsertDate_WeighingPartner

               , Movement_order.InvNumber                       AS InvNumber_order
               , MS_InvNumberPartner_order.ValueData            AS InvNumberPartner_order
               , Movement_order.OperDate                        AS OperDate_order

               , Movement_Parent.InvNumber                      AS InvNumber_Parent
               , Movement_Parent.OperDate                       AS OperDate_Parent
               , MovementDate_OperDatePartner_parent.ValueData  AS OperDatePartner_Parent
               
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

           FROM Movement
                 -- уже отправлен Desadv
                LEFT JOIN tmpMovement_Vchasno_Desadv ON tmpMovement_Vchasno_Desadv.MovementId_sale = Movement.ParentId

                LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                -- Дата/Время когда отправили в EDI
                LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                       ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                      AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                LEFT JOIN MovementDate AS MovementDate_Update
                                       ON MovementDate_Update.MovementId = Movement.Id
                                      AND MovementDate_Update.DescId     = zc_MovementDate_Update()
                -- Дата/Время когда отправили Ошибку
                LEFT JOIN MovementDate AS MovementDate_OperDate_Sent
                                       ON MovementDate_OperDate_Sent.MovementId = Movement.Id
                                      AND MovementDate_OperDate_Sent.DescId     = zc_MovementDate_Sent()
                LEFT JOIN MovementString AS MovementString_Comment
                                         ON MovementString_Comment.MovementId = Movement.Id
                                        AND MovementString_Comment.DescId     = zc_MovementString_Comment()

                --  EDI - Подтверждение заказа
                LEFT JOIN MovementBoolean AS MovementBoolean_EdiOrdspr
                                          ON MovementBoolean_EdiOrdspr.MovementId = Movement.Id
                                         AND MovementBoolean_EdiOrdspr.DescId     = zc_MovementBoolean_EdiOrdspr()
                --  EDI - Счет
                LEFT JOIN MovementBoolean AS MovementBoolean_EdiInvoice
                                          ON MovementBoolean_EdiInvoice.MovementId = Movement.Id
                                         AND MovementBoolean_EdiInvoice.DescId     = zc_MovementBoolean_EdiInvoice()
                --  EDI - Уведомление об отгрузке
                LEFT JOIN MovementBoolean AS MovementBoolean_EdiDesadv
                                          ON MovementBoolean_EdiDesadv.MovementId = Movement.Id
                                         AND MovementBoolean_EdiDesadv.DescId     = zc_MovementBoolean_EdiDesadv()
                --  DELNOT-Видаткова Накладна
                LEFT JOIN MovementBoolean AS MovementBoolean_EdiDelnot
                                          ON MovementBoolean_EdiDelnot.MovementId = Movement.Id
                                         AND MovementBoolean_EdiDelnot.DescId     = zc_MovementBoolean_EdiDelnot()
                -- COMDOC-Видаткова Накладна
                LEFT JOIN MovementBoolean AS MovementBoolean_EdiComdoc
                                          ON MovementBoolean_EdiComdoc.MovementId = Movement.Id
                                         AND MovementBoolean_EdiComdoc.DescId     = zc_MovementBoolean_EdiComdoc()

                -- продажа
                LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId
                LEFT JOIN MovementDate AS MovementDate_OperDatePartner_parent
                                       ON MovementDate_OperDatePartner_parent.MovementId = Movement_Parent.Id
                                      AND MovementDate_OperDatePartner_parent.DescId     = zc_MovementDate_OperDatePartner()

                -- заявка покупателя
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

                -- схема Vchasno - EDI
                LEFT JOIN ObjectBoolean AS ObjectBoolean_Juridical_VchasnoEdi
                                        ON ObjectBoolean_Juridical_VchasnoEdi.ObjectId  = Object_JuridicalTo.Id
                                       AND ObjectBoolean_Juridical_VchasnoEdi.DescId    = zc_ObjectBoolean_Juridical_VchasnoEdi()
                                     --AND ObjectBoolean_Juridical_VchasnoEdi.ValueData = TRUE

                -- ВН - Delnot, автоматическая отправка
                LEFT JOIN ObjectBoolean AS ObjectBoolean_Juridical_EdiDelnot
                                        ON ObjectBoolean_Juridical_EdiDelnot.ObjectId  = Object_JuridicalTo.Id
                                       AND ObjectBoolean_Juridical_EdiDelnot.DescId    = zc_ObjectBoolean_Juridical_isEdiDelnot()
                -- ВН - Comdoc, автоматическая отправка
                LEFT JOIN ObjectBoolean AS ObjectBoolean_Juridical_EdiComdoc
                                        ON ObjectBoolean_Juridical_EdiComdoc.ObjectId  = Object_JuridicalTo.Id
                                       AND ObjectBoolean_Juridical_EdiComdoc.DescId    = zc_ObjectBoolean_Juridical_isEdiComdoc()

                -- Вчасно - Декларация, автоматическая отправка
                LEFT JOIN ObjectBoolean AS ObjectBoolean_Juridical_EdiQuality
                                        ON ObjectBoolean_Juridical_EdiQuality.ObjectId  = Object_JuridicalTo.Id
                                       AND ObjectBoolean_Juridical_EdiQuality.DescId    = zc_ObjectBoolean_Juridical_isEdiQuality()

                LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                     ON ObjectLink_Juridical_Retail.ObjectId = Object_JuridicalTo.Id
                                    AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

                -- заявка покупателя
                LEFT JOIN Movement AS Movement_order ON Movement_order.Id = MovementLinkMovement_Order.MovementChildId
                LEFT JOIN MovementString AS MS_InvNumberPartner_order
                                         ON MS_InvNumberPartner_order.MovementId =  Movement_order.Id
                                        AND MS_InvNumberPartner_order.DescId     = zc_MovementString_InvNumberPartner()

                -- док.EDI
                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order_EDI
                                               ON MovementLinkMovement_Order_EDI.MovementId = MovementLinkMovement_Order.MovementChildId
                                              AND MovementLinkMovement_Order_EDI.DescId = zc_MovementLinkMovement_Order()
               -- схема Vchasno - EDI
                LEFT JOIN MovementString AS MovementString_DealId
                                         ON MovementString_DealId.MovementId = MovementLinkMovement_Order_EDI.MovementChildId
                                        AND MovementString_DealId.DescId     = zc_MovementString_DealId()

           WHERE Movement.DescId   = zc_Movement_EDI_Send()
             AND Movement.StatusId = zc_Enum_Status_UnComplete()
             AND Movement.OperDate >= CURRENT_DATE - INTERVAL '3 DAY'
             -- Без схемы Vchasno - EDI
             -- AND COALESCE (ObjectBoolean_Juridical_VchasnoEdi.ValueData, FALSE) = TRUE
             --
             -- уже отправлен Desadv
             AND tmpMovement_Vchasno_Desadv.MovementId_sale IS NULL

             --
             AND COALESCE (Movement_Parent.StatusId, 0) <> zc_Enum_Status_UnComplete()
             --
             AND (-- Этих Отправляем 55-min
                  (Movement.OperDate < CURRENT_TIMESTAMP - INTERVAL '55 MIN'
               AND COALESCE (CASE WHEN tmpMovement_WeighingPartner.InsertDate > MovementDate_Update.ValueData THEN tmpMovement_WeighingPartner.InsertDate ELSE MovementDate_Update.ValueData END, zc_DateStart())
                 < CURRENT_TIMESTAMP - INTERVAL '55 MIN'
                  )

               OR -- Этих Отправляем 10-min
                  (Movement.OperDate < CURRENT_TIMESTAMP - INTERVAL '20 MIN'
               AND COALESCE (CASE WHEN tmpMovement_WeighingPartner.InsertDate > MovementDate_Update.ValueData THEN tmpMovement_WeighingPartner.InsertDate ELSE MovementDate_Update.ValueData END, zc_DateStart())
                   < CURRENT_TIMESTAMP - INTERVAL '20 MIN'
               -- схема Vchasno - EDI
               AND ObjectBoolean_Juridical_VchasnoEdi.ValueData = TRUE
               -- Vchasno - без этих
               AND Object_Retail.Id NOT IN (310859 -- !!!Новус!!!
                                       -- , 310846 -- !!!ВК!!!
                                           )
                  )

               -- Этих Отправляем Сразу
               OR (Object_Retail.Id IN (310855 -- !!!Варус!!!
                                      -- , 310846 -- !!!ВК!!!
                                       )
               AND Movement.OperDate < CURRENT_TIMESTAMP - INTERVAL '1 MIN'
               AND COALESCE (MovementDate_Update.ValueData, zc_DateStart()) < CURRENT_TIMESTAMP - INTERVAL '1 MIN'
                  )

               -- Этих Отправляем Сразу + РК
               /*OR (Object_Retail.Id IN (310846 -- !!!ВК!!!
                                       )
               AND MovementLinkObject_From.ObjectId = zc_Unit_RK()
               AND Movement.OperDate < CURRENT_TIMESTAMP - INTERVAL '1 MIN'
               AND COALESCE (MovementDate_Update.ValueData, zc_DateStart()) < CURRENT_TIMESTAMP - INTERVAL '1 MIN'
                  )*/

               /*OR (COALESCE (ObjectLink_Unit_Branch.ChildObjectId, 0) NOT IN (0, zc_Branch_Basis())
               AND Movement.OperDate < CURRENT_TIMESTAMP - INTERVAL '5 MIN'
               AND COALESCE (MovementDate_Update.ValueData, zc_DateStart()) < CURRENT_TIMESTAMP - INTERVAL '5 MIN'
                  )*/

                )
           ORDER BY
                    CASE WHEN MovementBoolean_EdiOrdspr.ValueData  = TRUE THEN 1 ELSE 888 END
                  , CASE WHEN MovementBoolean_EdiInvoice.ValueData = TRUE THEN 2 ELSE 888 END
                  , CASE WHEN MovementBoolean_EdiDesadv.ValueData  = TRUE THEN 3 ELSE 888 END
                  , CASE WHEN MovementBoolean_EdiDelnot.ValueData  = TRUE THEN 4 ELSE 888 END
                  , CASE WHEN MovementBoolean_EdiComdoc.ValueData  = TRUE THEN 5 ELSE 888 END
                  , COALESCE (MovementDate_Update.ValueData, Movement.OperDate)
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
