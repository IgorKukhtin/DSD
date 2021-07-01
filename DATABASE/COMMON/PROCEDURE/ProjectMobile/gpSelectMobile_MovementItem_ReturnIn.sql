-- Function: gpSelectMobile_MovementItem_ReturnIn

DROP FUNCTION IF EXISTS gpSelectMobile_MovementItem_ReturnIn (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_MovementItem_ReturnIn (
    IN inMovementGUID TVarChar , -- глобальный идентификатор документа
    IN inSession      TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id            Integer  --  
             , MovementId    Integer  --
             , GUID          TVarChar -- Глобальный уникальный идентификатор для синхронизации с Главной БД
             , GoodsId       Integer  -- Товар
             , GoodsKindId   Integer  -- Вид товара
             , Amount        TFloat   -- Количество
             , Price         TFloat   -- Цена
             , ChangePercent TFloat   -- (-)% Скидки (+)% Наценки
              )
AS $BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...);
      vbUserId:= lpGetUserBySession (inSession);

      -- Результат
      RETURN QUERY
        SELECT MI_ReturnIn.Id
             , MovementString_GUID.MovementId
             , MIString_GUID.ValueData         AS GUID
             , MI_ReturnIn.ObjectId            AS GoodsId
             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)::Integer AS GoodsKindId
             , MI_ReturnIn.Amount
             , MIFloat_Price.ValueData         AS Price
             , MIFloat_ChangePercent.ValueData AS ChangePercent
        FROM MovementString AS MovementString_GUID
             JOIN Movement AS Movement_ReturnIn 
                           ON Movement_ReturnIn.Id = MovementString_GUID.MovementId
                          AND Movement_ReturnIn.DescId = zc_Movement_ReturnIn()
             JOIN MovementItem AS MI_ReturnIn
                               ON MI_ReturnIn.MovementId = Movement_ReturnIn.Id
                              AND MI_ReturnIn.DescId = zc_MI_Master()
             LEFT JOIN MovementItemString AS MIString_GUID
                                          ON MIString_GUID.MovementItemId = MI_ReturnIn.Id
                                         AND MIString_GUID.DescId = zc_MIString_GUID()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MI_ReturnIn.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                         ON MIFloat_Price.MovementItemId = MI_ReturnIn.Id
                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
             LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                         ON MIFloat_ChangePercent.MovementItemId = MI_ReturnIn.Id
                                        AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent() 
        WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
          AND MovementString_GUID.ValueData = inMovementGUID
        LIMIT CASE WHEN vbUserId = zfCalc_UserMobile_limit0() THEN 0 ELSE 500000 END
       ;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 18.08.17                                                        *                  
*/

-- SELECT * FROM gpSelectMobile_MovementItem_ReturnIn (inMovementGUID:= '{D2399D25-513D-4F68-A1ED-FCD21C63A0B7}', inSession:= zfCalc_UserAdmin());
