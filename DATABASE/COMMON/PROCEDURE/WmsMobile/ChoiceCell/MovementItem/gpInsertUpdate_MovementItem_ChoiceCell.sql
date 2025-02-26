-- Function: gpInsertUpdate_MovementItem_ChoiceCell()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ChoiceCell (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ChoiceCell(
    IN inBarCode             TVarChar  , -- штрихкод яч. отбора
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbChoiceCellId Integer;
   DECLARE vbMovementId   Integer;
   DECLARE vbOperDate     TDateTime;

   DECLARE vbGoodsId     Integer;
   DECLARE vbGoodsKindId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ChoiceCell());
     vbUserId:= lpGetUserBySession (inSession);

     -- если надо найти
     IF COALESCE (inBarCode,'') <> ''
     THEN
         -- по коду
         IF CHAR_LENGTH (inBarCode) < 12
         THEN vbChoiceCellId:= (SELECT Object.Id
                                FROM (SELECT zfConvert_StringToNumber (inBarCode) AS ObjectCode
                                     ) AS tmp
                                      INNER JOIN Object ON Object.ObjectCode = tmp.ObjectCode
                                                       AND Object.DescId = zc_Object_ChoiceCell()
                                                       AND Object.isErased = FALSE
                                WHERE tmp.ObjectCode > 0
                                );

         -- по штрих коду
         ELSEIF CHAR_LENGTH (inBarCode) = 12
         THEN
              vbChoiceCellId:= (SELECT Object.Id
                                FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS ObjectId
                                     ) AS tmp
                                      INNER JOIN Object ON Object.Id = tmp.ObjectId
                                                       AND Object.DescId = zc_Object_ChoiceCell()
                                                       AND Object.isErased = FALSE
                                );
         END IF;

     END IF;


     -- Проверка
     IF COALESCE (vbChoiceCellId, 0) = 0
     THEN
        --
         RAISE EXCEPTION 'Ошибка.Ячейка отбора с % <%> не найдена.'
                        , CASE WHEN CHAR_LENGTH (inBarCode) < 12 THEN 'кодом' ELSE 'штрихкодом' END
                        , inBarCode;
     END IF;


     -- Какой товар назначен для этой ячейки отбора
     SELECT COALESCE (ObjectLink_Goods.ChildObjectId, 0)       AS GoodsId
          , COALESCE (ObjectLink_GoodsKind.ChildObjectId, 0)   AS GoodsKindId
            INTO vbGoodsId, vbGoodsKindId
     FROM ObjectLink AS ObjectLink_Goods
          LEFT JOIN ObjectLink AS ObjectLink_GoodsKind
                               ON ObjectLink_GoodsKind.ObjectId = ObjectLink_Goods.ObjectId
                              AND ObjectLink_GoodsKind.DescId = zc_ObjectLink_ChoiceCell_GoodsKind()
     WHERE ObjectLink_Goods.ObjectId = vbChoiceCellId
       AND ObjectLink_Goods.DescId   = zc_ObjectLink_ChoiceCell_Goods()
    ;

     -- Дата в зависимости от смены
     vbOperDate:= gpGet_Scale_OperDate (inIsCeh:= FALSE, inBranchCode:= 1, inSession:= inSession);

     -- Проверка
     IF 1 < (SELECT COUNT(*) FROM Movement WHERE Movement.DescId = zc_Movement_ChoiceCell() AND Movement.OperDate = vbOperDate AND Movement.StatusId <> zc_Enum_Status_Erased())
     THEN
         --
         RAISE EXCEPTION 'Ошибка.Найдено несколько документов <%> за <%>.Лишний можно удалить.'
                       , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_ChoiceCell())
                       , vbOperDate
                        ;
     END IF;


     -- пробуем найти документ
     vbMovementId:= (SELECT Movement.Id FROM Movement WHERE Movement.DescId = zc_Movement_ChoiceCell() AND Movement.OperDate = vbOperDate AND Movement.StatusId <> zc_Enum_Status_Erased());


     IF COALESCE (vbMovementId,0) = 0
     THEN
         vbMovementId := lpInsertUpdate_Movement_ChoiceCell (ioId          := 0
                                                           , inInvNumber   := CAST (NEXTVAL ('movement_ChoiceCell_seq') AS TVarChar)
                                                           , inOperDate    := vbOperDate
                                                           , inUserId      := vbUserId
                                                            )AS tmp;
     END IF;


    -- сохранили
    PERFORM lpInsertUpdate_MovementItem_ChoiceCell (ioId                     := 0
                                                  , inMovementId             := vbMovementId
                                                  , inChoiceCellId           := tmp.ChoiceCellId
                                                  , inGoodsId                := vbGoodsId
                                                  , inGoodsKindId            := vbGoodsKindId
                                                  , inPartionGoodsDate       := tmp.PartionGoodsDate
                                                  , inPartionGoodsDate_next  := tmp.PartionGoodsDate_next
                                                  , inUserId                 := vbUserId
                                                   )
           FROM (WITH -- ВСЕ заполненные места хранения - ячейки + ячейка "Отбор"
                      tmpPartionCell_mi AS (SELECT DISTINCT lpSelect.PartionCellId, lpSelect.GoodsId, lpSelect.GoodsKindId, lpSelect.PartionGoodsDate
                                            FROM lpSelect_Object_PartionCell_mi (inGoodsId:= vbGoodsId, inGoodsKindId:= vbGoodsKindId) AS lpSelect
                                           )
                      -- найдем последнюю партию в ячейка "Отбор"
                    , tmpPartionCell_RK AS (SELECT tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.PartionGoodsDate
                                                   -- № п/п
                                                 , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.PartionGoodsDate DESC) AS Ord
                                            FROM tmpPartionCell_mi AS tmpMI
                                            -- партия = ячейка "Отбор"
                                            WHERE tmpMI.PartionCellId = zc_PartionCell_RK()
                                           )
                   -- найдем первую партию в ячейке Хранения
                 ,  tmpPartionCell_real AS (SELECT tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.PartionGoodsDate
                                                   -- № п/п
                                                 , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.PartionGoodsDate ASC) AS Ord
                                            FROM tmpPartionCell_mi AS tmpMI
                                            -- партия = ячейке Хранения
                                            WHERE tmpMI.PartionCellId <> zc_PartionCell_RK()
                                           )
              -- Результат
              SELECT
                     Object_ChoiceCell.Id                   AS ChoiceCellId
                     -- последняя партия в ячейка "Отбор"
                   , tmpPartionCell_RK.PartionGoodsDate   :: TDateTime AS PartionGoodsDate
                     -- первая партия в ячейке Хранения
                   , tmpPartionCell_real.PartionGoodsDate :: TDateTime AS PartionGoodsDate_next

                   , (zfFormat_BarCode (zc_BarCodePref_Object(), Object_ChoiceCell.Id)) ::TVarChar AS idBarCode

                   , Object_ChoiceCell.isErased      AS isErased

              FROM Object AS Object_ChoiceCell
                   -- последняя партия в ячейка "Отбор"
                   LEFT JOIN tmpPartionCell_RK ON tmpPartionCell_RK.GoodsId     = vbGoodsId
                                              AND tmpPartionCell_RK.GoodsKindId = vbGoodsKindId
                                              AND tmpPartionCell_RK.ord         = 1
                   -- первая партия в ячейке Хранения
                   LEFT JOIN tmpPartionCell_real ON tmpPartionCell_real.GoodsId     = vbGoodsId
                                                AND tmpPartionCell_real.GoodsKindId = vbGoodsKindId
                                                AND tmpPartionCell_real.ord         = 1

              WHERE Object_ChoiceCell.DescId = zc_Object_ChoiceCell()
                AND Object_ChoiceCell.Id     = vbChoiceCellId
             ) AS tmp
    ;

IF vbUserId = 5 AND 1=1
THEN
    RAISE EXCEPTION 'Ошибка.OK (%)', vbGoodsId;
END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.08.24         *
*/

-- тест
--      "  201011041653    "  --SELECT * FROM gpSelect_Object_ChoiceCell (FALSE, zfCalc_UserAdmin())

