-- Function: gpSelectMobile_Movement_PromoPartner()

DROP FUNCTION IF EXISTS gpSelectMobile_Movement_PromoPartner (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Movement_PromoPartner(
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id         Integer -- Уникальный идентификатор, формируется в Главной БД, и используется при синхронизации
             , MovementId Integer -- Уникальный идентификатор документа
             , ContractId Integer -- Договора
             , PartnerId  Integer -- Контрагент
             , isSync     Boolean 
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- Результат
      IF vbPersonalId IS NOT NULL 
      THEN
           RETURN QUERY
             SELECT Movement_PromoPartner.Id
                  , Movement_PromoPartner.ParentId                              AS MovementId
                  , COALESCE (MovementLinkObject_Contract.ObjectId, 0)::Integer AS ContractId
                  , MovementLinkObject_Partner.ObjectId                         AS PartnerId
                  , true::Boolean                                               AS isSync
             FROM Movement AS Movement_PromoPartner
                  JOIN MovementLinkObject AS MovementLinkObject_Partner
                                          ON MovementLinkObject_Partner.MovementId = Movement_PromoPartner.Id
                                         AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner() 
                  JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                  ON ObjectLink_Partner_PersonalTrade.ObjectId = MovementLinkObject_Partner.ObjectId 
                                 AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                 AND ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                               ON MovementLinkObject_Contract.MovementId = Movement_PromoPartner.Id
                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract() 
             WHERE Movement_PromoPartner.DescId = zc_Movement_PromoPartner()
               AND Movement_PromoPartner.ParentId IS NOT NULL
               AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased();
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.   Ярошенко Р.Ф.
 17.03.17                                                                          *
*/

-- SELECT * FROM gpSelectMobile_Movement_PromoPartner (inSyncDateIn:= zc_DateStart(), inSession:= zfCalc_UserAdmin())
