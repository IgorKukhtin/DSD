-- Function: lpInsertUpdate_Movement_PromoTrade()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PromoTrade (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_PromoTrade(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа  
    IN inContractId            Integer    , -- договор  
    IN inPromoItemId           Integer    , -- Статья затрат
    IN inPromoKindId           Integer    , -- Вид акции
    IN inStartPromo            TDateTime  , -- Дата начала акции
    IN inEndPromo              TDateTime  , -- Дата окончания акции
    IN inCostPromo             TFloat     , -- Стоимость участия в акции
    IN inComment               TVarChar   , -- Примечание
    IN inUserId                Integer      -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка
    IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
    THEN
        RAISE EXCEPTION 'Ошибка.Неверный формат даты документа <%>.', inOperDate;
    END IF;
       
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PromoTrade(), inInvNumber, inOperDate, NULL, 0);
   
    -- 
    IF ioId <=0 -- OR inUserId = 5
    THEN
        RAISE EXCEPTION 'Ошибка.Ключ <%> <= 0. <%> № <%> от <%>.'
                      , ioId
                      , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_PromoTrade())
                      , inInvNumber
                      , zfConvert_DateToString (inOperDate)
                       ;
    END IF;
 
    -- сохранили связь с <договор>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
  
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, OL_PriceList.ChildObjectId)
          , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalTrade(), ioId, OL_PersonalTrade.ChildObjectId)
          , lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, tmpCC.ChangePercent)
    FROM Object AS tmp                     
         LEFT JOIN tmpContractCondition_Value AS tmpCC ON tmpCC.ContractId = tmp.Id  
         LEFT JOIN ObjectLink AS OL_PersonalTrade
                              ON OL_PersonalTrade.ObjectId = Object_Contract_View.ContractId 
                             AND OL_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade() 
         LEFT JOIN ObjectLink AS OL_PriceList
                              ON OL_PriceList.ObjectId = Object_Contract_View.ContractId
                             AND OL_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
    WHERE tmp.Id = inContractId
      AND tmp.DescId = zc_Object_ContractId;
   
    -- Вид акции
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoKind(), ioId, inPromoKindId);
    -- статья затрат
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoItem(), ioId, inPromoItemId);

    -- Дата начала акции
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartPromo(), ioId, inStartPromo);
    -- Дата окончания акции
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndPromo(), ioId, inEndPromo); 
    
    -- Дата начала расч. продаж до акции
    --PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, inOperDateStart);
    -- Дата окончания расч. продаж до акции
    --PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, inOperDateEnd);
    
    --Стоимость участия в акции
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CostPromo(), ioId, inCostPromo)

     -- Примечание
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

        
     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <Дата создания> - при загрузке с моб устр., здесь дата загрузки
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили связь с <Пользователь>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     END IF;

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.08.24         *
*/