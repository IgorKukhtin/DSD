-- Function: gpInsert_MI_SaleCommerc_Load ()

DROP FUNCTION IF EXISTS gpInsert_MI_SaleCommerc_Load (Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_MI_SaleCommerc_Load (Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_SaleCommerc_Load(
    IN inMovementId            Integer   , -- ключ Документа
    IN inBranchName            TVarChar  , -- филиал
    IN inJuridicalName         TVarChar  , -- Юр лицо 
    IN inPartnerName           TVarChar  , -- Контрагент 
    IN inPartnerId             Integer   , -- Контрагент
    IN inContractName          TVarChar  , -- Договор
    IN inPaidKindName          TVarChar  , -- Форма оплаты
    IN inGoodsCode             Integer  , -- 
    IN inGoodsName             TVarChar  , -- 
    IN inGoodsKindName         TVarChar  , -- 
    IN inAmount                TFloat    , -- шт
    IN inAmount_weight         TFloat    , -- кг
    IN inSumm                  TFloat    , --
    IN inAmountPromo           TFloat    , -- шт
    IN inAmountPromo_weight    TFloat    , -- кг
    IN inSummPromo             TFloat    , --
    IN inAmountNoPromo         TFloat    , -- шт
    IN inAmountNoPromo_weight  TFloat    , -- кг
    IN inSummNoPromo           TFloat    , --    
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId        Integer;
   DECLARE vbGoodsId       Integer;
           vbBranchId      Integer;
           vbJuridicalId   Integer;
           vbContractId    Integer;
           vbPaidKindId    Integer;
           vbGoodsKindId   Integer;
           vbId            Integer;
           vbId_child      Integer;
           vbPrice         TFloat;
           vbAmount        TFloat;
           vbAmountPromo   TFloat;
           vbAmountNoPromo TFloat;
           
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SaleCommerc());

     -- 1 Поиск - Форма оплаты
     vbPaidKindId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PaidKind() AND Object.ValueData ILIKE inPaidKindName AND Object.isErased = FALSE);
     --проверка
     IF COALESCE (vbPaidKindId,0) = 0 AND TRIM (inPaidKindName) <> ''
     THEN
         RAISE EXCEPTION 'Ошибка.Не найдена Форма оплаты <%> в справочнике <Форм оплаты> .', inPaidKindName;
     END IF;
     

     -- 2 Поиск - Контргагент
     IF COALESCE(inPartnerId,0) <> 0 AND NOT EXISTS (SELECT 1 FROM Object WHERE Object.DescId = zc_Object_Partner() AND Object.Id = inPartnerId AND Object.isErased = FALSE) 
     THEN
         RAISE EXCEPTION 'Ошибка.Не найден ключ-2 <%> для <%> в справочнике <Контрагенты>.', inPartnerId, inPartnerName;
     END IF;
          
     IF COALESCE(inPartnerId,0) = 0
     THEN
         inPartnerId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Partner() AND Object.ValueData ILIKE inPartnerName AND Object.isErased = FALSE);
         --проверка
         IF COALESCE (inPartnerId,0) = 0 AND TRIM (inPartnerName) <> ''
         THEN
             RAISE EXCEPTION 'Ошибка.Не найден контрагент <%> в справочнике <Контрагенты>.', inPartnerName, inPartnerId;
         END IF;
     
     END IF;

     -- 3 Поиск договор по контрагенту
     vbJuridicalId := (SELECT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                       FROM ObjectLink AS ObjectLink_Partner_Juridical
                       WHERE ObjectLink_Partner_Juridical.ObjectId = inPartnerId
                         AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                      ); 
 
     --проверка
     IF COALESCE (vbJuridicalId,0) = 0
     THEN   
         RAISE EXCEPTION 'Ошибка.Не найдено Юр.дицо <%> для контрагента <%> ключ-2 <%> .', inJuridicalName, inPartnerName, inPartnerId;
     END IF;
     
     SELECT Object_Contract.Id  AS ContractId
            INTO vbContractId
     FROM ObjectLink AS ObjectLink_Contract_Juridical
          INNER JOIN Object AS Object_Contract ON Object_Contract.Id       = ObjectLink_Contract_Juridical.ObjectId
                                              AND Object_Contract.isErased = FALSE
                                              AND Object_Contract.ValueData ILIKE TRIM (inContractName)

          LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                               ON ObjectLink_Contract_ContractStateKind.ObjectId      = Object_Contract.Id
                              AND ObjectLink_Contract_ContractStateKind.DescId        = zc_ObjectLink_Contract_ContractStateKind()

          LEFT JOIN ObjectLink AS ObjectLink_Contract_PaidKind
                               ON ObjectLink_Contract_PaidKind.ObjectId = Object_Contract.Id
                              AND ObjectLink_Contract_PaidKind.DescId   = zc_ObjectLink_Contract_PaidKind()
     WHERE ObjectLink_Contract_Juridical.ChildObjectId = vbJuridicalId
       AND ObjectLink_Contract_Juridical.DescId        = zc_ObjectLink_Contract_Juridical()
       AND ObjectLink_Contract_PaidKind.ChildObjectId  = vbPaidKindId
    --   AND COALESCE (ObjectLink_Contract_ContractStateKind.ChildObjectId, 0) <> zc_Enum_ContractStateKind_Close()
     LIMIT 1;   --

     -- проверка
     IF COALESCE (vbContractId, 0) = 0 AND TRIM (inContractName) <> ''
     THEN
         --
         RAISE EXCEPTION 'Ошибка.Не найден Договор <%> для <%>.', inContractName, inPartnerName;
     END IF;

     -- 4 Филиал
     IF TRIM (COALESCE (inBranchName,'')) <> ''
     THEN
         vbBranchId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Branch() AND TRIM (Object.ValueData) = TRIM (inBranchName) AND Object.isErased = FALSE);
         -- проверка
         IF COALESCE (vbBranchId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найден Филиал <%> в справочнике.', inBranchName;
         END IF;
     END IF;

     -- 5 Поиск товара            --, CHR (13)
     IF COALESCE (inGoodsCode,0) > 0
     THEN
         -- Товар
         vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode =  (inGoodsCode));
         -- проверка
         IF COALESCE (vbGoodsId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найден товар Код = <%> <%> в справочнике <Товаров>.', zfConvert_StringToNumber (inGoodsCode), inGoodsName;
         END IF;

     ELSE
         -- Товар
         vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND TRIM (Object.ValueData) ILIKE TRIM (inGoodsName) AND TRIM (inGoodsName) <> ''
                          );
         -- проверка
         IF COALESCE (vbGoodsId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найден Товар <%> в справочнике <Товаров>.', inGoodsName;
         END IF;

     END IF;

     -- 6 находим вид товара
     vbGoodsKindId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName) AND Object.DescId = zc_Object_GoodsKind() AND TRIM (inGoodsKindName) <> '');

     IF COALESCE (vbGoodsKindId,0) = 0 AND TRIM (inGoodsKindName) <> ''
     THEN
        RAISE EXCEPTION 'Ошибка. Вид товара <%> не найден в справочнике <Виды товара>.', inGoodsKindName;
     END IF;



     -- 1.сохраняем Master, не ошибка - в Master все суммы = 0 + Примечание в чайлд
     -- пробуем найти строку мастер, если нет записываем
     vbId := (SELECT MovementItem.Id
              FROM MovementItem
                  INNER JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                    ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
                                                   AND MILinkObject_Partner.ObjectId = inPartnerId

                  INNER JOIN MovementItemLinkObject AS MILinkObject_Branch
                                                    ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
                                                   AND MILinkObject_Branch.ObjectId = vbBranchId

                  INNER JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                                    ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
                                                   AND MILinkObject_PaidKind.ObjectId = vbPaidKindId
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId     = zc_MI_Master()
                AND MovementItem.isErased   = FALSE
                AND MovementItem.ObjectId   = vbContractId
              );
     --если не нашли сохраняем
     IF COALESCE (vbId,0) = 0
     THEN 
         SELECT tmp.ioId
                INTO vbId
         FROM lpInsertUpdate_MI_SaleCommerc (ioId           := COALESCE (vbId,0)          ::Integer
                                           , inMovementId   := inMovementId   ::Integer
                                           , inContractId   := vbContractId   ::Integer
                                           , inBranchId     := vbBranchId     ::Integer
                                           , inPartnerId    := inPartnerId    ::Integer
                                           , inPaidKindId   := vbPaidKindId   ::Integer 
                                           , inUserId       := vbUserId
                                             ) AS tmp;
     END IF;
