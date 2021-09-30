-- Function: gpSelect_Movement_PromoInvoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_PromoInvoice (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PromoInvoice(
    IN inMovementId    Integer , -- Ключ документа <Акция>
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id                Integer
             , ParentId          Integer
             , OperDate          TDateTime
             , Invnumber         Integer
             , InvnumberPartner         TVarChar
             , BonusKindId        Integer 
             , BonusKindCode      Integer 
             , BonusKindName      TVarChar
             , PaidKindId       Integer  
             , PaidKindCode     Integer  
             , PaidKindName     TVarChar
             , ContractId       Integer
             , ContractCode     Integer
             , ContractName     TVarChar
             , JuridicalId      Integer
             , JuridicalName    TVarChar
             , TotalSumm        TFloat 
             , Comment          TVarChar
             , isErased         Boolean
             , StatusId         Integer
             , StatusCode       Integer
             , StatusName       TVarChar
             , InsertName       TVarChar
             , InsertDate       TDateTime
             , UpdateName       TVarChar
             , UpdateDate       TDateTime
      )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    RETURN QUERY
        SELECT Movement_PromoInvoice.Id
             , Movement_PromoInvoice.ParentId             --Ссылка на основной документ <Акции> (zc_Movement_Promo)
             , Movement_PromoInvoice.OperDate
             , Movement_PromoInvoice.Invnumber ::integer
             , Movement_PromoInvoice.InvnumberPartner

             , Movement_PromoInvoice.BonusKindId
             , Movement_PromoInvoice.BonusKindCode
             , Movement_PromoInvoice.BonusKindName

             , Movement_PromoInvoice.PaidKindId
             , Movement_PromoInvoice.PaidKindCode
             , Movement_PromoInvoice.PaidKindName

             , Movement_PromoInvoice.ContractId
             , Movement_PromoInvoice.ContractCode
             , Movement_PromoInvoice.ContractName
             , Movement_PromoInvoice.JuridicalId
             , Movement_PromoInvoice.JuridicalName

             , Movement_PromoInvoice.TotalSumm
             , Movement_PromoInvoice.Comment

             , Movement_PromoInvoice.isErased           --Удален
             , Movement_PromoInvoice.StatusId           --ид статуса
             , Movement_PromoInvoice.StatusCode         --код статуса
             , Movement_PromoInvoice.StatusName         --Статус

             , Movement_PromoInvoice.InsertName
             , Movement_PromoInvoice.InsertDate
             , Movement_PromoInvoice.UpdateName
             , Movement_PromoInvoice.UpdateDate
        FROM Movement_PromoInvoice_View AS Movement_PromoInvoice
        WHERE Movement_PromoInvoice.ParentId = inMovementId
            AND(Movement_PromoInvoice.isErased = FALSE OR inIsErased = TRUE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.09.21         *
 04.09.21         *
*/

-- test
-- SELECT * FROM gpSelect_Movement_PromoInvoice (inMovementId:= 0, inIsErased := false,  inSession:= zfCalc_UserAdmin())
