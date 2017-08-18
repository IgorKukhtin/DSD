-- Function: gpGetMobile_Movement_ReturnIn

DROP FUNCTION IF EXISTS gpGetMobile_Movement_ReturnIn (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGetMobile_Movement_ReturnIn (
    IN inGUID    TVarChar , -- Глобальный уникальный идентификатор для синхронизации с Главной БД
    In inSession TVarChar   -- сессия пользователей
)
RETURNS TABLE (Id            Integer -- ИД возврата от покупателя
             , ChangePercent TFloat  -- (-)% Скидки (+)% Наценки
             , TotalCountKg  TFloat  -- Итого количество, кг
             , TotalSummPVAT TFloat  -- Итого сумма по накладной (с НДС)
              )
AS $BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- Результат
      RETURN QUERY
        SELECT MovementString_GUID.MovementId                              AS Id
             , COALESCE (MovementFloat_ChangePercent.ValueData, 0)::TFloat AS ChangePercent
             , COALESCE (MovementFloat_TotalCountKg.ValueData, 0)::TFloat  AS TotalCountKg
             , COALESCE (MovementFloat_TotalSummPVAT.ValueData, 0)::TFloat AS TotalSummPVAT
        FROM MovementString AS MovementString_GUID
             JOIN Movement AS Movement_ReturnIn
                           ON Movement_ReturnIn.Id = MovementString_GUID.MovementId
                          AND Movement_ReturnIn.DescId = zc_Movement_ReturnIn()
             LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                     ON MovementFloat_ChangePercent.MovementId = Movement_ReturnIn.Id
                                    AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
             LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                     ON MovementFloat_TotalCountKg.MovementId = Movement_ReturnIn.Id
                                    AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
             LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                     ON MovementFloat_TotalSummPVAT.MovementId = Movement_ReturnIn.Id
                                    AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()
        WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
          AND MovementString_GUID.ValueData = inGUID;
END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 18.08.17                                                        *                  
*/

-- SELECT * FROM gpGetMobile_Movement_ReturnIn (inGUID:= '{D2399D25-513D-4F68-A1ED-FCD21C63A0B7}', inSession:= zfCalc_UserAdmin());
