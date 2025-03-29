-- Function: lpGet_ObjectHistory_Price_check ()

DROP FUNCTION IF EXISTS lpGet_ObjectHistory_Price_check (TDateTime, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_ObjectHistory_Price_check(
    IN inMovementId            Integer,
    IN inMovementItemId        Integer,
    IN inContractId            Integer,
    IN inPartnerId             Integer,
    IN inMovementDescId        Integer,
    IN inOperDate_order        TDateTime,
    IN inOperDatePartner       TDateTime,
    IN inDayPrior_PriceReturn  Integer,
    IN inIsPrior               Boolean,
    IN inOperDatePartner_order TDateTime, -- DEFAULT NULL
    IN inGoodsId                Integer,  -- Товар
    IN inGoodsKindId            Integer,  -- Вид товара
    IN inPrice                  TFloat,   -- Цена для проверки
    IN inCountForPrice          TFloat,   --
    IN inUserId                 Integer   -- пользователь
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbPriceListId Integer;
   DECLARE vbOperDate_pl TDateTime;
   DECLARE vbPrice_check TFloat;
BEGIN

       IF (SELECT 1 FROM Object WHERE Object.Id = inPartnerId AND Object.DescId = zc_Object_Unit())
       THEN
           vbPriceListId:= zc_PriceList_Basis();
           -- 
           IF inOperDate_order IS NOT NULL
           THEN
               vbOperDate_pl:= inOperDate_order;
           END IF;
       ELSE
           
           -- !!!нашли!!!
           SELECT tmp.PriceListId, tmp.OperDate
                  INTO vbPriceListId, vbOperDate_pl
           FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractId
                                                     , inPartnerId      := inPartnerId
                                                     , inMovementDescId := inMovementDescId
                                                     , inOperDate_order := inOperDate_order
                                                     , inOperDatePartner:=  inOperDatePartner
                                                     , inDayPrior_PriceReturn:= inDayPrior_PriceReturn
                                                     , inIsPrior        := inIsPrior
                                                     , inOperDatePartner_order:= inOperDatePartner_order
                                                      ) AS tmp;

       END IF;

       -- !!!поиск!!!
       vbPrice_check:= COALESCE ((SELECT tmp.ValuePrice FROM gpGet_ObjectHistory_PriceListItem (inOperDate   := vbOperDate_pl
                                                                                              , inPriceListId:= vbPriceListId
                                                                                              , inGoodsId    := inGoodsId
                                                                                              , inGoodsKindId:= inGoodsKindId
                                                                                              , inSession    := lfGet_User_Session (inUserId)
                                                                                               ) AS tmp)
                                , 0);
       -- если не нашли
       IF COALESCE (vbPrice_check, 0) = 0
       THEN
           -- !!!вторая попытка!!!
           vbPrice_check:= COALESCE ((SELECT tmp.ValuePrice FROM gpGet_ObjectHistory_PriceListItem (inOperDate   := vbOperDate_pl
                                                                                                  , inPriceListId:= vbPriceListId
                                                                                                  , inGoodsId    := inGoodsId
                                                                                                  , inGoodsKindId:= NULL
                                                                                                  , inSession    := lfGet_User_Session (inUserId)
                                                                                                   ) AS tmp)
                                    , 0);
       END IF;

       -- Проверка
       IF COALESCE (vbPrice_check, 0) = 0 AND EXTRACT (HOURS FROM CURRENT_TIMESTAMP) >= 9 AND EXTRACT (HOURS FROM CURRENT_TIMESTAMP) < 23
          AND inPrice > 0
          --
          AND inUserId <> 5
       THEN
           RAISE EXCEPTION 'Ошибка.Не установлена цена в прайсе <%> для <%>.'
                         , lfGet_Object_ValueData_sh (vbPriceListId)
                         , lfGet_Object_ValueData (inGoodsId)
                          ;

       ELSEIF COALESCE (inMovementItemId, 0) = 0
       THEN
           -- !!!замена!!!
           IF vbPrice_check > 0 THEN inPrice:= vbPrice_check; END IF;

       ELSEIF ABS (ROUND (COALESCE (inPrice, 0), 2) - COALESCE (vbPrice_check, 0)) > 0.02
          -- 
          AND NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View AS RoleAccessKeyView WHERE RoleAccessKeyView.UserId = inUserId AND RoleAccessKeyView.AccessKeyId = zc_Enum_Process_Update_MI_OperPrice())
          -- Проведение документов - нет проверки по филиалу
          AND NOT EXISTS  (SELECT 1 FROM Object_Role_Process_View WHERE Object_Role_Process_View.ProcessId = zc_Enum_Process_UpdateMovement_Branch() AND Object_Role_Process_View.UserId = inUserId)
          --
          AND inUserId <> 5
       THEN
           RAISE EXCEPTION 'Ошибка.У пользователя <%> нет прав ручного регулирования цены <%>.%Для <%>%Можно ввести цену <%> из прайса <%>.'
                         , lfGet_Object_ValueData_sh (inUserId)
                         , zfConvert_FloatToString (inPrice)
                         , CHR (13)
                         , lfGet_Object_ValueData (inGoodsId)
                         , CHR (13)
                         , zfConvert_FloatToString (vbPrice_check)
                         , lfGet_Object_ValueData_sh (vbPriceListId)
                          ;
       END IF;



       RETURN inPrice;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.05.15                                        *
*/

-- тест
/* SELECT * FROM lpGet_ObjectHistory_Price_check (inMovementId            := 1
                                              , inMovementItemId        := 1
                                              , inContractId            := 1
                                              , inPartnerId             := 1
                                              , inMovementDescId        := zc_Movement_Sale()
                                              , inOperDate_order        := CURRENT_DATE
                                              , inOperDatePartner       := NULL
                                              , inDayPrior_PriceReturn  := NULL
                                              , inIsPrior               := FALSE -- !!!отказались от старых цен!!!
                                              , inOperDatePartner_order := CURRENT_DATE
                                              , inGoodsId               := 2
                                              , inGoodsKindId           := 2
                                              , inPrice                 := 1
                                              , inCountForPrice         := 1
                                              , inUserId                := 5
                                               )
*/
