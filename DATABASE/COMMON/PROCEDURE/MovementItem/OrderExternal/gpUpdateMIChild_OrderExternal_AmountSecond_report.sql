-- Function: gpUpdateMIChild_OrderExternal_AmountSecond_report()

DROP FUNCTION IF EXISTS gpUpdateMIChild_OrderExternal_AmountSecond_report (TDateTime, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMIChild_OrderExternal_AmountSecond_report(
    IN inOperDate                TDateTime , -- Дата документа
    IN inOperDatePartner         TDateTime , -- Дата отгрузки со склада
    IN inToId                    Integer   , -- Кому (в документе)
    IN inRouteId                 Integer   , -- Маршрут
    IN inRetailId                Integer   , -- торг. сеть
    IN inGoodsId                 Integer   , -- если развернуто по товаарм тогда запрет редактирования
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderExternal_child());


     IF COALESCE (inGoodsId, 0) <> 0
     THEN
         RAISE EXCEPTION 'Ошибка.В режиме детализации по товарам изменения не возможны.';
     END IF;

     --
     IF COALESCE (inRouteId, 0) = 0 AND COALESCE (inRetailId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Маршрут и Торговая сеть не установлены.';
     END IF;


     ---
     PERFORM gpUpdateMIChild_OrderExternal_AmountSecond (tmp.Id, inSession)
     FROM (SELECT Movement.Id
           FROM Movement
               INNER JOIN MovementDate AS MovementDate_OperDatePartner
                                       ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                      AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                      AND MovementDate_OperDatePartner.ValueData = inOperDatePartner

               INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                            AND MovementLinkObject_To.ObjectId   = inToId

               LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                            ON MovementLinkObject_Route.MovementId = Movement.Id
                                           AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()

               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
               LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

               LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                    ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                   AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
               LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                    ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                   AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

           WHERE Movement.OperDate = inOperDate
             AND Movement.StatusId = zc_Enum_Status_Complete()
             AND Movement.DescId = zc_Movement_OrderExternal()
             AND (inRetailId = CASE WHEN Object_From.DescId = zc_Object_Unit() THEN Object_From.Id ELSE COALESCE (ObjectLink_Juridical_Retail.ChildObjectId, Object_From.Id) END
               OR COALESCE (inRetailId, 0) = 0
                 )
             AND COALESCE (MovementLinkObject_Route.ObjectId, 0) = inRouteId
             ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.07.22         *
*/

-- тест
--