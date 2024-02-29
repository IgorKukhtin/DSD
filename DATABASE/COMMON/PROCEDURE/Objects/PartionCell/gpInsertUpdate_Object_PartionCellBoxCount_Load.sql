 -- Function: gpInsertUpdate_Object_PartionCellBoxCount_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PartionCellBoxCount_Load (TVarChar, TFloat, TVarChar, TFloat, TVarChar, TFloat, TVarChar, TFloat, TVarChar, TFloat, TVarChar, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PartionCellBoxCount_Load(
    IN inName_l1        TVarChar    , 
    IN inBoxCount_l1    TFloat      ,
    IN inName_l2        TVarChar    , 
    IN inBoxCount_l2    TFloat      ,
    IN inName_l3        TVarChar    ,
    IN inBoxCount_l3    TFloat      ,
    IN inName_l4        TVarChar    , 
    IN inBoxCount_l4    TFloat      ,
    IN inName_l5        TVarChar    , 
    IN inBoxCount_l5    TFloat      ,
    IN inName_l6        TVarChar    ,
    IN inBoxCount_l6    TFloat      ,
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionCellId Integer;
   
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

      /*
     -- !!!Пустой код - Пропустили!!!
     IF COALESCE (inName_l1, '') = '' THEN
        RETURN; -- !!!ВЫХОД!!!
     END IF;
      */
        
/*
R первый
L второй 
N третий
M четвертый 
O пятый 
K шестой
*/

     -- уровень 1  
     IF COALESCE (inName_l1, '') <> '' THEN
         -- !!!поиск ИД ячейки!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                                 INNER JOIN ObjectFloat AS ObjectFloat_Level
                                                        ON ObjectFloat_Level.ObjectId = Object.Id
                                                       AND ObjectFloat_Level.DescId = zc_ObjectFloat_PartionCell_Level()
                                                       AND ObjectFloat_Level.ValueData = CASE WHEN POSITION ( 'R-' in inName_l1) > 0 THEN 1
                                                                                              WHEN POSITION ( 'L-' in inName_l1) > 0 THEN 2
                                                                                              WHEN POSITION ( 'N-' in inName_l1) > 0 THEN 3
                                                                                              WHEN POSITION ( 'M-' in inName_l1) > 0 THEN 4
                                                                                              WHEN POSITION ( 'O-' in inName_l1) > 0 THEN 5
                                                                                              WHEN POSITION ( 'K-' in inName_l1) > 0 THEN 6
                                                                                         END
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inName_l1))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --если нет нужно записать новый элемент
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
            PERFORM gpInsertUpdate_Object_PartionCell( ioId          := 0 :: Integer
                                                     , inCode        := lfGet_ObjectCode(0, zc_Object_PartionCell()) :: Integer
                                                     , inName        := TRIM (inName_l1) :: TVarChar
                                                     , inLevel       := CASE WHEN POSITION ( 'R-' in inName_l1) > 0 THEN 1
                                                                             WHEN POSITION ( 'L-' in inName_l1) > 0 THEN 2
                                                                             WHEN POSITION ( 'N-' in inName_l1) > 0 THEN 3
                                                                             WHEN POSITION ( 'M-' in inName_l1) > 0 THEN 4
                                                                             WHEN POSITION ( 'O-' in inName_l1) > 0 THEN 5
                                                                             WHEN POSITION ( 'K-' in inName_l1) > 0 THEN 6
                                                                             ELSE 0
                                                                        END         :: TFloat
                                                     , inLength      := 0         :: TFloat
                                                     , inWidth       := 0         :: TFloat
                                                     , inHeight      := 0         :: TFloat
                                                     , inBoxCount    := inBoxCount_l1 :: TFloat
                                                     , inRowBoxCount := 0         :: TFloat
                                                     , inRowWidth    := 0         :: TFloat
                                                     , inRowHeight   := 0         :: TFloat
                                                     , inComment     := NULL      :: TVarChar
                                                     , inSession     := inSession :: TVarChar 
                                                     );
         --если есть записываем количество ящиков, 
         ELSE
             -- сохранили свойство <>
             PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_BoxCount(), vbPartionCellId, inBoxCount_l1);
         END IF;
         
     END IF;
     
     -- уровень 2  
     IF COALESCE (inName_l2, '') <> '' THEN
         -- !!!поиск ИД ячейки!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                                 INNER JOIN ObjectFloat AS ObjectFloat_Level
                                                        ON ObjectFloat_Level.ObjectId = Object.Id
                                                       AND ObjectFloat_Level.DescId = zc_ObjectFloat_PartionCell_Level()
                                                       AND ObjectFloat_Level.ValueData = CASE WHEN POSITION ( 'R-' in inName_l2) > 0 THEN 1
                                                                                              WHEN POSITION ( 'L-' in inName_l2) > 0 THEN 2
                                                                                              WHEN POSITION ( 'N-' in inName_l2) > 0 THEN 3
                                                                                              WHEN POSITION ( 'M-' in inName_l2) > 0 THEN 4
                                                                                              WHEN POSITION ( 'O-' in inName_l2) > 0 THEN 5
                                                                                              WHEN POSITION ( 'K-' in inName_l2) > 0 THEN 6
                                                                                         END
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inName_l2))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         -- если нет нужно записать новый элемент
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
            PERFORM gpInsertUpdate_Object_PartionCell( ioId          := 0 :: Integer
                                                     , inCode        := lfGet_ObjectCode(0, zc_Object_PartionCell()) :: Integer
                                                     , inName        := TRIM (inName_l2)   :: TVarChar
                                                     , inLevel       := CASE WHEN POSITION ( 'R-' in inName_l2) > 0 THEN 1
                                                                             WHEN POSITION ( 'L-' in inName_l2) > 0 THEN 2
                                                                             WHEN POSITION ( 'N-' in inName_l2) > 0 THEN 3
                                                                             WHEN POSITION ( 'M-' in inName_l2) > 0 THEN 4
                                                                             WHEN POSITION ( 'O-' in inName_l2) > 0 THEN 5
                                                                             WHEN POSITION ( 'K-' in inName_l2) > 0 THEN 6
                                                                             ELSE 0
                                                                        END         :: TFloat
                                                     , inLength      := 0         :: TFloat
                                                     , inWidth       := 0         :: TFloat
                                                     , inHeight      := 0         :: TFloat
                                                     , inBoxCount    := inBoxCount_l2      :: TFloat
                                                     , inRowBoxCount := 0         :: TFloat
                                                     , inRowWidth    := 0         :: TFloat
                                                     , inRowHeight   := 0         :: TFloat
                                                     , inComment     := NULL      :: TVarChar
                                                     , inSession     := inSession :: TVarChar
                                                     );
         --если есть записываем количество ящиков, 
         ELSE
             -- сохранили свойство <>
             PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_BoxCount(), vbPartionCellId, inBoxCount_l2); 
         END IF;
         
     END IF;

     -- уровень 3 
     IF COALESCE (inName_l3, '') <> '' THEN
         -- !!!поиск ИД ячейки!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                                 INNER JOIN ObjectFloat AS ObjectFloat_Level
                                                        ON ObjectFloat_Level.ObjectId = Object.Id
                                                       AND ObjectFloat_Level.DescId = zc_ObjectFloat_PartionCell_Level()
                                                       AND ObjectFloat_Level.ValueData = CASE WHEN POSITION ( 'R-' in inName_l3) > 0 THEN 1
                                                                                              WHEN POSITION ( 'L-' in inName_l3) > 0 THEN 2
                                                                                              WHEN POSITION ( 'N-' in inName_l3) > 0 THEN 3
                                                                                              WHEN POSITION ( 'M-' in inName_l3) > 0 THEN 4
                                                                                              WHEN POSITION ( 'O-' in inName_l3) > 0 THEN 5
                                                                                              WHEN POSITION ( 'K-' in inName_l3) > 0 THEN 6
                                                                                         END
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inName_l3))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --если нет нужно записать новый элемент
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
            PERFORM gpInsertUpdate_Object_PartionCell( ioId          := 0 :: Integer
                                                     , inCode        := lfGet_ObjectCode(0, zc_Object_PartionCell()) :: Integer
                                                     , inName        := TRIM (inName_l3)                      :: TVarChar
                                                     , inLevel       := CASE WHEN POSITION ( 'R-' in inName_l3) > 0 THEN 1
                                                                             WHEN POSITION ( 'L-' in inName_l3) > 0 THEN 2
                                                                             WHEN POSITION ( 'N-' in inName_l3) > 0 THEN 3
                                                                             WHEN POSITION ( 'M-' in inName_l3) > 0 THEN 4
                                                                             WHEN POSITION ( 'O-' in inName_l3) > 0 THEN 5
                                                                             WHEN POSITION ( 'K-' in inName_l3) > 0 THEN 6
                                                                             ELSE 0
                                                                        END         :: TFloat
                                                     , inLength      := 0         :: TFloat
                                                     , inWidth       := 0         :: TFloat
                                                     , inHeight      := 0         :: TFloat
                                                     , inBoxCount    := inBoxCount_l3 :: TFloat
                                                     , inRowBoxCount := 0         :: TFloat
                                                     , inRowWidth    := 0         :: TFloat
                                                     , inRowHeight   := 0         :: TFloat
                                                     , inComment     := NULL      :: TVarChar
                                                     , inSession     := inSession :: TVarChar
                                                     );
         --если есть записываем количество ящиков, 
         ELSE
             -- сохранили свойство <>
             PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_BoxCount(), vbPartionCellId, inBoxCount_l3); 
         END IF;
         
     END IF;

     -- уровень 4  
     IF COALESCE (inName_l4, '') <> '' THEN
         -- !!!поиск ИД ячейки!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                                 INNER JOIN ObjectFloat AS ObjectFloat_Level
                                                        ON ObjectFloat_Level.ObjectId = Object.Id
                                                       AND ObjectFloat_Level.DescId = zc_ObjectFloat_PartionCell_Level()
                                                       AND ObjectFloat_Level.ValueData = CASE WHEN POSITION ( 'R-' in inName_l4) > 0 THEN 1
                                                                                              WHEN POSITION ( 'L-' in inName_l4) > 0 THEN 2
                                                                                              WHEN POSITION ( 'N-' in inName_l4) > 0 THEN 3
                                                                                              WHEN POSITION ( 'M-' in inName_l4) > 0 THEN 4
                                                                                              WHEN POSITION ( 'O-' in inName_l4) > 0 THEN 5
                                                                                              WHEN POSITION ( 'K-' in inName_l4) > 0 THEN 6
                                                                                         END
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inName_l4))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --если нет нужно записать новый элемент
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
            PERFORM gpInsertUpdate_Object_PartionCell( ioId          := 0 :: Integer
                                                     , inCode        := lfGet_ObjectCode(0, zc_Object_PartionCell()) :: Integer
                                                     , inName        := TRIM (inName_l4)                      :: TVarChar
                                                     , inLevel       := CASE WHEN POSITION ( 'R-' in inName_l4) > 0 THEN 1
                                                                             WHEN POSITION ( 'L-' in inName_l4) > 0 THEN 2
                                                                             WHEN POSITION ( 'N-' in inName_l4) > 0 THEN 3
                                                                             WHEN POSITION ( 'M-' in inName_l4) > 0 THEN 4
                                                                             WHEN POSITION ( 'O-' in inName_l4) > 0 THEN 5
                                                                             WHEN POSITION ( 'K-' in inName_l4) > 0 THEN 6
                                                                             ELSE 0
                                                                        END         :: TFloat
                                                     , inLength      := 0         :: TFloat
                                                     , inWidth       := 0         :: TFloat
                                                     , inHeight      := 0         :: TFloat
                                                     , inBoxCount    := inBoxCount_l4 :: TFloat
                                                     , inRowBoxCount := 0         :: TFloat
                                                     , inRowWidth    := 0         :: TFloat
                                                     , inRowHeight   := 0         :: TFloat
                                                     , inComment     := NULL      :: TVarChar
                                                     , inSession     := inSession :: TVarChar
                                                     );
         --если есть записываем количество ящиков, 
         ELSE
             -- сохранили свойство <>
             PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_BoxCount(), vbPartionCellId, inBoxCount_l4); 
         END IF;
         
     END IF;


     -- уровень 5  
     IF COALESCE (inName_l5, '') <> '' THEN
         -- !!!поиск ИД ячейки!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                                 INNER JOIN ObjectFloat AS ObjectFloat_Level
                                                        ON ObjectFloat_Level.ObjectId = Object.Id
                                                       AND ObjectFloat_Level.DescId = zc_ObjectFloat_PartionCell_Level()
                                                       AND ObjectFloat_Level.ValueData = CASE WHEN POSITION ( 'R-' in inName_l5) > 0 THEN 1
                                                                                              WHEN POSITION ( 'L-' in inName_l5) > 0 THEN 2
                                                                                              WHEN POSITION ( 'N-' in inName_l5) > 0 THEN 3
                                                                                              WHEN POSITION ( 'M-' in inName_l5) > 0 THEN 4
                                                                                              WHEN POSITION ( 'O-' in inName_l5) > 0 THEN 5
                                                                                              WHEN POSITION ( 'K-' in inName_l5) > 0 THEN 6
                                                                                         END
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inName_l5))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --если нет нужно записать новый элемент
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
            PERFORM gpInsertUpdate_Object_PartionCell( ioId          := 0 :: Integer
                                                     , inCode        := lfGet_ObjectCode(0, zc_Object_PartionCell()) :: Integer
                                                     , inName        := TRIM (inName_l5)                      :: TVarChar
                                                     , inLevel       := CASE WHEN POSITION ( 'R-' in inName_l5) > 0 THEN 1
                                                                             WHEN POSITION ( 'L-' in inName_l5) > 0 THEN 2
                                                                             WHEN POSITION ( 'N-' in inName_l5) > 0 THEN 3
                                                                             WHEN POSITION ( 'M-' in inName_l5) > 0 THEN 4
                                                                             WHEN POSITION ( 'O-' in inName_l5) > 0 THEN 5
                                                                             WHEN POSITION ( 'K-' in inName_l5) > 0 THEN 6
                                                                             ELSE 0
                                                                        END         :: TFloat
                                                     , inLength      := 0         :: TFloat
                                                     , inWidth       := 0         :: TFloat
                                                     , inHeight      := 0         :: TFloat
                                                     , inBoxCount    := inBoxCount_l5 :: TFloat
                                                     , inRowBoxCount := 0         :: TFloat
                                                     , inRowWidth    := 0         :: TFloat
                                                     , inRowHeight   := 0         :: TFloat
                                                     , inComment     := NULL      :: TVarChar
                                                     , inSession     := inSession :: TVarChar 
                                                     );
         --если есть записываем количество ящиков, 
         ELSE
             -- сохранили свойство <>
             PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_BoxCount(), vbPartionCellId, inBoxCount_l5);
         END IF;
         
     END IF;

     -- уровень 6  
     IF COALESCE (inName_l6, '') <> '' THEN
         -- !!!поиск ИД ячейки!!!
         vbPartionCellId:= (SELECT Object.Id
                            FROM Object
                                 INNER JOIN ObjectFloat AS ObjectFloat_Level
                                                        ON ObjectFloat_Level.ObjectId = Object.Id
                                                       AND ObjectFloat_Level.DescId = zc_ObjectFloat_PartionCell_Level()
                                                       AND ObjectFloat_Level.ValueData = CASE WHEN POSITION ( 'R-' in inName_l6) > 0 THEN 1
                                                                                              WHEN POSITION ( 'L-' in inName_l6) > 0 THEN 2
                                                                                              WHEN POSITION ( 'N-' in inName_l6) > 0 THEN 3
                                                                                              WHEN POSITION ( 'M-' in inName_l6) > 0 THEN 4
                                                                                              WHEN POSITION ( 'O-' in inName_l6) > 0 THEN 5
                                                                                              WHEN POSITION ( 'K-' in inName_l6) > 0 THEN 6
                                                                                         END
                            WHERE UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inName_l6))
                              AND Object.DescId     = zc_Object_PartionCell()
                           );
         --если нет нужно записать новый элемент
         IF COALESCE (vbPartionCellId,0) = 0
         THEN
            PERFORM gpInsertUpdate_Object_PartionCell( ioId          := 0 :: Integer
                                                     , inCode        := lfGet_ObjectCode(0, zc_Object_PartionCell()) :: Integer
                                                     , inName        := TRIM (inName_l6)                      :: TVarChar
                                                     , inLevel       := CASE WHEN POSITION ( 'R-' in inName_l6) > 0 THEN 1
                                                                             WHEN POSITION ( 'L-' in inName_l6) > 0 THEN 2
                                                                             WHEN POSITION ( 'N-' in inName_l6) > 0 THEN 3
                                                                             WHEN POSITION ( 'M-' in inName_l6) > 0 THEN 4
                                                                             WHEN POSITION ( 'O-' in inName_l6) > 0 THEN 5
                                                                             WHEN POSITION ( 'K-' in inName_l6) > 0 THEN 6
                                                                             ELSE 0
                                                                        END         :: TFloat
                                                     , inLength      := 0         :: TFloat
                                                     , inWidth       := 0         :: TFloat
                                                     , inHeight      := 0         :: TFloat
                                                     , inBoxCount    := inBoxCount_l6 :: TFloat
                                                     , inRowBoxCount := 0         :: TFloat
                                                     , inRowWidth    := 0         :: TFloat
                                                     , inRowHeight   := 0         :: TFloat
                                                     , inComment     := NULL      :: TVarChar
                                                     , inSession     := inSession :: TVarChar 
                                                     );
         --если есть записываем количество ящиков, 
         ELSE
             -- сохранили свойство <>
             PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionCell_BoxCount(), vbPartionCellId, inBoxCount_l6);
         END IF;
         
     END IF;
     /*
     IF (vbUserId = 5 OR vbUserId = 9457) AND 1=1
     THEN
           RAISE EXCEPTION 'Ошибка.test=ok ';
     END IF;
     */

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.02.24         *
*/

-- тест
--