/*
 RAISE EXCEPTION 'Ошибка.Test <%> <%> <%> <%> <%> <%> <%> <%> <%> <%>'
                        ,inMovementId ,vbId           
                        ,vbGoodsId, vbGoodsKindId         
                                    
                        ,inAmount                
                        ,inSumm          
                        ,inAmountPromo          
                        ,inSummPromo
,inAmountNoPromo
, inSummNoPromo             
                         ;
                         
*/
     -- Цены из прайса базового прайса
     vbPrice := (WITH
                  tmp AS (SELECT lfSelect.GoodsKindId AS GoodsKindId
                               , lfSelect.ValuePrice  AS Price
                          FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_BasisComerc()
                                                                   , inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
                                                                    ) AS lfSelect
                          WHERE lfSelect.GoodsId = vbGoodsId
                          )
                  SELECT COALESCE ( (SELECT tmp.Price FROM tmp WHERE COALESCE (tmp.GoodsKindId,0) = COALESCE (vbGoodsKindId,0))
                                  , (SELECT tmp.Price FROM tmp WHERE tmp.GoodsKindId IS NULL)
                                  , 0 
                                  ) ::TFloat AS Price
                 ) ::TFloat;

     -- 2.сохраняем Child - Первичный план на неделю
     -- если товар шт - берем эту колонку, если там 0 а есть кг, то переводим в шт, весовой - всегда в кг
     SELECT CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()       
                 THEN CASE WHEN COALESCE (inAmount,0) <> 0
                           THEN inAmount
                           ELSE CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0
                                     THEN inAmount_weight / COALESCE (ObjectFloat_Weight.ValueData,0)
                                     ELSE 0
                                END
                      END
                 ELSE COALESCE (inAmount_weight,0)
            END ::TFloat AS Amount
          , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()       
                 THEN CASE WHEN COALESCE (inAmountPromo,0) <> 0
                           THEN inAmountPromo
                           ELSE CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0
                                     THEN inAmountPromo_weight / COALESCE (ObjectFloat_Weight.ValueData,0)
                                     ELSE 0
                                END
                      END
                 ELSE COALESCE (inAmountPromo_weight,0)
            END ::TFloat AS AmountPromo
          , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()       
                 THEN CASE WHEN COALESCE (inAmountNoPromo,0) <> 0
                           THEN inAmountNoPromo
                           ELSE CASE WHEN COALESCE (ObjectFloat_Weight.ValueData,0) <> 0
                                     THEN inAmountNoPromo_weight / COALESCE (ObjectFloat_Weight.ValueData,0)
                                     ELSE 0
                                END
                      END
                 ELSE COALESCE (inAmountNoPromo_weight,0)
            END ::TFloat AS AmountNoPromo
   INTO vbAmount, vbAmountPromo, vbAmountNoPromo
     FROM ObjectLink AS ObjectLink_Goods_Measure
          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = ObjectLink_Goods_Measure.ObjectId
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
     WHERE ObjectLink_Goods_Measure.ObjectId = vbGoodsId
       AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure();
                                                      
     --                                                  
     SELECT tmp.ioId
      INTO vbId_child
         FROM lpInsertUpdate_MI_SaleCommerc_Child (ioId             := 0                 ::Integer
                                                 , inParentId       := vbId              ::Integer
                                                 , inMovementId     := inMovementId      ::Integer
                                                 , inGoodsId        := vbGoodsId         ::Integer
                                                 , inGoodsKindId    := vbGoodsKindId     ::Integer
                                                 , inAmount         := vbAmount          ::TFloat
                                                 , inSumm           := inSumm            ::TFloat
                                                 , inAmountPromo    := vbAmountPromo     ::TFloat
                                                 , inSummPromo      := inSummPromo       ::TFloat
                                                 , inAmountNoPromo  := vbAmountNoPromo   ::TFloat
                                                 , inSummNoPromo    := inSummNoPromo     ::TFloat
                                                 , inPrice          := vbPrice           ::TFloat
                                                 , inUserId         := vbUserId
                                                  ) AS tmp;

    -- тест
    --if vbUserId IN (9457) then RAISE EXCEPTION 'Админ.Test Ok. '; end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.02.26         *
*/

-- тест
--