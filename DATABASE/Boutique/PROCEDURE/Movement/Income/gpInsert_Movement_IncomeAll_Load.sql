-- Function: gpInsert_Movement_IncomeAll_Load()

DROP FUNCTION IF EXISTS gpInsert_Movement_IncomeAll_Load (TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_IncomeAll_Load(
    IN inOperDate              TDateTime ,
    IN inObjectCode            Integer   , -- код товара / название
    IN inPeriodName            TVarChar  , -- сезон
    IN inBrandName             TVarChar  , -- Торговая марка
    IN inGoodsGroupName        TVarChar  , -- группа товара
    IN inLabelName             TVarChar  , -- Название для ценника
    IN inCompositionName       TVarChar  , -- Состав товара
    IN inGoodsInfoName         TVarChar  , -- Описание товара 
    IN inOperPrice             TFloat    , -- вх цена
    IN inOperPriceList         TFloat    , -- цена продажи
    IN inAmount                TFloat    , -- кол-во
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbCurrencyId  Integer;
   DECLARE vbPartnerId   Integer;
   DECLARE vbUnitId      Integer;
   DECLARE vbBrandId     Integer;
   DECLARE vbPeriodId       Integer;
   DECLARE vbMovementId     Integer;
   DECLARE vbGoodsGroupParentId Integer;
   DECLARE vbGoodsGroupId   Integer;
   DECLARE vbCurrencyValue  TFloat;
   DECLARE vbParValue       TFloat;
   
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService_Child());
     vbUserId:= lpGetUserBySession (inSession);
     
     -- вносим данне только где остаток <> 0
     IF COALESCE (inAmount, 0) = 0
     THEN
         -- !!!ВЫХОД!!!
         RETURN;
     END IF;

     -- Ид подразделения
     vbUnitId := (SELECT Object.Id 
                  FROM Object
                  WHERE Object.DescId = zc_Object_Unit()
                     AND UPPER (TRIM (Object.ValueData) ) LIKE UPPER('%'||TRIM ('магазин PODIUM')||'%')    -- магазин PODIUM пока все привязала к этому магазину
                  );

     -- Ид валюта
     vbCurrencyId := zc_Currency_Basis();

     IF COALESCE (vbCurrencyId,0) = 0
     THEN 
         RAISE EXCEPTION 'Ошибка.Не найдена <Валюта> <%>.', inCurrencyName;
     END IF;
                          
     -- Ид поставщика
     vbPartnerId := (SELECT Object.Id 
                     FROM Object
                     WHERE Object.DescId = zc_Object_Partner()
                        AND UPPER (TRIM (Object.ValueData) ) LIKE UPPER('%'||TRIM (inBrandName||' ' ||inPeriodName)||'%')
                     );

     IF COALESCE (vbPartnerId,0) = 0
     THEN
         -- 
         vbBrandId := (SELECT Object.Id 
                       FROM Object
                       WHERE Object.DescId = zc_Object_Brand()
                          AND UPPER (TRIM (Object.ValueData) ) = UPPER (TRIM (inBrandName))
                       );
         IF COALESCE (vbBrandId, 0) = 0
         THEN
             -- Создание
             vbBrandId := (SELECT tmp.ioId 
                           FROM gpInsertUpdate_Object_Brand (ioId          := 0
                                                           , ioCode        := 0
                                                           , inName        := TRIM (inBrandName)
                                                           , inCountryBrandId := 0
                                                           , inSession     := inSession
                                                            ) AS tmp);
         END IF;
         --
         vbPeriodId := (SELECT Object.Id 
                        FROM Object
                        WHERE Object.DescId = zc_Object_Period()
                           AND UPPER (TRIM(Object.ValueData)) =  UPPER (TRIM(LEFT (inPeriodName, length(inPeriodName)-4)))
                        );
                       
         -- сохранили
         SELECT tmp.ioId
                INTO vbPartnerId
         FROM gpInsertUpdate_Object_Partner (ioId            := 0
                                           , ioCode          := 0
                                           , inBrandId       := vbBrandId
                                           , inFabrikaId     := 0
                                           , inPeriodId      := vbPeriodId
                                           , inPeriodYear    := RIGHT (TRIM (inPeriodName), 4) ::TFloat
                                           , inSession       := inSession
                                           ) AS tmp;
     END IF;

     -- пробуем найти документ по ключу дата, поставщик, магазин
     vbMovementId := (SELECT Movement.Id
                      FROM Movement
                           INNER JOIN MovementLinkObject AS MLO_From
                                                         ON MLO_From.MovementId = Movement.Id
                                                        AND MLO_From.DescId = zc_MovementLinkObject_From()
                                                        AND MLO_From.ObjectId = vbPartnerId
                           INNER JOIN MovementLinkObject AS MLO_To
                                                         ON MLO_To.MovementId = Movement.Id
                                                        AND MLO_To.DescId = zc_MovementLinkObject_To()
                                                        AND MLO_To.ObjectId = vbUnitId
               
                           INNER JOIN MovementLinkObject AS MLO_CurrencyDocument
                                                         ON MLO_CurrencyDocument.MovementId = Movement.Id
                                                        AND MLO_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
                                                        AND MLO_CurrencyDocument.ObjectId = vbCurrencyId
                      WHERE Movement.DescId = zc_Movement_Income()
                        AND Movement.OperDate = inOperDate
                      LIMIT 1);

     IF COALESCE (vbMovementId, 0) = 0
     THEN
  
         -- Если НЕ Базовая Валюта
         IF vbCurrencyId <> zc_Currency_Basis()
         THEN
             -- Определили курс на Дату документа
             SELECT COALESCE (tmp.Amount, 1), COALESCE (tmp.ParValue,0)
                    INTO vbCurrencyValue, vbParValue
             FROM lfSelect_Movement_Currency_byDate (inOperDate      := inOperDate
                                                   , inCurrencyFromId:= zc_Currency_Basis()
                                                   , inCurrencyToId  := vbCurrencyId
                                                    ) AS tmp;
         ELSE
             -- курс не нужен
             vbCurrencyValue:= 0;
             vbParValue     := 0;
         END IF;

         -- сохранили <Документ>
         vbMovementId := lpInsertUpdate_Movement_Income (ioId                := 0
                                                       , inInvNumber         := CAST (NEXTVAL ('Movement_Income_seq') AS TVarChar)
                                                       , inOperDate          := inOperDate
                                                       , inFromId            := vbPartnerId
                                                       , inToId              := vbUnitId
                                                       , inCurrencyDocumentId:= vbCurrencyId
                                                       , inCurrencyValue     := vbCurrencyValue
                                                       , inParValue          := vbParValue
                                                       , inComment           := 'загрузка' ::TVarChar
                                                       , inUserId            := vbUserId
                                                        );
                                            
     END IF;

     -- Группа товара
     vbGoodsGroupId:= (SELECT Object.Id 
                       FROM Object 
                       WHERE Object.DescId = zc_Object_GoodsGroup()
                         AND LOWER (Object.ValueData) = LOWER (COALESCE (TRIM (inGoodsGroupName), '')));
     --
     IF COALESCE (vbGoodsGroupId, 0) = 0
     THEN
         -- Создание
         vbGoodsGroupId := (SELECT tmp.ioId FROM gpInsertUpdate_Object_GoodsGroup (ioId          := 0
                                                                                 , ioCode        := 0
                                                                                 , inName        := COALESCE (TRIM (inGoodsGroupName), '')
                                                                                 , inParentId    := 0
                                                                                 , inInfoMoneyId := 0
                                                                                 , inSession     := inSession
                                                                                   ) AS tmp);
     END IF;
     
     PERFORM gpInsertUpdate_MIEdit_Income(ioId                 :=   0  -- Ключ объекта <Элемент документа>
                                        , inMovementId         :=   vbMovementId
                                        , inGoodsGroupId       :=   vbGoodsGroupId
                                        , inMeasureId          :=   219                                    -- шт.
                                        , inJuridicalId        :=   0         -- Юр.лицо(наше)
                                        , ioGoodsCode          :=   NEXTVAL ('Object_Goods_seq')   ::Integer      -- код товара
                                        , inGoodsName          :=   TRIM (inObjectCode :: TVarChar) :: TVarChar  -- Товары
                                        , inGoodsInfoName      :=   inGoodsInfoName                 :: TVarChar  --
                                        , inGoodsSizeName      :=   ''                              :: TVarChar  --
                                        , inCompositionName    :=   inCompositionName
                                        , inLineFabricaName    :=   '-'                :: TVarChar  --
                                        , inLabelName          :=   inLabelName  --
                                        , inAmount             :=   inAmount           :: TFloat    -- Количество
                                        , inPriceJur           :=   inOperPrice        :: TFloat    -- Цена вх.без скидки
                                        , inCountForPrice      :=   1                  :: TFloat    -- Цена за количество
                                        , inOperPriceList      :=   inOperPriceList    :: TFloat    -- Цена по прайсу
                                        , inSession            :=   inSession  -- сессия пользователя
                                         );      

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.01.20         *
*/

-- тест
