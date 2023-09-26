-- Function: lpInsertFind_Object_PartionGoods - InvNumber - ОС: МНМА + ...

-- DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (Integer, Integer, Integer, Integer, TVarChar, TVarChar, TDateTime, TFloat);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inUnitId_Partion Integer   , -- *Подразделение(для цены)
    IN inGoodsId        Integer   , -- *Товар
    IN inStorageId      Integer   , -- *Место хранения
    IN inPartionModelId Integer   , -- Модель
    IN inInvNumber      TVarChar  , -- *Инвентарный номер
    IN inPartNumber     TVarChar  , -- *Серийный номер(№ по тех паспорту)
    IN inOperDate       TDateTime , -- *Дата перемещения
    IN inPrice          TFloat      -- Цена
)
  RETURNS Integer AS
$BODY$
   DECLARE vbPartionGoodsId Integer;

   DECLARE vbHost      TVarChar;
   DECLARE vbDBName    TVarChar;
   DECLARE vbPort      Integer;
   DECLARE vbUserName  TVarChar;
   DECLARE vbPassword  TVarChar;
BEGIN
     -- в этом случае партия не нужна
   /*IF inOperDate < '01.05.2017' OR (COALESCE (inUnitId_Partion, 0) = 0 AND COALESCE (inGoodsId, 0) = 0)
     THEN
         -- RETURN (80132); -- !!!Пустая партия!!!
         RETURN (0);
     END IF;*/


     -- RAISE EXCEPTION 'Ошибка.Учет не организован.';

     -- проверка
     /*IF COALESCE (TRIM (inInvNumber), '') = ''
     THEN
         RAISE EXCEPTION 'Ошибка.В партии Не определен <Инвентарный номер>.';
     END IF;*/
     -- проверка
     IF COALESCE (TRIM (inInvNumber), '') = '' AND COALESCE (TRIM (inPartNumber), '') = '' 
     THEN
         RAISE EXCEPTION 'Ошибка.В партии Не определены <Инвентарный номер> или <Серийный номер>.Должно быть введено хотя бы одно значение.';
     END IF;

     -- проверка
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В партии Не определен <Товар>.';
     END IF;
     -- проверка
     IF COALESCE (inStorageId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.В партии Не определено <Место хранения>.';
     END IF;

     -- проверка - пока нет
     IF COALESCE (inUnitId_Partion, 0) = 0 AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.В партии Не определено <Подразделеление>.';
     END IF;
     -- проверка - пока такая
     IF (inOperDate IS NULL OR inOperDate IN (zc_DateStart(), zc_DateEnd())) AND inUnitId_Partion > 0
     THEN
         RAISE EXCEPTION 'Ошибка.В партии для <%> Не определена <Дата перемещения>.', lfGet_Object_ValueData (inGoodsId);
     END IF;

     -- меняем параметр
     IF COALESCE (TRIM (inInvNumber), '') = ''
     THEN
         inInvNumber:= '0';
     END IF;


     -- меняем параметр - !!!ВРЕМЕННО будет 1 партия в Месяц - последним днем!!!
     inOperDate:= DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';


     IF COALESCE (inStorageId, 0) = 0
     THEN
         -- если есть Инвентарный номер
         IF inInvNumber <> '0'
         THEN
             -- Находим по св-вам: Товар + Дата перемещения + Инвентарный номер + Место учета + Место хранения=NULL
             vbPartionGoodsId:= (SELECT ObjectLink_Goods.ObjectId
                                 FROM ObjectLink AS ObjectLink_Goods
                                      INNER JOIN ObjectDate ON ObjectDate.ObjectId  = ObjectLink_Goods.ObjectId
                                                           AND ObjectDate.DescId    = zc_ObjectDate_PartionGoods_Value()
                                                           AND ObjectDate.ValueData = inOperDate
                                      -- по Инвентарный номер
                                      INNER JOIN Object ON Object.Id        = ObjectLink_Goods.ObjectId
                                                       AND Object.ValueData = inInvNumber
                                      INNER JOIN ObjectLink AS ObjectLink_Unit
                                                            ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                           AND ObjectLink_Unit.DescId        = zc_ObjectLink_PartionGoods_Unit()
                                                           AND ObjectLink_Unit.ChildObjectId = inUnitId_Partion
                                      INNER JOIN ObjectLink AS ObjectLink_Storage
                                                            ON ObjectLink_Storage.ObjectId      = ObjectLink_Goods.ObjectId
                                                           AND ObjectLink_Storage.DescId        = zc_ObjectLink_PartionGoods_Storage()
                                                           AND ObjectLink_Storage.ChildObjectId IS NULL
                                 WHERE ObjectLink_Goods.ChildObjectId = inGoodsId
                                   AND ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                );

         ELSE
             -- Находим по св-вам: Товар + Дата перемещения + Серийный номер + Место учета + Место хранения=NULL
             vbPartionGoodsId:= (SELECT ObjectLink_Goods.ObjectId
                                 FROM ObjectLink AS ObjectLink_Goods
                                      -- по Серийный номер(№ по тех паспорту)
                                      INNER JOIN ObjectString ON ObjectString.ObjectId  = ObjectLink_Goods.ObjectId
                                                             AND ObjectString.DescId    = zc_ObjectString_PartionGoods_PartNumber()
                                                             AND ObjectString.ValueData = inPartNumber
                                      INNER JOIN ObjectDate ON ObjectDate.ObjectId  = ObjectLink_Goods.ObjectId
                                                           AND ObjectDate.DescId    = zc_ObjectDate_PartionGoods_Value()
                                                           AND ObjectDate.ValueData = inOperDate
                                      -- Инвентарный номер
                                      INNER JOIN Object ON Object.Id        = ObjectLink_Goods.ObjectId
                                                       -- без проверки Инвентарный номер
                                                       -- AND Object.ValueData = inInvNumber
                                      INNER JOIN ObjectLink AS ObjectLink_Unit
                                                            ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                           AND ObjectLink_Unit.DescId        = zc_ObjectLink_PartionGoods_Unit()
                                                           AND ObjectLink_Unit.ChildObjectId = inUnitId_Partion
                                      INNER JOIN ObjectLink AS ObjectLink_Storage
                                                            ON ObjectLink_Storage.ObjectId      = ObjectLink_Goods.ObjectId
                                                           AND ObjectLink_Storage.DescId        = zc_ObjectLink_PartionGoods_Storage()
                                                           AND ObjectLink_Storage.ChildObjectId IS NULL
                                 WHERE ObjectLink_Goods.ChildObjectId = inGoodsId
                                   AND ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                );
         END IF;

     ELSE
         -- если есть Инвентарный номер
         IF inInvNumber <> '0'
         THEN
             -- Находим по св-вам: Товар + Дата перемещения + Инвентарный номер + Место учета + Место хранения
             vbPartionGoodsId:= (SELECT ObjectLink_Goods.ObjectId
                                 FROM ObjectLink AS ObjectLink_Goods
                                      INNER JOIN ObjectDate ON ObjectDate.ObjectId  = ObjectLink_Goods.ObjectId
                                                           AND ObjectDate.DescId    = zc_ObjectDate_PartionGoods_Value()
                                                         --AND ObjectDate.ValueData = inOperDate
                                      -- по Инвентарный номер
                                      INNER JOIN Object ON Object.Id        = ObjectLink_Goods.ObjectId
                                                       AND Object.ValueData = inInvNumber
                                      INNER JOIN ObjectLink AS ObjectLink_Unit
                                                            ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                           AND ObjectLink_Unit.DescId        = zc_ObjectLink_PartionGoods_Unit()
                                                         --AND ObjectLink_Unit.ChildObjectId = inUnitId_Partion
                                      INNER JOIN ObjectLink AS ObjectLink_Storage
                                                            ON ObjectLink_Storage.ObjectId      = ObjectLink_Goods.ObjectId
                                                           AND ObjectLink_Storage.DescId        = zc_ObjectLink_PartionGoods_Storage()
                                                           AND ObjectLink_Storage.ChildObjectId = inStorageId
                                 WHERE ObjectLink_Goods.ChildObjectId = inGoodsId
                                   AND ObjectLink_Goods.DescId = zc_ObjectLink_PartionGoods_Goods()
                                   AND (ObjectLink_Unit.ChildObjectId = inUnitId_Partion OR (COALESCE (inUnitId_Partion, 0) = 0 AND ObjectLink_Unit.ChildObjectId IS NULL))
                                   AND (ObjectDate.ValueData          = inOperDate       OR (COALESCE (inUnitId_Partion, 0) = 0 AND ObjectDate.ValueData IS NULL))
                                );
         ELSE
             -- Находим по св-вам: Товар + Дата перемещения + Серийный номер + Место учета + Место хранения
             vbPartionGoodsId:= (SELECT ObjectLink_Goods.ObjectId
                                 FROM ObjectLink AS ObjectLink_Goods
                                      -- по Серийный номер(№ по тех паспорту)
                                      INNER JOIN ObjectString ON ObjectString.ObjectId  = ObjectLink_Goods.ObjectId
                                                             AND ObjectString.DescId    = zc_ObjectString_PartionGoods_PartNumber()
                                                             AND ObjectString.ValueData = inPartNumber
                                      INNER JOIN ObjectDate ON ObjectDate.ObjectId  = ObjectLink_Goods.ObjectId
                                                           AND ObjectDate.DescId    = zc_ObjectDate_PartionGoods_Value()
                                                         --AND ObjectDate.ValueData = inOperDate
                                      -- Инвентарный номер
                                      INNER JOIN Object ON Object.Id        = ObjectLink_Goods.ObjectId
                                                       -- без проверки Инвентарный номер
                                                       -- AND Object.ValueData = inInvNumber
                                      INNER JOIN ObjectLink AS ObjectLink_Unit
                                                            ON ObjectLink_Unit.ObjectId      = ObjectLink_Goods.ObjectId
                                                           AND ObjectLink_Unit.DescId        = zc_ObjectLink_PartionGoods_Unit()
                                                         --AND ObjectLink_Unit.ChildObjectId = inUnitId_Partion
                                      INNER JOIN ObjectLink AS ObjectLink_Storage
                                                            ON ObjectLink_Storage.ObjectId      = ObjectLink_Goods.ObjectId
                                                           AND ObjectLink_Storage.DescId        = zc_ObjectLink_PartionGoods_Storage()
                                                           AND ObjectLink_Storage.ChildObjectId = inStorageId
                                 WHERE ObjectLink_Goods.ChildObjectId = inGoodsId
                                   AND ObjectLink_Goods.DescId        = zc_ObjectLink_PartionGoods_Goods()
                                   AND (ObjectLink_Unit.ChildObjectId = inUnitId_Partion OR (COALESCE (inUnitId_Partion, 0) = 0 AND ObjectLink_Unit.ChildObjectId IS NULL))
                                   AND (ObjectDate.ValueData          = inOperDate       OR (COALESCE (inUnitId_Partion, 0) = 0 AND ObjectDate.ValueData IS NULL))
                                );
         END IF;
     END IF;

     -- Если не нашли
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN

         -- Если роль перепроводка то создаем на основном сервере если нет то ругнемся т.к. нельзя
         IF _replica.zc_isUserRewiring() = TRUE
         THEN
           -- Ищем на основном сервере
           SELECT Host, DBName, Port, UserName, Password
           INTO vbHost, vbDBName, vbPort, vbUserName, vbPassword
           FROM _replica.gpSelect_MasterConnectParams(zfCalc_UserAdmin());  

           SELECT Q.Id
           INTO vbPartionGoodsId
           FROM dblink('host='||vbHost||' dbname='||vbDBName||' port='||vbPort::Text||' user='||vbUserName||' password='||vbPassword,
                       'SELECT lpInsertFind_Object_PartionGoods ('||
                       '  inUnitId_Partion   := '||CASE WHEN NULLIF(inUnitId_Partion, 0) IS NULL THEN 'NULL' ELSE inUnitId_Partion::TEXT END||
                       ', inGoodsId   := '||CASE WHEN NULLIF(inGoodsId, 0) IS NULL THEN 'NULL' ELSE inGoodsId::TEXT END||
                       ', inStorageId   := '||CASE WHEN NULLIF(inStorageId, 0) IS NULL THEN 'NULL' ELSE inStorageId::TEXT END||
                       ', inPartionModelId   := '||CASE WHEN NULLIF(inPartionModelId, 0) IS NULL THEN 'NULL' ELSE inPartionModelId::TEXT END||
                       ', inInvNumber  := '||CASE WHEN inInvNumber IS NULL THEN 'NULL' ELSE ''''||inInvNumber::TEXT||'''' END||
                       ', inPartNumber  := '||CASE WHEN inPartNumber IS NULL THEN 'NULL' ELSE ''''||inPartNumber::TEXT||'''' END||
                       ', inOperDate  := '||CASE WHEN inOperDate IS NULL THEN 'NULL' ELSE ''''||zfConvert_DateToString(inOperDate)::TEXT||'''' END||
                       ', inPrice   := '||CASE WHEN NULLIF(inPrice, 0) IS NULL THEN 'NULL' ELSE inPrice::TEXT END||
                       ') AS ID') AS 
                         q(Id Integer);  

           IF COALESCE (vbPartionGoodsId, 0) = 0
           THEN
             RAISE EXCEPTION 'Ошибка получение партии с основного сервера';
           END IF;
             
         END IF;

         -- сохранили <Инвентарный номер>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, inInvNumber);

         -- сохранили <Подразделения(для цены)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Unit(), vbPartionGoodsId, CASE WHEN inUnitId_Partion > 0 THEN inUnitId_Partion ELSE NULL END);
         -- сохранили <Товар>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Goods(), vbPartionGoodsId, inGoodsId);
         -- сохранили <Место хранения>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Storage(), vbPartionGoodsId, CASE WHEN inStorageId > 0 THEN inStorageId ELSE NULL END);

         -- сохранили <Серийный номер(№ по тех паспорту)>
         PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_PartionGoods_PartNumber(), vbPartionGoodsId
                                            , CASE WHEN TRIM (inPartNumber) <> ''
                                                        THEN TRIM (inPartNumber)
                                                   ELSE COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.ObjectId = vbPartionGoodsId AND OS.DescId = zc_ObjectString_PartionGoods_PartNumber()), '')
                                              END
                                            );
         -- сохранили <Модель (Партия учета)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_PartionModel(), vbPartionGoodsId, inPartionModelId);

         -- сохранили <Дата перемещения>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PartionGoods_Value(), vbPartionGoodsId, CASE WHEN inUnitId_Partion > 0 THEN inOperDate ELSE NULL END);
         -- сохранили <Цена>
         PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionGoods_Price(), vbPartionGoodsId, COALESCE (inPrice, 0));

     ELSEIF TRIM (inPartNumber) <> ''
     THEN
         -- сохранили <Серийный номер(№ по тех паспорту)>
         PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_PartionGoods_PartNumber(), vbPartionGoodsId, TRIM (inPartNumber));
     
         -- сохранили <Модель (Партия учета)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_PartionModel(), vbPartionGoodsId, inPartionModelId);

     ELSEIF inPartionModelId > 0
     THEN
         -- сохранили <Модель (Партия учета)>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_PartionModel(), vbPartionGoodsId, inPartionModelId);

     END IF;

     -- Возвращаем значение
     RETURN (vbPartionGoodsId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.07.14                                        *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionGoods ();