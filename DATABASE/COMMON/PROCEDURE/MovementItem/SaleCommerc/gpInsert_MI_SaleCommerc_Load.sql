-- Function: gpInsert_MI_SaleCommerc_Load ()

DROP FUNCTION IF EXISTS gpInsert_MI_SaleCommerc_Load (Integer, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_SaleCommerc_Load(
    IN inMovementId            Integer   , -- ключ Документа
    IN inBranchName            TVarChar  , -- филиал 
    IN inPartnerName           TVarChar  , -- Контрагент 
    IN inPartnerId             Integer   , -- Контрагент
    IN inContractName          TVarChar  , -- Договор
    IN inPaidKindName          TVarChar  , -- Форма оплаты
    IN inGoodsCode             TVarChar  , -- 
    IN inGoodsName             TVarChar  , -- 
    IN inGoodsKindName         TVarChar  , -- 
    IN inAmount                TFloat    , -- 
    IN inSumm                  TFloat    , --
    IN inAmountPromo           TFloat    , --
    IN inSummPromo             TFloat    , --
    IN inAmountNoPromo         TFloat    , --
    IN inSummNoPromo           TFloat    , --    
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbGoodsId      Integer;
           vbBranchId     Integer;
           vbContractId   Integer;
           vbPaidKindId   Integer;
           vbPartnerId    Integer;
           vbGoodsKindId  Integer;
           vbId_child     Integer;
           vbOperDate     TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SaleCommerc());

     IF EXISTS (SELECT 1 FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = FALSE)
        AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Данные в документе уже заполнены';
     END IF;

     IF COALESCE (inAmount,0) = 0
     THEN
         RETURN;
     END IF;


     /*-- test
      IF  inAmount > 0
      AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.Test <%> <%> <%> <%> <%> <%> <%> <%> <%> <%> <%> <%>'
                        ,inMovementId            
                        ,inGoodsName         
                        ,inPartnerName            
                        ,inComment_Partner       
                        ,inAmount                
                        ,inInvNumber_Invoice     
                        ,inOKPO                  
                        ,inContractName          
                        ,inComment               
                        ,inOperDate              
                        ,inPaidKindName          
                        ,inBranchName              
                         ;
     END IF;
     */


     -- Поиск
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);


     -- 1 Поиск - Форма оплаты
     vbPaidKindId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PaidKind() AND Object.ValueData ILIKE inPaidKindName AND Object.isErased = FALSE);
     --проверка
     IF COALESCE (vbPaidKindId,0) = 0 AND TRIM (inPaidKindName) <> ''
     THEN
         RAISE EXCEPTION 'Ошибка.Не найдена Форма оплаты <%> для <%> договор <%> .', inPaidKindName, inPartnerName, inContractName;
     END IF;
     

     -- 2 Поиск - Контргагент
     IF COALESCE(inPartnerId,0) = 0
     THEN
         inPartnerId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Partner() AND Object.ValueData ILIKE inPartnerName AND Object.isErased = FALSE);
         --проверка
         IF COALESCE (inPartnerId,0) = 0 AND TRIM (inPartnerName) <> ''
         THEN
             RAISE EXCEPTION 'Ошибка.Не найден контрагент <%> договор <%>.', inPartnerName, inContractName;
         END IF;
     END IF;

     -- 3 Поиск договор
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
     WHERE ObjectLink_Contract_Juridical.ChildObjectId = vbObjectId
       AND ObjectLink_Contract_Juridical.DescId        = zc_ObjectLink_Contract_Juridical()
       AND ObjectLink_Contract_PaidKind.ChildObjectId  = vbPaidKindId
       AND COALESCE (ObjectLink_Contract_ContractStateKind.ChildObjectId, 0) <> zc_Enum_ContractStateKind_Close()
     LIMIT 1;   --

     -- проверка
     IF COALESCE (vbContractId, 0) = 0 AND TRIM (inContractName) <> ''
     THEN
         --
         RAISE EXCEPTION 'Ошибка.Не найден Договор <%> для <%>.', inContractName, inPartnerName;
     END IF;




     -- 4.1. проверка
     IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_Goods() AND TRIM (Object.ValueData) ILIKE TRIM (inGoodsName))
        -- нет кода
        AND zfConvert_StringToNumber (COALESCE (inGoodsCode, '')) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Товар = <%> определен больше 1 раза.', inGoodsName;   --, CHR (13)
     END IF;
     -- 4.2. проверка
     IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = zfConvert_StringToNumber (COALESCE (inGoodsCode, '')))
        -- есть кода
        AND zfConvert_StringToNumber (inGoodsCode) > 0
     THEN
         RAISE EXCEPTION 'Ошибка.Товар Код = <%>  <%> определен больше 1 раза.', zfConvert_StringToNumber (inGoodsCode), inGoodsName;
     END IF;


     IF zfConvert_StringToNumber (inGoodsCode) > 0
     THEN
         -- Товар
         vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = zfConvert_StringToNumber (inGoodsCode));
         -- проверка
         IF COALESCE (vbGoodsId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найден товар Код = <%> <%> для <%> договор <%> .', zfConvert_StringToNumber (inGoodsCode), inGoodsName, inPartnerName, inContractName;
         END IF;

     ELSE
         -- Товар
         vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND TRIM (Object.ValueData) ILIKE TRIM (inGoodsName) AND TRIM (inGoodsName) <> ''
                          );
         -- проверка
         IF COALESCE (vbGoodsId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найден Товар <%> для <%> договора <%> .', inGoodsName, inPartnerName, inContractName;
         END IF;

     END IF;



     -- 5, Филиал
     IF TRIM (COALESCE (inBranchName,'')) <> ''
     THEN
         vbBranchId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Branch() AND TRIM (Object.ValueData) = TRIM (inBranchName) AND Object.isErased = FALSE);
         -- проверка
         IF COALESCE (vbBranchId,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не найден Филиал <%> для <%> договор <%>.', inBranchName, inPartnerName, inContractName;
         END IF;
     END IF;




     -- 1.сохраняем Master, не ошибка - в Master все суммы = 0 + Примечание в чайлд
     SELECT tmp.ioId
            INTO vbId
     FROM gpInsertUpdate_MovementItem_SaleCommerc (ioId           := vbId           ::Integer
                                                 , inMovementId   := inMovementId   ::Integer
                                                 , inContractId   := vbContractId   ::Integer
                                                 , inBranchId     := vbBranchId     ::Integer
                                                 , inPartnerId    := vbPartnerId    ::Integer
                                                 , inPaidKindId   := vbPaidKindId   ::Integer 
                                                 , inSession      := inSession
                                                   ) AS tmp;


     -- 2.сохраняем Child - Первичный план на неделю
     vbId_child := gpInsertUpdate_MovementItem_SaleCommerc_child (ioId             := 0                 ::Integer
                                                                , inParentId       := vbParentId        ::Integer
                                                                , inMovementId     := inMovementId      ::Integer
                                                                --, inParentId       := vbId
                                                                , inGoodsId        := vbGoodsId         ::Integer
                                                                , inGoodsKindId    := vbGoodsKindId     ::Integer
                                                                , inAmount         := inAmount          ::TFloat
                                                                , inSumm           := inSumm            ::TFloat
                                                                , inAmountPromo    := inAmountPromo     ::TFloat
                                                                , inSummPromo      := inSummPromo       ::TFloat
                                                                , inAmountNoPromo  := inAmountNoPromo   ::TFloat
                                                                , inAmountNoPromo  := inAmountNoPromo   ::TFloat
                                                                , inSession        := inSession
                                                                 );
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