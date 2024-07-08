-- Function: gpGet_Movement_MobilebyOrderClient()

DROP FUNCTION IF EXISTS gpGet_Movement_MobilebyOrderClient ( TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_MobilebyOrderClient(
    IN inBarCode           TVarChar   , --
    IN inInvNumber         TVarChar   , --
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id                 Integer
             , InvNumber          TVarChar
             , InvNumberFull      TVarChar
               )
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbId         Integer;
   DECLARE vbStatusId   Integer;
   DECLARE vbDescId     Integer;
   DECLARE vbInvNumber  TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     IF SUBSTRING(inBarCode, 1, 4) = zc_BarCodePref_Movement()
     THEN
         -- Не удален
         SELECT Movement.Id, Movement.StatusId, Movement.InvNumber, Movement.DescId
                INTO vbId, vbStatusId, vbInvNumber, vbDescId
         FROM Movement
         WHERE Movement.DescId  IN (zc_Movement_OrderClient(), zc_Movement_OrderInternal())
           AND Movement.Id = SUBSTRING (inBarCode, 5, 8) :: Integer
           AND Movement.StatusId <> zc_Enum_Status_Erased()
        ;

         -- если не нашли
         IF COALESCE (vbId, 0) = 0
         THEN
             -- ВСЕ
             SELECT Movement.Id, Movement.StatusId, Movement.InvNumber, Movement.DescId
                    INTO vbId, vbStatusId, vbInvNumber, vbDescId
             FROM Movement
             WHERE Movement.DescId  IN (zc_Movement_OrderClient(), zc_Movement_OrderInternal())
               AND Movement.Id = SUBSTRING (inBarCode, 5, 8) :: Integer
            ;
         END IF;

     ELSEIF COALESCE(inBarCode, '') = '' AND COALESCE(inInvNumber, '') <> ''
     THEN
         -- Не удален
         SELECT Movement.Id, Movement.StatusId, Movement.InvNumber, Movement.DescId
                INTO vbId, vbStatusId, vbInvNumber, vbDescId
         FROM Movement
         WHERE Movement.DescId IN (zc_Movement_OrderClient(), zc_Movement_OrderInternal())
           AND Movement.InvNumber = TRIM (inInvNumber)
           AND Movement.StatusId <> zc_Enum_Status_Erased()
         ORDER BY CASE WHEN Movement.DescId = zc_Movement_OrderClient() THEN 0 ELSE 1 END
         LIMIT 1
        ;

         -- если не нашли
         IF COALESCE (vbId, 0) = 0
         THEN
             -- ВСЕ
             SELECT Movement.Id, Movement.StatusId, Movement.InvNumber, Movement.DescId
                    INTO vbId, vbStatusId, vbInvNumber, vbDescId
             FROM Movement
             WHERE Movement.DescId IN (zc_Movement_OrderClient(), zc_Movement_OrderInternal())
               AND Movement.InvNumber = TRIM (inInvNumber)
               AND Movement.StatusId <> zc_Enum_Status_Erased()
             ORDER BY CASE WHEN Movement.DescId = zc_Movement_OrderClient() THEN 0 ELSE 1 END
             LIMIT 1
            ;
         END IF;

     ELSE
         -- не нашли
         vbId := 0;
     END IF;


     IF COALESCE (vbId, 0) <> 0 AND vbDescId = zc_Movement_OrderInternal()
     THEN

       IF COALESCE((SELECT COUNT(DISTINCT MIFloat_MovementId.ValueData)
                    FROM MovementItem

                         INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                      ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                     AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                                     AND MIFloat_MovementId.ValueData      > 0

                    WHERE MovementItem.MovementId = vbId
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.DescId     = zc_MI_Master()), 0)  = 1
       THEN

         SELECT MIFloat_MovementId.ValueData::Integer
                INTO vbId
         FROM MovementItem
              INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                           ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                          AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                          AND MIFloat_MovementId.ValueData      > 0

         WHERE MovementItem.MovementId = vbId
           AND MovementItem.isErased   = FALSE
           AND MovementItem.DescId     = zc_MI_Master()
         LIMIT 1;

       ELSEIF COALESCE((SELECT COUNT(DISTINCT MIFloat_MovementId.ValueData)
                        FROM MovementItem

                             INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                          ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                         AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                                         AND COALESCE (MIFloat_MovementId.ValueData, 0) <> 0

                        WHERE MovementItem.MovementId = vbId
                          AND MovementItem.isErased   = FALSE
                          AND MovementItem.DescId     = zc_MI_Master()), 0)  > 1
       THEN
         IF COALESCE(inBarCode, '') = ''
         THEN
           RAISE EXCEPTION 'Ошибка. В заказе на производство c номером <%> более одной связи на заказ покупателя.', inInvNumber;
         ELSE
           RAISE EXCEPTION 'Ошибка. В заказе на производство по Ш/К <%> более одной связи на заказ покупателя.', inBarCode;
         END IF;
       ELSE
         IF COALESCE(inBarCode, '') = ''
         THEN
           RAISE EXCEPTION 'Ошибка. В заказе на производство c номером <%> нет связей на заказ покупателя.', inInvNumber;
         ELSE
           RAISE EXCEPTION 'Ошибка. В заказе на производство по Ш/К <%> нет связей на заказ покупателя.', inBarCode;
         END IF;
       END IF;
     END IF;

     IF COALESCE (vbId, 0) = 0
     THEN
       IF COALESCE(inBarCode, '') = ''
       THEN
         RAISE EXCEPTION 'Ошибка. Заказ клиента c номером <%> не наден.', inInvNumber;
       ELSE
         RAISE EXCEPTION 'Ошибка. Заказ клиента по Ш/К <%> не наден.', inBarCode;
       END IF;
     ELSEIF vbStatusId = zc_Enum_Status_Erased()
     THEN
       RAISE EXCEPTION 'Ошибка. Заказ клиента номер <%> удален.', vbInvNumber;
     END IF;

     -- Результат
     RETURN QUERY
       SELECT Movement.Id            AS Id
            , Movement.InvNumber     AS InvNumber
            , Movement.InvNumber     AS InvNumberFull

       FROM Movement
       WHERE Movement.Id = vbId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.04.24                                                       *
*/

-- тест
--

select * from gpGet_Movement_MobilebyOrderClient(inBarCode := '223000000813' , inInvNumber := '' ,  inSession := '5');