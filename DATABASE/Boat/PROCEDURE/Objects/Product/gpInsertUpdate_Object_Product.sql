-- Function: gpInsertUpdate_Object_Product()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, TFloat, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, Boolean, Boolean, TFloat, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean
                                                    , TFloat, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar
                                                    , Integer, TVarChar, TDateTime, Integer, TVarChar, TDateTime, TFloat, TFloat
                                                    , TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean
                                                    , TFloat, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar
                                                    , Integer, TVarChar, TDateTime, Integer, TVarChar, TDateTime, TFloat, TFloat, TFloat
                                                    , TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Product(Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean
                                                    , TFloat, TFloat, TFloat, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar, TVarChar
                                                    , Integer, TVarChar, TDateTime, Integer, TVarChar, TDateTime, TFloat, TFloat
                                                    , TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Product(
 INOUT ioId                    Integer   ,    -- ключ объекта <Лодки>
    IN inCode                  Integer   ,    -- Код объекта
    IN inName                  TVarChar  ,    -- Название объекта
    IN inBrandId               Integer   ,
    IN inModelId               Integer   ,
    IN inEngineId              Integer   ,
    IN inReceiptProdModelId    Integer   ,    --
    IN inClientId              Integer   ,    --
    IN inIsBasicConf           Boolean   ,    -- включать базовую Комплектацию
    IN inIsProdColorPattern    Boolean   ,    -- автоматически добавить все Items Boat Structure
    IN inHours                 TFloat    ,
    IN inDiscountTax           TFloat    ,
    IN inDiscountNextTax       TFloat    ,
    IN inDateStart             TDateTime ,
    IN inDateBegin             TDateTime ,
    IN inDateSale              TDateTime ,
    IN inCIN                   TVarChar  ,
    IN inEngineNum             TVarChar  ,
    IN inComment               TVarChar  ,

    IN inMovementId_OrderClient  Integer,
    IN inInvNumber_OrderClient   TVarChar ,  -- Номер документа
    IN inOperDate_OrderClient    TDateTime,
    IN inNPP_OrderClient         TFloat,

    IN inMovementId_Invoice      Integer,
    IN inInvNumber_Invoice       TVarChar ,  -- Номер документа
    IN inOperDate_Invoice        TDateTime,  --
    IN inAmountIn_Invoice        TFloat   ,  --
    IN inAmountOut_Invoice       TFloat   ,  --

    IN inSession               TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   --DECLARE vbMovementId Integer;
   DECLARE vbAmount TFloat;

   /*DECLARE vbDateStart TDateTime;
   DECLARE vbModelId Integer;
   DECLARE vbModelNom TVarChar;
   */
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Product());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- !!! временно !!!
   -- IF CEIL (inCode / 2) * 2 = inCode THEN inDateSale:= NULL; END IF;
   inDateSale:= NULL;


   -- нельзя менять модель
   IF vbIsInsert = FALSE AND inModelId <> (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = ioId AND OL.DescId = zc_ObjectLink_Product_Model())
      AND EXISTS (SELECT 1 FROM ObjectLink AS ObjectLink_Product
                             JOIN Object AS Object_ProdColorItems ON Object_ProdColorItems.Id       = ObjectLink_Product.ObjectId
                                                                 AND Object_ProdColorItems.isErased = FALSE
                  WHERE ObjectLink_Product.ChildObjectId = ioId
                    AND ObjectLink_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                 )
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Заполнен <Items Boat Structure>.Нельзя менять Model.' :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_Product'    :: TVarChar
                                             , inUserId        := vbUserId
                                              );
   END IF;

   -- проверка - должен быть Код
   IF COALESCE (inCode, 0) = 0 THEN
      RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Должен быть определен <Interne Nr.>' :: TVarChar
                                            , inProcedureName := 'gpInsertUpdate_Object_Product'    :: TVarChar
                                            , inUserId        := vbUserId
                                             );
   END IF;
   -- проверка - должен быть CIN
   IF COALESCE (inCIN, '') = '' AND inMovementId_OrderClient > 0
   THEN
      RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Должен быть определен <CIN Nr.>' :: TVarChar
                                            , inProcedureName := 'gpInsertUpdate_Object_Product'    :: TVarChar
                                            , inUserId        := vbUserId
                                             );
   END IF;
   
   -- Проверка
   IF COALESCE (inClientId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Должен быть определен <Kunden>.' :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_Product'
                                             , inUserId        := vbUserId
                                              );
   END IF;
   

   -- Проверка
   IF COALESCE (inModelId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Должна быть определена <Model>' :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_Product'
                                             , inUserId        := vbUserId
                                              );
   END IF;

   -- Проверка
   IF COALESCE (inReceiptProdModelId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Должен быть определен <Шаблон сборки Модели>' :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_Product'
                                             , inUserId        := vbUserId
                                              );
   END IF;

   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), inCode, vbUserId);
   -- проверка уникальности <CIN Nr.>
   IF LENGTH (inCIN) > 12 THEN PERFORM lpCheckUnique_ObjectString_ValueData (ioId, zc_ObjectString_Product_CIN(), inCIN, vbUserId); END IF;



   -- расчет
   inName:= SUBSTRING (COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inBrandId), ''), 1, 2)
             || ' ' || COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inModelId), '')
             || ' ' || COALESCE ((SELECT Object.ValueData FROM Object WHERE Object.Id = inEngineId), '')
             || ' ' || inCIN
             ;

   -- проверка прав уникальности для свойства <Наименование >
   -- PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Product(), inName, vbUserId);


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Product(), inCode, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Product_BasicConf(), ioId, inIsBasicConf);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Product_Hours(), ioId, inHours);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateStart(), ioId, inDateStart);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateBegin(), ioId, inDateBegin);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Product_DateSale(), ioId, inDateSale);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Product_CIN(), ioId, inCIN);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Product_EngineNum(), ioId, inEngineNum);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Product_Comment(), ioId, inComment);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Product_Brand(), ioId, inBrandId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Product_Model(), ioId, inModelId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Product_Engine(), ioId, inEngineId);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Product_ReceiptProdModel(), ioId, inReceiptProdModelId);



   --- !!! ЗАКАЗ
   -- если документ не создан
   IF COALESCE (inMovementId_OrderClient, 0) = 0 -- OR 1=1
   THEN
       inInvNumber_OrderClient := COALESCE (NULLIF (zfConvert_StringToNumber (inInvNumber_OrderClient), 0), NEXTVAL ('movement_OrderClient_seq')) ::TVarChar;
       -- создаем документ
       inMovementId_OrderClient:= lpInsertUpdate_Movement_OrderClient(ioId                 := inMovementId_OrderClient
                                                                    , inInvNumber          := inInvNumber_OrderClient
                                                                    , inInvNumberPartner   := ''
                                                                    , inOperDate           := COALESCE (inOperDate_OrderClient, CURRENT_DATE)
                                                                    , inPriceWithVAT       := FALSE
                                                                    , inVATPercent         := (SELECT ObjectFloat_TaxKind_Value.ValueData
                                                                                               FROM ObjectLink AS ObjectLink_TaxKind
                                                                                                    LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                                                                                          ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                                                                                                         AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
                                                                                               WHERE ObjectLink_TaxKind.ObjectId = inClientId
                                                                                                 AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Client_TaxKind()
                                                                                              )
                                                                    , inDiscountTax        := inDiscountTax
                                                                    , inDiscountNextTax    := inDiscountNextTax
                                                                  --, inNPP                := inNPP_OrderClient
                                                                    , inFromId             := inClientId
                                                                    , inToId               := zc_Unit_Production()
                                                                    , inPaidKindId         := zc_Enum_PaidKind_FirstForm()
                                                                    , inProductId          := ioId
                                                                    , inMovementId_Invoice := 0
                                                                    , inComment            := ''
                                                                    , inUserId             := vbUserId
                                                                    );
   ELSEIF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId_OrderClient AND Movement.StatusId = zc_Enum_Status_Complete())
   THEN
       -- пересохраняем
       PERFORM lpInsertUpdate_Movement_OrderClient(ioId               := inMovementId_OrderClient  ::Integer
                                                 , inInvNumber        := tmp.InvNumber ::TVarChar
                                                 , inInvNumberPartner := tmp.InvNumberPartner      ::TVarChar
                                                 , inOperDate         := inOperDate_OrderClient    ::TDateTime           --пересохраняем
                                                 , inPriceWithVAT     := tmp.PriceWithVAT          ::Boolean
                                                 , inVATPercent       := tmp.VATPercent            ::TFloat
                                                 , inDiscountTax      := inDiscountTax             ::TFloat              --пересохраняем
                                                 , inDiscountNextTax  := inDiscountNextTax         ::TFloat              --пересохраняем
                                               --, inNPP              := inNPP_OrderClient
                                                 , inFromId           := inClientId                ::Integer             --пересохраняем
                                                 , inToId             := tmp.ToId                  ::Integer
                                                 , inPaidKindId       := tmp.PaidKindId            ::Integer
                                                 , inProductId        := ioId                      ::Integer
                                                 , inMovementId_Invoice := tmp.MovementId_Invoice  ::Integer  --пересохраняем
                                                 , inComment          := tmp.Comment               ::TVarChar
                                                 , inUserId           := vbUserId     ::Integer
                                                  )
       FROM gpGet_Movement_OrderClient (inMovementId_OrderClient, inOperDate_OrderClient, inSession) AS tmp;
   END IF;


   -- только при создании
   IF inIsProdColorPattern = TRUE AND (vbIsInsert = TRUE OR EXISTS (SELECT 1
                                                                    FROM gpSelect_Object_ProdColorItems (inMovementId_OrderClient := inMovementId_OrderClient, inIsShowAll:= TRUE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS tmp
                                                                    WHERE tmp.ProductId = ioId
                                                                      AND COALESCE (tmp.Id, 0) = 0
                                                                   )
                                                       --OR 1=1
                                      )

                                                                       /*(SELECT 1
                                                                        FROM ObjectLink AS ObjectLink_Product
                                                                             INNER JOIN Object AS Object_ProdColorItems
                                                                                               ON Object_ProdColorItems.Id       = ObjectLink_Product.ObjectId
                                                                                              AND Object_ProdColorItems.isErased = FALSE
                                                                        WHERE ObjectLink_Product.ChildObjectId = ioId
                                                                          AND ObjectLink_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                                                                       ))*/
   THEN
       -- добавить все Items Boat Structure
       PERFORM gpInsertUpdate_Object_ProdColorItems (ioId                     := tmp.Id
                                                   , inCode                   := 0
                                                   , inProductId              := ioId
                                                   , inGoodsId                := tmp.GoodsId
                                                   , inProdColorPatternId     := tmp.ProdColorPatternId
                                                   , inMaterialOptionsId      := tmp.MaterialOptionsId
                                                   , inMovementId_OrderClient := inMovementId_OrderClient
                                                   , inComment                := tmp.Comment
                                                   , inIsEnabled              := TRUE
                                                   , ioIsProdOptions          := FALSE
                                                   , inSession                := inSession
                                                    )
       FROM gpSelect_Object_ProdColorItems (inMovementId_OrderClient:= inMovementId_OrderClient, inIsShowAll:= TRUE, inIsErased:= FALSE, inIsSale:= FALSE, inSession:= inSession) AS tmp
       WHERE tmp.ProductId = ioId
         AND tmp.ReceiptProdModelId = inReceiptProdModelId
         AND COALESCE (tmp.Id, 0) = 0
        ;

   END IF;



   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);



   --- !!! СЧЕТ
    --проверка, если заказ проведен сумму и дату счета уже менять нельзя
    IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId_OrderClient AND Movement.StatusId = zc_Enum_Status_Complete())
    THEN
        RETURN;
    END IF;

     -- !!!
     IF inAmountIn_Invoice <> 0 THEN
        vbAmount := inAmountIn_Invoice;
     ELSE
        vbAmount := -1 * inAmountOut_Invoice;
     END IF;

    -- Распроводим Документ
    IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId_Invoice AND Movement.StatusId = zc_Enum_Status_Complete())
    THEN
        PERFORM lpUnComplete_Movement (inMovementId := inMovementId_Invoice
                                     , inUserId     := vbUserId);
    END IF;

    IF COALESCE (inMovementId_Invoice) = 0 AND COALESCE (vbAmount,0) <> 0  -- создаем новый документ только если сумма не 0
    THEN
        -- сохранили <Документ>
        inInvNumber_Invoice := NEXTVAL ('movement_Invoice_seq')    :: TVarChar;
        inMovementId_Invoice := lpInsertUpdate_Movement_Invoice (ioId               := 0                                   ::Integer
                                                               , inParentId         := inMovementId_OrderClient
                                                               , inInvNumber        := inInvNumber_Invoice                 :: TVarChar
                                                               , inOperDate         := inOperDate_Invoice
                                                               , inPlanDate         := Null                                ::TDateTime
                                                               , inVATPercent       := ObjectFloat_TaxKind_Value.ValueData ::TFloat
                                                               , inAmount           := vbAmount                            ::TFloat
                                                               , inInvNumberPartner := ''                                  ::TVarChar
                                                               , inReceiptNumber    := ''                                  ::TVarChar
                                                               , inComment          := ''                                  ::TVarChar
                                                               , inObjectId         := inClientId
                                                               , inUnitId           := Null                                ::Integer
                                                               , inInfoMoneyId      := ObjectLink_InfoMoney.ChildObjectId  ::Integer
                                                               , inPaidKindId       := zc_Enum_PaidKind_FirstForm()        ::Integer
                                                               , inUserId           := vbUserId
                                                               )
        FROM Object AS Object_Client
             LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                  ON ObjectLink_TaxKind.ObjectId = Object_Client.Id
                                 AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Client_TaxKind()

             LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                   ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_TaxKind.ChildObjectId
                                  AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

             LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                  ON ObjectLink_InfoMoney.ObjectId = Object_Client.Id
                                 AND ObjectLink_InfoMoney.DescId = zc_ObjectLink_Client_InfoMoney()

        WHERE Object_Client.Id = inClientId;
        -- сохранили ParentId
        --PERFORM lpInsertUpdate_Movement (inMovementId_Invoice, zc_Movement_Invoice(), inInvNumber_Invoice, inOperDate_Invoice, inMovementId_OrderClient, vbUserId);

    ELSEIF inMovementId_Invoice > 0
    THEN
        -- пересохранили дату документа
        PERFORM lpInsertUpdate_Movement (inMovementId_Invoice, zc_Movement_Invoice()
                                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId_Invoice)
                                       , (SELECT Movement.OperDate  FROM Movement WHERE Movement.Id = inMovementId_Invoice)
                                       , inMovementId_OrderClient
                                       , vbUserId
                                        );
        --сохранили сумму
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), inMovementId_Invoice, vbAmount);

    END IF;

     -- 5.3. проводим Документ
     IF vbUserId = lpCheckRight (inSession, zc_Enum_Process_Complete_Invoice()) AND inMovementId_Invoice > 0
     THEN
          PERFORM lpComplete_Movement_Invoice (inMovementId := inMovementId_Invoice
                                             , inUserId     := vbUserId);
     END IF;

     -- сохранили связь документа <Заказ> с документом <Счет>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Invoice(), inMovementId_OrderClient, inMovementId_Invoice);


     -- Проверка - Boat Structure
     IF EXISTS (SELECT ObjectLink_ProdColorPattern.ChildObjectId
                FROM Object AS Object_ProdColorItems
                     -- Лодка
                     INNER JOIN ObjectLink AS ObjectLink_Product
                                           ON ObjectLink_Product.ObjectId      = Object_ProdColorItems.Id
                                          AND ObjectLink_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                                          AND ObjectLink_Product.ChildObjectId = ioId
                     -- Заказ Клиента
                     INNER JOIN ObjectFloat AS ObjectFloat_MovementId_OrderClient
                                            ON ObjectFloat_MovementId_OrderClient.ObjectId  = Object_ProdColorItems.Id
                                           AND ObjectFloat_MovementId_OrderClient.DescId    = zc_ObjectFloat_ProdColorItems_OrderClient()
                                           AND ObjectFloat_MovementId_OrderClient.ValueData = inMovementId_OrderClient
                     -- Элемент
                     INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                           ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                                          AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                WHERE Object_ProdColorItems.DescId   = zc_Object_ProdColorItems()
                  AND Object_ProdColorItems.isErased = FALSE
                  AND ObjectLink_ProdColorPattern.ChildObjectId > 0
                GROUP BY ObjectLink_ProdColorPattern.ChildObjectId
                HAVING COUNT(*) > 1
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Элемент Boat Structure = <%> не может дублироваться.'
             , (SELECT lfGet_Object_ValueData_pcp (ObjectLink_ProdColorPattern.ChildObjectId)
                FROM Object AS Object_ProdColorItems
                     -- Лодка
                     INNER JOIN ObjectLink AS ObjectLink_Product
                                           ON ObjectLink_Product.ObjectId      = Object_ProdColorItems.Id
                                          AND ObjectLink_Product.DescId        = zc_ObjectLink_ProdColorItems_Product()
                                          AND ObjectLink_Product.ChildObjectId = ioId
                     -- Заказ Клиента
                     INNER JOIN ObjectFloat AS ObjectFloat_MovementId_OrderClient
                                            ON ObjectFloat_MovementId_OrderClient.ObjectId  = Object_ProdColorItems.Id
                                           AND ObjectFloat_MovementId_OrderClient.DescId    = zc_ObjectFloat_ProdColorItems_OrderClient()
                                           AND ObjectFloat_MovementId_OrderClient.ValueData = inMovementId_OrderClient
                     -- Элемент
                     INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                           ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                                          AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                WHERE Object_ProdColorItems.DescId   = zc_Object_ProdColorItems()
                  AND Object_ProdColorItems.isErased = FALSE
                  AND ObjectLink_ProdColorPattern.ChildObjectId > 0
                GROUP BY ObjectLink_ProdColorPattern.ChildObjectId
                HAVING COUNT(*) > 1
               )
               ;
               
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.03.21         *
 24.02.21         *
 11.01.21         *
 04.01.21         *
 09.10.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Product()
