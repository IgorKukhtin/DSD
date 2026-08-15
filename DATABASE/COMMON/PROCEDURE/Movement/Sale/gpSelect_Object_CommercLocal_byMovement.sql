-- Function: gpSelect_Object_CommercLocal_byMovement()

DROP FUNCTION IF EXISTS gpSelect_Object_CommercLocal_byMovement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CommercLocal_byMovement(
    IN inMovementId          Integer  , -- ключ Документа
    IN inSession             TVarChar   -- сессия пользователя
)
RETURNS TABLE (Ord Integer
             , PositionName TVarChar
             , PersonalGroupName TVarChar
             , PersonalName Text
             , UnitName TVarChar 
             , PositionName_inf TVarChar
             , PersonalGroupName_inf TVarChar
             , PersonalName_inf Text
             , UnitName_inf TVarChar
              )
AS
$BODY$
  DECLARE vbUserId          Integer;
          vbUserId_order    Integer;
          vbUserId_source_order Integer;
          vbPartnerId       Integer;
          vbRouteTTId       Integer;
          vbRetailId        Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);
                           

     SELECT CASE WHEN Movement.DescId = zc_Movement_Sale() THEN MovementLinkObject_Insert_order.ObjectId
                 WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MovementLinkObject_Insert.ObjectId
            END AS UserId_order
            
          , CASE WHEN COALESCE (MovementLinkMovement_Order_edi.MovementId) <> 0 OR COALESCE (MovementLinkMovement_MasterEDI.MovementChildId, 0) <> 0 THEN 0
                 ELSE CASE WHEN Movement.DescId = zc_Movement_Sale() THEN MovementLinkObject_Insert_order.ObjectId
                           WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MovementLinkObject_Insert.ObjectId
                      END
            END AS isEDI    -- автор = ЭДИ или ВЧАСНО
          , MovementLinkObject_RouteTT.ObjectId       AS RouteTTId
          , ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
          , MovementLinkObject_To.ObjectId            AS PartnerId
          
    INTO vbUserId_order, vbUserId_source_order, vbRouteTTId, vbRetailId, vbPartnerId
     FROM Movement
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                           ON MovementLinkMovement_Order.MovementId = Movement.Id
                          AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
          -- Автор Заявки
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert_order
                                       ON MovementLinkObject_Insert_order.MovementId = MovementLinkMovement_Order.MovementChildId
                                      AND MovementLinkObject_Insert_order.DescId     = zc_MovementLinkObject_Insert()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                       ON MovementLinkObject_Insert.MovementId = Movement.Id
                                      AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()

          -- Док EDI
          --для продажи  берем по заявке
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order_edi
                                         ON MovementLinkMovement_Order_edi.MovementId = MovementLinkMovement_Order.MovementChildId
                                        AND MovementLinkMovement_Order_edi.DescId = zc_MovementLinkMovement_Order()
                                        AND COALESCE (MovementLinkMovement_Order_edi.MovementId) <> 0

         --для возврата по свойству zc_MovementLinkMovement_MasterEDI            
         LEFT JOIN MovementLinkMovement AS MovementLinkMovement_MasterEDI
                                        ON MovementLinkMovement_MasterEDI.MovementId = Movement.Id
                                       AND MovementLinkMovement_MasterEDI.DescId = zc_MovementLinkMovement_MasterEDI()
                                       AND COALESCE (MovementLinkMovement_MasterEDI.MovementChildId, 0) <> 0
                                       --AND 1 = 0  --пока не нужно

         LEFT JOIN MovementLinkObject AS MovementLinkObject_RouteTT
                          ON MovementLinkObject_RouteTT.MovementId = Movement.Id
                         AND MovementLinkObject_RouteTT.DescId = zc_MovementLinkObject_RouteTT()
                         AND (COALESCE (MovementLinkMovement_Order_edi.MovementId) <> 0 OR COALESCE (MovementLinkMovement_MasterEDI.MovementChildId, 0) <> 0)
         --
         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id        
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                              ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId -- PartnerId
                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

         LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalGroupCommerc
                              ON ObjectLink_Partner_PersonalGroupCommerc.ObjectId = MovementLinkObject_To.ObjectId
                             AND ObjectLink_Partner_PersonalGroupCommerc.DescId = zc_ObjectLink_Partner_PersonalGroupCommerc()
         LEFT JOIN Object AS Object_PersonalGroupCommerc ON Object_PersonalGroupCommerc.Id = ObjectLink_Partner_PersonalGroupCommerc.ChildObjectId

     WHERE Movement.Id = inMovementId;

         -- Результат
         RETURN QUERY 
         SELECT tmp.Ord               ::Integer
              , tmp.PositionName      ::TVarChar
              , tmp.PersonalGroupName ::TVarChar
              , tmp.PersonalName      ::Text
              , tmp.UnitName          ::TVarChar

              , tmp.PositionName_inf      ::TVarChar 
              , tmp.PersonalGroupName_inf ::TVarChar 
              , tmp.PersonalName_inf      ::Text     
              , tmp.UnitName_inf          ::TVarChar  
         FROM lpSelect_Object_CommercLocal_choice (inUserId_order       := vbUserId_order
                                                 , inUserId_source_order:= vbUserId_source_order
                                                 , inRetailId           := vbRetailId
                                                 , inRouteTTId          := vbRouteTTId
                                                 , inPartnerId          := vbPartnerId
                                                 ,  inSession           := inSession
                                                 ) AS tmp
        ORDER BY 1
        ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.06.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_CommercLocal_byMovement (inMovementId:= 40874, inSession := zfCalc_UserAdmin());

--
--select * from gpSelect_Object_CommercLocal_byMovement(inMovementId := 34499291 ,  inSession := '9457');
--select * from gpSelect_Object_CommercLocal_byMovement(inMovementId := 34932287  ,  inSession := '9457'); --EDI


