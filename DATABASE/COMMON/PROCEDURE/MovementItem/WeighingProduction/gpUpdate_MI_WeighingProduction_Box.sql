-- Function: gpUpdate_MI_WeighingProduction_Box()

DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingProduction_Box (Integer, Integer, Integer,Integer, Integer, Integer,Integer, Integer, Integer, Integer, Integer
                                                          , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_WeighingProduction_Box(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inBoxId_1             Integer   , -- Тара
    IN inBoxId_2             Integer   , -- 
    IN inBoxId_3             Integer   , --
    IN inBoxId_4             Integer   , --
    IN inBoxId_5             Integer   , --
    IN inBoxId_6             Integer   , --
    IN inBoxId_7             Integer   , --
    IN inBoxId_8             Integer   , --
    IN inBoxId_9             Integer   , --
    IN inBoxId_10            Integer   , --
    IN inCountTare1          TFloat    , -- Количество
    IN inCountTare2          TFloat    , -- Количество
    IN inCountTare3          TFloat    , -- Количество
    IN inCountTare4          TFloat    , -- Количество
    IN inCountTare5          TFloat    , -- Количество
    IN inCountTare6          TFloat    , -- Количество
    IN inCountTare7          TFloat    , -- Количество
    IN inCountTare8          TFloat    , -- Количество
    IN inCountTare9          TFloat    , -- Количество
    IN inCountTare10         TFloat    , -- Количество
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_WeighingProduction_Box());
    -- vbUserId:= lpGetUserBySession (inSession);

     -- проверка
     IF COALESCE (inId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Строка не сохранена';
     END IF;

     --можно заполнить 5 параметров
     IF (CASE WHEN COALESCE (inCountTare1,0) = 0 THEN 0 ELSE 1 END
       + CASE WHEN COALESCE (inCountTare2,0) = 0 THEN 0 ELSE 1 END
       + CASE WHEN COALESCE (inCountTare3,0) = 0 THEN 0 ELSE 1 END
       + CASE WHEN COALESCE (inCountTare4,0) = 0 THEN 0 ELSE 1 END
       + CASE WHEN COALESCE (inCountTare5,0) = 0 THEN 0 ELSE 1 END
       + CASE WHEN COALESCE (inCountTare6,0) = 0 THEN 0 ELSE 1 END
       + CASE WHEN COALESCE (inCountTare7,0) = 0 THEN 0 ELSE 1 END
       + CASE WHEN COALESCE (inCountTare8,0) = 0 THEN 0 ELSE 1 END
       + CASE WHEN COALESCE (inCountTare9,0) = 0 THEN 0 ELSE 1 END
       + CASE WHEN COALESCE (inCountTare10,0) = 0 THEN 0 ELSE 1 END) > 5
     THEN
         RAISE EXCEPTION 'Ошибка.Заполнено более 5 значений';
     END IF;

     PERFORM CASE WHEN tmp.Ord = 1 THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box1(), inId, tmp.BoxId)
                  WHEN tmp.Ord = 2 THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box2(), inId, tmp.BoxId)
                  WHEN tmp.Ord = 3 THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box3(), inId, tmp.BoxId)
                  WHEN tmp.Ord = 4 THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box4(), inId, tmp.BoxId)
                  WHEN tmp.Ord = 5 THEN lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box5(), inId, tmp.BoxId)
             END
           , CASE WHEN tmp.Ord = 1 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare1(), inId, tmp.CountTare ::TFloat)
                  WHEN tmp.Ord = 2 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare2(), inId, tmp.CountTare ::TFloat)
                  WHEN tmp.Ord = 3 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare3(), inId, tmp.CountTare ::TFloat)
                  WHEN tmp.Ord = 4 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare4(), inId, tmp.CountTare ::TFloat)
                  WHEN tmp.Ord = 5 THEN lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountTare5(), inId, tmp.CountTare ::TFloat)
             END  
                  
     FROM (WITH
           tmpParamAll AS (SELECT inBoxId_1 AS BoxId, COALESCE (inCountTare1,0) AS CountTare, 1 AS npp 
                 UNION ALL SELECT inBoxId_2 AS BoxId, COALESCE (inCountTare2,0) AS CountTare, 2 AS npp
                 UNION ALL SELECT inBoxId_3 AS BoxId, COALESCE (inCountTare3,0) AS CountTare, 3 AS npp
                 UNION ALL SELECT inBoxId_4 AS BoxId, COALESCE (inCountTare4,0) AS CountTare, 4 AS npp
                 UNION ALL SELECT inBoxId_5 AS BoxId, COALESCE (inCountTare5,0) AS CountTare, 5 AS npp
                 UNION ALL SELECT inBoxId_6 AS BoxId, COALESCE (inCountTare6,0) AS CountTare, 6 AS npp
                 UNION ALL SELECT inBoxId_7 AS BoxId, COALESCE (inCountTare7,0) AS CountTare, 7 AS npp
                 UNION ALL SELECT inBoxId_8 AS BoxId, COALESCE (inCountTare8,0) AS CountTare, 8 AS npp
                 UNION ALL SELECT inBoxId_9 AS BoxId, COALESCE (inCountTare9,0) AS CountTare, 9 AS npp
                 UNION ALL SELECT inBoxId_10 AS BoxId, COALESCE (inCountTare10,0) AS CountTare, 10 AS npp
                        )   
         , tmpParam AS (SELECT tmpParamAll.* 
                             , ROW_NUMBER() OVER (ORDER BY tmpParamAll.npp) AS Ord 
                        FROM tmpParamAll
                        WHERE tmpParamAll.CountTare <> 0 AND COALESCE (tmpParamAll.BoxId,0) <> 0
                          -- только поддоны
                          AND tmpParamAll.npp <= 2

                       UNION ALL
                        SELECT tmpParamAll.*
                             , 1 + ROW_NUMBER() OVER (ORDER BY tmpParamAll.npp) AS Ord
                        FROM tmpParamAll
                        WHERE tmpParamAll.CountTare <> 0 AND tmpParamAll.BoxId <> 0
                          -- без поддонов
                          AND tmpParamAll.npp > 2
                      )
         --- всегда 5 параметров если вдруг нужно что-то обнулить 
         , tmp AS (SELECT 0 AS BoxId, 0 AS CountTare, 1 AS npp 
         UNION ALL SELECT 0 AS BoxId, 0 AS CountTare, 2 AS npp
         UNION ALL SELECT 0 AS BoxId, 0 AS CountTare, 3 AS npp
         UNION ALL SELECT 0 AS BoxId, 0 AS CountTare, 4 AS npp
         UNION ALL SELECT 0 AS BoxId, 0 AS CountTare, 5 AS npp
                   )
         SELECT COALESCE (tmpParam.BoxId, tmp.BoxId)         AS BoxId
              , COALESCE (tmpParam.CountTare, tmp.CountTare) AS CountTare 
              , tmp.npp AS Ord 
         FROM tmp
              LEFT JOIN tmpParam ON tmpParam.Ord = tmp.npp
         ) AS tmp;
        
      -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.02.25         *
*/

-- тест
--