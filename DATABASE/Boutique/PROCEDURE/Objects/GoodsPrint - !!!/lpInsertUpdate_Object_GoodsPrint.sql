-- Function: lpInsertUpdate_Object_GoodsPrint (Integer, Integer, Integer, Integer, TFloat, Boolean, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsPrint (Integer, Integer, Integer, Integer, TFloat, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_GoodsPrint(
 INOUT ioOrd               Integer,      -- № п/п сессии GoodsPrint
 INOUT ioUserId            Integer,      -- Пользователь сессии GoodsPrint
    IN inUnitId            Integer,      --
    IN inPartionId         Integer,      --
    IN inAmount            TFloat,       --
    IN inIsReprice         Boolean,      --
   OUT outGoodsPrintName   TVarChar,     --
   OUT outUserName         TVarChar,     -- 
    IN inUserId            Integer       -- пользователь
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbInsertDate  TDateTime;
BEGIN
   -- проверка
   IF COALESCE (inPartionId, 0) = 0
   THEN
        RAISE EXCEPTION 'Ошибка.Не определено значение <Партия>.';
   END IF;


   -- !!!СНАЧАЛА удаляем данные ВСЕХ Пользователей БОЛЬШЕ чем за 7 дней!!!
   DELETE FROM Object_GoodsPrint WHERE InsertDate < CURRENT_DATE - INTERVAL '7 DAY';


   -- Для Пустой сессии + ПЕРЕОЦЕНКА
   IF COALESCE (ioOrd, 0) = 0 AND inIsReprice = TRUE
   THEN
       -- находим сессию "за сегодня" + ПЕРЕОЦЕНКА
       vbInsertDate:= COALESCE ((SELECT tmp.InsertDate
                                 FROM gpSelect_Object_GoodsPrint_Choice (inUserId, inUserId :: TVarChar) AS tmp
                                 WHERE tmp.InsertDate >= CURRENT_DATE -- !!!"за сегодня"!!!
                                   AND tmp.isReprice  = inIsReprice
                                 ORDER BY tmp.InsertDate DESC
                                 LIMIT 1)
                              , CURRENT_TIMESTAMP);

       -- Меняем на текущего пользователя
       ioUserId := inUserId;

   -- Для Пустой сессии
   ELSEIF COALESCE (ioOrd, 0) = 0
   THEN
       -- Создаем с текущей Дата/время
       vbInsertDate := CURRENT_TIMESTAMP;
       -- Создаем для текущего пользователя
       ioUserId := inUserId;
       -- еще раз уточнили - НЕ переоценка
       inIsReprice:= FALSE;

   ELSE
       -- иначе находим сессию, куда добавим товар + ЗАМЕНА isReprice
       SELECT tmp.InsertDate, tmp.isReprice
              INTO vbInsertDate, inIsReprice
       FROM gpSelect_Object_GoodsPrint_Choice (ioUserId, inUserId :: TVarChar) AS tmp
       WHERE tmp.Ord = ioOrd -- !!!выбрали только нужную!!!
       ;
       -- Проверка - т.к. старые сессии удаляются через 7 дней, нельзя с ними работать
       IF vbInsertDate <= CURRENT_DATE - INTERVAL '5 DAY'
       THEN
           RAISE EXCEPTION 'Ошибка.Нельзя добавлять товары в печать ценников за <%>.Можно выбрать другую с датой больше <%>'
                         , zfConvert_DateTimeToString (vbInsertDate)
                         , zfConvert_DateToString (CURRENT_DATE - INTERVAL '5 DAY');
       END IF;
       
   END IF;


   -- изменили элемент
   UPDATE Object_GoodsPrint SET Amount = inAmount
   WHERE Object_GoodsPrint.InsertDate = vbInsertDate
     AND Object_GoodsPrint.UserId     = ioUserId
     AND Object_GoodsPrint.PartionId  = inPartionId
     AND Object_GoodsPrint.UnitId     = inUnitId
     AND Object_GoodsPrint.isReprice  = inIsReprice
   ;

   -- если такой элемент не был найден
   IF NOT FOUND
   THEN
       -- добавили новый элемент
       INSERT INTO Object_GoodsPrint (PartionId, UnitId, UserId, Amount, InsertDate, isReprice)
                              VALUES (inPartionId, inUnitId, ioUserId, inAmount, vbInsertDate, inIsReprice);
   END IF; -- if NOT FOUND


   -- Результат - Определяем № п/п сессии + Название
   SELECT tmp.Ord, tmp.UserName, tmp.Name
          INTO ioOrd, outUserName, outGoodsPrintName
   FROM gpSelect_Object_GoodsPrint_Choice (ioUserId, inUserId :: TVarChar) AS tmp
   WHERE tmp.InsertDate = vbInsertDate
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
 06.03.18                                        *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Object_GoodsPrint (ioOrd:= 0, ioUserId:= 0, inUnitId:= 4198, inPartionId:= 0, inAmount:= 5, inIsReprice:= FALSE, inUserId := zfCalc_UserAdmin() :: Integer);
