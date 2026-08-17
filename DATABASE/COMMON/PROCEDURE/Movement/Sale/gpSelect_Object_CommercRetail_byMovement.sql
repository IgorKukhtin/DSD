-- Function: gpSelect_Object_CommercRetail_byMovement()

DROP FUNCTION IF EXISTS gpSelect_Object_CommercRetail_byMovement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CommercRetail_byMovement(
    IN inMovementId          Integer  , -- ключ Документа
    IN inSession             TVarChar   -- сессия пользователя
)
RETURNS TABLE (Ord Integer
             , PositionName TVarChar
             , PersonalGroupName TVarChar
             , PersonalName Text
             , UnitName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId          Integer;
          vbUserId_order    Integer;
          vbContractTagId   Integer;
          vbRetailId        Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     SELECT CASE WHEN Movement.DescId = zc_Movement_Sale() THEN MovementLinkObject_Insert_order.ObjectId
                 WHEN Movement.DescId = zc_Movement_ReturnIn() THEN MovementLinkObject_Insert.ObjectId
            END AS UserId_order
            
          , ObjectLink_Juridical_Retail.ChildObjectId
          , ObjectLink_Contract_ContractTag.ChildObjectId AS ContractTagId
    INTO vbUserId_order, vbRetailId, vbContractTagId 
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                       ON MovementLinkObject_Partner.MovementId = Movement.Id        
                                      AND MovementLinkObject_Partner.DescId = CASE WHEN Movement.DescId = zc_Movement_Sale() THEN zc_MovementLinkObject_To()
                                                                                   WHEN Movement.DescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_From()
                                                                              END
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_Partner.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

         LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                      ON MovementLinkObject_Contract.MovementId = Movement.Id
                                     AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

         LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                              ON ObjectLink_Contract_ContractTag.ObjectId = MovementLinkObject_Contract.ObjectId
                             AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()

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

     WHERE Movement.Id = inMovementId;


         -- Результат
         RETURN QUERY 
         SELECT tmp.Ord               ::Integer
              , tmp.PositionName      ::TVarChar
              , tmp.PersonalGroupName ::TVarChar
              , tmp.PersonalName      ::Text
              , tmp.UnitName          ::TVarChar
         FROM lpSelect_Object_CommercRetail_choice (inMemberId_order  := (SELECT lfSelect.MemberId
                                                                          FROM lfSelect_Object_Member_findPersonal (zfCalc_UserAdmin()) AS lfSelect
                                                                               INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                                                                     ON ObjectLink_User_Member.ChildObjectId = lfSelect.MemberId
                                                                                                    AND ObjectLink_User_Member.DescId        = zc_ObjectLink_User_Member()
                                                                                                    AND ObjectLink_User_Member.ObjectId      = vbUserId_order
                                                                          WHERE lfSelect.Ord = 1
                                                                         )
                                                  , inRetailId      := vbRetailId
                                                  , inContractTagId := vbContractTagId
                                                  , inSession       := inSession
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
-- SELECT * FROM gpSelect_Object_CommercRetail_byMovement (inMovementId:= 40874, inSession := zfCalc_UserAdmin());

